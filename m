From: Doug Ledford <dledford@redhat.com>
Subject: Re: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 21:45:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021123024501.GC19547@redhat.com>
References: <20021122183603.GC16865@redhat.com> <20021122155615.A21301@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021122155615.A21301@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 22, 2002 at 03:56:15PM -0800, Patrick Mansfield wrote:
> Hi Doug -
> 
> It booted and runs fine on a netfinity + aic. I haven't updated my 
> modutils yet, so did not try the qla driver (ported to your new naming
> scheme, I need the qla to test with a qlogics 2300 with a multi-lun target).
> 
> Was there a missing scsi_release_commandblocks call?

Yep (at least it looked like it, so I decided better safe than sorry since 
scsi_release_commandblocks() is safe even when there are none to release).

> Why not remove the next/prev in scsi_device? Any code referencing
> them is broken, usage should at least generate a compilation warning.

I was going to in my next patch.  The first was to change it over, the 
next would have been various cleanups.

> The slave_destroy should be called before the channel/id/lun is modified
> during scanning, so slave_destroy if needed can index off of 
> host/channel/id/lun and figure out properly what to destroy.

Hmmm...I thought that's how I did it....

> Perhaps there
> should be a common function for this that calls slave_destroy, modifies
> sdevscan channel/id/lun, and then calls slave_alloc; such a function might
> also release and build command blocks.

Well, before we go too far down this road, I do want to pipe up and 
publically announce how much I thoroughly *DETEST* that whole section of 
code with its totally convoluted hoop jumping crap that it does to avoid 
calling blk_init_queue() on each scan target.  Personally, if it were up 
to me I would make a much simpler/faster queue init routine, quit this 
crap of passing around and reusing the same pointer, and clean up *tons* 
of crap in the scsi scan code.  That being said, anything that increases 
the complexity of that code is bad IMHO.

Furthermore, one of my intended near future patches, pending review of the
idea because this is a change that would touch *A LOT* of files, is to get
rid of scsi_{build,release}_commandblocks entirely and instead change the
scsi subsystem to use generic command blocks that are applicable to all
hosts, modify all low level drivers to use the cmd->device pointer to get
the host/bus/target id/lun values so that they don't need device specific
command blocks, then to allocate a small pool of these on startup and lazy
allocate/deallocate them as we run and as scsi_adjust_queue_depth() starts
getting called for various devices.  If that happens, then most of the 
discussion about command blocks is moot.  Then, since currently I'm the 
only user of slave_alloc(), it would also be easy enough for me to make a 
rule that no device driver is allowed to hard code device numbers in thier 
alloced struct so that we could do this scanning of devices, not need to 
rebuild command blocks, not need to realloc slave structs, and still have 
everything work.  Good enough?

> The report lun usage does not modify the channel/id/lun, so does not need
> the slave_destroy/slave_alloc calls.

Umm...doesn't report lun scan get called on successive targets during a 
host scan using a recycled sdevscan?

> IMO the traversal of scsi_devices should be completely transparent
> to the user, such as a wrapper or call back function, so we would not 
> have to change anything if the underlying data structure changed (the
> list of scsi_hosts contains a list of scsi_devices). Namely, for
> multi-path  it is useful to have all the scsi_devices on one list, and
> not have a host centric view of the scsi_devices.

I personally think it makes more sense to keep the host centric view of 
devices, and for multipath the most I would do is add another list struct 
for chaining together device structs that all point to the same device.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
