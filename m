From: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH] cxgb4i: Use cxgb4_select_ntuple to correctly calculate
 ntuple fields
Date: Tue, 28 Jan 2014 17:01:37 -0800
Message-ID: <201401290101.s0T11brL026639@localhost6.localdomain6>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBDN4XE6H5QHRBN5HUGLQKGQEBFINCEA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

[PATCH] cxgb4i: Use cxgb4_select_ntuple to correctly calculate ntuple fields

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Fixed calculates wrong tuple values on T5 adapter: switch to use the exported API cxgb4_select_ntuple() from cxgb4 base driver.

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   59 ++++--------------------------------
 1 files changed, 7 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 5a9f842..e8ee5e5 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -175,52 +175,6 @@ static inline int is_ofld_imm(const struct sk_buff *skb)
 			sizeof(struct fw_ofld_tx_data_wr));
 }
 
-
-#define VLAN_NONE 0xfff
-#define FILTER_SEL_VLAN_NONE 0xffff
-#define FILTER_SEL_WIDTH_P_FC (3+1) /* port uses 3 bits, FCoE one bit */
-#define FILTER_SEL_WIDTH_VIN_P_FC \
-	(6 + 7 + FILTER_SEL_WIDTH_P_FC) /* 6 bits are unused, VF uses 7 bits*/
-#define FILTER_SEL_WIDTH_TAG_P_FC \
-	(3 + FILTER_SEL_WIDTH_VIN_P_FC) /* PF uses 3 bits */
-#define FILTER_SEL_WIDTH_VLD_TAG_P_FC (1 + FILTER_SEL_WIDTH_TAG_P_FC)
-
-static unsigned int select_ntuple(struct cxgbi_device *cdev,
-				struct l2t_entry *l2t)
-{
-	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(cdev);
-	unsigned int ntuple = 0;
-	u32 viid;
-
-	switch (lldi->filt_mode) {
-
-	/* default filter mode */
-	case HW_TPL_FR_MT_PR_IV_P_FC:
-		if (l2t->vlan == VLAN_NONE)
-			ntuple |= FILTER_SEL_VLAN_NONE << FILTER_SEL_WIDTH_P_FC;
-		else {
-			ntuple |= l2t->vlan << FILTER_SEL_WIDTH_P_FC;
-			ntuple |= 1 << FILTER_SEL_WIDTH_VLD_TAG_P_FC;
-		}
-		ntuple |= l2t->lport << S_PORT | IPPROTO_TCP <<
-			  FILTER_SEL_WIDTH_VLD_TAG_P_FC;
-		break;
-	case HW_TPL_FR_MT_PR_OV_P_FC: {
-		viid = cxgb4_port_viid(l2t->neigh->dev);
-
-		ntuple |= FW_VIID_VIN_GET(viid) << FILTER_SEL_WIDTH_P_FC;
-		ntuple |= FW_VIID_PFN_GET(viid) << FILTER_SEL_WIDTH_VIN_P_FC;
-		ntuple |= FW_VIID_VIVLD_GET(viid) << FILTER_SEL_WIDTH_TAG_P_FC;
-		ntuple |= l2t->lport << S_PORT | IPPROTO_TCP <<
-			  FILTER_SEL_WIDTH_VLD_TAG_P_FC;
-		break;
-	}
-	default:
-		break;
-	}
-	return ntuple;
-}
-
 static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 				struct l2t_entry *e)
 {
@@ -248,8 +202,6 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		struct cpl_act_open_req *req =
 				(struct cpl_act_open_req *)skb->head;
 
-		req = (struct cpl_act_open_req *)skb->head;
-
 		INIT_TP_WR(req, 0);
 		OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
 					qid_atid));
@@ -258,7 +210,9 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		req->local_ip = csk->saddr.sin_addr.s_addr;
 		req->peer_ip = csk->daddr.sin_addr.s_addr;
 		req->opt0 = cpu_to_be64(opt0);
-		req->params = cpu_to_be32(select_ntuple(csk->cdev, csk->l2t));
+		req->params = cpu_to_be32(cxgb4_select_ntuple(
+					csk->cdev->ports[csk->port_id],
+					csk->l2t));
 		opt2 |= 1 << 22;
 		req->opt2 = cpu_to_be32(opt2);
 
@@ -271,8 +225,6 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		struct cpl_t5_act_open_req *req =
 				(struct cpl_t5_act_open_req *)skb->head;
 
-		req = (struct cpl_t5_act_open_req *)skb->head;
-
 		INIT_TP_WR(req, 0);
 		OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
 					qid_atid));
@@ -281,7 +233,10 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		req->local_ip = csk->saddr.sin_addr.s_addr;
 		req->peer_ip = csk->daddr.sin_addr.s_addr;
 		req->opt0 = cpu_to_be64(opt0);
-		req->params = cpu_to_be32(select_ntuple(csk->cdev, csk->l2t));
+		req->params = cpu_to_be64(V_FILTER_TUPLE(
+				cxgb4_select_ntuple(
+					csk->cdev->ports[csk->port_id],
+					csk->l2t)));
 		opt2 |= 1 << 31;
 		req->opt2 = cpu_to_be32(opt2);
 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
