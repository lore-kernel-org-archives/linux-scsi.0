From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 13:46:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925134652.A6889@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924233941.A9952@flint.arm.linux.org.uk> <20020924170857.A15340@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17uBZ7-0003tU-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 13:46:53 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17uBZ6-0001yq-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 13:46:52 +0100
Content-Disposition: inline
In-Reply-To: <20020924170857.A15340@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 24, 2002 at 05:08:57PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Some more thoughts about this...

On Tue, Sep 24, 2002 at 05:08:57PM -0700, Patrick Mansfield wrote:
> It would be nice if we could call
> scsi_set_medium_removal(SCSI_REMOVAL_PREVENT) and use a single code path
> for all door lock requests, then we need a special force-to-queue-head
> argument passed on down the chain.

I don't think so.  In the general case, we need to wait for the command
to complete, pick up the result of that command, and report that back
to the caller.

In the error handing case, we must not wait for the command to complete.
Firstly, any result it reveals isn't useful.  The completion of the
command isn't interesting.

Secondly, blocking the error handler is one of the problems that the
original code had, which is why the rest of the error handler goes to
great efforts to submit retried commands to the host adapter in a
carefully controlled manner.  We must not block the error handler,
and then get into a situation that we need the error handler to
recover itself from.

So we have two situations.  First, the common case where we add requests
to the tail of the request queue.  This is the one you optimise for,
and make as fast as possible.

Second, we have the slow path, which is the error recovery.  Yes, it
is less important to optimise it, but it shouldn't be at the expense
of the fast, common path.

> (We should really have some common setup-a-scsi-command functions to
> remove all the duplicate cmd[] setup code.)

I have some thoughts on this.  However, I don't believe them to be
appropriate for 2.4 kernels.  For 2.4, I'm working to fix the problems
by introducing the minimum of new features.

> > +	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next) {
> 
> > +		if (!SDpnt->online || !SDpnt->locked)
> > +			continue;
> > +
> > +		scsi_eh_lock_door(SDpnt);
> > +	}
> 
> Why is the above in a separate loop from the loop with the request_fn call?
> To avoid holding the lock during the call or what?

Yes.  scsi_eh_lock_door() may sleep when trying to obtain a request.
I'm not convinced that this is the best thing to do yet.  However,
if we do have the possibility of sleeping, we must not hold any
spinlocks.

> Above is where we also need a "SDpnt->has_cmdblock" check, simplify
> the above to be:

No.  The request allocation code should be doing that for us.

> 	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next)
> 		if (SDpnt->online && SDpnt->locked && SDpnt->has_cmdblock)
> 			scsi_eh_lock_door(SDpnt);
> 			
> (And why does the SDpnt->device_blocked cause the later loop to
> break rather than continue! I can understand the host->xxx checks
> breaking out.)

Probably another bug.

I'm trying to make things more correct than they currently are.  Each
change on its own may not fix every single bug in one go.  Neither
should it.

Locate one problem, address it, solve it, prove that it is solved,
create a patch, submit, and get it reviewed.  Move to the next problem.

This is the only way that we're going to get reasonable improvement.
SCSI error handling has sucked for many many years.  If it was trivial
to fix, it would've been fixed long ago.

It's going to take time, but I believe that this method will have a
better success rate than one huge patch that claims to address all
issues, changes lots of code and therefore can't be reviewed.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

