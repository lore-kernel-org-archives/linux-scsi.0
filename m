Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2713C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 21:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB7102080C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 21:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgIHVh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 17:37:57 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:35399 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIHVhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 17:37:55 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MSZDt-1k8m772Fsf-00Ssj4; Tue, 08 Sep 2020 23:37:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Balsundar P <balsundar.p@microsemi.com>
Cc:     hch@infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Zou Wei <zou_wei@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: aacraid: improve compat_ioctl handlers
Date:   Tue,  8 Sep 2020 23:36:21 +0200
Message-Id: <20200908213715.3553098-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:KRcdwEjkKj9+XoPTDAYicg3zaMW+8aDN7KFTDFdvtQylHXBrceI
 4d8eunLAXcM9jP6dDtH+8xmH6N+5+Ao6vVxs4IdympM60xBQnobDY+FN5htDyO4Z9o/PVTC
 Svxotml9vbAurjzKdHkv2jkFKiF0mLWpVHpCF5JzIn8pjfrK0QYnzJy/PMMe41SHwCcSM1J
 mgL0yMlSogNhxz1j5/wsw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Son/2bucWXE=:OTWFTbHTBU5W/x1+wSmX61
 n854zU9YhMAAMMGHbpF+rRAAVaTaxn1hsv1mDzufM8Vv/1e87bT2fyl01TMoyyijVGG/IUSSN
 C/TRFFWsB9LLcWv11jwHRu8JwC3GSGyQ+HoZ2SMJfQ0IXMzWyCWK+I+wWG28/61dOKaSqDl9C
 CIjjK2kHy0im1xEZ+zoEH+Tqchj/DEE50sXWU7sAmmM7ao9y6Nk/1ckwc196Uif0Ahk/4xoVm
 tV73tyRXAezE/lt48vEN1BS8s1LsqP+SlKGFmq7FurWjtexBPF36ktnMxymszfz90J1pYd7Km
 larvBBPrb8QXfWl6K48iPnXGb9aQsZ2mS56fg0U8ANhsxLdajgpXelYeklp8az5XFiEIiJvhS
 04fKPSN81HLvABlkGAppA+VdXY+epXySk2bVkjdv9r4w00EFMWaQI6YFNylTWPfPJktIiti/o
 6pmpiIrgLWHUnmvbHvTNlaM7blRU1pXJAhm9wWwkKSqFyTK2VxHWNv6Kj6cxllRk/J8x1jl/O
 UmF6UGzlRZcvkVS/aLCehAN/L8+JI/i0ISqPWQqclnXWifOC3PQCpN/mkSkoWg6iMdstrW/47
 oO424NllNUX+86z4cr2TgHs/rvdQusIdewL3WrIKMmJ2PIHz2uxWOKBpFfZRKggD9sf2ARhwY
 vnHAdDU0lX9dXVsW+gVfdVSoJNdsnasZFumOdZ/2uZ9pAhqkQJKecYDpuBZxNEKlS56y+d4Ix
 EwfVKiLlli97rjsMmOq98EFcUyzWd+SGvkQFz2U6O0bS0LLenxbDo39pXCogLCWummQ6ssaJL
 0f5BVExDQaaTOOadR5zu/dJicHBqU/CtvPIsnzos7195rZ5x3t4OXrFrKRNs5tvbSmUaP3Y
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The use of compat_alloc_user_space() can be easily replaced by
handling compat arguments in the regular handler, and this will
make it work for big-endian kernels as well, which at the moment
get an invalid indirect pointer argument.

Calling aac_ioctl() instead of aac_compat_do_ioctl() means the
compat and native code paths behave the same way again, which
they stopped when the adapter health check was added only
in the native function.

Fixes: 572ee53a9bad ("scsi: aacraid: check adapter health")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/commctrl.c | 20 +++++++++--
 drivers/scsi/aacraid/linit.c    | 61 ++-------------------------------
 2 files changed, 20 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 59e82a832042..6d6f72d68164 100644
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
@@ -243,8 +244,23 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	struct list_head * entry;
 	unsigned long flags;
 
-	if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
-		return -EFAULT;
+	if (in_compat_syscall()) {
+		struct compat_fib_ioctl {
+			u32	fibctx;
+			s32	wait;
+			compat_uptr_t fib;
+		} cf;
+
+		if (copy_from_user(&f, arg, sizeof(struct compat_fib_ioctl)))
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
index 8588da0a0655..8c0f55845138 100644
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

