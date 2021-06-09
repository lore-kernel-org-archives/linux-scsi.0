Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3EEC48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 12:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E05D860FEB
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 12:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhFIMRH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 08:17:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3187 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhFIMRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 08:17:07 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G0Qmb3rcFz6K5X2;
        Wed,  9 Jun 2021 20:05:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 14:15:11 +0200
Received: from [10.47.80.201] (10.47.80.201) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 13:15:10 +0100
Subject: Re: [PATCH v2] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     Yufen Yu <yuyufen@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yanaijie@huawei.com>,
        <wubo40@huawei.com>
References: <20210609093631.2557822-1-yuyufen@huawei.com>
 <9c67a92d-b9df-0e0c-5dda-e9dbeffec48f@huawei.com>
 <cc7ff06c-6d7b-1aa9-91ea-40df057d9d2b@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9e6d20db-d9fe-24b6-4acd-924d3b5e4c2e@huawei.com>
Date:   Wed, 9 Jun 2021 13:09:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <cc7ff06c-6d7b-1aa9-91ea-40df057d9d2b@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.201]
X-ClientProxiedBy: lhreml749-chm.china.huawei.com (10.201.108.199) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/06/2021 13:01, Yufen Yu wrote:
>>
>> Do we also need to modify aix79xx in a similar fashion?
> 
> There is no aix79xx in directory drivers/scsi. I guess you mean
> aic79xxx? But it seems not need to modify.
> 

So if you think that this HBA does not support SATA, then it would be 
good to mention it in the commit log.

Some more comments:

On 09/06/2021 10:36, Yufen Yu wrote:
 > We found that offline a ata device on hisi sas control and then

/s/ata/SATA/

 > scanning the host can probe 255 not exist devices into system.

"can probe 255 non-existant"

 > It can be reproduced easily as following:
 >
 > Some ata devices on hisi sas v3 control:

I don't know what this means, so please drop it.

 >    [root@localhost ~]# lsscsi
 >    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
 >    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
 >    [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
 >
 >   1) echo "offline" > /sys/block/sdb/device/state
 >   2) echo "- - -" > /sys/class/scsi_host/host2/scan
 >
 > Then, we can see another 255 not exist devices in system:

use "non-existant"


 >    [root@localhost ~]# lsscsi
 >    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
 >    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
 >    [2:0:1:1]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdh
 >    ...
 >    [2:0:1:255]  disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdjb
 >
 > After REPORT LUN command issued to the offline device fail, it tries
 > to do a sequential scan and probe all devices whose lun is not 0
 > successfully.
 >
 > To fix the problem, we try to do same things as commit 2fc62e2ac350
 > ("[SCSI] libsas: disable scanning lun > 0 on ata devices"), which
 > will prevent the device whose lun number is not zero probe into system.
 >


Thanks,
John
