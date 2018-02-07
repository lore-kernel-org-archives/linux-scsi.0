From: John Garry <john.garry@huawei.com>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Wed, 7 Feb 2018 10:55:03 +0000
Message-ID: <712f97fe-633a-3e4c-8ae0-c8c1bbbb16c6@huawei.com>
References: <20180129154455.GB17176@ming.t460p>
 <1517259390.3969.41.camel@HansenPartnership.com>
 <20180130012408.GD17176@ming.t460p>
 <f2cf73ae-d645-6a04-5190-3d0cc91c4581@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:34391 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753478AbeBGKz1 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 05:55:27 -0500
In-Reply-To: <f2cf73ae-d645-6a04-5190-3d0cc91c4581@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-block@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org, Linux-scsi@vger.kernel.org, Linuxarm <linuxarm@huawei.com>

On 30/01/2018 10:33, John Garry wrote:
> On 30/01/2018 01:24, Ming Lei wrote:
>> On Mon, Jan 29, 2018 at 12:56:30PM -0800, James Bottomley wrote:
>>> On Mon, 2018-01-29 at 23:46 +0800, Ming Lei wrote:
>>> [...]
>>>> 2. When to enable SCSI_MQ at default again?
>>>
>>> I'm not sure there's much to discuss ... I think the basic answer is as
>>> soon as Christoph wants to try it again.
>>
>> I guess Christoph still need to evaluate if there are existed issues or
>> blockers before trying it again. And more input may be got from F2F
>> discussion, IMHO.
>>
>>>
>>>> SCSI_MQ is enabled on V3.17 firstly, but disabled at default. In
>>>> V4.13-rc1, it is enabled at default, but later the patch is reverted
>>>> in V4.13-rc7, and becomes disabled at default too.
>>>>
>>>> Now both the original reported PM issue(actually SCSI quiesce) and
>>>> the sequential IO performance issue have been addressed.
>>>
>>> Is the blocker bug just not closed because no-one thought to do it:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=178381
>>>
>>> (we have confirmed that this issue is now fixed with the original
>>> reporter?)
>>
>>> From a developer view, this issue is fixed by the following commit:
>> 3a0a52997(block, scsi: Make SCSI quiesce and resume work reliably),
>> and it is verified by kernel list reporter.
>>
>>>
>>> And did the Huawei guy (Jonathan Cameron) confirm his performance issue
>>> was fixed (I don't think I saw email that he did)?
>>
>> Last time I talked with John Garry about the issue, and the merged
>> .get_budget
>> based patch improves much on the IO performance, but there is still a
>> bit gap
>> compared with legacy path. Seems a driver specific issue, remembered
>> that removing
>> a driver's lock can improve performance much.
>>
>> Garry, could you provide further update on this issue?
>
> Hi Ming,
>
> From our testing with experimental changes to our driver to support SCSI
> mq we were almost getting on par performance with legacy path. But
> without these MQ was hitting performance (and I would not necessarily
> say it was a driver issue).
>
> We can retest from today's mainline and see where we are.
>
> BTW, Have you got performance figures for many other single queue HBAs
> with and without CONFIG_SCSI_MQ_DEFAULT=Y?

We finally got around to retesting this (on hisi_sas controller). So the 
results are generally ok, in that we are now not seeing such big 
performance drops in our hardware for enabling SCSI MQ - in some 
scenarios the performance is better. Generally fio rw mode is better.

Anyway, for what it's worth, it's a green light from us to set SCSI MQ 
on by default.

John

>
> Thanks,
> John
>
>>
>> Thanks,
>> Ming
>>
>> .
>>
>
>
> _______________________________________________
> Linuxarm mailing list
> Linuxarm@huawei.com
> http://hulk.huawei.com/mailman/listinfo/linuxarm
>
> .
>
