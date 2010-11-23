From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v3 04/13] BNX2I: Fixed a cid leak issue for 5771X (10g)
Date: Tue, 23 Nov 2010 15:29:23 -0800
Message-ID: <1290554972-16928-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1088 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0KWX1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 18:27:36 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

A cid leak issue was found when the connect destroy request exceeded
the driver's disconnection timeout.  This will lead to a cid resource
leak issue.
The fix is to allow the cid cleanup even when this happens.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fb50efb..b766812 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1640,18 +1640,26 @@ no_nx2_route:
 static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 				 struct bnx2i_endpoint *ep)
 {
-	if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic))
+	if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic) && ep->cm_sk)
 		hba->cnic->cm_destroy(ep->cm_sk);
 
-	if (test_bit(ADAPTER_STATE_GOING_DOWN, &ep->hba->adapter_state))
-		ep->state = EP_STATE_DISCONN_COMPL;
-
 	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type) &&
 	    ep->state == EP_STATE_DISCONN_TIMEDOUT) {
-		printk(KERN_ALERT "bnx2i - ERROR - please submit GRC Dump,"
-				  " NW/PCIe trace, driver msgs to developers"
-				  " for analysis\n");
-		return 1;
+		if (ep->conn && ep->conn->cls_conn &&
+		    ep->conn->cls_conn->dd_data) {
+			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
+
+			/* Must suspend all rx queue activity for this ep */
+			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+		}
+		/* CONN_DISCONNECT timeout may or may not be an issue depending
+		 * on what transcribed in TCP layer, different targets behave
+		 * differently
+		 */
+		printk(KERN_ALERT "bnx2i (%s): - WARN - CONN_DISCON timed out, "
+				  "please submit GRC Dump, NW/PCIe trace, "
+				  "driver msgs to developers for analysis\n",
+				  hba->netdev->name);
 	}
 
 	ep->state = EP_STATE_CLEANUP_START;
-- 
1.7.0.5


