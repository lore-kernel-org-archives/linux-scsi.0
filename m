Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9205EECAAD8
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 08:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiITIwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiITIwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 04:52:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB4062AA2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 01:52:02 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWwFj4hb4zpT6w;
        Tue, 20 Sep 2022 16:49:13 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 16:52:01 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500019.china.huawei.com
 (7.185.36.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 20 Sep
 2022 16:52:00 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <bvanassche@acm.org>,
        <qiuchangqi.qiu@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH V2] scsi: core: Add io timeout count for scsi device
Date:   Tue, 20 Sep 2022 17:32:19 +0800
Message-ID: <1663666339-17560-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

Current the scsi device has iorequest count, iodone count
and ioerr count, but lack of io timeout count.

For better tracking of scsi io, So add it now.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
v1->v2
Rebase this patch on top of Martin's for-next branch.
---
 drivers/scsi/scsi_error.c  | 1 +
 drivers/scsi/scsi_sysfs.c  | 2 ++
 include/scsi/scsi_device.h | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 448748e..e84aea9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -334,6 +334,7 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
+	atomic_inc(&scmd->device->iotmo_cnt);
 	if (host->eh_deadline != -1 && !host->last_reset)
 		host->last_reset = jiffies;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5d61f58..c95177c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -976,6 +976,7 @@ static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
 show_sdev_iostat(iorequest_cnt);
 show_sdev_iostat(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
+show_sdev_iostat(iotmo_cnt);
 
 static ssize_t
 sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
@@ -1295,6 +1296,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	&dev_attr_iorequest_cnt.attr,
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
+	&dev_attr_iotmo_cnt.attr,
 	&dev_attr_modalias.attr,
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2493bd6..c36656d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -231,6 +231,7 @@ struct scsi_device {
 	atomic_t iorequest_cnt;
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
+	atomic_t iotmo_cnt;
 
 	struct device		sdev_gendev,
 				sdev_dev;
-- 
1.8.3.1

