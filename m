From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 1/4] cxgbi: use per-connection link-speed dependent
 send/recv windows
Date: Fri, 10 Apr 2015 13:57:12 -0700
Message-ID: <201504102057.t3AKvCuC028751@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:29178 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbbDJVAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2015 17:00:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kxie@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

For adapters supporting both 10G and 40G use per-connection send/recv window
and calculate the size based on the link speed.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   14 +++++++-------
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   37 ++++++++++++++++++++++++++----------
 drivers/scsi/cxgbi/libcxgbi.c      |    8 ++++----
 drivers/scsi/cxgbi/libcxgbi.h      |    4 ++--
 4 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 3db4c63..0ae71562 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -156,7 +156,7 @@ static int push_tx_frames(struct cxgbi_sock *csk, int req_completion);
 static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 			      const struct l2t_entry *e)
 {
-	unsigned int wscale = cxgbi_sock_compute_wscale(cxgb3i_rcv_win);
+	unsigned int wscale = cxgbi_sock_compute_wscale(csk->rcv_win);
 	struct cpl_act_open_req *req = (struct cpl_act_open_req *)skb->head;
 
 	skb->priority = CPL_PRIORITY_SETUP;
@@ -172,7 +172,7 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 			V_WND_SCALE(wscale) | V_MSS_IDX(csk->mss_idx) |
 			V_L2T_IDX(e->idx) | V_TX_CHANNEL(e->smt_idx));
 	req->opt0l = htonl(V_ULP_MODE(ULP2_MODE_ISCSI) |
-			V_RCV_BUFSIZ(cxgb3i_rcv_win>>10));
+			V_RCV_BUFSIZ(csk->rcv_win >> 10));
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,0x%lx,%u, %pI4:%u-%pI4:%u, %u,%u,%u.\n",
@@ -369,7 +369,7 @@ static inline void make_tx_data_wr(struct cxgbi_sock *csk, struct sk_buff *skb,
 		req->flags |= htonl(V_TX_ACK_PAGES(2) | F_TX_INIT |
 				    V_TX_CPU_IDX(csk->rss_qid));
 		/* sendbuffer is in units of 32KB. */
-		req->param |= htonl(V_TX_SNDBUF(cxgb3i_snd_win >> 15));
+		req->param |= htonl(V_TX_SNDBUF(csk->snd_win >> 15));
 		cxgbi_sock_set_flag(csk, CTPF_TX_DATA_SENT);
 	}
 }
@@ -503,8 +503,8 @@ static int do_act_establish(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 			csk, csk->state, csk->flags, csk->tid);
 
 	csk->copied_seq = csk->rcv_wup = csk->rcv_nxt = rcv_isn;
-	if (cxgb3i_rcv_win > (M_RCV_BUFSIZ << 10))
-		csk->rcv_wup -= cxgb3i_rcv_win - (M_RCV_BUFSIZ << 10);
+	if (csk->rcv_win > (M_RCV_BUFSIZ << 10))
+		csk->rcv_wup -= csk->rcv_win - (M_RCV_BUFSIZ << 10);
 
 	cxgbi_sock_established(csk, ntohl(req->snd_isn), ntohs(req->tcp_opt));
 
@@ -988,6 +988,8 @@ static int init_act_open(struct cxgbi_sock *csk)
 		goto rel_resource;
 	skb->sk = (struct sock *)csk;
 	set_arp_failure_handler(skb, act_open_arp_failure);
+	csk->snd_win = cxgb3i_snd_win;
+	csk->rcv_win = cxgb3i_rcv_win;
 
 	csk->wr_max_cred = csk->wr_cred = T3C_DATA(t3dev)->max_wrs - 1;
 	csk->wr_una_cred = 0;
@@ -1320,8 +1322,6 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
 	cdev->nports = adapter->params.nports;
 	cdev->mtus = adapter->params.mtus;
 	cdev->nmtus = NMTUS;
-	cdev->snd_win = cxgb3i_snd_win;
-	cdev->rcv_win = cxgb3i_rcv_win;
 	cdev->rx_credit_thres = cxgb3i_rx_credit_thres;
 	cdev->skb_tx_rsvd = CXGB3I_TX_HEADER_LEN;
 	cdev->skb_rx_extra = sizeof(struct cpl_iscsi_hdr_norss);
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index dd00e5f..9147ae4 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -50,11 +50,13 @@ MODULE_LICENSE("GPL");
 module_param(dbg_level, uint, 0644);
 MODULE_PARM_DESC(dbg_level, "Debug flag (default=0)");
 
-static int cxgb4i_rcv_win = 256 * 1024;
+#define CXGB4I_DEFAULT_10G_RCV_WIN (256 * 1024)
+static int cxgb4i_rcv_win = -1;
 module_param(cxgb4i_rcv_win, int, 0644);
 MODULE_PARM_DESC(cxgb4i_rcv_win, "TCP reveive window in bytes");
 
-static int cxgb4i_snd_win = 128 * 1024;
+#define CXGB4I_DEFAULT_10G_SND_WIN (128 * 1024)
+static int cxgb4i_snd_win = -1;
 module_param(cxgb4i_snd_win, int, 0644);
 MODULE_PARM_DESC(cxgb4i_snd_win, "TCP send window in bytes");
 
@@ -196,7 +198,7 @@ static void send_act_open_req(struct cxgbi_sock *csk, struct sk_buff *skb,
 		TX_CHAN_V(csk->tx_chan) |
 		SMAC_SEL_V(csk->smac_idx) |
 		ULP_MODE_V(ULP_MODE_ISCSI) |
-		RCV_BUFSIZ_V(cxgb4i_rcv_win >> 10);
+		RCV_BUFSIZ_V(csk->rcv_win >> 10);
 	opt2 = RX_CHANNEL_V(0) |
 		RSS_QUEUE_VALID_F |
 		(RX_FC_DISABLE_F) |
@@ -279,7 +281,7 @@ static void send_act_open_req6(struct cxgbi_sock *csk, struct sk_buff *skb,
 		TX_CHAN_V(csk->tx_chan) |
 		SMAC_SEL_V(csk->smac_idx) |
 		ULP_MODE_V(ULP_MODE_ISCSI) |
-		RCV_BUFSIZ_V(cxgb4i_rcv_win >> 10);
+		RCV_BUFSIZ_V(csk->rcv_win >> 10);
 
 	opt2 = RX_CHANNEL_V(0) |
 		RSS_QUEUE_VALID_F |
@@ -544,7 +546,7 @@ static inline int send_tx_flowc_wr(struct cxgbi_sock *csk)
 	flowc->mnemval[5].mnemonic = FW_FLOWC_MNEM_RCVNXT;
 	flowc->mnemval[5].val = htonl(csk->rcv_nxt);
 	flowc->mnemval[6].mnemonic = FW_FLOWC_MNEM_SNDBUF;
-	flowc->mnemval[6].val = htonl(cxgb4i_snd_win);
+	flowc->mnemval[6].val = htonl(csk->snd_win);
 	flowc->mnemval[7].mnemonic = FW_FLOWC_MNEM_MSS;
 	flowc->mnemval[7].val = htonl(csk->advmss);
 	flowc->mnemval[8].mnemonic = 0;
@@ -557,7 +559,7 @@ static inline int send_tx_flowc_wr(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p, tid 0x%x, %u,%u,%u,%u,%u,%u,%u.\n",
 		csk, csk->tid, 0, csk->tx_chan, csk->rss_qid,
-		csk->snd_nxt, csk->rcv_nxt, cxgb4i_snd_win,
+		csk->snd_nxt, csk->rcv_nxt, csk->snd_win,
 		csk->advmss);
 
 	cxgb4_ofld_send(csk->cdev->ports[csk->port_id], skb);
@@ -750,8 +752,8 @@ static void do_act_establish(struct cxgbi_device *cdev, struct sk_buff *skb)
 	 * Causes the first RX_DATA_ACK to supply any Rx credits we couldn't
 	 * pass through opt0.
 	 */
-	if (cxgb4i_rcv_win > (RCV_BUFSIZ_MASK << 10))
-		csk->rcv_wup -= cxgb4i_rcv_win - (RCV_BUFSIZ_MASK << 10);
+	if (csk->rcv_win > (RCV_BUFSIZ_MASK << 10))
+		csk->rcv_wup -= csk->rcv_win - (RCV_BUFSIZ_MASK << 10);
 
 	csk->advmss = lldi->mtus[TCPOPT_MSS_G(tcp_opt)] - 40;
 	if (TCPOPT_TSTAMP_G(tcp_opt))
@@ -1367,6 +1369,8 @@ static int init_act_open(struct cxgbi_sock *csk)
 	unsigned int step;
 	unsigned int size, size6;
 	int t4 = is_t4(lldi->adapter_type);
+	unsigned int linkspeed;
+	unsigned int rcv_winf, snd_winf;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,0x%lx,%u.\n",
@@ -1440,6 +1444,21 @@ static int init_act_open(struct cxgbi_sock *csk)
 	csk->txq_idx = cxgb4_port_idx(ndev) * step;
 	step = lldi->nrxq / lldi->nchan;
 	csk->rss_qid = lldi->rxq_ids[cxgb4_port_idx(ndev) * step];
+	linkspeed = ((struct port_info *)netdev_priv(ndev))->link_cfg.speed;
+	csk->snd_win = cxgb4i_snd_win;
+	csk->rcv_win = cxgb4i_rcv_win;
+	if (cxgb4i_rcv_win <= 0) {
+		csk->rcv_win = CXGB4I_DEFAULT_10G_RCV_WIN;
+		rcv_winf = linkspeed / SPEED_10000;
+		if (rcv_winf)
+			csk->rcv_win *= rcv_winf;
+	}
+	if (cxgb4i_snd_win <= 0) {
+		csk->snd_win = CXGB4I_DEFAULT_10G_SND_WIN;
+		snd_winf = linkspeed / SPEED_10000;
+		if (snd_winf)
+			csk->snd_win *= snd_winf;
+	}
 	csk->wr_cred = lldi->wr_cred -
 		       DIV_ROUND_UP(sizeof(struct cpl_abort_req), 16);
 	csk->wr_max_cred = csk->wr_cred;
@@ -1758,8 +1777,6 @@ static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
 	cdev->nports = lldi->nports;
 	cdev->mtus = lldi->mtus;
 	cdev->nmtus = NMTUS;
-	cdev->snd_win = cxgb4i_snd_win;
-	cdev->rcv_win = cxgb4i_rcv_win;
 	cdev->rx_credit_thres = cxgb4i_rx_credit_thres;
 	cdev->skb_tx_rsvd = CXGB4I_TX_HEADER_LEN;
 	cdev->skb_rx_extra = sizeof(struct cpl_iscsi_hdr);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index eb58afc..42c9284 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1126,11 +1126,11 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 		goto out_err;
 	}
 
-	if (csk->write_seq - csk->snd_una >= cdev->snd_win) {
+	if (csk->write_seq - csk->snd_una >= csk->snd_win) {
 		log_debug(1 << CXGBI_DBG_PDU_TX,
 			"csk 0x%p,%u,0x%lx,%u, FULL %u-%u >= %u.\n",
 			csk, csk->state, csk->flags, csk->tid, csk->write_seq,
-			csk->snd_una, cdev->snd_win);
+			csk->snd_una, csk->snd_win);
 		err = -ENOBUFS;
 		goto out_err;
 	}
@@ -1885,7 +1885,7 @@ static void csk_return_rx_credits(struct cxgbi_sock *csk, int copied)
 		"csk 0x%p,%u,0x%lx,%u, seq %u, wup %u, thre %u, %u.\n",
 		csk, csk->state, csk->flags, csk->tid, csk->copied_seq,
 		csk->rcv_wup, cdev->rx_credit_thres,
-		cdev->rcv_win);
+		csk->rcv_win);
 
 	if (csk->state != CTP_ESTABLISHED)
 		return;
@@ -1896,7 +1896,7 @@ static void csk_return_rx_credits(struct cxgbi_sock *csk, int copied)
 	if (unlikely(cdev->rx_credit_thres == 0))
 		return;
 
-	must_send = credits + 16384 >= cdev->rcv_win;
+	must_send = credits + 16384 >= csk->rcv_win;
 	if (must_send || credits >= cdev->rx_credit_thres)
 		csk->rcv_wup += cdev->csk_send_rx_credits(csk, credits);
 }
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index aba1af7..f89fad0 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -234,6 +234,8 @@ struct cxgbi_sock {
 	u32 snd_nxt;
 	u32 snd_una;
 	u32 write_seq;
+	u32 snd_win;
+	u32 rcv_win;
 };
 
 /*
@@ -540,8 +542,6 @@ struct cxgbi_device {
 	struct iscsi_transport *itp;
 
 	unsigned int pfvf;
-	unsigned int snd_win;
-	unsigned int rcv_win;
 	unsigned int rx_credit_thres;
 	unsigned int skb_tx_rsvd;
 	unsigned int skb_rx_extra;	/* for msg coalesced mode */
