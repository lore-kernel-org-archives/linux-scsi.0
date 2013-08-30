From: Marcus Meissner <meissner@suse.de>
Subject: PATCH: scsi: make scsi reset permissions more relaxed (RFC)
Date: Fri, 30 Aug 2013 14:04:50 +0200
Message-ID: <20130830120450.GB31120@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi folks,

cdrecord wants to whack the CD drive with a SCSI RESET ...

So far SCSI RESET can be done at 4 levels (target, device, bus, host)
and all 4 are checked for CAP_SYS_ADMIN / CAP_SYS_RAWIO.


As the cdrecord author wants special permissions for cdrecord, readcd ,
cdda2wav to allow it to send SCSI RESET commands I was wondering if
relaxing the permission is a potential idea?

This would allow SCSI reset on target/device if a local user
gets regular access to a SCSI device (via udev acls etc.)


(I know that the actual reset code will fall back into the chain
 target -> device -> bus -> host resetting if one fails.)

Signed-off-by: Marcus Meissner <meissner@suse.de>

Ciao, Marcus
---
 drivers/scsi/scsi_ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index d9564fb..770720e 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -306,22 +306,26 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			return 0;
 		switch (val) {
 		case SG_SCSI_RESET_DEVICE:
+			/* allowed if you can send scsi commands to the device */
 			val = SCSI_TRY_RESET_DEVICE;
 			break;
 		case SG_SCSI_RESET_TARGET:
+			/* allowed if you can send scsi commands to the device */
 			val = SCSI_TRY_RESET_TARGET;
 			break;
 		case SG_SCSI_RESET_BUS:
+			if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+				return -EACCES;
 			val = SCSI_TRY_RESET_BUS;
 			break;
 		case SG_SCSI_RESET_HOST:
+			if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+				return -EACCES;
 			val = SCSI_TRY_RESET_HOST;
 			break;
 		default:
 			return -EINVAL;
 		}
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
 		return (scsi_reset_provider(sdev, val) ==
 			SUCCESS) ? 0 : -EIO;
 	}
-- 
1.8.1.4
