From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/3] scsi: Detailed I/O errors
Date: Mon, 17 Jan 2011 13:20:59 -0500
Message-ID: <20110117182059.GA6549@redhat.com>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
 <1295020736-27699-2-git-send-email-snitzer@redhat.com>
 <20110114161048.GK5727@earth.li>
 <20110114171614.GA27852@redhat.com>
 <4D3465B8.1040108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1AQSVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2011 13:21:19 -0500
Content-Disposition: inline
In-Reply-To: <4D3465B8.1040108@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jonathan McDowell <noodles@earth.li>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, michaelc@cs.wisc.edu

On Mon, Jan 17 2011 at 10:52am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/14/2011 06:16 PM, Mike Snitzer wrote:
> > On Fri, Jan 14 2011 at 11:10am -0500,
> > Jonathan McDowell <noodles@earth.li> wrote:
> >>
> >> I'd have viewed a reservation conflict as being tied to a particular
> >> path, rather than the entire target. I've seen multipath setups where
> >> there are reservation issues on some of the paths but others are fine
> >> and this is expected (eg use of reservations to fence off particular
> >> paths).
> > 
> > Very good point (as I think you're correct).  Technically a reservation
> > conflict is retryable across _different_ paths but (relative to the
> > error path as it relates to multipath) it appears Hannes elected to go
> > with the conservative approach of always failing the IO upward given the
> > potential for data corruption when queue_if_no_path is used.
> > 
> > Hannes previously touched on this here:
> > https://www.redhat.com/archives/dm-devel/2009-November/msg00190.html
> > 
> > "This also solves a potential data corruption with multipathing
> > and persistent reservations. When queue_if_no_path is active
> > multipath will queue any I/O failure (including those failed
> > with RESERVATION CONFLICT) until the reservation status changes.
> > But by then I/O might have been ongoing on the other paths,
> > thus the delayed submission will severely corrupt your data."
> > 
> > Even in the context of that older SCSI sense-based mpath patchset a
> > reservation conflict would always fail upward (regardless of path count
> > and/or queue_if_no_path).
> > 
> > All said, the above doesn't excuse what seems to be a mis-categorization
> > of reservation conflict as a pure non-retryable TARGET_FAILURE
> > (EREMOTEIO).
> > 
> Ho-hum.
> 
> Yes, and no.
> 
> Yes, it is correct that persistent reservations are in fact per
> ITL nexus, and hence might yield different responses if retried on
> another path.
> 
> And no, it is not entirely correct to return the standard EIO error
> here as then the no_path_retry mechanism might kick in and we're
> back to square one.
>
> That said we probably need to invent another error code with
> meaning 'Retry on other ITL nexus if present, but ignore no_path_retry'.

That sounds right.  So something like the following?:
- set ITL_NEXUS_ERROR/DID_ITL_NEXXUS_FAILURE in scsi (comparable to how
  you did TARGET_ERROR/DID_TARGET_FAILURE) 
- then return -EAGAIN from __scsi_error_from_host_byte() to signal to
  upper layer(s) that a retry could be worthwhile -- driver specific

In mpath's case it can respond to -EAGAIN by conversatively retrying
with the 'Retry on other ITL nexus if present, but ignore no_path_retry'
semantic?

(overloading -EAGAIN leaves something to be desired but I welcome other
ideas).

Thanks,
Mike
