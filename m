Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5642EC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 12:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA1822208
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 12:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIRMLO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 08:11:14 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55079 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRMLN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 08:11:13 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MHo6Y-1kEHQL3GCc-00EsgF; Fri, 18 Sep 2020 14:10:43 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Balsundar P <balsundar.p@microsemi.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Zou Wei <zou_wei@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: aacraid: improve compat_ioctl handlers
Date:   Fri, 18 Sep 2020 14:09:31 +0200
Message-Id: <20200918120955.1465510-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:turuYngxuWvvZGlQIzIUIkI/5MIDwtOTRRsAxoSfubHLS0nafsT
 Ztq8Y/VdxVa+9rY3KO9F62a+NgYuMeLRsnF/UU/rJOZsZYgi7EXR1Qy8Hvd6KErlRCqg9XD
 yp4ZT71D/sOpvi9fB00rCDvh6RQczR66k2/OZ+3TNFGF4mvGbFQZ9dbPCY7q1+JI02ovJ9T
 5vrJTwTT7r88+K3jXP9gA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3zo151Kxg3s=:X2HIUpg2rTwqsEIOSufltD
 8zomUTVMWKzIyXKlScb+anMjCDM8HdXU+fAOIvvuUXkvEdW1GIw0O2Go1hggHc7jsYz+AJHBS
 HwMAwUaB27wcw2Yt6AiTYQTjz68bH+8e4q43HyDh7lGWp2jItDYXGVsH8ZmU9l2cxB91pPKP2
 S2HDgNUnYZp2Z6I0+x0/ZxZxlm1GpZqR5nX2NyGy5dcCmhqA/hyX2lEjtR7VEzjd6a2oDKc6W
 3F0AwfJcNjNFVg7DGTiANbQ/z0ZnNDq4O/oNYvXTtLNDOJJ8DYzjdQ1qb8Tly8qv/lD6TbJDZ
 Em7wH6L3gNTK+oO1pfzEpw5t68jj3x7yxWGbEYIvC8MSmNNatGm9Ut4IbesDXu2ZZaAD4Tcz/
 m2ndkyhjXEAX84nVUog2EeCL7cmON02zCOleY/IOw2fNjQC+f2gbWz2oyaUqB5budJ0j4V4HU
 +4ptcW/t+muED3n025+OAgleerkQaPwRgf0x4Ienw8if9/kfbyCIdLweGUnwPh2mZS8CN8f5y
 vnqxSQ6kqSOtJLG++OIukIR0TxIfHzUbHfKHyujGfbisyjAM2jYkIYhoPocJuYXOcdopTjRuH
 df3JfBRh02X3p7phs0CWXyh/x0IY091tv47GEAnTxo9NG06myL/yGXnYbPg5XUg5VHflulSx/
 FuhYap4y3IlHCzxYz32eQADWZkhzW8BITew2dIc/u/m3yWMDibY/fWm0jXieMtTUo3of1Mg32
 JRUegL66alKkjH8d1m+x1UddE2rgtBS19o4HazSxnwWJopif36qo6c3T5Hbg/CQyU+teLvP18
 Nol6YEq2H4miMIVOetA3v4WF7OKSEas0zCvpOAF2gBZVIw+WGDmm3wyf7SGN/8dHuUky/Zh
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/commctrl.c | 22 ++++++++++--
 drivers/scsi/aacraid/linit.c    | 61 ++-------------------------------
 2 files changed, 22 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 59e82a832042..3588360211e0 100644
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

