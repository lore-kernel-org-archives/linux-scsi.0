From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: PATCH: scsi-sd-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 11:12:26 +0100
Message-ID: <47931E8A.60905@hhs.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020905040504000901070106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.versatel.nl ([62.58.50.97]:56425 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYATKKx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jan 2008 05:10:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Guillaume Bedot <littletux@zarb.org>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

This is a multi-part message in MIME format.
--------------020905040504000901070106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

This patch adds a new scsi_device flag for devices which contain a bug where
the device crashes when the last sector is read in a larger then 1 sector read.

This is for example the case with sdcards in the HP PSC1350 printer cardreader
and in the HP PSC1610 printer cardreader.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------020905040504000901070106
Content-Type: text/x-patch;
 name="scsi-sd-last-sector-bug-flag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-sd-last-sector-bug-flag.patch"

This patch adds a new scsi_device flag for devices which contain a bug where
the device crashes when the last sector is read in a larger then 1 sector read.

This is for example the case with sdcards in the HP PSC1350 printer cardreader
and in the HP PSC1610 printer cardreader.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -up vanilla-2.6.24-rc7/include/scsi/scsi_device.h.psc1350 vanilla-2.6.24-rc7/include/scsi/scsi_device.h
--- vanilla-2.6.24-rc7/include/scsi/scsi_device.h.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/include/scsi/scsi_device.h	2008-01-11 19:40:48.000000000 +0100
@@ -142,6 +142,7 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
+	unsigned last_sector_bug:1;	/* Always read last sector in a 1 sector read */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
diff -up vanilla-2.6.24-rc7/drivers/scsi/sd.c.psc1350 vanilla-2.6.24-rc7/drivers/scsi/sd.c
--- vanilla-2.6.24-rc7/drivers/scsi/sd.c.psc1350	2008-01-11 19:55:43.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/scsi/sd.c	2008-01-20 10:49:17.000000000 +0100
@@ -395,6 +395,16 @@ static int sd_prep_fn(struct request_que
 		goto out;
 	}
 
+	/* 
+	 * Some devices (some sdcards for one) don't like it if the last sector
+	 * gets read in a larger then 1 sector read.
+	 */
+	if (unlikely(sdp->last_sector_bug && 
+	    rq->nr_sectors > sdp->sector_size / 512 &&
+ 	    block + this_count == get_capacity(disk))) {
+		this_count -= sdp->sector_size / 512;
+	}
+
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 

--------------020905040504000901070106--
