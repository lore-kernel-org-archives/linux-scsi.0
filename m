From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] start stop libata attached SATA disks, take 2
Date: Sat, 06 Aug 2005 18:27:23 +1000
Message-ID: <42F4746B.6030303@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050803030008000103050008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:24466 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261259AbVHFI1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Aug 2005 04:27:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050803030008000103050008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeff,
Here is another (more successful) attempt at that patch.

ChangeLog:
  - adds minimal START STOP UNIT SCSI command functionality
    to libata (follows sat-r05 apart from the IMMED bit).
  - implements the TEST UNIT READY SCSI command as indicated
    by sat-r05.

Patch against lk 2.6.13-rc5 .

Tested on my ST380013AS Seagate SATA disk with a Sil 3112
HBA. Stop (spin down [enter standby power mode]) seems to
work as does start. Start takes 3.8 seconds to spin up
on my disk. TEST UNIT READY works returning GOOD status
(after 0 ms) when the disk is active or idle and the
"initializing command required" sense (after 180 ms)
when the disk is in standby power mode.

I looked a bit closer at the power condition states in
SBC-2 and I assume there is an equivalence with SATA
disks:

State    Disk mechanics
- ----------------------------------
Active   Spinning, heads on track
Idle     Spinning, heads parked
Standby  Spun down,  " "
Stop     Spun down,  " "

The difference between "standby" and "stop" is that an
initializing command is required (i.e. START STOP UNIT
command, start=1) to transition out of "stop" state
(but not "standby"). As far as I can see ATA disks don't
have a "stop" state that can be accessed via the ATA
command set so the the SAT draft says to translate a
SCSI START STOP UNIT command, start=0 (i.e. stop) into
SATA disk being placed into standby mode. That is fine
but a SATA (and PATA) disk doesn't need an initializing
command to go into active state, any media access command
will do that. This is all fine, I just find it a little
curious what SAT is defining should happen for the TEST
UNIT READY translation.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFC9HRqnayo+9E+FQIRAmWQAJ44Aq/qgo42MF/E6VHdREHVRxw7qwCfceGA
kklbxZFB/fMgFXQChvC3A7k=
=a/U2
-----END PGP SIGNATURE-----

--------------050803030008000103050008
Content-Type: text/x-patch;
 name="libata2613rc5_stop.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2613rc5_stop.diff"

--- linux/include/linux/ata.h	2005-07-30 10:22:08.000000000 +1000
+++ linux/include/linux/ata.h2613rc5standby	2005-08-06 14:36:03.000000000 +1000
@@ -108,6 +108,8 @@
 
 	/* ATA device commands */
 	ATA_CMD_CHK_POWER	= 0xE5, /* check power mode */
+	ATA_CMD_STANDBY		= 0xE2, /* place in standby power mode */
+	ATA_CMD_IDLE		= 0xE3, /* place in idle power mode */
 	ATA_CMD_EDD		= 0x90,	/* execute device diagnostic */
 	ATA_CMD_FLUSH		= 0xE7,
 	ATA_CMD_FLUSH_EXT	= 0xEA,
--- linux/drivers/scsi/libata-scsi.c	2005-07-30 10:22:02.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2613rc5stop	2005-08-06 17:39:34.000000000 +1000
@@ -391,6 +391,86 @@
 }
 
 /**
+ *	ata_scsi_tur_xlat - Translate SCSI TEST UNIT READY command
+ *	@qc: Storage for translated ATA taskfile
+ *	@scsicmd: SCSI command to translate (ignored)
+ *
+ *	Sets up an ATA taskfile to issue CHECK POWER MODE.
+ *	[See SAT revision 5 at www.t10.org]
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
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
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
@@ -632,7 +712,30 @@
 
 	if (unlikely(drv_stat & (ATA_ERR | ATA_BUSY | ATA_DRQ)))
 		ata_to_sense_error(qc, drv_stat);
-	else
+	else if (cmd->cmnd[0] == TEST_UNIT_READY) {
+		unsigned char *sb = cmd->sense_buffer;
+		struct ata_taskfile resp_tf;
+
+		memset(&resp_tf, 0, sizeof(resp_tf));
+		qc->ap->ops->tf_read(qc->ap, &resp_tf);
+		/* result value in sector count field */
+		if (resp_tf.nsect == 0) {
+			/* standby mode, respond as per sat-r05 */
+			sb[0] = 0x70;
+			sb[2] = NOT_READY;
+			sb[7] = 0x0a;
+			sb[12] = 0x4;	/* Logical unit not ready .. */
+			sb[13] = 0x2;	/* .. initializing command required */
+			cmd->result = SAM_STAT_CHECK_CONDITION;
+		} else if (resp_tf.nsect == 0x80) {
+			/* idle mode */
+			DPRINTK("CHECK POWER MODE reports idle\n");
+			cmd->result = SAM_STAT_GOOD;
+		} else {
+			/* nsect should be 0xff implying active or idle */
+			cmd->result = SAM_STAT_GOOD;
+		}
+	} else
 		cmd->result = SAM_STAT_GOOD;
 
 	qc->scsidone(cmd);
@@ -1434,6 +1537,10 @@
 	case VERIFY:
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
+	case TEST_UNIT_READY:
+		return ata_scsi_tur_xlat;
+	case START_STOP:
+		return ata_scsi_start_stop_xlat;
 	}
 
 	return NULL;
@@ -1544,7 +1651,6 @@
 		case REZERO_UNIT:
 		case SEEK_6:
 		case SEEK_10:
-		case TEST_UNIT_READY:
 		case FORMAT_UNIT:		/* FIXME: correct? */
 		case SEND_DIAGNOSTIC:		/* FIXME: correct? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);


--------------050803030008000103050008--
