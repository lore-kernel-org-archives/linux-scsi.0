From: Doug Ledford <dledford@redhat.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Wed, 28 Aug 2002 21:42:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828214215.A31167@redhat.com>
References: <20020828202534.G30927@redhat.com> <20020828174737.A27554@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020828174737.A27554@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Aug 28, 2002 at 05:47:37PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2002 at 05:47:37PM -0700, Patrick Mansfield wrote:
> So, you think all (or most) of the GFP_ATOMIC's in scsi_scan.c should
> be GFP_KERNEL?

Yep.  Until such time as a LLDD actually calls scsi_scan from an interrupt 
handler to handle a fiber fabric that has just come back up, it is safe 
for this code to use GFP_KERNEL.  As for the fiber channel issue, I 
actually think that it needs to notify the eh thread of the change in loop 
state and let the eh thread do the rescan from the eh thread context 
instead of interrupt context, so this won't be an issue when we support 
fiber loop transitions either.

> All the kmalloc calls should be at boot time, or via
> insmod.

Right, process context with no locks held.

> I was wondering about them, but left them to match the previous
> scsi_scan.c code.

I figured.  That's why I pointed it out ;-)

> Do GFP_KERNEL alloc failures during boot time just return NULL?

GFP_ATOMIC returns NULL on failure, GFP_KERNEL *should* never fail until 
we get to a true OOM condition because it will block and wait for the vm 
subsystem to free us up some space.  Under true OOM conditions it will 
return NULL AFAIK.

> (Given that there is really no memory left.) I'd hope so, but was
> never sure.
> 
> I suppose I could change them and boot with mem=something-low and
> see what happens.

I've known people that had actual, real problems because of the GFP_ATOMIC 
allocations in this code area.  It was related to bringing up a fiber 
controller that had 100s of disks hanging off of it and therefore wanted 
to do a *LOT* of atomic allocations in a short period of time, but it was 
a real problem none the less.  Making the allocations non-atomic would 
allow the scanning to block waiting on more ram instead of bailing on 
devices.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
