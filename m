From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 15:23:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924152319.A12439@eng2.beaverton.ibm.com>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924210042.C4409@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020924210042.C4409@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Tue, Sep 24, 2002 at 09:00:42PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 09:00:42PM +0100, Russell King wrote:

> I agree.  I'm actually running against the "rmk" error handler, which
> has a fair number of the problems with the existing error handler fixed.
> For instance, it won't leave the HBA driver with a currently executing
> command and a stuck bus after attempting a retry.
> 
> It also knows about channels, and knows that if it a command fails on
> a bus that has needed a reset, then the right thing to do is to reset
> it _once_ again and only once, because the bus is probably stuck.
> 
> Oh, yes, I've put a lot of thought into this. 8)

Have you seen Mike Anderon's 2.5 cleanup patch?

Patch:

http://www-124.ibm.com/storageio/gen-io/patch-scsi_error-2.5.34-1.gz

Posting:

http://marc.theaimsgroup.com/?l=linux-scsi&m=103187417110244&w=2

I've been focusing on 2.5.x scsi (i.e. scsi multi-path), and would prefer
work be done there first.

> > > 5) the head of the request queue is _not_ the door lock, but the original
> > >    request.
> > 
> > I still don't see how this can be the original request. The TUR is sent via
> > the error handler, the INQUIRY resent during error handling does not call
> > scsi_request_fn().
> > 
> > So, where is the request requeued?
> 
> A request received via ioctl is queued at the tail of the request queue,
> not the head.  I can give you a reference if you'd like. 8)

Yes, I understand that, but where is the original, non-door lock request
coming from? 

My point is that I think there is none, and there can't be any on
a partially initialized device, since there are no command blocks
for the device - put a printk in the scsi_ioctl or such to dump
Scsi_Device::queue_depth and/or Scsi_Device::has_cmdblocks.

-- Patrick Mansfield
