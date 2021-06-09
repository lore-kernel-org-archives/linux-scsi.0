Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112E3C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 12:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EABB761263
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 12:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhFIMFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 08:05:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8115 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbhFIMD7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 08:03:59 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0Qcv1ffYzYsYr;
        Wed,  9 Jun 2021 19:59:11 +0800 (CST)
Received: from dggpeml500009.china.huawei.com (7.185.36.209) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 20:02:00 +0800
Received: from [10.174.179.197] (10.174.179.197) by
 dggpeml500009.china.huawei.com (7.185.36.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 20:01:59 +0800
Subject: Re: [PATCH v2] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yanaijie@huawei.com>,
        <wubo40@huawei.com>
References: <20210609093631.2557822-1-yuyufen@huawei.com>
 <9c67a92d-b9df-0e0c-5dda-e9dbeffec48f@huawei.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <cc7ff06c-6d7b-1aa9-91ea-40df057d9d2b@huawei.com>
Date:   Wed, 9 Jun 2021 20:01:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <9c67a92d-b9df-0e0c-5dda-e9dbeffec48f@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.197]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500009.china.huawei.com (7.185.36.209)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi, John

On 2021/6/9 17:40, John Garry wrote:
> On 09/06/2021 10:36, Yufen Yu wrote:
>> We found that offline a ata device on hisi sas control and then
>> scanning the host can probe 255 not exist devices into system.
>> It can be reproduced easily as following:
>>
>> Some ata devices on hisi sas v3 control:
>>    [root@localhost ~]# lsscsi
>>    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>>    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>>    [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
>>
>>   1) echo "offline" > /sys/block/sdb/device/state
>>   2) echo "- - -" > /sys/class/scsi_host/host2/scan
>>
>> Then, we can see another 255 not exist devices in system:
>>    [root@localhost ~]# lsscsi
>>    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>>    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>>    [2:0:1:1]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdh
>>    ...
>>    [2:0:1:255]  disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdjb
>>
>> After REPORT LUN command issued to the offline device fail, it tries
>> to do a sequential scan and probe all devices whose lun is not 0
>> successfully.
>>
>> To fix the problem, we try to do same things as commit 2fc62e2ac350
>> ("[SCSI] libsas: disable scanning lun > 0 on ata devices"), which
>> will prevent the device whose lun number is not zero probe into system.
>>
>> Reported-by: Wu Bo <wubo40@huawei.com>
>> Suggested-by: John Garry <john.garry@huawei.com>
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>> ---
>>   drivers/scsi/aic94xx/aic94xx_init.c    | 1 +
>>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
>>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
>>   drivers/scsi/isci/init.c               | 1 +
>>   drivers/scsi/libsas/sas_scsi_host.c    | 9 +++++++++
>>   drivers/scsi/mvsas/mv_init.c           | 1 +
>>   drivers/scsi/pm8001/pm8001_init.c      | 1 +
> 
> Do we also need to modify aix79xx in a similar fashion?

There is no aix79xx in directory drivers/scsi. I guess you mean
aic79xxx? But it seems not need to modify.

> 
> I just noticed that libsas.h already has a prototype for sas_slave_alloc() - any idea why?

'git log' shows that commit fa1c1e8f1ece "[SCSI] Add SATA support to libsas" have
introduced sas_slave_alloc. And commit 9508a66f898d "[SCSI] libsas: async ata scanning"
delete it while forgetting to get rid of the prototype.

Yufen,
Thanks
