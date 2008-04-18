From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] iscsi: extended cdb support
Date: Fri, 18 Apr 2008 10:11:51 -0500
Message-ID: <1208531513-5122-2-git-send-email-michaelc@cs.wisc.edu>
References: <1208531513-5122-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYDRPMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 11:12:36 -0400
In-Reply-To: <1208531513-5122-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Boaz Harrosh <bharrosh@panasas.com>

Support for extended CDBs in iscsi.
All we need is to check if command spills over 16 bytes then allocate
an iscsi-extended-header for the leftovers.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c    |   55 ++++++++++++++++++++++++++++++++++++++++----
 include/scsi/iscsi_proto.h |    6 +++-
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index bdd7de7..2f6b095 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -137,6 +137,45 @@ static int iscsi_add_hdr(struct iscsi_cmd_task *ctask, unsigned len)
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
+	                   sizeof(ecdb_ahdr->ahstype) + ahslength + pad_len);
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
+		   "rlen %d pad_len %d ahs_length %d iscsi_headers_size %u\n",
+		   cmd->cmd_len, rlen, pad_len, ahslength, ctask->hdr_len);
+
+	return 0;
+}
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @ctask: iscsi cmd task
@@ -150,7 +189,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	struct iscsi_session *session = conn->session;
 	struct iscsi_cmd *hdr = ctask->hdr;
 	struct scsi_cmnd *sc = ctask->sc;
-	unsigned hdrlength;
+	unsigned hdrlength, cmd_len;
 	int rc;
 
 	ctask->hdr_len = 0;
@@ -165,10 +204,16 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
-	memcpy(hdr->cdb, sc->cmnd, sc->cmd_len);
-	if (sc->cmd_len < MAX_COMMAND_SIZE)
-		memset(&hdr->cdb[sc->cmd_len], 0,
-			MAX_COMMAND_SIZE - sc->cmd_len);
+	cmd_len = sc->cmd_len;
+	if (cmd_len < ISCSI_CDB_SIZE)
+		memset(&hdr->cdb[cmd_len], 0, ISCSI_CDB_SIZE - cmd_len);
+	else if (cmd_len > ISCSI_CDB_SIZE) {
+		rc = iscsi_prep_ecdb_ahs(ctask);
+		if (rc)
+			return rc;
+		cmd_len = ISCSI_CDB_SIZE;
+	}
+	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
 	ctask->imm_count = 0;
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 5ffec8a..e0593bf 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -112,6 +112,7 @@ struct iscsi_ahs_hdr {
 
 #define ISCSI_AHSTYPE_CDB		1
 #define ISCSI_AHSTYPE_RLENGTH		2
+#define ISCSI_CDB_SIZE			16
 
 /* iSCSI PDU Header */
 struct iscsi_cmd {
@@ -125,7 +126,7 @@ struct iscsi_cmd {
 	__be32 data_length;
 	__be32 cmdsn;
 	__be32 exp_statsn;
-	uint8_t cdb[16];	/* SCSI Command Block */
+	uint8_t cdb[ISCSI_CDB_SIZE];	/* SCSI Command Block */
 	/* Additional Data (Command Dependent) */
 };
 
@@ -154,7 +155,8 @@ struct iscsi_ecdb_ahdr {
 	__be16 ahslength;	/* CDB length - 15, including reserved byte */
 	uint8_t ahstype;
 	uint8_t reserved;
-	uint8_t ecdb[260 - 16];	/* 4-byte aligned extended CDB spillover */
+	/* 4-byte aligned extended CDB spillover */
+	uint8_t ecdb[260 - ISCSI_CDB_SIZE];
 };
 
 /* SCSI Response Header */
-- 
1.5.4.1

