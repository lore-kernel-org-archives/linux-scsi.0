From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [LSF/MM ATTEND] interest in blk-mq, scsi-mq, dm-cache, dm-thinp,
 dm-*
Date: Thu, 23 Jan 2014 20:37:46 -0600
Message-ID: <52E1D1FA.8000703@cs.wisc.edu>
References: <20140110182714.GA11731@redhat.com> <52D3CFB2.4010207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60734 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaAXCiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jan 2014 21:38:00 -0500
In-Reply-To: <52D3CFB2.4010207@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/13/2014 05:36 AM, Hannes Reinecke wrote:
> On 01/10/2014 07:27 PM, Mike Snitzer wrote:
>> I would like to attend to participate in discussions related to topics
>> listed in the subject.  As a maintainer of DM I'd be interested to
>> learn/discuss areas that should become a development focus in the months
>> following LSF.
>>
> +1
> 
> I've been thinking on (re-) implementing multipathing on top of
> blk-mq, and would like to discuss the probability of which.
> There are some design decisions in blk-mq (eg statically allocating
> the number of queues) which do not play well with that.
> 

I think I have been thinking about going a completely different direction.

The thing about dm-multipath is that request based adds the extra queue
locking and that of course is bad. In our testing it is a major perf
issue. We got things like ioscheduling though.

If we went back to bio based multipathing then it turns out that when
scsi also supports multiqueue then it all works pretty nicely. There is
room for improvement in general like with some dm allocations being
numa/cpu aware, but the request_queue locking issues we have go away and
it is very simple code wise.

We could go the route of making request based dm-multipath:

1. aware of underlying multiqueue devices. So just basically keep what
we have more or less but then have dm-multipath make a request that can
be sent to a multiqueue device then call blk_mq_insert_request. This
would all be hidden by nice interfaces that hide if it is multiqueue
underlying device or not.

2. make dm-multipath do multiqueue (so implement map_queue, queue_rq,
etc) and also making it aware of underlying multiqueue devices.

#1 just keeps the existing request spin_lock problem so there is not
much point other than just getting things working.

#2 is a good deal of work and what does it end up buying us over just
making multipath bio based. We lose iosched support. If we are going to
make advanced multiqueue ioschedulers that rely on request structs then
#2 could be useful.
