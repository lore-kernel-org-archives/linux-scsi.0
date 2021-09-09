Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFADC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 03:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F66561178
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 03:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhIIDsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 23:48:00 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15311 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhIIDr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 23:47:59 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4H4lKk1ZSnz8t02;
        Thu,  9 Sep 2021 11:46:18 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 9 Sep 2021 11:46:48 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 9 Sep 2021 11:46:47 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <fujita.tomonori@lab.ntt.co.jp>, <axboe@kernel.dk>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <gregkh@linuxfoundation.org>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] scsi: bsg: Fix device unregistration
Date:   Thu, 9 Sep 2021 11:46:08 +0800
Message-ID: <20210909034608.1435-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use device_initialize() to take refcount for the device but forget to
put_device() on device teardown, which ends up leaking private data of the
driver core, dev_name(), etc. This is reported by kmemleak at boot time if
we compile kernel with DEBUG_TEST_DRIVER_REMOVE.

Note that adding the missing put_device() is _not_ sufficient to fix device
unregistration. As we don't provide the .release() method for device, which
turned out to be typically wrong and will be complained loudly by the
driver core.

Fix both of them.

Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 block/bsg.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 351095193788..c3bb92b9af7e 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -165,13 +165,20 @@ static const struct file_operations bsg_fops = {
 	.llseek		=	default_llseek,
 };
 
+static void bsg_device_release(struct device *dev)
+{
+	struct bsg_device *bd = container_of(dev, struct bsg_device, device);
+
+	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
+	kfree(bd);
+}
+
 void bsg_unregister_queue(struct bsg_device *bd)
 {
 	if (bd->queue->kobj.sd)
 		sysfs_remove_link(&bd->queue->kobj, "bsg");
 	cdev_device_del(&bd->cdev, &bd->device);
-	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
-	kfree(bd);
+	put_device(&bd->device);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
@@ -198,6 +205,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	bd->device.devt = MKDEV(bsg_major, ret);
 	bd->device.class = bsg_class;
 	bd->device.parent = parent;
+	bd->device.release = bsg_device_release;
 	dev_set_name(&bd->device, "%s", name);
 	device_initialize(&bd->device);
 
@@ -218,6 +226,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 out_device_del:
 	cdev_device_del(&bd->cdev, &bd->device);
 out_ida_remove:
+	put_device(&bd->device);
 	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
 out_kfree:
 	kfree(bd);
-- 
2.19.1

