From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] libata: scsi error handling
Date: Sun, 28 Aug 2005 15:38:41 +1000
Message-ID: <43114DE1.7090406@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030308020902050803060900"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:13796 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751115AbVH1Fig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 01:38:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.
--------------030308020902050803060900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff,
Here is a follow on patch based on lk 2.6.13-rc7
plus the start_stop_unit patch and the rw_zero_length
patch.

It adds more general error processing, typically for
problems (or an early finish) detected while a
SCSI command is being processed prior to an ATA
command being executed.

Changelog:
  - add extern ata_scsi_set_sense() to build SCSI
    sense data and corresponding status
  - this allows removal of extern ata_scsi_badcmd()
    and static inline ata_bad_scsiop() and ata_bad_cdb()
  - change "xlat" functions in libata-scsi so they
    are responsible for SCSI status and sense data
    when they return 1. This allows GOOD status or a
    specialized error to be set.
  - set DRIVER_SENSE when SAM_STAT_CHECK_CONDITION
    is flagged in scsi_cmnd::result
  - yield an error for mode sense requests for saved
    values [sat-r05]
  - change recent rw_zero_length patch to do nothing
    (yield GOOD status) when transfer_length==0 for
    10 and 16 byte READ and WRITE commands (SBC-2).

Doug Gilbert


--------------030308020902050803060900
Content-Type: text/x-patch;
 name="libata2613rc7ssrw0_err.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2613rc7ssrw0_err.diff"

--- linux/drivers/scsi/libata.h	2005-08-16 12:45:37.000000000 +1000
+++ linux/drivers/scsi/libata.h2613rc6xa	2005-08-17 23:01:08.000000000 +1000
@@ -69,21 +69,9 @@
 			        unsigned int buflen);
 extern unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
 				   unsigned int buflen);
-extern void ata_scsi_badcmd(struct scsi_cmnd *cmd,
-			    void (*done)(struct scsi_cmnd *),
-			    u8 asc, u8 ascq);
+extern void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq);
 extern void ata_scsi_rbuf_fill(struct ata_scsi_args *args, 
                         unsigned int (*actor) (struct ata_scsi_args *args,
                                            u8 *rbuf, unsigned int buflen));
 
-static inline void ata_bad_scsiop(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	ata_scsi_badcmd(cmd, done, 0x20, 0x00);
-}
-
-static inline void ata_bad_cdb(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	ata_scsi_badcmd(cmd, done, 0x24, 0x00);
-}
-
 #endif /* __LIBATA_H__ */
--- linux/drivers/scsi/libata-scsi.c	2005-08-28 10:44:31.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2613rc7ssrw0_err	2005-08-28 13:24:29.000000000 +1000
@@ -37,6 +37,14 @@
 static struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, struct scsi_device *scsidev);
 
+static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
+				   void (*done)(struct scsi_cmnd *))
+{
+	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
+	done(cmd);
+}
+
 
 /**
  *	ata_std_bios_param - generic bios head/sector/cylinder calculator used by sd.
@@ -171,7 +179,6 @@
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 err = 0;
-	unsigned char *sb = cmd->sense_buffer;
 	/* Based on the 3ware driver translation table */
 	static unsigned char sense_table[][4] = {
 		/* BBD|ECC|ID|MAR */
@@ -214,8 +221,6 @@
 	};
 	int i = 0;
 
-	cmd->result = SAM_STAT_CHECK_CONDITION;
-
 	/*
 	 *	Is this an error we can process/parse
 	 */
@@ -270,11 +275,9 @@
 		/* Look for best matches first */
 		if((sense_table[i][0] & err) == sense_table[i][0])
 		{
-			sb[0] = 0x70;
-			sb[2] = sense_table[i][1];
-			sb[7] = 0x0a;
-			sb[12] = sense_table[i][2];
-			sb[13] = sense_table[i][3];
+			ata_scsi_set_sense(cmd, sense_table[i][1] /* sk */,
+					   sense_table[i][2] /* asc */,
+					   sense_table[i][3] /* ascq */ );
 			return;
 		}
 		i++;
@@ -289,11 +292,9 @@
 	{
 		if(stat_table[i][0] & drv_stat)
 		{
-			sb[0] = 0x70;
-			sb[2] = stat_table[i][1];
-			sb[7] = 0x0a;
-			sb[12] = stat_table[i][2];
-			sb[13] = stat_table[i][3];
+			ata_scsi_set_sense(cmd, sense_table[i][1] /* sk */,
+					   sense_table[i][2] /* asc */,
+					   sense_table[i][3] /* ascq */ );
 			return;
 		}
 		i++;
@@ -302,15 +303,12 @@
 	printk(KERN_ERR "ata%u: called with no error (%02X)!\n", qc->ap->id, drv_stat);
 	/* additional-sense-code[-qualifier] */
 
-	sb[0] = 0x70;
-	sb[2] = MEDIUM_ERROR;
-	sb[7] = 0x0A;
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
-		sb[12] = 0x11; /* "unrecovered read error" */
-		sb[13] = 0x04;
+		ata_scsi_set_sense(cmd, MEDIUM_ERROR, 0x11, 0x4);
+		/* "unrecovered read error" */
 	} else {
-		sb[12] = 0x0C; /* "write error -             */
-		sb[13] = 0x02; /*  auto-reallocation failed" */
+		ata_scsi_set_sense(cmd, MEDIUM_ERROR, 0xc, 0x2);
+		/* "write error - auto-reallocation failed" */
 	}
 }
 
@@ -419,9 +417,9 @@
 		;	/* ignore IMMED bit, violates sat-r05 */
 	}
 	if (scsicmd[4] & 0x2)
-		return 1;	/* LOEJ bit set not supported */
+		goto invalid_fld;	/* LOEJ bit set not supported */
 	if (((scsicmd[4] >> 4) & 0xf) != 0)
-		return 1;	/* power conditions not supported */
+		goto invalid_fld;	/* power conditions not supported */
 	if (scsicmd[4] & 0x1) {
 		tf->nsect = 1;	/* 1 sector, lba=0 */
 		tf->lbah = 0x0;
@@ -442,6 +440,11 @@
 	 */
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+        /* "Invalid field in cbd" */
+	return 1;
 }
 
 
@@ -529,20 +532,20 @@
 	}
 
 	else
-		return 1;
+		goto invalid_fld;
 
 	if (!n_sect)
-		return 1;
+		goto invalid_fld;
 	if (sect >= dev_sectors)
-		return 1;
+		goto invalid_fld;
 	if ((sect + n_sect) > dev_sectors)
-		return 1;
+		goto invalid_fld;
 	if (lba48) {
 		if (n_sect > (64 * 1024))
-			return 1;
+			goto invalid_fld;
 	} else {
 		if (n_sect > 256)
-			return 1;
+			goto invalid_fld;
 	}
 
 	if (lba48) {
@@ -566,6 +569,11 @@
 	tf->lbal = sect & 0xff;
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+        /* "Invalid field in cbd" */
+	return 1;
 }
 
 /**
@@ -616,7 +624,7 @@
 			/* if we don't support LBA48 addressing, the request
 			 * -may- be too large. */
 			if ((scsicmd[2] & 0xf0) || scsicmd[7])
-				return 1;
+				goto out_of_range;
 
 			/* stores LBA27:24 in lower 4 bits of device reg */
 			tf->device |= scsicmd[2];
@@ -630,8 +638,8 @@
 		tf->lbah = scsicmd[3];
 
 		VPRINTK("ten-byte command\n");
-		if (qc->nsect == 0) /* we don't support length==0 cmds */
-			return 1;
+		if (qc->nsect == 0) /* skip length==0 cmds */
+			goto nothing_todo;
 		return 0;
 	}
 
@@ -653,8 +661,10 @@
 
 	if (scsicmd[0] == READ_16 || scsicmd[0] == WRITE_16) {
 		/* rule out impossible LBAs and sector counts */
-		if (scsicmd[2] || scsicmd[3] || scsicmd[10] || scsicmd[11])
-			return 1;
+		if (scsicmd[2] || scsicmd[3])
+			goto out_of_range;
+		if (scsicmd[10] || scsicmd[11])
+			goto invalid_fld;
 
 		if (lba48) {
 			tf->hob_nsect = scsicmd[12];
@@ -666,9 +676,10 @@
 					scsicmd[13];
 		} else {
 			/* once again, filter out impossible non-zero values */
-			if (scsicmd[4] || scsicmd[5] || scsicmd[12] ||
-			    (scsicmd[6] & 0xf0))
-				return 1;
+			if (scsicmd[4] || scsicmd[5] || (scsicmd[6] & 0xf0))
+				goto out_of_range;
+			if (scsicmd[12])
+				goto invalid_fld;
 
 			/* stores LBA27:24 in lower 4 bits of device reg */
 			tf->device |= scsicmd[6];
@@ -682,13 +693,25 @@
 		tf->lbah = scsicmd[7];
 
 		VPRINTK("sixteen-byte command\n");
-		if (qc->nsect == 0) /* we don't support length==0 cmds */
-			return 1;
+		if (qc->nsect == 0) /* skip length==0 cmds */
+			goto nothing_todo;
 		return 0;
 	}
 
+nothing_todo:
+	qc->scsicmd->result = SAM_STAT_GOOD;
 	DPRINTK("no-byte command\n");
 	return 1;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+        /* "Invalid field in cbd" */
+	return 1;
+
+out_of_range:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x21, 0x0);
+        /* "Logical Block Address out of range" */
+	return 1;
 }
 
 static int ata_scsi_qc_complete(struct ata_queued_cmd *qc, u8 drv_stat)
@@ -720,6 +743,12 @@
  *	This function sets up an ata_queued_cmd structure for the
  *	SCSI command, and sends that ata_queued_cmd to the hardware.
  *
+ *	xlat_func argument (actor) returns 0 if ready to execute ATA
+ *	command, else 1 to finish translation. If 1 is returned then
+ *	cmd->result (and possibly cmd->sense_buffer) are assumed to
+ *	be set reflecting an error condition or clean (early)
+ *	termination.
+ *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
  */
@@ -736,7 +765,7 @@
 
 	qc = ata_scsi_qc_new(ap, dev, cmd, done);
 	if (!qc)
-		return;
+		goto err_mem;
 
 	/* data is present; dma-map it */
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
@@ -744,7 +773,7 @@
 		if (unlikely(cmd->request_bufflen < 1)) {
 			printk(KERN_WARNING "ata%u(%u): WARNING: zero len r/w req\n",
 			       ap->id, dev->devno);
-			goto err_out;
+			goto err_did;
 		}
 
 		if (cmd->use_sg)
@@ -759,19 +788,28 @@
 	qc->complete_fn = ata_scsi_qc_complete;
 
 	if (xlat_func(qc, scsicmd))
-		goto err_out;
+		goto early_finish;
 
 	/* select device, send command to hardware */
 	if (ata_qc_issue(qc))
-		goto err_out;
+		goto err_did;
 
 	VPRINTK("EXIT\n");
 	return;
 
-err_out:
+early_finish:
 	ata_qc_free(qc);
-	ata_bad_cdb(cmd, done);
-	DPRINTK("EXIT - badcmd\n");
+	done(cmd);
+	DPRINTK("EXIT - early finish (good or error)\n");
+	return;
+
+err_did:
+	ata_qc_free(qc);
+err_mem:
+	cmd->result = (DID_ERROR << 16);
+	done(cmd);
+	DPRINTK("EXIT - internal\n");
+	return;
 }
 
 /**
@@ -838,7 +876,8 @@
  *	Mapping the response buffer, calling the command's handler,
  *	and handling the handler's return value.  This return value
  *	indicates whether the handler wishes the SCSI command to be
- *	completed successfully, or not.
+ *	completed successfully (0), or not (in which case cmd->result
+ *	and sense buffer are assumed to be set).
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -857,12 +896,9 @@
 	rc = actor(args, rbuf, buflen);
 	ata_scsi_rbuf_put(cmd, rbuf);
 
-	if (rc)
-		ata_bad_cdb(cmd, args->done);
-	else {
+	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
-		args->done(cmd);
-	}
+	args->done(cmd);
 }
 
 /**
@@ -1168,8 +1204,16 @@
 	 * in the same manner)
 	 */
 	page_control = scsicmd[2] >> 6;
-	if ((page_control != 0) && (page_control != 3))
-		return 1;
+	switch (page_control) {
+	case 0:	/* current */
+		break;	/* supported */
+	case 3:	/* saved */
+		goto saving_not_supp;
+	case 1:	/* changeable */
+	case 2:	/* defaults */
+	default:
+		goto invalid_fld;
+	}
 
 	if (six_byte)
 		output_len = 4;
@@ -1200,7 +1244,7 @@
 		break;
 
 	default:		/* invalid page code */
-		return 1;
+		goto invalid_fld;
 	}
 
 	if (six_byte) {
@@ -1213,6 +1257,16 @@
 	}
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(args->cmd, ILLEGAL_REQUEST, 0x24, 0x0);
+        /* "Invalid field in cbd" */
+	return 1;
+
+saving_not_supp:
+	ata_scsi_set_sense(args->cmd, ILLEGAL_REQUEST, 0x39, 0x0);
+        /* "Saving parameters not supported" */
+	return 1;
 }
 
 /**
@@ -1302,6 +1356,34 @@
 }
 
 /**
+ *	ata_scsi_set_sense - Set SCSI sense data and status
+ *	@cmd: SCSI request to be handled
+ *	@sk: SCSI-defined sense key
+ *	@asc: SCSI-defined additional sense code
+ *	@ascq: SCSI-defined additional sense code qualifier
+ *
+ *	Helper function that builds a valid fixed format, current
+ *	response code and the given sense key (sk), additional sense
+ *	code (asc) and additional sense code qualifier (ascq) with
+ *	a SCSI command status of %SAM_STAT_CHECK_CONDITION and
+ *	DRIVER_SENSE set in the upper bits of scsi_cmnd::result .
+ *
+ *	LOCKING:
+ *	Not required
+ */
+
+void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
+{
+	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+	cmd->sense_buffer[0] = 0x70;	/* fixed format, current */
+	cmd->sense_buffer[2] = sk;
+	cmd->sense_buffer[7] = 18 - 8;	/* additional sense length */
+	cmd->sense_buffer[12] = asc;
+	cmd->sense_buffer[13] = ascq;
+}
+
+/**
  *	ata_scsi_badcmd - End a SCSI request with an error
  *	@cmd: SCSI request to be handled
  *	@done: SCSI command completion function
@@ -1319,13 +1401,7 @@
 void ata_scsi_badcmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *), u8 asc, u8 ascq)
 {
 	DPRINTK("ENTER\n");
-	cmd->result = SAM_STAT_CHECK_CONDITION;
-
-	cmd->sense_buffer[0] = 0x70;
-	cmd->sense_buffer[2] = ILLEGAL_REQUEST;
-	cmd->sense_buffer[7] = 14 - 8;	/* addnl. sense len. FIXME: correct? */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, asc, ascq);
 
 	done(cmd);
 }
@@ -1337,7 +1413,7 @@
 	if (unlikely(drv_stat & (ATA_ERR | ATA_BUSY | ATA_DRQ))) {
 		DPRINTK("request check condition\n");
 
-		cmd->result = SAM_STAT_CHECK_CONDITION;
+		cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
 		qc->scsidone(cmd);
 
@@ -1619,7 +1695,7 @@
 
 		case INQUIRY:
 			if (scsicmd[1] & 2)	           /* is CmdDt set?  */
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
 			else if (scsicmd[2] == 0x00)
@@ -1629,7 +1705,7 @@
 			else if (scsicmd[2] == 0x83)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
 			else
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case MODE_SENSE:
@@ -1639,7 +1715,7 @@
 
 		case MODE_SELECT:	/* unconditionally return */
 		case MODE_SELECT_10:	/* bad-field-in-cdb */
-			ata_bad_cdb(cmd, done);
+			ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case READ_CAPACITY:
@@ -1650,7 +1726,7 @@
 			if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 			else
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case REPORT_LUNS:
@@ -1662,7 +1738,9 @@
 
 		/* all other commands */
 		default:
-			ata_bad_scsiop(cmd, done);
+			ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
+			/* "Invalid command operation code" */
+			done(cmd);
 			break;
 	}
 }


--------------030308020902050803060900--
