Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFB1C6FA86
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 07:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiI1Hya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 03:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiI1HyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 03:54:01 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4605B057;
        Wed, 28 Sep 2022 00:53:58 -0700 (PDT)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mcpf751ZDz6HJT8;
        Wed, 28 Sep 2022 15:53:51 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Wed, 28 Sep 2022 09:53:55 +0200
Received: from [10.126.175.219] (10.126.175.219) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 08:53:55 +0100
Message-ID: <13e5e5e5-7dc2-8f14-3dd2-43366343842d@huawei.com>
Date:   Wed, 28 Sep 2022 08:53:57 +0100
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
 <66dbb3da-595e-c673-320d-00f139435192@huawei.com>
 <6f08d6b9-63ba-10f6-2900-020db60a94be@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <6f08d6b9-63ba-10f6-2900-020db60a94be@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.175.219]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/09/2022 08:00, Damien Le Moal wrote:
>> So we don't return. However the following subsequent test does evaluate
>> true in ata_change_queue_depth():
>>
>> if (sdev->queue_depth == queue_depth)
>> 	return -EINVAL;
>>
>> And we error.
> I dug further into this. For AHCI, I still get an error when trying to set
> 33. No capping and defaulting to 32. The reason is I believe that
> sdev_store_queue_depth() has the check:
> 
> 	if (depth < 1 || depth > sdev->host->can_queue)
>                  return -EINVAL;
> 
> as you mentioned. So all good.
> 
> So changing that last "if" in ata_change_queue_depth() to
> 
> 	if (sdev->queue_depth == queue_depth)
> 		return sdev->queue_depth;
> 
> has no effect. The error remains.
> 
> Now, for a libsas SATA drive, if I add the above change, I do indeed get a
> cap to 32 and the QD changes, no error. That is bothering me as that is
> really inconsistent. Instead of suppressing the error, shouldn't we unify
> AHCI and libsas behavior and error if the user is attempting to set a
> value larger than what the*device*  supports (the host can_queue was
> checked already). In a nutshell, the difference comes form
> sdev->host->can_queue being equal to the device max qd for AHCI but not
> necessarily for libsas.

Yes, I think consistent behaviour would be good. I suppose we just need 
the same check to reject QD of > 32 in ata_change_queue_depth() (and not 
just cap to 32 there).

Having said all that, scsi_device_max_queue_depth() does introduce some 
capping. But let's just consider SATA behaviour now.

> 
> I am tempted to leave things as is for now (not changin gthe current weird
> behavior) and cleaning that up during the next round. Thoughts ?
> 

It's up to you. Obviously we are making an improvement in this series, 
but if we are going to backport then it's better to backport something 
fully working first time.

Thanks,
John
