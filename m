Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B4DC6FA90
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 02:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiIPCB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 22:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiIPCB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 22:01:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADA980F5A
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 19:01:19 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MTHKk4NFPznVK1;
        Fri, 16 Sep 2022 09:58:34 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 10:01:08 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 10:01:08 +0800
Message-ID: <32aff63d-1b79-916a-50e2-1e6c113ed9ef@huawei.com>
Date:   Fri, 16 Sep 2022 10:01:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        <qiuchangqi.qiu@huawei.com>, <wubo40@huawei.com>
From:   Wu Bo <wubo40@huawei.com>
Subject: [PATCH] scsi: core: Add io timeout count for scsi device
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current the scsi device has iorequest count, iodone count
and ioerr count, but lack of io timeout count.

For better tracking of scsi io, So add it now.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
  drivers/scsi/scsi_error.c  | 1 +
  drivers/scsi/scsi_sysfs.c  | 2 ++
  include/scsi/scsi_device.h | 1 +
  3 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 448748e..e84aea9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -334,6 +334,7 @@ enum blk_eh_timer_return scsi_timeout(struct request 
*req)
         trace_scsi_dispatch_cmd_timeout(scmd);
         scsi_log_completion(scmd, TIMEOUT_ERROR);

+       atomic_inc(&scmd->device->iotmo_cnt);
         if (host->eh_deadline != -1 && !host->last_reset)
                 host->last_reset = jiffies;

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9dad2fd..72e702c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -970,6 +970,7 @@ static DEVICE_ATTR(field, S_IRUGO, 
show_iostat_##field, NULL)
  show_sdev_iostat(iorequest_cnt);
  show_sdev_iostat(iodone_cnt);
  show_sdev_iostat(ioerr_cnt);
+show_sdev_iostat(iotmo_cnt);

  static ssize_t
  sdev_show_modalias(struct device *dev, struct device_attribute *attr, 
char *buf)
@@ -1289,6 +1290,7 @@ static umode_t 
scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
         &dev_attr_iorequest_cnt.attr,
         &dev_attr_iodone_cnt.attr,
         &dev_attr_ioerr_cnt.attr,
+       &dev_attr_iotmo_cnt.attr,
         &dev_attr_modalias.attr,
         &dev_attr_queue_depth.attr,
         &dev_attr_queue_type.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3113471..78039d1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -231,6 +231,7 @@ struct scsi_device {
         atomic_t iorequest_cnt;
         atomic_t iodone_cnt;
         atomic_t ioerr_cnt;
+       atomic_t iotmo_cnt;

         struct device           sdev_gendev,
                                 sdev_dev;
-- 
1.8.3.1
