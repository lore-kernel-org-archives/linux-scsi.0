Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7630C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 16:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiI0QL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 12:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiI0QLH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 12:11:07 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CD95C94B;
        Tue, 27 Sep 2022 09:09:42 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4McPf151Jpz686y1;
        Wed, 28 Sep 2022 00:07:21 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 18:09:25 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 17:09:24 +0100
Message-ID: <66dbb3da-595e-c673-320d-00f139435192@huawei.com>
Date:   Tue, 27 Sep 2022 17:09:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 2/2] ata: libata-sata: Fix device queue depth control
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
 <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
 <db84e61a-1069-982a-5659-297fcffc14f4@huawei.com>
 <ed504bcc-a880-12c5-0dea-4b22a8cce087@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <ed504bcc-a880-12c5-0dea-4b22a8cce087@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/09/2022 16:03, Damien Le Moal wrote:
> On 9/27/22 20:51, John Garry wrote:
>> On 26/09/2022 00:08, Damien Le Moal wrote:
>>> The function __ata_change_queue_depth() uses the helper
>>> ata_scsi_find_dev() to get the ata_device structure of a scsi device and
>>> set that device maximum queue depth. However, when the ata device is
>>> managed by libsas, ata_scsi_find_dev() returns NULL, turning
>>> __ata_change_queue_depth() into a nop, which prevents the user from
>>> setting the maximum queue depth of ATA devices used with libsas based
>>> HBAs.
>>>
>>> Fix this by renaming __ata_change_queue_depth() to
>>> ata_change_queue_depth() and adding a pointer to the ata_device
>>> structure of the target device as argument. This pointer is provided by
>>> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case of
>>> a libata managed device and by sas_change_queue_depth() using
>>> sas_to_ata_dev() in the case of a libsas managed ata device.
>>>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>> Tested-by: John Garry <john.garry@huawei.com>
>>
>> However - a big however - I will note that this following behaviour is
>> strange for a SATA device for libsas:
>>
>> root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
>> root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
>> sh: echo: write error: Invalid argument
>> root@(none)$
> 
> Weird. I am not getting any error (pm80xx driver). The qd gets capped at
> 32 as expected. Is it something that changes per libsas driver ?

That is with my pm8001 card.

What happens here is that the first store of 33 gets through to 
ata_change_queue_depth() as it does not exceed the SAS shost can_queue, 
which is >> 32, and then we cap this to 32 and store it in 
sdev->queue_depth. And then the 2nd store of 33 also gets through, but 
this following expression not evaluate true in ata_change_queue_depth():

queue_depth < 1 || queue_depth == sdev->queue_depth

So we don't return. However the following subsequent test does evaluate 
true in ata_change_queue_depth():

if (sdev->queue_depth == queue_depth)
	return -EINVAL;

And we error.

> 
>> I also note that setting a value out of range is just rejected for a SAS
>> device, and not capped to the max range (like it is for SATA).
> 
> Not sure where that come from. A quick look does not reveal anything
> obvious. Need to dig into that one.
>>
>> AHCI rejects out of range values it as it exceeds the shost can_queue in
>> sdev_store_queue_depth().
> 
> Indeed:
> 
> echo 1 > /sys/block/sdk/device/queue_depth
> echo 33 > /sys/block/sdk/device/queue_depth

Hmmmm... why no error message? is the printk silenced?

> cat /sys/block/sdk/device/queue_depth
> 1
> 
> But for the libsas SATA device:
> 
> echo 1 > /sys/block/sdd/device/queue_depth
> cat /sys/block/sdd/device/queue_depth
> 1
> echo 33 > /sys/block/sdd/device/queue_depth
> cat /sys/block/sdd/device/queue_depth
> 32
> 
> As one would expect... > Need to dig into that one.
> 

thanks,
John

