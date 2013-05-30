From: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH] cxgb4i: add support for t5 adapter
Date: Wed, 29 May 2013 17:13:28 -0700
Message-ID: <201305300013.r4U0DShR002579@localhost6.localdomain6>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBDN4XE6H5QHRBTVTTKGQKGQEUOZEEAA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

[PATCH] cxgb4i: add support for T5 adapter

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Adds support for Chelsio T5 adapter.

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |  159 +++++++++++++++++++++++++++++-------
 1 files changed, 128 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 3fecf35..e659feb 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -20,6 +20,7 @@
 #include <net/dst.h>
 #include <linux/netdevice.h>
 
+#include "t4_regs.h"
 #include "t4_msg.h"
 #include "cxgb4.h"
 #include "cxgb4_uld.h"
@@ -32,13 +33,12 @@ static unsigned int dbg_level;
 #include "../libcxgbi.h"
 
 #define	DRV_MODULE_NAME		"cxgb4i"
-#define DRV_MODULE_DESC		"Chelsio T4 iSCSI Driver"
-#define	DRV_MODULE_VERSION	"0.9.1"
-#define	DRV_MODULE_RELDATE	"Aug. 2010"
+#define DRV_MODULE_DESC		"Chelsio T4/T5 iSCSI Driver"
+#define	DRV_MODULE_VERSION	"0.9.4"
 
 static char version[] =
 	DRV_MODULE_DESC " " DRV_MODULE_NAME
-	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+	" v" DRV_MODULE_VERSION "\n";
 
 MODULE_AUTHOR("Chelsio Communications, Inc.");
 MODULE_DESCRIPTION(DRV_MODULE_DESC);
@@ -175,10 +175,56 @@ static inline int is_ofld_imm(const struct sk_buff *skb)
 			sizeof(struct fw_ofld_tx_data_wr));
 }
 
+
+#define VLAN_NONE 0xfff
+#define FILTER_SEL_VLAN_NONE 0xffff
+#define FILTER_SEL_WIDTH_P_FC (3+1) /* port uses 3 bits, FCoE one bit */
+#define FILTER_SEL_WIDTH_VIN_P_FC \
+	(6 + 7 + FILTER_SEL_WIDTH_P_FC) /* 6 bits are unused, VF uses 7 bits*/
+#define FILTER_SEL_WIDTH_TAG_P_FC \
+	(3 + FILTER_SEL_WIDTH_VIN_P_FC) /* PF uses 3 bits */
+#define FILTER_SEL_WIDTH_VLD_TAG_P_FC (1 + FILTER_SEL_WIDTH_TAG_P_FC)
+
+static unsigned int select_ntuple(struct cxgbi_device *cdev,
+				struct l2t_entry *l2t)
+{
+	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(cdev);
+	unsigned int ntuple = 0;
+	u32 viid;
+
+	switch (lldi->filt_mode) {
+
+	/* default filter mode */
+	case HW_TPL_FR_MT_PR_IV_P_FC:
+		if (l2t->vlan == VLAN_NONE)
+			ntuple |= FILTER_SEL_VLAN_NONE << FILTER_SEL_WIDTH_P_FC;
+		else {
+			ntuple |= l2t->vlan << FILTER_SEL_WIDTH_P_FC;
+			ntuple |= 1 << FILTER_SEL_WIDTH_VLD_TAG_P_FC;
+		}
+		ntuple |= l2t->lport << S_PORT | IPPROTO_TCP <<
+			  FILTER_SEL_WIDTH_VLD_TAG_P_FC;
+		break;
+	case HW_TPL_FR_MT_PR_OV_P_FC: {
+		viid = cxgb4_port_viid(l2t->neigh->dev);
+
+		ntuple |= FW_VIID_VIN_GET(viid) << FILTER_SEL_WIDTH_P_FC;
+		ntuple |= FW_VIID_PFN_GET(viid) << FILTER_SEL_WIDTH_VIN_P_FC;
+		ntuple |= FW_VIID_VIVLD_GET(viid) << FILTER_SEL_WIDTH_TAG_P_FC;
+		ntuple |= l2t->lport << S_PORT | IPPROTO_TCP <<
+			  FILTER_SEL_WIDTH_VLD_TAG_P_FC;
+		break;
+	}
+	default:
+		break;
+	}
+	return ntuple;
+}
+
 static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 				struct l2t_entry *e)
 {
-	struct cpl_act_open_req *req;
+	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(csk->cdev);
 	int wscale = cxgbi_sock_compute_wscale(csk->mss_idx);
 	unsigned long long opt0;
 	unsigned int opt2;
@@ -195,29 +241,58 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		RCV_BUFSIZ(cxgb4i_rcv_win >> 10);
 	opt2 = RX_CHANNEL(0) |
 		RSS_QUEUE_VALID |
-		(1 << 20) | (1 << 22) |
+		(1 << 20) |
 		RSS_QUEUE(csk->rss_qid);
 
-	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->port_id);
-	req = (struct cpl_act_open_req *)skb->head;
+	if (is_t4(lldi->adapter_type)) {
+		struct cpl_act_open_req *req =
+				(struct cpl_act_open_req *)skb->head;
 
-	INIT_TP_WR(req, 0);
-	OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
+		req = (struct cpl_act_open_req *)skb->head;
+
+		INIT_TP_WR(req, 0);
+		OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
 					qid_atid));
-	req->local_port = csk->saddr.sin_port;
-	req->peer_port = csk->daddr.sin_port;
-	req->local_ip = csk->saddr.sin_addr.s_addr;
-	req->peer_ip = csk->daddr.sin_addr.s_addr;
-	req->opt0 = cpu_to_be64(opt0);
-	req->params = 0;
-	req->opt2 = cpu_to_be32(opt2);
+		req->local_port = csk->saddr.sin_port;
+		req->peer_port = csk->daddr.sin_port;
+		req->local_ip = csk->saddr.sin_addr.s_addr;
+		req->peer_ip = csk->daddr.sin_addr.s_addr;
+		req->opt0 = cpu_to_be64(opt0);
+		req->params = cpu_to_be32(select_ntuple(csk->cdev, csk->l2t));
+		opt2 |= 1 << 22;
+		req->opt2 = cpu_to_be32(opt2);
 
-	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, %pI4:%u-%pI4:%u, atid %d, qid %u.\n",
-		csk, &req->local_ip, ntohs(req->local_port),
-		&req->peer_ip, ntohs(req->peer_port),
-		csk->atid, csk->rss_qid);
+		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
+			"csk t4 0x%p, %pI4:%u-%pI4:%u, atid %d, qid %u.\n",
+			csk, &req->local_ip, ntohs(req->local_port),
+			&req->peer_ip, ntohs(req->peer_port),
+			csk->atid, csk->rss_qid);
+	} else {
+		struct cpl_t5_act_open_req *req =
+				(struct cpl_t5_act_open_req *)skb->head;
+
+		req = (struct cpl_t5_act_open_req *)skb->head;
+
+		INIT_TP_WR(req, 0);
+		OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
+					qid_atid));
+		req->local_port = csk->saddr.sin_port;
+		req->peer_port = csk->daddr.sin_port;
+		req->local_ip = csk->saddr.sin_addr.s_addr;
+		req->peer_ip = csk->daddr.sin_addr.s_addr;
+		req->opt0 = cpu_to_be64(opt0);
+		req->params = cpu_to_be32(select_ntuple(csk->cdev, csk->l2t));
+		opt2 |= 1 << 31;
+		req->opt2 = cpu_to_be32(opt2);
 
+		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
+			"csk t5 0x%p, %pI4:%u-%pI4:%u, atid %d, qid %u.\n",
+			csk, &req->local_ip, ntohs(req->local_port),
+			&req->peer_ip, ntohs(req->peer_port),
+			csk->atid, csk->rss_qid);
+	}
+
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->port_id);
 	cxgb4_l2t_send(csk->cdev->ports[csk->port_id], skb, csk->l2t);
 }
 
@@ -632,6 +707,7 @@ static void csk_act_open_retry_timer(unsigned long data)
 {
 	struct sk_buff *skb;
 	struct cxgbi_sock *csk = (struct cxgbi_sock *)data;
+	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(csk->cdev);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,0x%lx,%u.\n",
@@ -639,7 +715,10 @@ static void csk_act_open_retry_timer(unsigned long data)
 
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
-	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_ATOMIC);
+	skb = alloc_wr(is_t4(lldi->adapter_type) ?
+				sizeof(struct cpl_act_open_req) :
+				sizeof(struct cpl_t5_act_open_req),
+			0, GFP_ATOMIC);
 	if (!skb)
 		cxgbi_sock_fail_act_open(csk, -ENOMEM);
 	else {
@@ -871,7 +950,7 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	if (!csk->skb_ulp_lhdr) {
 		unsigned char *bhs;
-		unsigned int hlen, dlen;
+		unsigned int hlen, dlen, plen;
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
 			"csk 0x%p,%u,0x%lx, tid %u, skb 0x%p header.\n",
@@ -890,11 +969,15 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 		hlen = ntohs(cpl->len);
 		dlen = ntohl(*(unsigned int *)(bhs + 4)) & 0xFFFFFF;
 
-		if ((hlen + dlen) != ISCSI_PDU_LEN(pdu_len_ddp) - 40) {
+		plen = ISCSI_PDU_LEN(pdu_len_ddp);
+		if (is_t4(lldi->adapter_type))
+			plen -= 40;
+
+		if ((hlen + dlen) != plen) {
 			pr_info("tid 0x%x, CPL_ISCSI_HDR, pdu len "
 				"mismatch %u != %u + %u, seq 0x%x.\n",
-				csk->tid, ISCSI_PDU_LEN(pdu_len_ddp) - 40,
-				hlen, dlen, cxgbi_skcb_tcp_seq(skb));
+				csk->tid, plen, hlen, dlen,
+				cxgbi_skcb_tcp_seq(skb));
 			goto abort_conn;
 		}
 
@@ -1154,7 +1237,10 @@ static int init_act_open(struct cxgbi_sock *csk)
 	}
 	cxgbi_sock_get(csk);
 
-	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
+	skb = alloc_wr(is_t4(lldi->adapter_type) ?
+				sizeof(struct cpl_act_open_req) :
+				sizeof(struct cpl_t5_act_open_req),
+			0, GFP_ATOMIC);
 	if (!skb)
 		goto rel_resource;
 	skb->sk = (struct sock *)csk;
@@ -1193,6 +1279,8 @@ rel_resource:
 	return -EINVAL;
 }
 
+#define CPL_ISCSI_DATA		0xB2
+#define CPL_RX_ISCSI_DDP	0x49
 cxgb4i_cplhandler_func cxgb4i_cplhandlers[NUM_CPL_CMDS] = {
 	[CPL_ACT_ESTABLISH] = do_act_establish,
 	[CPL_ACT_OPEN_RPL] = do_act_open_rpl,
@@ -1202,8 +1290,10 @@ cxgb4i_cplhandler_func cxgb4i_cplhandlers[NUM_CPL_CMDS] = {
 	[CPL_CLOSE_CON_RPL] = do_close_con_rpl,
 	[CPL_FW4_ACK] = do_fw4_ack,
 	[CPL_ISCSI_HDR] = do_rx_iscsi_hdr,
+	[CPL_ISCSI_DATA] = do_rx_iscsi_hdr,
 	[CPL_SET_TCB_RPL] = do_set_tcb_rpl,
 	[CPL_RX_DATA_DDP] = do_rx_data_ddp,
+	[CPL_RX_ISCSI_DDP] = do_rx_data_ddp,
 };
 
 int cxgb4i_ofld_init(struct cxgbi_device *cdev)
@@ -1234,14 +1324,20 @@ int cxgb4i_ofld_init(struct cxgbi_device *cdev)
  * functions to program the pagepod in h/w
  */
 #define ULPMEM_IDATA_MAX_NPPODS	4 /* 256/PPOD_SIZE */
-static inline void ulp_mem_io_set_hdr(struct ulp_mem_io *req,
+static inline void ulp_mem_io_set_hdr(struct cxgb4_lld_info *lldi,
+				struct ulp_mem_io *req,
 				unsigned int wr_len, unsigned int dlen,
 				unsigned int pm_addr)
 {
 	struct ulptx_idata *idata = (struct ulptx_idata *)(req + 1);
 
 	INIT_ULPTX_WR(req, wr_len, 0, 0);
-	req->cmd = htonl(ULPTX_CMD(ULP_TX_MEM_WRITE) | (1 << 23));
+	if (is_t4(lldi->adapter_type))
+		req->cmd = htonl(ULPTX_CMD(ULP_TX_MEM_WRITE) |
+					(ULP_MEMIO_ORDER(1)));
+	else
+		req->cmd = htonl(ULPTX_CMD(ULP_TX_MEM_WRITE) |
+					(V_T5_ULP_MEMIO_IMM(1)));
 	req->dlen = htonl(ULP_MEMIO_DATA_LEN(dlen >> 5));
 	req->lock_addr = htonl(ULP_MEMIO_ADDR(pm_addr >> 5));
 	req->len16 = htonl(DIV_ROUND_UP(wr_len - sizeof(req->wr), 16));
@@ -1257,6 +1353,7 @@ static int ddp_ppod_write_idata(struct cxgbi_device *cdev, unsigned int port_id,
 				unsigned int gl_pidx)
 {
 	struct cxgbi_ddp_info *ddp = cdev->ddp;
+	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(cdev);
 	struct sk_buff *skb;
 	struct ulp_mem_io *req;
 	struct ulptx_idata *idata;
@@ -1276,7 +1373,7 @@ static int ddp_ppod_write_idata(struct cxgbi_device *cdev, unsigned int port_id,
 	req = (struct ulp_mem_io *)skb->head;
 	set_queue(skb, CPL_PRIORITY_CONTROL, NULL);
 
-	ulp_mem_io_set_hdr(req, wr_len, dlen, pm_addr);
+	ulp_mem_io_set_hdr(lldi, req, wr_len, dlen, pm_addr);
 	idata = (struct ulptx_idata *)(req + 1);
 	ppod = (struct cxgbi_pagepod *)(idata + 1);
 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi?hl=en.
For more options, visit https://groups.google.com/groups/opt_out.
