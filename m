From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: convert to compat_ioctl
Date: Wed, 6 Apr 2005 16:46:39 +0200
Message-ID: <20050406144639.GA7644@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:2947 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S262218AbVDFOpp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 10:45:45 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j36EjiFa094988
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 14:45:44 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j36EjiGV213230
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 16:45:44 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j36Ejh3t013827
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 16:45:44 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

Patch converts zfcp to use compat_ioctl.

Thanks to Cristoph who reminded me to adapt zfcp.


Regards,

Andreas


zfcp changes: convert zfcp to compat_ioctl

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

===== zfcp_aux.c 1.19 vs edited =====
--- 1.19/drivers/s390/scsi/zfcp_aux.c	2005-03-29 06:39:24 +02:00
+++ edited/zfcp_aux.c	2005-04-06 14:55:52 +02:00
@@ -52,19 +52,18 @@
 static inline int zfcp_sg_list_copy_to_user(void __user *,
 					    struct zfcp_sg_list *, size_t);
 
-static int zfcp_cfdc_dev_ioctl(struct inode *, struct file *,
-	unsigned int, unsigned long);
+static long zfcp_cfdc_dev_ioctl(struct file *, unsigned int, unsigned long);
 
 #define ZFCP_CFDC_IOC_MAGIC                     0xDD
 #define ZFCP_CFDC_IOC \
 	_IOWR(ZFCP_CFDC_IOC_MAGIC, 0, struct zfcp_cfdc_sense_data)
 
-#ifdef CONFIG_COMPAT
-static struct ioctl_trans zfcp_ioctl_trans = {ZFCP_CFDC_IOC, (void*) sys_ioctl};
-#endif
 
 static struct file_operations zfcp_cfdc_fops = {
-	.ioctl = zfcp_cfdc_dev_ioctl
+	.unlocked_ioctl = zfcp_cfdc_dev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = zfcp_cfdc_dev_ioctl
+#endif
 };
 
 static struct miscdevice zfcp_cfdc_misc = {
@@ -308,23 +307,16 @@
 	if (!zfcp_transport_template)
 		return -ENODEV;
 
-	retval = register_ioctl32_conversion(zfcp_ioctl_trans.cmd,
-					     zfcp_ioctl_trans.handler);
-	if (retval != 0) {
-		ZFCP_LOG_INFO("registration of ioctl32 conversion failed\n");
-		goto out;
-	}
-
 	retval = misc_register(&zfcp_cfdc_misc);
 	if (retval != 0) {
 		ZFCP_LOG_INFO("registration of misc device "
 			      "zfcp_cfdc failed\n");
-		goto out_misc_register;
-	} else {
-		ZFCP_LOG_TRACE("major/minor for zfcp_cfdc: %d/%d\n",
-			       ZFCP_CFDC_DEV_MAJOR, zfcp_cfdc_misc.minor);
+		goto out;
 	}
 
+	ZFCP_LOG_TRACE("major/minor for zfcp_cfdc: %d/%d\n",
+		       ZFCP_CFDC_DEV_MAJOR, zfcp_cfdc_misc.minor);
+
 	/* Initialise proc semaphores */
 	sema_init(&zfcp_data.config_sema, 1);
 
@@ -348,8 +340,6 @@
 
  out_ccw_register:
 	misc_deregister(&zfcp_cfdc_misc);
- out_misc_register:
-	unregister_ioctl32_conversion(zfcp_ioctl_trans.cmd);
  out:
 	return retval;
 }
@@ -370,9 +360,9 @@
  *              -EPERM      - Cannot create or queue FSF request or create SBALs
  *              -ERESTARTSYS- Received signal (is mapped to EAGAIN by VFS)
  */
-static int
-zfcp_cfdc_dev_ioctl(struct inode *inode, struct file *file,
-                    unsigned int command, unsigned long buffer)
+static long
+zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
+		    unsigned long buffer)
 {
 	struct zfcp_cfdc_sense_data *sense_data, __user *sense_data_user;
 	struct zfcp_adapter *adapter = NULL;
===== zfcp_def.h 1.20 vs edited =====
--- 1.20/drivers/s390/scsi/zfcp_def.h	2004-12-07 11:19:06 +01:00
+++ edited/zfcp_def.h	2005-04-06 14:19:31 +02:00
@@ -61,7 +61,6 @@
 #include <linux/mempool.h>
 #include <linux/syscalls.h>
 #include <linux/ioctl.h>
-#include <linux/ioctl32.h>
 
 /************************ DEBUG FLAGS *****************************************/
 

