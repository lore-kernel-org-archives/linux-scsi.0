From: Joe Perches <joe@perches.com>
Subject: RE: [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
Date: Mon, 16 Aug 2010 09:48:17 -0700
Message-ID: <1281977297.6518.68.camel@Joe-Laptop>
References: <201008130257.o7D2vLVx001282@localhost.localdomain>
	 <1281669700.15486.71.camel@Joe-Laptop>
	 <8A71B368A89016469F72CD08050AD33408403F41@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8A71B368A89016469F72CD08050AD33408403F41@maui.asicdesigners.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Rakesh Ranjan <rakesh@chelsio.com>, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-08-12 at 20:44 -0700, Karen Xie wrote:
> Will use pr_xxx instead.

I meant more like this:

Use #define pr_fmt(fmt) KBUILD_MODNAME ":s: " fmt, __func__
Use pr_<level>
Correct mismatches of "%lu", sizeof to "%u", sizeof
Standardize message to remove trailing ".", some had, some hadn't.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |  122 +++++++-------
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |  153 +++++++++---------
 drivers/scsi/cxgbi/libcxgbi.c      |  312 ++++++++++++++++++------------------
 drivers/scsi/cxgbi/libcxgbi.h      |   31 ++---
 4 files changed, 308 insertions(+), 310 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 6e1dcd8..dc97c83 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -12,6 +12,8 @@
  *		Karen Xie (kxie@chelsio.com)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -191,7 +193,7 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 			V_RCV_BUFSIZ(cxgb3i_rcv_win>>10));
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, %pI4:%u-%pI4:%u, %u,%u,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u, %pI4:%u-%pI4:%u, %u,%u,%u\n",
 		csk, csk->state, csk->flags, csk->atid,
 		&req->local_ip, ntohs(req->local_port),
 		&req->peer_ip, ntohs(req->peer_port),
@@ -218,7 +220,7 @@ static void send_close_req(struct cxgbi_sock *csk)
 	unsigned int tid = csk->tid;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	csk->cpl_close = NULL;
@@ -244,7 +246,7 @@ static void abort_arp_failure(struct t3cdev *tdev, struct sk_buff *skb)
 	struct cpl_abort_req *req = cplhdr(skb);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"t3dev 0x%p, tid %u, skb 0x%p.\n",
+		"t3dev 0x%p, tid %u, skb 0x%p\n",
 		tdev, GET_TID(req), skb);
 	req->cmd = CPL_ABORT_NO_RST;
 	cxgb3_ofld_send(tdev, skb);
@@ -274,7 +276,7 @@ static void send_abort_req(struct cxgbi_sock *csk)
 	req->cmd = CPL_ABORT_SEND_RST;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, snd_nxt %u, 0x%x.\n",
+		"csk 0x%p,%u,0x%lx,%u, snd_nxt %u, 0x%x\n",
 		csk, csk->state, csk->flags, csk->tid, csk->snd_nxt,
 		req->rsvd1);
 
@@ -292,7 +294,7 @@ static void send_abort_rpl(struct cxgbi_sock *csk, int rst_status)
 	struct cpl_abort_rpl *rpl = (struct cpl_abort_rpl *)skb->head;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, status %d.\n",
+		"csk 0x%p,%u,0x%lx,%u, status %d\n",
 		csk, csk->state, csk->flags, csk->tid, rst_status);
 
 	csk->cpl_abort_rpl = NULL;
@@ -321,7 +323,7 @@ static u32 send_rx_credits(struct cxgbi_sock *csk, u32 credits)
 
 	skb = alloc_cpl(sizeof(*req), 0, GFP_ATOMIC);
 	if (!skb) {
-		log_info("csk 0x%p, credit %u, OOM.\n", csk, credits);
+		pr_info("csk 0x%p, credit %u, OOM\n", csk, credits);
 		return 0;
 	}
 	req = (struct cpl_rx_data_ack *)skb->head;
@@ -414,7 +416,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 	if (unlikely(csk->state < CTP_ESTABLISHED ||
 		csk->state == CTP_CLOSE_WAIT_1 || csk->state >= CTP_ABORTING)) {
 			log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_TX,
-				"csk 0x%p,%u,0x%lx,%u, in closing state.\n",
+				"csk 0x%p,%u,0x%lx,%u, in closing state\n",
 				csk, csk->state, csk->flags, csk->tid);
 		return 0;
 	}
@@ -431,7 +433,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 
 		if (csk->wr_cred < wrs_needed) {
 			log_debug(1 << CXGBI_DBG_PDU_TX,
-				"csk 0x%p, skb len %u/%u, frag %u, wr %d<%u.\n",
+				"csk 0x%p, skb len %u/%u, frag %u, wr %d<%u\n",
 				csk, skb->len, skb->data_len, frags,
 				wrs_needed, csk->wr_cred);
 			break;
@@ -446,7 +448,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_TX,
 			"csk 0x%p, enqueue, skb len %u/%u, frag %u, wr %d, "
-			"left %u, unack %u.\n",
+			"left %u, unack %u\n",
 			csk, skb->len, skb->data_len, frags, skb->csum,
 			csk->wr_cred, csk->wr_una_cred);
 
@@ -464,7 +466,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 		}
 		total_size += skb->truesize;
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p, tid 0x%x, send skb 0x%p.\n",
+			"csk 0x%p, tid 0x%x, send skb 0x%p\n",
 			csk, csk->tid, skb);
 		set_arp_failure_handler(skb, arp_failure_skb_discard);
 		l2t_send(csk->cdev->lldev, skb, csk->l2t);
@@ -496,7 +498,7 @@ static int do_act_establish(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	u32 rcv_isn = ntohl(req->rcv_isn);	/* real RCV_ISN + 1 */
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"atid 0x%x,tid 0x%x, csk 0x%p,%u,0x%lx, isn %u.\n",
+		"atid 0x%x,tid 0x%x, csk 0x%p,%u,0x%lx, isn %u\n",
 		atid, atid, csk, csk->state, csk->flags, rcv_isn);
 
 	cxgbi_sock_get(csk);
@@ -515,7 +517,7 @@ static int do_act_establish(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	}
 
 	if (unlikely(csk->state != CTP_ACTIVE_OPEN))
-		log_info("csk 0x%p,%u,0x%lx,%u, got EST.\n",
+		pr_info("csk 0x%p,%u,0x%lx,%u, got EST\n",
 			csk, csk->state, csk->flags, csk->tid);
 
 	csk->copied_seq = csk->rcv_wup = csk->rcv_nxt = rcv_isn;
@@ -566,7 +568,7 @@ static void act_open_retry_timer(unsigned long data)
 	struct cxgbi_sock *csk = (struct cxgbi_sock *)data;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	cxgbi_sock_get(csk);
@@ -589,7 +591,7 @@ static int do_act_open_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	struct cpl_act_open_rpl *rpl = cplhdr(skb);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, status %u.\n",
+		"csk 0x%p,%u,0x%lx,%u, status %u\n",
 		csk, csk->state, csk->flags, csk->atid, rpl->status);
 
 	if (rpl->status != CPL_ERR_TCAM_FULL &&
@@ -622,7 +624,7 @@ static int do_peer_close(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
 	struct cxgbi_sock *csk = ctx;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	cxgbi_sock_rcv_peer_close(csk);
@@ -641,7 +643,7 @@ static int do_close_con_rpl(struct t3cdev *cdev, struct sk_buff *skb,
 	struct cpl_close_con_rpl *rpl = cplhdr(skb);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, snxt %u.\n",
+		"csk 0x%p,%u,0x%lx,%u, snxt %u\n",
 		csk, csk->state, csk->flags, csk->tid, ntohl(rpl->snd_nxt));
 
 	cxgbi_sock_rcv_close_conn_rpl(csk, ntohl(rpl->snd_nxt));
@@ -680,7 +682,7 @@ static int do_abort_req(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
 	int rst_status = CPL_ABORT_NO_RST;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	if (req->status == CPL_ERR_RTX_NEG_ADVICE ||
@@ -726,7 +728,7 @@ static int do_abort_rpl(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
 	struct cxgbi_sock *csk = ctx;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"status 0x%x, csk 0x%p, s %u, 0x%lx.\n",
+		"status 0x%x, csk 0x%p, s %u, 0x%lx\n",
 		rpl->status, csk, csk ? csk->state : 0,
 		csk ? csk->flags : 0UL);
 	/*
@@ -767,14 +769,14 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
 	int err;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lx,%u, skb 0x%p,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u, skb 0x%p,%u\n",
 		csk, csk->state, csk->flags, csk->tid, skb, skb->len);
 
 	spin_lock_bh(&csk->lock);
 
 	if (unlikely(csk->state >= CTP_PASSIVE_CLOSE)) {
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-			"csk 0x%p,%u,0x%lx,%u, bad state.\n",
+			"csk 0x%p,%u,0x%lx,%u, bad state\n",
 			csk, csk->state, csk->flags, csk->tid);
 		if (csk->state != CTP_ABORTING)
 			goto abort_conn;
@@ -791,9 +793,9 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
 	len = hdr_len = ntohs(hdr_cpl->len);
 	/* msg coalesce is off or not enough data received */
 	if (skb->len <= hdr_len) {
-		log_error("%s: tid %u, CPL_ISCSI_HDR, skb len %u < %u.\n",
-			csk->cdev->ports[csk->port_id]->name, csk->tid,
-			skb->len, hdr_len);
+		pr_err("%s: tid %u, CPL_ISCSI_HDR, skb len %u < %u\n",
+		       csk->cdev->ports[csk->port_id]->name, csk->tid,
+		       skb->len, hdr_len);
 		goto abort_conn;
 	}
 	cxgbi_skcb_set_flag(skb, SKCBF_RX_COALESCED);
@@ -801,9 +803,9 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
 	err = skb_copy_bits(skb, skb->len - sizeof(ddp_cpl), &ddp_cpl,
 			    sizeof(ddp_cpl));
 	if (err < 0) {
-		log_error("%s: tid %u, copy cpl_ddp %u-%lu failed %d.\n",
-			csk->cdev->ports[csk->port_id]->name, csk->tid,
-			skb->len, sizeof(ddp_cpl), err);
+		pr_err("%s: tid %u, copy cpl_ddp %u-%u failed %d\n",
+		       csk->cdev->ports[csk->port_id]->name, csk->tid,
+		       skb->len, sizeof(ddp_cpl), err);
 		goto abort_conn;
 	}
 
@@ -813,7 +815,7 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
 	status = ntohl(ddp_cpl.ddp_status);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p, skb 0x%p,%u, pdulen %u, status 0x%x.\n",
+		"csk 0x%p, skb 0x%p,%u, pdulen %u, status 0x%x\n",
 		csk, skb, skb->len, cxgbi_skcb_rx_pdulen(skb), status);
 
 	if (status & (1 << CPL_RX_DDP_STATUS_HCRC_SHIFT))
@@ -826,14 +828,14 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
 	if (skb->len > (hdr_len + sizeof(ddp_cpl))) {
 		err = skb_copy_bits(skb, hdr_len, &data_cpl, sizeof(data_cpl));
 		if (err < 0) {
-			log_error("%s: tid %u, cp %lu/%u failed %d.\n",
-				csk->cdev->ports[csk->port_id]->name,
-				csk->tid, sizeof(data_cpl), skb->len, err);
+			pr_err("%s: tid %u, cp %u/%u failed %d\n",
+			       csk->cdev->ports[csk->port_id]->name,
+			       csk->tid, sizeof(data_cpl), skb->len, err);
 			goto abort_conn;
 		}
 		data_len = ntohs(data_cpl.len);
 		log_debug(1 << CXGBI_DBG_DDP | 1 << CXGBI_DBG_PDU_RX,
-			"skb 0x%p, pdu not ddp'ed %u/%u, status 0x%x.\n",
+			"skb 0x%p, pdu not ddp'ed %u/%u, status 0x%x\n",
 			skb, data_len, cxgbi_skcb_rx_pdulen(skb), status);
 		len += sizeof(data_cpl) + data_len;
 	} else if (status & (1 << CPL_RX_DDP_STATUS_DDP_SHIFT))
@@ -866,7 +868,7 @@ static int do_wr_ack(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
 	struct cpl_wr_ack *hdr = cplhdr(skb);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lx,%u, cr %u.\n",
+		"csk 0x%p,%u,0x%lx,%u, cr %u\n",
 		csk, csk->state, csk->flags, csk->tid, ntohs(hdr->credits));
 
 	cxgbi_sock_rcv_wr_ack(csk, ntohs(hdr->credits), ntohl(hdr->snd_una), 1);
@@ -922,7 +924,7 @@ static void release_offload_resources(struct cxgbi_sock *csk)
 	struct t3cdev *t3dev = (struct t3cdev *)csk->cdev->lldev;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	csk->rss_qid = 0;
@@ -953,19 +955,19 @@ static int init_act_open(struct cxgbi_sock *csk)
 	struct sk_buff *skb = NULL;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx.\n", csk, csk->state, csk->flags);
+		"csk 0x%p,%u,0x%lx\n", csk, csk->state, csk->flags);
 
 	csk->rss_qid = 0;
 	csk->l2t = t3_l2t_get(t3dev, dst->neighbour, ndev);
 	if (!csk->l2t) {
-		log_error("NO l2t available.\n");
+		pr_err("NO l2t available\n");
 		return -EINVAL;
 	}
 	cxgbi_sock_get(csk);
 
 	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
 	if (csk->atid < 0) {
-		log_error("NO atid available.\n");
+		pr_err("NO atid available\n");
 		goto rel_resource;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
@@ -1019,7 +1021,7 @@ int cxgb3i_ofld_init(struct cxgbi_device *cdev)
 	if (t3dev->ctl(t3dev, GET_WR_LEN, &wr_len) < 0 ||
 	    t3dev->ctl(t3dev, GET_PORTS, &port) < 0 ||
 	    t3dev->ctl(t3dev, GET_RX_PAGE_INFO, &rx_page_info) < 0) {
-		log_warn("t3 0x%p, offload up, ioctl failed.\n", t3dev);
+		pr_warn("t3 0x%p, offload up, ioctl failed\n", t3dev);
 		return -EINVAL;
 	}
 
@@ -1040,7 +1042,7 @@ int cxgb3i_ofld_init(struct cxgbi_device *cdev)
 	cdev->csk_alloc_cpls = alloc_cpls;
 	cdev->csk_init_act_open = init_act_open;
 
-	log_info("cdev 0x%p, offload up, added.\n", cdev);
+	pr_info("cdev 0x%p, offload up, added\n", cdev);
 	return 0;
 }
 
@@ -1070,7 +1072,7 @@ static int ddp_set_map(struct cxgbi_sock *csk, struct cxgbi_pagepod_hdr *hdr,
 	int i;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"csk 0x%p, idx %u, npods %u, gl 0x%p.\n",
+		"csk 0x%p, idx %u, npods %u, gl 0x%p\n",
 		csk, idx, npods, gl);
 
 	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
@@ -1098,15 +1100,15 @@ static void ddp_clear_map(struct cxgbi_hba *chba, unsigned int tag,
 	int i;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"cdev 0x%p, idx %u, npods %u, tag 0x%x.\n",
+		"cdev 0x%p, idx %u, npods %u, tag 0x%x\n",
 		cdev, idx, npods, tag);
 
 	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
 		struct sk_buff *skb = ddp->gl_skb[idx];
 
 		if (!skb) {
-			log_error("tag 0x%x, 0x%x, %d/%u, skb NULL.\n",
-				tag, idx, i, npods);
+			pr_err("tag 0x%x, 0x%x, %d/%u, skb NULL\n",
+			       tag, idx, i, npods);
 			continue;
 		}
 		ddp->gl_skb[idx] = NULL;
@@ -1122,7 +1124,7 @@ static void ddp_free_gl_skb(struct cxgbi_ddp_info *ddp, int idx, int cnt)
 	int i;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"ddp 0x%p, idx %d, cnt %d.\n", ddp, idx, cnt);
+		"ddp 0x%p, idx %d, cnt %d\n", ddp, idx, cnt);
 
 	for (i = 0; i < cnt; i++, idx++)
 		if (ddp->gl_skb[idx]) {
@@ -1137,7 +1139,7 @@ static int ddp_alloc_gl_skb(struct cxgbi_ddp_info *ddp, int idx,
 	int i;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"ddp 0x%p, idx %d, cnt %d.\n", ddp, idx, cnt);
+		"ddp 0x%p, idx %d, cnt %d\n", ddp, idx, cnt);
 
 	for (i = 0; i < cnt; i++) {
 		struct sk_buff *skb = alloc_cpl(sizeof(struct ulp_mem_io) +
@@ -1161,7 +1163,7 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk,
 	u64 val = pg_idx < DDP_PGIDX_MAX ? pg_idx : 0;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"csk 0x%p, tid %u, pg_idx %d.\n", csk, tid, pg_idx);
+		"csk 0x%p, tid %u, pg_idx %d\n", csk, tid, pg_idx);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1198,7 +1200,7 @@ static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
 	u64 val = (hcrc ? 1 : 0) | (dcrc ? 2 : 0);
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"csk 0x%p, tid %u, crc %d,%d.\n", csk, tid, hcrc, dcrc);
+		"csk 0x%p, tid %u, crc %d,%d\n", csk, tid, hcrc, dcrc);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1229,7 +1231,7 @@ static void t3_ddp_cleanup(struct cxgbi_device *cdev)
 	struct t3cdev *tdev = (struct t3cdev *)cdev->lldev;
 
 	if (cxgbi_ddp_cleanup(cdev)) {
-		log_info("t3dev 0x%p, ulp_iscsi no more user.\n", tdev);
+		pr_info("t3dev 0x%p, ulp_iscsi no more user\n", tdev);
 		tdev->ulp_iscsi = NULL;
 	}
 }
@@ -1249,7 +1251,7 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 
 	if (ddp) {
 		kref_get(&ddp->refcnt);
-		log_warn("t3dev 0x%p, ddp 0x%p already set up.\n",
+		pr_warn("t3dev 0x%p, ddp 0x%p already set up\n",
 			tdev, tdev->ulp_iscsi);
 		cdev->ddp = ddp;
 		return -EALREADY;
@@ -1257,8 +1259,8 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 
 	err = tdev->ctl(tdev, ULP_ISCSI_GET_PARAMS, &uinfo);
 	if (err < 0) {
-		log_error("%s, failed to get iscsi param err=%d.\n",
-			 tdev->name, err);
+		pr_err("%s, failed to get iscsi param err=%d\n",
+		       tdev->name, err);
 		return err;
 	}
 
@@ -1275,7 +1277,7 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 
 	err = tdev->ctl(tdev, ULP_ISCSI_SET_PARAMS, &uinfo);
 	if (err < 0) {
-		log_warn("%s unable to set iscsi param err=%d, ddp disabled.\n",
+		pr_warn("%s unable to set iscsi param err=%d, ddp disabled\n",
 			tdev->name, err);
 		cxgbi_ddp_cleanup(cdev);
 		return err;
@@ -1289,8 +1291,8 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 	cdev->csk_ddp_set = ddp_set_map;
 	cdev->csk_ddp_clear = ddp_clear_map;
 
-	log_info("tdev 0x%p, nppods %u, bits %u, mask 0x%x,0x%x pkt %u/%u, "
-		"%u/%u.\n",
+	pr_info("tdev 0x%p, nppods %u, bits %u, mask 0x%x,0x%x pkt %u/%u, "
+		"%u/%u\n",
 		tdev, ddp->nppods, ddp->idx_bits, ddp->idx_mask,
 		ddp->rsvd_tag_mask, ddp->max_txsz, uinfo.max_txsz,
 		ddp->max_rxsz, uinfo.max_rxsz);
@@ -1302,7 +1304,7 @@ static void cxgb3i_dev_close(struct t3cdev *t3dev)
 	struct cxgbi_device *cdev = cxgbi_device_find_by_lldev(t3dev);
 
 	if (!cdev || cdev->flags & CXGBI_FLAG_ADAPTER_RESET) {
-		log_info("0x%p close, f 0x%x.\n", cdev, cdev ? cdev->flags : 0);
+		pr_info("0x%p close, f 0x%x\n", cdev, cdev ? cdev->flags : 0);
 		return;
 	}
 
@@ -1320,13 +1322,13 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
 	int i, err;
 
 	if (cdev) {
-		log_info("0x%p, updating.\n", cdev);
+		pr_info("0x%p, updating\n", cdev);
 		return;
 	}
 
 	cdev = cxgbi_device_register(0, adapter->params.nports);
 	if (!cdev) {
-		log_warn("device 0x%p register failed.\n", t3dev);
+		pr_warn("device 0x%p register failed\n", t3dev);
 		return;
 	}
 
@@ -1347,13 +1349,13 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
 
 	err = cxgb3i_ddp_init(cdev);
 	if (err) {
-		log_info("0x%p ddp init failed\n", cdev);
+		pr_info("0x%p ddp init failed\n", cdev);
 		goto err_out;
 	}
 
 	err = cxgb3i_ofld_init(cdev);
 	if (err) {
-		log_info("0x%p offload init failed\n", cdev);
+		pr_info("0x%p offload init failed\n", cdev);
 		goto err_out;
 	}
 
@@ -1366,7 +1368,7 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
 		cdev->hbas[i]->ipv4addr =
 			cxgb3i_get_private_ipv4addr(cdev->ports[i]);
 
-	log_info("cdev 0x%p, f 0x%x, t3dev 0x%p open, err %d.\n",
+	pr_info("cdev 0x%p, f 0x%x, t3dev 0x%p open, err %d\n",
 		cdev, cdev ? cdev->flags : 0, t3dev, err);
 	return;
 
@@ -1379,7 +1381,7 @@ static void cxgb3i_dev_event_handler(struct t3cdev *t3dev, u32 event, u32 port)
 	struct cxgbi_device *cdev = cxgbi_device_find_by_lldev(t3dev);
 
 	log_debug(1 << CXGBI_DBG_TOE,
-		"0x%p, cdev 0x%p, event 0x%x, port 0x%x.\n",
+		"0x%p, cdev 0x%p, event 0x%x, port 0x%x\n",
 		t3dev, cdev, event, port);
 	if (!cdev)
 		return;
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 77d4418..dab0f79 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -11,6 +11,8 @@
  *		Rakesh Ranjan (rranjan@chelsio.com)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -26,7 +28,6 @@
 #include "l2t.h"
 #include "cxgb4i.h"
 
-#define pr_prefix "cxgb4i: "
 static unsigned int dbg_level;
 
 #include "../libcxgbi.h"
@@ -230,7 +231,7 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 	req->opt2 = cpu_to_be32(opt2);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, %pI4:%u-%pI4:%u, atid %d, qid %u.\n",
+		"csk 0x%p, %pI4:%u-%pI4:%u, atid %d, qid %u\n",
 		csk, &req->local_ip, ntohs(req->local_port),
 		&req->peer_ip, ntohs(req->peer_port),
 		csk->atid, csk->rss_qid);
@@ -245,7 +246,7 @@ static void send_close_req(struct cxgbi_sock *csk)
 	unsigned int tid = csk->tid;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, tid %u.\n",
+		"csk 0x%p,%u,0x%lx, tid %u\n",
 		csk, csk->state, csk->flags, csk->tid);
 	csk->cpl_close = NULL;
 	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->port_id);
@@ -264,7 +265,7 @@ static void abort_arp_failure(void *handle, struct sk_buff *skb)
 	struct cpl_abort_req *req;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, tid %u, abort.\n",
+		"csk 0x%p,%u,0x%lx, tid %u, abort\n",
 		csk, csk->state, csk->flags, csk->tid);
 	req = (struct cpl_abort_req *)skb->data;
 	req->cmd = CPL_ABORT_NO_RST;
@@ -293,7 +294,7 @@ static void send_abort_req(struct cxgbi_sock *csk)
 	req->rsvd1 = !cxgbi_sock_flag(csk, CTPF_TX_DATA_SENT);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, snd_nxt %u, 0x%x.\n",
+		"csk 0x%p,%u,0x%lx,%u, snd_nxt %u, 0x%x\n",
 		csk, csk->state, csk->flags, csk->tid, csk->snd_nxt,
 		req->rsvd1);
 
@@ -306,7 +307,7 @@ static void send_abort_rpl(struct cxgbi_sock *csk, int rst_status)
 	struct cpl_abort_rpl *rpl = (struct cpl_abort_rpl *)skb->head;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u, status %d.\n",
+		"csk 0x%p,%u,0x%lx,%u, status %d\n",
 		csk, csk->state, csk->flags, csk->tid, rst_status);
 
 	csk->cpl_abort_rpl = NULL;
@@ -328,12 +329,12 @@ static u32 send_rx_credits(struct cxgbi_sock *csk, u32 credits)
 	struct cpl_rx_data_ack *req;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lx,%u, credit %u.\n",
+		"csk 0x%p,%u,0x%lx,%u, credit %u\n",
 		csk, csk->state, csk->flags, csk->tid, credits);
 
 	skb = alloc_cpl(sizeof(*req), 0, GFP_ATOMIC);
 	if (!skb) {
-		log_info("csk 0x%p, credit %u, OOM.\n", csk, credits);
+		pr_info("csk 0x%p, credit %u, OOM\n", csk, credits);
 		return 0;
 	}
 	req = (struct cpl_rx_data_ack *)skb->head;
@@ -420,7 +421,7 @@ static inline void send_tx_flowc_wr(struct cxgbi_sock *csk)
 	set_queue(skb, CPL_PRIORITY_DATA, csk);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, tid 0x%x, %u,%u,%u,%u,%u,%u,%u.\n",
+		"csk 0x%p, tid 0x%x, %u,%u,%u,%u,%u,%u,%u\n",
 		csk, csk->tid, 0, csk->tx_chan, csk->rss_qid,
 		csk->snd_nxt, csk->rcv_nxt, cxgb4i_snd_win,
 		csk->advmss);
@@ -476,7 +477,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 		csk->state == CTP_CLOSE_WAIT_1 || csk->state >= CTP_ABORTING)) {
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK |
 			 1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p,%u,0x%lx,%u, in closing state.\n",
+			"csk 0x%p,%u,0x%lx,%u, in closing state\n",
 			csk, csk->state, csk->flags, csk->tid);
 		return 0;
 	}
@@ -497,7 +498,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 
 		if (csk->wr_cred < credits_needed) {
 			log_debug(1 << CXGBI_DBG_PDU_TX,
-				"csk 0x%p, skb %u/%u, wr %d < %u.\n",
+				"csk 0x%p, skb %u/%u, wr %d < %u\n",
 				csk, skb->len, skb->data_len,
 				credits_needed, csk->wr_cred);
 			break;
@@ -510,7 +511,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 		cxgbi_sock_enqueue_wr(csk, skb);
 
 		log_debug(1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p, skb %u/%u, wr %d, left %u, unack %u.\n",
+			"csk 0x%p, skb %u/%u, wr %d, left %u, unack %u\n",
 			csk, skb->len, skb->data_len, credits_needed,
 			csk->wr_cred, csk->wr_una_cred);
 
@@ -531,7 +532,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion)
 		t4_set_arp_err_handler(skb, csk, arp_failure_skb_discard);
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p,%u,0x%lx,%u, skb 0x%p, %u.\n",
+			"csk 0x%p,%u,0x%lx,%u, skb 0x%p, %u\n",
 			csk, csk->state, csk->flags, csk->tid, skb, len);
 
 		cxgb4_l2t_send(csk->cdev->ports[csk->port_id], skb, csk->l2t);
@@ -563,12 +564,12 @@ static void do_act_establish(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_atid(t, atid);
 	if (unlikely(!csk)) {
-		log_error("NO connection for atid %u, cdev 0x%p\n", atid, cdev);
+		pr_err("NO connection for atid %u, cdev 0x%p\n", atid, cdev);
 		goto rel_skb;
 	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, tid %u, atid %u, rseq %u.\n",
+		"csk 0x%p,%u,0x%lx, tid %u, atid %u, rseq %u\n",
 		csk, csk->state, csk->flags, tid, atid, rcv_isn);
 
 	cxgbi_sock_get(csk);
@@ -580,7 +581,7 @@ static void do_act_establish(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	spin_lock_bh(&csk->lock);
 	if (unlikely(csk->state != CTP_ACTIVE_OPEN))
-		log_info("csk 0x%p,%u,0x%lx,%u, got EST.\n",
+		pr_info("csk 0x%p,%u,0x%lx,%u, got EST\n",
 			csk, csk->state, csk->flags, csk->tid);
 
 	if (csk->retry_timer.function) {
@@ -603,7 +604,7 @@ static void do_act_establish(struct cxgbi_device *cdev, struct sk_buff *skb)
 		csk->advmss = 128;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, mss_idx %u, advmss %u.\n",
+		"csk 0x%p, mss_idx %u, advmss %u\n",
 			csk, GET_TCPOPT_MSS(tcp_opt), csk->advmss);
 
 	cxgbi_sock_established(csk, ntohl(req->snd_isn), ntohs(req->tcp_opt));
@@ -645,7 +646,7 @@ static void csk_act_open_retry_timer(unsigned long data)
 	struct cxgbi_sock *csk = (struct cxgbi_sock *)data;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	cxgbi_sock_get(csk);
@@ -676,12 +677,12 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_atid(t, atid);
 	if (unlikely(!csk)) {
-		log_error("NO matching conn. atid %u, tid %u.\n", atid, tid);
+		pr_err("NO matching conn. atid %u, tid %u\n", atid, tid);
 		goto rel_skb;
 	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, status %u, atid %u, tid %u.\n",
+		"csk 0x%p,%u,0x%lx, status %u, atid %u, tid %u\n",
 			csk, csk->state, csk->flags, status, atid, tid);
 
 	if (status && status != CPL_ERR_TCAM_FULL &&
@@ -716,11 +717,11 @@ static void do_peer_close(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		log_error("can't find connection for tid %u\n", tid);
+		pr_err("can't find connection for tid %u\n", tid);
 		goto rel_skb;
 	}
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 	cxgbi_sock_rcv_peer_close(csk);
 rel_skb:
@@ -737,11 +738,11 @@ static void do_close_con_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		log_error("can't find connection for tid %u\n", tid);
+		pr_err("can't find connection for tid %u\n", tid);
 		goto rel_skb;
 	}
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 	cxgbi_sock_rcv_close_conn_rpl(csk, ntohl(rpl->snd_nxt));
 rel_skb:
@@ -777,12 +778,12 @@ static void do_abort_req_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		log_error("can't find connection for tid %u\n", tid);
+		pr_err("can't find connection for tid %u\n", tid);
 		goto rel_skb;
 	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, tid %u, status 0x%x.\n",
+		"csk 0x%p,%u,0x%lx, tid %u, status 0x%x\n",
 		csk, csk->state, csk->flags, csk->tid, req->status);
 
 	if (req->status == CPL_ERR_RTX_NEG_ADVICE ||
@@ -825,7 +826,7 @@ static void do_abort_rpl_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 		goto rel_skb;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"status 0x%x, csk 0x%p, s %u, 0x%lx.\n",
+		"status 0x%x, csk 0x%p, s %u, 0x%lx\n",
 		rpl->status, csk, csk ? csk->state : 0,
 		csk ? csk->flags : 0UL);
 
@@ -849,12 +850,12 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		log_error("can't find conn. for tid %u\n", tid);
+		pr_err("can't find conn. for tid %u\n", tid);
 		goto rel_skb;
 	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lx, tid %u, skb 0x%p,%u, 0x%x.\n",
+		"csk 0x%p,%u,0x%lx, tid %u, skb 0x%p,%u, 0x%x\n",
 		csk, csk->state, csk->flags, csk->tid, skb, skb->len,
 		pdu_len_ddp);
 
@@ -862,7 +863,7 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	if (unlikely(csk->state >= CTP_PASSIVE_CLOSE)) {
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-			"csk 0x%p,%u,0x%lx,%u, bad state.\n",
+			"csk 0x%p,%u,0x%lx,%u, bad state\n",
 			csk, csk->state, csk->flags, csk->tid);
 		if (csk->state != CTP_ABORTING)
 			goto abort_conn;
@@ -880,14 +881,14 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 		unsigned int hlen, dlen;
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p,%u,0x%lx, tid %u, skb 0x%p header.\n",
+			"csk 0x%p,%u,0x%lx, tid %u, skb 0x%p header\n",
 			csk, csk->state, csk->flags, csk->tid, skb);
 		csk->skb_ulp_lhdr = skb;
 		lskb = csk->skb_ulp_lhdr;
 		cxgbi_skcb_set_flag(lskb, SKCBF_RX_HDR);
 
 		if (cxgbi_skcb_tcp_seq(lskb) != csk->rcv_nxt) {
-			log_info("tid %u, CPL_ISCSI_HDR, bad seq, 0x%x/0x%x\n",
+			pr_info("tid %u, CPL_ISCSI_HDR, bad seq, 0x%x/0x%x\n",
 				csk->tid, cxgbi_skcb_tcp_seq(lskb),
 				csk->rcv_nxt);
 			goto abort_conn;
@@ -898,7 +899,7 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 		dlen = ntohl(*(unsigned int *)(bhs + 4)) & 0xFFFFFF;
 
 		if ((hlen + dlen) != ISCSI_PDU_LEN(pdu_len_ddp) - 40) {
-			log_info("tid 0x%x, CPL_ISCSI_HDR, pdu len "
+			pr_info("tid 0x%x, CPL_ISCSI_HDR, pdu len "
 				"mismatch %u != %u + %u, seq 0x%x\n",
 				csk->tid, ISCSI_PDU_LEN(pdu_len_ddp) - 40,
 				hlen, dlen, cxgbi_skcb_tcp_seq(skb));
@@ -911,7 +912,7 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 		csk->rcv_nxt += cxgbi_skcb_rx_pdulen(skb);
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, skb 0x%p, 0x%x,%u+%u,0x%x,0x%x.\n",
+			"csk 0x%p, skb 0x%p, 0x%x,%u+%u,0x%x,0x%x\n",
 			csk, skb, *bhs, hlen, dlen,
 			ntohl(*((unsigned int *)(bhs + 16))),
 			ntohl(*((unsigned int *)(bhs + 24))));
@@ -921,7 +922,7 @@ static void do_rx_iscsi_hdr(struct cxgbi_device *cdev, struct sk_buff *skb)
 		cxgbi_skcb_set_flag(lskb, SKCBF_RX_DATA);
 
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p,%u,0x%lx, skb 0x%p data, 0x%p.\n",
+			"csk 0x%p,%u,0x%lx, skb 0x%p data, 0x%p\n",
 			csk, csk->state, csk->flags, skb, lskb);
 	}
 
@@ -950,19 +951,19 @@ static void do_rx_data_ddp(struct cxgbi_device *cdev,
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		log_error("can't find connection for tid %u\n", tid);
+		pr_err("can't find connection for tid %u\n", tid);
 		goto rel_skb;
 	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lx, skb 0x%p,0x%x, lhdr 0x%p.\n",
+		"csk 0x%p,%u,0x%lx, skb 0x%p,0x%x, lhdr 0x%p\n",
 		csk, csk->state, csk->flags, skb, status, csk->skb_ulp_lhdr);
 
 	spin_lock_bh(&csk->lock);
 
 	if (unlikely(csk->state >= CTP_PASSIVE_CLOSE)) {
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-			"csk 0x%p,%u,0x%lx,%u, bad state.\n",
+			"csk 0x%p,%u,0x%lx,%u, bad state\n",
 			csk, csk->state, csk->flags, csk->tid);
 		if (csk->state != CTP_ABORTING)
 			goto abort_conn;
@@ -971,7 +972,7 @@ static void do_rx_data_ddp(struct cxgbi_device *cdev,
 	}
 
 	if (!csk->skb_ulp_lhdr) {
-		log_error("tid 0x%x, rcv RX_DATA_DDP w/o pdu bhs.\n", csk->tid);
+		pr_err("tid 0x%x, rcv RX_DATA_DDP w/o pdu bhs\n", csk->tid);
 		goto abort_conn;
 	}
 
@@ -982,36 +983,36 @@ static void do_rx_data_ddp(struct cxgbi_device *cdev,
 	cxgbi_skcb_rx_ddigest(lskb) = ntohl(rpl->ulp_crc);
 
 	if (ntohs(rpl->len) != cxgbi_skcb_rx_pdulen(lskb))
-		log_info("tid 0x%x, RX_DATA_DDP pdulen %u != %u.\n",
+		pr_info("tid 0x%x, RX_DATA_DDP pdulen %u != %u\n",
 			csk->tid, ntohs(rpl->len), cxgbi_skcb_rx_pdulen(lskb));
 
 	if (status & (1 << CPL_RX_DDP_STATUS_HCRC_SHIFT)) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, lhdr 0x%p, status 0x%x, hcrc bad.\n",
+			"csk 0x%p, lhdr 0x%p, status 0x%x, hcrc bad\n",
 			csk, lskb, status);
 		cxgbi_skcb_set_flag(lskb, SKCBF_RX_HCRC_ERR);
 	}
 	if (status & (1 << CPL_RX_DDP_STATUS_DCRC_SHIFT)) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, lhdr 0x%p, status 0x%x, dcrc bad.\n",
+			"csk 0x%p, lhdr 0x%p, status 0x%x, dcrc bad\n",
 			csk, lskb, status);
 		cxgbi_skcb_set_flag(lskb, SKCBF_RX_DCRC_ERR);
 	}
 	if (status & (1 << CPL_RX_DDP_STATUS_PAD_SHIFT)) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, lhdr 0x%p, status 0x%x, pad bad.\n",
+			"csk 0x%p, lhdr 0x%p, status 0x%x, pad bad\n",
 			csk, lskb, status);
 		cxgbi_skcb_set_flag(lskb, SKCBF_RX_PAD_ERR);
 	}
 	if ((status & (1 << CPL_RX_DDP_STATUS_DDP_SHIFT)) &&
 		!cxgbi_skcb_test_flag(lskb, SKCBF_RX_DATA)) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, lhdr 0x%p, 0x%x, data ddp'ed.\n",
+			"csk 0x%p, lhdr 0x%p, 0x%x, data ddp'ed\n",
 			csk, lskb, status);
 		cxgbi_skcb_set_flag(lskb, SKCBF_RX_DATA_DDPD);
 	}
 	log_debug(1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p, lskb 0x%p, f 0x%lx.\n",
+		"csk 0x%p, lskb 0x%p, f 0x%lx\n",
 		csk, lskb, cxgbi_skcb_flags(lskb));
 
 	cxgbi_conn_pdu_ready(csk);
@@ -1036,10 +1037,10 @@ static void do_fw4_ack(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk))
-		log_error("can't find connection for tid %u\n", tid);
+		pr_err("can't find connection for tid %u\n", tid);
 	else {
 		log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-			"csk 0x%p,%u,0x%lx,%u.\n",
+			"csk 0x%p,%u,0x%lx,%u\n",
 			csk, csk->state, csk->flags, csk->tid);
 		cxgbi_sock_rcv_wr_ack(csk, rpl->credits, ntohl(rpl->snd_una),
 					rpl->seq_vld);
@@ -1057,14 +1058,14 @@ static void do_set_tcb_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (!csk)
-		log_error("can't find conn. for tid %u\n", tid);
+		pr_err("can't find conn. for tid %u\n", tid);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,%lx,%u, status 0x%x.\n",
+		"csk 0x%p,%u,%lx,%u, status 0x%x\n",
 		csk, csk->state, csk->flags, csk->tid, rpl->status);
 
 	if (rpl->status != CPL_ERR_NONE)
-		log_error("csk 0x%p,%u, SET_TCB_RPL status %u.\n",
+		pr_err("csk 0x%p,%u, SET_TCB_RPL status %u\n",
 			csk, tid, rpl->status);
 
 	__kfree_skb(skb);
@@ -1107,7 +1108,7 @@ static void release_offload_resources(struct cxgbi_sock *csk)
 	struct cxgb4_lld_info *lldi;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	cxgbi_sock_free_cpl_skbs(csk);
@@ -1139,12 +1140,12 @@ static int init_act_open(struct cxgbi_sock *csk)
 	unsigned int step;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx,%u.\n",
+		"csk 0x%p,%u,0x%lx,%u\n",
 		csk, csk->state, csk->flags, csk->tid);
 
 	csk->atid = cxgb4_alloc_atid(lldi->tids, csk);
 	if (csk->atid < 0) {
-		log_error("%s, NO atid available.\n", ndev->name);
+		pr_err("%s, NO atid available\n", ndev->name);
 		return -EINVAL;
 	}
 	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
@@ -1152,7 +1153,7 @@ static int init_act_open(struct cxgbi_sock *csk)
 
 	csk->l2t = cxgb4_l2t_get(lldi->l2t, csk->dst->neighbour, ndev, 0);
 	if (!csk->l2t) {
-		log_error("%s, cannot alloc l2t.\n", ndev->name);
+		pr_err("%s, cannot alloc l2t\n", ndev->name);
 		goto rel_resource;
 	}
 	cxgbi_sock_get(csk);
@@ -1178,7 +1179,7 @@ static int init_act_open(struct cxgbi_sock *csk)
 	cxgbi_sock_reset_wr_list(csk);
 	csk->err = 0;
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,p%d,%s, %u,%u,%u, mss %u,%u, smac %u.\n",
+		"csk 0x%p,p%d,%s, %u,%u,%u, mss %u,%u, smac %u\n",
 		csk, pi->port_id, ndev->name, csk->tx_chan,
 		csk->txq_idx, csk->rss_qid, csk->mtu, csk->mss_idx,
 		csk->smac_idx);
@@ -1226,7 +1227,7 @@ int cxgb4i_ofld_init(struct cxgbi_device *cdev)
 	cdev->csk_alloc_cpls = alloc_cpls;
 	cdev->csk_init_act_open = init_act_open;
 
-	log_info("cdev 0x%p, offload up, added.\n", cdev);
+	pr_info("cdev 0x%p, offload up, added\n", cdev);
 	return 0;
 }
 
@@ -1269,7 +1270,7 @@ static int ddp_ppod_write_sgl(struct cxgbi_device *cdev, unsigned int port_id,
 
 	skb = alloc_cpl(sizeof(*req) + sizeof(*sgl), dlen, GFP_ATOMIC);
 	if (!skb) {
-		log_error("cdev 0x%p, idx %u, npods %u, OOM\n",
+		pr_err("cdev 0x%p, idx %u, npods %u, OOM\n",
 			cdev, idx, npods);
 		return -ENOMEM;
 	}
@@ -1356,7 +1357,7 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk, unsigned int tid,
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->port_id);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, tid 0x%x, pg_idx %u.\n", csk, csk->tid, pg_idx);
+		"csk 0x%p, tid 0x%x, pg_idx %u\n", csk, csk->tid, pg_idx);
 
 	cxgb4_ofld_send(csk->cdev->ports[csk->port_id], skb);
 	return 0;
@@ -1389,7 +1390,7 @@ static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->port_id);
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, tid 0x%x, crc %d,%d.\n", csk, csk->tid, hcrc, dcrc);
+		"csk 0x%p, tid 0x%x, crc %d,%d\n", csk, csk->tid, hcrc, dcrc);
 
 	cxgb4_ofld_send(csk->cdev->ports[csk->port_id], skb);
 	return 0;
@@ -1404,7 +1405,7 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 
 	if (ddp) {
 		kref_get(&ddp->refcnt);
-		log_warn("cdev 0x%p, ddp 0x%p already set up\n",
+		pr_warn("cdev 0x%p, ddp 0x%p already set up\n",
 			cdev, cdev->ddp);
 		return -EALREADY;
 	}
@@ -1428,15 +1429,15 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 	cdev->csk_ddp_set = ddp_set_map;
 	cdev->csk_ddp_clear = ddp_clear_map;
 
-	log_info("cxgb4i 0x%p tag: sw %u, rsvd %u,%u, mask 0x%x.\n",
+	pr_info("cxgb4i 0x%p tag: sw %u, rsvd %u,%u, mask 0x%x\n",
 		cdev, cdev->tag_format.sw_bits, cdev->tag_format.rsvd_bits,
 		cdev->tag_format.rsvd_shift, cdev->tag_format.rsvd_mask);
-	log_info("cxgb4i 0x%p, nppods %u, bits %u, mask 0x%x,0x%x pkt %u/%u, "
-		" %u/%u\n",
+	pr_info("cxgb4i 0x%p, nppods %u, bits %u, mask 0x%x,0x%x pkt %u/%u, "
+		"%u/%u\n",
 		cdev, ddp->nppods, ddp->idx_bits, ddp->idx_mask,
 		ddp->rsvd_tag_mask, ddp->max_txsz, lldi->iscsi_iolen,
 		ddp->max_rxsz, lldi->iscsi_iolen);
-	log_info("cxgb4i 0x%p max payload size: %u/%u, %u/%u.\n",
+	pr_info("cxgb4i 0x%p max payload size: %u/%u, %u/%u\n",
 		cdev, cdev->tx_max_size, ddp->max_txsz, cdev->rx_max_size,
 		ddp->max_rxsz);
 	return 0;
@@ -1450,16 +1451,16 @@ static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
 
 	cdev = cxgbi_device_register(sizeof(*lldi), lldi->nports);
 	if (!cdev) {
-		log_info("t4 device 0x%p, register failed.\n", lldi);
+		pr_info("t4 device 0x%p, register failed\n", lldi);
 		return NULL;
 	}
-	log_info("0x%p,0x%x, ports %u,%s, chan %u, q %u,%u, wr %u.\n",
+	pr_info("0x%p,0x%x, ports %u,%s, chan %u, q %u,%u, wr %u\n",
 		cdev, lldi->adapter_type, lldi->nports,
 		lldi->ports[0]->name, lldi->nchan, lldi->ntxq,
 		lldi->nrxq, lldi->wr_cred);
 	for (i = 0; i < lldi->nrxq; i++)
 		log_debug(1 << CXGBI_DBG_DEV,
-			"t4 0x%p, rxq id #%d: %u.\n",
+			"t4 0x%p, rxq id #%d: %u\n",
 			cdev, i, lldi->rxq_ids[i]);
 
 	memcpy(cxgbi_cdev_priv(cdev), lldi, sizeof(*lldi));
@@ -1478,12 +1479,12 @@ static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
 
 	rc = cxgb4i_ddp_init(cdev);
 	if (rc) {
-		log_info("t4 0x%p ddp init failed\n", cdev);
+		pr_info("t4 0x%p ddp init failed\n", cdev);
 		goto err_out;
 	}
 	rc = cxgb4i_ofld_init(cdev);
 	if (rc) {
-		log_info("t4 0x%p ofld init failed\n", cdev);
+		pr_info("t4 0x%p ofld init failed\n", cdev);
 		goto err_out;
 	}
 
@@ -1521,7 +1522,7 @@ static int t4_uld_rx_handler(void *handle, const __be64 *rsp,
 		skb_copy_to_linear_data(skb, &rsp[1], len);
 	} else {
 		if (unlikely(*(u8 *)rsp != *(u8 *)pgl->va)) {
-			log_info("? FL 0x%p,RSS%#llx,FL %#llx,len %u.\n",
+			pr_info("? FL 0x%p,RSS%#llx,FL %#llx,len %u\n",
 				pgl->va, be64_to_cpu(*rsp),
 				be64_to_cpu(*(u64 *)pgl->va),
 				pgl->tot_len);
@@ -1540,7 +1541,7 @@ static int t4_uld_rx_handler(void *handle, const __be64 *rsp,
 	if (cxgb4i_cplhandlers[opc])
 		cxgb4i_cplhandlers[opc](cdev, skb);
 	else {
-		log_error("No handler for opcode 0x%x\n", opc);
+		pr_err("No handler for opcode 0x%x\n", opc);
 		__kfree_skb(skb);
 	}
 	return 0;
@@ -1555,21 +1556,21 @@ static int t4_uld_state_change(void *handle, enum cxgb4_state state)
 
 	switch (state) {
 	case CXGB4_STATE_UP:
-		log_info("cdev 0x%p, UP.\n", cdev);
+		pr_info("cdev 0x%p, UP\n", cdev);
 		/* re-initialize */
 		break;
 	case CXGB4_STATE_START_RECOVERY:
-		log_info("cdev 0x%p, RECOVERY.\n", cdev);
+		pr_info("cdev 0x%p, RECOVERY\n", cdev);
 		/* close all connections */
 		break;
 	case CXGB4_STATE_DOWN:
-		log_info("cdev 0x%p, DOWN.\n", cdev);
+		pr_info("cdev 0x%p, DOWN\n", cdev);
 		break;
 	case CXGB4_STATE_DETACH:
-		log_info("cdev 0x%p, DETACH.\n", cdev);
+		pr_info("cdev 0x%p, DETACH\n", cdev);
 		break;
 	default:
-		log_info("cdev 0x%p, unknown state %d.\n", cdev, state);
+		pr_info("cdev 0x%p, unknown state %d\n", cdev, state);
 		break;
 	}
 	return 0;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 95c13b4..e29b326 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -11,6 +11,8 @@
  * Written by: Rakesh Ranjan (rranjan@chelsio.com)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/skbuff.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
@@ -60,7 +62,7 @@ int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
 					     sizeof(struct cxgbi_sock *),
 					     GFP_KERNEL);
 	if (!pmap->port_csk) {
-		log_warn("cdev 0x%p, portmap OOM %u.\n", cdev, max_conn);
+		pr_warn("cdev 0x%p, portmap OOM %u\n", cdev, max_conn);
 		return -ENOMEM;
 	}
 
@@ -82,7 +84,7 @@ void cxgbi_device_portmap_cleanup(struct cxgbi_device *cdev)
 			csk = pmap->port_csk[i];
 			pmap->port_csk[i] = NULL;
 			log_debug(1 << CXGBI_DBG_SOCK,
-				"csk 0x%p, cdev 0x%p, offload down.\n",
+				"csk 0x%p, cdev 0x%p, offload down\n",
 				csk, cdev);
 			spin_lock_bh(&csk->lock);
 			cxgbi_sock_set_flag(csk, CTPF_OFFLOAD_DOWN);
@@ -97,7 +99,7 @@ EXPORT_SYMBOL_GPL(cxgbi_device_portmap_cleanup);
 static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
 {
 	log_debug(1 << CXGBI_DBG_DEV,
-		"cdev 0x%p, p# %u.\n", cdev, cdev->nports);
+		"cdev 0x%p, p# %u\n", cdev, cdev->nports);
 	cxgbi_hbas_remove(cdev);
 	cxgbi_device_portmap_cleanup(cdev);
 	if (cdev->dev_ddp_cleanup)
@@ -121,7 +123,7 @@ struct cxgbi_device *cxgbi_device_register(unsigned int extra,
 			 sizeof(struct net_device *)),
 			GFP_KERNEL);
 	if (!cdev) {
-		log_warn("nport %d, OOM.\n", nports);
+		pr_warn("nport %d, OOM\n", nports);
 		return NULL;
 	}
 	cdev->ports = (struct net_device **)(cdev + 1);
@@ -137,7 +139,7 @@ struct cxgbi_device *cxgbi_device_register(unsigned int extra,
 	mutex_unlock(&cdev_mutex);
 
 	log_debug(1 << CXGBI_DBG_DEV,
-		"cdev 0x%p, p# %u.\n", cdev, nports);
+		"cdev 0x%p, p# %u\n", cdev, nports);
 	return cdev;
 }
 EXPORT_SYMBOL_GPL(cxgbi_device_register);
@@ -145,7 +147,7 @@ EXPORT_SYMBOL_GPL(cxgbi_device_register);
 void cxgbi_device_unregister(struct cxgbi_device *cdev)
 {
 	log_debug(1 << CXGBI_DBG_DEV,
-		"cdev 0x%p, p# %u,%s.\n",
+		"cdev 0x%p, p# %u,%s\n",
 		cdev, cdev->nports, cdev->nports ? cdev->ports[0]->name : "");
 	mutex_lock(&cdev_mutex);
 	list_del(&cdev->list_head);
@@ -162,7 +164,7 @@ void cxgbi_device_unregister_all(unsigned int flag)
 	list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
 		if ((cdev->flags & flag) == flag) {
 			log_debug(1 << CXGBI_DBG_DEV,
-				"cdev 0x%p, p# %u,%s.\n",
+				"cdev 0x%p, p# %u,%s\n",
 				cdev, cdev->nports, cdev->nports ?
 				 cdev->ports[0]->name : "");
 			list_del(&cdev->list_head);
@@ -186,7 +188,7 @@ struct cxgbi_device *cxgbi_device_find_by_lldev(void *lldev)
 	}
 	mutex_unlock(&cdev_mutex);
 	log_debug(1 << CXGBI_DBG_DEV,
-		"lldev 0x%p, NO match found.\n", lldev);
+		"lldev 0x%p, NO match found\n", lldev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(cxgbi_device_find_by_lldev);
@@ -213,7 +215,7 @@ static struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *ndev,
 	}
 	mutex_unlock(&cdev_mutex);
 	log_debug(1 << CXGBI_DBG_DEV,
-		"ndev 0x%p, %s, NO match found.\n", ndev, ndev->name);
+		"ndev 0x%p, %s, NO match found\n", ndev, ndev->name);
 	return NULL;
 }
 
@@ -230,7 +232,7 @@ struct cxgbi_hba *cxgbi_hba_find_by_netdev(struct net_device *dev,
 			return cdev->hbas[i];
 	}
 	log_debug(1 << CXGBI_DBG_DEV,
-		"ndev 0x%p, %s, cdev 0x%p, NO match found.\n",
+		"ndev 0x%p, %s, cdev 0x%p, NO match found\n",
 		dev, dev->name, cdev);
 	return NULL;
 }
@@ -241,7 +243,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 	struct cxgbi_hba *chba;
 
 	log_debug(1 << CXGBI_DBG_DEV,
-		"cdev 0x%p, p#%u.\n", cdev, cdev->nports);
+		"cdev 0x%p, p#%u\n", cdev, cdev->nports);
 
 	for (i = 0; i < cdev->nports; i++) {
 		chba = cdev->hbas[i];
@@ -263,12 +265,12 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, unsigned int max_lun,
 	struct Scsi_Host *shost;
 	int i, err;
 
-	log_debug(1 << CXGBI_DBG_DEV, "cdev 0x%p, p#%u.\n", cdev, cdev->nports);
+	log_debug(1 << CXGBI_DBG_DEV, "cdev 0x%p, p#%u\n", cdev, cdev->nports);
 
 	for (i = 0; i < cdev->nports; i++) {
 		shost = iscsi_host_alloc(sht, sizeof(*chba), 1);
 		if (!shost) {
-			log_info("0x%p, p%d, %s, host alloc failed\n",
+			pr_info("0x%p, p%d, %s, host alloc failed\n",
 				cdev, i, cdev->ports[i]->name);
 			err = -ENOMEM;
 			goto err_out;
@@ -292,7 +294,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, unsigned int max_lun,
 		pci_dev_get(cdev->pdev);
 		err = iscsi_host_add(shost, &cdev->pdev->dev);
 		if (err) {
-			log_info("cdev 0x%p, p#%d %s, host add failed.\n",
+			pr_info("cdev 0x%p, p#%d %s, host add failed\n",
 				cdev, i, cdev->ports[i]->name);
 			pci_dev_put(cdev->pdev);
 			scsi_host_put(shost);
@@ -332,21 +334,21 @@ static int sock_get_port(struct cxgbi_sock *csk)
 	int idx;
 
 	if (!pmap->max_connect) {
-		log_error("cdev 0x%p, p#%u %s, NO port map.\n",
-			   cdev, csk->port_id, cdev->ports[csk->port_id]->name);
+		pr_err("cdev 0x%p, p#%u %s, NO port map\n",
+		       cdev, csk->port_id, cdev->ports[csk->port_id]->name);
 		return -EADDRNOTAVAIL;
 	}
 
 	if (csk->saddr.sin_port) {
-		log_error("source port NON-ZERO %u.\n",
-			ntohs(csk->saddr.sin_port));
+		pr_err("source port NON-ZERO %u\n",
+		       ntohs(csk->saddr.sin_port));
 		return -EADDRINUSE;
 	}
 
 	spin_lock_bh(&pmap->lock);
 	if (pmap->used >= pmap->max_connect) {
 		spin_unlock_bh(&pmap->lock);
-		log_info("cdev 0x%p, p#%u %s, ALL ports used.\n",
+		pr_info("cdev 0x%p, p#%u %s, ALL ports used\n",
 			cdev, csk->port_id, cdev->ports[csk->port_id]->name);
 		return -EADDRNOTAVAIL;
 	}
@@ -364,7 +366,7 @@ static int sock_get_port(struct cxgbi_sock *csk)
 			spin_unlock_bh(&pmap->lock);
 			cxgbi_sock_get(csk);
 			log_debug(1 << CXGBI_DBG_SOCK,
-				"cdev 0x%p, p#%u %s, p %u, %u.\n",
+				"cdev 0x%p, p#%u %s, p %u, %u\n",
 				cdev, csk->port_id,
 				cdev->ports[csk->port_id]->name,
 				pmap->sport_base + idx, pmap->next);
@@ -374,7 +376,7 @@ static int sock_get_port(struct cxgbi_sock *csk)
 	spin_unlock_bh(&pmap->lock);
 
 	/* should not happen */
-	log_warn("cdev 0x%p, p#%u %s, next %u?\n",
+	pr_warn("cdev 0x%p, p#%u %s, next %u?\n",
 		cdev, csk->port_id, cdev->ports[csk->port_id]->name,
 		pmap->next);
 	return -EADDRNOTAVAIL;
@@ -390,10 +392,10 @@ static void sock_put_port(struct cxgbi_sock *csk)
 
 		csk->saddr.sin_port = 0;
 		if (idx < 0 || idx >= pmap->max_connect) {
-			log_error("cdev 0x%p, p#%u %s, port %u OOR.\n",
-				cdev, csk->port_id,
-				cdev->ports[csk->port_id]->name,
-				ntohs(csk->saddr.sin_port));
+			pr_err("cdev 0x%p, p#%u %s, port %u OOR\n",
+			       cdev, csk->port_id,
+			       cdev->ports[csk->port_id]->name,
+			       ntohs(csk->saddr.sin_port));
 			return;
 		}
 
@@ -403,7 +405,7 @@ static void sock_put_port(struct cxgbi_sock *csk)
 		spin_unlock_bh(&pmap->lock);
 
 		log_debug(1 << CXGBI_DBG_SOCK,
-			"cdev 0x%p, p#%u %s, release %u.\n",
+			"cdev 0x%p, p#%u %s, release %u\n",
 			cdev, csk->port_id, cdev->ports[csk->port_id]->name,
 			pmap->sport_base + idx);
 
@@ -436,12 +438,12 @@ static struct cxgbi_sock *cxgbi_sock_create(struct cxgbi_device *cdev)
 	struct cxgbi_sock *csk = kzalloc(sizeof(*csk), GFP_NOIO);
 
 	if (!csk) {
-		log_info("alloc csk %lu failed.\n", sizeof(*csk));
+		pr_info("alloc csk %u failed\n", sizeof(*csk));
 		return NULL;
 	}
 
 	if (cdev->csk_alloc_cpls(csk) < 0) {
-		log_info("csk 0x%p, alloc cpls failed.\n", csk);
+		pr_info("csk 0x%p, alloc cpls failed\n", csk);
 		kfree(csk);
 		return NULL;
 	}
@@ -456,7 +458,7 @@ static struct cxgbi_sock *cxgbi_sock_create(struct cxgbi_device *cdev)
 	csk->flags = 0;
 	cxgbi_sock_set_state(csk, CTP_CLOSED);
 
-	log_debug(1 << CXGBI_DBG_SOCK, "cdev 0x%p, new csk 0x%p.\n", cdev, csk);
+	log_debug(1 << CXGBI_DBG_SOCK, "cdev 0x%p, new csk 0x%p\n", cdev, csk);
 
 	return csk;
 }
@@ -500,7 +502,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	int err = 0;
 
 	if (daddr->sin_family != AF_INET) {
-		log_info("address family 0x%x NOT supported.\n",
+		pr_info("address family 0x%x NOT supported\n",
 			daddr->sin_family);
 		err = -EAFNOSUPPORT;
 		goto err_out;
@@ -508,7 +510,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 
 	rt = find_route_ipv4(0, daddr->sin_addr.s_addr, 0, daddr->sin_port, 0);
 	if (!rt) {
-		log_info("no route to ipv4 0x%x, port %u.\n",
+		pr_info("no route to ipv4 0x%x, port %u\n",
 			daddr->sin_addr.s_addr, daddr->sin_port);
 		err = -ENETUNREACH;
 		goto err_out;
@@ -517,7 +519,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	ndev = dst->neighbour->dev;
 
 	if (rt->rt_flags & (RTCF_MULTICAST | RTCF_BROADCAST)) {
-		log_info("multi-cast route %pI4, port %u, dev %s.\n",
+		pr_info("multi-cast route %pI4, port %u, dev %s\n",
 			&daddr->sin_addr.s_addr, ntohs(daddr->sin_port),
 			ndev->name);
 		err = -ENETUNREACH;
@@ -527,25 +529,25 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	if (ndev->flags & IFF_LOOPBACK) {
 		ndev = ip_dev_find(&init_net, daddr->sin_addr.s_addr);
 		mtu = ndev->mtu;
-		log_info("rt dev %s, loopback -> %s, mtu %u.\n",
+		pr_info("rt dev %s, loopback -> %s, mtu %u\n",
 			dst->neighbour->dev->name, ndev->name, mtu);
 	}
 
 	if (ndev->priv_flags & IFF_802_1Q_VLAN) {
 		ndev = vlan_dev_real_dev(ndev);
-		log_info("rt dev %s, vlan -> %s.\n",
+		pr_info("rt dev %s, vlan -> %s\n",
 			dst->neighbour->dev->name, ndev->name);
 	}
 
 	cdev = cxgbi_device_find_by_netdev(ndev, &port);
 	if (!cdev) {
-		log_info("dst %pI4, %s, NOT cxgbi device.\n",
+		pr_info("dst %pI4, %s, NOT cxgbi device\n",
 			&daddr->sin_addr.s_addr, ndev->name);
 		err = -ENETUNREACH;
 		goto rel_rt;
 	}
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"route to %pI4 :%u, ndev p#%d,%s, cdev 0x%p.\n",
+		"route to %pI4 :%u, ndev p#%d,%s, cdev 0x%p\n",
 		&daddr->sin_addr.s_addr, ntohs(daddr->sin_port),
 			   port, ndev->name, cdev);
 
@@ -588,7 +590,7 @@ EXPORT_SYMBOL_GPL(cxgbi_sock_established);
 static void cxgbi_inform_iscsi_conn_closing(struct cxgbi_sock *csk)
 {
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"csk 0x%p, state %u, flags 0x%lx, conn 0x%p.\n",
+		"csk 0x%p, state %u, flags 0x%lx, conn 0x%p\n",
 		csk, csk->state, csk->flags, csk->user_data);
 
 	if (csk->state != CTP_ESTABLISHED) {
@@ -651,11 +653,11 @@ static void need_active_close(struct cxgbi_sock *csk)
 
 void cxgbi_sock_fail_act_open(struct cxgbi_sock *csk, int errno)
 {
-	log_info("csk 0x%p,%u,%lx, %pI4:%u-%pI4:%u, err %d.\n",
-			csk, csk->state, csk->flags,
-			&csk->saddr.sin_addr.s_addr, csk->saddr.sin_port,
-			&csk->daddr.sin_addr.s_addr, csk->daddr.sin_port,
-			errno);
+	pr_info("csk 0x%p,%u,%lx, %pI4:%u-%pI4:%u, err %d\n",
+		csk, csk->state, csk->flags,
+		&csk->saddr.sin_addr.s_addr, csk->saddr.sin_port,
+		&csk->daddr.sin_addr.s_addr, csk->daddr.sin_port,
+		errno);
 
 	cxgbi_sock_set_state(csk, CTP_CONNECTING);
 	csk->err = errno;
@@ -689,8 +691,8 @@ void cxgbi_sock_rcv_abort_rpl(struct cxgbi_sock *csk)
 			cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_RCVD);
 			cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_PENDING);
 			if (cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD))
-				log_error("csk 0x%p,%u,0x%lx,%u,ABT_RPL_RSS.\n",
-					csk, csk->state, csk->flags, csk->tid);
+				pr_err("csk 0x%p,%u,0x%lx,%u,ABT_RPL_RSS\n",
+				       csk, csk->state, csk->flags, csk->tid);
 			cxgbi_sock_closed(csk);
 		}
 	}
@@ -721,8 +723,8 @@ void cxgbi_sock_rcv_peer_close(struct cxgbi_sock *csk)
 	case CTP_ABORTING:
 		break;
 	default:
-		log_error("csk 0x%p,%u,0x%lx,%u, bad state.\n",
-			csk, csk->state, csk->flags, csk->tid);
+		pr_err("csk 0x%p,%u,0x%lx,%u, bad state\n",
+		       csk, csk->state, csk->flags, csk->tid);
 	}
 	cxgbi_inform_iscsi_conn_closing(csk);
 done:
@@ -752,8 +754,8 @@ void cxgbi_sock_rcv_close_conn_rpl(struct cxgbi_sock *csk, u32 snd_nxt)
 	case CTP_ABORTING:
 		break;
 	default:
-		log_error("csk 0x%p,%u,0x%lx,%u, bad state.\n",
-			csk, csk->state, csk->flags, csk->tid);
+		pr_err("csk 0x%p,%u,0x%lx,%u, bad state\n",
+		       csk, csk->state, csk->flags, csk->tid);
 	}
 done:
 	spin_unlock_bh(&csk->lock);
@@ -765,7 +767,7 @@ void cxgbi_sock_rcv_wr_ack(struct cxgbi_sock *csk, unsigned int credits,
 			   unsigned int snd_una, int seq_chk)
 {
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
-			"csk 0x%p,%u,0x%lx,%u, cr %u,%u+%u, snd_una %u,%d.\n",
+			"csk 0x%p,%u,0x%lx,%u, cr %u,%u+%u, snd_una %u,%d\n",
 			csk, csk->state, csk->flags, csk->tid, credits,
 			csk->wr_cred, csk->wr_una_cred, snd_una, seq_chk);
 
@@ -779,15 +781,15 @@ void cxgbi_sock_rcv_wr_ack(struct cxgbi_sock *csk, unsigned int credits,
 		struct sk_buff *p = cxgbi_sock_peek_wr(csk);
 
 		if (unlikely(!p)) {
-			log_error("csk 0x%p,%u,0x%lx,%u, cr %u,%u+%u, empty.\n",
-					csk, csk->state, csk->flags, csk->tid,
-					credits, csk->wr_cred,
-					csk->wr_una_cred);
+			pr_err("csk 0x%p,%u,0x%lx,%u, cr %u,%u+%u, empty\n",
+			       csk, csk->state, csk->flags, csk->tid,
+			       credits, csk->wr_cred,
+			       csk->wr_una_cred);
 			break;
 		}
 
 		if (unlikely(credits < p->csum)) {
-			log_warn("csk 0x%p,%u,0x%lx,%u, cr %u,%u+%u, < %u.\n",
+			pr_warn("csk 0x%p,%u,0x%lx,%u, cr %u,%u+%u, < %u\n",
 				csk, csk->state, csk->flags, csk->tid,
 				credits, csk->wr_cred, csk->wr_una_cred,
 				p->csum);
@@ -804,7 +806,7 @@ void cxgbi_sock_rcv_wr_ack(struct cxgbi_sock *csk, unsigned int credits,
 
 	if (seq_chk) {
 		if (unlikely(before(snd_una, csk->snd_una))) {
-			log_warn("csk 0x%p,%u,0x%lx,%u, snd_una %u/%u.",
+			pr_warn("csk 0x%p,%u,0x%lx,%u, snd_una %u/%u\n",
 				csk, csk->state, csk->flags, csk->tid, snd_una,
 				csk->snd_una);
 			goto done;
@@ -875,8 +877,8 @@ void cxgbi_sock_check_wr_invariants(const struct cxgbi_sock *csk)
 	int pending = cxgbi_sock_count_pending_wrs(csk);
 
 	if (unlikely(csk->wr_cred + pending != csk->wr_max_cred))
-		log_error("csk 0x%p, tid %u, credit %u + %u != %u.\n",
-			csk, csk->tid, csk->wr_cred, pending, csk->wr_max_cred);
+		pr_err("csk 0x%p, tid %u, credit %u + %u != %u\n",
+		       csk, csk->tid, csk->wr_cred, pending, csk->wr_max_cred);
 }
 EXPORT_SYMBOL_GPL(cxgbi_sock_check_wr_invariants);
 
@@ -890,7 +892,7 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 
 	if (csk->state != CTP_ESTABLISHED) {
 		log_debug(1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p,%u,0x%lx,%u, EAGAIN.\n",
+			"csk 0x%p,%u,0x%lx,%u, EAGAIN\n",
 			csk, csk->state, csk->flags, csk->tid);
 		err = -EAGAIN;
 		goto out_err;
@@ -898,7 +900,7 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 
 	if (csk->err) {
 		log_debug(1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p,%u,0x%lx,%u, EPIPE %d.\n",
+			"csk 0x%p,%u,0x%lx,%u, EPIPE %d\n",
 			csk, csk->state, csk->flags, csk->tid, csk->err);
 		err = -EPIPE;
 		goto out_err;
@@ -906,7 +908,7 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 
 	if (csk->write_seq - csk->snd_una >= cdev->snd_win) {
 		log_debug(1 << CXGBI_DBG_PDU_TX,
-			"csk 0x%p,%u,0x%lx,%u, FULL %u-%u >= %u.\n",
+			"csk 0x%p,%u,0x%lx,%u, FULL %u-%u >= %u\n",
 			csk, csk->state, csk->flags, csk->tid, csk->write_seq,
 			csk->snd_una, cdev->snd_win);
 		err = -ENOBUFS;
@@ -918,16 +920,16 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 				(skb->len != skb->data_len);
 
 		if (unlikely(skb_headroom(skb) < cdev->skb_tx_rsvd)) {
-			log_error("csk 0x%p, skb head %u < %u.\n",
-				csk, skb_headroom(skb), cdev->skb_tx_rsvd);
+			pr_err("csk 0x%p, skb head %u < %u\n",
+			       csk, skb_headroom(skb), cdev->skb_tx_rsvd);
 			err = -EINVAL;
 			goto out_err;
 		}
 
 		if (frags >= SKB_WR_LIST_SIZE) {
-			log_error("csk 0x%p, frags %d, %u,%u >%lu.\n",
-				csk, skb_shinfo(skb)->nr_frags, skb->len,
-				skb->data_len, SKB_WR_LIST_SIZE);
+			pr_err("csk 0x%p, frags %d, %u,%u >%lu\n",
+			       csk, skb_shinfo(skb)->nr_frags, skb->len,
+			       skb->data_len, SKB_WR_LIST_SIZE);
 			err = -EINVAL;
 			goto out_err;
 		}
@@ -982,7 +984,7 @@ static int ddp_adjust_page_table(void)
 	unsigned int base_order, order;
 
 	if (PAGE_SIZE < (1UL << ddp_page_shift[0])) {
-		log_info("PAGE_SIZE 0x%lx too small, min 0x%lx\n",
+		pr_info("PAGE_SIZE 0x%lx too small, min 0x%lx\n",
 			PAGE_SIZE, 1UL << ddp_page_shift[0]);
 		return -EINVAL;
 	}
@@ -1006,7 +1008,7 @@ static int ddp_find_page_index(unsigned long pgsz)
 		if (pgsz == (1UL << ddp_page_shift[i]))
 			return i;
 	}
-	log_info("ddp page size %lu not supported.\n", pgsz);
+	pr_info("ddp page size %lu not supported\n", pgsz);
 	return DDP_PGIDX_MAX;
 }
 
@@ -1016,14 +1018,14 @@ static void ddp_setup_host_page_size(void)
 		page_idx = ddp_find_page_index(PAGE_SIZE);
 
 		if (page_idx == DDP_PGIDX_MAX) {
-			log_info("system PAGE %lu, update hw.\n", PAGE_SIZE);
+			pr_info("system PAGE %lu, update hw\n", PAGE_SIZE);
 			if (ddp_adjust_page_table() < 0) {
-				log_info("PAGE %lu, disable ddp.\n", PAGE_SIZE);
+				pr_info("PAGE %lu, disable ddp\n", PAGE_SIZE);
 				return;
 			}
 			page_idx = ddp_find_page_index(PAGE_SIZE);
 		}
-		log_info("system PAGE %lu, ddp idx %u.\n", PAGE_SIZE, page_idx);
+		pr_info("system PAGE %lu, ddp idx %u\n", PAGE_SIZE, page_idx);
 	}
 }
 
@@ -1070,7 +1072,7 @@ static inline int ddp_find_unused_entries(struct cxgbi_ddp_info *ddp,
 	/*  not enough entries */
 	if ((max - start) < count) {
 		log_debug(1 << CXGBI_DBG_DDP,
-			"NOT enough entries %u+%u < %u.\n", start, count, max);
+			"NOT enough entries %u+%u < %u\n", start, count, max);
 		return -EBUSY;
 	}
 
@@ -1091,7 +1093,7 @@ static inline int ddp_find_unused_entries(struct cxgbi_ddp_info *ddp,
 	}
 	spin_unlock(&ddp->map_lock);
 	log_debug(1 << CXGBI_DBG_DDP,
-		"NO suitable entries %u available.\n", count);
+		"NO suitable entries %u available\n", count);
 	return -EBUSY;
 }
 
@@ -1125,7 +1127,7 @@ static inline int ddp_gl_map(struct pci_dev *pdev,
 						PCI_DMA_FROMDEVICE);
 		if (unlikely(dma_mapping_error(&pdev->dev, gl->phys_addr[i]))) {
 			log_debug(1 << CXGBI_DBG_DDP,
-				"page %d 0x%p, 0x%p dma mapping err.\n",
+				"page %d 0x%p, 0x%p dma mapping err\n",
 				i, gl->pages[i], pdev);
 			goto unmap;
 		}
@@ -1166,7 +1168,7 @@ static struct cxgbi_gather_list *ddp_make_gl(unsigned int xferlen,
 
 	if (xferlen < DDP_THRESHOLD) {
 		log_debug(1 << CXGBI_DBG_DDP,
-			"xfer %u < threshold %u, no ddp.\n",
+			"xfer %u < threshold %u, no ddp\n",
 			xferlen, DDP_THRESHOLD);
 		return NULL;
 	}
@@ -1176,12 +1178,12 @@ static struct cxgbi_gather_list *ddp_make_gl(unsigned int xferlen,
 		     sizeof(struct page *)), gfp);
 	if (!gl) {
 		log_debug(1 << CXGBI_DBG_DDP,
-			"xfer %u, %u pages, OOM.\n", xferlen, npages);
+			"xfer %u, %u pages, OOM\n", xferlen, npages);
 		return NULL;
 	}
 
 	 log_debug(1 << CXGBI_DBG_DDP,
-		"xfer %u, sgl %u, gl max %u.\n", xferlen, sgcnt, npages);
+		"xfer %u, sgl %u, gl max %u\n", xferlen, sgcnt, npages);
 
 	gl->pages = (struct page **)&gl->phys_addr[npages];
 	gl->nelem = npages;
@@ -1203,7 +1205,7 @@ static struct cxgbi_gather_list *ddp_make_gl(unsigned int xferlen,
 			if ((j && sgoffset) || ((i != sgcnt - 1) &&
 			    ((sglen + sgoffset) & ~PAGE_MASK))) {
 				log_debug(1 << CXGBI_DBG_DDP,
-					"page %d/%u, %u + %u.\n",
+					"page %d/%u, %u + %u\n",
 					i, sgcnt, sgoffset, sglen);
 				goto error_out;
 			}
@@ -1211,7 +1213,7 @@ static struct cxgbi_gather_list *ddp_make_gl(unsigned int xferlen,
 			j++;
 			if (j == gl->nelem || sg->offset) {
 				log_debug(1 << CXGBI_DBG_DDP,
-					"page %d/%u, offset %u.\n",
+					"page %d/%u, offset %u\n",
 					j, gl->nelem, sg->offset);
 				goto error_out;
 			}
@@ -1245,19 +1247,19 @@ static void ddp_tag_release(struct cxgbi_hba *chba, u32 tag)
 		unsigned int npods;
 
 		if (!gl || !gl->nelem) {
-			log_warn("tag 0x%x, idx %u, gl 0x%p, %u\n",
+			pr_warn("tag 0x%x, idx %u, gl 0x%p, %u\n",
 				tag, idx, gl, gl ? gl->nelem : 0);
 			return;
 		}
 		npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
 		log_debug(1 << CXGBI_DBG_DDP,
-			"tag 0x%x, release idx %u, npods %u.\n",
+			"tag 0x%x, release idx %u, npods %u\n",
 			tag, idx, npods);
 		cdev->csk_ddp_clear(chba, tag, idx, npods);
 		ddp_unmark_entries(ddp, idx, npods);
 		ddp_release_gl(gl, ddp->pdev);
 	} else
-		log_warn("tag 0x%x, idx %u > max %u.\n", tag, idx, ddp->nppods);
+		pr_warn("tag 0x%x, idx %u > max %u\n", tag, idx, ddp->nppods);
 }
 
 static int ddp_tag_reserve(struct cxgbi_sock *csk, unsigned int tid,
@@ -1289,7 +1291,7 @@ static int ddp_tag_reserve(struct cxgbi_sock *csk, unsigned int tid,
 	}
 	if (idx < 0) {
 		log_debug(1 << CXGBI_DBG_DDP,
-			"xferlen %u, gl %u, npods %u NO DDP.\n",
+			"xferlen %u, gl %u, npods %u NO DDP\n",
 			gl->length, gl->nelem, npods);
 		return idx;
 	}
@@ -1318,7 +1320,7 @@ static int ddp_tag_reserve(struct cxgbi_sock *csk, unsigned int tid,
 
 	ddp->idx_last = idx;
 	log_debug(1 << CXGBI_DBG_DDP,
-		"xfer %u, gl %u,%u, tid 0x%x, tag 0x%x->0x%x(%u,%u).\n",
+		"xfer %u, gl %u,%u, tid 0x%x, tag 0x%x->0x%x(%u,%u)\n",
 		gl->length, gl->nelem, gl->offset, tid, sw_tag, tag, idx,
 		npods);
 	*tagp = tag;
@@ -1341,13 +1343,13 @@ int cxgbi_ddp_reserve(struct cxgbi_sock *csk, unsigned int *tagp,
 	if (page_idx >= DDP_PGIDX_MAX || !cdev->ddp ||
 	    xferlen < DDP_THRESHOLD) {
 		log_debug(1 << CXGBI_DBG_DDP,
-			"pgidx %u, xfer %u, NO ddp.\n", page_idx, xferlen);
+			"pgidx %u, xfer %u, NO ddp\n", page_idx, xferlen);
 		return -EINVAL;
 	}
 
 	if (!cxgbi_sw_tag_usable(tformat, sw_tag)) {
 		log_debug(1 << CXGBI_DBG_DDP,
-			"sw_tag 0x%x NOT usable.\n", sw_tag);
+			"sw_tag 0x%x NOT usable\n", sw_tag);
 		return -EINVAL;
 	}
 
@@ -1370,7 +1372,7 @@ static void ddp_destroy(struct kref *kref)
 	struct cxgbi_device *cdev = ddp->cdev;
 	int i = 0;
 
-	log_info("kref 0, destroy ddp 0x%p, cdev 0x%p.\n", ddp, cdev);
+	pr_info("kref 0, destroy ddp 0x%p, cdev 0x%p\n", ddp, cdev);
 
 	while (i < ddp->nppods) {
 		struct cxgbi_gather_list *gl = ddp->gl_map[i];
@@ -1378,7 +1380,7 @@ static void ddp_destroy(struct kref *kref)
 		if (gl) {
 			int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
 					>> PPOD_PAGES_SHIFT;
-			log_info("cdev 0x%p, ddp %d + %d.\n", cdev, i, npods);
+			pr_info("cdev 0x%p, ddp %d + %d\n", cdev, i, npods);
 			kfree(gl);
 			if (cdev->csk_ddp_free_gl_skb)
 				cdev->csk_ddp_free_gl_skb(ddp, i, npods);
@@ -1394,7 +1396,7 @@ int cxgbi_ddp_cleanup(struct cxgbi_device *cdev)
 	struct cxgbi_ddp_info *ddp = cdev->ddp;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"cdev 0x%p, release ddp 0x%p.\n", cdev, ddp);
+		"cdev 0x%p, release ddp 0x%p\n", cdev, ddp);
 	cdev->ddp = NULL;
 	if (ddp)
 		return kref_put(&ddp->refcnt, ddp_destroy);
@@ -1420,7 +1422,7 @@ int cxgbi_ddp_init(struct cxgbi_device *cdev,
 					 sizeof(struct sk_buff *)),
 				GFP_KERNEL);
 	if (!ddp) {
-		log_warn("cdev 0x%p, ddp ppmax %u OOM.\n", cdev, ppmax);
+		pr_warn("cdev 0x%p, ddp ppmax %u OOM\n", cdev, ppmax);
 		return -ENOMEM;
 	}
 	ddp->gl_map = (struct cxgbi_gather_list **)(ddp + 1);
@@ -1448,7 +1450,7 @@ int cxgbi_ddp_init(struct cxgbi_device *cdev,
 	cdev->tag_format.rsvd_shift = PPOD_IDX_SHIFT;
 	cdev->tag_format.rsvd_mask = (1 << cdev->tag_format.rsvd_bits) - 1;
 
-	log_info("%s tag format, sw %u, rsvd %u,%u, mask 0x%x.\n",
+	pr_info("%s tag format, sw %u, rsvd %u,%u, mask 0x%x\n",
 		cdev->ports[0]->name, cdev->tag_format.sw_bits,
 		cdev->tag_format.rsvd_bits, cdev->tag_format.rsvd_shift,
 		cdev->tag_format.rsvd_mask);
@@ -1459,7 +1461,7 @@ int cxgbi_ddp_init(struct cxgbi_device *cdev,
 				ddp->max_rxsz - ISCSI_PDU_NONPAYLOAD_LEN);
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"%s max payload size: %u/%u, %u/%u.\n",
+		"%s max payload size: %u/%u, %u/%u\n",
 		cdev->ports[0]->name, cdev->tx_max_size, ddp->max_txsz,
 		cdev->rx_max_size, ddp->max_rxsz);
 	return 0;
@@ -1482,7 +1484,7 @@ static void task_release_itt(struct iscsi_task *task, itt_t hdr_itt)
 	u32 tag = ntohl((__force u32)hdr_itt);
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		   "cdev 0x%p, release tag 0x%x.\n", chba->cdev, tag);
+		   "cdev 0x%p, release tag 0x%x\n", chba->cdev, tag);
 	if (sc &&
 	    (scsi_bidi_cmnd(sc) || sc->sc_data_direction == DMA_FROM_DEVICE) &&
 	    cxgbi_is_ddp_tag(tformat, tag))
@@ -1511,7 +1513,7 @@ static int task_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 					GFP_ATOMIC);
 		if (err < 0)
 			log_debug(1 << CXGBI_DBG_DDP,
-				"csk 0x%p, R task 0x%p, %u,%u, no ddp.\n",
+				"csk 0x%p, R task 0x%p, %u,%u, no ddp\n",
 				cconn->cep->csk, task, scsi_in(sc)->length,
 				scsi_in(sc)->table.nents);
 	}
@@ -1522,7 +1524,7 @@ static int task_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 	*hdr_itt = (__force itt_t)htonl(tag);
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"cdev 0x%p, task 0x%p, 0x%x(0x%x,0x%x)->0x%x/0x%x.\n",
+		"cdev 0x%p, task 0x%p, 0x%x(0x%x,0x%x)->0x%x/0x%x\n",
 		chba->cdev, task, sw_tag, task->itt, sess->age, tag, *hdr_itt);
 	return 0;
 }
@@ -1542,7 +1544,7 @@ void cxgbi_parse_pdu_itt(struct iscsi_conn *conn, itt_t itt, int *idx, int *age)
 		*age = (sw_bits >> cconn->task_idx_bits) & ISCSI_AGE_MASK;
 
 	log_debug(1 << CXGBI_DBG_DDP,
-		"cdev 0x%p, tag 0x%x/0x%x, -> 0x%x(0x%x,0x%x).\n",
+		"cdev 0x%p, tag 0x%x/0x%x, -> 0x%x(0x%x,0x%x)\n",
 		cdev, tag, itt, sw_bits, idx ? *idx : 0xFFFFF,
 		age ? *age : 0xFF);
 }
@@ -1554,7 +1556,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *csk)
 
 	if (conn) {
 		log_debug(1 << CXGBI_DBG_SOCK,
-			"csk 0x%p, cid %d.\n", csk, conn->id);
+			"csk 0x%p, cid %d\n", csk, conn->id);
 		iscsi_conn_queue_work(conn);
 	}
 }
@@ -1574,17 +1576,17 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 	bytes_read = iscsi_tcp_recv_skb(conn, skb, offset, offloaded, &status);
 	switch (status) {
 	case ISCSI_TCP_CONN_ERR:
-		log_info("skb 0x%p, off %u, %d, TCP_ERR.\n",
-			  skb, offset, offloaded);
+		pr_info("skb 0x%p, off %u, %d, TCP_ERR\n",
+			skb, offset, offloaded);
 		return -EIO;
 	case ISCSI_TCP_SUSPENDED:
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"skb 0x%p, off %u, %d, TCP_SUSPEND, rc %d.\n",
+			"skb 0x%p, off %u, %d, TCP_SUSPEND, rc %d\n",
 			skb, offset, offloaded, bytes_read);
 		/* no transfer - just have caller flush queue */
 		return bytes_read;
 	case ISCSI_TCP_SKB_DONE:
-		log_info("skb 0x%p, off %u, %d, TCP_SKB_DONE.\n",
+		pr_info("skb 0x%p, off %u, %d, TCP_SKB_DONE\n",
 			skb, offset, offloaded);
 		/*
 		 * pdus should always fit in the skb and we should get
@@ -1594,11 +1596,11 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 		return -EFAULT;
 	case ISCSI_TCP_SEGMENT_DONE:
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"skb 0x%p, off %u, %d, TCP_SEG_DONE, rc %d.\n",
+			"skb 0x%p, off %u, %d, TCP_SEG_DONE, rc %d\n",
 			skb, offset, offloaded, bytes_read);
 		return bytes_read;
 	default:
-		log_info("skb 0x%p, off %u, %d, invalid status %d.\n",
+		pr_info("skb 0x%p, off %u, %d, invalid status %d\n",
 			skb, offset, offloaded, status);
 		return -EINVAL;
 	}
@@ -1609,18 +1611,18 @@ static int skb_read_pdu_bhs(struct iscsi_conn *conn, struct sk_buff *skb)
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
-		"conn 0x%p, skb 0x%p, len %u, flag 0x%lx.\n",
+		"conn 0x%p, skb 0x%p, len %u, flag 0x%lx\n",
 		conn, skb, skb->len, cxgbi_skcb_flags(skb));
 
 	if (!iscsi_tcp_recv_segment_is_hdr(tcp_conn)) {
-		log_info("conn 0x%p, skb 0x%p, not hdr.\n", conn, skb);
+		pr_info("conn 0x%p, skb 0x%p, not hdr\n", conn, skb);
 		iscsi_conn_failure(conn, ISCSI_ERR_PROTO);
 		return -EIO;
 	}
 
 	if (conn->hdrdgst_en &&
 	    cxgbi_skcb_test_flag(skb, SKCBF_RX_HCRC_ERR)) {
-		log_info("conn 0x%p, skb 0x%p, hcrc.\n", conn, skb);
+		pr_info("conn 0x%p, skb 0x%p, hcrc\n", conn, skb);
 		iscsi_conn_failure(conn, ISCSI_ERR_HDR_DGST);
 		return -EIO;
 	}
@@ -1636,12 +1638,12 @@ static int skb_read_pdu_data(struct iscsi_conn *conn, struct sk_buff *lskb,
 	int opcode = tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
-		"conn 0x%p, skb 0x%p, len %u, flag 0x%lx.\n",
+		"conn 0x%p, skb 0x%p, len %u, flag 0x%lx\n",
 		conn, skb, skb->len, cxgbi_skcb_flags(skb));
 
 	if (conn->datadgst_en &&
 	    cxgbi_skcb_test_flag(lskb, SKCBF_RX_DCRC_ERR)) {
-		log_info("conn 0x%p, skb 0x%p, dcrc 0x%lx.\n",
+		pr_info("conn 0x%p, skb 0x%p, dcrc 0x%lx\n",
 			conn, lskb, cxgbi_skcb_flags(lskb));
 		iscsi_conn_failure(conn, ISCSI_ERR_DATA_DGST);
 		return -EIO;
@@ -1659,7 +1661,7 @@ static int skb_read_pdu_data(struct iscsi_conn *conn, struct sk_buff *lskb,
 
 	if (opcode == ISCSI_OP_SCSI_DATA_IN)
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"skb 0x%p, op 0x%x, itt 0x%x, %u %s ddp'ed.\n",
+			"skb 0x%p, op 0x%x, itt 0x%x, %u %s ddp'ed\n",
 			skb, opcode, ntohl(tcp_conn->in.hdr->itt),
 			tcp_conn->in.datalen, offloaded ? "is" : "not");
 
@@ -1673,7 +1675,7 @@ static void csk_return_rx_credits(struct cxgbi_sock *csk, int copied)
 	u32 credits;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lu,%u, seq %u, wup %u, thre %u, %u.\n",
+		"csk 0x%p,%u,0x%lu,%u, seq %u, wup %u, thre %u, %u\n",
 		csk, csk->state, csk->flags, csk->tid, csk->copied_seq,
 		csk->rcv_wup, cdev->rx_credit_thres,
 		cdev->rcv_win);
@@ -1701,7 +1703,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	int err = 0;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p, conn 0x%p.\n", csk, conn);
+		"csk 0x%p, conn 0x%p\n", csk, conn);
 
 	if (unlikely(!conn || conn->suspend_rx)) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
@@ -1719,7 +1721,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 		    !(cxgbi_skcb_test_flag(skb, SKCBF_RX_STATUS))) {
 			if (skb)
 				log_debug(1 << CXGBI_DBG_PDU_RX,
-					"skb 0x%p, NOT ready 0x%lx.\n",
+					"skb 0x%p, NOT ready 0x%lx\n",
 					skb, cxgbi_skcb_flags(skb));
 			read_unlock(&csk->callback_lock);
 			break;
@@ -1729,7 +1731,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 
 		read += cxgbi_skcb_rx_pdulen(skb);
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, skb 0x%p,%u,f 0x%lx, pdu len %u.\n",
+			"csk 0x%p, skb 0x%p,%u,f 0x%lx, pdu len %u\n",
 			csk, skb, skb->len, cxgbi_skcb_flags(skb),
 			cxgbi_skcb_rx_pdulen(skb));
 
@@ -1750,7 +1752,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 				dskb = skb_peek(&csk->receive_queue);
 				if (!dskb) {
 					read_unlock(&csk->callback_lock);
-					log_error("csk 0x%p, NO data.\n", csk);
+					pr_err("csk 0x%p, NO data\n", csk);
 					err = -EAGAIN;
 					break;
 				}
@@ -1768,7 +1770,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 		__kfree_skb(skb);
 	}
 
-	log_debug(1 << CXGBI_DBG_PDU_RX, "csk 0x%p, read %u.\n", csk, read);
+	log_debug(1 << CXGBI_DBG_PDU_RX, "csk 0x%p, read %u\n", csk, read);
 	if (read) {
 		csk->copied_seq += read;
 		csk_return_rx_credits(csk, read);
@@ -1776,7 +1778,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	}
 
 	if (err < 0) {
-		log_info("csk 0x%p, 0x%p, rx failed %d.\n", csk, conn, err);
+		pr_info("csk 0x%p, 0x%p, rx failed %d\n", csk, conn, err);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	}
 }
@@ -1816,7 +1818,7 @@ static int sgl_read_to_frags(struct scatterlist *sg, unsigned int sgoffset,
 		if (!sglen) {
 			sg = sg_next(sg);
 			if (!sg) {
-				log_warn("sg %d NULL, len %u/%u.\n",
+				pr_warn("sg %d NULL, len %u/%u\n",
 					i, datalen, dlen);
 				return -EINVAL;
 			}
@@ -1832,7 +1834,7 @@ static int sgl_read_to_frags(struct scatterlist *sg, unsigned int sgoffset,
 			frags[i - 1].size += copy;
 		} else {
 			if (i >= frag_max) {
-				log_warn("too many pages %u, dlen %u.\n",
+				pr_warn("too many pages %u, dlen %u\n",
 					frag_max, dlen);
 				return -EINVAL;
 			}
@@ -1875,7 +1877,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 
 	tdata->skb = alloc_skb(cdev->skb_tx_rsvd + headroom, GFP_ATOMIC);
 	if (!tdata->skb) {
-		log_warn("alloc skb %u+%u, opcode 0x%x failed.\n",
+		pr_warn("alloc skb %u+%u, opcode 0x%x failed\n",
 			cdev->skb_tx_rsvd, headroom, opcode);
 		return -ENOMEM;
 	}
@@ -1889,7 +1891,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 		task_reserve_itt(task, &task->hdr->itt);
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-		"task 0x%p, op 0x%x, skb 0x%p,%u+%u/%u, itt 0x%x.\n",
+		"task 0x%p, op 0x%x, skb 0x%p,%u+%u/%u, itt 0x%x\n",
 		task, opcode, tdata->skb, cdev->skb_tx_rsvd, headroom,
 		conn->max_xmit_dlength, ntohl(task->hdr->itt));
 
@@ -1920,7 +1922,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 	struct page *pg;
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-		"task 0x%p,0x%p, skb 0x%p, 0x%x,0x%x,0x%x, %u+%u.\n",
+		"task 0x%p,0x%p, skb 0x%p, 0x%x,0x%x,0x%x, %u+%u\n",
 		task, task->sc, skb, (*skb->data) & ISCSI_OPCODE_MASK,
 		ntohl(task->cmdsn), ntohl(task->hdr->itt), offset, count);
 
@@ -1940,14 +1942,14 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 					sdb->table.sgl, sdb->table.nents,
 					tdata->offset, &tdata->sgoffset, &sg);
 		if (err < 0) {
-			log_warn("tpdu, sgl %u, bad offset %u/%u.\n",
+			pr_warn("tpdu, sgl %u, bad offset %u/%u\n",
 				sdb->table.nents, tdata->offset, sdb->length);
 			return err;
 		}
 		err = sgl_read_to_frags(sg, tdata->sgoffset, tdata->count,
 					tdata->frags, MAX_PDU_FRAGS);
 		if (err < 0) {
-			log_warn("tpdu, sgl %u, bad offset %u + %u.\n",
+			pr_warn("tpdu, sgl %u, bad offset %u + %u\n",
 				sdb->table.nents, tdata->offset, tdata->count);
 			return err;
 		}
@@ -2023,7 +2025,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 
 	if (!skb) {
 		log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-			"task 0x%p, skb NULL.\n", task);
+			"task 0x%p, skb NULL\n", task);
 		return 0;
 	}
 
@@ -2034,7 +2036,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 		int pdulen = err;
 
 		log_debug(1 << CXGBI_DBG_PDU_TX,
-			"task 0x%p,0x%p, skb 0x%p, len %u/%u, rv %d.\n",
+			"task 0x%p,0x%p, skb 0x%p, len %u/%u, rv %d\n",
 			task, task->sc, skb, skb->len, skb->data_len, err);
 
 		if (task->conn->hdrdgst_en)
@@ -2049,7 +2051,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 
 	if (err == -EAGAIN || err == -ENOBUFS) {
 		log_debug(1 << CXGBI_DBG_PDU_TX,
-			"task 0x%p, skb 0x%p, len %u/%u, %d EAGAIN.\n",
+			"task 0x%p, skb 0x%p, len %u/%u, %d EAGAIN\n",
 			task, skb, skb->len, skb->data_len, err);
 		/* reset skb to send when we are called again */
 		tdata->skb = skb;
@@ -2058,9 +2060,9 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 
 	kfree_skb(skb);
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-		"itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
+		"itt 0x%x, skb 0x%p, len %u/%u, xmit err %d\n",
 		task->itt, skb, skb->len, skb->data_len, err);
-	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
+	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d\n", err);
 	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
 	return err;
 }
@@ -2072,7 +2074,7 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 				sizeof(struct iscsi_tcp_task);
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"task 0x%p, skb 0x%p, itt 0x%x.\n",
+		"task 0x%p, skb 0x%p, itt 0x%x\n",
 		task, tdata->skb, task->hdr_itt);
 
 	/*  never reached the xmit task callout */
@@ -2136,8 +2138,8 @@ static int cxgbi_conn_max_recv_dlength(struct iscsi_conn *conn)
 
 	if (conn->max_recv_dlength) {
 		if (conn->max_recv_dlength > max) {
-			log_error("MaxRecvDataSegmentLength %u > %u.\n",
-				conn->max_recv_dlength, max);
+			pr_err("MaxRecvDataSegmentLength %u > %u\n",
+			       conn->max_recv_dlength, max);
 			return -EINVAL;
 		}
 		conn->max_recv_dlength = min(conn->max_recv_dlength, max);
@@ -2159,7 +2161,7 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 	int value, err = 0;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"cls_conn 0x%p, param %d, buf(%d) %s.\n",
+		"cls_conn 0x%p, param %d, buf(%d) %s\n",
 		cls_conn, param, buflen, buf);
 
 	switch (param) {
@@ -2211,7 +2213,7 @@ int cxgbi_get_conn_param(struct iscsi_cls_conn *cls_conn,
 	int len;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"cls_conn 0x%p, param %d.\n", cls_conn, param);
+		"cls_conn 0x%p, param %d\n", cls_conn, param);
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -2249,7 +2251,7 @@ cxgbi_create_conn(struct iscsi_cls_session *cls_session, u32 cid)
 	cconn->iconn = conn;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"cid %u(0x%x), cls 0x%p,0x%p, conn 0x%p,0x%p,0x%p.\n",
+		"cid %u(0x%x), cls 0x%p,0x%p, conn 0x%p,0x%p,0x%p\n",
 		cid, cid, cls_session, cls_conn, conn, tcp_conn, cconn);
 
 	return cls_conn;
@@ -2302,7 +2304,7 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	spin_unlock_bh(&conn->session->lock);
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"cls 0x%p,0x%p, ep 0x%p, cconn 0x%p, csk 0x%p.\n",
+		"cls 0x%p,0x%p, ep 0x%p, cconn 0x%p, csk 0x%p\n",
 		cls_session, cls_conn, ep, cconn, csk);
 	/*  init recv engine */
 	iscsi_tcp_hdr_recv_prep(tcp_conn);
@@ -2322,7 +2324,7 @@ struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *ep,
 	struct iscsi_session *session;
 
 	if (!ep) {
-		log_error("missing endpoint\n");
+		pr_err("missing endpoint\n");
 		return NULL;
 	}
 
@@ -2345,7 +2347,7 @@ struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *ep,
 		goto remove_session;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"ep 0x%p, cls sess 0x%p.\n", ep, cls_session);
+		"ep 0x%p, cls sess 0x%p\n", ep, cls_session);
 	return cls_session;
 
 remove_session:
@@ -2357,7 +2359,7 @@ EXPORT_SYMBOL_GPL(cxgbi_create_session);
 void cxgbi_destroy_session(struct iscsi_cls_session *cls_session)
 {
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"cls sess 0x%p.\n", cls_session);
+		"cls sess 0x%p\n", cls_session);
 
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
@@ -2376,7 +2378,7 @@ int cxgbi_set_host_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 	}
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"shost 0x%p, hba 0x%p,%s, param %d, buf(%d) %s.\n",
+		"shost 0x%p, hba 0x%p,%s, param %d, buf(%d) %s\n",
 		shost, chba, chba->ndev->name, param, buflen, buf);
 
 	switch (param) {
@@ -2385,7 +2387,7 @@ int cxgbi_set_host_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 		__be32 addr = in_aton(buf);
 		cxgbi_set_iscsi_ipv4(chba, addr);
 		log_debug(1 << CXGBI_DBG_ISCSI,
-			"hba %s, set ipv4 %pI4.\n", chba->ndev->name, &addr);
+			"hba %s, set ipv4 %pI4\n", chba->ndev->name, &addr);
 		return 0;
 	}
 	case ISCSI_HOST_PARAM_HWADDRESS:
@@ -2405,12 +2407,12 @@ int cxgbi_get_host_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 
 	if (!chba->ndev) {
 		shost_printk(KERN_ERR, shost, "Could not get host param. "
-				"netdev for host not set.\n");
+				"netdev for host not set\n");
 		return -ENODEV;
 	}
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"shost 0x%p, hba 0x%p,%s, param %d.\n",
+		"shost 0x%p, hba 0x%p,%s, param %d\n",
 		shost, chba, chba->ndev->name, param);
 
 	switch (param) {
@@ -2427,7 +2429,7 @@ int cxgbi_get_host_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 		addr = cxgbi_get_iscsi_ipv4(chba);
 		len = sprintf(buf, "%pI4", &addr);
 		log_debug(1 << CXGBI_DBG_ISCSI,
-			"hba %s, ipv4 %pI4.\n", chba->ndev->name, &addr);
+			"hba %s, ipv4 %pI4\n", chba->ndev->name, &addr);
 		break;
 	}
 	default:
@@ -2449,13 +2451,13 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	int err = -EINVAL;
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_SOCK,
-		"shost 0x%p, non_blocking %d, dst_addr 0x%p.\n",
+		"shost 0x%p, non_blocking %d, dst_addr 0x%p\n",
 		shost, non_blocking, dst_addr);
 
 	if (shost) {
 		hba = iscsi_host_priv(shost);
 		if (!hba) {
-			log_info("shost 0x%p, priv NULL.\n", shost);
+			pr_info("shost 0x%p, priv NULL\n", shost);
 			goto err_out;
 		}
 	}
@@ -2468,8 +2470,8 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	if (!hba)
 		hba = csk->cdev->hbas[csk->port_id];
 	else if (hba != csk->cdev->hbas[csk->port_id]) {
-		log_info("Could not connect through requested host %u"
-			"hba 0x%p != 0x%p (%u).\n",
+		pr_info("Could not connect through requested host %u"
+			"hba 0x%p != 0x%p (%u)\n",
 			shost->host_no, hba,
 			csk->cdev->hbas[csk->port_id], csk->port_id);
 		err = -ENOSPC;
@@ -2487,14 +2489,14 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 
 	if (cxgbi_sock_is_closing(csk)) {
 		err = -ENOSPC;
-		log_info("csk 0x%p is closing.\n", csk);
+		pr_info("csk 0x%p is closing\n", csk);
 		goto release_conn;
 	}
 
 	ep = iscsi_create_endpoint(sizeof(*cep));
 	if (!ep) {
 		err = -ENOMEM;
-		log_info("iscsi alloc ep, OOM\n");
+		pr_info("iscsi alloc ep, OOM\n");
 		goto release_conn;
 	}
 
@@ -2503,7 +2505,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	cep->chba = hba;
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_SOCK,
-		"ep 0x%p, cep 0x%p, csk 0x%p, hba 0x%p,%s.\n",
+		"ep 0x%p, cep 0x%p, csk 0x%p, hba 0x%p,%s\n",
 		ep, cep, csk, hba, hba->ndev->name);
 	return ep;
 
@@ -2533,7 +2535,7 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
 	struct cxgbi_sock *csk = cep->csk;
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_SOCK,
-		"ep 0x%p, cep 0x%p, cconn 0x%p, csk 0x%p,%u,0x%lx.\n",
+		"ep 0x%p, cep 0x%p, cconn 0x%p, csk 0x%p,%u,0x%lx\n",
 		ep, cep, cconn, csk, csk->state, csk->flags);
 
 	if (cconn && cconn->iconn) {
@@ -2559,12 +2561,12 @@ int cxgbi_iscsi_init(struct iscsi_transport *itp,
 {
 	*stt = iscsi_register_transport(itp);
 	if (*stt == NULL) {
-		log_error("unable to register %s transport 0x%p.\n",
-			itp->name, itp);
+		pr_err("unable to register %s transport 0x%p\n",
+		       itp->name, itp);
 		return -ENODEV;
 	}
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"%s, registered iscsi transport 0x%p.\n",
+		"%s, registered iscsi transport 0x%p\n",
 		itp->name, stt);
 	return 0;
 }
@@ -2575,7 +2577,7 @@ void cxgbi_iscsi_cleanup(struct iscsi_transport *itp,
 {
 	if (*stt) {
 		log_debug(1 << CXGBI_DBG_ISCSI,
-			"de-register transport 0x%p, %s, stt 0x%p.\n",
+			"de-register transport 0x%p, %s, stt 0x%p\n",
 			itp, itp->name, *stt);
 		*stt = NULL;
 		iscsi_unregister_transport(itp);
@@ -2588,7 +2590,7 @@ static int __init libcxgbi_init_module(void)
 	sw_tag_idx_bits = (__ilog2_u32(ISCSI_ITT_MASK)) + 1;
 	sw_tag_age_bits = (__ilog2_u32(ISCSI_AGE_MASK)) + 1;
 
-	log_info("tag itt 0x%x, %u bits, age 0x%x, %u bits\n",
+	pr_info("tag itt 0x%x, %u bits, age 0x%x, %u bits\n",
 		ISCSI_ITT_MASK, sw_tag_idx_bits,
 		ISCSI_AGE_MASK, sw_tag_age_bits);
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 5a9f84e..2e5b54a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -38,18 +38,11 @@ enum cxgbi_dbg_flag {
 	CXGBI_DBG_DEV,
 };
 
-#define log_debug(level, fmt, ...)	\
-	do {	\
-		if (dbg_level & (level)) \
-			pr_info(pr_prefix "%s - " fmt, \
-			__func__ , ##__VA_ARGS__); \
-	} while (0)
-#define log_error(fmt, ...) \
-	pr_err(pr_prefix "ERR! %s, " fmt, __func__, ##__VA_ARGS__)
-#define log_warn(fmt, ...) \
-	pr_warn(pr_prefix "WARN! %s, " fmt, __func__, ##__VA_ARGS__)
-#define log_info(fmt, ...) \
-	pr_info(pr_prefix "%s, " fmt, __func__, ##__VA_ARGS__)
+#define log_debug(level, fmt, ...)			\
+do {							\
+	if (dbg_level & (level))			\
+		pr_info(fmt, ##__VA_ARGS__);		\
+} while (0)
 
 /* max. connections per adapter */
 #define CXGBI_MAX_CONN		16384
@@ -238,7 +231,7 @@ struct cxgbi_sock {
 	u32 write_seq;
 };
 #define csk_debug(csk) \
-	log_debug(1 << CXGBI_DBG_SOCK, "csk 0x%p,%u,0x%lx,%u.\n", \
+	log_debug(1 << CXGBI_DBG_SOCK, "csk 0x%p,%u,0x%lx,%u\n", \
 		csk, (csk)->state, (csk)->flags, (csk)->tid);
 
 /*
@@ -333,7 +326,7 @@ static inline void cxgbi_sock_set_flag(struct cxgbi_sock *csk,
 {
 	__set_bit(flag, &csk->flags);
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, bit %d.\n",
+		"csk 0x%p,%u,0x%lx, bit %d\n",
 		csk, csk->state, csk->flags, flag);
 }
 
@@ -342,7 +335,7 @@ static inline void cxgbi_sock_clear_flag(struct cxgbi_sock *csk,
 {
 	__clear_bit(flag, &csk->flags);
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, bit %d.\n",
+		"csk 0x%p,%u,0x%lx, bit %d\n",
 		csk, csk->state, csk->flags, flag);
 }
 
@@ -357,7 +350,7 @@ static inline int cxgbi_sock_flag(struct cxgbi_sock *csk,
 static inline void cxgbi_sock_set_state(struct cxgbi_sock *csk, int state)
 {
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"csk 0x%p,%u,0x%lx, state -> %u.\n",
+		"csk 0x%p,%u,0x%lx, state -> %u\n",
 		csk, csk->state, csk->flags, state);
 	csk->state = state;
 }
@@ -378,7 +371,7 @@ static inline void cxgbi_sock_free(struct kref *kref)
 static inline void __cxgbi_sock_put(const char *fn, struct cxgbi_sock *csk)
 {
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"%s, put csk 0x%p, ref %u-1.\n",
+		"%s, put csk 0x%p, ref %u-1\n",
 		fn, csk, atomic_read(&csk->refcnt.refcount));
 	kref_put(&csk->refcnt, cxgbi_sock_free);
 }
@@ -387,7 +380,7 @@ static inline void __cxgbi_sock_put(const char *fn, struct cxgbi_sock *csk)
 static inline void __cxgbi_sock_get(const char *fn, struct cxgbi_sock *csk)
 {
 	log_debug(1 << CXGBI_DBG_SOCK,
-		"%s, get csk 0x%p, ref %u+1.\n",
+		"%s, get csk 0x%p, ref %u+1\n",
 		fn, csk, atomic_read(&csk->refcnt.refcount));
 	kref_get(&csk->refcnt);
 }
@@ -429,7 +422,7 @@ static inline struct sk_buff *alloc_cpl(int cpl_len, int dlen, gfp_t gfp)
 		__skb_put(skb, wrlen);
 		memset(skb->head, 0, wrlen + dlen);
 	} else
-		log_info("alloc cpl skb %u+%u, OOM.\n", cpl_len, dlen);
+		pr_info("alloc cpl skb %u+%u, OOM\n", cpl_len, dlen);
 	return skb;
 }
 
