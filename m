From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/7 v2] BNX2I: Fine tuned conn destroy and context
 destroy timeout values
Date: Thu, 1 Jul 2010 15:34:53 -0700
Message-ID: <1278023696-17817-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhDTr7ThBBoExhFSIg-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Added variables to separate the fine tuned timeout values for
connection destroy and context destroy for both 1g and 10g devices.

v2: Extended the 5771X disconnect timeout from 10s to 20s as the firmware
has a retransmission timeout of 16s.  This fixes one of the iscsi_endpoint
leak issues when the target is slow or non-responsive to our TCP FIN.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
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
index 1600e7c..f6eebb3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -854,10 +854,15 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	spin_lock_init(&hba->lock);
 	mutex_init(&hba->net_dev_lock);
 	init_waitqueue_head(&hba->eh_wait);
-	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type))
+	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type)) {
 		hba->hba_shutdown_tmo = 20 * HZ;
-	else	/* 5706/5708/5709 */
+		hba->conn_teardown_tmo = 20 * HZ;
+		hba->conn_ctx_destroy_tmo = 6 * HZ;
+	} else {	/* 5706/5708/5709 */
 		hba->hba_shutdown_tmo = 20 * HZ;
+		hba->conn_teardown_tmo = 10 * HZ;
+		hba->conn_ctx_destroy_tmo = 2 * HZ;
+	}
 
 	if (iscsi_host_add(shost, &hba->pcidev->dev))
 		goto free_dump_mem;
@@ -1633,7 +1638,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 
 	ep->state = EP_STATE_CLEANUP_START;
 	init_timer(&ep->ofld_timer);
-	ep->ofld_timer.expires = 10*HZ + jiffies;
+	ep->ofld_timer.expires = hba->conn_ctx_destroy_tmo + jiffies;
 	ep->ofld_timer.function = bnx2i_ep_ofld_timer;
 	ep->ofld_timer.data = (unsigned long) ep;
 	add_timer(&ep->ofld_timer);
@@ -1937,7 +1942,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	bnx2i_ep->state = EP_STATE_DISCONN_START;
 
 	init_timer(&bnx2i_ep->ofld_timer);
-	bnx2i_ep->ofld_timer.expires = 10*HZ + jiffies;
+	bnx2i_ep->ofld_timer.expires = hba->conn_teardown_tmo + jiffies;
 	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
 	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
-- 
1.7.0.5


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
