From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: fix compile error
Date: Thu, 21 Apr 2005 14:42:32 +0200
Message-ID: <20050421124232.GA27754@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:34981 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261333AbVDUMlm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 08:41:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Dittmer <jdittmer@ppp0.net>, James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

	Jan Dittmer <jdittmer@ppp0.net> wrote:
	21.04.2005 10:49

> > aherrman@de.ibm.com:
> >     [PATCH] zfcp: convert to compat_ioctl

> This does not seem to compile anymore with defconfig:

>   CC      drivers/s390/scsi/zfcp_aux.o
> /usr/src/ctest/rc/kernel/drivers/s390/scsi/zfcp_aux.c:63: warning: initialization from incompatible pointer type
> /usr/src/ctest/rc/kernel/drivers/s390/scsi/zfcp_aux.c:366: error: conflicting types for `zfcp_cfdc_dev_ioctl'


Oops. Submitted patch was incorrect.
Attached patch (against 2.6.12-rc3) will fix the problem.
Sorry, for any inconvenience.


Regards,

Andreas


zfcp: fix compile error

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>


diff -bBrauN linux-2.6.x/drivers/s390/scsi-orig/zfcp_aux.c linux-2.6.x/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.x/drivers/s390/scsi-orig/zfcp_aux.c	2005-04-21 12:36:44.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi/zfcp_aux.c	2005-04-21 12:40:48.000000000 +0200
@@ -52,7 +52,7 @@
 static inline int zfcp_sg_list_copy_to_user(void __user *,
 					    struct zfcp_sg_list *, size_t);
 
-static int zfcp_cfdc_dev_ioctl(struct file *, unsigned int, unsigned long);
+static long zfcp_cfdc_dev_ioctl(struct file *, unsigned int, unsigned long);
 
 #define ZFCP_CFDC_IOC_MAGIC                     0xDD
 #define ZFCP_CFDC_IOC \
diff -bBrauN linux-2.6.x/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.x/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.x/drivers/s390/scsi-orig/zfcp_def.h	2005-04-21 12:36:44.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi/zfcp_def.h	2005-04-21 12:41:56.000000000 +0200
@@ -61,7 +61,6 @@
 #include <linux/mempool.h>
 #include <linux/syscalls.h>
 #include <linux/ioctl.h>
-#include <linux/ioctl32.h>
 
 /************************ DEBUG FLAGS *****************************************/
 

