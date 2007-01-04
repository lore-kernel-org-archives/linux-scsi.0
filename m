From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Thu, 4 Jan 2007 12:21:56 +0100
Message-ID: <20070104112156.GV11203@kernel.dk>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:23950 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbXADLTF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 06:19:05 -0500
Content-Disposition: inline
In-Reply-To: <459C92CE.4090709@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 04 2007, Douglas Gilbert wrote:
> Jens Axboe wrote:
> > Hi Doug,
> > 
> > resp_inquiry() does a GFP_KERNEL memory allocation, but it's not allowed
> > to from the queuecommand context. There's no good way to return this
> > error, so I used DID_ERROR which is used from similar paths. That
> > doesn't seem quite right though, it would be better to return an error
> > indicating a later retry would be more appropriate.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 30ee3d7..0c80ed3 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -954,7 +954,9 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
> >  	int alloc_len, n, ret;
> >  
> >  	alloc_len = (cmd[3] << 8) + cmd[4];
> > -	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
> > +	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
> > +	if (!arr)
> > +		return DID_ERROR << 16;
> >  	if (devip->wlun)
> >  		pq_pdt = 0x1e;	/* present, wlun */
> >  	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
> > 
> 
> Jens,
> I had to read that twice. I'm always happy to convert a
> GFP_KERNEL to a GFP_ATOMIC (as I'm sure it started as a
> GFP_ATOMIC). There are a couple more that may be in
> queuecommand context.
> 
> Taking up your point about retries and seeing that the
> scsi_debug driver has a SAS flavour, I'm inclined towards
> a "aborted command, initiator response timeout" [Bh,4Bh,6]
> CHECK CONDITION. There is a group of transport injected
> error messages in SAS (see sas2r07.pdf section 10.2.3)
> that pop up from time to time. Due to conjestion in
> connection-switched SAS expanders these error messages
> should be interpreted as "try again" depending on the
> topology. The patch below adds a "aborted_command" bit
> in opts that will cause every nth command to be aborted
> (with an ack/nak timeout).
> 
> Note that SAS has an optional "transport layer retries"
> state machine to lessen the incidence of "aborted commands".
> Evidently SAS tape drives use the facility.

I guess it's fully up to you how you want to solve it. The scheme seems
a little elaborate, but these error conditions are unlikely to ever been
seen in the wild, so no objections from me.

I'd suggest sending this in for 2.6.20.

-- 
Jens Axboe

