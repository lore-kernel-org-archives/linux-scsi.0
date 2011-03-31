From: Amit Shah <amit.shah@redhat.com>
Subject: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Thu, 31 Mar 2011 23:50:04 +0530
Message-ID: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
List-Id: linux-scsi@vger.kernel.org

After the first GET_EVENT_STATUS_NOTIFICATION command, any new media
notification is reset by the device.  The following is then noticed:

1. insert a CD of a particular size
2. mount it
3. note /sys/block/sr0/size
4. unmount cd
5. replace cd with a size greater than previous one
6. mount it
7. /sys/block/sr0/size isn't updated
8. copy all files from cd to somewhere; IO errors will pop up where the
   files lie beyond previous CD's geometry

The cause is:

 cdrom_open()
     open_for_data()
         cdo->drive_status() = sr_drive_status()
             cdrom_get_media_event()
             --> GPCMD_GET_EVENT_STATUS_NOTIFICATION
         --> med.media_present is true, return CDS_DISK_OK
     (success)
 check_disk_change()
    ... -> 2nd call to GPCMD_GET_EVENT_STATUS_NOTIFICATION

at this point the device has already reset the new media event and the
call to revalidate_disk() in check_disk_change() is never made.

All of this is noticed in a qemu-kvm virtual machine where two CD images
are created from two files different in size.

CC: Jens Axboe <axboe@kernel.dk>
CC: "James E.J. Bottomley" <James.Bottomley@suse.de>
CC: linux-scsi@vger.kernel.org
CC: Markus Armbruster <armbru@redhat.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
Needless to say this is based on my limited research of the flow of
data and events.  I think sr_ioctl is the best place to handle this
revalidation as that's where the information gets lost.  If there's a
better or a more generic place where this needs to be done, please
point me to it.

Also, qemu upstream doesn't yet support GET_EVENT_STATUS_NOTIFICATION,
I have a scratch implementation that I'm testing against.


 drivers/scsi/sr_ioctl.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 8be3055..0651448 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -316,12 +316,19 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 		return CDS_DRIVE_NOT_READY;
 
 	if (!cdrom_get_media_event(cdi, &med)) {
-		if (med.media_present)
+		if (med.media_present) {
+			/*
+			 * New media was inserted; ensure disk data is
+			 * revalidated.
+			 */
+			if (cdi->disk->fops->revalidate_disk)
+				cdi->disk->fops->revalidate_disk(cdi->disk);
 			return CDS_DISC_OK;
-		else if (med.door_open)
+		} else if (med.door_open) {
 			return CDS_TRAY_OPEN;
-		else
+		} else {
 			return CDS_NO_DISC;
+		}
 	}
 
 	/*
-- 
1.7.4
