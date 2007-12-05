From: michaelc@cs.wisc.edu
Subject: [PATCH 04/23] iscsi_tcp, libiscsi: initial AHS Support
Date: Tue,  4 Dec 2007 18:42:18 -0600
Message-ID: <11968153753743-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbXLEAng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:36 -0500
In-Reply-To: <11968153713324-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>

From: Mike Christie <michaelc@cs.wisc.edu>

  at libiscsi generic code
  - currently code assumes a storage space of pdu header is allocated
    at llds ctask and is pointed to by iscsi_cmd_task->hdr. Here I add
    a hdr_max field pertaining to that storage, and an hdr_len that
    accumulates the current use of the pdu-header.

  - Add an iscsi_next_hdr() inline which returns the next free space
    to write new Header at. Also iscsi_next_hdr() is used to retrieve
    the address at which to write the header-digest.

  - Add iscsi_add_hdr(length). What the user do is calls iscsi_next_hdr()
    for address of the new header, than calls iscsi_add_hdr(length) with
    the size of the new header. iscsi_add_hdr() will check if space is
    available and update to the new size. length must be padded according
    to standard.

  - Add 2 padding inline helpers thanks to Olaf. Current patch does not
    use them but Following patches will.
    Also moved definition of ISCSI_PAD_LEN to iscsi_proto.h which had
    PAD_WORD_LEN that was never used anywhere.

  - Let iscsi_prep_scsi_cmd_pdu() signal an Error return since now  it is
    possible that it will fail.

  - I was tired of yet again writing a "this is a digest" comment next to
    sizeof(__u32) so I defined a new ISCSI_DIGEST_SIZE. Now I don't need
    any comments. Changed all places that used sizeof(__u32) or "4" in
    connection to a digest.

  iscsi_tcp specific code
  - At struct iscsi_tcp_cmd_task allocate maximum space allowed in
    standard for all headers following the iscsi_cmd header. and mark
    it so in iscsi_tcp_session_create()
  - At iscsi_send_cmd_hdr() retrieve the correct headers size and
    write header digest at iscsi_next_hdr().

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c   |   16 ++++++++--------
 drivers/scsi/iscsi_tcp.h   |   13 +++++++------
 drivers/scsi/libiscsi.c    |   41 +++++++++++++++++++++++++++++++++++++++--
 include/scsi/iscsi_proto.h |   10 +++++++++-
 include/scsi/libiscsi.h    |   33 +++++++++++++++++++++++++++++++--
 5 files changed, 94 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index fd88777..491845f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -113,7 +113,7 @@ iscsi_hdr_digest(struct iscsi_conn *conn, struct iscsi_buf *buf,
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	crypto_hash_digest(&tcp_conn->tx_hash, &buf->sg, buf->sg.length, crc);
-	buf->sg.length += sizeof(u32);
+	buf->sg.length += ISCSI_DIGEST_SIZE;
 }
 
 /*
@@ -220,6 +220,7 @@ static inline int
 iscsi_tcp_chunk_done(struct iscsi_chunk *chunk)
 {
 	static unsigned char padbuf[ISCSI_PAD_LEN];
+	unsigned int pad;
 
 	if (chunk->copied < chunk->size) {
 		iscsi_tcp_chunk_map(chunk);
@@ -243,10 +244,8 @@ iscsi_tcp_chunk_done(struct iscsi_chunk *chunk)
 	}
 
 	/* Do we need to handle padding? */
-	if (chunk->total_copied & (ISCSI_PAD_LEN-1)) {
-		unsigned int pad;
-
-		pad = ISCSI_PAD_LEN - (chunk->total_copied & (ISCSI_PAD_LEN-1));
+	pad = iscsi_padding(chunk->total_copied);
+	if (pad != 0) {
 		debug_tcp("consume %d pad bytes\n", pad);
 		chunk->total_size += pad;
 		chunk->size = pad;
@@ -1385,11 +1384,11 @@ iscsi_send_cmd_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		}
 
 		iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)ctask->hdr,
-				  sizeof(struct iscsi_hdr));
+				  ctask->hdr_len);
 
 		if (conn->hdrdgst_en)
 			iscsi_hdr_digest(conn, &tcp_ctask->headbuf,
-					 (u8*)tcp_ctask->hdrext);
+					 iscsi_next_hdr(ctask));
 		tcp_ctask->xmstate &= ~XMSTATE_CMD_HDR_INIT;
 		tcp_ctask->xmstate |= XMSTATE_CMD_HDR_XMIT;
 	}
@@ -2176,7 +2175,8 @@ iscsi_tcp_session_create(struct iscsi_transport *iscsit,
 		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
-		ctask->hdr = &tcp_ctask->hdr;
+		ctask->hdr = &tcp_ctask->hdr.cmd_hdr;
+		ctask->hdr_max = sizeof(tcp_ctask->hdr) - ISCSI_DIGEST_SIZE;
 	}
 
 	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++) {
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index f1c5411..eb3784f 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -41,7 +41,6 @@
 #define XMSTATE_IMM_HDR_INIT		0x1000
 #define XMSTATE_SOL_HDR_INIT		0x2000
 
-#define ISCSI_PAD_LEN			4
 #define ISCSI_SG_TABLESIZE		SG_ALL
 #define ISCSI_TCP_MAX_CMD_LEN		16
 
@@ -130,14 +129,14 @@ struct iscsi_buf {
 
 struct iscsi_data_task {
 	struct iscsi_data	hdr;			/* PDU */
-	char			hdrext[sizeof(__u32)];	/* Header-Digest */
+	char			hdrext[ISCSI_DIGEST_SIZE];/* Header-Digest */
 	struct iscsi_buf	digestbuf;		/* digest buffer */
 	uint32_t		digest;			/* data digest */
 };
 
 struct iscsi_tcp_mgmt_task {
 	struct iscsi_hdr	hdr;
-	char			hdrext[sizeof(__u32)]; /* Header-Digest */
+	char			hdrext[ISCSI_DIGEST_SIZE]; /* Header-Digest */
 	int			xmstate;	/* mgmt xmit progress */
 	struct iscsi_buf	headbuf;	/* header buffer */
 	struct iscsi_buf	sendbuf;	/* in progress buffer */
@@ -159,9 +158,11 @@ struct iscsi_r2t_info {
 };
 
 struct iscsi_tcp_cmd_task {
-	struct iscsi_cmd	hdr;
-	char			hdrext[4*sizeof(__u16)+	/* AHS */
-				    sizeof(__u32)];	/* HeaderDigest */
+	struct iscsi_hdr_buff {
+		struct iscsi_cmd	cmd_hdr;
+		char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
+		                                  ISCSI_DIGEST_SIZE];
+	} hdr;
 	char			pad[ISCSI_PAD_LEN];
 	int			pad_count;		/* padded bytes */
 	struct iscsi_buf	headbuf;		/* header buf (xmit) */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0beb4c6..0d7914f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -37,6 +37,9 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
 
+static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
+			 int err);
+
 struct iscsi_session *
 class_to_transport_session(struct iscsi_cls_session *cls_session)
 {
@@ -122,6 +125,20 @@ void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *ctask,
 }
 EXPORT_SYMBOL_GPL(iscsi_prep_unsolicit_data_pdu);
 
+static int iscsi_add_hdr(struct iscsi_cmd_task *ctask, unsigned len)
+{
+	unsigned exp_len = ctask->hdr_len + len;
+
+	if (exp_len > ctask->hdr_max) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	WARN_ON(len & (ISCSI_PAD_LEN - 1)); /* caller must pad the AHS */
+	ctask->hdr_len = exp_len;
+	return 0;
+}
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @ctask: iscsi cmd task
@@ -129,13 +146,19 @@ EXPORT_SYMBOL_GPL(iscsi_prep_unsolicit_data_pdu);
  * Prep basic iSCSI PDU fields for a scsi cmd pdu. The LLD should set
  * fields like dlength or final based on how much data it sends
  */
-static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
+static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_cmd *hdr = ctask->hdr;
 	struct scsi_cmnd *sc = ctask->sc;
+	unsigned hdrlength;
+	int rc;
 
+	ctask->hdr_len = 0;
+	rc = iscsi_add_hdr(ctask, sizeof(*hdr));
+	if (rc)
+		return rc;
         hdr->opcode = ISCSI_OP_SCSI_CMD;
         hdr->flags = ISCSI_ATTR_SIMPLE;
         int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
@@ -199,6 +222,15 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 			hdr->flags |= ISCSI_FLAG_CMD_READ;
 	}
 
+	/* calculate size of additional header segments (AHSs) */
+	hdrlength = ctask->hdr_len - sizeof(*hdr);
+
+	WARN_ON(hdrlength & (ISCSI_PAD_LEN-1));
+	hdrlength /= ISCSI_PAD_LEN;
+
+	WARN_ON(hdrlength >= 256);
+	hdr->hlength = hdrlength & 0xFF;
+
 	conn->scsicmd_pdus_cnt++;
 
         debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
@@ -206,6 +238,7 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
                 sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
 		conn->id, sc, sc->cmnd[0], ctask->itt, scsi_bufflen(sc),
                 session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
+	return 0;
 }
 
 /**
@@ -744,7 +777,10 @@ check_mgmt:
 
 		conn->ctask = list_entry(conn->xmitqueue.next,
 					 struct iscsi_cmd_task, running);
-		iscsi_prep_scsi_cmd_pdu(conn->ctask);
+		if (iscsi_prep_scsi_cmd_pdu(conn->ctask)) {
+			fail_command(conn, conn->ctask, DID_ABORT << 16);
+			continue;
+		}
 		conn->session->tt->init_cmd_task(conn->ctask);
 		conn->ctask->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->xmitqueue.next, &conn->run_list);
@@ -1534,6 +1570,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		if (cmd_task_size)
 			ctask->dd_data = &ctask[1];
 		ctask->itt = cmd_i;
+		ctask->hdr_max = sizeof(struct iscsi_cmd);
 		INIT_LIST_HEAD(&ctask->running);
 	}
 
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 751c81e..6947082 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -27,7 +27,7 @@
 #define ISCSI_LISTEN_PORT	3260
 
 /* Padding word length */
-#define PAD_WORD_LEN		4
+#define ISCSI_PAD_LEN		4
 
 /*
  * useful common(control and data pathes) macro
@@ -147,6 +147,14 @@ struct iscsi_rlength_ahdr {
 	__be32 read_length;
 };
 
+/* Extended CDB AHS */
+struct iscsi_ecdb_ahdr {
+	__be16 ahslength;	/* CDB length - 15, including reserved byte */
+	uint8_t ahstype;
+	uint8_t reserved;
+	uint8_t ecdb[260 - 16];	/* 4-byte aligned extended CDB spillover */
+};
+
 /* SCSI Response Header */
 struct iscsi_cmd_rsp {
 	uint8_t opcode;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e1fb3d0..a9a9e86 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -78,6 +78,9 @@ enum {
 #define ISCSI_ADDRESS_BUF_LEN		64
 
 enum {
+	/* this is the maximum possible storage for AHSs */
+	ISCSI_MAX_AHS_SIZE = sizeof(struct iscsi_ecdb_ahdr) +
+				sizeof(struct iscsi_rlength_ahdr),
 	ISCSI_DIGEST_SIZE = sizeof(__u32),
 };
 
@@ -102,10 +105,13 @@ enum {
 
 struct iscsi_cmd_task {
 	/*
-	 * Becuae LLDs allocate their hdr differently, this is a pointer to
-	 * that storage. It must be setup at session creation time.
+	 * Because LLDs allocate their hdr differently, this is a pointer
+	 * and length to that storage. It must be setup at session
+	 * creation time.
 	 */
 	struct iscsi_cmd	*hdr;
+	unsigned short		hdr_max;
+	unsigned short		hdr_len;	/* accumulated size of hdr used */
 	int			itt;		/* this ITT */
 
 	uint32_t		unsol_datasn;
@@ -124,6 +130,11 @@ struct iscsi_cmd_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
+static inline void* iscsi_next_hdr(struct iscsi_cmd_task *ctask)
+{
+	return (void*)ctask->hdr + ctask->hdr_len;
+}
+
 struct iscsi_conn {
 	struct iscsi_cls_conn	*cls_conn;	/* ptr to class connection */
 	void			*dd_data;	/* iscsi_transport data */
@@ -342,4 +353,22 @@ extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
 extern void iscsi_pool_free(struct iscsi_queue *, void **);
 extern int iscsi_pool_init(struct iscsi_queue *, int, void ***, int);
 
+/*
+ * inline functions to deal with padding.
+ */
+static inline unsigned int
+iscsi_padded(unsigned int len)
+{
+	return (len + ISCSI_PAD_LEN - 1) & ~(ISCSI_PAD_LEN - 1);
+}
+
+static inline unsigned int
+iscsi_padding(unsigned int len)
+{
+	len &= (ISCSI_PAD_LEN - 1);
+	if (len)
+		len = ISCSI_PAD_LEN - len;
+	return len;
+}
+
 #endif
-- 
1.5.1.2

