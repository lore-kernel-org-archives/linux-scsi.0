From: Luben Tuikov <luben@splentec.com>
Subject: Re: One more change pushed to bk tree
Date: Mon, 25 Nov 2002 12:02:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE257C3.C48D4FE6@splentec.com>
References: <20021122183603.GC16865@redhat.com> <20021122155615.A21301@eng2.beaverton.ibm.com> <20021123024501.GC19547@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> 
> Well, before we go too far down this road, I do want to pipe up and
> publically announce how much I thoroughly *DETEST* that whole section of
> code with its totally convoluted hoop jumping crap that it does to avoid
> calling blk_init_queue() on each scan target.  Personally, if it were up
> to me I would make a much simpler/faster queue init routine, quit this
> crap of passing around and reusing the same pointer, and clean up *tons*
> of crap in the scsi scan code.  That being said, anything that increases
> the complexity of that code is bad IMHO.
> 
> Furthermore, one of my intended near future patches, pending review of the
> idea because this is a change that would touch *A LOT* of files, is to get
> rid of scsi_{build,release}_commandblocks entirely and instead change the
> scsi subsystem to use generic command blocks that are applicable to all
> hosts, modify all low level drivers to use the cmd->device pointer to get
> the host/bus/target id/lun values so that they don't need device specific
> command blocks, then to allocate a small pool of these on startup and lazy
> allocate/deallocate them as we run and as scsi_adjust_queue_depth() starts
> getting called for various devices.  If that happens, then most of the
> discussion about command blocks is moot.  Then, since currently I'm the
> only user of slave_alloc(), it would also be easy enough for me to make a
> rule that no device driver is allowed to hard code device numbers in thier
> alloced struct so that we could do this scanning of devices, not need to
> rebuild command blocks, not need to realloc slave structs, and still have
> everything work.  Good enough?

scsi_adjust_queue_depth() would ideally just change an integer,
say device->max_device_cmds or something like that (OSLT). This would play
nicely with int dev->device_cmds_held or int device_cmds_active OSLT, also
being an integer and it wouldn't matter if you _decrease_ the
max, but currently there are more active in the device. (you may
disallow this or set some policy if you wish, etc...)

As a spin off of this, if you set max_device_cmds to 0, you've
effectively turned off the device, but letting it complete what's
active -- one may not want to do this like that of course, but
mentioned here just as a consequence.

The point of all this is that this makes a lot more things a lot
more flexible and makes SCSI core shrink (long, long awaited).

BTW, you've mentioned this change many times before. I don't know
why you haven't implemented it yet, or how structural (non-cosmetic)
changes are voted for in linux-scsi for the SCSI layer, but
you have my vote on this change.

-- 
Luben
