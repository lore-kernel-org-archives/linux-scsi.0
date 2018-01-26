From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH resend 3/6] cdrom: wait for tray to close
Date: Fri, 26 Jan 2018 17:58:37 +0100
Message-ID: <03915a2e64f50ec04ea6d8e6f80e36ecf16e4f0f.1516985620.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
 <cover.1516985620.git.msuchanek@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbeA0Psd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Jan 2018 10:48:33 -0500
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
References: <cover.1516985620.git.msuchanek@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Suchanek <msuchanek@suse.de>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

The scsi command to close tray only starts the motor and does not wait
for the tray to close. Wait until the state chages from TRAY_OPEN so
users do not race with the tray closing.

This looks like inifinte wait but unless the drive is broken it either
closes the tray within a few seconds or reports an error when it detects
the tray is blocked. At worst the wait can be interrupted by user.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
v2:
 - check drive_status exists before using it
 - rename tray_close -> cdrom_tray_close
---
 drivers/cdrom/cdrom.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 89746b3d193f..69e85c902373 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -281,7 +281,9 @@
 #include <linux/fcntl.h>
 #include <linux/blkdev.h>
 #include <linux/times.h>
+#include <linux/delay.h>
 #include <linux/uaccess.h>
+#include <linux/sched/signal.h>
 #include <scsi/scsi_request.h>
 
 /* used to tell the module to turn on full debugging messages */
@@ -1030,6 +1032,18 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 	       tracks->cdi, tracks->xa);
 }
 
+static int cdrom_tray_close(struct cdrom_device_info *cdi)
+{
+	int ret;
+
+	ret = cdi->ops->tray_move(cdi, 0);
+	if (ret || !cdi->ops->drive_status)
+		return ret;
+
+	return poll_event_interruptible(CDS_TRAY_OPEN !=
+			cdi->ops->drive_status(cdi, CDSL_CURRENT), 500);
+}
+
 static
 int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
 {
@@ -1048,7 +1062,9 @@ int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret = cdo->tray_move(cdi, 0);
+				ret = cdrom_tray_close(cdi);
+				if (ret == -ERESTARTSYS)
+					return ret;
 				if (ret) {
 					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
@@ -2312,7 +2328,8 @@ static int cdrom_ioctl_closetray(struct cdrom_device_info *cdi)
 
 	if (!CDROM_CAN(CDC_CLOSE_TRAY))
 		return -ENOSYS;
-	return cdi->ops->tray_move(cdi, 0);
+
+	return cdrom_tray_close(cdi);
 }
 
 static int cdrom_ioctl_eject_sw(struct cdrom_device_info *cdi,
-- 
2.13.6
