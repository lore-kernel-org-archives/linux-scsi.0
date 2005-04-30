From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2.6.11.8] SCSI tape security: require CAP_SYS_RAWIO for SG_IO
 etc.
Date: Sat, 30 Apr 2005 10:59:33 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0504301055500.21122@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:9191 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262546AbVD3H5U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Apr 2005 03:57:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

The patch at the end is against 2.6.11.8.

The kernel currently allows any user permitted to access the tape device file
to send the tape drive commands that may either make the tape drivers internal
state inconsistent or to change the drive parameters so that other users find
the drive to be unusable. This patch changes ioctl handling so that SG_IO,
SCSI_IOCTL_COMMAND, etc. require CAP_SYS_RAWIO. This solves the consistency
problems for SCSI tapes. The st driver provides user-accessible commands to
change the drive parameters that users may need to access.

The SCSI command permissions were discussed on the linux lists and solutions
enabling different rules for different devices were suggested. However, none
of these has been implemented in the current kernel. It may very well
be that the tape drives are the only devices that users are sometimes given
permissions to access and that have security problems with the current command
filtering. This patch solves the problem for tapes and no more elaborate
patches are needed. If those are merged to the kernel, this patch can be reversed.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11.8/drivers/scsi/st.c	2005-03-03 21:10:36.000000000 +0200
+++ linux-2.6.11.8-k1/drivers/scsi/st.c	2005-04-30 09:57:21.000000000 +0300
@@ -3414,7 +3414,10 @@ static int st_ioctl(struct inode *inode,
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			break;
 		default:
-			i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
+			if (!capable(CAP_SYS_RAWIO))
+				i = -EPERM;
+			else
+				i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
 			if (i != -ENOTTY)
 				return i;
 			break;
