From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] make sr_mod report more accurate drive status
 after	closing the tray.
Date: Fri, 11 Jul 2008 16:17:05 -0400
Message-ID: <4877BFC1.6070703@redhat.com>
References: <48767E08.50202@redhat.com>
	<1215726719.3353.92.camel@localhost.localdomain>
	<4877738B.4090100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <4877738B.4090100-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/fedora-kernel-list>,
	<mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-kernel-list>
List-Post: <mailto:fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/fedora-kernel-list>,
	<mailto:fedora-kernel-list-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Errors-To: fedora-kernel-list-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: fedora-kernel-list <fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

So, what's happening here is that the drive is reporting a sense of 
2/4/1 ("logical unit is becoming ready") from sr_test_unit_ready(), and 
then we ask for the media event notification before checking that result 
at all.  The check_media_event_descriptor() call isn't getting a check 
condition, but it's also reporting that the tray is closed and that 
there's no media.  In actuality it doesn't yet know if there's media or 
not, but there's no way to express that in the media event status field.

My current thought is that if it told us the device isn't yet ready, we 
should return that immediately, since there's nothing that'll tell us 
any more data than that reliably:

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ae87d08..25f2008 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -309,6 +309,11 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
int slot)
         if (0 == sr_test_unit_ready(cd->device, &sshdr))
                 return CDS_DISC_OK;

+       /* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
+       if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
+                       && sshdr.asc == 0x04 && sshdr.ascq == 0x01)
+               return CDS_DRIVE_NOT_READY;
+
         if (!cdrom_get_media_event(cdi, &med)) {
                 if (med.media_present)
                         return CDS_DISC_OK;


-- 
   Peter
