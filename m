From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 3/7 v2] BNX2I: Optimized the bnx2i_stop connection clean
 up procedure
Date: Thu, 1 Jul 2010 15:34:52 -0700
Message-ID: <1278023696-17817-4-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2238 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab0GAWdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 18:33:54 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

For cases where the iSCSI disconnection procedure times out due to
the iSCSI daemon being slow or unresponsive, the bnx2i_stop routine
will now perform hardware cleanup via bnx2i_hw_ep_disconnect on all
active endpoints so that subsequent operations will perform properly.
Also moved the mutex locks inside ep_connect and ep_disconnect so
that proper exclusivity can resolve simultaneous calls to the
ep_disconnect routine.

v2: Removed the unnecessary read lock in the bnx2i_stop

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    4 ++++
 drivers/scsi/bnx2i/bnx2i_init.c  |   33 ++++++++++++++++++++++++++++++---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   12 ++++++------
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index c17c3a3..fed1a68 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -295,6 +295,7 @@ struct iscsi_cid_queue {
  * @max_cqes:              CQ size
  * @num_ccell:             number of command cells per connection
  * @ofld_conns_active:     active connection list
+ * @eh_wait:               wait queue for the endpoint to shutdown
  * @max_active_conns:      max offload connections supported by this device
  * @cid_que:               iscsi cid queue
  * @ep_rdwr_lock:          read / write lock to synchronize various ep lists
@@ -306,6 +307,7 @@ struct iscsi_cid_queue {
  * @dummy_buffer:          Dummy buffer to be used with zero length scsicmd reqs
  * @dummy_buf_dma:         DMA address of 'dummy_buffer' memory buffer
  * @lock:              	   lock to synchonize access to hba structure
+ * @hba_shutdown_tmo:      Timeout value to shutdown each connection
  * @pci_did:               PCI device ID
  * @pci_vid:               PCI vendor ID
  * @pci_sdid:              PCI subsystem device ID
@@ -770,6 +772,8 @@ extern struct bnx2i_endpoint *bnx2i_find_ep_in_destroy_list(
 extern int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep);
 extern void bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action);
 
+extern int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep);
+
 /* Debug related function prototypes */
 extern void bnx2i_print_pend_cmd_queue(struct bnx2i_conn *conn);
 extern void bnx2i_print_active_cmd_queue(struct bnx2i_conn *conn);
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index af6a00a..f0f8361 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -176,6 +176,9 @@ void bnx2i_start(void *handle)
 void bnx2i_stop(void *handle)
 {
 	struct bnx2i_hba *hba = handle;
+	struct list_head *pos, *tmp;
+	struct bnx2i_endpoint *bnx2i_ep;
+	int conns_active;
 
 	/* check if cleanup happened in GOING_DOWN context */
 	if (!test_and_clear_bit(ADAPTER_STATE_GOING_DOWN,
@@ -187,9 +190,33 @@ void bnx2i_stop(void *handle)
 	 *  control returns to network driver. So it is required to cleanup and
 	 * release all connection resources before returning from this routine.
 	 */
-	wait_event_interruptible_timeout(hba->eh_wait,
-					 (hba->ofld_conns_active == 0),
-					 hba->hba_shutdown_tmo);
+	while (hba->ofld_conns_active) {
+		conns_active = hba->ofld_conns_active;
+		wait_event_interruptible_timeout(hba->eh_wait,
+				(hba->ofld_conns_active != conns_active),
+				hba->hba_shutdown_tmo);
+		if (hba->ofld_conns_active == conns_active)
+			break;
+	}
+	if (hba->ofld_conns_active) {
+		/* Stage to force the disconnection
+		 * This is the case where the daemon is either slow or
+		 * not present
+		 */
+		printk(KERN_ALERT "bnx2i: Wait timeout, force all eps "
+			"to disconnect (%d)\n", hba->ofld_conns_active);
+		mutex_lock(&hba->net_dev_lock);
+		list_for_each_safe(pos, tmp, &hba->ep_active_list) {
+			bnx2i_ep = list_entry(pos, struct bnx2i_endpoint, link);
+			/* Clean up the chip only */
+			bnx2i_hw_ep_disconnect(bnx2i_ep);
+		}
+		mutex_unlock(&hba->net_dev_lock);
+		if (hba->ofld_conns_active)
+			printk(KERN_ERR "bnx2i: EP disconnect timeout (%d)!\n",
+				hba->ofld_conns_active);
+	}
+
 	/* This flag should be cleared last so that ep_disconnect() gracefully
 	 * cleans up connection context
 	 */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fb5fe88..1600e7c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -708,7 +708,6 @@ bnx2i_find_ep_in_destroy_list(struct bnx2i_hba *hba, u32 iscsi_cid)
 	return ep;
 }
 
-
 /**
  * bnx2i_ep_active_list_add - add an entry to ep active list
  * @hba:	pointer to adapter instance
@@ -856,9 +855,9 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	mutex_init(&hba->net_dev_lock);
 	init_waitqueue_head(&hba->eh_wait);
 	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type))
-		hba->hba_shutdown_tmo = 240 * HZ;
+		hba->hba_shutdown_tmo = 20 * HZ;
 	else	/* 5706/5708/5709 */
-		hba->hba_shutdown_tmo = 30 * HZ;
+		hba->hba_shutdown_tmo = 20 * HZ;
 
 	if (iscsi_host_add(shost, &hba->pcidev->dev))
 		goto free_dump_mem;
@@ -1700,10 +1699,11 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 
 	if (!hba || test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state)) {
 		rc = -EINVAL;
-		goto check_busy;
+		goto nohba;
 	}
 
 	cnic = hba->cnic;
+	mutex_lock(&hba->net_dev_lock);
 	ep = bnx2i_alloc_ep(hba);
 	if (!ep) {
 		rc = -ENOMEM;
@@ -1711,7 +1711,6 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	}
 	bnx2i_ep = ep->dd_data;
 
-	mutex_lock(&hba->net_dev_lock);
 	if (bnx2i_adapter_ready(hba)) {
 		rc = -EPERM;
 		goto net_if_down;
@@ -1813,8 +1812,9 @@ iscsi_cid_err:
 	bnx2i_free_qp_resc(hba, bnx2i_ep);
 qp_resc_err:
 	bnx2i_free_ep(ep);
-	mutex_unlock(&hba->net_dev_lock);
 check_busy:
+	mutex_unlock(&hba->net_dev_lock);
+nohba:
 	bnx2i_unreg_dev_all();
 	return ERR_PTR(rc);
 }
-- 
1.7.0.5


