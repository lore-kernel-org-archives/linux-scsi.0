Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EC6C77B7D
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 02:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjEOCzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 May 2023 22:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjEOCzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 May 2023 22:55:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1350E7A
        for <linux-scsi@vger.kernel.org>; Sun, 14 May 2023 19:55:04 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QKP495jKMzTkfx;
        Mon, 15 May 2023 10:50:17 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 10:55:01 +0800
Message-ID: <e08f3fe4-a14e-c1c7-4344-7fbe0b50d44f@huawei.com>
Date:   Mon, 15 May 2023 10:55:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: SCSI: Consumer of
 scsi_devices->iorequest_cnt/iodone_cnt/ioerr_cnt
To:     Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <emilne@redhat.com>, <czhong@redhat.com>,
        Wenchao Hao <haowenchao@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linfeilong@huawei.com>
References: <ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com>
Content-Language: en-US
From:   "haowenchao (C)" <haowenchao2@huawei.com>
In-Reply-To: <ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/5/13 23:55, Ming Lei wrote:
> Hello Guys,
> 
> scsi_device->iorequest_cnt/iodone_cnt/ioerr_cnt are only inc/dec,
> and exported to userspace via sysfs in kernel, and not see any kernel
> consumers, so the exported counters are only for userspace, just be curious
> which/how applications consume them?
> 

These counters are used to checking the disk health status in a certain scenario
for us.

> These counters not only adds cost in fast path, but also causes kernel panic,
> especially the "atomic_inc(&cmd->device->iorequest_cnt)" in
> scsi_queue_rq(), because cmd->device may be freed after returning
> from scsi_dispatch_cmd(), which is introduced by:
> 
> cfee29ffb45b ("scsi: core: Do not increase scsi_device's iorequest_cnt if dispatch failed")
> 
> If there aren't explicit applications which depend on these counters,
> I'd suggest to kill the three since all are not in stable ABI. Otherwise
> I think we need to revert cfee29ffb45b.
> 
> 

Sorry for introduce this bug.

We would check these counters after iodone_cnt equal to iorequest_cnt. So
cfee29ffb45b is aimed to fix the issue of iorequest_cnt is increased for
multiple times if scsi_dispatch_cmd() failed.

Maybe we should revert cfee29ffb45b and fix the original issue with following
changes:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 03964b26f3f2..0226c9279cef 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1485,6 +1485,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
                  */
                 SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
                         "queuecommand : device blocked\n"));
+               atomic_dec(&cmd->device->iorequest_cnt);
                 return SCSI_MLQUEUE_DEVICE_BUSY;
         }
  
@@ -1517,6 +1518,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
         trace_scsi_dispatch_cmd_start(cmd);
         rtn = host->hostt->queuecommand(host, cmd);
         if (rtn) {
+               atomic_dec(&cmd->device->iorequest_cnt);
                 trace_scsi_dispatch_cmd_error(cmd, rtn);
                 if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
                     rtn != SCSI_MLQUEUE_TARGET_BUSY)

> 
> [1] [linux]$ git grep -n -E "iorequest_cnt|iodone_cnt|ioerr_cnt" ./
> Documentation/scsi/st.rst:222:value as iodone_cnt at the device level. The tape statistics only count
> drivers/scsi/scsi_error.c:362:  atomic_inc(&scmd->device->iodone_cnt);
> drivers/scsi/scsi_lib.c:1428:   atomic_inc(&cmd->device->iodone_cnt);
> drivers/scsi/scsi_lib.c:1430:           atomic_inc(&cmd->device->ioerr_cnt);
> drivers/scsi/scsi_lib.c:1764:   atomic_inc(&cmd->device->iorequest_cnt);
> drivers/scsi/scsi_sysfs.c:968:show_sdev_iostat(iorequest_cnt);
> drivers/scsi/scsi_sysfs.c:969:show_sdev_iostat(iodone_cnt);
> drivers/scsi/scsi_sysfs.c:970:show_sdev_iostat(ioerr_cnt);
> drivers/scsi/scsi_sysfs.c:1288: &dev_attr_iorequest_cnt.attr,
> drivers/scsi/scsi_sysfs.c:1289: &dev_attr_iodone_cnt.attr,
> drivers/scsi/scsi_sysfs.c:1290: &dev_attr_ioerr_cnt.attr,
> drivers/scsi/sd.c:3531: atomic_set(&sdkp->device->ioerr_cnt, 0);
> include/scsi/scsi_device.h:234: atomic_t iorequest_cnt;
> include/scsi/scsi_device.h:235: atomic_t iodone_cnt;
> include/scsi/scsi_device.h:236: atomic_t ioerr_cnt;
> 
> 
> 
> 
> Thanks,
> Ming
> 

