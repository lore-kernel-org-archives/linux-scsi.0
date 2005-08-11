From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] START STOP UNIT SCSI command for libata
Date: Thu, 11 Aug 2005 17:02:36 +1000
Message-ID: <42FAF80C.1060507@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030206090607030809060407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:5765 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932278AbVHKHCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 03:02:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030206090607030809060407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeff Garzik wrote:
> Douglas Gilbert wrote:
>
>> Jeff,
>> Here is another (more successful) attempt at that patch.
>>
>> ChangeLog:
>>   - adds minimal START STOP UNIT SCSI command functionality
>>     to libata (follows sat-r05 apart from the IMMED bit).
>>   - implements the TEST UNIT READY SCSI command as indicated
>>     by sat-r05.
>
>
>> Signed-off-by: Douglas Gilbert <dougg@torque.net>
>
>
> Looks pretty decent, however...
>
> Can you please resend as two patches:
>
> #1: implement START STOP UNIT
> #2: implement TEST UNIT READY
>
> I need to think about TUR a bit more.  Separating into two patches would
> allow me to apply SSU patch to upstream immediately, while applying the
> TUR feature to libata-dev.git respository, queueing it for further
> review and eventual upstream merge.

Jeff,
Attached is #1, a patch against lk 2.6.13-rc6 .

I asked several people to test the full patch and one
has responded to date. That was successful with:
    sata_sil+SP1614C (Samsung)
    sata_nv+SP2004C
I just tested this patch on my hardware:
    sata_sil+ST380013AS (Seagate)
and it worked.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFC+vgMnayo+9E+FQIRAhWrAKCxYnR1duIJNjYJzL80OW51nzdLHQCeKGMG
cuZcws48H4LXVZCIyamzOsk=
=7kTq
-----END PGP SIGNATURE-----

--------------030206090607030809060407
Content-Type: text/x-patch;
 name="libata2613rc6_ss.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2613rc6_ss.diff"

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
--- linux/drivers/scsi/libata-scsi.c	2005-08-11 15:36:21.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2613rc6ss	2005-08-11 15:22:12.000000000 +1000
@@ -391,6 +391,60 @@
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
@@ -1434,6 +1488,8 @@
 	case VERIFY:
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
+	case START_STOP:
+		return ata_scsi_start_stop_xlat;
 	}
 
 	return NULL;


--------------030206090607030809060407--
