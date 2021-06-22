Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6A7C2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F1060FEE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFVJSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 05:18:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11080 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFVJSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2021 05:18:06 -0400
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G8LJw6LCbzZgjR;
        Tue, 22 Jun 2021 17:12:48 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 dggeml756-chm.china.huawei.com (10.1.199.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 22 Jun 2021 17:15:48 +0800
Subject: Re: [PATCH v3] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     John Garry <john.garry@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Wu Bo <wubo40@huawei.com>
References: <20210622034037.1467088-1-yuyufen@huawei.com>
 <af233a61-76a5-d4fe-e190-2f4d020df31a@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <d9757dc3-851d-e7bf-e59a-58e7f761d4bd@huawei.com>
Date:   Tue, 22 Jun 2021 17:15:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <af233a61-76a5-d4fe-e190-2f4d020df31a@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml756-chm.china.huawei.com (10.1.199.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2021/6/22 15:20, John Garry 写道:
> On 22/06/2021 04:40, Yufen Yu wrote:
>> We found that offline a sata device on hisi sas control and then
> 
> /s/sata/SATA/
> 
> /s/control/controller/
> 
>> scanning the host can probe 255 not-existant devices into system.
>>
>> [root@localhost ~]# lsscsi
>>    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>>    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>>    [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
>>
>>   1) echo "offline" > /sys/block/sdb/device/state
>>   2) echo "- - -" > /sys/class/scsi_host/host2/scan
>>
>> Then, we can see another 255 non-existant devices in system:
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
> 
> I thought that we would mention why we don't change aic7xxx driver.

We are talking about libsas here. aic7xxx is not even a libsas driver,
so I don't think we need to mention it.

Thanks,
Jason

> 
>> Reported-by: Wu Bo<wubo40@huawei.com>
>> Suggested-by: John Garry<john.garry@huawei.com>
>> Signed-off-by: Yufen Yu<yuyufen@huawei.com>
>> ---
> 
> Apart from the small items above:
> Reviewed-by: John Garry <john.garry@huawei.com>
> .
