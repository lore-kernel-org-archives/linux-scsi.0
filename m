From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 15:45:38 +0200
Message-ID: <54AE8A02.1030100@dev.mellanox.co.il>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54AE36CE.8020509@acm.org>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 1/8/2015 9:50 AM, Bart Van Assche wrote:
> On 01/07/15 22:39, Mike Christie wrote:
>> On 01/07/2015 10:57 AM, Hannes Reinecke wrote:
>>> On 01/07/2015 05:25 PM, Sagi Grimberg wrote:
>>>> Hi everyone,
>>>>
>>>> Now that scsi-mq is fully included, we need an iSCSI initiator that
>>>> would use it to achieve scalable performance. The need is even greater
>>>> for iSCSI offload devices and transports that support multiple HW
>>>> queues. As iSER maintainer I'd like to discuss the way we would choose
>>>> to implement that in iSCSI.
>>>>
>>>> My measurements show that iSER initiator can scale up to ~2.1M IOPs
>>>> with multiple sessions but only ~630K IOPs with a single session where
>>>> the most significant bottleneck the (single) core processing
>>>> completions.
>>>>
>>>> In the existing single connection per session model, given that command
>>>> ordering must be preserved session-wide, we end up in a serial command
>>>> execution over a single connection which is basically a single queue
>>>> model. The best fit seems to be plugging iSCSI MCS as a multi-queued
>>>> scsi LLDD. In this model, a hardware context will have a 1x1 mapping
>>>> with an iSCSI connection (TCP socket or a HW queue).
>>>>
>>>> iSCSI MCS and it's role in the presence of dm-multipath layer was
>>>> discussed several times in the past decade(s). The basic need for
>>>> MCS is
>>>> implementing a multi-queue data path, so perhaps we may want to avoid
>>>> doing any type link aggregation or load balancing to not overlap
>>>> dm-multipath. For example we can implement ERL=0 (which is basically
>>>> the
>>>> scsi-mq ERL) and/or restrict a session to a single portal.
>>>>
>>>> As I see it, the todo's are:
>>>> 1. Getting MCS to work (kernel + user-space) with ERL=0 and a
>>>>     round-robin connection selection (per scsi command execution).
>>>> 2. Plug into scsi-mq - exposing num_connections as nr_hw_queues and
>>>>     using blk-mq based queue (conn) selection.
>>>> 3. Rework iSCSI core locking scheme to avoid session-wide locking
>>>>     as much as possible.
>>>> 4. Use blk-mq pre-allocation and tagging facilities.
>>>>
>>>> I've recently started looking into this. I would like the community to
>>>> agree (or debate) on this scheme and also talk about implementation
>>>> with anyone who is also interested in this.
>>>>
>>> Yes, that's a really good topic.
>>>
>>> I've pondered implementing MC/S for iscsi/TCP but then I've figured my
>>> network implementation knowledge doesn't spread that far.
>>> So yeah, a discussion here would be good.
>>>
>>> Mike? Any comments?
>>
>> I have been working under the assumption that people would be ok with
>> MCS upstream if we are only using it to handle the issue where we want
>> to do something like have a tcp/iscsi connection per CPU then map the
>> connection to a blk_mq_hw_ctx. In this more limited MCS implementation
>> there would be no iscsi layer code to do something like load balance
>> across ports or transport paths like how dm-multipath does, so there
>> would be no feature/code duplication. For balancing across hctxs, then
>> the iscsi layer would also leave that up to whatever we end up with in
>> upper layers, so again no feature/code duplication with upper layers.
>>
>> So pretty non controversial I hope :)
>>
>> If people want to add something like round robin connection selection in
>> the iscsi layer, then I think we want to leave that for after the
>> initial merge, so people can argue about that separately.
>
> Hello Sagi and Mike,
>
> I agree with Sagi that adding scsi-mq support in the iSER initiator
> would help iSER users because that would allow these users to configure
> a single iSER target and use the multiqueue feature instead of having to
> configure multiple iSER targets to spread the workload over multiple
> cpus at the target side.

Hey Bart,

IMHO, iSER is an iSCSI extension, so I think the discussion should
focus the solving this in iSCSI level in a way that would apply both
for TCP and RDMA (and offload devices).

>
> And I agree with Mike that implementing scsi-mq support in the iSER
> initiator as multiple independent connections probably is a better
> choice than MC/S.

Actually I started with that approach, but the independent connections
under a single session (I-T-Nexus) violates the command ordering 
requirement. Plus, such a solution is specific to iSER...

> RFC 3720 namely requires that iSCSI numbering is
> session-wide. This means maintaining a single counter for all MC/S
> sessions. Such a counter would be a contention point. I'm afraid that
> because of that counter performance on a multi-socket initiator system
> with a scsi-mq implementation based on MC/S could be worse than with the
> approach with multiple iSER targets. Hence my preference for an approach
> based on multiple independent iSER connections instead of MC/S.

So this comment is spot on the pros/cons of the discussion (we might 
want to leave something for LSF ;)).
MCS would not allow a completely lockless data-path due to command
ordering. On the other hand implementing some kind of multiple sessions
solution feels somewhat like a mis-fit (at least in my view).

One of my thoughts about how to overcome the contention on commands
sequence numbering was to suggest some kind of negotiable "relaxed
ordering" mode but of course I don't have anything figured out yet.

I had a short discussion on this with Mallikarjun Chadalapaka at SDC-14.
He said that if I show some numbers to back up such a proposal it can
be considered.

Sagi.
