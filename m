From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Wed, 16 May 2012 09:04:58 -0400
Message-ID: <x49r4uke0p1.fsf@segfault.boston.devel.redhat.com>
References: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
	<1337071697-30920-4-git-send-email-ming.m.lin@intel.com>
	<x49mx59b6c0.fsf@segfault.boston.devel.redhat.com>
	<1337131643.22243.2.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337131643.22243.2.camel@minggr> (Lin Ming's message of "Wed, 16
	May 2012 09:27:23 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Lin Ming <ming.m.lin@intel.com> writes:

> On Tue, 2012-05-15 at 15:19 -0400, Jeff Moyer wrote:
>> Lin Ming <ming.m.lin@intel.com> writes:
>> 
>> > Add an idle timer that is set to some suitable timeout and would be
>> > added when the queue first goes empty. If nothing has happened during
>> > the timeout interval, then the queue is suspended.
>> >
>> > Queueing a new request could check the state and resume queue if it is
>> > supended.
>> >
>> 
>> [snip]
>> 
>> > @@ -1129,6 +1141,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>> >  	if (unlikely(--req->ref_count))
>> >  		return;
>> >  
>> > +	/* PM request is not accounted */
>> > +	if (!(req->cmd_flags & REQ_PM)) {
>> > +		if (!(--q->nr_pending))
>> > +			/* Hard code to 20secs, will move to sysfs */
>> > +			mod_timer(&q->idle, jiffies + 20*HZ);
>> > +	}
>> > +
>> 
>> I'm pretty sure Jens wanted to avoid doing a mod_timer, here, given that
>> the queue can transition between empty and non-empty fairly rapidly for
>> dependent I/O.
>
> I'll remove this idle timer and use runtime pm core's timer.

This issues isn't which timer to use, it's when to modify it.  Since the
queue can cycle between empty and non-empty very quickly, you should try
to avoid calling mod_timer for every non-empty to empty transition.
Jens had described one way to do this in the thread you referenced in
your 0/3 email.

Cheers,
Jeff
