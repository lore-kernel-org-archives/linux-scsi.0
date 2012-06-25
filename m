From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Mon, 25 Jun 2012 22:35:39 +0100
Message-ID: <1340660139.2980.55.camel@dabdike.int.hansenpartnership.com>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org>
	 <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
	 <20120625212107.GM3869@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33531 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab2FYVfn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2012 17:35:43 -0400
In-Reply-To: <20120625212107.GM3869@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Mon, 2012-06-25 at 14:21 -0700, Tejun Heo wrote:
> Hey, James.
> 
> On Mon, Jun 25, 2012 at 10:14:49PM +0100, James Bottomley wrote:
> > > @@ -1490,11 +1489,7 @@ static void scsi_request_fn(struct request_queue *q)
> > >  	struct scsi_cmnd *cmd;
> > >  	struct request *req;
> > >  
> > > -	if (!sdev) {
> > > -		while ((req = blk_peek_request(q)) != NULL)
> > > -			scsi_kill_request(req, q);
> > > -		return;
> > > -	}
> > 
> > That means that this hunk of code has to stay, but needs to be gated on
> > blk_queue_dead(q); there's still a race where this can occur.
> 
> Wouldn't the scsi_device_online() check down below be enough?  Block
> layer drain is gonna loop until all requests are done, so the looping
> is handled from block layer.

It might be ... in theory the teardown is supposed to happen in
SDEV_CANCEL and be done by SDEV_DEL.  However, I'm not sure that's
entirely true now.  blk_queue_dead() is safer since we know we just
killed the queue.  Another reason for doing it like this is that the
kill on queue dead isn't noisy ... the one on !online is ... and logs
were getting stuffed with messages about killing requests to dead
queues.

James


