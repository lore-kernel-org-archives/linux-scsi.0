From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: PATCH] BNX2I : Bug fixes related to MTU change issue when there
 are active iscsi sessions
Date: Thu, 8 Apr 2010 14:16:12 -0700
Message-ID: <1270761372.28522.109699.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3743 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701Ab0DHVP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2010 17:15:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, "Mike C." <michaelc@cs.wisc.edu>
Cc: linux scsi <linux-scsi@vger.kernel.org>, open-iscsi-ml <open-iscsi@googlegroups.com>

James,
   This patch is made against scsi-misc from this morning. Please apply.

Thanks,
Anil



 	* bnx2i driver has to wait and cleanup all iscsi endpoints before
 	  returning from bnx2i_stop(). This is to make sure all chip
 	  resources are freed before chip is reset.
 	* As the requirements for 1G and 10G chipsets are different, added
 	  per-device 'hba_shutdown_tmo' parameter to the adapter structure
 	* If the connections are not torn down by the daemon within this
 	  timeout period, 'cid's will be leaked in 10G device. 1G devices
 	  are more flexible and do not leak any resources because the whole
 	  chip ports gets reset when MTU is changed or ethtool selftest is
 	  run
 	* fixed a minor issue in bnx2i_ep_poll() which unnecessarily forced
 	  error return code when driver timed out waiting for TCP connect
 	  request to complete. This was also discovered while debugging
	  MTU change issue

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    2 ++
 drivers/scsi/bnx2i/bnx2i_init.c  |   13 ++++++++++++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   11 ++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 6cf9dc3..6b624e7 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -362,6 +362,7 @@ struct bnx2i_hba {
 	u32 num_ccell;
 
 	int ofld_conns_active;
+	wait_queue_head_t eh_wait;
 
 	int max_active_conns;
 	struct iscsi_cid_queue cid_que;
@@ -381,6 +382,7 @@ struct bnx2i_hba {
 	spinlock_t lock;	/* protects hba structure access */
 	struct mutex net_dev_lock;/* sync net device access */
 
+	int hba_shutdown_tmo;
 	/*
 	 * PCI related info.
 	 */
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 6d8172e..5d9296c 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -177,11 +177,22 @@ void bnx2i_stop(void *handle)
 	struct bnx2i_hba *hba = handle;
 
 	/* check if cleanup happened in GOING_DOWN context */
-	clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
 	if (!test_and_clear_bit(ADAPTER_STATE_GOING_DOWN,
 				&hba->adapter_state))
 		iscsi_host_for_each_session(hba->shost,
 					    bnx2i_drop_session);
+
+	/* Wait for all endpoints to be torn down, Chip will be reset once
+	 *  control returns to network driver. So it is required to cleanup and
+	 * release all connection resources before returning from this routine.
+	 */
+	wait_event_interruptible_timeout(hba->eh_wait,
+					 (hba->ofld_conns_active == 0),
+					 hba->hba_shutdown_tmo);
+	/* This flag should be cleared last so that ep_disconnect() gracefully
+	 * cleans up connection context
+	 */
+	clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
 }
 
 /**
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index cb71dc9..974dfb6 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -819,6 +819,11 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 
 	spin_lock_init(&hba->lock);
 	mutex_init(&hba->net_dev_lock);
+	init_waitqueue_head(&hba->eh_wait);
+	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type))
+		hba->hba_shutdown_tmo = 240 * HZ;
+	else	/* 5706/5708/5709 */
+		hba->hba_shutdown_tmo = 30 * HZ;
 
 	if (iscsi_host_add(shost, &hba->pcidev->dev))
 		goto free_dump_mem;
@@ -1657,8 +1662,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 		 */
 		hba = bnx2i_check_route(dst_addr);
 
-	if (!hba) {
-		rc = -ENOMEM;
+	if (!hba || test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state)) {
+		rc = -EINVAL;
 		goto check_busy;
 	}
 
@@ -1803,7 +1808,7 @@ static int bnx2i_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 					       (bnx2i_ep->state ==
 						EP_STATE_CONNECT_COMPL)),
 					      msecs_to_jiffies(timeout_ms));
-	if (!rc || (bnx2i_ep->state == EP_STATE_OFLD_FAILED))
+	if (bnx2i_ep->state == EP_STATE_OFLD_FAILED)
 		rc = -1;
 
 	if (rc > 0)
-- 
1.6.5.1




