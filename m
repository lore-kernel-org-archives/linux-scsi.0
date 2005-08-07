From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH C&C] gdth: remove GDTIOCTL_OSVERS
Date: Mon, 8 Aug 2005 02:28:29 +0400
Message-ID: <20050807222829.GA20558@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:30869 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1753029AbVHGWUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 18:20:18 -0400
Received: by wproxy.gmail.com with SMTP id i20so720742wra
        for <linux-scsi@vger.kernel.org>; Sun, 07 Aug 2005 15:20:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Achim Leubner <achim_leubner@adaptec.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/gdth.c       |   12 ------------
 drivers/scsi/gdth_ioctl.h |    8 --------
 2 files changed, 20 deletions(-)

diff -uprN linux-vanilla/drivers/scsi/gdth.c linux-gdth/drivers/scsi/gdth.c
--- linux-vanilla/drivers/scsi/gdth.c	2005-08-08 02:16:47.000000000 +0400
+++ linux-gdth/drivers/scsi/gdth.c	2005-08-08 02:19:59.000000000 +0400
@@ -5411,18 +5411,6 @@ static int gdth_ioctl(struct inode *inod
                 return -EFAULT;
         break;
       }
-      
-      case GDTIOCTL_OSVERS:
-      { 
-        gdth_ioctl_osvers osv; 
-
-        osv.version = (unchar)(LINUX_VERSION_CODE >> 16);
-        osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
-        osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
-        if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
-                return -EFAULT;
-        break;
-      }
 
       case GDTIOCTL_CTRTYPE:
       { 
diff -uprN linux-vanilla/drivers/scsi/gdth_ioctl.h linux-gdth/drivers/scsi/gdth_ioctl.h
--- linux-vanilla/drivers/scsi/gdth_ioctl.h	2005-08-08 02:16:47.000000000 +0400
+++ linux-gdth/drivers/scsi/gdth_ioctl.h	2005-08-08 02:20:19.000000000 +0400
@@ -10,7 +10,6 @@
 #define GDTIOCTL_GENERAL    (GDTIOCTL_MASK | 0) /* general IOCTL */
 #define GDTIOCTL_DRVERS     (GDTIOCTL_MASK | 1) /* get driver version */
 #define GDTIOCTL_CTRTYPE    (GDTIOCTL_MASK | 2) /* get controller type */
-#define GDTIOCTL_OSVERS     (GDTIOCTL_MASK | 3) /* get OS version */
 #define GDTIOCTL_HDRLIST    (GDTIOCTL_MASK | 4) /* get host drive list */
 #define GDTIOCTL_CTRCNT     (GDTIOCTL_MASK | 5) /* get controller count */
 #define GDTIOCTL_LOCKDRV    (GDTIOCTL_MASK | 6) /* lock host drive */
@@ -296,13 +295,6 @@ typedef struct {
     unchar channel;                             /* channel */
 } gdth_ioctl_lockchn;
 
-/* GDTIOCTL_OSVERS */
-typedef struct {
-    unchar version;                             /* OS version */
-    unchar subversion;                          /* OS subversion */
-    ushort revision;                            /* revision */
-} gdth_ioctl_osvers;
-
 /* GDTIOCTL_CTRTYPE */
 typedef struct {
     ushort ionode;                              /* controller number */

