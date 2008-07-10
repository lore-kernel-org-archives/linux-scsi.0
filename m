From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] make sr_mod report more accurate drive status after closing
 the tray.
Date: Thu, 10 Jul 2008 17:24:24 -0400
Message-ID: <48767E08.50202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/fedora-kernel-list>,
	<mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-kernel-list>
List-Post: <mailto:fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/fedora-kernel-list>,
	<mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Errors-To: fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fedora-kernel-list <fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Right now, when using sr_mod and issuing the CDROM_DRIVE_STATUS ioctl,
there's no way to differentiate between when you've just closed the
drive tray, but the media is not yet loaded, and when there's no media.
This seems to be accidental.

Here's a patch that seems to fix this behaviour:

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ae87d08..43a084b 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -306,10 +306,9 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
int slot)
  		/* we have no changer support */
  		return -EINVAL;
  	}
-	if (0 == sr_test_unit_ready(cd->device, &sshdr))
-		return CDS_DISC_OK;
-
-	if (!cdrom_get_media_event(cdi, &med)) {
+	if (0 == sr_test_unit_ready(cd->device, &sshdr)
+			&& sshdr.sense_key == 0
+			&& !cdrom_get_media_event(cdi, &med)) {
  		if (med.media_present)
  			return CDS_DISC_OK;
  		else if (med.door_open)
@@ -319,10 +318,27 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
int slot)
  	}

  	/*
-	 * 0x04 is format in progress .. but there must be a disc present!
+	 * ASC: 0x04: "logical unit is not ready"
+	 * ASCQ: 0x01: cause not reportable
+	 *       0x02: in process of becoming ready
+	 *       0x03: initializing command required
+	 *       0x04: format in progress .. but there must be a disc present!
+	 *       0x07: operation in progress
+	 *       0x08: long write in progress
  	 */
-	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
-		return CDS_DISC_OK;
+	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04) {
+		switch (sshdr.ascq) {
+			case 0x01:
+			case 0x02:
+				return CDS_DRIVE_NOT_READY;
+			case 0x03:
+				return CDS_TRAY_OPEN;
+			case 0x04:
+			case 0x07:
+			case 0x08:
+				return CDS_DRIVE_NOT_READY;
+		}
+	}

  	/*
  	 * If not using Mt Fuji extended media tray reports,
