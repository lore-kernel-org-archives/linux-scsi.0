From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 3/2] SCSI tape security: require CAP_ADMIN for SG_IO etc.
Date: Sun, 13 Mar 2005 20:10:38 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0503132009020.7265@kai.makisara.local>
References: <Pine.LNX.4.61.0503121903010.6875@kai.makisara.local>
 <Pine.LNX.4.61.0503121906090.6875@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:49340 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261404AbVCMSJR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Mar 2005 13:09:17 -0500
Received: from kai.makisara.local ([193.229.226.111])
          by fep30-app.kolumbus.fi with ESMTP
          id <20050313180915.HLCS3347.fep30-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sun, 13 Mar 2005 20:09:15 +0200
In-Reply-To: <Pine.LNX.4.61.0503121906090.6875@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch at the end is against 2.6.11-bk7 + the two patches in this
thread but it applies with offset to nearly any recent kernel.

The kernel currently allows any user permitted to access the tape device file
to send the tape drive commands that may either make the tape drivers internal
state inconsistent or to change the drive parameters so that other users find
the drive to be unusable. This patch changes ioctl handling so that SG_IO,
SCSI_IOCTL_COMMAND, etc. require CAP_ADMIN. This solves the consistency
problems for SCSI tapes. The st driver provides user-accessible commands to
change the drive parameters that users may need to access.

The SCSI command permissions were discussed widely on the linux lists but this
did not result in any useful refinement of the permissions. It may very well
be that the tape drives are the only devices that users are sometimes given
permissions to access and that have security problems with the current command
filtering. This patch solves the problem for tapes and no more elaborate
patches are needed.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-bk7-k3/drivers/scsi/st.c	2005-03-12 18:11:11.000000000 +0200
+++ linux-2.6.11-bk7-k4/drivers/scsi/st.c	2005-03-13 19:24:29.000000000 +0200
@@ -3461,11 +3461,17 @@ static int st_ioctl(struct inode *inode,
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			break;
 		default:
-			i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
+			if (!capable(CAP_SYS_ADMIN))
+				i = -EPERM;
+			else
+				i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
 			if (i != -ENOTTY)
 				return i;
 			break;
 	}
+	if (!capable(CAP_SYS_ADMIN) &&
+	    (cmd_in == SCSI_IOCTL_START_UNIT || cmd_in == SCSI_IOCTL_STOP_UNIT))
+		return -EPERM;
 	return scsi_ioctl(STp->device, cmd_in, p);
 
  out:
