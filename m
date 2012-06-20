From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] SCSI & usb-storage: add try_rc_10_first flag
Date: Wed, 20 Jun 2012 16:04:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206201558090.1804-100000@iolanthe.rowland.org>
References: <4FDEE8A1.5030200@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37377 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758001Ab2FTUEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2012 16:04:20 -0400
In-Reply-To: <4FDEE8A1.5030200@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Hans de Goede <hdegoede@redhat.com>, Torsten Wohlfarth <towo@siduction.org>, Sturm Flut <sturmflut@lieberbiber.de>, Sergey <sergeyn@gmail.com>, Philippe Valembois - Phil <lephilousophe@users.sourceforge.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Several bug reports have been received recently for USB mass-storage
devices that don't handle READ CAPACITY(16) commands properly.  They
report bogus sizes, in some cases becoming unusable as a result.

The bugs were triggered by commit
09b6b51b0b6c1b9bb61815baf205e4d74c89ff04 (SCSI & usb-storage: add
flags for VPD pages and REPORT LUNS), which caused usb-storage to stop
overriding the SCSI level reported by devices.  By default, the sd
driver will try READ CAPACITY(16) first for any device whose level is
above SCSI_SPC_2.

It seems likely that any device large enough to require the use of
READ CAPACITY(16) (i.e., 2 TB or more) would be able to handle READ
CAPACITY(10) commands properly.  Indeed, I don't know of any devices
that don't handle READ CAPACITY(10) properly.

Therefore this patch (as1559) adds a new flag telling the sd driver
to try READ CAPACITY(10) before READ CAPACITY(16), and sets this flag
for every USB mass-storage device.  If a device really is larger than
2 TB, sd will fall back to READ CAPACITY(16) just as it used to.

This fixes Bugzilla #43391.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Hans de Goede <hdegoede@redhat.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
CC: <stable@vger.kernel.org>

---

 drivers/scsi/sd.c              |    2 ++
 drivers/usb/storage/scsiglue.c |    6 ++++++
 include/scsi/scsi_device.h     |    1 +
 3 files changed, 9 insertions(+)

Index: usb-3.4/include/scsi/scsi_device.h
===================================================================
--- usb-3.4.orig/include/scsi/scsi_device.h
+++ usb-3.4/include/scsi/scsi_device.h
@@ -151,6 +151,7 @@ struct scsi_device {
 					   SD_LAST_BUGGY_SECTORS */
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
+	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
Index: usb-3.4/drivers/scsi/sd.c
===================================================================
--- usb-3.4.orig/drivers/scsi/sd.c
+++ usb-3.4/drivers/scsi/sd.c
@@ -1899,6 +1899,8 @@ static int sd_try_rc16_first(struct scsi
 {
 	if (sdp->host->max_cmd_len < 16)
 		return 0;
+	if (sdp->try_rc_10_first)
+		return 0;
 	if (sdp->scsi_level > SCSI_SPC_2)
 		return 1;
 	if (scsi_device_protection(sdp))
Index: usb-3.4/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-3.4.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.4/drivers/usb/storage/scsiglue.c
@@ -202,6 +202,12 @@ static int slave_configure(struct scsi_d
 		if (us->fflags & US_FL_NO_READ_CAPACITY_16)
 			sdev->no_read_capacity_16 = 1;
 
+		/*
+		 * Many devices do not respond properly to READ_CAPACITY_16.
+		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
+		 */
+		sdev->try_rc_10_first = 1;
+
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
 			us->fflags |= US_FL_SANE_SENSE;


