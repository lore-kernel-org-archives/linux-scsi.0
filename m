Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DDAC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 10:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B4B61952
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 10:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbhCaKyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 06:54:03 -0400
Received: from foss.arm.com ([217.140.110.172]:38120 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234862AbhCaKxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 06:53:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84B5111B3;
        Wed, 31 Mar 2021 03:53:41 -0700 (PDT)
Received: from [10.57.24.208] (unknown [10.57.24.208])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B32EC3F719;
        Wed, 31 Mar 2021 03:53:39 -0700 (PDT)
Subject: Re: [PATCH 3/6] iova: Allow rcache range upper limit to be
 configurable
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-4-git-send-email-john.garry@huawei.com>
 <26fb1b79-2e46-09f6-1814-48fec4205f32@arm.com>
 <3375b67f-438c-32d3-a5a6-7e08f37b04e3@huawei.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <e2d873d9-3529-caff-d4ae-cca456857ff1@arm.com>
Date:   Wed, 31 Mar 2021 11:53:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <3375b67f-438c-32d3-a5a6-7e08f37b04e3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-19 17:26, John Garry wrote:
[...]
>>> @@ -25,7 +25,8 @@ struct iova {
>>>   struct iova_magazine;
>>>   struct iova_cpu_rcache;
>>> -#define IOVA_RANGE_CACHE_MAX_SIZE 6    /* log of max cached IOVA 
>>> range size (in pages) */
>>> +#define IOVA_RANGE_CACHE_DEFAULT_SIZE 6
>>> +#define IOVA_RANGE_CACHE_MAX_SIZE 10 /* log of max cached IOVA range 
>>> size (in pages) */
>>
>> No.
>>
>> And why? If we're going to allocate massive caches anyway, whatever is 
>> the point of *not* using all of them?
>>
> 
> I wanted to keep the same effective threshold for devices today, unless 
> set otherwise.
> 
> The reason is that I didn't know if a blanket increase would cause 
> regressions, and I was taking the super-safe road. Specifically some 
> systems may be very IOVA space limited, and just work today by not 
> caching large IOVAs.

alloc_iova_fast() will already clear out the caches if space is running 
low, so the caching itself shouldn't be an issue.

> And in the precursor thread you wrote "We can't arbitrarily *increase* 
> the scope of caching once a domain is active due to the size-rounding-up 
> requirement, which would be prohibitive to larger allocations if applied 
> universally" (sorry for quoting)
> 
> I took the last part to mean that we shouldn't apply this increase in 
> threshold globally.

I meant we can't increase the caching threshold as-is once the domain is 
in use, because that could result in odd-sized IOVAs previously 
allocated above the old threshold being later freed back into caches, 
then causing havoc the next time they get allocated (because they're not 
as big as the actual size being asked for). However, trying to address 
that by just size-aligning everything even above the caching threshold 
is liable to waste too much space on IOVA-constrained systems (e.g. a 
single 4K video frame may be ~35MB - rounding that up to 64MB each time 
would be hard to justify).

It follows from that that there's really no point in decoupling the 
rounding-up threshold from the actual caching threshold - you get all 
the wastage (both IOVA space and actual memory for the cache arrays) for 
no obvious benefit.

>> It only makes sense for a configuration knob to affect the actual 
>> rcache and depot allocations - that way, big high-throughput systems 
>> with plenty of memory can spend it on better performance, while small 
>> systems - that often need IOMMU scatter-gather precisely *because* 
>> memory is tight and thus easily fragmented - don't have to pay the 
>> (not insignificant) cost for caches they don't need.
> 
> So do you suggest to just make IOVA_RANGE_CACHE_MAX_SIZE a kconfig option?

Again, I'm less convinced by Kconfig since I imagine many people tuning 
server-class systems for their own particular workloads will be running 
standard enterprise distros, so I think end-user-accessible knobs will 
be the most valuable. That's not to say that a Kconfig option to set the 
default state of a command-line option (as we do elsewhere) won't be 
useful for embedded users, cloud providers, etc., just that I'm not sure 
it's worth it being the *only* option.

Robin.
