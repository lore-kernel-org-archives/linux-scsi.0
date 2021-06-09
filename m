Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6994C48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 12:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9317A613AC
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 12:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhFIMvh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 08:51:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3814 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhFIMv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 08:51:27 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0RdL1BcGzWlZF;
        Wed,  9 Jun 2021 20:44:38 +0800 (CST)
Received: from dggpeml500009.china.huawei.com (7.185.36.209) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 20:49:30 +0800
Received: from [10.174.179.197] (10.174.179.197) by
 dggpeml500009.china.huawei.com (7.185.36.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 20:49:29 +0800
Subject: Re: [PATCH v2] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yanaijie@huawei.com>,
        <wubo40@huawei.com>
References: <20210609093631.2557822-1-yuyufen@huawei.com>
 <9c67a92d-b9df-0e0c-5dda-e9dbeffec48f@huawei.com>
 <cc7ff06c-6d7b-1aa9-91ea-40df057d9d2b@huawei.com>
 <9e6d20db-d9fe-24b6-4acd-924d3b5e4c2e@huawei.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <c73b3f78-76ae-6be2-63b8-d3a844e939bf@huawei.com>
Date:   Wed, 9 Jun 2021 20:49:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <9e6d20db-d9fe-24b6-4acd-924d3b5e4c2e@huawei.com>
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



On 2021/6/9 20:09, John Garry wrote:
> On 09/06/2021 13:01, Yufen Yu wrote:
>>>
>>> Do we also need to modify aix79xx in a similar fashion?
>>
>> There is no aix79xx in directory drivers/scsi. I guess you mean
>> aic79xxx? But it seems not need to modify.
>>
> 
> So if you think that this HBA does not support SATA, then it would be good to mention it in the commit log.

Maybe I didn't describe it clearly. I am not mean that aic79xxx dose not support
SATA. But it is not libsas driver, so I think we don't need to modify it here.

> 
> Some more comments:
> 
> On 09/06/2021 10:36, Yufen Yu wrote:
>  > We found that offline a ata device on hisi sas control and then
> 
> /s/ata/SATA/
> 
>  > scanning the host can probe 255 not exist devices into system.
> 
> "can probe 255 non-existant"
> 
>  > It can be reproduced easily as following:
>  >
>  > Some ata devices on hisi sas v3 control:
> 
> I don't know what this means, so please drop it.
> 
>  >    [root@localhost ~]# lsscsi
>  >    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>  >    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>  >    [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
>  >
>  >   1) echo "offline" > /sys/block/sdb/device/state
>  >   2) echo "- - -" > /sys/class/scsi_host/host2/scan
>  >
>  > Then, we can see another 255 not exist devices in system:
> 
> use "non-existant"

Thanks to point out these error. I will fix it in next version.

Thanks,
Yufen

