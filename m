From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 11/24][RFC] libata: Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon,  4 Feb 2008 18:58:43 +0200
Message-ID: <1202144323-4938-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:54649 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYBDREE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:04:04 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  both libata-scsi and libata-eh used a cooked up
  REQUEST_SENSE command to retrieve sense data. Use
  of the scsi_eh_{prep,restore}_cmnd() can facilitate
  and simplify the code. And insulates code from scsi
  future changes.

  Am I right in assuming that ata_exec_internal_sg() executes
  synchronously (called from atapi_eh_request_sense()) and
  once returned contain valid sense data?

  Also other places in libata where converted to new scsi_eh
  API and accessors.

  Set shost->sense_buffsize in ata_scsi_add_hosts() for all drivers.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/ata/libata-eh.c   |   29 +++++++++++------------------
 drivers/ata/libata-scsi.c |   44 ++++++++++++++++++++++----------------------
 include/linux/libata.h    |    3 +++
 3 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4e31071..9f02be4 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1270,29 +1270,19 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 {
 	struct ata_device *dev = qc->dev;
-	unsigned char *sense_buf = qc->scsicmd->sense_buffer;
 	struct ata_port *ap = dev->link->ap;
 	struct ata_taskfile tf;
-	u8 cdb[ATAPI_CDB_LEN];
+	struct scsi_eh_save ses;
+	struct scsi_cmnd *cmd = qc->scsicmd;
+	int ret;
 
 	DPRINTK("ATAPI request sense\n");
 
-	/* FIXME: is this needed? */
-	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
-
-	/* initialize sense_buf with the error register,
-	 * for the case where they are -not- overwritten
-	 */
-	sense_buf[0] = 0x70;
-	sense_buf[2] = qc->result_tf.feature >> 4;
-
+	/*?? Is there a maximum size here that ATAPI will confuse if more ??*/
+	scsi_eh_prep_cmnd(cmd, &ses, NULL, 0, ~0);
 	/* some devices time out if garbage left in tf */
 	ata_tf_init(dev, &tf);
 
-	memset(cdb, 0, ATAPI_CDB_LEN);
-	cdb[0] = REQUEST_SENSE;
-	cdb[4] = SCSI_SENSE_BUFFERSIZE;
-
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 
@@ -1302,12 +1292,15 @@ static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 		tf.feature |= ATAPI_PKT_DMA;
 	} else {
 		tf.protocol = ATAPI_PROT_PIO;
-		tf.lbam = SCSI_SENSE_BUFFERSIZE;
+		tf.lbam = scsi_bufflen(cmd);
 		tf.lbah = 0;
 	}
 
-	return ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
-				 sense_buf, SCSI_SENSE_BUFFERSIZE, 0);
+	ret = ata_exec_internal_sg(dev, &tf, cmd->cmnd, DMA_FROM_DEVICE,
+				 scsi_sglist(cmd), scsi_sg_count(cmd), 0);
+
+	scsi_eh_restore_cmnd(cmd, &ses);
+	return ret;
 }
 
 /**
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c02c490..652fce4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -705,11 +705,11 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	unsigned char *sb = cmd->sense_buffer;
+	unsigned char sb[24];
 	unsigned char *desc = sb + 8;
 	int verbose = qc->ap->ops->error_handler == NULL;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(sb, 0, sizeof(sb));
 
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
@@ -758,6 +758,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 		desc[8] = tf->hob_lbam;
 		desc[10] = tf->hob_lbah;
 	}
+	scsi_eh_cpy_sense(cmd, sb, sizeof(sb));
 }
 
 /**
@@ -775,12 +776,12 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	unsigned char *sb = cmd->sense_buffer;
+	u8 sb[24];
 	unsigned char *desc = sb + 8;
 	int verbose = qc->ap->ops->error_handler == NULL;
 	u64 block;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(sb, 0, sizeof(sb));
 
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
@@ -811,6 +812,8 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	desc[9] = block >> 16;
 	desc[10] = block >> 8;
 	desc[11] = block;
+
+	scsi_eh_cpy_sense(cmd, sb, sizeof(sb));
 }
 
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
@@ -2277,13 +2280,17 @@ unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
 
 void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
+	u8 sb[14];
+
+	memset(sb, 0, sizeof(sb));
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
-	cmd->sense_buffer[0] = 0x70;	/* fixed format, current */
-	cmd->sense_buffer[2] = sk;
-	cmd->sense_buffer[7] = 18 - 8;	/* additional sense length */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	sb[0] = 0x70;	/* fixed format, current */
+	sb[2] = sk;
+	sb[7] = 18 - 8;	/* additional sense length */
+	sb[12] = asc;
+	sb[13] = ascq;
+	scsi_eh_cpy_sense(cmd, sb, sizeof(sb));
 }
 
 /**
@@ -2311,6 +2318,7 @@ void ata_scsi_badcmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *), u8
 
 static void atapi_sense_complete(struct ata_queued_cmd *qc)
 {
+	scsi_eh_restore_cmnd(qc->scsicmd, &qc->ses);
 	if (qc->err_mask && ((qc->err_mask & AC_ERR_DEV) == 0)) {
 		/* FIXME: not quite right; we don't want the
 		 * translation of taskfile registers into
@@ -2337,25 +2345,16 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 
 	DPRINTK("ATAPI request sense\n");
 
-	/* FIXME: is this needed? */
-	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
 	ap->ops->tf_read(ap, &qc->tf);
 
-	/* fill these in, for the case where they are -not- overwritten */
-	cmd->sense_buffer[0] = 0x70;
-	cmd->sense_buffer[2] = qc->tf.feature >> 4;
-
 	ata_qc_reinit(qc);
 
-	/* setup sg table and init transfer direction */
-	sg_init_one(&qc->sgent, cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	ata_sg_init(qc, &qc->sgent, 1);
-	qc->dma_dir = DMA_FROM_DEVICE;
+	scsi_eh_prep_cmnd(cmd, &qc->ses, NULL, 0, SCSI_SENSE_BUFFERSIZE);
 
+	ata_sg_init(qc, scsi_sglist(cmd), scsi_sg_count(cmd));
+	qc->dma_dir = cmd->sc_data_direction;
 	memset(&qc->cdb, 0, qc->dev->cdb_len);
-	qc->cdb[0] = REQUEST_SENSE;
-	qc->cdb[4] = SCSI_SENSE_BUFFERSIZE;
+	memcpy(qc->cdb, cmd->cmnd, cmd->cmd_len);
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	qc->tf.command = ATA_CMD_PACKET;
@@ -3141,6 +3140,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
+		shost->sense_buffsize = SCSI_SENSE_BUFFERSIZE;
 
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4374c42..6f2974f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -34,6 +34,7 @@
 #include <linux/ata.h>
 #include <linux/workqueue.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
 
@@ -454,6 +455,8 @@ struct ata_queued_cmd {
 	struct ata_taskfile	tf;
 	u8			cdb[ATAPI_CDB_LEN];
 
+	struct scsi_eh_save	ses;
+
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
-- 
1.5.3.3

