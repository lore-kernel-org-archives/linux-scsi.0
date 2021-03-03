Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B532C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200AE6146D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbhCDAbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348838AbhCCN4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 08:56:17 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A45C061223
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 05:55:06 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so2901464wma.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 05:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WJUtAp3RgTuh77Yze697rFi7ZjYyj9YiGnAS+QwJ7C0=;
        b=YL9ezgrsIYF/mhf7EYRWSR1lQZXrDPM/NOFRk+RGiRvHGHVOtx/Y3isZqopKl4RG6z
         ix32xeM0AR16nmSlcBFhUbyu/6WdESyu+0x3bkTWPfhCrigYGd0dhAn5uII4A4ombPrL
         bnggwd5WcH4P9RhdrafjN379iDJlE8OrjDeGZBiFjMWE3pyOzJZVYP7C81Ab7/GaNy7D
         xRMsOkrzbyq7dxDRHQh3MlVKKVlci7syCEhd6qLTuV1LlYRbIxHPgUDGb4MzWGigkLaH
         zr2T8xG+2g4lZ0dZcs4XDO2ef4cFMViexc6uT+xAJPYtJ+3TJLxCj86QlOTE40QR6pZ0
         GGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJUtAp3RgTuh77Yze697rFi7ZjYyj9YiGnAS+QwJ7C0=;
        b=aEFX9yzTMpxH4f1XluOYrChlShZV1LjBPze9EYMR2UYZbL0rMrpZa+LxFlSrAlc3Xk
         iLTWebKBUDkM9daLmXIbKHvV/YZi0+xZA7j89GOY2diaWWcOWgipbpuKb9cb71QDbDT7
         yG8B3Ety0043OAUscskG6KRM/UW4ME3/UOAQfxxklb+/s/VOFBEo15gaim+aTfln0/yw
         lg0l9zZXXE00HFkGTiqAt6FkiH20w8khj46csswNE2wJ4lBDwsWGcDjIZS2UKdsW9uVg
         2OgBx5fWX30QyZ7JqBstFquUrofvEffR8vdFva/Jv081Xh9DtWtMWPlbf8ywa9hlzDao
         uQ0Q==
X-Gm-Message-State: AOAM532i7dE8gkCO6WyXZ3FVaQ6e3rF/0s8eEb63Cj87ciT8aw8vVyPJ
        P7VZzWtrJBm4QFwzrgJvp+boRg==
X-Google-Smtp-Source: ABdhPJxIJTZNj1xIlqq51htSj3XbOWuBJixpryvB02USBa1G2kBlj1jXo8vwVEEiGDDHKtsMgTtvqg==
X-Received: by 2002:a1c:2ed4:: with SMTP id u203mr9479000wmu.45.1614779705554;
        Wed, 03 Mar 2021 05:55:05 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id l15sm5963387wme.43.2021.03.03.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 05:55:01 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A9ED71FF8C;
        Wed,  3 Mar 2021 13:55:00 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     linux-kernel@vger.kernel.org
Cc:     maxim.uvarov@linaro.org, joakim.bech@linaro.org,
        ilias.apalodimas@linaro.org, arnd@linaro.org,
        ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com, bing.zhu@intel.com,
        Matti.Moell@opensynergy.com, hmo@opensynergy.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Avri Altman <avri.altman@sandisk.com>
Subject: [RFC PATCH  2/5] char: rpmb: provide a user space interface
Date:   Wed,  3 Mar 2021 13:54:57 +0000
Message-Id: <20210303135500.24673-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210303135500.24673-1-alex.bennee@linaro.org>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The user space API is achieved via a number of synchronous IOCTLs.

  * RPMB_IOC_VER_CMD - simple versioning API
  * RPMB_IOC_CAP_CMD - query of underlying capabilities
  * RPMB_IOC_PKEY_CMD - one time programming of access key
  * RPMB_IOC_COUNTER_CMD - query the write counter
  * RPMB_IOC_WBLOCKS_CMD - write blocks to device
  * RPMB_IOC_RBLOCKS_CMD - read blocks from device

The keys used for programming and writing blocks to the device are
key_serial_t handles as provided by the keyctl() interface.

[AJB: here there are two key differences between this and the original
proposal. The first is the dropping of the sequence of preformated
frames in favour of explicit actions. The second is the introduction
of key_serial_t and the keyring API for referencing the key to use]

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linus  Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Cc: Avri Altman <avri.altman@sandisk.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |   1 +
 drivers/char/rpmb/Kconfig                     |   7 +
 drivers/char/rpmb/Makefile                    |   1 +
 drivers/char/rpmb/cdev.c                      | 246 ++++++++++++++++++
 drivers/char/rpmb/core.c                      |  10 +-
 drivers/char/rpmb/rpmb-cdev.h                 |  17 ++
 include/linux/rpmb.h                          |  10 +
 include/uapi/linux/rpmb.h                     |  68 +++++
 9 files changed, 357 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/rpmb/cdev.c
 create mode 100644 drivers/char/rpmb/rpmb-cdev.h
 create mode 100644 include/uapi/linux/rpmb.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index a4c75a28c839..0ff2d4d81bb0 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -344,6 +344,7 @@ Code  Seq#    Include File                                           Comments
 0xB5  00-0F  uapi/linux/rpmsg.h                                      <mailto:linux-remoteproc@vger.kernel.org>
 0xB6  all    linux/fpga-dfl.h
 0xB7  all    uapi/linux/remoteproc_cdev.h                            <mailto:linux-remoteproc@vger.kernel.org>
+0xB8  80-8F  uapi/linux/rpmb.h                                       <mailto:linux-mmc@vger.kernel.org>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/MAINTAINERS b/MAINTAINERS
index 076f3983526c..c60b41b6e6bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15374,6 +15374,7 @@ M:	?
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/char/rpmb/*
+F:	include/uapi/linux/rpmb.h
 F:	include/linux/rpmb.h
 
 RTL2830 MEDIA DRIVER
diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
index 431c2823cf70..9068664a399a 100644
--- a/drivers/char/rpmb/Kconfig
+++ b/drivers/char/rpmb/Kconfig
@@ -9,3 +9,10 @@ config RPMB
 	  access RPMB partition.
 
 	  If unsure, select N.
+
+config RPMB_INTF_DEV
+	bool "RPMB character device interface /dev/rpmbN"
+	depends on RPMB && KEYS
+	help
+	  Say yes here if you want to access RPMB from user space
+	  via character device interface /dev/rpmb%d
diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
index 24d4752a9a53..f54b3f30514b 100644
--- a/drivers/char/rpmb/Makefile
+++ b/drivers/char/rpmb/Makefile
@@ -3,5 +3,6 @@
 
 obj-$(CONFIG_RPMB) += rpmb.o
 rpmb-objs += core.o
+rpmb-$(CONFIG_RPMB_INTF_DEV) += cdev.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/char/rpmb/cdev.c b/drivers/char/rpmb/cdev.c
new file mode 100644
index 000000000000..55f66720fd03
--- /dev/null
+++ b/drivers/char/rpmb/cdev.c
@@ -0,0 +1,246 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2015 - 2019 Intel Corporation.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/compat.h>
+#include <linux/slab.h>
+#include <linux/capability.h>
+
+#include <linux/rpmb.h>
+
+#include "rpmb-cdev.h"
+
+static dev_t rpmb_devt;
+#define RPMB_MAX_DEVS  MINORMASK
+
+#define RPMB_DEV_OPEN    0  /** single open bit (position) */
+
+/**
+ * rpmb_open - the open function
+ *
+ * @inode: pointer to inode structure
+ * @fp: pointer to file structure
+ *
+ * Return: 0 on success, <0 on error
+ */
+static int rpmb_open(struct inode *inode, struct file *fp)
+{
+	struct rpmb_dev *rdev;
+
+	rdev = container_of(inode->i_cdev, struct rpmb_dev, cdev);
+	if (!rdev)
+		return -ENODEV;
+
+	/* the rpmb is single open! */
+	if (test_and_set_bit(RPMB_DEV_OPEN, &rdev->status))
+		return -EBUSY;
+
+	mutex_lock(&rdev->lock);
+
+	fp->private_data = rdev;
+
+	mutex_unlock(&rdev->lock);
+
+	return nonseekable_open(inode, fp);
+}
+
+/**
+ * rpmb_release - the cdev release function
+ *
+ * @inode: pointer to inode structure
+ * @fp: pointer to file structure
+ *
+ * Return: 0 always.
+ */
+static int rpmb_release(struct inode *inode, struct file *fp)
+{
+	struct rpmb_dev *rdev = fp->private_data;
+
+	clear_bit(RPMB_DEV_OPEN, &rdev->status);
+
+	return 0;
+}
+
+static long rpmb_ioctl_ver_cmd(struct rpmb_dev *rdev,
+			       struct rpmb_ioc_ver_cmd __user *ptr)
+{
+	struct rpmb_ioc_ver_cmd ver = {
+		.api_version = RPMB_API_VERSION,
+	};
+
+	return copy_to_user(ptr, &ver, sizeof(ver)) ? -EFAULT : 0;
+}
+
+static long rpmb_ioctl_cap_cmd(struct rpmb_dev *rdev,
+			       struct rpmb_ioc_cap_cmd __user *ptr)
+{
+	struct rpmb_ioc_cap_cmd cap;
+
+	cap.target      = rdev->target;
+	cap.block_size  = rdev->ops->block_size;
+	cap.wr_cnt_max  = rdev->ops->wr_cnt_max;
+	cap.rd_cnt_max  = rdev->ops->rd_cnt_max;
+	cap.auth_method = rdev->ops->auth_method;
+	cap.capacity    = rpmb_get_capacity(rdev);
+	cap.reserved    = 0;
+
+	return copy_to_user(ptr, &cap, sizeof(cap)) ? -EFAULT : 0;
+}
+
+static long rpmb_ioctl_pkey_cmd(struct rpmb_dev *rdev, key_serial_t __user *k)
+{
+	key_serial_t keyid;
+
+	if (get_user(keyid, k))
+		return -EFAULT;
+	else
+		return rpmb_program_key(rdev, keyid);
+}
+
+static long rpmb_ioctl_counter_cmd(struct rpmb_dev *rdev, int __user *ptr)
+{
+	int count = rpmb_get_write_count(rdev);
+
+	if (count > 0)
+		return put_user(count, ptr);
+	else
+		return count;
+}
+
+static long rpmb_ioctl_wblocks_cmd(struct rpmb_dev *rdev,
+				   struct rpmb_ioc_blocks_cmd __user *ptr)
+{
+	struct rpmb_ioc_blocks_cmd wblocks;
+	int sz;
+	long ret;
+	u8 *data;
+
+	if (copy_from_user(&wblocks, ptr, sizeof(struct rpmb_ioc_blocks_cmd)))
+		return -EFAULT;
+
+	/* Don't write more blocks device supports */
+	if (wblocks.count > rdev->ops->wr_cnt_max)
+		return -EINVAL;
+
+	sz = wblocks.count * 256;
+	data = kmalloc(sz, GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, wblocks.data, sz))
+		ret = -EFAULT;
+	else
+		ret = rpmb_write_blocks(rdev, wblocks.key, wblocks.addr, wblocks.count, data);
+
+	kfree(data);
+	return ret;
+}
+
+static long rpmb_ioctl_rblocks_cmd(struct rpmb_dev *rdev,
+				   struct rpmb_ioc_blocks_cmd __user *ptr)
+{
+	struct rpmb_ioc_blocks_cmd rblocks;
+	int sz;
+	long ret;
+	u8 *data;
+
+	if (copy_from_user(&rblocks, ptr, sizeof(struct rpmb_ioc_blocks_cmd)))
+		return -EFAULT;
+
+	if (rblocks.count > rdev->ops->rd_cnt_max)
+		return -EINVAL;
+
+	sz = rblocks.count * 256;
+	data = kmalloc(sz, GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
+	ret = rpmb_read_blocks(rdev, rblocks.addr, rblocks.count, data);
+
+	if (ret == 0)
+		ret = copy_to_user(rblocks.data, data, sz);
+
+	kfree(data);
+	return ret;
+}
+
+/**
+ * rpmb_ioctl - rpmb ioctl dispatcher
+ *
+ * @fp: a file pointer
+ * @cmd: ioctl command RPMB_IOC_SEQ_CMD RPMB_IOC_VER_CMD RPMB_IOC_CAP_CMD
+ * @arg: ioctl data: rpmb_ioc_ver_cmd rpmb_ioc_cap_cmd pmb_ioc_seq_cmd
+ *
+ * Return: 0 on success; < 0 on error
+ */
+static long rpmb_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	struct rpmb_dev *rdev = fp->private_data;
+	void __user *ptr = (void __user *)arg;
+
+	switch (cmd) {
+	case RPMB_IOC_VER_CMD:
+		return rpmb_ioctl_ver_cmd(rdev, ptr);
+	case RPMB_IOC_CAP_CMD:
+		return rpmb_ioctl_cap_cmd(rdev, ptr);
+	case RPMB_IOC_PKEY_CMD:
+		return rpmb_ioctl_pkey_cmd(rdev, ptr);
+	case RPMB_IOC_COUNTER_CMD:
+		return rpmb_ioctl_counter_cmd(rdev, ptr);
+	case RPMB_IOC_WBLOCKS_CMD:
+		return rpmb_ioctl_wblocks_cmd(rdev, ptr);
+	case RPMB_IOC_RBLOCKS_CMD:
+		return rpmb_ioctl_rblocks_cmd(rdev, ptr);
+	default:
+		dev_err(&rdev->dev, "unsupported ioctl 0x%x.\n", cmd);
+		return -ENOIOCTLCMD;
+	}
+}
+
+static const struct file_operations rpmb_fops = {
+	.open           = rpmb_open,
+	.release        = rpmb_release,
+	.unlocked_ioctl = rpmb_ioctl,
+	.owner          = THIS_MODULE,
+	.llseek         = noop_llseek,
+};
+
+void rpmb_cdev_prepare(struct rpmb_dev *rdev)
+{
+	rdev->dev.devt = MKDEV(MAJOR(rpmb_devt), rdev->id);
+	rdev->cdev.owner = THIS_MODULE;
+	cdev_init(&rdev->cdev, &rpmb_fops);
+}
+
+void rpmb_cdev_add(struct rpmb_dev *rdev)
+{
+	cdev_add(&rdev->cdev, rdev->dev.devt, 1);
+}
+
+void rpmb_cdev_del(struct rpmb_dev *rdev)
+{
+	if (rdev->dev.devt)
+		cdev_del(&rdev->cdev);
+}
+
+int __init rpmb_cdev_init(void)
+{
+	int ret;
+
+	ret = alloc_chrdev_region(&rpmb_devt, 0, RPMB_MAX_DEVS, "rpmb");
+	if (ret < 0)
+		pr_err("unable to allocate char dev region\n");
+
+	return ret;
+}
+
+void __exit rpmb_cdev_exit(void)
+{
+	unregister_chrdev_region(rpmb_devt, RPMB_MAX_DEVS);
+}
diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
index a2e21c14986a..e26d605e48e1 100644
--- a/drivers/char/rpmb/core.c
+++ b/drivers/char/rpmb/core.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 
 #include <linux/rpmb.h>
+#include "rpmb-cdev.h"
 
 static DEFINE_IDA(rpmb_ida);
 
@@ -277,6 +278,7 @@ int rpmb_dev_unregister(struct rpmb_dev *rdev)
 		return -EINVAL;
 
 	mutex_lock(&rdev->lock);
+	rpmb_cdev_del(rdev);
 	device_del(&rdev->dev);
 	mutex_unlock(&rdev->lock);
 
@@ -371,9 +373,6 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev, u8 target,
 	if (!ops->read_blocks)
 		return ERR_PTR(-EINVAL);
 
-	if (ops->type == RPMB_TYPE_ANY || ops->type > RPMB_TYPE_MAX)
-		return ERR_PTR(-EINVAL);
-
 	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev)
 		return ERR_PTR(-ENOMEM);
@@ -396,6 +395,8 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev, u8 target,
 	if (ret)
 		goto exit;
 
+	rpmb_cdev_add(rdev);
+
 	dev_dbg(&rdev->dev, "registered device\n");
 
 	return rdev;
@@ -412,11 +413,12 @@ static int __init rpmb_init(void)
 {
 	ida_init(&rpmb_ida);
 	class_register(&rpmb_class);
-	return 0;
+	return rpmb_cdev_init();
 }
 
 static void __exit rpmb_exit(void)
 {
+	rpmb_cdev_exit();
 	class_unregister(&rpmb_class);
 	ida_destroy(&rpmb_ida);
 }
diff --git a/drivers/char/rpmb/rpmb-cdev.h b/drivers/char/rpmb/rpmb-cdev.h
new file mode 100644
index 000000000000..e59ff0c05e9d
--- /dev/null
+++ b/drivers/char/rpmb/rpmb-cdev.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/*
+ * Copyright (C) 2015-2018 Intel Corp. All rights reserved
+ */
+#ifdef CONFIG_RPMB_INTF_DEV
+int __init rpmb_cdev_init(void);
+void __exit rpmb_cdev_exit(void);
+void rpmb_cdev_prepare(struct rpmb_dev *rdev);
+void rpmb_cdev_add(struct rpmb_dev *rdev);
+void rpmb_cdev_del(struct rpmb_dev *rdev);
+#else
+static inline int __init rpmb_cdev_init(void) { return 0; }
+static inline void __exit rpmb_cdev_exit(void) {}
+static inline void rpmb_cdev_prepare(struct rpmb_dev *rdev) {}
+static inline void rpmb_cdev_add(struct rpmb_dev *rdev) {}
+static inline void rpmb_cdev_del(struct rpmb_dev *rdev) {}
+#endif /* CONFIG_RPMB_INTF_DEV */
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
index 718ba7c91ecd..fe44f60efe31 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -8,9 +8,13 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
+#include <linux/cdev.h>
+#include <uapi/linux/rpmb.h>
 #include <linux/kref.h>
 #include <linux/key.h>
 
+#define RPMB_API_VERSION 0x80000001
+
 /**
  * struct rpmb_ops - RPMB ops to be implemented by underlying block device
  *
@@ -51,6 +55,8 @@ struct rpmb_ops {
  * @dev        : device
  * @id         : device id
  * @target     : RPMB target/region within the physical device
+ * @cdev       : character dev
+ * @status     : device status
  * @ops        : operation exported by block layer
  */
 struct rpmb_dev {
@@ -58,6 +64,10 @@ struct rpmb_dev {
 	struct device dev;
 	int id;
 	u8 target;
+#ifdef CONFIG_RPMB_INTF_DEV
+	struct cdev cdev;
+	unsigned long status;
+#endif /* CONFIG_RPMB_INTF_DEV */
 	const struct rpmb_ops *ops;
 };
 
diff --git a/include/uapi/linux/rpmb.h b/include/uapi/linux/rpmb.h
new file mode 100644
index 000000000000..3957b785cdd5
--- /dev/null
+++ b/include/uapi/linux/rpmb.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Copyright (C) 2015-2018 Intel Corp. All rights reserved
+ * Copyright (C) 2021 Linaro Ltd
+ */
+#ifndef _UAPI_LINUX_RPMB_H_
+#define _UAPI_LINUX_RPMB_H_
+
+#include <linux/types.h>
+
+/**
+ * struct rpmb_ioc_ver_cmd - rpmb api version
+ *
+ * @api_version: rpmb API version.
+ */
+struct rpmb_ioc_ver_cmd {
+	__u32 api_version;
+} __packed;
+
+enum rpmb_auth_method {
+	RPMB_HMAC_ALGO_SHA_256 = 0,
+};
+
+/**
+ * struct rpmb_ioc_cap_cmd - rpmb capabilities
+ *
+ * @target: rpmb target/region within RPMB partition.
+ * @capacity: storage capacity (in units of 128K)
+ * @block_size: storage data block size (in units of 256B)
+ * @wr_cnt_max: maximal number of block that can be written in a single request.
+ * @rd_cnt_max: maximal number of block that can be read in a single request.
+ * @auth_method: authentication method: currently always HMAC_SHA_256
+ * @reserved: reserved to align to 4 bytes.
+ */
+struct rpmb_ioc_cap_cmd {
+	__u16 target;
+	__u16 capacity;
+	__u16 block_size;
+	__u16 wr_cnt_max;
+	__u16 rd_cnt_max;
+	__u16 auth_method;
+	__u16 reserved;
+} __attribute__((packed));
+
+/**
+ * struct rpmb_ioc_blocks_cmd - read/write blocks to/from RPMB
+ *
+ * @keyid: key_serial_t of key to use
+ * @addr: index into device (units of 256B blocks)
+ * @count: number of 256B blocks
+ * @data: pointer to data to write/read
+ */
+struct rpmb_ioc_blocks_cmd {
+	__s32 key; /* key_serial_t */
+	__u32 addr;
+	__u32 count;
+	__u8 __user *data;
+} __attribute__((packed));
+
+
+#define RPMB_IOC_VER_CMD     _IOR(0xB8, 80, struct rpmb_ioc_ver_cmd)
+#define RPMB_IOC_CAP_CMD     _IOR(0xB8, 81, struct rpmb_ioc_cap_cmd)
+#define RPMB_IOC_PKEY_CMD    _IOW(0xB8, 82, key_serial_t)
+#define RPMB_IOC_COUNTER_CMD _IOR(0xB8, 84, int)
+#define RPMB_IOC_WBLOCKS_CMD _IOW(0xB8, 85, struct rpmb_ioc_blocks_cmd)
+#define RPMB_IOC_RBLOCKS_CMD _IOR(0xB8, 86, struct rpmb_ioc_blocks_cmd)
+
+#endif /* _UAPI_LINUX_RPMB_H_ */
-- 
2.20.1

