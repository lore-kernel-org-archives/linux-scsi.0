From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Sun, 30 Jan 2005 23:47:25 -0800
Message-ID: <1107157645.21520.17.camel@plap>
References: <1106954650.9862.61.camel@plap> <1106977566.9862.102.camel@plap>
	 <1107017081.4535.29.camel@mulgrave>  <20050129193421.GA7573@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:35251 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261968AbVAaHta
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 02:49:30 -0500
In-Reply-To: <20050129193421.GA7573@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-01-29 at 11:34 -0800, Patrick Mansfield wrote:
> On Sat, Jan 29, 2005 at 10:44:41AM -0600, James Bottomley wrote:
> > On Fri, 2005-01-28 at 21:46 -0800, Andrew Vasquez wrote:
> > > Returning back DID_IMM_RETRY for these 'transport' related conditions
> > > would of course help in this issue -- but at the same time bring with it
> > > several side-effects which may not be desirable.
> > > 
> > > So, beyond this particular circumstance, what would be considered a
> > > 'proper' return status for this type of event? 
> > 
> > Well, the correct return, since this is a condition from the storage, is
> > simply the check condition and the sense code (rather than having the
> > driver interpret it).
> 
> But the transport hit a failure, not the storage device.
> 
> I thought Andrew hit this sequence:
> 
> 	- pull / replace cable
> 
> 	- IO resumes but gets NOT_READY (the device could be logging back
> 	  into the fibre or such)
> 
> 	- a FC transport problem is hit, DID_BUSY_BUSY is returned, but
> 	  scmd->retries has already been exhausted by the NOT_READY
> 
> Did I misread something?
> 

No, that's correct -- sorry about the confusion my second email caused.
I had only inquired about the 'correct' return status in the context of
avoiding the (cmd-retries > cmd->allowed) failure.

> > > > Would this be an approach to consider?  Or should we tackle the problem
> > > > by addressing the quirky (cmd->retries > cmd->allowed) state?
> > 
> > That's what I think the correct approach should be....we have a few
> > other quirky devices that aren't pleased with our current NOT_READY
> > handling.  Were you going to look into coding up a patch for this?
> 
> We don't track what errors caused a retry (doing so is too painful), or
> reset the retries. In scsi_decide_disposition() if we get a few retry
> cases for one or multiple errors, and then a different error that should
> reasonably be a retry case, we return SUCCESS instead of NEEDS_RETRY.
> 
> Why not just set scmd->retries to zero in scsi_requeue_command()?
> 

This is exactly what I was thinking would be a fairly straight-forward
approach at solving the problem...
 
> All callers are cases that we want to keep retrying if other errors are hit,
> and would fix other potential retry problems, not only the NOT_READY case.
> 

given this fact.  I could code up a quick patch if this would be
acceptable???

> [There is one bad looking scsi_requeue_command() for UNIT_ATTENTION that
> looks like it could retry forever, independent of this problem.]
>

We could also retry forever if the storage never transitions from its
NOT_READY state (unlikely - unless totally borken).

> Fixing the NOT_READY case to quiesce (and not incrementing retries) would
> fix the problem or make it much less likely, and is still a good idea.
> 

Yes, pounding on the storage box seems like a rather unfriendly
approach :-|

--
Andrew
