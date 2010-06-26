From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 4/7] BNX2I: Fine tuned conn destroy and context destroy
 timeout values
Date: Fri, 25 Jun 2010 18:39:29 -0700
Message-ID: <1277516372-469-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4314 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab0FZBip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2010 21:38:45 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Added variables to separate the fine tuned timeout values for
connection destroy and context destroy for both 1g and 10g devices.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    4 ++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   13 +++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index fed1a68..69febb6 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -308,6 +308,8 @@ struct iscsi_cid_queue {
  * @dummy_buf_dma:         DMA address of 'dummy_buffer' memory buffer
  * @lock:              	   lock to synchonize access to hba structure
  * @hba_shutdown_tmo:      Timeout value to shutdown each connection
+ * @conn_teardown_tmo:     Timeout value to tear down each connection
+ * @conn_ctx_destroy_tmo:  Timeout value to destroy context of each connection
  * @pci_did:               PCI device ID
  * @pci_vid:               PCI vendor ID
  * @pci_sdid:              PCI subsystem device ID
@@ -387,6 +389,8 @@ struct bnx2i_hba {
 	struct mutex net_dev_lock;/* sync net device access */
 
 	int hba_shutdown_tmo;
+	int conn_teardown_tmo;
+	int conn_ctx_destroy_tmo;
 	/*
 	 * PCI related info.
 	 */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a6ee72e..f8394d4 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -857,10 +857,15 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	spin_lock_init(&hba->lock);
 	mutex_init(&hba->net_dev_lock);
 	init_waitqueue_head(&hba->eh_wait);
-	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type))
+	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type)) {
 		hba->hba_shutdown_tmo = 20 * HZ;
-	else	/* 5706/5708/5709 */
+		hba->conn_teardown_tmo = 10 * HZ;
+		hba->conn_ctx_destroy_tmo = 6 * HZ;
+	} else {	/* 5706/5708/5709 */
 		hba->hba_shutdown_tmo = 20 * HZ;
+		hba->conn_teardown_tmo = 10 * HZ;
+		hba->conn_ctx_destroy_tmo = 2 * HZ;
+	}
 
 	if (iscsi_host_add(shost, &hba->pcidev->dev))
 		goto free_dump_mem;
@@ -1636,7 +1641,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 
 	ep->state = EP_STATE_CLEANUP_START;
 	init_timer(&ep->ofld_timer);
-	ep->ofld_timer.expires = 10*HZ + jiffies;
+	ep->ofld_timer.expires = hba->conn_ctx_destroy_tmo + jiffies;
 	ep->ofld_timer.function = bnx2i_ep_ofld_timer;
 	ep->ofld_timer.data = (unsigned long) ep;
 	add_timer(&ep->ofld_timer);
@@ -1939,7 +1944,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	bnx2i_ep->state = EP_STATE_DISCONN_START;
 
 	init_timer(&bnx2i_ep->ofld_timer);
-	bnx2i_ep->ofld_timer.expires = 10*HZ + jiffies;
+	bnx2i_ep->ofld_timer.expires = hba->conn_teardown_tmo + jiffies;
 	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
 	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
-- 
1.7.0.5


