From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Mon, 25 Jun 2012 14:21:07 -0700
Message-ID: <20120625212107.GM3869@google.com>
References: <4FE8A9FC.6040805@acm.org>
 <4FE8AAB9.9060602@acm.org>
 <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42595 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab2FYVVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 17:21:11 -0400
Received: by pbbrp8 with SMTP id rp8so7090788pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2012 14:21:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

Hey, James.

On Mon, Jun 25, 2012 at 10:14:49PM +0100, James Bottomley wrote:
> > @@ -1490,11 +1489,7 @@ static void scsi_request_fn(struct request_queue *q)
> >  	struct scsi_cmnd *cmd;
> >  	struct request *req;
> >  
> > -	if (!sdev) {
> > -		while ((req = blk_peek_request(q)) != NULL)
> > -			scsi_kill_request(req, q);
> > -		return;
> > -	}
> 
> That means that this hunk of code has to stay, but needs to be gated on
> blk_queue_dead(q); there's still a race where this can occur.

Wouldn't the scsi_device_online() check down below be enough?  Block
layer drain is gonna loop until all requests are done, so the looping
is handled from block layer.

Thanks.

-- 
tejun
