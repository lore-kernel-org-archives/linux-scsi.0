Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0440EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 16:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFD6F613D2
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 16:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346685AbhDFQ4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 12:56:47 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2772 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244303AbhDFQ4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 12:56:46 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FFD2j4tTVz6824f;
        Wed,  7 Apr 2021 00:47:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 18:56:37 +0200
Received: from [10.210.166.136] (10.210.166.136) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 17:56:35 +0100
Subject: Re: [PATCH 1/6] iommu: Move IOVA power-of-2 roundup into allocator
To:     Robin Murphy <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-2-git-send-email-john.garry@huawei.com>
 <ee935a6d-a94c-313e-f0ed-e14cc6dac055@arm.com>
 <73d459de-b5cc-e2f5-bcd7-2ee23c8d5075@huawei.com>
 <afc2fc05-a799-cb14-debd-d36afed8f456@arm.com>
 <08c0f4b9-8713-fa97-3986-3cfb0d6b820b@huawei.com>
 <e4b9146a-ca32-50f5-4fe0-42aa0b66d2d6@arm.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4914d134-5a63-f683-b14b-25ab71a57cd4@huawei.com>
Date:   Tue, 6 Apr 2021 17:54:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e4b9146a-ca32-50f5-4fe0-42aa0b66d2d6@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.166.136]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>> So then we have the issue of how to dynamically increase this rcache
>>>> threshold. The problem is that we may have many devices associated with
>>>> the same domain. So, in theory, we can't assume that when we increase
>>>> the threshold that some other device will try to fast free an IOVA 
>>>> which
>>>> was allocated prior to the increase and was not rounded up.
>>>>
>>>> I'm very open to better (or less bad) suggestions on how to do this ...
>>> ...but yes, regardless of exactly where it happens, rounding up or not
>>> is the problem for rcaches in general. I've said several times that my
>>> preferred approach is to not change it that dynamically at all, but
>>> instead treat it more like we treat the default domain type.
>>>
>>
>> Can you remind me of that idea? I don't remember you mentioning using 
>> default domain handling as a reference in any context.
> 

Hi Robin,

> Sorry if the phrasing was unclear there - the allusion to default 
> domains is new, it just occurred to me that what we do there is in fact 
> fairly close to what I've suggested previously for this. In that case, 
> we have a global policy set by the command line, which *can* be 
> overridden per-domain via sysfs at runtime, provided the user is willing 
> to tear the whole thing down. Using a similar approach here would give a 
> fair degree of flexibility but still mean that changes never have to be 
> made dynamically to a live domain.

So are you saying that we can handle it similar to how we now can handle 
changing default domain for an IOMMU group via sysfs? If so, that just 
is not practical here. Reason being that this particular DMA engine 
provides the block device giving / mount point, so if we unbind the 
driver, we lose / mount point.

And I am not sure if the end user would even know how to set such a 
tunable. Or, in this case, why the end user would not want the optimized 
range configured always.

I'd still rather if the device driver could provide info which can be 
used to configure this before or during probing.

Cheers,
John
