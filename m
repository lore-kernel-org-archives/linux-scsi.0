From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] st.c for GET_IDLUN 2.6.6-rc2
Date: Sun, 25 Apr 2004 18:40:43 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408B798B.50005@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040609080206000805010704"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:56070 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262009AbUDYIkk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 04:40:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: osst@riede.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040609080206000805010704
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Kai,
A little more testing of st's SG_IO ioctl turned up a
small problem.

This is the corresponding patch that was applied to the
sd driver when it received the block layer SG_IO ioctl.

For least surprise of lk 2.4 utilities that use the
SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER
ioctls (e.g. sg_map) it is better to return the correct
values rather than 0.

BTW Does cdrecord correctly distinguish between 2
(non-scsi) ATAPI cd writers on the same system in
lk 2.6 ?

Doug Gilbert

--------------040609080206000805010704
Content-Type: text/plain;
 name="st266rc2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="st266rc2.diff"

--- linux/drivers/scsi/st.c	2004-04-05 20:49:34.000000000 +1000
+++ linux/drivers/scsi/st.c266rc2id	2004-04-25 18:13:50.272071680 +1000
@@ -3402,11 +3402,17 @@
 		goto out;
 	}
 	up(&STp->lock);
-	i = scsi_cmd_ioctl(STp->disk, cmd_in, arg);
-	if (i != -ENOTTY)
-		return i;
-	else
-		return scsi_ioctl(STp->device, cmd_in, (void *) arg);
+	switch (cmd_in) {
+		case SCSI_IOCTL_GET_IDLUN:
+		case SCSI_IOCTL_GET_BUS_NUMBER:
+			break;
+		default:
+			i = scsi_cmd_ioctl(STp->disk, cmd_in, arg);
+			if (i != -ENOTTY)
+				return i;
+			break;
+	}
+	return scsi_ioctl(STp->device, cmd_in, (void *) arg);
 
  out:
 	up(&STp->lock);

--------------040609080206000805010704--

