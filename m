Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65191C4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFD664E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBJTmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhBJTmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 14:42:10 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810CCC06174A;
        Wed, 10 Feb 2021 11:41:28 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v7so4389088eds.10;
        Wed, 10 Feb 2021 11:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LHXywT2kelu1bKxhCC80KU3i6QC3hDkkI/0ReAsfSNc=;
        b=V6PRP8dvUsdGypUE8XML5M6kvkPQlKQYm9NB6v1dCRWMFpqZ2XrDeMOjabew0YIdmj
         6oiNxNtNuh3pB/SAQxYKySGNf+NIhlWXUtq9Pp6eDVOEB/wTCySHZi7/d6gFIwo1edGD
         iA8s4JIwTyqaLqNDagfhvvQkFJALqgkuH6H/gTJqsto6r2WnZU8C865s76xtknufv3MD
         mIHY/UJqJiI7Wl8lFGcUu44WP4wlEtgJtORuHxpjMEvCo0u7Ef6MZUKH3QbaX8BQzT6c
         ADPNhHYLUM91LtM+ee0XwFiokrzud+NPZSg8pj6AaA5wtwKzYY8jTr/ckMquTy7pCyY/
         7bVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LHXywT2kelu1bKxhCC80KU3i6QC3hDkkI/0ReAsfSNc=;
        b=AAZhEtpsa6ZB/s9Wb3bDYoGyamHtExS3Ml6iqqHKiDbf4mxrR7KcsU9gscTDvdXwUR
         OhEs/BZhnUrMv4DoJ4vtxq2roS13sTKsXzY37YVv8RoOvrF/hb5Z3hPFmIiC+UZC19VO
         hoyRXcZMsN9JyehOEVh1oAAnAqhhAciijLQk1yX8s9rPXJdsW+axCDF9ps0bOoYKGjMR
         W+e1FCcGQoZiGgeRKiET9RQiwv3+PUYOP/yk2nrO4NGKF2qjRyADeLAz96gvzJPL01U3
         alQ7cbJT3hb+4stnJ1Spa+yAHf4DMmwMhNzaBkP9SmSUcSYLopmlvJ3P8fCFoA2ZZb9b
         JASA==
X-Gm-Message-State: AOAM5314mcoTdThZ1o+/BRSX19XLhBmJiz0TdZ3pW+0xis7OUMj47m1P
        HMK60K7Xz/DfsVqgWG8MjzoeYeuk+cs=
X-Google-Smtp-Source: ABdhPJyjfvkkSlsnp7GqKHJ9E1suw+SQAb0RxqYouVfgb1UNczfXYpbtbUUeAZkYKqFdlNjJQODq9Q==
X-Received: by 2002:a05:6402:202a:: with SMTP id ay10mr4773740edb.93.1612986087299;
        Wed, 10 Feb 2021 11:41:27 -0800 (PST)
Received: from localhost (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id r1sm1794806eds.70.2021.02.10.11.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:41:27 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/2] uio: Add late_release callback to uio_info
Date:   Wed, 10 Feb 2021 20:40:30 +0100
Message-Id: <20210210194031.7422-2-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210210194031.7422-1-bostroesser@gmail.com>
References: <20210210194031.7422-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If uio_unregister_device() is called while userspace daemon
still holds the uio device open or mmap'ed, uio will not call
uio_info->release() on later close / munmap.

At least one user of uio (tcmu) should not free resources (pages
allocated by tcmu which are mmap'ed to userspace) while uio
device still is open, because that could cause userspace daemon
to be killed by SIGSEGV or SIGBUS. Therefore tcmu frees the
pages only after it called uio_unregister_device _and_ the device
was closed.
So, uio not calling uio_info->release causes trouble.
tcmu currently leaks memory in that case.

Just waiting for userspace daemon to exit before calling
uio_unregister_device I think is not the right solution, because
daemon would not become aware of kernel code wanting to destroy
the uio device.
After uio_unregister_device was called, reading or writing the
uio device returns -EIO, which normally results in daemon exit.

This patch adds new callback pointer 'late_release' to struct
uio_info. If uio user sets this callback, it will be called by
uio if userspace closes / munmaps the device after
uio_unregister_device was executed.

That way we can use uio_unregister_device() to notify userspace
that we are going to destroy the device, but still get a call
to late_release when uio device is finally closed.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 Documentation/driver-api/uio-howto.rst | 10 ++++++++++
 drivers/uio/uio.c                      |  4 ++++
 include/linux/uio_driver.h             |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/Documentation/driver-api/uio-howto.rst b/Documentation/driver-api/uio-howto.rst
index 907ffa3b38f5..a2d57a7d623a 100644
--- a/Documentation/driver-api/uio-howto.rst
+++ b/Documentation/driver-api/uio-howto.rst
@@ -265,6 +265,16 @@ the members are required, others are optional.
    function. The parameter ``irq_on`` will be 0 to disable interrupts
    and 1 to enable them.
 
+-  ``int (*late_release)(struct uio_info *info, struct inode *inode)``:
+   Optional. If you define your own :c:func:`open()`, you will
+   in certain cases also want a custom :c:func:`late_release()`
+   function. If uio device is unregistered - by calling
+   :c:func:`uio_unregister_device()` - while it is open or mmap'ed by
+   userspace, the custom :c:func:`release()` function will not be
+   called when userspace later closes the device. An optionally
+   specified :c:func:`late_release()` function will be called in that
+   situation.
+
 Usually, your device will have one or more memory regions that can be
 mapped to user space. For each region, you have to set up a
 ``struct uio_mem`` in the ``mem[]`` array. Here's a description of the
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index ea96e319c8a0..0b2636f8d373 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -532,6 +532,8 @@ static int uio_release(struct inode *inode, struct file *filep)
 	mutex_lock(&idev->info_lock);
 	if (idev->info && idev->info->release)
 		ret = idev->info->release(idev->info, inode);
+	else if (idev->late_info && idev->late_info->late_release)
+		ret = idev->late_info->late_release(idev->late_info, inode);
 	mutex_unlock(&idev->info_lock);
 
 	module_put(idev->owner);
@@ -1057,6 +1059,8 @@ void uio_unregister_device(struct uio_info *info)
 		free_irq(info->irq, idev);
 
 	idev->info = NULL;
+	if (info->late_release)
+		idev->late_info = info;
 	mutex_unlock(&idev->info_lock);
 
 	wake_up_interruptible(&idev->wait);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 47c5962b876b..5712e149f9ac 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -74,6 +74,7 @@ struct uio_device {
 	struct fasync_struct    *async_queue;
 	wait_queue_head_t       wait;
 	struct uio_info         *info;
+	struct uio_info         *late_info;
 	struct mutex		info_lock;
 	struct kobject          *map_dir;
 	struct kobject          *portio_dir;
@@ -94,6 +95,8 @@ struct uio_device {
  * @open:		open operation for this uio device
  * @release:		release operation for this uio device
  * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
+ * @late_release:	optional late release operation for this uio device,
+ *			called if device is released after uio_unregister_device()
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
@@ -109,6 +112,7 @@ struct uio_info {
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
+	int (*late_release)(struct uio_info *info, struct inode *inode);
 };
 
 extern int __must_check
-- 
2.12.3

