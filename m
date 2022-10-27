Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C70FA373D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 08:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiJ0IQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiJ0IQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 04:16:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF87EE09;
        Thu, 27 Oct 2022 01:16:40 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MydlM3sYhz67DWp;
        Thu, 27 Oct 2022 16:15:11 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 10:16:38 +0200
Received: from [10.195.32.169] (10.195.32.169) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 09:16:37 +0100
Message-ID: <72234b96-b3b5-606c-cf82-95e6ee86550d@huawei.com>
Date:   Thu, 27 Oct 2022 09:16:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v3 03/22] scsi: core: Implement reserved command
 handling
To:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <jinpu.wang@cloud.ionos.com>,
        <bvanassche@acm.org>, <hch@lst.de>, <ming.lei@redhat.com>,
        <niklas.cassel@wdc.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
 <1666693096-180008-4-git-send-email-john.garry@huawei.com>
 <cd5df8e0-03d1-8f22-0367-eb7c76bc70e7@opensource.wdc.com>
 <5db88114-559b-970a-0437-9acdacb47f8b@suse.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <5db88114-559b-970a-0437-9acdacb47f8b@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.195.32.169]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/10/2022 08:51, Hannes Reinecke wrote:
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> #jpg: Set tag_set->queue_depth = shost->can_queue, and not
>>> = shost->can_queue + shost->nr_reserved_cmds;
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   drivers/scsi/hosts.c     |  3 +++
>>>   drivers/scsi/scsi_lib.c  |  2 ++
>>>   include/scsi/scsi_host.h | 15 ++++++++++++++-
>>>   3 files changed, 19 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index 12346e2297fd..db89afc37bc9 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -489,6 +489,9 @@ struct Scsi_Host *scsi_host_alloc(struct 
>>> scsi_host_template *sht, int privsize)
>>>       if (sht->virt_boundary_mask)
>>>           shost->virt_boundary_mask = sht->virt_boundary_mask;
>>> +    if (sht->nr_reserved_cmds)
>>> +        shost->nr_reserved_cmds = sht->nr_reserved_cmds;
>>> +
>>
>> Nit: the if is not really necessary I think. But it does not hurt.
>>
> Yes, we do.
> Not all HBAs are able to figure out the number of reserved commands 
> upfront; some modify that based on the PCI device used etc.
> So I'd keep it for now.

I think logically Damien is right as in the shost alloc 
shost->nr_reserved_cmds is initially zero, so:

if (sht->nr_reserved_cmds)
        shost->nr_reserved_cmds = sht->nr_reserved_cmds;

is same as simply:

	shost->nr_reserved_cmds = sht->nr_reserved_cmds;

However I am just copying the coding style.

Thanks,
John
