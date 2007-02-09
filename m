From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] iscsi endianness annotations
Date: Fri, 09 Feb 2007 16:39:40 +0000
Message-ID: <E1HFYmi-0006qO-O0@ZenIV.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51728 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946654AbXBIQjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 11:39:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |    4 +-
 drivers/scsi/iscsi_tcp.c                     |    2 +-
 drivers/scsi/libiscsi.c                      |   40 +++++++++++------------
 include/scsi/iscsi_proto.h                   |   46 +++++++++++++++-----------
 4 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 0a7d1ab..89e3728 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -567,7 +567,7 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
 	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
-	        itt = hdr->itt & ISCSI_ITT_MASK; /* mask out cid and age bits */
+	        itt = get_itt(hdr->itt); /* mask out cid and age bits */
 		if (!(itt < session->cmds_max))
 			iser_err("itt can't be matched to task!!!"
 				 "conn %p opcode %d cmds_max %d itt %d\n",
@@ -625,7 +625,7 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 		/* this arithmetic is legal by libiscsi dd_data allocation */
 		mtask = (void *) ((long)(void *)tx_desc -
 				  sizeof(struct iscsi_mgmt_task));
-		if (mtask->hdr->itt == cpu_to_be32(ISCSI_RESERVED_TAG)) {
+		if (mtask->hdr->itt == RESERVED_ITT) {
 			struct iscsi_session *session = conn->session;
 
 			spin_lock(&conn->session->lock);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4376840..8f55e14 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1375,7 +1375,7 @@ iscsi_tcp_mtask_xmit(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 	}
 
 	BUG_ON(tcp_mtask->xmstate != XMSTATE_IDLE);
-	if (mtask->hdr->itt == cpu_to_be32(ISCSI_RESERVED_TAG)) {
+	if (mtask->hdr->itt == RESERVED_ITT) {
 		struct iscsi_session *session = conn->session;
 
 		spin_lock_bh(&session->lock);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d37048c..7c75771 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -113,8 +113,7 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
         hdr->opcode = ISCSI_OP_SCSI_CMD;
         hdr->flags = ISCSI_ATTR_SIMPLE;
         int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-        hdr->itt = ctask->itt | (conn->id << ISCSI_CID_SHIFT) |
-                         (session->age << ISCSI_AGE_SHIFT);
+        hdr->itt = build_itt(ctask->itt, conn->id, session->age);
         hdr->data_length = cpu_to_be32(sc->request_bufflen);
         hdr->cmdsn = cpu_to_be32(session->cmdsn);
         session->cmdsn++;
@@ -270,7 +269,7 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = be16_to_cpu(*(uint16_t *)data);
+		senselen = be16_to_cpu(*(__be16 *)data);
 		if (datalen < senselen)
 			goto invalid_datalen;
 
@@ -338,7 +337,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		if (ntoh24(reject->dlength) >= sizeof(struct iscsi_hdr)) {
 			memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
-			itt = rejected_pdu.itt & ISCSI_ITT_MASK;
+			itt = get_itt(rejected_pdu.itt);
 			printk(KERN_ERR "itt 0x%x had pdu (op 0x%x) rejected "
 				"due to DataDigest error.\n", itt,
 				rejected_pdu.opcode);
@@ -367,10 +366,10 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_mgmt_task *mtask;
 	uint32_t itt;
 
-	if (hdr->itt != cpu_to_be32(ISCSI_RESERVED_TAG))
-		itt = hdr->itt & ISCSI_ITT_MASK;
+	if (hdr->itt != RESERVED_ITT)
+		itt = get_itt(hdr->itt);
 	else
-		itt = hdr->itt;
+		itt = ~0U;
 
 	if (itt < session->cmds_max) {
 		ctask = session->cmds[itt];
@@ -440,7 +439,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			iscsi_tmf_rsp(conn, hdr);
 			break;
 		case ISCSI_OP_NOOP_IN:
-			if (hdr->ttt != ISCSI_RESERVED_TAG || datalen) {
+			if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
 				rc = ISCSI_ERR_PROTO;
 				break;
 			}
@@ -457,7 +456,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			rc = ISCSI_ERR_BAD_OPCODE;
 			break;
 		}
-	} else if (itt == ISCSI_RESERVED_TAG) {
+	} else if (itt == ~0U) {
 		rc = iscsi_check_assign_cmdsn(session,
 					     (struct iscsi_nopin*)hdr);
 		if (rc)
@@ -470,7 +469,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 				break;
 			}
 
-			if (hdr->ttt == ISCSI_RESERVED_TAG)
+			if (hdr->ttt == cpu_to_be32(ISCSI_RESERVED_TAG))
 				break;
 
 			if (iscsi_recv_pdu(conn->cls_conn, hdr, NULL, 0))
@@ -516,24 +515,24 @@ int iscsi_verify_itt(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_cmd_task *ctask;
 	uint32_t itt;
 
-	if (hdr->itt != cpu_to_be32(ISCSI_RESERVED_TAG)) {
-		if ((hdr->itt & ISCSI_AGE_MASK) !=
+	if (hdr->itt != RESERVED_ITT) {
+		if (((__force u32)hdr->itt & ISCSI_AGE_MASK) !=
 		    (session->age << ISCSI_AGE_SHIFT)) {
 			printk(KERN_ERR "iscsi: received itt %x expected "
-				"session age (%x)\n", hdr->itt,
+				"session age (%x)\n", (__force u32)hdr->itt,
 				session->age & ISCSI_AGE_MASK);
 			return ISCSI_ERR_BAD_ITT;
 		}
 
-		if ((hdr->itt & ISCSI_CID_MASK) !=
+		if (((__force u32)hdr->itt & ISCSI_CID_MASK) !=
 		    (conn->id << ISCSI_CID_SHIFT)) {
 			printk(KERN_ERR "iscsi: received itt %x, expected "
-				"CID (%x)\n", hdr->itt, conn->id);
+				"CID (%x)\n", (__force u32)hdr->itt, conn->id);
 			return ISCSI_ERR_BAD_ITT;
 		}
-		itt = hdr->itt & ISCSI_ITT_MASK;
+		itt = get_itt(hdr->itt);
 	} else
-		itt = hdr->itt;
+		itt = ~0U;
 
 	if (itt < session->cmds_max) {
 		ctask = session->cmds[itt];
@@ -896,9 +895,8 @@ iscsi_conn_send_generic(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	/*
 	 * pre-format CmdSN for outgoing PDU.
 	 */
-	if (hdr->itt != cpu_to_be32(ISCSI_RESERVED_TAG)) {
-		hdr->itt = mtask->itt | (conn->id << ISCSI_CID_SHIFT) |
-			   (session->age << ISCSI_AGE_SHIFT);
+	if (hdr->itt != RESERVED_ITT) {
+		hdr->itt = build_itt(mtask->itt, conn->id, session->age);
 		nop->cmdsn = cpu_to_be32(session->cmdsn);
 		if (conn->c_stage == ISCSI_CONN_STARTED &&
 		    !(hdr->opcode & ISCSI_OP_IMMEDIATE))
@@ -1064,7 +1062,7 @@ static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
 
 	spin_lock_bh(&session->lock);
 	ctask->mtask = (struct iscsi_mgmt_task *)
-			session->mgmt_cmds[(hdr->itt & ISCSI_ITT_MASK) -
+			session->mgmt_cmds[get_itt(hdr->itt) -
 					ISCSI_MGMT_ITT_OFFSET];
 
 	if (conn->tmabort_state == TMABORT_INITIAL) {
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 02f6e4b..4a44278 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -40,6 +40,14 @@
 }
 #define zero_data(p) {p[0]=0;p[1]=0;p[2]=0;}
 
+/* initiator tags; opaque for target */
+typedef uint32_t __bitwise__ itt_t;
+/* below makes sense only for initiator that created this tag */
+#define build_itt(itt, id, age) ((__force itt_t)\
+	((itt) | ((id) << ISCSI_CID_SHIFT) | ((age) << ISCSI_AGE_SHIFT)))
+#define get_itt(itt) ((__force uint32_t)(itt_t)(itt) & ISCSI_ITT_MASK)
+#define RESERVED_ITT ((__force itt_t)0xffffffff)
+
 /*
  * iSCSI Template Message Header
  */
@@ -50,7 +58,7 @@ struct iscsi_hdr {
 	uint8_t		hlength;	/* AHSs total length */
 	uint8_t		dlength[3];	/* Data length */
 	uint8_t		lun[8];
-	__be32		itt;		/* Initiator Task Tag */
+	itt_t		itt;		/* Initiator Task Tag, opaque for target */
 	__be32		ttt;		/* Target Task Tag */
 	__be32		statsn;
 	__be32		exp_statsn;
@@ -111,7 +119,7 @@ struct iscsi_cmd {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t lun[8];
-	__be32 itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32 data_length;
 	__be32 cmdsn;
 	__be32 exp_statsn;
@@ -148,7 +156,7 @@ struct iscsi_cmd_rsp {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t rsvd[8];
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	rsvd1;
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -206,7 +214,7 @@ struct iscsi_nopout {
 	uint8_t rsvd3;
 	uint8_t dlength[3];
 	uint8_t lun[8];
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
 	__be32	cmdsn;
 	__be32	exp_statsn;
@@ -221,7 +229,7 @@ struct iscsi_nopin {
 	uint8_t rsvd3;
 	uint8_t dlength[3];
 	uint8_t lun[8];
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -237,8 +245,8 @@ struct iscsi_tm {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t lun[8];
-	__be32	itt;	/* Initiator Task Tag */
-	__be32	rtt;	/* Reference Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
+	itt_t	 rtt;	/* Reference Task Tag */
 	__be32	cmdsn;
 	__be32	exp_statsn;
 	__be32	refcmdsn;
@@ -267,8 +275,8 @@ struct iscsi_tm_rsp {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t rsvd2[8];
-	__be32	itt;	/* Initiator Task Tag */
-	__be32	rtt;	/* Reference Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
+	itt_t	 rtt;	/* Reference Task Tag */
 	__be32	statsn;
 	__be32	exp_cmdsn;
 	__be32	max_cmdsn;
@@ -293,7 +301,7 @@ struct iscsi_r2t_rsp {
 	uint8_t	hlength;
 	uint8_t	dlength[3];
 	uint8_t lun[8];
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -311,7 +319,7 @@ struct iscsi_data {
 	uint8_t rsvd3;
 	uint8_t dlength[3];
 	uint8_t lun[8];
-	__be32	itt;
+	itt_t	 itt;
 	__be32	ttt;
 	__be32	rsvd4;
 	__be32	exp_statsn;
@@ -331,7 +339,7 @@ struct iscsi_data_rsp {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t lun[8];
-	__be32	itt;
+	itt_t	 itt;
 	__be32	ttt;
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -355,7 +363,7 @@ struct iscsi_text {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t rsvd4[8];
-	__be32	itt;
+	itt_t	 itt;
 	__be32	ttt;
 	__be32	cmdsn;
 	__be32	exp_statsn;
@@ -373,7 +381,7 @@ struct iscsi_text_rsp {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t rsvd4[8];
-	__be32	itt;
+	itt_t	 itt;
 	__be32	ttt;
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -392,7 +400,7 @@ struct iscsi_login {
 	uint8_t dlength[3];
 	uint8_t isid[6];	/* Initiator Session ID */
 	__be16	tsih;	/* Target Session Handle */
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be16	cid;
 	__be16	rsvd3;
 	__be32	cmdsn;
@@ -421,7 +429,7 @@ struct iscsi_login_rsp {
 	uint8_t dlength[3];
 	uint8_t isid[6];	/* Initiator Session ID */
 	__be16	tsih;	/* Target Session Handle */
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	rsvd3;
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -478,7 +486,7 @@ struct iscsi_logout {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t rsvd2[8];
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be16	cid;
 	uint8_t rsvd3[2];
 	__be32	cmdsn;
@@ -505,7 +513,7 @@ struct iscsi_logout_rsp {
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t rsvd3[8];
-	__be32	itt;	/* Initiator Task Tag */
+	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	rsvd4;
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -528,7 +536,7 @@ struct iscsi_snack {
 	uint8_t opcode;
 	uint8_t flags;
 	uint8_t rsvd2[14];
-	__be32	itt;
+	itt_t	 itt;
 	__be32	begrun;
 	__be32	runlength;
 	__be32	exp_statsn;
-- 
1.5.0-rc2.GIT


