From: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
Subject: PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 11:27:29 +0100
Message-ID: <47932211.90105@hhs.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000200020103020600070803"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000200020103020600070803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

This patch sets the last_sector_bug flag to 1 for all USB disks. This is
needed to makes the cardreader on various HP multifunction printers work.

Since the performance impact is negible we set this flag for all USB disks to
avoid an unusual_devs.h nightmare.

Note that this patch depends on:
PATCH: scsi-sd-last-sector-bug-flag.patch

Which actually adds this flag to the scsi subsystem.

Signed-off-by: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>

Regards,

Hans

--------------000200020103020600070803
Content-Type: text/x-patch;
 name="usb-storage-set-last-sector-bug-flag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-storage-set-last-sector-bug-flag.patch"

This patch sets the last_sector_bug flag to 1 for all USB disks. This is
needed to makes the cardreader on various HP multifunction printers work.

Since the performance impact is negible we set this flag for all USB disks to
avoid an unusual_devs.h nightmare.

Note that this patch depends on:
PATCH: scsi-sd-last-sector-bug-flag.patch

Which actually adds this flag to the scsi subsystem.

Signed-off-by: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
--- vanilla-2.6.24-rc7/drivers/usb/storage/scsiglue.c.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/usb/storage/scsiglue.c	2008-01-20 11:18:38.000000000 +0100
@@ -187,6 +187,10 @@ static int slave_configure(struct scsi_d
 		 * automatically, requiring a START-STOP UNIT command. */
 		sdev->allow_restart = 1;
 
+		/* Some USB cardreaders have trouble reading an sdcard's last
+		 * sector in a larger then 1 sector read, since the performance
+		 * impact is negible we set this flag for all USB disks */
+		sdev->last_sector_bug = 1;
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages

--------------000200020103020600070803--
