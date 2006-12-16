From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] [PATCH] libata: take scmd->cmd_len into account when translating SCSI commands
Date: Sat, 16 Dec 2006 19:43:31 +0900
Message-ID: <20061216104331.GA5400@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:9270 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbWLPKnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Dec 2006 05:43:47 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1058700uga
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2006 02:43:46 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

libata depended on SCSI command to have the correct length when
tranlating it into an ATA command.  This generally worked for commands
issued by SCSI HLD but user could issue arbitrary broken command using
sg interface.

Also, when building ATAPI command, full command size was always
copied.  Because some ATAPI devices needs bytes after CDB cleared, if
upper layer doesn't clear bytes after CDB, such devices will
malfunction.  This necessiated recent clear-garbage-after-CDB fix in
sg interfaces.  However, scsi_execute() isn't fixed yet and HL-DT-ST
DVD-RAM GSA-H30N malfunctions on initialization commands issued from
SCSI.

This patch updates libata xlat functions.

* SCSI cmd_len is always considered.  Each translation function checks
  for proper cmd_len and ATAPI translaation clears bytes after CDB.

* Don't pass CDB as argument to xlat functions.  xlat functions need
  to access more than just CDB and they have already been accessing scmd
  via qc->scsicmd.  Just pass in qc.

* Variable names are normalized.  scsi_cmnd is scmd and CDB, cdb.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
---
 drivers/ata/libata-scsi.c |  187 ++++++++++++++++++++++++---------------------
 1 files changed, 100 insertions(+), 87 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a4790be..f82871c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -51,7 +51,7 @@
 
 #define SECTOR_SIZE	512
 
-typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc, const u8 *scsicmd);
+typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
 static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
@@ -935,7 +935,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
- *	@scsicmd: SCSI command to translate
  *
  *	Sets up an ATA taskfile to issue STANDBY (to stop) or READ VERIFY
  *	(to start). Perhaps these commands should be preceded by
@@ -948,22 +947,25 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
  *	RETURNS:
  *	Zero on success, non-zero on error.
  */
-
-static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc,
-					     const u8 *scsicmd)
+static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 {
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
 	struct ata_taskfile *tf = &qc->tf;
 
+	if (scmd->cmd_len < 5)
+		goto invalid_fld;
+
 	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
 	tf->protocol = ATA_PROT_NODATA;
-	if (scsicmd[1] & 0x1) {
+	if (cdb[1] & 0x1) {
 		;	/* ignore IMMED bit, violates sat-r05 */
 	}
-	if (scsicmd[4] & 0x2)
-		goto invalid_fld;       /* LOEJ bit set not supported */
-	if (((scsicmd[4] >> 4) & 0xf) != 0)
-		goto invalid_fld;       /* power conditions not supported */
-	if (scsicmd[4] & 0x1) {
+	if (cdb[4] & 0x2)
+		goto invalid_fld;	/* LOEJ bit set not supported */
+	if (((cdb[4] >> 4) & 0xf) != 0)
+		goto invalid_fld;	/* power conditions not supported */
+	if (cdb[4] & 0x1) {
 		tf->nsect = 1;	/* 1 sector, lba=0 */
 
 		if (qc->dev->flags & ATA_DFLAG_LBA) {
@@ -996,16 +998,14 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc,
 	return 0;
 
 invalid_fld:
-	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
 }
 
-
 /**
  *	ata_scsi_flush_xlat - Translate SCSI SYNCHRONIZE CACHE command
  *	@qc: Storage for translated ATA taskfile
- *	@scsicmd: SCSI command to translate (ignored)
  *
  *	Sets up an ATA taskfile to issue FLUSH CACHE or
  *	FLUSH CACHE EXT.
@@ -1016,8 +1016,7 @@ invalid_fld:
  *	RETURNS:
  *	Zero on success, non-zero on error.
  */
-
-static unsigned int ata_scsi_flush_xlat(struct ata_queued_cmd *qc, const u8 *scsicmd)
+static unsigned int ata_scsi_flush_xlat(struct ata_queued_cmd *qc)
 {
 	struct ata_taskfile *tf = &qc->tf;
 
@@ -1128,7 +1127,6 @@ static void scsi_16_lba_len(const u8 *scsicmd, u64 *plba, u32 *plen)
 /**
  *	ata_scsi_verify_xlat - Translate SCSI VERIFY command into an ATA one
  *	@qc: Storage for translated ATA taskfile
- *	@scsicmd: SCSI command to translate
  *
  *	Converts SCSI VERIFY command to an ATA READ VERIFY command.
  *
@@ -1136,11 +1134,12 @@ static void scsi_16_lba_len(const u8 *scsicmd, u64 *plba, u32 *plen)
  *	spin_lock_irqsave(host lock)
  *
  *	RETURNS:
- *	Zero on success, non-zero on error.
+ *	Zero on success, -errno on error.
  */
-
-static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc, const u8 *scsicmd)
+static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 {
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
 	u64 dev_sectors = qc->dev->n_sectors;
@@ -1150,11 +1149,15 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc, const u8 *sc
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf->protocol = ATA_PROT_NODATA;
 
-	if (scsicmd[0] == VERIFY)
-		scsi_10_lba_len(scsicmd, &block, &n_block);
-	else if (scsicmd[0] == VERIFY_16)
-		scsi_16_lba_len(scsicmd, &block, &n_block);
-	else
+	if (cdb[0] == VERIFY) {
+		if (scmd->cmd_len < 10)
+			goto invalid_fld;
+		scsi_10_lba_len(cdb, &block, &n_block);
+	} else if (cdb[0] == VERIFY_16) {
+		if (scmd->cmd_len < 16)
+			goto invalid_fld;
+		scsi_16_lba_len(cdb, &block, &n_block);
+	} else
 		goto invalid_fld;
 
 	if (!n_block)
@@ -1229,24 +1232,23 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc, const u8 *sc
 	return 0;
 
 invalid_fld:
-	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
 
 out_of_range:
-	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x21, 0x0);
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x21, 0x0);
 	/* "Logical Block Address out of range" */
 	return 1;
 
 nothing_to_do:
-	qc->scsicmd->result = SAM_STAT_GOOD;
+	scmd->result = SAM_STAT_GOOD;
 	return 1;
 }
 
 /**
  *	ata_scsi_rw_xlat - Translate SCSI r/w command into an ATA one
  *	@qc: Storage for translated ATA taskfile
- *	@scsicmd: SCSI command to translate
  *
  *	Converts any of six SCSI read/write commands into the
  *	ATA counterpart, including starting sector (LBA),
@@ -1262,29 +1264,33 @@ nothing_to_do:
  *	RETURNS:
  *	Zero on success, non-zero on error.
  */
-
-static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc, const u8 *scsicmd)
+static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
 	unsigned int tf_flags = 0;
 	u64 block;
 	u32 n_block;
 	int rc;
 
-	if (scsicmd[0] == WRITE_10 || scsicmd[0] == WRITE_6 ||
-	    scsicmd[0] == WRITE_16)
+	if (cdb[0] == WRITE_10 || cdb[0] == WRITE_6 || cdb[0] == WRITE_16)
 		tf_flags |= ATA_TFLAG_WRITE;
 
 	/* Calculate the SCSI LBA, transfer length and FUA. */
-	switch (scsicmd[0]) {
+	switch (cdb[0]) {
 	case READ_10:
 	case WRITE_10:
-		scsi_10_lba_len(scsicmd, &block, &n_block);
-		if (unlikely(scsicmd[1] & (1 << 3)))
+		if (unlikely(scmd->cmd_len < 10))
+			goto invalid_fld;
+		scsi_10_lba_len(cdb, &block, &n_block);
+		if (unlikely(cdb[1] & (1 << 3)))
 			tf_flags |= ATA_TFLAG_FUA;
 		break;
 	case READ_6:
 	case WRITE_6:
-		scsi_6_lba_len(scsicmd, &block, &n_block);
+		if (unlikely(scmd->cmd_len < 6))
+			goto invalid_fld;
+		scsi_6_lba_len(cdb, &block, &n_block);
 
 		/* for 6-byte r/w commands, transfer length 0
 		 * means 256 blocks of data, not 0 block.
@@ -1294,8 +1300,10 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc, const u8 *scsicm
 		break;
 	case READ_16:
 	case WRITE_16:
-		scsi_16_lba_len(scsicmd, &block, &n_block);
-		if (unlikely(scsicmd[1] & (1 << 3)))
+		if (unlikely(scmd->cmd_len < 16))
+			goto invalid_fld;
+		scsi_16_lba_len(cdb, &block, &n_block);
+		if (unlikely(cdb[1] & (1 << 3)))
 			tf_flags |= ATA_TFLAG_FUA;
 		break;
 	default:
@@ -1326,17 +1334,17 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc, const u8 *scsicm
 		goto out_of_range;
 	/* treat all other errors as -EINVAL, fall through */
 invalid_fld:
-	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
 
 out_of_range:
-	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x21, 0x0);
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x21, 0x0);
 	/* "Logical Block Address out of range" */
 	return 1;
 
 nothing_to_do:
-	qc->scsicmd->result = SAM_STAT_GOOD;
+	scmd->result = SAM_STAT_GOOD;
 	return 1;
 }
 
@@ -1456,7 +1464,6 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			      ata_xlat_func_t xlat_func)
 {
 	struct ata_queued_cmd *qc;
-	u8 *scsicmd = cmd->cmnd;
 	int is_io = xlat_func == ata_scsi_rw_xlat;
 
 	VPRINTK("ENTER\n");
@@ -1488,7 +1495,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	qc->complete_fn = ata_scsi_qc_complete;
 
-	if (xlat_func(qc, scsicmd))
+	if (xlat_func(qc))
 		goto early_finish;
 
 	/* select device, send command to hardware */
@@ -2344,7 +2351,6 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 /**
  *	atapi_xlat - Initialize PACKET taskfile
  *	@qc: command structure to be initialized
- *	@scsicmd: SCSI CDB associated with this PACKET command
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -2352,25 +2358,25 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
  *	RETURNS:
  *	Zero on success, non-zero on failure.
  */
-
-static unsigned int atapi_xlat(struct ata_queued_cmd *qc, const u8 *scsicmd)
+static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 {
-	struct scsi_cmnd *cmd = qc->scsicmd;
+	struct scsi_cmnd *scmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
 	int using_pio = (dev->flags & ATA_DFLAG_PIO);
-	int nodata = (cmd->sc_data_direction == DMA_NONE);
+	int nodata = (scmd->sc_data_direction == DMA_NONE);
 
 	if (!using_pio)
 		/* Check whether ATAPI DMA is safe */
 		if (ata_check_atapi_dma(qc))
 			using_pio = 1;
 
-	memcpy(&qc->cdb, scsicmd, dev->cdb_len);
+	memset(qc->cdb, 0, dev->cdb_len);
+	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
-	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
 		qc->tf.flags |= ATA_TFLAG_WRITE;
 		DPRINTK("direction: write\n");
 	}
@@ -2392,12 +2398,12 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc, const u8 *scsicmd)
 		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
 		qc->tf.feature |= ATAPI_PKT_DMA;
 
-		if (atapi_dmadir && (cmd->sc_data_direction != DMA_TO_DEVICE))
+		if (atapi_dmadir && (scmd->sc_data_direction != DMA_TO_DEVICE))
 			/* some SATA bridges need us to indicate data xfer direction */
 			qc->tf.feature |= ATAPI_DMADIR;
 	}
 
-	qc->nbytes = cmd->request_bufflen;
+	qc->nbytes = scmd->request_bufflen;
 
 	return 0;
 }
@@ -2517,7 +2523,6 @@ ata_scsi_map_proto(u8 byte1)
 /**
  *	ata_scsi_pass_thru - convert ATA pass-thru CDB to taskfile
  *	@qc: command structure to be initialized
- *	@scsicmd: SCSI command to convert
  *
  *	Handles either 12 or 16-byte versions of the CDB.
  *
@@ -2525,20 +2530,21 @@ ata_scsi_map_proto(u8 byte1)
  *	Zero on success, non-zero on failure.
  */
 static unsigned int
-ata_scsi_pass_thru(struct ata_queued_cmd *qc, const u8 *scsicmd)
+ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 {
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
 	struct ata_taskfile *tf = &(qc->tf);
-	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
 
-	if ((tf->protocol = ata_scsi_map_proto(scsicmd[1])) == ATA_PROT_UNKNOWN)
+	if ((tf->protocol = ata_scsi_map_proto(cdb[1])) == ATA_PROT_UNKNOWN)
 		goto invalid_fld;
 
 	/* We may not issue DMA commands if no DMA mode is set */
 	if (tf->protocol == ATA_PROT_DMA && dev->dma_mode == 0)
 		goto invalid_fld;
 
-	if (scsicmd[1] & 0xe0)
+	if (cdb[1] & 0xe0)
 		/* PIO multi not supported yet */
 		goto invalid_fld;
 
@@ -2546,18 +2552,18 @@ ata_scsi_pass_thru(struct ata_queued_cmd *qc, const u8 *scsicmd)
 	 * 12 and 16 byte CDBs use different offsets to
 	 * provide the various register values.
 	 */
-	if (scsicmd[0] == ATA_16) {
+	if (cdb[0] == ATA_16) {
 		/*
 		 * 16-byte CDB - may contain extended commands.
 		 *
 		 * If that is the case, copy the upper byte register values.
 		 */
-		if (scsicmd[1] & 0x01) {
-			tf->hob_feature = scsicmd[3];
-			tf->hob_nsect = scsicmd[5];
-			tf->hob_lbal = scsicmd[7];
-			tf->hob_lbam = scsicmd[9];
-			tf->hob_lbah = scsicmd[11];
+		if (cdb[1] & 0x01) {
+			tf->hob_feature = cdb[3];
+			tf->hob_nsect = cdb[5];
+			tf->hob_lbal = cdb[7];
+			tf->hob_lbam = cdb[9];
+			tf->hob_lbah = cdb[11];
 			tf->flags |= ATA_TFLAG_LBA48;
 		} else
 			tf->flags &= ~ATA_TFLAG_LBA48;
@@ -2565,26 +2571,26 @@ ata_scsi_pass_thru(struct ata_queued_cmd *qc, const u8 *scsicmd)
 		/*
 		 * Always copy low byte, device and command registers.
 		 */
-		tf->feature = scsicmd[4];
-		tf->nsect = scsicmd[6];
-		tf->lbal = scsicmd[8];
-		tf->lbam = scsicmd[10];
-		tf->lbah = scsicmd[12];
-		tf->device = scsicmd[13];
-		tf->command = scsicmd[14];
+		tf->feature = cdb[4];
+		tf->nsect = cdb[6];
+		tf->lbal = cdb[8];
+		tf->lbam = cdb[10];
+		tf->lbah = cdb[12];
+		tf->device = cdb[13];
+		tf->command = cdb[14];
 	} else {
 		/*
 		 * 12-byte CDB - incapable of extended commands.
 		 */
 		tf->flags &= ~ATA_TFLAG_LBA48;
 
-		tf->feature = scsicmd[3];
-		tf->nsect = scsicmd[4];
-		tf->lbal = scsicmd[5];
-		tf->lbam = scsicmd[6];
-		tf->lbah = scsicmd[7];
-		tf->device = scsicmd[8];
-		tf->command = scsicmd[9];
+		tf->feature = cdb[3];
+		tf->nsect = cdb[4];
+		tf->lbal = cdb[5];
+		tf->lbam = cdb[6];
+		tf->lbah = cdb[7];
+		tf->device = cdb[8];
+		tf->command = cdb[9];
 	}
 	/*
 	 * If slave is possible, enforce correct master/slave bit
@@ -2611,7 +2617,7 @@ ata_scsi_pass_thru(struct ata_queued_cmd *qc, const u8 *scsicmd)
 	 */
 	tf->flags |= (ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE);
 
-	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+	if (scmd->sc_data_direction == DMA_TO_DEVICE)
 		tf->flags |= ATA_TFLAG_WRITE;
 
 	/*
@@ -2620,7 +2626,7 @@ ata_scsi_pass_thru(struct ata_queued_cmd *qc, const u8 *scsicmd)
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nsect = cmd->request_bufflen / ATA_SECT_SIZE;
+	qc->nsect = scmd->request_bufflen / ATA_SECT_SIZE;
 
 	/* request result TF */
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
@@ -2628,7 +2634,7 @@ ata_scsi_pass_thru(struct ata_queued_cmd *qc, const u8 *scsicmd)
 	return 0;
 
  invalid_fld:
-	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x00);
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x00);
 	/* "Invalid field in cdb" */
 	return 1;
 }
@@ -2701,22 +2707,29 @@ static inline void ata_scsi_dump_cdb(struct ata_port *ap,
 #endif
 }
 
-static inline int __ata_scsi_queuecmd(struct scsi_cmnd *cmd,
+static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 				      void (*done)(struct scsi_cmnd *),
 				      struct ata_device *dev)
 {
 	int rc = 0;
 
+	if (unlikely(!scmd->cmd_len)) {
+		ata_dev_printk(dev, KERN_WARNING, "WARNING: zero len CDB\n");
+		scmd->result = DID_ERROR << 16;
+		done(scmd);
+		return 0;
+	}
+
 	if (dev->class == ATA_DEV_ATA) {
 		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
-							      cmd->cmnd[0]);
+							      scmd->cmnd[0]);
 
 		if (xlat_func)
-			rc = ata_scsi_translate(dev, cmd, done, xlat_func);
+			rc = ata_scsi_translate(dev, scmd, done, xlat_func);
 		else
-			ata_scsi_simulate(dev, cmd, done);
+			ata_scsi_simulate(dev, scmd, done);
 	} else
-		rc = ata_scsi_translate(dev, cmd, done, atapi_xlat);
+		rc = ata_scsi_translate(dev, scmd, done, atapi_xlat);
 
 	return rc;
 }
-- 
1.4.4.2

