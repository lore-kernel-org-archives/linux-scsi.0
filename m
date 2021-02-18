Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E3AC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 19:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F4F364EBA
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhBRTOR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 14:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbhBRRvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 12:51:48 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2ABC061788;
        Thu, 18 Feb 2021 09:51:05 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g5so7158045ejt.2;
        Thu, 18 Feb 2021 09:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GDQh0QEQbp9EyxBLZJYplnHcQKv0aNwLxSIw4hIybT0=;
        b=sxzws0YDabvA5xZ9Cz3vdVVqhushPBAJAKBTFZUJw6iRDx4cVAVFRuG1jdo9iOPvUB
         y8UFQuvIHA/Ytl6B6CabWA669WOabO4naQIMYSO0VLAsp1vGssky+jfAa7acOk6EX9VE
         xLD65puHidKzvtivK1JeUy/mO84tI0PdvF64qqAhk6C0XKSx5bcnh8RSHe1m5lggNcoi
         dH5bzIoXupR2afdopXYE5VYiCssP2HMsKyoIB7jSLlpL0eONeCeYEi2LLvwMJMbNmhxx
         tiY982rnZ0nFS2cYC7SUm+J5t+XOqdT+P9jZTmPY+yFv06piyKvaYdM+3D1uBW+aPr6n
         ZQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GDQh0QEQbp9EyxBLZJYplnHcQKv0aNwLxSIw4hIybT0=;
        b=AdOFXXx12jLlyqsLKmcGmDGTn0Yc/XSjT1UgL3EJxzpjYcgWtXc4O3xSpVBfu5vWiv
         Z2Msyz9E/qa4Gfvv9GZjXRdcwI4h8Z+Prra7ujJlio/GCbwBJrWEw0CvC1P5hScVsp2j
         HZW33cYGpZPQ7j1mV9yY0cAaxYe9//bPdzxubc/QjZA63U8ny1xlmBD0pPqqxK4Wdvlt
         vCFnDGBeScrev7cEeP/+v/95xGDv9ZvSOQc5CVQLOOj/R5wBQPCYMgQAOcIckPdt2yM5
         JZwudV3Ep9ZtSjG9gfkuXP0XSrmt0KUKDkoVxSCiD+oksW0xYuLomF07DyIF7YhNYgsN
         l6GA==
X-Gm-Message-State: AOAM530hYYzBEIaVTvpTkw+Yl8PR4L4ExX4WPu++S7mkjgfB5DP+AYjV
        LxK+On8MMFn0J8/p2VPMUrBAxwm6goQ=
X-Google-Smtp-Source: ABdhPJyc+lH+7RtAr8ZYq/DCsY8SzckiBU14kLjxJJxmlkM7mlmZFo56z7dKU/mIeXsUtiYS9/mKrA==
X-Received: by 2002:a17:906:f102:: with SMTP id gv2mr5040168ejb.47.1613670664086;
        Thu, 18 Feb 2021 09:51:04 -0800 (PST)
Received: from localhost (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id cb21sm3243668edb.57.2021.02.18.09.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 09:51:03 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/2] scsi: target: tcmu: Fix memory leak caused by wrong uio usage
Date:   Thu, 18 Feb 2021 18:50:39 +0100
Message-Id: <20210218175039.7829-3-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210218175039.7829-1-bostroesser@gmail.com>
References: <20210218175039.7829-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When user deletes a tcmu device via configFS, tcmu calls
uio_unregister_device(). During that call uio resets its pointer
to struct uio_info provided by tcmu. That means, after
uio_unregister_device uio will no longer execute any of the
callbacks tcmu had set in uio_info.

Especially, if userspace daemon still holds the corresponding uio
device open or mmap'ed while tcmu calls uio_unregister_device(),
uio will not call tcmu_release() when userspace finally closes
and munmaps the uio device.

Since tcmu does refcounting for the tcmu device in tcmu_open()
and tcmu_release(), in the decribed case refcount does not drop
to 0 and tcmu does not free tcmu device's resources.
In extrem cases this can cause memory leaking of up to 1 GB for
a single tcmu device.

After uio_unregister_device(), uio will reject every open, read,
write, mmap from userspace with -EOI. But userspace daemon can
still access the mmap'ed command ring and data area. Therefore
tcmu should wait until userspace munmaps the uio device before
it frees the resources, as we don't want to cause SIGSEGV or
SIGBUS to user space.

That said, current refcounting during tcmu_open and tcmu_release
does not work correctly, and refcounting better should be done in
the open and close callouts of the vm_operations_struct, which
tcmu assigns to each mmap of the uio device (because it wants its
own page fault handler).

This patch fixes the memory leak by removing refcounting from
tcmu_open and tcmu_close, and instead adding new tcmu_vma_open()
and tcmu_vma_close() handlers that only do refcounting.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 6d010cf22879..bf73cd5f4b04 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1643,6 +1643,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	bitmap_free(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
+	pr_debug("dev_kref_release\n");
+
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
 
@@ -1758,6 +1760,25 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 	return page;
 }
 
+static void tcmu_vma_open(struct vm_area_struct *vma)
+{
+	struct tcmu_dev *udev = vma->vm_private_data;
+
+	pr_debug("vma_open\n");
+
+	kref_get(&udev->kref);
+}
+
+static void tcmu_vma_close(struct vm_area_struct *vma)
+{
+	struct tcmu_dev *udev = vma->vm_private_data;
+
+	pr_debug("vma_close\n");
+
+	/* release ref from tcmu_vma_open */
+	kref_put(&udev->kref, tcmu_dev_kref_release);
+}
+
 static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 {
 	struct tcmu_dev *udev = vmf->vma->vm_private_data;
@@ -1796,6 +1817,8 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct tcmu_vm_ops = {
+	.open = tcmu_vma_open,
+	.close = tcmu_vma_close,
 	.fault = tcmu_vma_fault,
 };
 
@@ -1812,6 +1835,8 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
 		return -EINVAL;
 
+	tcmu_vma_open(vma);
+
 	return 0;
 }
 
@@ -1824,7 +1849,6 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 		return -EBUSY;
 
 	udev->inode = inode;
-	kref_get(&udev->kref);
 
 	pr_debug("open\n");
 
@@ -1838,8 +1862,7 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 	clear_bit(TCMU_DEV_BIT_OPEN, &udev->flags);
 
 	pr_debug("close\n");
-	/* release ref from open */
-	kref_put(&udev->kref, tcmu_dev_kref_release);
+
 	return 0;
 }
 
-- 
2.12.3

