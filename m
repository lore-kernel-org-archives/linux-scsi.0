From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Sat, 19 Jul 2003 10:26:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030719082633.GF833@suse.de>
References: <1058474814.4638.11.camel@markh1.pdx.osdl.net> <1058481553.19508.5.camel@markh1.pdx.osdl.net> <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net> <20030717170055.5dbe20c1.akpm@osdl.org> <3F17821A.307@cyberone.com.au> <1058540605.20130.48.camel@markh1.pdx.osdl.net> <1058545730.20130.62.camel@markh1.pdx.osdl.net> <1058547377.1826.61.camel@mulgrave> <1058550386.20130.75.camel@markh1.pdx.osdl.net> <1058559719.1826.106.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:27531 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270537AbTGSILp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2003 04:11:45 -0400
Content-Disposition: inline
In-Reply-To: <1058559719.1826.106.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Haverkamp <markh@osdl.org>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jul 18 2003, James Bottomley wrote:
> On Fri, 2003-07-18 at 12:46, Mark Haverkamp wrote:
> > I'll try out your test harness on our hardware and see what happens.
> 
> OK, I think I found the problem.
> 
> Parts of the SCSI and block code don't distinguish between queueing and
> requeueing, so they trip over the exact same error.
> 
> The (fairly invasive) fix is to add an extra parameter to
> blk_insert_request to tell it if this is a reinsertion or a new request
> (patch attached--against Jens' previous one).
> 
> With this, I now get the AS ioscheduler to survive my tests.
> 
> Incidentally, I'm not sure whether scsi_requeue_command() counts as a
> reinsertion.  It's used to redo I/O after end_that_request_first() but
> before end_that_request_last().
> 
  
> @@ -1550,11 +1551,15 @@
>  	/*
>  	 * If command is tagged, release the tag
>  	 */
> -	if (blk_rq_tagged(rq))
> -		blk_queue_end_tag(q, rq);
> +	if(reinsert) {
> +		blk_requeue_request(q, rq);
> +	} else {
> +		if (blk_rq_tagged(rq))
> +			blk_queue_end_tag(q, rq);
>  
> -	drive_stat_acct(rq, rq->nr_sectors, 1);
> -	__elv_add_request(q, rq, !at_head, 0);
> +		drive_stat_acct(rq, rq->nr_sectors, 1);
> +		__elv_add_request(q, rq, !at_head, 0);
> +	}
>  	q->request_fn(q);
>  	spin_unlock_irqrestore(q->queue_lock, flags);

much better, looks good to me. Andrew, could you pull your hack and
apply mine + this one? If James doesn't beat me to it, I can make a
complete patch this afternoon.


-- 
Jens Axboe

