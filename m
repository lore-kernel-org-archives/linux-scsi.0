Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF6CC76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 09:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjDCJLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 05:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjDCJLY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 05:11:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBD27EC0
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 02:11:20 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PqlQv2DjYzSkdl;
        Mon,  3 Apr 2023 17:07:35 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 3 Apr 2023 17:11:17 +0800
Subject: Re: [PATCH 1/3] scsi: libsas: Simplify sas_check_eeds()
To:     John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>
References: <20230401081526.1655279-1-yanaijie@huawei.com>
 <20230401081526.1655279-2-yanaijie@huawei.com>
 <739e2d17-f1c6-fc33-adc4-41cb97b5950d@opensource.wdc.com>
 <e9729d4e-e6d1-7bf6-25a6-5de92214b019@huawei.com>
 <7481900b-9139-fa1b-3fdd-4fdb9891bf7f@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <0184c5f2-6f0c-451d-e04b-727be45f8626@huawei.com>
Date:   Mon, 3 Apr 2023 17:11:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7481900b-9139-fa1b-3fdd-4fdb9891bf7f@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/4/3 16:12, John Garry wrote:
> On 03/04/2023 02:37, Jason Yan wrote:
>>>>
>>>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>>>> b/drivers/scsi/libsas/sas_expander.c
>>>> index dc670304f181..048a931d856a 100644
>>>> --- a/drivers/scsi/libsas/sas_expander.c
>>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>>> @@ -1198,37 +1198,35 @@ static void 
>>>> sas_print_parent_topology_bug(struct domain_device *child,
>>>>             sas_route_char(child, child_phy));
>>>>   }
>>>> +static bool sas_eeds_valid(struct domain_device *parent, struct 
>>>> domain_device *child)
>>>> +{
>>>> +    struct sas_discovery *disc = &parent->port->disc;
>>>
>>> Missing blank line after declaration.
>>
>> OK.
>>
>>>
>>>> +    return (((SAS_ADDR(disc->eeds_a) == SAS_ADDR(parent->sas_addr)) ||
>>>> +         (SAS_ADDR(disc->eeds_a) == SAS_ADDR(child->sas_addr))) &&
>>>> +        ((SAS_ADDR(disc->eeds_b) == SAS_ADDR(parent->sas_addr)) ||
>>>> +         (SAS_ADDR(disc->eeds_b) == SAS_ADDR(child->sas_addr))));
>>>
>>> Drop the inner-most and outter-most parenthesis.
>>
>> No problem.
> 
> Personally I think that the flow:
> 
> if (SAS_ADDR(disc->eeds_a) == SAS_ADDR(parent->sas_addr))
>      return true;
> if (...)
>      return true;
> if (...)
>      return true;
> return false;
> 
> ..reads a bit better (than this and the current code). However I don't 
> feel too strongly about it.

If there is only "||", we can do that. But there is a "&&" so it's not 
that simple now.

Thanks,
Jason

> 
> Thanks,
> John
> .
