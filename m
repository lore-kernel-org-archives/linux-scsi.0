From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [BUG] Slab corruption during XFS writeback under memory pressure
Date: Tue, 19 Jul 2016 14:22:47 -0700
Message-ID: <53af895c-7ddb-1e50-6c90-d4d59f5c7a2f@fb.com>
References: <28f77d74-5ab4-d913-2921-df90da53f393@fb.com>
 <20160717000003.GW1922@dastard> <20160718060215.GB16044@dastard>
 <24d2f83f-5281-ab3c-9e91-985a4b8e2f8b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50538 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbcGSVXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 17:23:15 -0400
In-Reply-To: <24d2f83f-5281-ab3c-9e91-985a4b8e2f8b@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, xfs@oss.sgi.com

On 07/18/2016 07:05 PM, Calvin Owens wrote:
> On 07/17/2016 11:02 PM, Dave Chinner wrote:
>> On Sun, Jul 17, 2016 at 10:00:03AM +1000, Dave Chinner wrote:
>>> On Fri, Jul 15, 2016 at 05:18:02PM -0700, Calvin Owens wrote:
>>>> Hello all,
>>>>
>>>> I've found a nasty source of slab corruption. Based on seeing similar symptoms
>>>> on boxes at Facebook, I suspect it's been around since at least 3.10.
>>>>
>>>> It only reproduces under memory pressure so far as I can tell: the issue seems
>>>> to be that XFS reclaims pages from buffers that are still in use by
>>>> scsi/block. I'm not sure which side the bug lies on, but I've only observed it
>>>> with XFS.
>> [....]
>>> But this indicates that the page is under writeback at this point,
>>> so that tends to indicate that the above freeing was incorrect.
>>>
>>> Hmmm - it's clear we've got direct reclaim involved here, and the
>>> suspicion of a dirty page that has had it's bufferheads cleared.
>>> Are there any other warnings in the log from XFS prior to kasan
>>> throwing the error?
>>
>> Can you try the patch below?
>
> Thanks for getting this out so quickly :)
>
> So far so good: I booted Linus' tree as of this morning and reproduced the ASAN
> splat. After applying your patch I haven't triggered it.
>
> I'm a bit wary since it was hard to trigger reliably in the first place... so I
> lined up a few dozen boxes to run the test case overnight. I'll confirm in the
> morning (-0700) they look good.

All right, my testcase ran 2099 times overnight without triggering anything.

For the overnight tests, I booted the boxes with "mem=" to artificially limit RAM,
which makes my repro *much* more reliable (I feel silly for not thinking of that
in the first place). With that setup, I hit the ASAN splat 21 times in 98 runs on
vanilla 4.7-rc7. So I'm sold.

Tested-by: Calvin Owens <calvinowens@fb.com>

Again, really appreciate the quick response :)

Thanks,
Calvin

> Thanks,
> Calvin
>
>> -Dave.

