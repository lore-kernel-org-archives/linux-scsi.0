Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F9CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 09:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC1761969
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 09:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhCaJ7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:59:14 -0400
Received: from foss.arm.com ([217.140.110.172]:37006 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhCaJ6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 05:58:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CB561042;
        Wed, 31 Mar 2021 02:58:42 -0700 (PDT)
Received: from [10.57.24.208] (unknown [10.57.24.208])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5A3F3F792;
        Wed, 31 Mar 2021 02:58:40 -0700 (PDT)
Subject: Re: [PATCH 1/6] iommu: Move IOVA power-of-2 roundup into allocator
To:     John Garry <john.garry@huawei.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-2-git-send-email-john.garry@huawei.com>
 <ee935a6d-a94c-313e-f0ed-e14cc6dac055@arm.com>
 <73d459de-b5cc-e2f5-bcd7-2ee23c8d5075@huawei.com>
 <afc2fc05-a799-cb14-debd-d36afed8f456@arm.com>
 <08c0f4b9-8713-fa97-3986-3cfb0d6b820b@huawei.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <e4b9146a-ca32-50f5-4fe0-42aa0b66d2d6@arm.com>
Date:   Wed, 31 Mar 2021 10:58:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <08c0f4b9-8713-fa97-3986-3cfb0d6b820b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-22 15:01, John Garry wrote:
> On 19/03/2021 19:20, Robin Murphy wrote:
> 
> Hi Robin,
> 
>>> So then we have the issue of how to dynamically increase this rcache
>>> threshold. The problem is that we may have many devices associated with
>>> the same domain. So, in theory, we can't assume that when we increase
>>> the threshold that some other device will try to fast free an IOVA which
>>> was allocated prior to the increase and was not rounded up.
>>>
>>> I'm very open to better (or less bad) suggestions on how to do this ...
>> ...but yes, regardless of exactly where it happens, rounding up or not
>> is the problem for rcaches in general. I've said several times that my
>> preferred approach is to not change it that dynamically at all, but
>> instead treat it more like we treat the default domain type.
>>
> 
> Can you remind me of that idea? I don't remember you mentioning using 
> default domain handling as a reference in any context.

Sorry if the phrasing was unclear there - the allusion to default 
domains is new, it just occurred to me that what we do there is in fact 
fairly close to what I've suggested previously for this. In that case, 
we have a global policy set by the command line, which *can* be 
overridden per-domain via sysfs at runtime, provided the user is willing 
to tear the whole thing down. Using a similar approach here would give a 
fair degree of flexibility but still mean that changes never have to be 
made dynamically to a live domain.

Robin.
