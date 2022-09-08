Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EBCECAAD5
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 08:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiIHIPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 04:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiIHIOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 04:14:44 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0968C12750
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 01:14:35 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MNWyr2wMPz14QR5;
        Thu,  8 Sep 2022 16:10:44 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 16:14:33 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 16:14:33 +0800
Message-ID: <f081b7ca-64d9-add3-2ebb-48b80614d107@huawei.com>
Date:   Thu, 8 Sep 2022 16:14:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: scsi: core: Add io timeout count for scsi device
Content-Language: en-US
References: <dc592095-0a26-b33d-b019-52424df22957@huawei.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <qiuchangqi.qiu@huawei.com>,
        <wubo40@huawei.com>
From:   Wu Bo <wubo40@huawei.com>
In-Reply-To: <dc592095-0a26-b33d-b019-52424df22957@huawei.com>
X-Forwarded-Message-Id: <dc592095-0a26-b33d-b019-52424df22957@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
-- 
Wu Bo
