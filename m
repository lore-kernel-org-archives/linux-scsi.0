From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] start stop libata attached SATA disks
Date: Sun, 31 Jul 2005 18:33:48 +1000
Message-ID: <42EC8CEC.3030509@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040601040409050006080906"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:51616 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261845AbVGaIdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 04:33:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040601040409050006080906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jeff,
Here is half a patch.

Adds minimal START STOP UNIT SCSI command functionality
to libata (follows sat-r04 apart from the IMMED bit).
Tries to implement the TEST UNIT READY SCSI command.

Patch against lk 2.6.13-rc4 . There are comments in the
code where I was on thin ice.

Tested on my ST380013AS Seagate SATA disk on a Sil 3112
HBA. Stop (spin down) seems to work. Starting a disk
works (well the disk spins up) but the command is aborted
after 3.8 seconds. There doesn't seem to be a mechanism to pass
through timeouts from SG_IO (or the SCSI ULDs) into libata.
Probably the READ VERIFY is not set up properly.
TEST UNIT READY code just doesn't work at all ... the
corresponding ATA command (CHECK POWER MODE) sends a return
value back in the nsector register of the response. I
tried ata_tf_read() but that just made the device inoperable.

The TEST UNIT READY implementation needs to be solid since
the sd driver issues it when it first sees a disk. If sd
receives a NOT READY sense key then it will try to send
a START STOP UNIT command to spin up the disk.

I notice that when the SATA disk is in standby mode, sending
it a normal read command works (i.e. the disk spins up, the
read command waits patiently and then does the read). This
is different to a SCSI disk that would reject a media access
command when in standby mode.

Signed-off-by: Douglas Gilbert <dougg@torque.net>
but not ready for production.

Doug Gilbert


--------------040601040409050006080906
Content-Type: text/x-patch;
 name="libata2613rc4_stop.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2613rc4_stop.diff"

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
--- linux/drivers/scsi/libata-scsi.c	2005-07-30 10:22:03.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2613rc4stop	2005-07-31 17:52:34.000000000 +1000
@@ -391,6 +391,88 @@
 }
 
 /**
+ *	ata_scsi_tur_xlat - Translate SCSI TEST UNIT READY command
+ *	@qc: Storage for translated ATA taskfile
+ *	@scsicmd: SCSI command to translate (ignored)
+ *
+ *	Sets up an ATA taskfile to issue CHECK POWER MODE.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+
+static unsigned int ata_scsi_tur_xlat(struct ata_queued_cmd *qc, u8 *scsicmd)
+{
+	struct ata_taskfile *tf = &qc->tf;
+
+	tf->flags |= ATA_TFLAG_DEVICE;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_CHK_POWER;
+
+	return 0;
+}
+
+/**
+ *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
+ *	@qc: Storage for translated ATA taskfile
+ *	@scsicmd: SCSI command to translate
+ *
+ *	Sets up an ATA taskfile to issue STANDBY (to stop) or READ VERIFY
+ *	(to start). Perhaps these commands should be preceded by
+ *	CHECK POWER MODE to see what power mode the device is already in.
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
+	/*
+	 * Should probably precede any commands to change power mode with
+	 * CHECK POWER MODE to see what the current state of the device is.
+	 * The patch author does not know how to do this.
+	 * D. Gilbert 20050731
+	 */
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	if (scsicmd[1] & 0x1) {
+		;	/* ignore IMMED bit, violates sat-r04 */
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
+		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
+	} else {
+		tf->nsect = 0;	/* time period value (0 implies now) */
+		tf->command = ATA_CMD_STANDBY;
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
@@ -635,6 +717,34 @@
 	else
 		cmd->result = SAM_STAT_GOOD;
 
+#if 0
+// >>>>>> Couldn't get this code working: need to fetch nsector field
+//        from CHECK POWER MODE response. The following code,
+//        especially the ata_tf_read() made the device inoperable.
+	if (cmd->result == SAM_STAT_GOOD &&
+	    cmd->cmnd[0] == TEST_UNIT_READY) {
+
+		unsigned char *sb = cmd->sense_buffer;
+		struct ata_taskfile resp_tf;
+
+		ata_tf_read(qc->ap, &resp_tf);
+		/* result value in sector count field */
+		if (resp_tf.nsect == 0) {
+			/* standby mode */
+			sb[0] = 0x70;
+			sb[2] = NOT_READY;
+			sb[7] = 0x0a;
+			sb[12] = 0x4;	/* Logical unit not ready .. */
+			sb[13] = 0x2;	/* .. initializing command required */
+			cmd->result = SAM_STAT_CHECK_CONDITION;
+		} else if (resp_tf.nsect == 0x80) {
+			/* idle mode */
+			DPRINTK("CHECK POWER MODE reports idle\n");
+		}
+		/* else nsect should be 0xff implying active or idle */
+	}
+#endif
+
 	qc->scsidone(cmd);
 
 	return 0;
@@ -1434,6 +1544,10 @@
 	case VERIFY:
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
+	case TEST_UNIT_READY:
+		return ata_scsi_tur_xlat;
+	case START_STOP:
+		return ata_scsi_start_stop_xlat;
 	}
 
 	return NULL;
@@ -1544,7 +1658,6 @@
 		case REZERO_UNIT:
 		case SEEK_6:
 		case SEEK_10:
-		case TEST_UNIT_READY:
 		case FORMAT_UNIT:		/* FIXME: correct? */
 		case SEND_DIAGNOSTIC:		/* FIXME: correct? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);

--------------040601040409050006080906--
