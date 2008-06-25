From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06 of 10] scsi: Command protection operation
Date: Wed, 25 Jun 2008 11:22:45 -0400
Message-ID: <aa26bad30eec2adf1362.1214407365@sermon.lab.mkp.net>
References: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41045 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbYFYPZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:27 -0400
In-Reply-To: <patchbomb.1214407359@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Controllers that support DMA of protection information must be told
explicitly how to handle the I/O.  The controller has no knowledge of
the protection capabilities of the target device so this information
must be passed in the scsi_cmnd.

The protection operation tells the HBA whether to generate, strip or
verify protection information.

When a scsi_cmnd is reused for error handling, the protection
operation must be cleared and saved while error handling is in
progress.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
3 files changed, 32 insertions(+)
drivers/scsi/scsi_error.c |    3 +++
include/scsi/scsi_cmnd.h  |   28 ++++++++++++++++++++++++++++
include/scsi/scsi_eh.h    |    1 +



diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -653,7 +653,9 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
 	ses->sdb = scmd->sdb;
 	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
+	ses->prot_op = scmd->prot_op;
 
+	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
@@ -711,6 +713,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->sdb = ses->sdb;
 	scmd->request->next_rq = ses->next_rq;
 	scmd->result = ses->result;
+	scmd->prot_op = ses->prot_op;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -77,6 +77,8 @@ struct scsi_cmnd {
 	int retries;
 	int allowed;
 	int timeout_per_command;
+
+	unsigned char prot_op;
 
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
@@ -211,6 +213,32 @@ static inline int scsi_sg_copy_to_buffer
 				 buf, buflen);
 }
 
+/*
+ * The operations below are hints that tell the controller driver how
+ * to handle I/Os with DIF or similar types of protection information.
+ */
+
+enum scsi_prot_operations {
+	/* Normal I/O */
+	SCSI_PROT_NORMAL = 0,
+
+	/* OS-HBA: Protected, HBA-Target: Unprotected */
+	SCSI_PROT_READ_INSERT,
+	SCSI_PROT_WRITE_STRIP,
+
+	/* OS-HBA: Unprotected, HBA-Target: Protected */
+	SCSI_PROT_READ_STRIP,
+	SCSI_PROT_WRITE_INSERT,
+
+	/* OS-HBA: Protected, HBA-Target: Protected */
+	SCSI_PROT_READ_PASS,
+	SCSI_PROT_WRITE_PASS,
+
+	/* OS-HBA: Protected, HBA-Target: Protected, checksum conversion */
+	SCSI_PROT_READ_CONVERT,
+	SCSI_PROT_WRITE_CONVERT,
+};
+
 static inline unsigned scsi_prot_sg_count(struct scsi_cmnd *cmd)
 {
 	return cmd->prot_sdb ? cmd->prot_sdb->table.nents : 0;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -75,6 +75,7 @@ struct scsi_eh_save {
 	int result;
 	enum dma_data_direction data_direction;
 	unsigned char cmd_len;
+	unsigned char prot_op;
 	unsigned char *cmnd;
 	struct scsi_data_buffer sdb;
 	struct request *next_rq;


