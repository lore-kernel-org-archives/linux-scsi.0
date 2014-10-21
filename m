From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Tue, 21 Oct 2014 12:10:22 +0300
Message-ID: <544622FE.5040906@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54450690.709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/20/2014 3:56 PM, Bart Van Assche wrote:
> On 10/19/14 19:36, Sagi Grimberg wrote:
>> On 10/7/2014 4:07 PM, Bart Van Assche wrote:
>>>           * comp_vector, a number in the range 0..n-1 specifying the
>>> -          MSI-X completion vector. Some HCA's allocate multiple (n)
>>> -          MSI-X vectors per HCA port. If the IRQ affinity masks of
>>> -          these interrupts have been configured such that each MSI-X
>>> -          interrupt is handled by a different CPU then the comp_vector
>>> -          parameter can be used to spread the SRP completion workload
>>> -          over multiple CPU's.
>>> +          MSI-X completion vector of the first RDMA channel. Some
>>> +          HCA's allocate multiple (n) MSI-X vectors per HCA port. If
>>> +          the IRQ affinity masks of these interrupts have been
>>> +          configured such that each MSI-X interrupt is handled by a
>>> +          different CPU then the comp_vector parameter can be used to
>>> +          spread the SRP completion workload over multiple CPU's.
>>
>> This is fairly not trivial for the user...
>>
>> Aren't we requesting a bit too much awareness here?
>> Can't we just "make it work"? The user hands out ch_count - why can't
>> you do some least-used logic here?
>>
>> Maybe we can even go with per-cpu QPs and discard comp_vector argument?
>> this would probably bring the best performance, wouldn't it?
>> (fallback to least-used logic in case HW support less vectors)
>
> Hello Sagi,
>
> The only reason the comp_vector parameter is still supported is because
> of backwards compatibility. What I expect is that users will set the
> ch_count parameter but not the comp_vector parameter.

Agreed...

>
> Using one QP per CPU thread does not necessarily result in the best
> performance. In the tests I ran performance was about 4% better when
> using one QP for each pair of CPU threads (with hyperthreading enabled).

I usually don't like using defaults based on empirical experiments on
specific workloads. IMO, going either full blown MQ (per-cpu), or
go SQ for default.

But that is just my opinion...
you call it.

>
>>> +static unsigned ch_count;
>>> +module_param(ch_count, uint, 0444);
>>> +MODULE_PARM_DESC(ch_count,
>>> +         "Number of RDMA channels to use for communication with an
>>> SRP target. Using more than one channel improves performance if the
>>> HCA supports multiple completion vectors. The default value is the
>>> minimum of four times the number of online CPU sockets and the number
>>> of completion vectors supported by the HCA.");
>>
>> Why? how did you get to this magic equation?
>
> On the systems I have access to measurements have shown that this choice
> for the ch_count parameter results in a significant performance
> improvement without consuming too many system resources. The performance
> difference when using more than four channels was small. This means that
> the exact value of this parameter is not that important. What matters to
> me is that users can benefit from improved performance even if the
> ch_count kernel module parameter has been left to its default value.

I do like the idea of giving users high performance out-of-the-box. But
as I wrote below, I less like the idea of basing your choice on
experiments.

Sagi.

>
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
