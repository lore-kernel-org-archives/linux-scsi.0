From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Wed, 16 Oct 2002 16:15:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016201531.GB8159@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com> <20021016023231.GA4690@redhat.com> <20021016120436.A1598@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id g9GKFVfv008184
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 16:15:31 -0400
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id g9GKFV2m008182
	for linux-scsi@vger.kernel.org; Wed, 16 Oct 2002 16:15:31 -0400
Content-Disposition: inline
In-Reply-To: <20021016120436.A1598@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Oct 16, 2002 at 12:04:36PM -0700, Patrick Mansfield wrote:
> On Tue, Oct 15, 2002 at 10:32:31PM -0400, Doug Ledford wrote:
> > On Tue, Oct 15, 2002 at 04:30:57PM -0700, Patrick Mansfield wrote:
> > 
> > > If the adapter is setting queue depth based upon what
> > > the adapter knows, that is completely wrong
> > 
> > I strongly disagree here.  Only the adapter driver knows if the card 
> > itself has a hard limit of X commands at a time (so that deeper queues are 
> > wasted).  Only the adapter driver knows if the particular interconnect has 
> > any inherent queue limitations or speed limitations.  There are a thousand 
> > things only the adapter driver knows that should be factored into a sane 
> > queue depth.
> 
> OK, the adapter does not get it completely wrong, but it does not
> know about special scsi device limitations, block layer limits, usage
> patterns, or total number of scsi devices on the system.

All of these are special cases.  Scsi device limitations it will learn
(that's the go lower part ;-), block layer limits need to be addressed (by
changing the block layer to know about our queue depth requirements is my
preferred way of doing things, I would like to see the block layer adjust
the request queue depth whenever we adjust our queue depth, but I'm not 
sure what this would take at this point in time), usage patterns are 
something only an admin could reasonably tell us ("Hey, this disk is only 
used for temporary storage when streaming to tape, so it only needs 
miniscule resources" is valid, but special, and trying to write a default 
for this scenario isn't feasible), and total number of scsi devices on the 
system is learnable, but I don't think we should change our defaults over 
it (especially since hot plug devices makes this a dubious distinction at 
best, I think the better default is to assume that any machine with some 
huge number of drives attached via SCSI is likely a huge machine and that 
the relatively small X kilobytes of data we allocate statically per drive 
is OK, the aic7xxx_old driver allocates 1k +- for each command, with a 
maximum of 255 commands per controller regardless of total device queue 
depth on that controller, so a maximum of 256K per controller right now, 
so 100 drives on 10 controllers would be a maximum of 2.5MB of RAM, and 
any machine with 100 disks shouldn't balk at 2.5MB of aic7xxx_old data 
structs, how much data is allocated in the block layer and mid layer is 
not a figure I have at hand though).

> Your changes (set high, adjust lower as we hit queue fulls) should
> work fine in most cases, and is much better than the previous state.

Good, then we agree ;-)

> Some example cases where we might want to lower queue depth:
> 
> System with small amounts of memory compared to the number of devices.
> 
> With many disks on a system, some with a very light load, it could be
> give the lightly loaded disks a lower queue depth so they use less
> memory, or so they can do less IO.

Both of these are strong candidates for proper admin setup IMHO.

> In a 2 node cluster with shared devices, the queue depth could be set to
> half of some hard limit on each node of the cluster, and avoid hitting
> any hard queue fulls.

Maybe, but what if you want each node to be able to reach maximum 
performance under peak conditions and then fall back during more relaxed 
times?  This is the same sort of thing that all of our controllers have 
been doing in the past by limiting the queue depth of all devices on a 
controller to the controllers maximum depth and I contend it's a false 
optimization.  It permanently lowers the peak performance of each machine 
for fear that you might have contention for the device's queue instead of 
simply acting reasonable in the presence of QUEUE_FULL return codes.

> (It would really nice if we could modify the number of struct request's 
> allocated for little used or unused devices, or on character devices like
> tape that don't even use the requests. Current block code allocates 2*128
> of these on systems with lots of memory, this could save way more space
> than lowering the queue depth.)

This I agree with 1000% and is on my list of things to investigate.

> I was suggesting a common interface via a Scsi_Device device attribute
> so the default depth can be modified as needed, rather than a fixed
> boot or module load option that is fixed (once the driver is loaded)
> and might be a different option for every adapter driver.
> 
> It's too bad we can't modify new_queue_depth and have all the layers
> (well mid and lower) adjust accordingly.

Well, I don't have any objection to being able to modify queue depths.  
However, the current problem is that none of the device drivers have the 
ability to accept events that tell them to change their queue depth on a 
device.  Instead, they all want to tell the mid layer what queue depth to 
use.  Now, because we can't just blindly shove more commands into a driver 
than it's expecting, you can't up the queue depth without telling the 
driver (lowering it is probably safe, although it is wasteful of allocated 
structs in memory).  As it stands, the mid layer *would* honor changing 
new_queue_depth.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
