From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2.6] SCSI tape: fix permissions for SG_IO, etc.
Date: Sun, 1 May 2005 21:11:55 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0505012110050.6783@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep31-0.kolumbus.fi ([193.229.0.35]:59629 "EHLO
	fep31-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262635AbVEASJm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 May 2005 14:09:42 -0400
Received: from kai.makisara.local ([84.231.181.72])
          by fep31-app.kolumbus.fi with ESMTP
          id <20050501180941.HXTB15588.fep31-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sun, 1 May 2005 21:09:41 +0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against 2.6.12-rc3 + linus-patch from April 30. The patch
contains the following fixes:

- CAP_SYS_RAWIO is used instead of CAP_SYS_ADMIN; fix from Alan Cox
- only direct sending of SCSI commands requires this permission
- the st status is modified is successful unload is performed using
  SCSI_IOCTL_STOP_UNIT

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.12-rc3-300405/drivers/scsi/st.c	2005-04-05 22:36:16.000000000 +0300
+++ linux-2.6.12-rc3-300405-k1/drivers/scsi/st.c	2005-05-01 20:45:27.000000000 +0300
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050312";
+static char *verstr = "20050501";
 
 #include <linux/module.h>
 
@@ -29,6 +29,7 @@ static char *verstr = "20050312";
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/mtio.h>
+#include <linux/cdrom.h>
 #include <linux/ioctl.h>
 #include <linux/fcntl.h>
 #include <linux/spinlock.h>
@@ -50,6 +51,7 @@ static char *verstr = "20050312";
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_request.h>
+#include <scsi/sg.h>
 
 
 /* The driver prints some debugging information on the console if DEBUG
@@ -3463,7 +3465,10 @@ static int st_ioctl(struct inode *inode,
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			break;
 		default:
-			if (!capable(CAP_SYS_ADMIN))
+			if ((cmd_in == SG_IO ||
+			     cmd_in == SCSI_IOCTL_SEND_COMMAND ||
+			     cmd_in == CDROM_SEND_PACKET) &&
+			    !capable(CAP_SYS_RAWIO))
 				i = -EPERM;
 			else
 				i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
@@ -3471,10 +3476,12 @@ static int st_ioctl(struct inode *inode,
 				return i;
 			break;
 	}
-	if (!capable(CAP_SYS_ADMIN) &&
-	    (cmd_in == SCSI_IOCTL_START_UNIT || cmd_in == SCSI_IOCTL_STOP_UNIT))
-		return -EPERM;
-	return scsi_ioctl(STp->device, cmd_in, p);
+	retval = scsi_ioctl(STp->device, cmd_in, p);
+	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) { /* unload */
+		STp->rew_at_close = 0;
+		STp->ready = ST_NO_TAPE;
+	}
+	return retval;
 
  out:
 	up(&STp->lock);


