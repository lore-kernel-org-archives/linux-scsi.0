From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [RFC 7/8] IB/srp: stop sharing the host lock with SCSI
Date: Mon, 27 Dec 2010 13:01:53 -0500
Message-ID: <1293472913.2896.36.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-8-git-send-email-dillowda@ornl.gov>
	 <1293472165.2896.34.camel@obelisk.thedillows.org>
	 <4D18D355.30308@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D18D355.30308-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-12-27 at 19:56 +0200, Boaz Harrosh wrote:
> On 12/27/2010 07:49 PM, David Dillow wrote:
> > On Thu, 2010-12-23 at 16:31 -0500, David Dillow wrote:
> >> We don't need protection against the SCSI stack, so use our own lock to
> >> allow parallel progress on separate CPUs.
> > 
> >> @@ -1126,7 +1125,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
> >>  		return 0;
> >>  	}
> >>  
> >> -	spin_lock_irqsave(shost->host_lock, flags);
> >> +	spin_lock_irqsave(&target->lock, flags);
> >>  	/* This goes away once the scsi_eh routines stop testing it. */
> >>  	scsi_cmd_get_serial(shost, scmnd);
> >>  	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
> > 
> > This one may be a bit problematic -- I need to look at the required
> > locking to avoid a race with the serial number. Of course, there's an
> > easy fix -- if this patch lands after the patches to remove the serial
> > number check from the error handler, then there's no reason to get a
> > serial number in the initiator.
> > 
> 
> $ git log --oneline -1 linus/master -- drivers/scsi/scsi_error.c
> 459dbf7 [SCSI] Eliminate error handler overload of the SCSI serial number

Oh goodie, I hadn't followed up to see if it was in one of James's later
pulls. Thanks for the heads up -- I'll dump scsi_cmd_get_serial() in
this patch then.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
