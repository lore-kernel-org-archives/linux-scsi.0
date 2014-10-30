From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Thu, 30 Oct 2014 16:19:36 +0200
Message-ID: <545248F8.8020102@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40619 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaJ3OTk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 10:19:40 -0400
Received: by mail-wi0-f173.google.com with SMTP id n3so4674806wiv.6
        for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 07:19:39 -0700 (PDT)
In-Reply-To: <5450C6FC.90908@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/29/2014 12:52 PM, Bart Van Assche wrote:
> On 10/28/14 19:32, Sagi Grimberg wrote:
>> On 10/21/2014 12:10 PM, Sagi Grimberg wrote:
>>> On 10/20/2014 3:56 PM, Bart Van Assche wrote:
>>>> On 10/19/14 19:36, Sagi Grimberg wrote:
>>>>> On 10/7/2014 4:07 PM, Bart Van Assche wrote:
>>>>>>           * comp_vector, a number in the range 0..n-1 specifying the
>>>>>> -          MSI-X completion vector. Some HCA's allocate multiple (n)
>>>>>> -          MSI-X vectors per HCA port. If the IRQ affinity masks of
>>>>>> -          these interrupts have been configured such that each MSI-X
>>>>>> -          interrupt is handled by a different CPU then the
>>>>>> comp_vector
>>>>>> -          parameter can be used to spread the SRP completion
>>>>>> workload
>>>>>> -          over multiple CPU's.
>>>>>> +          MSI-X completion vector of the first RDMA channel. Some
>>>>>> +          HCA's allocate multiple (n) MSI-X vectors per HCA port. If
>>>>>> +          the IRQ affinity masks of these interrupts have been
>>>>>> +          configured such that each MSI-X interrupt is handled by a
>>>>>> +          different CPU then the comp_vector parameter can be
>>>>>> used to
>>>>>> +          spread the SRP completion workload over multiple CPU's.
>>>>>
>>>>> This is fairly not trivial for the user...
>>>>>
>>>>> Aren't we requesting a bit too much awareness here?
>>>>> Can't we just "make it work"? The user hands out ch_count - why can't
>>>>> you do some least-used logic here?
>>>>>
>>>>> Maybe we can even go with per-cpu QPs and discard comp_vector
>>>>> argument?
>>>>> this would probably bring the best performance, wouldn't it?
>>>>> (fallback to least-used logic in case HW support less vectors)
>>>>
>>>> The only reason the comp_vector parameter is still supported is because
>>>> of backwards compatibility. What I expect is that users will set the
>>>> ch_count parameter but not the comp_vector parameter.
>>
>> Another wander I have with this. Say you have 8 cores on a single numa
>> node. First connection will attach to vectors 0-3 (ch_count=4) and so
>> are all the connections. Don't we want to spread that a little?
>>
>> If we are not going per-cpu, why aren't we trying to spread vectors
>> around to try and reduce the interference?
>
> Hello Sagi,
>
> Sorry but your question is not entirely clear to me. Are you referring
> to spreading the workload over CPU's or over completion vectors ?

I'm talking about completion vectors, but I assume both as I consider
spreading interrupt vectors across CPU cores a common practice.

> If a
> user wants to spread the completion workload maximally by using all
> completion vectors that can be achieved by setting ch_count to a value
> that is equal to or larger than the number of completion vectors.
>

I'm talking about the default.
My impression here that in the default settings, on a 1 NUMA node with
8 cores, 2 different srp connections (using 4 channels each) will be
associated with comp vectors 0-3. while it could potentially use
vectors 4-7 and reduce possible mutual interference. right?
(you said yourself that the user is not expected to use comp_vector
and it is only for backward compatibility).

Now given that each connection uses less than per-cpu channels, don't
you think this logic will be helpful?

> As mentioned in the commit message, spreading the completion workload
> over CPU's is not entirely under control of the SRP initiator driver.

I was referring to comp vectors - but I consider 1x1 mapping a common
usage when it comes to RDMA (and not only btw).

Feel free to correct me if I misunderstand the implementation.

Sagi.
