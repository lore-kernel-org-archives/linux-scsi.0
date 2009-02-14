From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH v2 3/6 2.6.29-rc] cxgb3i - Outgoing pdus need to observe skb's MAX_SKB_FRAGS
Date: Fri, 13 Feb 2009 21:38:54 -0800
Message-ID: <200902140538.n1E5csvZ014339@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:5154 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZBNFhJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Feb 2009 00:37:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH v2 3/6 2.6.29-rc] cxgb3i - Outgoing pdus need to observe skb's MAX_SKB_FRAGS

From: Karen Xie <kxie@chelsio.com>

Need to make sure the outgoing pdu can fit into a single skb.
When calulating the max. outgoing pdu payload size, take into consideration of
- data can be held in the skb's fragment list, assume 512 bytes per fragment, and
- data can be held in the headroom.
 
Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |   19 +-
 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |    3 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |   17 +-
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    1 
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |  275 +++++++++++++++++++++++-----------
 drivers/scsi/cxgb3i/cxgb3i_pdu.h     |    2 
 6 files changed, 205 insertions(+), 112 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 08f3a09..a83d36e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -639,10 +639,11 @@ static int ddp_init(struct t3cdev *tdev)
 	write_unlock(&cxgb3i_ddp_rwlock);
 
 	ddp_log_info("nppods %u (0x%x ~ 0x%x), bits %u, mask 0x%x,0x%x "
-			"pkt %u,%u.\n",
+			"pkt %u/%u, %u/%u.\n",
 			ppmax, ddp->llimit, ddp->ulimit, ddp->idx_bits,
 			ddp->idx_mask, ddp->rsvd_tag_mask,
-			ddp->max_txsz, ddp->max_rxsz);
+			ddp->max_txsz, uinfo.max_txsz,
+			ddp->max_rxsz, uinfo.max_rxsz);
 	return 0;
 
 free_ddp_map:
@@ -654,8 +655,8 @@ free_ddp_map:
  * cxgb3i_adapter_ddp_init - initialize the adapter's ddp resource
  * @tdev: t3cdev adapter
  * @tformat: tag format
- * @txsz: max tx pkt size, filled in by this func.
- * @rxsz: max rx pkt size, filled in by this func.
+ * @txsz: max tx pdu payload size, filled in by this func.
+ * @rxsz: max rx pdu payload size, filled in by this func.
  * initialize the ddp pagepod manager for a given adapter if needed and
  * setup the tag format for a given iscsi entity
  */
@@ -685,10 +686,12 @@ int cxgb3i_adapter_ddp_init(struct t3cdev *tdev,
 		      tformat->sw_bits, tformat->rsvd_bits,
 		      tformat->rsvd_shift, tformat->rsvd_mask);
 
-	*txsz = ddp->max_txsz;
-	*rxsz = ddp->max_rxsz;
-	ddp_log_info("ddp max pkt size: %u, %u.\n",
-		     ddp->max_txsz, ddp->max_rxsz);
+	*txsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
+			ddp->max_txsz - ISCSI_PDU_NONPAYLOAD_LEN);
+	*rxsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
+			ddp->max_rxsz - ISCSI_PDU_NONPAYLOAD_LEN);
+	ddp_log_info("max payload size: %u/%u, %u/%u.\n",
+		     *txsz, ddp->max_txsz, *rxsz, ddp->max_rxsz);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_init);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index f675807..3faae78 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -87,8 +87,9 @@ struct cxgb3i_ddp_info {
 	struct sk_buff **gl_skb;
 };
 
+#define ISCSI_PDU_NONPAYLOAD_LEN	312 /* bhs(48) + ahs(256) + digest(8) */
 #define ULP2_MAX_PKT_SIZE	16224
-#define ULP2_MAX_PDU_PAYLOAD	(ULP2_MAX_PKT_SIZE - ISCSI_PDU_NONPAYLOAD_MAX)
+#define ULP2_MAX_PDU_PAYLOAD	(ULP2_MAX_PKT_SIZE - ISCSI_PDU_NONPAYLOAD_LEN)
 #define PPOD_PAGES_MAX		4
 #define PPOD_PAGES_SHIFT	2	/* 4 pages per pod */
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index f0434b7..fa2a44f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -403,17 +403,15 @@ static inline int cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
-	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
-				 cconn->hba->snic->tx_max_size -
-				 ISCSI_PDU_NONPAYLOAD_MAX);
+	unsigned int max = max(512 * MAX_SKB_FRAGS, SKB_TX_HEADROOM);
 
+	max = min(cconn->hba->snic->tx_max_size, max);
 	if (conn->max_xmit_dlength)
-		conn->max_xmit_dlength = min_t(unsigned int,
-						conn->max_xmit_dlength, max);
+		conn->max_xmit_dlength = min(conn->max_xmit_dlength, max);
 	else
 		conn->max_xmit_dlength = max;
 	align_pdu_size(conn->max_xmit_dlength);
-	cxgb3i_log_info("conn 0x%p, max xmit %u.\n",
+	cxgb3i_api_debug("conn 0x%p, max xmit %u.\n",
 			 conn, conn->max_xmit_dlength);
 	return 0;
 }
@@ -428,9 +426,7 @@ static inline int cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
-	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
-				 cconn->hba->snic->rx_max_size -
-				 ISCSI_PDU_NONPAYLOAD_MAX);
+	unsigned int max = cconn->hba->snic->rx_max_size;
 
 	align_pdu_size(max);
 	if (conn->max_recv_dlength) {
@@ -440,8 +436,7 @@ static inline int cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
 					 conn->max_recv_dlength, max);
 			return -EINVAL;
 		}
-		conn->max_recv_dlength = min_t(unsigned int,
-						conn->max_recv_dlength, max);
+		conn->max_recv_dlength = min(conn->max_recv_dlength, max);
 		align_pdu_size(conn->max_recv_dlength);
 	} else
 		conn->max_recv_dlength = max;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index df1eae0..6344b9e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -225,6 +225,7 @@ struct sge_opaque_hdr {
 /* for TX: a skb must have a headroom of at least TX_HEADER_LEN bytes */
 #define TX_HEADER_LEN \
 		(sizeof(struct tx_data_wr) + sizeof(struct sge_opaque_hdr))
+#define SKB_TX_HEADROOM		SKB_MAX_HEAD(TX_HEADER_LEN)
 
 /*
  * get and set private ip for iscsi traffic
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index ce7ce8c..17115c2 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -32,6 +32,10 @@
 #define cxgb3i_tx_debug(fmt...)
 #endif
 
+/* always allocate rooms for AHS */
+#define SKB_TX_PDU_HEADER_LEN	\
+	(sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE)
+static unsigned int skb_extra_headroom;
 static struct page *pad_page;
 
 /*
@@ -146,12 +150,13 @@ static inline void tx_skb_setmode(struct sk_buff *skb, int hcrc, int dcrc)
 
 void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
 {
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct cxgb3i_task_data *tdata = task->dd_data +
+					sizeof(struct iscsi_tcp_task);
 
 	/* never reached the xmit task callout */
-	if (tcp_task->dd_data)
-		kfree_skb(tcp_task->dd_data);
-	tcp_task->dd_data = NULL;
+	if (tdata->skb)
+		__kfree_skb(tdata->skb);
+	memset(tdata, 0, sizeof(struct cxgb3i_task_data));
 
 	/* MNC - Do we need a check in case this is called but
 	 * cxgb3i_conn_alloc_pdu has never been called on the task */
@@ -159,28 +164,102 @@ void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
 	iscsi_tcp_cleanup_task(task);
 }
 
-/*
- * We do not support ahs yet
- */
+static int sgl_seek_offset(struct scatterlist *sgl, unsigned int sgcnt,
+				unsigned int offset, unsigned int *off,
+				struct scatterlist **sgp)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(sgl, sg, sgcnt, i) {
+		if (offset < sg->length) {
+			*off = offset;
+			*sgp = sg;
+			return 0;
+		}
+		offset -= sg->length;
+	}
+	return -EFAULT;
+}
+
+static int sgl_read_to_frags(struct scatterlist *sg, unsigned int sgoffset,
+				unsigned int dlen, skb_frag_t *frags,
+				int frag_max)
+{
+	unsigned int datalen = dlen;
+	unsigned int sglen = sg->length - sgoffset;
+	struct page *page = sg_page(sg);
+	int i;
+
+	i = 0;
+	do {
+		unsigned int copy;
+
+		if (!sglen) {
+			sg = sg_next(sg);
+			if (!sg) {
+				cxgb3i_log_error("%s, sg NULL, len %u/%u.\n",
+						 __func__, datalen, dlen);
+				return -EINVAL;
+			}
+			sgoffset = 0;
+			sglen = sg->length;
+			page = sg_page(sg);
+
+		}
+		copy = min(datalen, sglen);
+		if (i && page == frags[i - 1].page &&
+		    sgoffset + sg->offset ==
+			frags[i - 1].page_offset + frags[i - 1].size) {
+			frags[i - 1].size += copy;
+		} else {
+			if (i >= frag_max) {
+				cxgb3i_log_error("%s, too many pages %u, "
+						 "dlen %u.\n", __func__,
+						 frag_max, dlen);
+				return -EINVAL;
+			}
+
+			frags[i].page = page;
+			frags[i].page_offset = sg->offset + sgoffset;
+			frags[i].size = copy;
+			i++;
+		}
+		datalen -= copy;
+		sgoffset += copy;
+		sglen -= copy;
+	} while (datalen);
+
+	return i;
+}
+
 int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 {
+	struct iscsi_conn *conn = task->conn;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct sk_buff *skb;
+	struct cxgb3i_task_data *tdata = task->dd_data + sizeof(*tcp_task);
+	struct scsi_cmnd *sc = task->sc;
+	int headroom = SKB_TX_PDU_HEADER_LEN;
 
+	tcp_task->dd_data = tdata;
 	task->hdr = NULL;
-	/* always allocate rooms for AHS */
-	skb = alloc_skb(sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE +
-			TX_HEADER_LEN,  GFP_ATOMIC);
-	if (!skb)
+
+	/* write command, need to send data pdus */
+	if (skb_extra_headroom && (opcode == ISCSI_OP_SCSI_DATA_OUT ||
+	    (opcode == ISCSI_OP_SCSI_CMD &&
+	    (scsi_bidi_cmnd(sc) || sc->sc_data_direction == DMA_TO_DEVICE))))
+		headroom += min(skb_extra_headroom, conn->max_xmit_dlength);
+
+	tdata->skb = alloc_skb(TX_HEADER_LEN + headroom, GFP_ATOMIC);
+	if (!tdata->skb)
 		return -ENOMEM;
+	skb_reserve(tdata->skb, TX_HEADER_LEN);
 
 	cxgb3i_tx_debug("task 0x%p, opcode 0x%x, skb 0x%p.\n",
-			task, opcode, skb);
+			task, opcode, tdata->skb);
 
-	tcp_task->dd_data = skb;
-	skb_reserve(skb, TX_HEADER_LEN);
-	task->hdr = (struct iscsi_hdr *)skb->data;
-	task->hdr_max = sizeof(struct iscsi_hdr);
+	task->hdr = (struct iscsi_hdr *)tdata->skb->data;
+	task->hdr_max = SKB_TX_PDU_HEADER_LEN;
 
 	/* data_out uses scsi_cmd's itt */
 	if (opcode != ISCSI_OP_SCSI_DATA_OUT)
@@ -192,13 +271,13 @@ int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 int cxgb3i_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 			      unsigned int count)
 {
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct sk_buff *skb = tcp_task->dd_data;
 	struct iscsi_conn *conn = task->conn;
-	struct page *pg;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct cxgb3i_task_data *tdata = tcp_task->dd_data;
+	struct sk_buff *skb = tdata->skb;
 	unsigned int datalen = count;
 	int i, padlen = iscsi_padding(count);
-	skb_frag_t *frag;
+	struct page *pg;
 
 	cxgb3i_tx_debug("task 0x%p,0x%p, offset %u, count %u, skb 0x%p.\n",
 			task, task->sc, offset, count, skb);
@@ -209,90 +288,94 @@ int cxgb3i_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 		return 0;
 
 	if (task->sc) {
-		struct scatterlist *sg;
-		struct scsi_data_buffer *sdb;
-		unsigned int sgoffset = offset;
-		struct page *sgpg;
-		unsigned int sglen;
-
-		sdb = scsi_out(task->sc);
-		sg = sdb->table.sgl;
-
-		for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-			cxgb3i_tx_debug("sg %d, page 0x%p, len %u offset %u\n",
-					i, sg_page(sg), sg->length, sg->offset);
-
-			if (sgoffset < sg->length)
-				break;
-			sgoffset -= sg->length;
+		struct scsi_data_buffer *sdb = scsi_out(task->sc);
+		struct scatterlist *sg = NULL;
+		int err;
+
+		tdata->offset = offset;
+		tdata->count = count;
+		err = sgl_seek_offset(sdb->table.sgl, sdb->table.nents,
+					tdata->offset, &tdata->sgoffset, &sg);
+		if (err < 0) {
+			cxgb3i_log_warn("tpdu, sgl %u, bad offset %u/%u.\n",
+					sdb->table.nents, tdata->offset,
+					sdb->length);
+			return err;
 		}
-		sgpg = sg_page(sg);
-		sglen = sg->length - sgoffset;
-
-		do {
-			int j = skb_shinfo(skb)->nr_frags;
-			unsigned int copy;
-
-			if (!sglen) {
-				sg = sg_next(sg);
-				sgpg = sg_page(sg);
-				sgoffset = 0;
-				sglen = sg->length;
-				++i;
+		err = sgl_read_to_frags(sg, tdata->sgoffset, tdata->count,
+					tdata->frags, MAX_PDU_FRAGS);
+		if (err < 0) {
+			cxgb3i_log_warn("tpdu, sgl %u, bad offset %u + %u.\n",
+					sdb->table.nents, tdata->offset,
+					tdata->count);
+			return err;
+		}
+		tdata->nr_frags = err;
+
+		if (tdata->nr_frags > MAX_SKB_FRAGS ||
+		    (padlen && tdata->nr_frags == MAX_SKB_FRAGS)) {
+			char *dst = skb->data + task->hdr_len;
+			skb_frag_t *frag = tdata->frags;
+
+			/* data fits in the skb's headroom */
+			for (i = 0; i < tdata->nr_frags; i++, frag++) {
+				char *src = kmap_atomic(frag->page,
+							KM_SOFTIRQ0);
+
+				memcpy(dst, src+frag->page_offset, frag->size);
+				dst += frag->size;
+				kunmap_atomic(src, KM_SOFTIRQ0);
 			}
-			copy = min(sglen, datalen);
-			if (j && skb_can_coalesce(skb, j, sgpg,
-						  sg->offset + sgoffset)) {
-				skb_shinfo(skb)->frags[j - 1].size += copy;
-			} else {
-				get_page(sgpg);
-				skb_fill_page_desc(skb, j, sgpg,
-						   sg->offset + sgoffset, copy);
+			if (padlen) {
+				memset(dst, 0, padlen);
+				padlen = 0;
 			}
-			sgoffset += copy;
-			sglen -= copy;
-			datalen -= copy;
-		} while (datalen);
+			skb_put(skb, count + padlen);
+		} else {
+			/* data fit into frag_list */
+			for (i = 0; i < tdata->nr_frags; i++)
+				get_page(tdata->frags[i].page);
+
+			memcpy(skb_shinfo(skb)->frags, tdata->frags,
+				sizeof(skb_frag_t) * tdata->nr_frags);
+			skb_shinfo(skb)->nr_frags = tdata->nr_frags;
+			skb->len += count;
+			skb->data_len += count;
+			skb->truesize += count;
+		}
+
 	} else {
 		pg = virt_to_page(task->data);
 
-		while (datalen) {
-			i = skb_shinfo(skb)->nr_frags;
-			frag = &skb_shinfo(skb)->frags[i];
-
-			get_page(pg);
-			frag->page = pg;
-			frag->page_offset = 0;
-			frag->size = min((unsigned int)PAGE_SIZE, datalen);
-
-			skb_shinfo(skb)->nr_frags++;
-			datalen -= frag->size;
-			pg++;
-		}
+		get_page(pg);
+		skb_fill_page_desc(skb, 0, pg, offset_in_page(task->data),
+					count);
+		skb->len += count;
+		skb->data_len += count;
+		skb->truesize += count;
 	}
 
 	if (padlen) {
 		i = skb_shinfo(skb)->nr_frags;
-		frag = &skb_shinfo(skb)->frags[i];
-		frag->page = pad_page;
-		frag->page_offset = 0;
-		frag->size = padlen;
-		skb_shinfo(skb)->nr_frags++;
+		get_page(pad_page);
+		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, pad_page, 0,
+				 padlen);
+
+		skb->data_len += padlen;
+		skb->truesize += padlen;
+		skb->len += padlen;
 	}
 
-	datalen = count + padlen;
-	skb->data_len += datalen;
-	skb->truesize += datalen;
-	skb->len += datalen;
 	return 0;
 }
 
 int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 {
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct sk_buff *skb = tcp_task->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct cxgb3i_task_data *tdata = tcp_task->dd_data;
+	struct sk_buff *skb = tdata->skb;
 	unsigned int datalen;
 	int err;
 
@@ -300,13 +383,14 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 		return 0;
 
 	datalen = skb->data_len;
-	tcp_task->dd_data = NULL;
+	tdata->skb = NULL;
 	err = cxgb3i_c3cn_send_pdus(cconn->cep->c3cn, skb);
-	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
-			task, skb, skb->len, skb->data_len, err);
 	if (err > 0) {
 		int pdulen = err;
 
+	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
+			task, skb, skb->len, skb->data_len, err);
+
 		if (task->conn->hdrdgst_en)
 			pdulen += ISCSI_DIGEST_SIZE;
 		if (datalen && task->conn->datadgst_en)
@@ -325,12 +409,14 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 		return err;
 	}
 	/* reset skb to send when we are called again */
-	tcp_task->dd_data = skb;
+	tdata->skb = skb;
 	return -EAGAIN;
 }
 
 int cxgb3i_pdu_init(void)
 {
+	if (SKB_TX_HEADROOM > (512 * MAX_SKB_FRAGS))
+		skb_extra_headroom = SKB_TX_HEADROOM;
 	pad_page = alloc_page(GFP_KERNEL);
 	if (!pad_page)
 		return -ENOMEM;
@@ -366,7 +452,9 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 	skb = skb_peek(&c3cn->receive_queue);
 	while (!err && skb) {
 		__skb_unlink(skb, &c3cn->receive_queue);
-		read += skb_ulp_pdulen(skb);
+		read += skb_rx_pdulen(skb);
+		cxgb3i_rx_debug("conn 0x%p, cn 0x%p, rx skb 0x%p, pdulen %u.\n",
+				conn, c3cn, skb, skb_rx_pdulen(skb));
 		err = cxgb3i_conn_read_pdu_skb(conn, skb);
 		__kfree_skb(skb);
 		skb = skb_peek(&c3cn->receive_queue);
@@ -377,6 +465,11 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 		cxgb3i_c3cn_rx_credits(c3cn, read);
 	}
 	conn->rxdata_octets += read;
+
+	if (err) {
+		cxgb3i_log_info("conn 0x%p rx failed err %d.\n", conn, err);
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	}
 }
 
 void cxgb3i_conn_tx_open(struct s3_conn *c3cn)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.h b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
index a3f685c..0770b23 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
@@ -53,7 +53,7 @@ struct cpl_rx_data_ddp_norss {
 #define ULP2_FLAG_DCRC_ERROR		0x20
 #define ULP2_FLAG_PAD_ERROR		0x40
 
-void cxgb3i_conn_closing(struct s3_conn *);
+void cxgb3i_conn_closing(struct s3_conn *c3cn);
 void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn);
 void cxgb3i_conn_tx_open(struct s3_conn *c3cn);
 #endif
