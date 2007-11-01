From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/4] iscsi: extended cdb support
Date: Thu, 01 Nov 2007 20:10:47 +0200
Message-ID: <472A16A7.3010808@panasas.com>
References: <472A12D6.805@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:23376 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106AbXKASMJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 14:12:09 -0400
In-Reply-To: <472A12D6.805@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>


  Once varlen cdbs are supported by the block and scsi-ml layers
  we can apply this patch to support extended CDBs in iscsi.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/iscsi_tcp.h   |    3 +-
 drivers/scsi/libiscsi.c    |   56 ++++++++++++++++++++++++++++++++++++++++----
 include/scsi/iscsi_proto.h |    6 +++-
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index ec4e5cf..30077fa 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -23,6 +23,7 @@
 #define ISCSI_TCP_H
 
 #include <scsi/libiscsi.h>
+#include <scsi/scsi.h>
 
 /* Socket's Receive state machine */
 #define IN_PROGRESS_WAIT_HEADER		0x0
@@ -49,7 +50,7 @@
 #define XMSTATE_SOL_HDR_INIT		0x2000
 
 #define ISCSI_SG_TABLESIZE		SG_ALL
-#define ISCSI_TCP_MAX_CMD_LEN		16
+#define ISCSI_TCP_MAX_CMD_LEN		SCSI_MAX_VARLEN_CDB_SIZE
 
 struct crypto_hash;
 struct socket;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6a747cc..e57963c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -139,6 +139,45 @@ static int iscsi_add_hdr(struct iscsi_cmd_task *ctask, unsigned len)
 	return 0;
 }
 
+/*
+ * make an extended cdb AHS
+ */
+static int iscsi_prep_ecdb_ahs(struct iscsi_cmd_task *ctask)
+{
+	struct scsi_cmnd *cmd = ctask->sc;
+	unsigned rlen, pad_len;
+	unsigned short ahslength;
+	struct iscsi_ecdb_ahdr *ecdb_ahdr;
+	int rc;
+
+	ecdb_ahdr = iscsi_next_hdr(ctask);
+	rlen = cmd->cmd_len - ISCSI_CDB_SIZE;
+
+	BUG_ON(rlen > sizeof(ecdb_ahdr->ecdb));
+	ahslength = rlen + sizeof(ecdb_ahdr->reserved);
+
+	pad_len = iscsi_padding(rlen);
+
+	rc = iscsi_add_hdr(ctask, sizeof(ecdb_ahdr->ahslength) +
+	              sizeof(ecdb_ahdr->ahstype) + ahslength + pad_len);
+	if (rc)
+		return rc;
+
+	if (pad_len)
+		memset(&ecdb_ahdr->ecdb[rlen], 0, pad_len);
+
+	ecdb_ahdr->ahslength = cpu_to_be16(ahslength);
+	ecdb_ahdr->ahstype = ISCSI_AHSTYPE_CDB;
+	ecdb_ahdr->reserved = 0;
+	memcpy(ecdb_ahdr->ecdb, cmd->cmnd + ISCSI_CDB_SIZE, rlen);
+
+	debug_scsi("iscsi_prep_ecdb_ahs: varlen_cdb_len %d "
+		"rlen %d pad_len %d ahs_length %d iscsi_headers_size %u\n",
+		cmd->cmd_len, rlen, pad_len, ahslength, ctask->hdr_len);
+
+	return 0;
+}
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @ctask: iscsi cmd task
@@ -152,7 +191,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	struct iscsi_session *session = conn->session;
 	struct iscsi_cmd *hdr = ctask->hdr;
 	struct scsi_cmnd *sc = ctask->sc;
-	unsigned hdrlength;
+	unsigned hdrlength, cmd_len;
 	int rc;
 
 	ctask->hdr_len = 0;
@@ -167,10 +206,17 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
         hdr->cmdsn = cpu_to_be32(session->cmdsn);
         session->cmdsn++;
         hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
-        memcpy(hdr->cdb, sc->cmnd, sc->cmd_len);
-	if (sc->cmd_len < MAX_COMMAND_SIZE)
-		memset(&hdr->cdb[sc->cmd_len], 0,
-			MAX_COMMAND_SIZE - sc->cmd_len);
+	cmd_len = sc->cmd_len;
+	if (cmd_len < ISCSI_CDB_SIZE)
+		memset(&hdr->cdb[cmd_len], 0,
+			ISCSI_CDB_SIZE - cmd_len);
+	else if (cmd_len > ISCSI_CDB_SIZE) {
+		rc = iscsi_prep_ecdb_ahs(ctask);
+		if (rc)
+			return rc;
+		cmd_len = ISCSI_CDB_SIZE;
+	}
+	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
 	ctask->data_count = 0;
 	ctask->imm_count = 0;
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 4b2dce7..9dff9cc 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -110,6 +110,7 @@ struct iscsi_ahs_hdr {
 
 #define ISCSI_AHSTYPE_CDB		1
 #define ISCSI_AHSTYPE_RLENGTH		2
+#define ISCSI_CDB_SIZE			16
 
 /* iSCSI PDU Header */
 struct iscsi_cmd {
@@ -123,7 +124,7 @@ struct iscsi_cmd {
 	__be32 data_length;
 	__be32 cmdsn;
 	__be32 exp_statsn;
-	uint8_t cdb[16];	/* SCSI Command Block */
+	uint8_t cdb[ISCSI_CDB_SIZE];	/* SCSI Command Block */
 	/* Additional Data (Command Dependent) */
 };
 
@@ -152,7 +153,8 @@ struct iscsi_ecdb_ahdr {
 	__be16 ahslength;	/* CDB length - 15, including reserved byte */
 	uint8_t ahstype;
 	uint8_t reserved;
-	uint8_t ecdb[260 - 16];	/* 4-byte aligned extended CDB spillover */
+	/* 4-byte aligned extended CDB spillover */
+	uint8_t ecdb[260 - ISCSI_CDB_SIZE];
 };
 
 /* SCSI Response Header */
-- 
1.5.3.1


