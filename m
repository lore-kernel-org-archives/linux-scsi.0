From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Sat, 29 Jan 2005 11:34:21 -0800
Message-ID: <20050129193421.GA7573@us.ibm.com>
References: <1106954650.9862.61.camel@plap> <1106977566.9862.102.camel@plap> <1107017081.4535.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:45712 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261555AbVA2TfK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 14:35:10 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0TJZ3ul736910
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2005 14:35:03 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0TJZ342447658
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2005 12:35:03 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0TJZ2X3013359
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2005 12:35:02 -0700
Content-Disposition: inline
In-Reply-To: <1107017081.4535.29.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Jan 29, 2005 at 10:44:41AM -0600, James Bottomley wrote:
> On Fri, 2005-01-28 at 21:46 -0800, Andrew Vasquez wrote:
> > Returning back DID_IMM_RETRY for these 'transport' related conditions
> > would of course help in this issue -- but at the same time bring with it
> > several side-effects which may not be desirable.
> > 
> > So, beyond this particular circumstance, what would be considered a
> > 'proper' return status for this type of event? 
> 
> Well, the correct return, since this is a condition from the storage, is
> simply the check condition and the sense code (rather than having the
> driver interpret it).

But the transport hit a failure, not the storage device.

I thought Andrew hit this sequence:

	- pull / replace cable

	- IO resumes but gets NOT_READY (the device could be logging back
	  into the fibre or such)

	- a FC transport problem is hit, DID_BUSY_BUSY is returned, but
	  scmd->retries has already been exhausted by the NOT_READY

Did I misread something?

> > > Would this be an approach to consider?  Or should we tackle the problem
> > > by addressing the quirky (cmd->retries > cmd->allowed) state?
> 
> That's what I think the correct approach should be....we have a few
> other quirky devices that aren't pleased with our current NOT_READY
> handling.  Were you going to look into coding up a patch for this?

We don't track what errors caused a retry (doing so is too painful), or
reset the retries. In scsi_decide_disposition() if we get a few retry
cases for one or multiple errors, and then a different error that should
reasonably be a retry case, we return SUCCESS instead of NEEDS_RETRY.

Why not just set scmd->retries to zero in scsi_requeue_command()?

All callers are cases that we want to keep retrying if other errors are hit,
and would fix other potential retry problems, not only the NOT_READY case.

[There is one bad looking scsi_requeue_command() for UNIT_ATTENTION that
looks like it could retry forever, independent of this problem.]

Fixing the NOT_READY case to quiesce (and not incrementing retries) would
fix the problem or make it much less likely, and is still a good idea.

And as a long term goal, losing the retry count and moving to allowing all
retries for a period of time would avoid other potential problems, and not
be tied to the speed of the system.

-- Patrick Mansfield
