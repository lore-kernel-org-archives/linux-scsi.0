From: James.Smart@Emulex.Com
Subject: [PATCH] add int_to_scsilun() function
Date: Wed, 13 Jul 2005 22:05:03 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201ACDF@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15564 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261380AbVGNCFF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 22:05:05 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j6E2549P003282
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 19:05:04 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

One of the issues we had was reverting the midlayers lun value
into the 8byte lun value that we wanted to send to the device.
Historically, there's been some combination of byte swapping,
setting high/low, etc. There's also been no common thread between
how our driver did it and others.  I also got very confused as
to why byteswap routines were being used.

Anyway, this patch is a LLDD-callable function that reverts the
midlayer's lun value, stored in an int, to the 8-byte quantity
(note: this is not the real 8byte quantity, just the same amount
that scsilun_to_int() was able to convert and store originally).

This also solves the dilemma of the thread:
http://marc.theaimsgroup.com/?l=linux-kernel&m=112116767118981&w=2

A patch for the lpfc driver to use this function will be along
in a few days (batched with other patches).

-- james


diff -upNr scsi-misc-2.6-20050713.ORIG/drivers/scsi/scsi_scan.c scsi-misc-2.6-20050713/drivers/scsi/scsi_scan.c
--- scsi-misc-2.6-20050713.ORIG/drivers/scsi/scsi_scan.c	2005-07-13 20:52:25.000000000 -0400
+++ scsi-misc-2.6-20050713/drivers/scsi/scsi_scan.c	2005-07-13 20:52:25.000000000 -0400
@@ -1000,6 +1000,38 @@ static int scsilun_to_int(struct scsi_lu
 }
 
 /**
+ * int_to_scsilun: reverts an int into a scsi_lun
+ * @int:        integer to be reverted
+ * @scsilun:	struct scsi_lun to be set.
+ *
+ * Description:
+ *     Reverts the functionality of the scsilun_to_int, which packed
+ *     an 8-byte lun value into an int. This routine unpacks the int
+ *     back into the lun value.
+ *     Note: the scsilun_to_int() routine does not truly handle all
+ *     8bytes of the lun value. This functions restores only as much
+ *     as was set by the routine.
+ *
+ * Notes:
+ *     Given an integer : 0x0b030a04,  this function returns a
+ *     scsi_lun of : struct scsi_lun of: 0a 04 0b 03 00 00 00 00
+ *
+ **/
+void int_to_scsilun(unsigned int lun, struct scsi_lun *scsilun)
+{
+	int i;
+
+	memset(scsilun->scsi_lun, 0, sizeof(scsilun->scsi_lun));
+
+	for (i = 0; i < sizeof(lun); i += 2) {
+		scsilun->scsi_lun[i] = (lun >> 8) & 0xFF;
+		scsilun->scsi_lun[i+1] = lun & 0xFF;
+		lun = lun >> 16;
+	}
+}
+EXPORT_SYMBOL(int_to_scsilun);
+
+/**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
  * @sdevscan:	scan the host, channel, and id of this Scsi_Device
  *
diff -upNr scsi-misc-2.6-20050713.ORIG/include/scsi/scsi_device.h scsi-misc-2.6-20050713/include/scsi/scsi_device.h
--- scsi-misc-2.6-20050713.ORIG/include/scsi/scsi_device.h	2005-07-13 20:52:36.000000000 -0400
+++ scsi-misc-2.6-20050713/include/scsi/scsi_device.h	2005-07-13 20:52:36.000000000 -0400
@@ -243,6 +243,7 @@ extern void scsi_target_reap(struct scsi
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
 extern void scsi_remove_target(struct device *);
+extern void int_to_scsilun(unsigned int, struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
