Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389F1C10F14
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 12:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3862083B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 12:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfJOMo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 08:44:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3765 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726721AbfJOMo0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 08:44:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3F622109782877069354;
        Tue, 15 Oct 2019 20:44:23 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 20:44:20 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: core: try to get module before removing devcie
Date:   Tue, 15 Oct 2019 21:05:56 +0800
Message-ID: <20191015130556.18061-1-yuyufen@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a test case like block/001 in blktests, which will
create a scsi device by loading scsi_debug module and then
try to delete the device by sysfs interface. At the same time,
it may remove the scsi_debug module.

And getting a invalid paging request BUG_ON as following:

[   34.625854] BUG: unable to handle page fault for address: ffffffffa0016bb8
[   34.629189] Oops: 0000 [#1] SMP PTI
[   34.629618] CPU: 1 PID: 450 Comm: bash Tainted: G        W         5.4.0-rc3+ #473
[   34.632524] RIP: 0010:scsi_proc_hostdir_rm+0x5/0xa0
[   34.643555] CR2: ffffffffa0016bb8 CR3: 000000012cd88000 CR4: 00000000000006e0
[   34.644545] Call Trace:
[   34.644907]  scsi_host_dev_release+0x6b/0x1f0
[   34.645511]  device_release+0x74/0x110
[   34.646046]  kobject_put+0x116/0x390
[   34.646559]  put_device+0x17/0x30
[   34.647041]  scsi_target_dev_release+0x2b/0x40
[   34.647652]  device_release+0x74/0x110
[   34.648186]  kobject_put+0x116/0x390
[   34.648691]  put_device+0x17/0x30
[   34.649157]  scsi_device_dev_release_usercontext+0x2e8/0x360
[   34.649953]  execute_in_process_context+0x29/0x80
[   34.650603]  scsi_device_dev_release+0x20/0x30
[   34.651221]  device_release+0x74/0x110
[   34.651732]  kobject_put+0x116/0x390
[   34.652230]  sysfs_unbreak_active_protection+0x3f/0x50
[   34.652935]  sdev_store_delete.cold.4+0x71/0x8f
[   34.653579]  dev_attr_store+0x1b/0x40
[   34.654103]  sysfs_kf_write+0x3d/0x60
[   34.654603]  kernfs_fop_write+0x174/0x250
[   34.655165]  __vfs_write+0x1f/0x60
[   34.655639]  vfs_write+0xc7/0x280
[   34.656117]  ksys_write+0x6d/0x140
[   34.656591]  __x64_sys_write+0x1e/0x30
[   34.657114]  do_syscall_64+0xb1/0x400
[   34.657627]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   34.658335] RIP: 0033:0x7f156f337130

During deleting scsi target, the scsi_debug module have been
removed. Then, sdebug_driver_template belonged to the module
cannot be accessd, resulting in scsi_proc_hostdir_rm() BUG_ON.

To fix the bug, we add scsi_device_get() in sdev_store_delete()
to try to increase refcount of module, avoiding the module been
removed.

Cc: stable@vger.kernel.org
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/scsi/scsi_sysfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 64c96c7828ee..6d7362e7367e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -730,6 +730,14 @@ sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
 	struct kernfs_node *kn;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	/*
+	 * We need to try to get module, avoiding the module been removed
+	 * during delete.
+	 */
+	if (scsi_device_get(sdev))
+		return -ENODEV;
 
 	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
 	WARN_ON_ONCE(!kn);
@@ -744,9 +752,10 @@ sdev_store_delete(struct device *dev, struct device_attribute *attr,
 	 * state into SDEV_DEL.
 	 */
 	device_remove_file(dev, attr);
-	scsi_remove_device(to_scsi_device(dev));
+	scsi_remove_device(sdev);
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
+	scsi_device_put(sdev);
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
-- 
2.17.2

