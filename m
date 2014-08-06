From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support
Date: Wed,  6 Aug 2014 15:37:48 -0700
Message-ID: <1407364668-20931-2-git-send-email-anish@chelsio.com>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:34760
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754005AbaHFWk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 18:40:28 -0400
In-Reply-To: <1407364668-20931-1-git-send-email-anish@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off by: Manoj Malvia <manojmalviya@chelsio.com>
Signed-off by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/libiscsi.c     |  61 +++++++--
 drivers/scsi/libiscsi_tcp.c | 296 ++++++++++++++++++++++++++++++++++++++++----
 include/scsi/libiscsi.h     |   6 +
 include/scsi/libiscsi_tcp.h |  22 ++++
 4 files changed, 349 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 26dc005b..8cfecec 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -233,7 +233,7 @@ static int iscsi_prep_bidi_ahs(struct iscsi_task *task)
 						  sizeof(rlen_ahdr->reserved));
 	rlen_ahdr->ahstype = ISCSI_AHSTYPE_RLENGTH;
 	rlen_ahdr->reserved = 0;
-	rlen_ahdr->read_length = cpu_to_be32(scsi_in(sc)->length);
+	rlen_ahdr->read_length = cpu_to_be32(iscsi_scsi_in_total_length(sc));
 
 	ISCSI_DBG_SESSION(task->conn->session,
 			  "bidi-in rlen_ahdr->read_length(%d) "
@@ -325,6 +325,32 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 	return 0;
 }
 
+inline int iscsi_scsi_out_total_length(struct scsi_cmnd *sc)
+{
+	int sector_size = sc->device->sector_size;
+	int len = scsi_out(sc)->length;
+
+	if ((scsi_get_prot_op(sc) == SCSI_PROT_WRITE_INSERT) ||
+	    (scsi_get_prot_op(sc) == SCSI_PROT_WRITE_PASS))
+		len += (len / sector_size) << ISCSI_PI_LEN_PER_SECTOR_SHIFT;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(iscsi_scsi_out_total_length);
+
+inline int iscsi_scsi_in_total_length(struct scsi_cmnd *sc)
+{
+	int sector_size = sc->device->sector_size;
+	int len = scsi_in(sc)->length;
+
+	if ((scsi_get_prot_op(sc) == SCSI_PROT_READ_STRIP) ||
+	    (scsi_get_prot_op(sc) == SCSI_PROT_READ_PASS))
+		len += (len / sector_size) << ISCSI_PI_LEN_PER_SECTOR_SHIFT;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(iscsi_scsi_in_total_length);
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @task: iscsi task
@@ -392,8 +418,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		task->protected = true;
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		unsigned out_len = scsi_out(sc)->length;
+		unsigned out_len = iscsi_scsi_out_total_length(sc);
 		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
+		unsigned int pi_sector_size = sc->device->sector_size +
+			((scsi_get_prot_op(sc) == SCSI_PROT_WRITE_STRIP) ?
+			0 : ISCSI_PI_LEN_PER_SECTOR);
 
 		hdr->data_length = cpu_to_be32(out_len);
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
@@ -420,6 +449,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			else
 				task->imm_count = min(out_len,
 							conn->max_xmit_dlength);
+			if (scsi_get_prot_op(sc))
+				task->imm_count =
+					(task->imm_count/pi_sector_size) *
+					pi_sector_size;
 			hton24(hdr->dlength, task->imm_count);
 		} else
 			zero_data(hdr->dlength);
@@ -428,6 +461,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			r2t->data_length = min(session->first_burst, out_len) -
 					       task->imm_count;
 			r2t->data_offset = task->imm_count;
+			if (scsi_get_prot_op(sc))
+				r2t->data_length =
+					(r2t->data_length/pi_sector_size) *
+					pi_sector_size;
 			r2t->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
 			r2t->exp_statsn = cpu_to_be32(conn->exp_statsn);
 		}
@@ -436,12 +473,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			/* No unsolicit Data-Out's */
 			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
+		unsigned in_len = iscsi_scsi_in_total_length(sc);
 		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 		zero_data(hdr->dlength);
-		hdr->data_length = cpu_to_be32(scsi_in(sc)->length);
-
 		if (sc->sc_data_direction == DMA_FROM_DEVICE)
 			hdr->flags |= ISCSI_FLAG_CMD_READ;
+		hdr->data_length = cpu_to_be32(in_len);
 	}
 
 	/* calculate size of additional header segments (AHSs) */
@@ -467,8 +504,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			  sc->sc_data_direction == DMA_TO_DEVICE ?
 			  "write" : "read", conn->id, sc, sc->cmnd[0],
 			  task->itt, scsi_bufflen(sc),
-			  scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
-			  session->cmdsn,
+			  scsi_bidi_cmnd(sc) ? iscsi_scsi_in_total_length(sc)
+			  : 0, session->cmdsn,
 			  session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
@@ -635,8 +672,8 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
-		scsi_out(sc)->resid = scsi_out(sc)->length;
-		scsi_in(sc)->resid = scsi_in(sc)->length;
+		scsi_out(sc)->resid = iscsi_scsi_out_total_length(sc);
+		scsi_in(sc)->resid = iscsi_scsi_in_total_length(sc);
 	}
 
 	/* regular RX path uses back_lock */
@@ -887,7 +924,7 @@ invalid_datalen:
 
 		if (scsi_bidi_cmnd(sc) && res_count > 0 &&
 				(rhdr->flags & ISCSI_FLAG_CMD_BIDI_OVERFLOW ||
-				 res_count <= scsi_in(sc)->length))
+				 res_count <= iscsi_scsi_in_total_length(sc)))
 			scsi_in(sc)->resid = res_count;
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
@@ -937,7 +974,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		if (res_count > 0 &&
 		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
-		     res_count <= scsi_in(sc)->length))
+		     res_count <= iscsi_scsi_in_total_length(sc)))
 			scsi_in(sc)->resid = res_count;
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
@@ -1753,8 +1790,8 @@ fault:
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
-		scsi_out(sc)->resid = scsi_out(sc)->length;
-		scsi_in(sc)->resid = scsi_in(sc)->length;
+		scsi_out(sc)->resid = iscsi_scsi_out_total_length(sc);
+		scsi_in(sc)->resid = iscsi_scsi_in_total_length(sc);
 	}
 	sc->scsi_done(sc);
 	return 0;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 60cb6dc..aba3319 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -24,6 +24,7 @@
  *	FUJITA Tomonori
  *	Arne Redlich
  *	Zhenyu Wang
+ *	Manoj Malviya
  */
 
 #include <linux/types.h>
@@ -259,7 +260,7 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 	 * Set us up for transferring the data digest. hdr digest
 	 * is completely handled in hdr done function.
 	 */
-	if (segment->hash) {
+	if (segment->hash && !tcp_conn->in.pi_ctx.pi_pending) {
 		crypto_hash_final(segment->hash, segment->digest);
 		iscsi_tcp_segment_splice_digest(segment,
 				 recv ? segment->recv_digest : segment->digest);
@@ -270,6 +271,73 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_segment_done);
 
+static int
+iscsi_tcp_segment_interleve_data_pi_recv(struct iscsi_tcp_conn *tcp_conn,
+					 struct iscsi_segment *data_segment,
+					 const void *ptr, unsigned int len)
+{
+	struct iscsi_segment *pi_segment = &tcp_conn->in.pi_ctx.pi_segment;
+	struct iscsi_segment *segment;
+	unsigned int copy = 0, copied = 0;
+	unsigned int copy_state = tcp_conn->in.pi_ctx.copy_state;
+
+restart:
+	copy = 0;
+	if (copy_state == COPY_DATA)
+		segment = data_segment;
+	else /* if (copy_state == COPY_PI) */
+		segment = pi_segment;
+
+	if (copy_state == COPY_PI &&
+	    tcp_conn->in.pi_ctx.prot_op == SCSI_PROT_READ_STRIP) {
+		/* We need to drop pi */
+		copy = min(len - copied, segment->remaining_bytes_in_block);
+		segment->remaining_bytes_in_block -= copy;
+		copied += copy;
+		goto next_state;
+	}
+
+	while (!iscsi_tcp_segment_done(tcp_conn, segment, 1, copy)) {
+		if (!segment->remaining_bytes_in_block) {
+			/* change the state */
+			copy_state = ~copy_state;
+			/* reset remianing block size */
+			segment->remaining_bytes_in_block =
+					((segment == data_segment) ?
+					 data_segment->segment_size :
+					 ISCSI_PI_LEN_PER_SECTOR);
+			break;
+		}
+		if (copied == len) {
+			ISCSI_DBG_TCP(tcp_conn->iscsi_conn,
+				      "copied %d bytes\n", len);
+			break;
+		}
+
+		copy = min(len - copied, segment->size - segment->copied);
+		copy = min(copy, segment->remaining_bytes_in_block);
+		segment->remaining_bytes_in_block -= copy;
+		memcpy(segment->data + segment->copied, ptr + copied, copy);
+		copied += copy;
+	}
+
+next_state:
+	if (!segment->remaining_bytes_in_block) {
+		/* change the state */
+		copy_state = ~copy_state;
+		/* reset remianing block size */
+		segment->remaining_bytes_in_block = ((segment == data_segment) ?
+						     data_segment->segment_size
+						     : ISCSI_PI_LEN_PER_SECTOR);
+	}
+	if (copied != len)
+		goto restart;
+
+	tcp_conn->in.pi_ctx.copy_state = copy_state;
+	return copied;
+}
+
+
 /**
  * iscsi_tcp_segment_recv - copy data to segment
  * @tcp_conn: the iSCSI TCP connection
@@ -402,6 +470,9 @@ void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 	iscsi_segment_init_linear(&tcp_conn->in.segment,
 				tcp_conn->in.hdr_buf, sizeof(struct iscsi_hdr),
 				iscsi_tcp_hdr_recv_done, NULL);
+
+	tcp_conn->in.pi_inline = 0;
+	memset(&tcp_conn->in.pi_ctx, 0, sizeof(tcp_conn->in.pi_ctx));
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_hdr_recv_prep);
 
@@ -442,6 +513,71 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 				iscsi_tcp_data_recv_done, rx_hash);
 }
 
+static int
+iscsi_tcp_process_pi(struct iscsi_tcp_conn *tcp_conn,
+		     struct iscsi_segment *segment)
+{
+	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
+	struct iscsi_hdr *hdr = tcp_conn->in.hdr;
+	int rc;
+
+	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
+		return ISCSI_ERR_DATA_DGST;
+
+	/* check for non-exceptional status */
+	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
+		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, NULL, 0);
+		if (rc)
+			return rc;
+	}
+
+	iscsi_tcp_hdr_recv_prep(tcp_conn);
+	return 0;
+}
+
+static int
+iscsi_tcp_pi_recv_prep(struct iscsi_tcp_conn *tcp_conn)
+{
+	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
+	struct iscsi_hdr *hdr = (struct iscsi_hdr *)tcp_conn->in.hdr_buf;
+	struct iscsi_segment *segment = &tcp_conn->in.segment;
+	struct hash_desc *hash = segment->hash;
+	struct scsi_data_buffer *prot_sdb = NULL;
+	struct iscsi_task *task;
+	int rc = 0;
+
+	if (tcp_conn->in.pi_inline) {
+		/* all done. need to calculate the final hash and complete */
+		if (segment->hash) {
+			crypto_hash_final(segment->hash, segment->digest);
+			iscsi_tcp_segment_splice_digest(segment,
+							segment->recv_digest);
+		}
+		iscsi_tcp_process_pi(tcp_conn, segment);
+		return rc;
+	}
+
+	spin_lock(&conn->session->back_lock);
+	task = iscsi_itt_to_ctask(conn, hdr->itt);
+	if (task) {
+		prot_sdb = scsi_prot(task->sc);
+		rc = iscsi_segment_seek_sg(segment, prot_sdb->table.sgl,
+					   prot_sdb->table.nents,
+					   tcp_conn->in.pi_ctx.pi_offset,
+					   tcp_conn->in.pi_ctx.pi_len,
+					   iscsi_tcp_process_pi,
+				/* We don't want to initialize hash again */
+					    NULL);
+	} else {
+		/* TODO : better error handling */
+		rc = ISCSI_ERR_BAD_ITT;
+	}
+	spin_unlock(&conn->session->back_lock);
+	segment->hash = hash;
+	tcp_conn->in.pi_ctx.pi_pending = 0;
+	return rc;
+}
+
 /**
  * iscsi_tcp_cleanup_task - free tcp_task resources
  * @task: iscsi task
@@ -486,7 +622,11 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
 	int datasn = be32_to_cpu(rhdr->datasn);
-	unsigned total_in_length = scsi_in(task->sc)->length;
+	/* unsigned total_in_length = scsi_in(task->sc)->length; */
+	unsigned total_in_length = iscsi_scsi_in_total_length(task->sc);
+
+	/* tcp_task->data_offset and tcp_conn->in.datalen will always have the
+	 * values received from target */
 
 	/*
 	 * lib iscsi will update this in the completion handling if there
@@ -571,11 +711,12 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 			      data_length, session->max_burst);
 
 	data_offset = be32_to_cpu(rhdr->data_offset);
-	if (data_offset + data_length > scsi_out(task->sc)->length) {
+	if (data_offset + data_length > iscsi_scsi_out_total_length(task->sc)) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
-				  data_offset, scsi_out(task->sc)->length);
+				  data_offset,
+				  iscsi_scsi_out_total_length(task->sc));
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -617,6 +758,11 @@ iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_conn,
 	struct iscsi_hdr *hdr = tcp_conn->in.hdr;
 	int rc;
 
+	if (tcp_conn->in.pi_ctx.pi_pending) {
+		rc = iscsi_tcp_pi_recv_prep(tcp_conn);
+		return rc;
+	}
+
 	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
 		return ISCSI_ERR_DATA_DGST;
 
@@ -631,6 +777,18 @@ iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_conn,
 	return 0;
 }
 
+static int pi_len_in_data(int prot_op, int total_len,
+			  unsigned int sector_size)
+{
+	int num_sector = total_len/(sector_size + ISCSI_PI_LEN_PER_SECTOR);
+	int pi_len = 0;
+
+	if (prot_op == SCSI_PROT_READ_PASS || prot_op == SCSI_PROT_READ_STRIP)
+		pi_len = num_sector << ISCSI_PI_LEN_PER_SECTOR_SHIFT;
+
+	return pi_len;
+}
+
 /**
  * iscsi_tcp_hdr_dissect - process PDU header
  * @conn: iSCSI connection
@@ -645,6 +803,7 @@ static int
 iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	int rc = 0, opcode, ahslen;
+	int prot_op;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_task *task;
 
@@ -688,6 +847,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			struct iscsi_tcp_task *tcp_task = task->dd_data;
 			struct hash_desc *rx_hash = NULL;
 			struct scsi_data_buffer *sdb = scsi_in(task->sc);
+			struct scsi_data_buffer *prot_sdb = scsi_prot(task->sc);
+			unsigned int data_offset = tcp_task->data_offset;
+			unsigned int datalen = tcp_conn->in.datalen;
+			unsigned int sector_size = task->sc->device->sector_size;
+			unsigned int pi_len, pi_offset;
 
 			/*
 			 * Setup copy of Data-In into the Scsi_Cmnd
@@ -701,18 +865,74 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 				rx_hash = tcp_conn->rx_hash;
 
-			ISCSI_DBG_TCP(conn, "iscsi_tcp_begin_data_in( "
-				     "offset=%d, datalen=%d)\n",
-				      tcp_task->data_offset,
-				      tcp_conn->in.datalen);
+			prot_op = scsi_get_prot_op(task->sc);
+			tcp_conn->in.pi_ctx.prot_op = prot_op;
+
+			if (prot_op) {
+				/* Expecting pi, pi bytes in datalen bytes */
+				pi_len = pi_len_in_data(prot_op,
+							tcp_conn->in.datalen,
+							sector_size);
+				pi_offset = pi_len_in_data(prot_op,
+							   tcp_task->data_offset,
+							   sector_size);
+
+				ISCSI_DBG_TCP(conn,
+					      "iscsi_tcp_hdr_dissect: pi_len %u, pi_offset %u, tcp_conn->in.datalen %u, tcp_task->data_offset %u\n",
+					      pi_len, pi_offset,
+					      tcp_conn->in.datalen,
+					      tcp_task->data_offset);
+
+				datalen = tcp_conn->in.datalen - pi_len;
+				data_offset =  tcp_task->data_offset - pi_offset;
+
+				if (prot_op == SCSI_PROT_READ_INSERT) {
+					pi_len = (datalen/sector_size) <<
+						 ISCSI_PI_LEN_PER_SECTOR_SHIFT;
+					pi_offset = (data_offset/sector_size) <<
+						 ISCSI_PI_LEN_PER_SECTOR_SHIFT;
+				}
+				tcp_conn->in.pi_ctx.pi_len = pi_len;
+				tcp_conn->in.pi_ctx.pi_offset = pi_offset;
+
+				if (prot_op == SCSI_PROT_READ_STRIP)
+					tcp_conn->in.pi_ctx.pi_pending = 0;
+				else
+					tcp_conn->in.pi_ctx.pi_pending = 1;
+			}
+
+			ISCSI_DBG_TCP(conn,
+				      "iscsi_tcp_begin_data_in( offset=%d, datalen=%d)\n",
+				      data_offset, datalen);
 			task->last_xfer = jiffies;
 			rc = iscsi_segment_seek_sg(&tcp_conn->in.segment,
 						   sdb->table.sgl,
 						   sdb->table.nents,
-						   tcp_task->data_offset,
-						   tcp_conn->in.datalen,
+						   data_offset, datalen,
 						   iscsi_tcp_process_data_in,
 						   rx_hash);
+
+			if (tcp_conn->in.pi_ctx.prot_op &&
+			    tcp_conn->in.pi_inline) {
+				if (tcp_conn->in.pi_ctx.pi_pending) {
+					rc = iscsi_segment_seek_sg(
+						   &tcp_conn->in.pi_ctx.pi_segment,
+						   prot_sdb->table.sgl,
+						   prot_sdb->table.nents,
+						   tcp_conn->in.pi_ctx.pi_offset,
+						   tcp_conn->in.pi_ctx.pi_len,
+						   NULL,
+						   NULL);
+				}
+				tcp_conn->in.segment.segment_size = sector_size;
+				tcp_conn->in.segment.remaining_bytes_in_block =
+					sector_size;
+				tcp_conn->in.pi_ctx.copy_state = COPY_DATA;
+				tcp_conn->in.pi_ctx.pi_segment.remaining_bytes_in_block
+					= ISCSI_PI_LEN_PER_SECTOR;
+				tcp_conn->in.pi_ctx.pi_segment.hash = rx_hash;
+			}
+
 			spin_unlock(&conn->session->back_lock);
 			return rc;
 		}
@@ -866,21 +1086,13 @@ inline int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_recv_segment_is_hdr);
 
-/**
- * iscsi_tcp_recv_skb - Process skb
- * @conn: iscsi connection
- * @skb: network buffer with header and/or data segment
- * @offset: offset in skb
- * @offload: bool indicating if transfer was offloaded
- *
- * Will return status of transfer in status. And will return
- * number of bytes copied.
- */
-int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
-		       unsigned int offset, bool offloaded, int *status)
+int __iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
+			 unsigned int offset, bool offloaded,
+			 bool pi_inline, int *status)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_segment *segment = &tcp_conn->in.segment;
+	struct iscsi_segment *pi_segment = &tcp_conn->in.pi_ctx.pi_segment;
 	struct skb_seq_state seq;
 	unsigned int consumed = 0;
 	int rc = 0;
@@ -916,15 +1128,34 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 			*status = ISCSI_TCP_SKB_DONE;
 			goto skb_done;
 		}
-		BUG_ON(segment->copied >= segment->size);
 
 		ISCSI_DBG_TCP(conn, "skb %p ptr=%p avail=%u\n", skb, ptr,
 			      avail);
-		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
+
+		if (tcp_conn->in.pi_ctx.prot_op && pi_inline)
+			rc = iscsi_tcp_segment_interleve_data_pi_recv(tcp_conn,
+								      segment,
+								      ptr,
+								      avail);
+		else {
+			BUG_ON(segment->copied >= segment->size);
+			rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr,
+						    avail);
+		}
+		tcp_conn->in.pi_inline = pi_inline;
+
 		BUG_ON(rc == 0);
 		consumed += rc;
 
 		if (segment->total_copied >= segment->total_size) {
+			/* if pi_inline then segment done can be declared only
+			 * if pi segment is also complete
+			 */
+			if (!iscsi_tcp_recv_segment_is_hdr(tcp_conn) &&
+			    tcp_conn->in.pi_ctx.prot_op && pi_inline &&
+			    (pi_segment->total_copied <
+			     pi_segment->total_size))
+				continue;
 			skb_abort_seq_read(&seq);
 			goto segment_done;
 		}
@@ -946,6 +1177,23 @@ skb_done:
 	conn->rxdata_octets += consumed;
 	return consumed;
 }
+EXPORT_SYMBOL_GPL(__iscsi_tcp_recv_skb);
+
+/**
+ * iscsi_tcp_recv_skb - Process skb
+ * @conn: iscsi connection
+ * @skb: network buffer with header and/or data segment
+ * @offset: offset in skb
+ * @offload: bool indicating if transfer was offloaded
+ *
+ * Will return status of transfer in status. And will return
+ * number of bytes copied.
+ */
+int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
+		       unsigned int offset, bool offloaded, int *status)
+{
+	return __iscsi_tcp_recv_skb(conn, skb, offset, offloaded, 1, status);
+}
 EXPORT_SYMBOL_GPL(iscsi_tcp_recv_skb);
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 728c9ad..1af7bbd 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -76,6 +76,9 @@ enum {
 
 #define ISCSI_ADDRESS_BUF_LEN		64
 
+#define ISCSI_PI_LEN_PER_SECTOR_SHIFT	3
+#define ISCSI_PI_LEN_PER_SECTOR		8
+
 enum {
 	/* this is the maximum possible storage for AHSs */
 	ISCSI_MAX_AHS_SIZE = sizeof(struct iscsi_ecdb_ahdr) +
@@ -421,6 +424,9 @@ extern int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 #define iscsi_session_printk(prefix, _sess, fmt, a...)	\
 	iscsi_cls_session_printk(prefix, _sess->cls_session, fmt, ##a)
 
+extern int iscsi_scsi_out_total_length(struct scsi_cmnd *);
+extern int iscsi_scsi_in_total_length(struct scsi_cmnd *);
+
 /*
  * connection management
  */
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 2a7aa75..1a1d87c 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -37,6 +37,7 @@ struct iscsi_segment {
 	unsigned int		copied;
 	unsigned int		total_size;
 	unsigned int		total_copied;
+	unsigned int		segment_size;
 
 	struct hash_desc	*hash;
 	unsigned char		padbuf[ISCSI_PAD_LEN];
@@ -50,6 +51,20 @@ struct iscsi_segment {
 	bool			atomic_mapped;
 
 	iscsi_segment_done_fn_t	*done;
+	/* Used if pi is inline to data */
+	unsigned int		remaining_bytes_in_block;
+};
+
+#define COPY_DATA	0
+#define COPY_PI		~COPY_DATA
+struct protection_info_ctx {
+	unsigned char			prot_op;
+	unsigned int			pi_pending;
+	unsigned int			pi_len;
+	unsigned int			pi_offset;
+	/* Following used only pi is inline to data */
+	unsigned int			copy_state;
+	struct iscsi_segment	pi_segment;
 };
 
 /* Socket connection receive helper */
@@ -62,6 +77,10 @@ struct iscsi_tcp_recv {
 
 	/* copied and flipped values */
 	int			datalen;
+	/* LLD should set if the current pdu has inline pi */
+	int			pi_inline;
+	/* To handle protection bytes */
+	struct protection_info_ctx	pi_ctx;
 };
 
 struct iscsi_tcp_conn {
@@ -97,6 +116,9 @@ enum {
 extern void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn);
 extern int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 			      unsigned int offset, bool offloaded, int *status);
+extern int __iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
+				unsigned int offset, bool offloaded,
+				bool pi_inline, int *status);
 extern void iscsi_tcp_cleanup_task(struct iscsi_task *task);
 extern int iscsi_tcp_task_init(struct iscsi_task *task);
 extern int iscsi_tcp_task_xmit(struct iscsi_task *task);
-- 
2.0.3

