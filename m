From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] scsi_ioctl_send_command fix
Date: Sun, 29 Jun 2003 22:37:58 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0306292234150.751@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:45048 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S263455AbTF2TXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 15:23:40 -0400
Received: from kai.makisara.local ([80.186.91.66]) by fep06-app.kolumbus.fi
          with ESMTP
          id <20030629193758.VGZH22040.fep06-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sun, 29 Jun 2003 22:37:58 +0300
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The SCSI_IOCTL_SENS_COMMAND ioctl does not work in 2.5.73-bk7. The
following patch (possibly mangled by my mail client) does fix the problem
(introduced in 2.5.73):

--- linux-2.5/drivers/scsi/scsi_ioctl.c.org	2003-06-29 22:19:14.000000000 +0300
+++ linux-2.5/drivers/scsi/scsi_ioctl.c	2003-06-29 22:19:30.000000000 +0300
@@ -322,7 +322,7 @@
 	}

 	sreq = scsi_allocate_request(sdev);
-        if (sreq) {
+        if (!sreq) {
                 result = -EINTR;
                 goto error;
         }

-- 
Kai
