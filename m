From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 16 Jul 2003 08:41:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058359278.1856.8.camel@mulgrave>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:34053 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270545AbTGPM0v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 08:26:51 -0400
In-Reply-To: <1058310172.981.7.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Tue, 2003-07-15 at 19:02, Mark Haverkamp wrote:
> Daniel McNeil and I have been debugging a hang with the aacraid driver
> using the as I/O scheduler.  We found that scsi_request_fn would
> de-queue a request and later re-queued it.  This left the
> as_data->nr_dispatched variable in an inconsistent state (it was never
> being decremented back to zero).  We added a call to
> elv_completed_request to clean up the state before re-adding the
> request.  This has fixed our hang problem.  The linux-scsi list is being
> copied for review of the scsi_lib.c change.
> 
> ===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
> --- 1.99/drivers/scsi/scsi_lib.c	Sun Jun 29 18:14:44 2003
> +++ edited/drivers/scsi/scsi_lib.c	Tue Jul 15 15:47:45 2003
> @@ -1215,6 +1215,7 @@
>  	spin_lock_irq(q->queue_lock);
>  	if (blk_rq_tagged(req))
>  		blk_queue_end_tag(q, req);
> +	elv_completed_request(q, req);
>  	__elv_add_request(q, req, 0, 0);

This doen't look right to me.

SCSI expects to be able to push back uncompleted requests onto the
request queue.  The fact that you seem to be calling a completion
function for an uncompleted request is what's causing me heartburn.

This code used to work with the old scheduler (we extensively tested it
around the 2.5.6x timeframe because of other changes), so what I'd
really like to know is what changed in the scheduler assumptions to
necessitate this?

If this change is suddenly required, there are several other places in
our queueing functions that will need similar modifications.

Could I have a definitive statement from the I/O scheduler people about
the procedure for pushing back uncompleted I/O on the block queue just
so we all get back on the same page?

Thanks,

James


