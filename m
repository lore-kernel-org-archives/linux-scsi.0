From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 4/5 v2] BNX2I: Added chip cleanup for the remove module
 path
Date: Thu, 12 Aug 2010 16:44:30 -0700
Message-ID: <1281656671-5369-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2290 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab0HLXmr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 19:42:47 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

In the case when an ep_connect request is interrupted due to route
request stall, if the iSCSI daemon is terminated by the user, the chip
will be left in a state which will not get cleaned up upon module
removal.  Upon module reload, when the same context id is used for a
new connection, chip panic would occur.

This patch adds chip cleanup in the module removal path.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c  |   54 ++++++++++++++++++++++++--------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 ++
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index a796f56..1294936 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -167,6 +167,38 @@ void bnx2i_start(void *handle)
 
 
 /**
+ * bnx2i_chip_cleanup - local routine to handle chip cleanup
+ * @hba:	Adapter instance to register
+ *
+ * Driver checks if adapter still has any active connections before
+ *	executing the cleanup process
+ */
+static void bnx2i_chip_cleanup(struct bnx2i_hba *hba)
+{
+	struct bnx2i_endpoint *bnx2i_ep;
+	struct list_head *pos, *tmp;
+
+	if (hba->ofld_conns_active) {
+		/* Stage to force the disconnection
+		 * This is the case where the daemon is either slow or
+		 * not present
+		 */
+		printk(KERN_ALERT "bnx2i: (%s) chip cleanup for %d active "
+			"connections\n", hba->netdev->name,
+			hba->ofld_conns_active);
+		mutex_lock(&hba->net_dev_lock);
+		list_for_each_safe(pos, tmp, &hba->ep_active_list) {
+			bnx2i_ep = list_entry(pos, struct bnx2i_endpoint, link);
+			/* Clean up the chip only */
+			bnx2i_hw_ep_disconnect(bnx2i_ep);
+			bnx2i_ep->cm_sk = NULL;
+		}
+		mutex_unlock(&hba->net_dev_lock);
+	}
+}
+
+
+/**
  * bnx2i_stop - cnic callback to shutdown adapter instance
  * @handle:	transparent handle pointing to adapter structure
  *
@@ -176,8 +208,6 @@ void bnx2i_start(void *handle)
 void bnx2i_stop(void *handle)
 {
 	struct bnx2i_hba *hba = handle;
-	struct list_head *pos, *tmp;
-	struct bnx2i_endpoint *bnx2i_ep;
 	int conns_active;
 
 	/* check if cleanup happened in GOING_DOWN context */
@@ -198,24 +228,7 @@ void bnx2i_stop(void *handle)
 		if (hba->ofld_conns_active == conns_active)
 			break;
 	}
-	if (hba->ofld_conns_active) {
-		/* Stage to force the disconnection
-		 * This is the case where the daemon is either slow or
-		 * not present
-		 */
-		printk(KERN_ALERT "bnx2i: Wait timeout, force all eps "
-			"to disconnect (%d)\n", hba->ofld_conns_active);
-		mutex_lock(&hba->net_dev_lock);
-		list_for_each_safe(pos, tmp, &hba->ep_active_list) {
-			bnx2i_ep = list_entry(pos, struct bnx2i_endpoint, link);
-			/* Clean up the chip only */
-			bnx2i_hw_ep_disconnect(bnx2i_ep);
-		}
-		mutex_unlock(&hba->net_dev_lock);
-		if (hba->ofld_conns_active)
-			printk(KERN_ERR "bnx2i: EP disconnect timeout (%d)!\n",
-				hba->ofld_conns_active);
-	}
+	bnx2i_chip_cleanup(hba);
 
 	/* This flag should be cleared last so that ep_disconnect() gracefully
 	 * cleans up connection context
@@ -457,6 +470,7 @@ static void __exit bnx2i_mod_exit(void)
 		adapter_count--;
 
 		if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
+			bnx2i_chip_cleanup(hba);
 			hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
 			clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
 		}
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 40f3758..abe73b9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1953,6 +1953,9 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	if (!cnic)
 		return 0;
 
+	if (bnx2i_ep->state == EP_STATE_IDLE)
+		return 0;
+
 	if (!bnx2i_ep_tcp_conn_active(bnx2i_ep))
 		goto destroy_conn;
 
-- 
1.7.0.5


