From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 21:00:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924210042.C4409@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020924123250.A5890@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 24, 2002 at 12:32:50PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 12:32:50PM -0700, Patrick Mansfield wrote:
> OK - but you also do not want eternal bus resets because of a marginal
> device.

I agree.  I'm actually running against the "rmk" error handler, which
has a fair number of the problems with the existing error handler fixed.
For instance, it won't leave the HBA driver with a currently executing
command and a stuck bus after attempting a retry.

It also knows about channels, and knows that if it a command fails on
a bus that has needed a reset, then the right thing to do is to reset
it _once_ again and only once, because the bus is probably stuck.

Oh, yes, I've put a lot of thought into this. 8)

> > Not quite.  Its even more disgusting.  That code is fundamentally wrong, as
> > proven by my later hangs when the devices have been initialised, and passed
> > to the device drivers.
> > 
> > 1) We queue up a command for device A _or_ step 3 above.
> > 
> > 2) scsi_request_fn() gets called to start this device
> > 
> > 3) scsi_request_fn() for A sees that a reset happened, and calls scsi_ioctl()
> > 
> > 4) scsi_ioctl() calls scsi_request_fn().
> > 
> 
> Agree with all the above.
> 
> > 5) the head of the request queue is _not_ the door lock, but the original
> >    request.
> 
> I still don't see how this can be the original request. The TUR is sent via
> the error handler, the INQUIRY resent during error handling does not call
> scsi_request_fn().
> 
> So, where is the request requeued?

A request received via ioctl is queued at the tail of the request queue,
not the head.  I can give you a reference if you'd like. 8)

> Is this is in modified error handler code or something?

Yes, and it is definitely more correct than the previous.  It certainly
isn't the cause of the problems.  I can say this because I'm now back
in my driver trying to debug a problem there, and the rest of the SCSI
subsystem is admirably coping with the crap I'm throwing at it.

My error handler doesn't go around chunking stuff into request queues
btw.  Neither does the existing one.

Basically, all its doing is knowing about channels properly, and knowing
that it needs to do a bus reset if its going to take a device off line.

If you can stand the suspense a while longer, I'll generate the patches,
and then you can read all the gory details yourself.  Until that time, I
think its rather academic trying to discuss stuff that I've had more than
12 hours to hammer away at and successfully solve.

Give me two hours, and I'll have patches.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

