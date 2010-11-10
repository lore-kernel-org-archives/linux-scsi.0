From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 10/16] BNX2I: Fixed a cid leak issue for 5771X (10g)
Date: Wed, 10 Nov 2010 15:04:51 -0800
Message-ID: <1289430297-30221-11-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhCtyezmBBoE6Qaq7Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

A cid leak issue was found when the connect destroy request exceeded
the driver's disconnection timeout.  This will lead to a cid resource
leak issue.
The fix is to allow the cid cleanup even when this happens.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 58515ee..dd18717 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1659,18 +1659,26 @@ no_nx2_route:
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


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
