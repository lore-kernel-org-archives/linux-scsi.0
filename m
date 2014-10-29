From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Wed, 29 Oct 2014 11:52:44 +0100
Message-ID: <5450C6FC.90908@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544FE13A.60807-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/28/14 19:32, Sagi Grimberg wrote:
> On 10/21/2014 12:10 PM, Sagi Grimberg wrote:
>> On 10/20/2014 3:56 PM, Bart Van Assche wrote:
>>> On 10/19/14 19:36, Sagi Grimberg wrote:
>>>> On 10/7/2014 4:07 PM, Bart Van Assche wrote:
>>>>>           * comp_vector, a number in the range 0..n-1 specifying the
>>>>> -          MSI-X completion vector. Some HCA's allocate multiple (n)
>>>>> -          MSI-X vectors per HCA port. If the IRQ affinity masks of
>>>>> -          these interrupts have been configured such that each MSI-X
>>>>> -          interrupt is handled by a different CPU then the
>>>>> comp_vector
>>>>> -          parameter can be used to spread the SRP completion workload
>>>>> -          over multiple CPU's.
>>>>> +          MSI-X completion vector of the first RDMA channel. Some
>>>>> +          HCA's allocate multiple (n) MSI-X vectors per HCA port. If
>>>>> +          the IRQ affinity masks of these interrupts have been
>>>>> +          configured such that each MSI-X interrupt is handled by a
>>>>> +          different CPU then the comp_vector parameter can be used to
>>>>> +          spread the SRP completion workload over multiple CPU's.
>>>>
>>>> This is fairly not trivial for the user...
>>>>
>>>> Aren't we requesting a bit too much awareness here?
>>>> Can't we just "make it work"? The user hands out ch_count - why can't
>>>> you do some least-used logic here?
>>>>
>>>> Maybe we can even go with per-cpu QPs and discard comp_vector argument?
>>>> this would probably bring the best performance, wouldn't it?
>>>> (fallback to least-used logic in case HW support less vectors)
>>>
>>> The only reason the comp_vector parameter is still supported is because
>>> of backwards compatibility. What I expect is that users will set the
>>> ch_count parameter but not the comp_vector parameter.
>
> Another wander I have with this. Say you have 8 cores on a single numa
> node. First connection will attach to vectors 0-3 (ch_count=4) and so
> are all the connections. Don't we want to spread that a little?
>
> If we are not going per-cpu, why aren't we trying to spread vectors
> around to try and reduce the interference?

Hello Sagi,

Sorry but your question is not entirely clear to me. Are you referring 
to spreading the workload over CPU's or over completion vectors ? If a 
user wants to spread the completion workload maximally by using all 
completion vectors that can be achieved by setting ch_count to a value 
that is equal to or larger than the number of completion vectors.

As mentioned in the commit message, spreading the completion workload 
over CPU's is not entirely under control of the SRP initiator driver. It 
is assumed that a user assigns IRQ affinity such that the interrupts 
associated with different completion vectors are processed by different 
CPU threads. If there are more RDMA channels than completion vectors, 
the SRP initiator driver associates RDMA channels with completion 
vectors such that the workload is spread evenly over the completion vectors.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
