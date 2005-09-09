From: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] SCSI: Don't be so verbose if no disc is present
Date: Fri, 09 Sep 2005 23:17:16 +0100
Message-ID: <432209EC.90900@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050601010706080906080008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:13765 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1030720AbVIIWRT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 18:17:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050601010706080906080008
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Running a simple "touch /dev/scd0" on a SCSI cdrom will cause the following 
message to appear in the logs if no disc is present:

	Device not ready. Make sure there is a disc in the drive.

This results in the logs being flooded for some users by those userspace 
agents which repeatedly poll the device for media change.

This patch demotes the message to a quieter scsi-logging message only.

Signed-off-by: Daniel Drake <dsd@gentoo.org>


--------------050601010706080906080008
Content-Type: text/x-patch;
 name="scsi-quiet-no-cd-warning.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-quiet-no-cd-warning.patch"

--- linux/drivers/scsi/scsi_ioctl.c.orig	2005-09-09 23:10:07.000000000 +0100
+++ linux/drivers/scsi/scsi_ioctl.c	2005-09-09 23:13:17.000000000 +0100
@@ -118,8 +118,9 @@ static int ioctl_internal_command(struct
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
 			if (sdev->removable && (cmd[0] != TEST_UNIT_READY)) {
-				printk(KERN_INFO "Device not ready. Make sure"
-				       " there is a disc in the drive.\n");
+				SCSI_LOG_IOCTL(2, printk(
+				       "Device not ready. Make sure"
+				       " there is a disc in the drive.\n"));
 				break;
 			}
 		case UNIT_ATTENTION:

--------------050601010706080906080008--
