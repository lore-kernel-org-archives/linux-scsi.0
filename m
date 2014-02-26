From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Proposal for a scalable SCSI midlayer
Date: Wed, 26 Feb 2014 11:12:13 -0600
Message-ID: <1393434733.2274.10.camel@dabdike>
References: <20140205123918.GA15907@infradead.org>
	 <1393186218.9743.3.camel@dabdike> <530DC92C.5070603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51884 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaBZRMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 12:12:17 -0500
In-Reply-To: <530DC92C.5070603@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, 2014-02-26 at 11:59 +0100, Bart Van Assche wrote:
> On 02/23/14 21:10, James Bottomley wrote:
> > Right ... my ideal here if we can achieve it would be lockless threaded
> > models, where we could make guarantees like single thread of execution
> > per command, so all command state could be lockless.
> 
> This approach sounds interesting but could be challenging to implement.
> With this approach it would no longer be safe to access the SCSI command
> state from interrupt nor from tasklet context.

I don't think so: a SCSI command has to be in a distinct state, either
preparing, dispatching (at HBA) or returning (or a variety of states in
between).  It can't be in more than one state, so we can still guarantee
the per command variables can be accessed locklessly from any context
because if more than one CPU is operating on it simultaneously, we just
broke the state machine.

The challenge comes from the device variables:  a device can have a
bunch of commands in various states.  However, if we can guarantee
single CPU dispatch per device queue, then we could also use lockless
plus sloppy counters on the device variables because the CPU can only be
in a single state per queue even if multiple commands in the queue are
in different states.  The times we need to see the per-queue state
rolled up are fairly well defined, so we can shift the expense of the
rollup operation to the aggregation phase, hence sloppy counters.


James


>  That means that the I/O
> completion path would have to be modified such that instead of using an
> IPI to invoke a tasklet at the CPU that submitted the SCSI command a new
> mechanism would have to be used that causes the I/O completion code to
> run directly on the context of the thread that submitted the SCSI command.
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



