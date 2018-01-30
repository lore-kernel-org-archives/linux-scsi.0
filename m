From: John Garry <john.garry@huawei.com>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Tue, 30 Jan 2018 10:33:20 +0000
Message-ID: <f2cf73ae-d645-6a04-5190-3d0cc91c4581@huawei.com>
References: <20180129154455.GB17176@ming.t460p>
 <1517259390.3969.41.camel@HansenPartnership.com>
 <20180130012408.GD17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180130012408.GD17176@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 30/01/2018 01:24, Ming Lei wrote:
> On Mon, Jan 29, 2018 at 12:56:30PM -0800, James Bottomley wrote:
>> On Mon, 2018-01-29 at 23:46 +0800, Ming Lei wrote:
>> [...]
>>> 2. When to enable SCSI_MQ at default again?
>>
>> I'm not sure there's much to discuss ... I think the basic answer is as
>> soon as Christoph wants to try it again.
>
> I guess Christoph still need to evaluate if there are existed issues or
> blockers before trying it again. And more input may be got from F2F
> discussion, IMHO.
>
>>
>>> SCSI_MQ is enabled on V3.17 firstly, but disabled at default. In
>>> V4.13-rc1, it is enabled at default, but later the patch is reverted
>>> in V4.13-rc7, and becomes disabled at default too.
>>>
>>> Now both the original reported PM issue(actually SCSI quiesce) and
>>> the sequential IO performance issue have been addressed.
>>
>> Is the blocker bug just not closed because no-one thought to do it:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=178381
>>
>> (we have confirmed that this issue is now fixed with the original
>> reporter?)
>
>>From a developer view, this issue is fixed by the following commit:
> 3a0a52997(block, scsi: Make SCSI quiesce and resume work reliably),
> and it is verified by kernel list reporter.
>
>>
>> And did the Huawei guy (Jonathan Cameron) confirm his performance issue
>> was fixed (I don't think I saw email that he did)?
>
> Last time I talked with John Garry about the issue, and the merged .get_budget
> based patch improves much on the IO performance, but there is still a bit gap
> compared with legacy path. Seems a driver specific issue, remembered that removing
> a driver's lock can improve performance much.
>
> Garry, could you provide further update on this issue?

Hi Ming,

 From our testing with experimental changes to our driver to support 
SCSI mq we were almost getting on par performance with legacy path. But 
without these MQ was hitting performance (and I would not necessarily 
say it was a driver issue).

We can retest from today's mainline and see where we are.

BTW, Have you got performance figures for many other single queue HBAs 
with and without CONFIG_SCSI_MQ_DEFAULT=Y?

Thanks,
John

>
> Thanks,
> Ming
>
> .
>
