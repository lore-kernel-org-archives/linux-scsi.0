From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 2/2] libata: MODE SELECT, add command
Date: Sun, 23 Oct 2005 16:25:07 +1000
Message-ID: <435B2CC3.9040203@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060900020908040705030608"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060900020908040705030608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Patch against libata-dev git tree, upstream branch

Changelog:
  - decode MODE SELECT SCSI command
  - only two attributes are translated to the SET FEATURES
    ATA command: WCE and DRA
  - moved relative position of ata_scsi_rbuf_get+put() to
    make them visible to ata_scsi_mode_select_xlat()

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------060900020908040705030608
Content-Type: text/x-patch;
 name="libata-scsi051023ms2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-scsi051023ms2.diff"

--- libata-dev/drivers/scsi/libata-scsi.c	2005-10-23 14:15:01.000000000 +1000
+++ libata-dev/drivers/scsi/libata-scsi.c051023ms2	2005-10-23 14:47:07.000000000 +1000
@@ -922,6 +922,188 @@
 }
 
 /**
+ *	ata_scsi_rbuf_get - Map response buffer.
+ *	@cmd: SCSI command containing buffer to be mapped.
+ *	@buf_out: Pointer to mapped area.
+ *
+ *	Maps buffer contained within SCSI command @cmd.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ *
+ *	RETURNS:
+ *	Length of response buffer.
+ */
+
+static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
+{
+	u8 *buf;
+	unsigned int buflen;
+
+	if (cmd->use_sg) {
+		struct scatterlist *sg;
+
+		sg = (struct scatterlist *) cmd->request_buffer;
+		buf = kmap_atomic(sg->page, KM_USER0) + sg->offset;
+		buflen = sg->length;
+	} else {
+		buf = cmd->request_buffer;
+		buflen = cmd->request_bufflen;
+	}
+
+	*buf_out = buf;
+	return buflen;
+}
+
+/**
+ *	ata_scsi_rbuf_put - Unmap response buffer.
+ *	@cmd: SCSI command containing buffer to be unmapped.
+ *	@buf: buffer to unmap
+ *
+ *	Unmaps response buffer contained within @cmd.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ */
+
+static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
+{
+	if (cmd->use_sg) {
+		struct scatterlist *sg;
+
+		sg = (struct scatterlist *) cmd->request_buffer;
+		kunmap_atomic(buf - sg->offset, KM_USER0);
+	}
+}
+
+/**
+ *	ata_scsi_mode_select_xlat - Translate SCSI MODE SELECT commands
+ *	@qc: Storage for translated ATA taskfile
+ *	@scsicmd: SCSI command to translate
+ *
+ *	Sets up an ATA taskfile to issue SET FEATURES, if required.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ *
+ *	RETURNS:
+ *	Zero on success and setup ATA command to execute,
+ *	returns 1 otherwise which includes no ATA command to execute.
+ */
+
+static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc,
+					      const u8 *scsicmd)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *cmd = qc->scsicmd;
+	unsigned int param_len, ten, buflen, minlen, bdlen, offset;
+	unsigned int pglen, spf, mpg, wce, dra;
+	u8 *rbuf;
+	u8 apage[64];
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	cmd->result = SAM_STAT_GOOD;
+	if (! (scsicmd[1] & 0x10))
+		goto invalid_fld;	/* require PF bit set */
+	ten = (scsicmd[0] == MODE_SELECT_10) ? 1 : 0;
+	param_len =  ten ? ((scsicmd[7] << 8) + scsicmd[8]) : scsicmd[4];
+	if (param_len < (ten ? 8 : 4))
+		goto nothing_to_do;	/* not defined as an error but */
+        buflen = ata_scsi_rbuf_get(cmd, &rbuf);
+	minlen = (param_len < buflen) ? param_len : buflen;
+	bdlen = ten ? ((rbuf[6] << 8) + rbuf[7]) : rbuf[3];
+	offset = (ten ? 8 : 4) + bdlen;
+	if (minlen > offset) {
+		memset(apage, 0, sizeof(apage));
+		pglen = minlen - offset;
+		pglen = (pglen < sizeof(apage)) ? pglen : sizeof(apage);
+		memcpy(apage, rbuf + offset, pglen);
+	}
+	ata_scsi_rbuf_put(cmd, rbuf);
+	if (minlen == offset)
+		goto nothing_to_do;	/* not defined as an error but */
+	if (minlen < offset)
+		goto bad_param;
+	minlen -= offset;
+	spf = !!(apage[0] & 0x40);
+	mpg = apage[0] & 0x3f;
+	/* mspg = spf ? apage[1] : 0; */
+	if (spf)
+		goto bad_param;
+	else
+		pglen = apage[1];
+		if (pglen + 2 < minlen)
+			goto bad_param;
+	switch (mpg) {
+	case RW_RECOVERY_MPAGE:
+		if (pglen != def_rw_recovery_mpage[1])
+			goto bad_param;
+		break;
+	case CACHE_MPAGE:
+		if (pglen != def_cache_mpage[1])
+			goto bad_param;
+		wce = !!(apage[2] & 0x4);
+		dra = !!(apage[12] & 0x20);
+		if (wce != !!(ata_id_wcache_enabled(qc->dev->id))) {
+			/* write(back) cache */
+			if (wce)
+				tf->feature = 0x2;	/* WCE -> enable */
+			else
+				tf->feature = 0x82;	/* disable */
+			tf->command = ATA_CMD_SET_FEATURES;
+			/* <<< If success, should dev->id be updated? >>> */
+			/* vvvvvvv   start of dubious code   vvvvvvvvvv */
+			if (wce)
+				qc->dev->id[85] |= 0x20;
+			else
+				qc->dev->id[85] &= ~0x20;
+			/* vvvvvvv   end of dubious code   vvvvvvvvvv */
+			return 0;
+		}
+/* FIXME: we may want to issue two SET FEATURES commands here */
+		if (dra != !(ata_id_rahead_enabled(qc->dev->id))) {
+			/* read look ahead */
+			if (dra)
+				tf->feature = 0x55;	/* DRA -> disable */
+			else
+				tf->feature = 0xaa;	/* enable */
+			tf->command = ATA_CMD_SET_FEATURES;
+			/* <<< If success, should dev->id be updated? >>> */
+			/* vvvvvvv   start of dubious code   vvvvvvvvvv */
+			if (dra)
+				qc->dev->id[85] &= ~0x40;
+			else
+				qc->dev->id[85] |= 0x40;
+			/* vvvvvvv   end of dubious code   vvvvvvvvvv */
+			return 0;
+		} 
+		break;
+	case CONTROL_MPAGE:
+		if (pglen != def_control_mpage[1])
+			goto bad_param;
+		break;
+	default:
+		goto bad_param;
+	}
+	/* fall through, nothing to do */
+
+nothing_to_do:
+	qc->scsicmd->result = SAM_STAT_GOOD;
+	return 1;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
+	return 1;
+
+bad_param:
+	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x26, 0x0);
+        /* "Invalid field in parameter list" */
+	return 1;
+}
+
+/**
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@ap: ATA port to which the command is addressed
  *	@dev: ATA device to which the command is addressed
@@ -1006,61 +1188,6 @@
 }
 
 /**
- *	ata_scsi_rbuf_get - Map response buffer.
- *	@cmd: SCSI command containing buffer to be mapped.
- *	@buf_out: Pointer to mapped area.
- *
- *	Maps buffer contained within SCSI command @cmd.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host_set lock)
- *
- *	RETURNS:
- *	Length of response buffer.
- */
-
-static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
-{
-	u8 *buf;
-	unsigned int buflen;
-
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
-		buf = kmap_atomic(sg->page, KM_USER0) + sg->offset;
-		buflen = sg->length;
-	} else {
-		buf = cmd->request_buffer;
-		buflen = cmd->request_bufflen;
-	}
-
-	*buf_out = buf;
-	return buflen;
-}
-
-/**
- *	ata_scsi_rbuf_put - Unmap response buffer.
- *	@cmd: SCSI command containing buffer to be unmapped.
- *	@buf: buffer to unmap
- *
- *	Unmaps response buffer contained within @cmd.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host_set lock)
- */
-
-static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
-{
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
-		kunmap_atomic(buf - sg->offset, KM_USER0);
-	}
-}
-
-/**
  *	ata_scsi_rbuf_fill - wrapper for SCSI command simulators
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@actor: Callback hook for desired SCSI command simulator
@@ -1878,6 +2005,9 @@
 		return ata_scsi_verify_xlat;
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
+	case MODE_SELECT:
+	case MODE_SELECT_10:
+		return ata_scsi_mode_select_xlat;
 	}
 
 	return NULL;
@@ -2014,11 +2144,6 @@
 			ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
 			break;
 
-		case MODE_SELECT:	/* unconditionally return */
-		case MODE_SELECT_10:	/* bad-field-in-cdb */
-			ata_scsi_invalid_field(cmd, done);
-			break;
-
 		case READ_CAPACITY:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 			break;

--------------060900020908040705030608--
