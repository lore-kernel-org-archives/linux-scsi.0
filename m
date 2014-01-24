From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [LSF/MM ATTEND] interest in blk-mq, scsi-mq, dm-cache, dm-thinp,
 dm-*
Date: Fri, 24 Jan 2014 14:19:52 -0600
Message-ID: <52E2CAE8.4070006@cs.wisc.edu>
References: <20140110182714.GA11731@redhat.com> <52D3CFB2.4010207@suse.de> <52E1D1FA.8000703@cs.wisc.edu> <52E21252.6000701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34172 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaAXUUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 15:20:05 -0500
In-Reply-To: <52E21252.6000701@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/24/2014 01:12 AM, Hannes Reinecke wrote:
> On 01/24/2014 03:37 AM, Mike Christie wrote:
>> On 01/13/2014 05:36 AM, Hannes Reinecke wrote:
>>> On 01/10/2014 07:27 PM, Mike Snitzer wrote:
>>>> I would like to attend to participate in discussions related to topics
>>>> listed in the subject.  As a maintainer of DM I'd be interested to
>>>> learn/discuss areas that should become a development focus in the months
>>>> following LSF.
>>>>
>>> +1
>>>
>>> I've been thinking on (re-) implementing multipathing on top of
>>> blk-mq, and would like to discuss the probability of which.
>>> There are some design decisions in blk-mq (eg statically allocating
>>> the number of queues) which do not play well with that.
>>>
>>
>> I think I have been thinking about going a completely different direction.
>>
>> The thing about dm-multipath is that request based adds the extra queue
>> locking and that of course is bad. In our testing it is a major perf
>> issue. We got things like ioscheduling though.
>>
> Indeed. And without that we cannot do true load-balancing.

I think I might be using some terms differently. You do not need
ioscheduling like deadline and cfq for path load balancing in multipath
do you? Do you mean IO merging?

With noop load balancing works as expected.

> 
>> If we went back to bio based multipathing then it turns out that when
>> scsi also supports multiqueue then it all works pretty nicely. There is
>> room for improvement in general like with some dm allocations being
>> numa/cpu aware, but the request_queue locking issues we have go away and
>> it is very simple code wise.
>>
> If and when.
> 
> The main issue I see with that is that it might take some time (if
> ever) for SCSI LLDDs to go fully multiqueue.
> In fact, I strongly suspect that only newer LLDDs will ever support
> multiqueue; for the older cards the HW interface it too much tied
> to single queue operations.

Maybe we are talking about different things. We will do software/partial
blk/scsi mq support soon and dm-multipath is not compatible with
underlying devices that do multiqueue as it is now. I am just saying
that dm cannot do its current bio/request cloning and then call
blk_insert_cloned_request on a request when the underlying device does
even the partial/software multiqueue that people are making patches for
scsi for.

We can hack in support like I mentioned or we can do a bigger change
like yours or we can do bio based or something else. The point is that
something will need to be done and it is not dependent on hw multiqueue
support.

However, on that subject of hw multiqueue support, Bart is experimenting
with some tricks for SRP so it is not that far off. That is why he keeps
asking about hw mutiqueue support for scsi.

> 
>> We could go the route of making request based dm-multipath:
>>
>> 1. aware of underlying multiqueue devices. So just basically keep what
>> we have more or less but then have dm-multipath make a request that can
>> be sent to a multiqueue device then call blk_mq_insert_request. This
>> would all be hidden by nice interfaces that hide if it is multiqueue
>> underlying device or not.
>>
>> 2. make dm-multipath do multiqueue (so implement map_queue, queue_rq,
>> etc) and also making it aware of underlying multiqueue devices.
>>
>> #1 just keeps the existing request spin_lock problem so there is not
>> much point other than just getting things working.
>>
>> #2 is a good deal of work and what does it end up buying us over just
>> making multipath bio based. We lose iosched support. If we are going to
>> make advanced multiqueue ioschedulers that rely on request structs then
>> #2 could be useful.
>>
> 
> Obviously we need iosched support when going multiqueue.
> I wouldn't dream of dropping them.

I was just saying that blk-mq already dropped support for advanced
ioscheds like deadline and cfq. It basically only does noop where there
is a list/fifo.

> 
> So my overall idea here is to move multipath over to block-mq,
> making each path identical to one queue.

There are too many queues now :) Do you mean request_queue or
blk_mq_hw_ctx or blk_mq_ctx?


> (As mentioned above, currently every single FC HBA exposes a single
> HW queue anyway)
> The ioschedulers would be moved to the map_queue function.
> 

Are you maybe talking about path selectors here? map_queue would be too
early for ioscheduling like deadline/cfq or you would need more
callouts. Depending on how you are implementing blk multipath multiqueue
I think map_queue could be good for path selection.


> This approach has several issues which I would like to discuss:

Hey, yeah, maybe best to discuss at LSF.

