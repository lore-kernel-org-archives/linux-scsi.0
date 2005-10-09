From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 2/3] libata: scsi error handling, encore
Date: Sun, 09 Oct 2005 22:25:07 +1000
Message-ID: <43490C23.3030309@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010107030506090002090806"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:7396 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932284AbVJIMYN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2005 08:24:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com

This is a multi-part message in MIME format.
--------------010107030506090002090806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is against Jeff's libata-dev git repository,
upstream branch.

Changelog:
  - change "xlat" and "fill" actors in libata-scsi so
    they are responsible for SCSI status and sense data
    when they return 1. This allows GOOD status or a
    specialized error to be set.
  - yield an error for mode sense requests for saved
    values [sat-r06]

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------010107030506090002090806
Content-Type: text/x-patch;
 name="libata_err2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata_err2.diff"

--- linux/drivers/scsi/libata-scsi.c	2005-10-09 15:46:22.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2	2005-10-09 18:21:17.000000000 +1000
@@ -49,6 +49,14 @@
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
  *	@sdev: SCSI device for which BIOS geometry is to be determined
@@ -182,7 +190,6 @@
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 err = 0;
-	unsigned char *sb = cmd->sense_buffer;
 	/* Based on the 3ware driver translation table */
 	static unsigned char sense_table[][4] = {
 		/* BBD|ECC|ID|MAR */
@@ -225,8 +232,6 @@
 	};
 	int i = 0;
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
 	/*
 	 *	Is this an error we can process/parse
 	 */
@@ -281,11 +286,9 @@
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
@@ -300,11 +303,9 @@
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
@@ -313,15 +314,12 @@
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
 
@@ -430,9 +428,9 @@
 		;	/* ignore IMMED bit, violates sat-r05 */
 	}
 	if (scsicmd[4] & 0x2)
-		return 1;	/* LOEJ bit set not supported */
+		goto invalid_fld;       /* LOEJ bit set not supported */
 	if (((scsicmd[4] >> 4) & 0xf) != 0)
-		return 1;	/* power conditions not supported */
+		goto invalid_fld;       /* power conditions not supported */
 	if (scsicmd[4] & 0x1) {
 		tf->nsect = 1;	/* 1 sector, lba=0 */
 
@@ -464,6 +462,11 @@
 	 */
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
+	return 1;
 }
 
 
@@ -623,20 +626,20 @@
 	else if (scsicmd[0] == VERIFY_16)
 		scsi_16_lba_len(scsicmd, &block, &n_block);
 	else
-		return 1;
+		goto invalid_fld;
 
 	if (!n_block)
-		return 1;
+		goto nothing_to_do;
 	if (block >= dev_sectors)
-		return 1;
+		goto out_of_range;
 	if ((block + n_block) > dev_sectors)
-		return 1;
+		goto out_of_range;
 	if (lba48) {
 		if (n_block > (64 * 1024))
-			return 1;
+			goto invalid_fld;
 	} else {
 		if (n_block > 256)
-			return 1;
+			goto invalid_fld;
 	}
 
 	if (lba) {
@@ -679,7 +682,7 @@
 		   Head: 0-15
 		   Sector: 1-255*/
 		if ((cyl >> 16) || (head >> 4) || (sect >> 8) || (!sect)) 
-			return 1;
+			goto out_of_range;
 		
 		tf->command = ATA_CMD_VERIFY;
 		tf->nsect = n_block & 0xff; /* Sector count 0 means 256 sectors */
@@ -690,6 +693,20 @@
 	}
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
+	return 1;
+
+out_of_range:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x21, 0x0);
+	/* "Logical Block Address out of range" */
+	return 1;
+
+nothing_to_do:
+	qc->scsicmd->result = SAM_STAT_GOOD;
+	return 1;
 }
 
 /**
@@ -754,7 +771,7 @@
 		break;
 	default:
 		DPRINTK("no-byte command\n");
-		return 1;
+		goto invalid_fld;
 	}
 
 	/* Check and compose ATA command */
@@ -764,13 +781,13 @@
 		 * However, for ATA R/W commands, sector count 0 means
 		 * 256 or 65536 sectors, not 0 sectors as in SCSI.
 		 */
-		return 1;
+		goto nothing_to_do;
 
 	if (lba) {
 		if (lba48) {
 			/* The request -may- be too large for LBA48. */
 			if ((block >> 48) || (n_block > 65536))
-				return 1;
+				goto out_of_range;
 
 			tf->hob_nsect = (n_block >> 8) & 0xff;
 
@@ -782,7 +799,7 @@
 
 			/* The request -may- be too large for LBA28. */
 			if ((block >> 28) || (n_block > 256))
-				return 1;
+				goto out_of_range;
 
 			tf->device |= (block >> 24) & 0xf;
 		}
@@ -801,7 +818,7 @@
 
 		/* The request -may- be too large for CHS addressing. */
 		if ((block >> 28) || (n_block > 256))
-			return 1;
+			goto out_of_range;
 
 		/* Convert LBA to CHS */
 		track = (u32)block / dev->sectors;
@@ -817,7 +834,7 @@
 		   Head: 0-15
 		   Sector: 1-255*/
 		if ((cyl >> 16) || (head >> 4) || (sect >> 8) || (!sect))
-			return 1;
+			goto out_of_range;
 
 		qc->nsect = n_block;
 		tf->nsect = n_block & 0xff; /* Sector count 0 means 256 sectors */
@@ -828,6 +845,20 @@
 	}
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
+	return 1;
+
+out_of_range:
+	ata_scsi_set_sense(qc->scsicmd, ILLEGAL_REQUEST, 0x21, 0x0);
+	/* "Logical Block Address out of range" */
+	return 1;
+
+nothing_to_do:
+	qc->scsicmd->result = SAM_STAT_GOOD;
+	return 1;
 }
 
 static int ata_scsi_qc_complete(struct ata_queued_cmd *qc, u8 drv_stat)
@@ -859,6 +890,12 @@
  *	This function sets up an ata_queued_cmd structure for the
  *	SCSI command, and sends that ata_queued_cmd to the hardware.
  *
+ *	The xlat_func argument (actor) returns 0 if ready to execute
+ *	ATA command, else 1 to finish translation. If 1 is returned
+ *	then cmd->result (and possibly cmd->sense_buffer) are assumed
+ *	to be set reflecting an error condition or clean (early)
+ *	termination.
+ *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
  */
@@ -875,7 +912,7 @@
 
 	qc = ata_scsi_qc_new(ap, dev, cmd, done);
 	if (!qc)
-		return;
+		goto err_mem;
 
 	/* data is present; dma-map it */
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
@@ -883,7 +920,7 @@
 		if (unlikely(cmd->request_bufflen < 1)) {
 			printk(KERN_WARNING "ata%u(%u): WARNING: zero len r/w req\n",
 			       ap->id, dev->devno);
-			goto err_out;
+			goto err_did;
 		}
 
 		if (cmd->use_sg)
@@ -898,19 +935,28 @@
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
+        ata_qc_free(qc);
+	done(cmd);
+	DPRINTK("EXIT - early finish (good or error)\n");
+	return;
+
+err_did:
 	ata_qc_free(qc);
-	ata_bad_cdb(cmd, done);
-	DPRINTK("EXIT - badcmd\n");
+err_mem:
+	cmd->result = (DID_ERROR << 16);
+	done(cmd);
+	DPRINTK("EXIT - internal\n");
+	return;
 }
 
 /**
@@ -977,7 +1023,8 @@
  *	Mapping the response buffer, calling the command's handler,
  *	and handling the handler's return value.  This return value
  *	indicates whether the handler wishes the SCSI command to be
- *	completed successfully, or not.
+ *	completed successfully (0), or not (in which case cmd->result
+ *	and sense buffer are assumed to be set).
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -996,12 +1043,9 @@
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
@@ -1307,8 +1351,16 @@
 	 * in the same manner)
 	 */
 	page_control = scsicmd[2] >> 6;
-	if ((page_control != 0) && (page_control != 3))
-		return 1;
+	switch (page_control) {
+	case 0: /* current */
+		break;  /* supported */
+	case 3: /* saved */
+		goto saving_not_supp;
+	case 1: /* changeable */
+	case 2: /* defaults */
+	default:
+		goto invalid_fld;
+	}
 
 	if (six_byte)
 		output_len = 4;
@@ -1339,7 +1391,7 @@
 		break;
 
 	default:		/* invalid page code */
-		return 1;
+		goto invalid_fld;
 	}
 
 	if (six_byte) {
@@ -1352,6 +1404,16 @@
 	}
 
 	return 0;
+
+invalid_fld:
+	ata_scsi_set_sense(args->cmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
+	return 1;
+
+saving_not_supp:
+	ata_scsi_set_sense(args->cmd, ILLEGAL_REQUEST, 0x39, 0x0);
+	 /* "Saving parameters not supported" */
+	return 1;
 }
 
 /**
@@ -1496,13 +1558,7 @@
 void ata_scsi_badcmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *), u8 asc, u8 ascq)
 {
 	DPRINTK("ENTER\n");
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
-	cmd->sense_buffer[0] = 0x70;
-	cmd->sense_buffer[2] = ILLEGAL_REQUEST;
-	cmd->sense_buffer[7] = 14 - 8;	/* addnl. sense len. FIXME: correct? */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, asc, ascq);
 
 	done(cmd);
 }
@@ -1572,7 +1628,7 @@
 		 * time).  We need to issue REQUEST SENSE some other
 		 * way, to avoid completing the command twice.
 		 */
-		cmd->result = SAM_STAT_CHECK_CONDITION;
+		cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
 		qc->scsidone(cmd);
 
@@ -1871,7 +1927,7 @@
 
 		case INQUIRY:
 			if (scsicmd[1] & 2)	           /* is CmdDt set?  */
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
 			else if (scsicmd[2] == 0x00)
@@ -1881,7 +1937,7 @@
 			else if (scsicmd[2] == 0x83)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
 			else
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case MODE_SENSE:
@@ -1891,7 +1947,7 @@
 
 		case MODE_SELECT:	/* unconditionally return */
 		case MODE_SELECT_10:	/* bad-field-in-cdb */
-			ata_bad_cdb(cmd, done);
+			ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case READ_CAPACITY:
@@ -1902,7 +1958,7 @@
 			if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 			else
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case REPORT_LUNS:
@@ -1914,7 +1970,9 @@
 
 		/* all other commands */
 		default:
-			ata_bad_scsiop(cmd, done);
+			ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
+			/* "Invalid command operation code" */
+			done(cmd);
 			break;
 	}
 }


--------------010107030506090002090806--
