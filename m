From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] libata: spin up + down disk, lk 2.4.32
Date: Wed, 07 Dec 2005 22:36:52 +1000
Message-ID: <4396D764.6020905@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010203070104050006020503"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010203070104050006020503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I was asked recently to port the START STOP UNIT
SCSI command in libata back to lk 2.4.32 .

Changelog:
  - add START STOP UNIT SCSI command to libata
    allowing SATA disks to be spun down and up

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------010203070104050006020503
Content-Type: text/x-patch;
 name="libata2432ss.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2432ss.diff"

--- linux/include/linux/ata.h	2005-11-23 22:17:01.000000000 +1000
+++ linux/include/linux/ata.h2432ss	2005-11-24 16:52:06.000000000 +1000
@@ -108,6 +108,8 @@
 
 	/* ATA device commands */
 	ATA_CMD_CHK_POWER	= 0xE5, /* check power mode */
+	ATA_CMD_STANDBY		= 0xE2, /* place in standby power mode */
+	ATA_CMD_IDLE		= 0xE3, /* place in idle power mode */
 	ATA_CMD_EDD		= 0x90,	/* execute device diagnostic */
 	ATA_CMD_FLUSH		= 0xE7,
 	ATA_CMD_FLUSH_EXT	= 0xEA,
--- linux/drivers/scsi/libata-scsi.c	2005-11-23 22:17:01.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2432ss	2005-11-24 17:09:21.000000000 +1000
@@ -350,6 +350,63 @@
 }
 
 /**
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
+		tf->device |= ATA_LBA;
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
+/**
  *	ata_scsi_flush_xlat - Translate SCSI SYNCHRONIZE CACHE command
  *	@qc: Storage for translated ATA taskfile
  *	@scsicmd: SCSI command to translate (ignored)
@@ -1393,6 +1450,8 @@
 	case VERIFY:
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
+	case START_STOP:
+		return ata_scsi_start_stop_xlat;
 	}
 
 	return NULL;

--------------010203070104050006020503--
