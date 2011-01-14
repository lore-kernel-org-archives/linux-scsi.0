From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/3] scsi: Detailed I/O errors
Date: Fri, 14 Jan 2011 12:16:14 -0500
Message-ID: <20110114171614.GA27852@redhat.com>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
 <1295020736-27699-2-git-send-email-snitzer@redhat.com>
 <20110114161048.GK5727@earth.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab1ANRQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 12:16:28 -0500
Content-Disposition: inline
In-Reply-To: <20110114161048.GK5727@earth.li>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan McDowell <noodles@earth.li>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

On Fri, Jan 14 2011 at 11:10am -0500,
Jonathan McDowell <noodles@earth.li> wrote:

> On Fri, Jan 14, 2011 at 10:58:54AM -0500, Mike Snitzer wrote:
> > From: Hannes Reinecke <hare@suse.de>
> > 
> > Instead of just passing 'EIO' for any I/O error we should be
> > notifying the upper layers with more details about the cause
> > of this error.
> > 
> > Update the possible I/O errors to:
> > 
> > - ENOLINK: Link failure between host and target
> > - EIO: Retryable I/O error
> > - EREMOTEIO: Non-retryable I/O error
> > 
> > 'Retryable' in this context means that an I/O error _might_ be
> > restricted to the I_T_L nexus (vulgo: path), so retrying on another
> > nexus / path might succeed.
> ...
> > @@ -1486,6 +1495,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
> >  	case RESERVATION_CONFLICT:
> >  		sdev_printk(KERN_INFO, scmd->device,
> >  			    "reservation conflict\n");
> > +		scmd->result |= (DID_TARGET_FAILURE << 16);
> >  		return SUCCESS; /* causes immediate i/o error */
> >  	default:
> >  		return FAILED;
> ...
> > +#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
> > +				 * other paths */
> 
> I'd have viewed a reservation conflict as being tied to a particular
> path, rather than the entire target. I've seen multipath setups where
> there are reservation issues on some of the paths but others are fine
> and this is expected (eg use of reservations to fence off particular
> paths).

Very good point (as I think you're correct).  Technically a reservation
conflict is retryable across _different_ paths but (relative to the
error path as it relates to multipath) it appears Hannes elected to go
with the conservative approach of always failing the IO upward given the
potential for data corruption when queue_if_no_path is used.

Hannes previously touched on this here:
https://www.redhat.com/archives/dm-devel/2009-November/msg00190.html

"This also solves a potential data corruption with multipathing
and persistent reservations. When queue_if_no_path is active
multipath will queue any I/O failure (including those failed
with RESERVATION CONFLICT) until the reservation status changes.
But by then I/O might have been ongoing on the other paths,
thus the delayed submission will severely corrupt your data."

Even in the context of that older SCSI sense-based mpath patchset a
reservation conflict would always fail upward (regardless of path count
and/or queue_if_no_path).

All said, the above doesn't excuse what seems to be a mis-categorization
of reservation conflict as a pure non-retryable TARGET_FAILURE
(EREMOTEIO).

But I'd like to defer to Hannes for the authorative answer ;)

Regards,
Mike
