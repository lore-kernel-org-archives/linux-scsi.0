From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: One more change pushed to bk tree
Date: Mon, 25 Nov 2002 11:45:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021125114548.A24993@eng2.beaverton.ibm.com>
References: <20021122183603.GC16865@redhat.com> <20021122155615.A21301@eng2.beaverton.ibm.com> <20021123024501.GC19547@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gAPJjo7l074106
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2002 14:45:50 -0500
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gAPJjnkS068608
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2002 12:45:49 -0700
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id gAPJjms12160
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2002 11:45:48 -0800
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id gAPJjmk26928
	for linux-scsi@vger.kernel.org; Mon, 25 Nov 2002 11:45:48 -0800 (PST)
In-Reply-To: <20021123024501.GC19547@redhat.com>; from dledford@redhat.com on Fri, Nov 22, 2002 at 09:45:01PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

Hi Doug -

On Fri, Nov 22, 2002 at 09:45:01PM -0500, Doug Ledford wrote:
> On Fri, Nov 22, 2002 at 03:56:15PM -0800, Patrick Mansfield wrote:
> > The slave_destroy should be called before the channel/id/lun is modified
> > during scanning, so slave_destroy if needed can index off of 
> > host/channel/id/lun and figure out properly what to destroy.
> 
> Hmmm...I thought that's how I did it....

I meant the ones done during scanning, like these back to back calls
in scsi_probe_and_add_lun, where we call both functions with the new
values of host/chan/id/lun:

	if (sdevscan->host->hostt->slave_destroy)
		sdevscan->host->hostt->slave_destroy(sdevscan);
	if (sdevscan->host->hostt->slave_alloc)
		sdevscan->host->hostt->slave_alloc(sdevscan);

> > Perhaps there
> > should be a common function for this that calls slave_destroy, modifies
> > sdevscan channel/id/lun, and then calls slave_alloc; such a function might
> > also release and build command blocks.
> 
> Well, before we go too far down this road, I do want to pipe up and 
> publically announce how much I thoroughly *DETEST* that whole section of 
> code with its totally convoluted hoop jumping crap that it does to avoid 
> calling blk_init_queue() on each scan target.  Personally, if it were up 
> to me I would make a much simpler/faster queue init routine, quit this 
> crap of passing around and reusing the same pointer, and clean up *tons* 
> of crap in the scsi scan code.  That being said, anything that increases 
> the complexity of that code is bad IMHO.

The really ugly loop stuff of 2.4 is gone. We still must pass
host/channel/id/lun, even if the sdevscan is removed, so we would
still have to pass around a bunch of args or a pointer to a 
host/chan/id/lun.

The worst part about the queue setup is that we allocate our own request,
as do the scsi character devices (st, osst and sg), never using the
make_request, so we need no struct request's. So during the scan we are
avoiding allocations/frees of data structures we do not even use. 

We need a two piece blk queue setup - one to setup the queue, and one
to allocate the number of struct request's needed. The latter can
be called at upper level driver attach time (maybe even in 
scsi_attach_device, needs another argument or use an sdev field).

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

Sounds good, though lazy allocation (even like we have now) can have
cases where we are trying to swap out, and suddenly load up the swap
device, and the swap device must then allocate new command blocks while
low on memory - IO will happen but could be slower than optimal.

I would like abstract interfaces so the device drivers don't have to be
modified if the data structures ever change. i.e. something like:

	scsi_get_cmd_host(scmd)
	scsi_get_cmd_channel(scmd)
	scsi_get_cmd_id(scdm)
	scsi_get_cmd_lun(scmd)

If the above returned handles (or structs) the interface could be
abstracted even further, making future changes easier to deal with
(like changing the the lun size; you can grep for the names everywhere
but that's not easy). The above helps me with the scsi multi-path (even
if you don't agree with the approach).

> > The report lun usage does not modify the channel/id/lun, so does not need
> > the slave_destroy/slave_alloc calls.
> 
> Umm...doesn't report lun scan get called on successive targets during a 
> host scan using a recycled sdevscan?

Yes, but the host/chan/id/lun has is already setup for scanning lun 0.
It does not hurt and is cleaner to do the same setup/teardown in all
cases.

> > IMO the traversal of scsi_devices should be completely transparent
> > to the user, such as a wrapper or call back function, so we would not 
> > have to change anything if the underlying data structure changed (the
> > list of scsi_hosts contains a list of scsi_devices). Namely, for
> > multi-path  it is useful to have all the scsi_devices on one list, and
> > not have a host centric view of the scsi_devices.
> 
> I personally think it makes more sense to keep the host centric view of 
> devices, and for multipath the most I would do is add another list struct 
> for chaining together device structs that all point to the same device.

But no matter which way it goes, having an abastracted interface (callback
or whatever) makes it possible to use a host or non-host centric list of
scsi_devices.

The current scsi multi-path patch I have uses a list to chain together
paths to one scsi_device, not a scsi_device per path. If we have a
scsi_device per path, we have the overhead of duplicate block queues
(and lack of sorting/merging across queues), duplicated data in
a scsi_device, we have to figure out what scsi_device to use or expose
to user land, and passing errors into the block layer is difficult
(generally, externalizing the code/data contained in
scsi_decide_disposition).

-- Patrick Mansfield
