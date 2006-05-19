From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/6] iscsi update: kill dtask mempools
Date: Thu, 18 May 2006 20:31:36 -0500
Message-ID: <1148002296.3248.24.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60548 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932182AbWESBdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:33:20 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1WxZR007199
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:33:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Discovered by steven@hayter.me.uk and patch by michaelc@cs.wisc.edu

The dtask mempool is reserving 261120 items per session! Since we are now
sending headers with sendmsg there is no reason for the mempool and that
was causing us to us carzy amounts of mem. We can preallicate a header in
the r2t and task struct and reuse them

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7c2ed7b..08357a6 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -67,9 +67,6 @@ MODULE_VERSION("0:4.445");
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
-/* global data */
-static kmem_cache_t *taskcache;
-
 static inline void
 iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
@@ -195,16 +192,6 @@ __iscsi_ctask_cleanup(struct iscsi_conn 
 	if (unlikely(!sc))
 		return;
 
-	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		struct iscsi_data_task *dtask, *n;
-
-		/* WRITE: cleanup Data-Out's if any */
-		list_for_each_entry_safe(dtask, n, &tcp_ctask->dataqueue,
-					 item) {
-			list_del(&dtask->item);
-			mempool_free(dtask, tcp_ctask->datapool);
-		}
-	}
 	tcp_ctask->xmstate = XMSTATE_IDLE;
 	tcp_ctask->r2t = NULL;
 }
@@ -286,14 +273,10 @@ iscsi_solicit_data_init(struct iscsi_con
 			struct iscsi_r2t_info *r2t)
 {
 	struct iscsi_data *hdr;
-	struct iscsi_data_task *dtask;
 	struct scsi_cmnd *sc = ctask->sc;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
-	dtask = mempool_alloc(tcp_ctask->datapool, GFP_ATOMIC);
-	BUG_ON(!dtask);
-	INIT_LIST_HEAD(&dtask->item);
-	hdr = &dtask->hdr;
+	hdr = &r2t->dtask.hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
 	hdr->ttt = r2t->ttt;
 	hdr->datasn = cpu_to_be32(r2t->solicit_datasn);
@@ -319,8 +302,6 @@ iscsi_solicit_data_init(struct iscsi_con
 	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
 			   sizeof(struct iscsi_hdr));
 
-	r2t->dtask = dtask;
-
 	if (sc->use_sg) {
 		int i, sg_count = 0;
 		struct scatterlist *sg = sc->request_buffer;
@@ -352,8 +333,6 @@ iscsi_solicit_data_init(struct iscsi_con
 		iscsi_buf_init_iov(&tcp_ctask->sendbuf,
 			    (char*)sc->request_buffer + r2t->data_offset,
 			    r2t->data_count);
-
-	list_add(&dtask->item, &tcp_ctask->dataqueue);
 }
 
 /**
@@ -1229,14 +1208,10 @@ iscsi_solicit_data_cont(struct iscsi_con
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data *hdr;
-	struct iscsi_data_task *dtask;
 	struct scsi_cmnd *sc = ctask->sc;
 	int new_offset;
 
-	dtask = mempool_alloc(tcp_ctask->datapool, GFP_ATOMIC);
-	BUG_ON(!dtask);
-	INIT_LIST_HEAD(&dtask->item);
-	hdr = &dtask->hdr;
+	hdr = &r2t->dtask.hdr;
 	memset(hdr, 0, sizeof(struct iscsi_data));
 	hdr->ttt = r2t->ttt;
 	hdr->datasn = cpu_to_be32(r2t->solicit_datasn);
@@ -1260,8 +1235,6 @@ iscsi_solicit_data_cont(struct iscsi_con
 	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
 			   sizeof(struct iscsi_hdr));
 
-	r2t->dtask = dtask;
-
 	if (sc->use_sg && !iscsi_buf_left(&r2t->sendbuf)) {
 		BUG_ON(tcp_ctask->bad_sg == r2t->sg);
 		iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
@@ -1270,8 +1243,6 @@ iscsi_solicit_data_cont(struct iscsi_con
 		iscsi_buf_init_iov(&tcp_ctask->sendbuf,
 			    (char*)sc->request_buffer + new_offset,
 			    r2t->data_count);
-
-	list_add(&dtask->item, &tcp_ctask->dataqueue);
 }
 
 static void
@@ -1280,17 +1251,11 @@ iscsi_unsolicit_data_init(struct iscsi_c
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data_task *dtask;
 
-	dtask = mempool_alloc(tcp_ctask->datapool, GFP_ATOMIC);
-	BUG_ON(!dtask);
-	INIT_LIST_HEAD(&dtask->item);
-
+	dtask = tcp_ctask->dtask = &tcp_ctask->unsol_dtask;
 	iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr,
 				      tcp_ctask->r2t_data_count);
 	iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)&dtask->hdr,
 			   sizeof(struct iscsi_hdr));
-
-	list_add(&dtask->item, &tcp_ctask->dataqueue);
-	tcp_ctask->dtask = dtask;
 }
 
 /**
@@ -1534,7 +1499,6 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 	tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
 	if (tcp_ctask->xmstate & XMSTATE_UNS_INIT) {
 		iscsi_unsolicit_data_init(conn, ctask);
-		BUG_ON(!tcp_ctask->dtask);
 		dtask = tcp_ctask->dtask;
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
@@ -1643,7 +1607,7 @@ handle_xmstate_sol_data(struct iscsi_con
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_r2t_info *r2t = tcp_ctask->r2t;
-	struct iscsi_data_task *dtask = r2t->dtask;
+	struct iscsi_data_task *dtask = &r2t->dtask;
 	int left;
 
 	tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
@@ -1857,7 +1821,7 @@ solicit_head_again:
 		r2t = tcp_ctask->r2t;
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &r2t->headbuf,
-					(u8*)r2t->dtask->hdrext);
+					(u8*)r2t->dtask.hdrext);
 		if (iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count)) {
 			tcp_ctask->xmstate &= ~XMSTATE_SOL_DATA;
 			tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
@@ -2113,21 +2077,6 @@ iscsi_r2tpool_alloc(struct iscsi_session
 					(void**)tcp_ctask->r2ts);
 			goto r2t_alloc_fail;
 		}
-
-		/*
-		 * number of
-		 * Data-Out PDU's within R2T-sequence can be quite big;
-		 * using mempool
-		 */
-		tcp_ctask->datapool = mempool_create_slab_pool(ISCSI_DTASK_DEFAULT_MAX,
-							       taskcache);
-		if (tcp_ctask->datapool == NULL) {
-			kfifo_free(tcp_ctask->r2tqueue);
-			iscsi_pool_free(&tcp_ctask->r2tpool,
-					(void**)tcp_ctask->r2ts);
-			goto r2t_alloc_fail;
-		}
-		INIT_LIST_HEAD(&tcp_ctask->dataqueue);
 	}
 
 	return 0;
@@ -2137,7 +2086,6 @@ r2t_alloc_fail:
 		struct iscsi_cmd_task *ctask = session->cmds[i];
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
-		mempool_destroy(tcp_ctask->datapool);
 		kfifo_free(tcp_ctask->r2tqueue);
 		iscsi_pool_free(&tcp_ctask->r2tpool,
 				(void**)tcp_ctask->r2ts);
@@ -2154,7 +2102,6 @@ iscsi_r2tpool_free(struct iscsi_session 
 		struct iscsi_cmd_task *ctask = session->cmds[i];
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
-		mempool_destroy(tcp_ctask->datapool);
 		kfifo_free(tcp_ctask->r2tqueue);
 		iscsi_pool_free(&tcp_ctask->r2tpool,
 				(void**)tcp_ctask->r2ts);
@@ -2496,21 +2443,6 @@ r2tpool_alloc_fail:
 
 static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 {
-	struct iscsi_session *session = class_to_transport_session(cls_session);
-	struct iscsi_data_task *dtask, *n;
-	int cmd_i;
-
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
-		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
-
-		list_for_each_entry_safe(dtask, n, &tcp_ctask->dataqueue,
-					 item) {
-			list_del(&dtask->item);
-			mempool_free(dtask, tcp_ctask->datapool);
-		}
-	}
-
 	iscsi_r2tpool_free(class_to_transport_session(cls_session));
 	iscsi_session_teardown(cls_session);
 }
@@ -2592,14 +2524,8 @@ iscsi_tcp_init(void)
 	}
 	iscsi_tcp_transport.max_lun = iscsi_max_lun;
 
-	taskcache = kmem_cache_create("iscsi_taskcache",
-			sizeof(struct iscsi_data_task), 0,
-			SLAB_HWCACHE_ALIGN, NULL, NULL);
-	if (!taskcache)
-		return -ENOMEM;
-
 	if (!iscsi_register_transport(&iscsi_tcp_transport))
-		kmem_cache_destroy(taskcache);
+		return -ENODEV;
 
 	return 0;
 }
@@ -2608,7 +2534,6 @@ static void __exit
 iscsi_tcp_exit(void)
 {
 	iscsi_unregister_transport(&iscsi_tcp_transport);
-	kmem_cache_destroy(taskcache);
 }
 
 module_init(iscsi_tcp_init);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index c591885..8083028 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -118,11 +118,9 @@ struct iscsi_buf {
 struct iscsi_data_task {
 	struct iscsi_data	hdr;			/* PDU */
 	char			hdrext[sizeof(__u32)];	/* Header-Digest */
-	struct list_head	item;			/* data queue item */
 	struct iscsi_buf	digestbuf;		/* digest buffer */
 	uint32_t		digest;			/* data digest */
 };
-#define ISCSI_DTASK_DEFAULT_MAX	ISCSI_SG_TABLESIZE * PAGE_SIZE / 512
 
 struct iscsi_tcp_mgmt_task {
 	struct iscsi_hdr	hdr;
@@ -144,7 +142,7 @@ struct iscsi_r2t_info {
 	int			data_count;	/* DATA-Out payload progress */
 	struct scatterlist	*sg;		/* per-R2T SG list */
 	int			solicit_datasn;
-	struct iscsi_data_task   *dtask;        /* which data task */
+	struct iscsi_data_task   dtask;        /* which data task */
 };
 
 struct iscsi_tcp_cmd_task {
@@ -167,14 +165,13 @@ struct iscsi_tcp_cmd_task {
 	struct iscsi_queue	r2tpool;
 	struct kfifo		*r2tqueue;
 	struct iscsi_r2t_info	**r2ts;
-	struct list_head	dataqueue;		/* Data-Out dataqueue */
-	mempool_t		*datapool;
 	uint32_t		datadigest;		/* for recover digest */
 	int			digest_count;
 	uint32_t		immdigest;		/* for imm data */
 	struct iscsi_buf	immbuf;			/* for imm data digest */
-	struct iscsi_data_task   *dtask;		/* data task in progress*/
-	int			digest_offset;		/* for partial buff digest */
+	struct iscsi_data_task	*dtask;		/* data task in progress*/
+	struct iscsi_data_task	unsol_dtask;	/* unsol data task */
+	int			digest_offset;	/* for partial buff digest */
 };
 
 #endif /* ISCSI_H */


