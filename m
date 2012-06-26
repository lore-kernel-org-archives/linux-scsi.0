From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Tue, 26 Jun 2012 08:25:24 +0100
Message-ID: <1340695524.3058.5.camel@dabdike.int.hansenpartnership.com>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org>
	 <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
	 <4FE95ADE.2080102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34804 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883Ab2FZHZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jun 2012 03:25:29 -0400
In-Reply-To: <4FE95ADE.2080102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Tue, 2012-06-26 at 06:46 +0000, Bart Van Assche wrote:
> On 06/25/12 21:14, James Bottomley wrote:
> 
> > On Mon, 2012-06-25 at 18:15 +0000, Bart Van Assche wrote:
> >> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >> index 6dfb978..c26ef49 100644
> >> --- a/drivers/scsi/scsi_lib.c
> >> +++ b/drivers/scsi/scsi_lib.c
> >> @@ -406,10 +406,7 @@ static void scsi_run_queue(struct request_queue *q)
> >>  	LIST_HEAD(starved_list);
> >>  	unsigned long flags;
> >>  
> >> -	/* if the device is dead, sdev will be NULL, so no queue to run */
> >> -	if (!sdev)
> >> -		return;
> >> -
> >> +	BUG_ON(!sdev);
> > 
> > Needs to be a blk_queue_dead() check as well.
> 
> 
> Callers of scsi_run_queue() don't hold the queue lock. Does it make
> sense to test whether the queue is dead without the queue lock being held ?

I'm not entirely sure I understand the question, but I think you think
that locking is required to read the queue state?  That's emphatically
not correct.  In fact, you don't even need locking to write the state
provied the state variable is a natcural processor witdth (i.e. u32 on
32 bit or u64 or u32 on 64 bit) and you don't do dependent state
variable updates or other atomic sequences.

James


