From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Wed, 19 Jun 2002 14:25:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020619142554.G8854@redhat.com>
References: <20020619014048.B8623@redhat.com> <20020619134436.A27002@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020619134436.A27002@devserv.devel.redhat.com>; from zaitcev@redhat.com on Wed, Jun 19, 2002 at 01:44:36PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 19, 2002 at 01:44:36PM -0400, Pete Zaitcev wrote:
> >   So, when Justin Gibbs' driver allocates a queue depth of 253 
> > commands on drive X, then finds out that drive X has a hard limit of 64, 
> > then we aren't continuing to waste 189 commands worth of allocated kernel 
> > memory that can never be effectively used.
> 
> > +		  diff = p->dev_lun_queue_depth[tindex] -
> > +			 p->dev_active_cmds[tindex];
> > +		  p->dev_lun_queue_depth[tindex] -= diff;
> 
> I think this is not enough, or backwards. We hit a situation with
> EMC when attaching hundreds of disks depleted atomic memory with
> queue request arrays before swapper had a chance to replenish it.
> I would much appreciate if the initial allocation was concervative,
> if low performing, and was adjusted upwards at slave_attach time.

This is actually from the runtime code, part of my interrupt handler.  It 
notices that we might get a lot of QUEUE_FULLs from a device all at the 
same queue depth, and in that case it reduces the queue depth to the new 
depth.  So, in short, it's not backwards, it's actually taking the depth 
down based upon solid feedback from the drive.

> For 2.5 I would appreciate if we made some SCSI allocations non-atomic.
> The probe time things better be GFP_KERNEL.

Noted, I'll change that soon.  As long as we have at least 1 command 
block, then the other allocations can be at our leisure since the change 
to scsi_release_command() will attempt to allocate 1 command block per 
completed command until they catch up to the intended queue depth.  And, 
since that isn't done from an interrupt, all make it GFP_KERNEL as well 
and if we fail, then we simply wait and do the allocation later.

Allocations on the aic7xxx_old driver are a different thing.  Don't pay 
too much attention to them.  This work I'm doing here has pointed out to 
me that the tagged queue handling in the driver is totally busted in 
regards to multi-lun disk devices.  I would actually have to do a rather 
large overhaul to get it right, and that's not on the plate until I've 
got some of this other stuff out of the way.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
