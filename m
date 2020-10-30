Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AF3C55178
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3855720725
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604076303;
	bh=0wAVZ7LWOT+Yli7FlgoGOsLD6ZgzF+PznOWrnS6jtbE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=bf7SJVZU5mkpII9OokcvHGz7oBYNsqNa1O2tIJKGbH/xAbvttHzAyUPuYcBj/7F3u
	 e74U1MzHIAtUemOV6iiR98LQn/WuRwkt787YL5AjnsC6WpD4/czxnZxytOBV62lkq8
	 RFRcPuBX/QmnbdQcwwXLqbOUncAbA3QmYf9tEku8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgJ3Qo7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 12:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3Qo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 12:44:58 -0400
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A8920704;
        Fri, 30 Oct 2020 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076298;
        bh=0wAVZ7LWOT+Yli7FlgoGOsLD6ZgzF+PznOWrnS6jtbE=;
        h=From:To:Cc:Subject:Date:From;
        b=ZPMI5kAeRkLoxylXJxlq7T+VnincfAnSN7sUBBheiIO0c39QpfrQ2GEoJL7bZHP6I
         gH2swpdlIVfpC78U1dvM3Ub6kKfz0mpQXpb02L/fYiV4z6NifZqM0NcqwfzjBeb4PP
         +M8g0Ei3Vcm5VCJ+CeNigHvg0s/AGRFz2N3nu0iQ=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] scsi: aacraid: improve compat_ioctl handlers
Date:   Fri, 30 Oct 2020 17:44:19 +0100
Message-Id: <20201030164450.1253641-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The use of compat_alloc_user_space() can be easily replaced by
handling compat arguments in the regular handler, and this will
make it work for big-endian kernels as well, which at the moment
get an invalid indirect pointer argument.

Calling aac_ioctl() instead of aac_compat_do_ioctl() means the
compat and native code paths behave the same way again, which
they stopped when the adapter health check was added only
in the native function.

Fixes: 572ee53a9bad ("scsi: aacraid: check adapter health")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/commctrl.c | 22 ++++++++++--
 drivers/scsi/aacraid/linit.c    | 61 ++-------------------------------
 2 files changed, 22 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index e3e157a74988..1b1da162f5f6 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -25,6 +25,7 @@
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
+#include <linux/compat.h>
 #include <linux/delay.h> /* ssleep prototype */
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
@@ -226,6 +227,12 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	return status;
 }
 
+struct compat_fib_ioctl {
+	u32	fibctx;
+	s32	wait;
+	compat_uptr_t fib;
+};
+
 /**
  *	next_getadapter_fib	-	get the next fib
  *	@dev: adapter to use
@@ -243,8 +250,19 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	struct list_head * entry;
 	unsigned long flags;
 
-	if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
-		return -EFAULT;
+	if (in_compat_syscall()) {
+		struct compat_fib_ioctl cf;
+
+		if (copy_from_user(&cf, arg, sizeof(struct compat_fib_ioctl)))
+			return -EFAULT;
+
+		f.fibctx = cf.fibctx;
+		f.wait = cf.wait;
+		f.fib = compat_ptr(cf.fib);
+	} else {
+		if (copy_from_user(&f, arg, sizeof(struct fib_ioctl)))
+			return -EFAULT;
+	}
 	/*
 	 *	Verify that the HANDLE passed in was a valid AdapterFibContext
 	 *
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 8f3772480582..0a82afaf4028 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1182,63 +1182,6 @@ static long aac_cfg_ioctl(struct file *file,
 	return aac_do_ioctl(aac, cmd, (void __user *)arg);
 }
 
-#ifdef CONFIG_COMPAT
-static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long arg)
-{
-	long ret;
-	switch (cmd) {
-	case FSACTL_MINIPORT_REV_CHECK:
-	case FSACTL_SENDFIB:
-	case FSACTL_OPEN_GET_ADAPTER_FIB:
-	case FSACTL_CLOSE_GET_ADAPTER_FIB:
-	case FSACTL_SEND_RAW_SRB:
-	case FSACTL_GET_PCI_INFO:
-	case FSACTL_QUERY_DISK:
-	case FSACTL_DELETE_DISK:
-	case FSACTL_FORCE_DELETE_DISK:
-	case FSACTL_GET_CONTAINERS:
-	case FSACTL_SEND_LARGE_FIB:
-		ret = aac_do_ioctl(dev, cmd, (void __user *)arg);
-		break;
-
-	case FSACTL_GET_NEXT_ADAPTER_FIB: {
-		struct fib_ioctl __user *f;
-
-		f = compat_alloc_user_space(sizeof(*f));
-		ret = 0;
-		if (clear_user(f, sizeof(*f)))
-			ret = -EFAULT;
-		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
-			ret = -EFAULT;
-		if (!ret)
-			ret = aac_do_ioctl(dev, cmd, f);
-		break;
-	}
-
-	default:
-		ret = -ENOIOCTLCMD;
-		break;
-	}
-	return ret;
-}
-
-static int aac_compat_ioctl(struct scsi_device *sdev, unsigned int cmd,
-			    void __user *arg)
-{
-	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
-}
-
-static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
-{
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-	return aac_compat_do_ioctl(file->private_data, cmd, arg);
-}
-#endif
-
 static ssize_t aac_show_model(struct device *device,
 			      struct device_attribute *attr, char *buf)
 {
@@ -1523,7 +1466,7 @@ static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl   = aac_compat_cfg_ioctl,
+	.compat_ioctl   = aac_cfg_ioctl,
 #endif
 	.open		= aac_cfg_open,
 	.llseek		= noop_llseek,
@@ -1536,7 +1479,7 @@ static struct scsi_host_template aac_driver_template = {
 	.info				= aac_info,
 	.ioctl				= aac_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl			= aac_compat_ioctl,
+	.compat_ioctl			= aac_ioctl,
 #endif
 	.queuecommand			= aac_queuecommand,
 	.bios_param			= aac_biosparm,
-- 
2.27.0

