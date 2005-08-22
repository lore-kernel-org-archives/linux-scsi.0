From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] libata: error processing + rw 6 byte fix
Date: Mon, 22 Aug 2005 19:02:52 +1000
Message-ID: <430994BC.4060102@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040601030104060606000808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:6025 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751410AbVHVWYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:24:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.
--------------040601030104060606000808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This is a revised patch following this post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112461881419898&w=2

The plan is to add MODE SELECT SCSI command support to
libata so that parameters such as WCE and DRA can be
changed by a user (i.e. Write(back) Cache Enable and
Disable Read Ahead respectively). There are still some
issues to be addressed with MODE SELECT so the attached
is mainly a subset of the earlier one.
It improves error processing and fixes a READ_6/WRITE_6
SCSI command special case ** as requested by Jeff G.

The attached is against lk 2.6.13-rc6 and includes the
START STOP UNIT patch.

ChangeLog:
   - generalize SCSI error processing
   - add block descriptor to MODE SENSE command
   - make various changes to sync with sat-r05 (as
     noted in source)
   - fix READ(6) and WRITE(6) SCSI command special
     case: transfer_length=0 -> transfer 256 blocks


** The special case can be tested with sg_dd:
sg_dd if=/dev/sda blk_sgio=1 cdbsz=6 of=. bs=512 bpt=256 count=256
   This tests READ(6) with a transfer length of 0
   (i.e. 256 blocks) in its cdb.
   BTW the scsi_debug driver has the same bug.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------040601030104060606000808
Content-Type: text/x-patch;
 name="libata_ua.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata_ua.diff"

--- linux/include/linux/ata.h	2005-07-30 10:22:09.000000000 +1000
+++ linux/include/linux/ata.h2613rc4standby	2005-07-31 12:21:55.000000000 +1000
@@ -108,6 +108,8 @@
 
 	/* ATA device commands */
 	ATA_CMD_CHK_POWER	= 0xE5, /* check power mode */
+	ATA_CMD_STANDBY		= 0xE2, /* place in standby power mode */
+	ATA_CMD_IDLE		= 0xE3, /* place in idle power mode */
 	ATA_CMD_EDD		= 0x90,	/* execute device diagnostic */
 	ATA_CMD_FLUSH		= 0xE7,
 	ATA_CMD_FLUSH_EXT	= 0xEA,
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
--- linux/drivers/scsi/libata-scsi.c	2005-08-22 16:33:55.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2613rc6ua	2005-08-22 16:38:35.000000000 +1000
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
 
@@ -391,6 +389,60 @@
 }
 
 /**
+ *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
+ *	@qc: Storage for translated ATA taskfile
+ *	@scsicmd: SCSI command to translate
+ *
+ *	Sets up an ATA taskfile to issue STANDBY (to stop) or READ VERIFY
+ *	(to start). Perhaps these commands should be preceded by
+ *	CHECK POWER MODE to see what power mode the device is already in.
+ *	[See SAT revision 5 at www.t10.org]
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+
+static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc,
+					     u8 *scsicmd)
+{
+	struct ata_taskfile *tf = &qc->tf;
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	if (scsicmd[1] & 0x1) {
+		;	/* ignore IMMED bit, violates sat-r05 */
+	}
+	if (scsicmd[4] & 0x2)
+		return 1;	/* LOEJ bit set not supported */
+	if (((scsicmd[4] >> 4) & 0xf) != 0)
+		return 1;	/* power conditions not supported */
+	if (scsicmd[4] & 0x1) {
+		tf->nsect = 1;	/* 1 sector, lba=0 */
+		tf->lbah = 0x0;
+		tf->lbam = 0x0;
+		tf->lbal = 0x0;
+		tf->device |= ATA_LBA;
+		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
+	} else {
+		tf->nsect = 0;	/* time period value (0 implies now) */
+		tf->command = ATA_CMD_STANDBY;
+		/* Consider: ATA STANDBY IMMEDIATE command */
+	}
+	/*
+	 * Standby and Idle condition timers could be implemented but that
+	 * would require libata to implement the Power condition mode page
+	 * and allow the user to change it. Changing mode pages requires
+	 * MODE SELECT to be implemented.
+	 */
+
+	return 0;
+}
+
+
+/**
  *	ata_scsi_flush_xlat - Translate SCSI SYNCHRONIZE CACHE command
  *	@qc: Storage for translated ATA taskfile
  *	@scsicmd: SCSI command to translate (ignored)
@@ -579,7 +631,19 @@
 	}
 
 	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
-		qc->nsect = tf->nsect = scsicmd[4];
+		if (scsicmd[4] == 0) {
+			/*
+			 * For READ_6 and WRITE_6 (only)
+			 * transfer_len==0 -> 256 blocks !!
+			 */
+			if (lba48) {
+				tf->hob_nsect = 1;
+				qc->nsect = 256;
+			} else
+				return 1;
+		} else
+			qc->nsect = scsicmd[4];
+		tf->nsect = scsicmd[4];
 		tf->lbal = scsicmd[3];
 		tf->lbam = scsicmd[2];
 		tf->lbah = scsicmd[1] & 0x1f; /* mask out reserved bits */
@@ -655,6 +719,10 @@
  *	This function sets up an ata_queued_cmd structure for the
  *	SCSI command, and sends that ata_queued_cmd to the hardware.
  *
+ *	xlat_func argument (actor) returns 0 if ok, 1 for invalid field
+ *	or 2 for a detected problem (or early termination) for which
+ *	the actor has already setup the result, sense key and sense data.
+ *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
  */
@@ -666,12 +734,13 @@
 {
 	struct ata_queued_cmd *qc;
 	u8 *scsicmd = cmd->cmnd;
+	unsigned int res;
 
 	VPRINTK("ENTER\n");
 
 	qc = ata_scsi_qc_new(ap, dev, cmd, done);
 	if (!qc)
-		return;
+		goto err_mem;
 
 	/* data is present; dma-map it */
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
@@ -679,7 +748,7 @@
 		if (unlikely(cmd->request_bufflen < 1)) {
 			printk(KERN_WARNING "ata%u(%u): WARNING: zero len r/w req\n",
 			       ap->id, dev->devno);
-			goto err_out;
+			goto err_did;
 		}
 
 		if (cmd->use_sg)
@@ -693,20 +762,38 @@
 
 	qc->complete_fn = ata_scsi_qc_complete;
 
-	if (xlat_func(qc, scsicmd))
-		goto err_out;
+	res = xlat_func(qc, scsicmd);
+	if (res == 1)
+		goto err_invalid;
+	else if (res > 1)
+		goto err_sense;
 
 	/* select device, send command to hardware */
 	if (ata_qc_issue(qc))
-		goto err_out;
+		goto err_did;
 
 	VPRINTK("EXIT\n");
 	return;
 
-err_out:
+err_invalid:
 	ata_qc_free(qc);
-	ata_bad_cdb(cmd, done);
-	DPRINTK("EXIT - badcmd\n");
+	ata_scsi_invalid_field(cmd, done);
+	DPRINTK("EXIT - invalid field\n");
+	return;
+
+err_sense:
+	ata_qc_free(qc);
+	done(cmd);
+	DPRINTK("EXIT - check condition (or do nothing)\n");
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
@@ -772,8 +859,9 @@
  *	Takes care of the hard work of simulating a SCSI command...
  *	Mapping the response buffer, calling the command's handler,
  *	and handling the handler's return value.  This return value
- *	indicates whether the handler wishes the SCSI command to be
- *	completed successfully, or not.
+ *	(i.e. @actor) is 0 for success, 1 for "Invalid field in cdb"
+ *	needs to be set, 2 for sense data and status already set
+ *	by actor.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -792,11 +880,14 @@
 	rc = actor(args, rbuf, buflen);
 	ata_scsi_rbuf_put(cmd, rbuf);
 
-	if (rc)
-		ata_bad_cdb(cmd, args->done);
-	else {
+	if (rc == 0) {
 		cmd->result = SAM_STAT_GOOD;
 		args->done(cmd);
+	} else if (rc == 1)
+		ata_scsi_invalid_field(cmd, args->done);
+	else {
+		/* assume sense data and status set by actor */
+		args->done(cmd);
 	}
 }
 
@@ -994,6 +1085,13 @@
 	*ptr_io = ptr;
 }
 
+static const u8 def_caching_mpage[] = {
+		0x8,				/* page code */
+		0x12,				/* page length */
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 10 zeroes */
+		0, 0, 0, 0, 0, 0, 0, 0		/* 8 zeroes */
+	};
+
 /**
  *	ata_msense_caching - Simulate MODE SENSE caching info page
  *	@id: device IDENTIFY data
@@ -1011,13 +1109,9 @@
 static unsigned int ata_msense_caching(u16 *id, u8 **ptr_io,
 				       const u8 *last)
 {
-	u8 page[] = {
-		0x8,				/* page code */
-		0x12,				/* page length */
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 10 zeroes */
-		0, 0, 0, 0, 0, 0, 0, 0		/* 8 zeroes */
-	};
+	u8 page[sizeof(def_caching_mpage)];
 
+	memcpy(page, def_caching_mpage, sizeof(page));
 	if (ata_id_wcache_enabled(id))
 		page[2] |= (1 << 2);	/* write cache enable */
 	if (!ata_id_rahead_enabled(id))
@@ -1027,6 +1121,13 @@
 	return sizeof(page);
 }
 
+/* As of sat-r05: considering defining this page (for QErr).
+ * D_SENSE is now 0 (fixed sense data format);
+ * guess extended self test completion time: 30 seconds (why?).
+ */
+static const u8 def_control_mpage[] = {
+		0xa, 0xa, 0, 0, 0, 0, 0, 0, 0xff, 0xff, 0, 30};
+
 /**
  *	ata_msense_ctl_mode - Simulate MODE SENSE control mode page
  *	@dev: Device associated with this MODE SENSE command
@@ -1041,16 +1142,17 @@
 
 static unsigned int ata_msense_ctl_mode(u8 **ptr_io, const u8 *last)
 {
-	const u8 page[] = {0xa, 0xa, 6, 0, 0, 0, 0, 0, 0xff, 0xff, 0, 30};
-
-	/* byte 2: set the descriptor format sense data bit (bit 2)
-	 * since we need to support returning this format for SAT
-	 * commands and any SCSI commands against a 48b LBA device.
-	 */
-
-	ata_msense_push(ptr_io, last, page, sizeof(page));
-	return sizeof(page);
+	ata_msense_push(ptr_io, last, def_control_mpage,
+			sizeof(def_control_mpage));
+	return sizeof(def_control_mpage);
 }
+	
+static const u8 def_rw_recovery_mpage[] = {
+		0x1,			  /* page code */
+		0xa,			  /* page length */
+		(1 << 6),		  /* note: ARRE=1 */
+		0, 0, 0, 0, 0, 0, 0, 0, 0 /* 9 zeroes */
+	};	/* sat-r05 says AWRE will be 0 */
 
 /**
  *	ata_msense_rw_recovery - Simulate MODE SENSE r/w error recovery page
@@ -1066,15 +1168,9 @@
 
 static unsigned int ata_msense_rw_recovery(u8 **ptr_io, const u8 *last)
 {
-	const u8 page[] = {
-		0x1,			  /* page code */
-		0xa,			  /* page length */
-		(1 << 7) | (1 << 6),	  /* note auto r/w reallocation */
-		0, 0, 0, 0, 0, 0, 0, 0, 0 /* 9 zeroes */
-	};
-
-	ata_msense_push(ptr_io, last, page, sizeof(page));
-	return sizeof(page);
+	ata_msense_push(ptr_io, last, def_rw_recovery_mpage,
+			sizeof(def_rw_recovery_mpage));
+	return sizeof(def_rw_recovery_mpage);
 }
 
 /**
@@ -1093,28 +1189,54 @@
 				  unsigned int buflen)
 {
 	u8 *scsicmd = args->cmd->cmnd, *p, *last;
-	unsigned int page_control, six_byte, output_len;
+	const u8 sat_blk_desc[] = {0, 0, 0, 0, 0, 0, 0x2, 0x0};
+	/* 512 byte blocks, number of blocks = 0, (sat-r05) */
+	u8 pg, spg;
+	unsigned int ebd, page_control, six_byte, output_len, alloc_len, minlen;
 
 	VPRINTK("ENTER\n");
 
 	six_byte = (scsicmd[0] == MODE_SENSE);
+	ebd = !(scsicmd[1] & 0x8);	/* dbd bit inverted == edb */
 
-	/* we only support saved and current values (which we treat
-	 * in the same manner)
+	/*
+	 * LLBA bit in MS(10) ignored (permitted)
+	 * Only support current values (sat-r05)
 	 */
 	page_control = scsicmd[2] >> 6;
-	if ((page_control != 0) && (page_control != 3))
-		return 1;
+	switch (page_control) {
+	case 1:		/* changeable values */
+	case 2:		/* default values */
+		return 1;	/* illegal field in cdb */
+	case 3:		/* saved values */
+		ata_scsi_set_sense(args->cmd, ILLEGAL_REQUEST, 0x39, 0x0);
+		/* "Saving parameters not supported" */
+		return 2;
+	default:
+		break;
+	}
 
-	if (six_byte)
-		output_len = 4;
-	else
-		output_len = 8;
+	if (six_byte) {
+		output_len = 4 + (ebd ? 8 : 0);
+		alloc_len = scsicmd[4];
+	} else {
+		output_len = 8 + (ebd ? 8 : 0);
+		alloc_len = (scsicmd[7] << 8) + scsicmd[8];
+	}
+	minlen = (alloc_len < buflen) ? alloc_len : buflen;
 
 	p = rbuf + output_len;
-	last = rbuf + buflen - 1;
+	last = rbuf + minlen - 1;
 
-	switch(scsicmd[2] & 0x3f) {
+	pg = scsicmd[2] & 0x3f;
+	spg = scsicmd[3];
+	/* No mode subpages supported (yet) but asking for _all_
+	 * subpages may be valid
+	 */
+	if (spg && (spg != 0xff))
+		return 1;
+
+	switch(pg) {
 	case 0x01:		/* r/w error recovery */
 		output_len += ata_msense_rw_recovery(&p, last);
 		break;
@@ -1128,6 +1250,8 @@
 		break;
 		}
 
+	/* case 0x1c: Informational Exception Control mode page */
+
 	case 0x3f:		/* all pages */
 		output_len += ata_msense_rw_recovery(&p, last);
 		output_len += ata_msense_caching(args->id, &p, last);
@@ -1138,13 +1262,30 @@
 		return 1;
 	}
 
+	if (minlen < 1)
+		return 0;
 	if (six_byte) {
 		output_len--;
 		rbuf[0] = output_len;
+		if (ebd) {
+			if (minlen > 3)
+				rbuf[3] = sizeof(sat_blk_desc);
+			if (minlen > 11)
+				memcpy(rbuf + 4, sat_blk_desc,
+				       sizeof(sat_blk_desc));
+		}
 	} else {
 		output_len -= 2;
 		rbuf[0] = output_len >> 8;
-		rbuf[1] = output_len;
+		if (minlen > 1)
+			rbuf[1] = output_len;
+		if (ebd) {
+			if (minlen > 7)
+				rbuf[7] = sizeof(sat_blk_desc);
+			if (minlen > 15)
+				memcpy(rbuf + 8, sat_blk_desc,
+				       sizeof(sat_blk_desc));
+		}
 	}
 
 	return 0;
@@ -1237,6 +1378,33 @@
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
+ *	a SCSI command status of %SAM_STAT_CHECK_CONDITION .
+ *
+ *	LOCKING:
+ *	Not required
+ */
+
+void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
+{
+	cmd->result = SAM_STAT_CHECK_CONDITION;
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
@@ -1254,13 +1422,7 @@
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
@@ -1414,9 +1576,10 @@
  *	Pointer to translation function if possible, %NULL if not.
  */
 
-static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
+static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
+						u8 *cmd)
 {
-	switch (cmd) {
+	switch (cmd[0]) {
 	case READ_6:
 	case READ_10:
 	case READ_16:
@@ -1434,6 +1597,9 @@
 	case VERIFY:
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
+
+	case START_STOP:
+		return ata_scsi_start_stop_xlat;
 	}
 
 	return NULL;
@@ -1501,7 +1667,7 @@
 
 	if (dev->class == ATA_DEV_ATA) {
 		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
-							      cmd->cmnd[0]);
+							      cmd->cmnd);
 
 		if (xlat_func)
 			ata_scsi_translate(ap, dev, cmd, done, xlat_func);
@@ -1547,12 +1713,13 @@
 		case TEST_UNIT_READY:
 		case FORMAT_UNIT:		/* FIXME: correct? */
 		case SEND_DIAGNOSTIC:		/* FIXME: correct? */
+			/* sat-r05: both should be translated */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
 			break;
 
 		case INQUIRY:
 			if (scsicmd[1] & 2)	           /* is CmdDt set?  */
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
 			else if (scsicmd[2] == 0x00)
@@ -1562,7 +1729,7 @@
 			else if (scsicmd[2] == 0x83)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
 			else
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case MODE_SENSE:
@@ -1570,11 +1737,6 @@
 			ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
 			break;
 
-		case MODE_SELECT:	/* unconditionally return */
-		case MODE_SELECT_10:	/* bad-field-in-cdb */
-			ata_bad_cdb(cmd, done);
-			break;
-
 		case READ_CAPACITY:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 			break;
@@ -1583,7 +1745,7 @@
 			if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 			else
-				ata_bad_cdb(cmd, done);
+				ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case REPORT_LUNS:
@@ -1595,7 +1757,9 @@
 
 		/* all other commands */
 		default:
-			ata_bad_scsiop(cmd, done);
+			ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
+			/* "Invalid command operation code" */
+			done(cmd);
 			break;
 	}
 }


--------------040601030104060606000808--
