From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 7 Jan 2003 14:53:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107145300.A16954@beaverton.ibm.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <20030107194445.GC11402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030107194445.GC11402@redhat.com>; from dledford@redhat.com on Tue, Jan 07, 2003 at 02:44:45PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 02:44:45PM -0500, Doug Ledford wrote:
> On Tue, Jan 07, 2003 at 10:21:27AM -0800, Patrick Mansfield wrote:

> > For use with multi-path, it is very useful to have the path in the
> > scsi_cmnd, and generally to not have the lldd's know about the scsi_device
> > at all, such that we can pick a path, and send a scsi_cmnd to a lldd.
> > 
> > Putting path information only in scsi_device makes it hard to do
> > multi-path below (or even in) the block layer, and makes it hard to
> > multi-path non block devices (like tape).
> 
> Not true at all.  This is completely an implementation issue.  If you 
> implement scsi multipath in certain ways, then this is true.  My preferred 
> implementation for something like this wouldn't have this problem at all.  
> My preferred implementation would have one scsi_device struct per path, 
> but would only register the first/primary device with the block layer (or 
> char layer as the case may be), and during scsi_scan detection the 
> duplicate paths would be added to the primary path by using a list_struct 
> item to link the devices.  Then you pick the path by picking the device 
> struct you need.  The primary path goes away, you change the device 
> registration to point to a new primary path scsi_device struct.  So I 
> don't see the difficulty at all myself.

The hard part is making sure all of the references to scsi_device values
are OK - that we correctly use and set the values across all of the
scsi_devices that represent a single scsi device. It would be easy for a
LLDD to screw this up, unless we have some sort of interface to get/set
every value in scsi_device.

Plus we have the overhead of redundant data for the fields: type,
scsi_level, inquiry, vendor, etc.

And the atomic device_active might have to be re-done with SMP locking.

I'm arguing for a linked list of structs that hold the minimum data we
need to use them as a path - much like a scsi_device with the redundant
fields removed (and if needed it can also point to the actual
scsi_device). And then plugging this data (or a pointer) into a scsi_cmnd
for use by the LLDD.

> > I would prefer we keep the current scsi_cmnd with its
> > host/channel/target[id]/lun.
> 
> One of the goals of this change is to eliminate scsi_build_commandblocks() 
> entirely and do away with keeping a per-device list of pre-allocated and 
> pre-filled in commands.  We could put the data items back into the struct, 
> but that would then mean that scsi_get_command() would have to init the 
> items from the device struct in question, then the lldd would init their 
> command from these items.  In short, it would save us having to change all 
> the lldd (which Luben has already done), but would cost us double init'ing 
> items for no real purpose.  I would prefer to leave them out.

As long as we have an interface (function or macro), I'm not strongly
opposed to the above. We can keep the scsi_allocate_device (in dire need
of a new name), and just have it allocate and init (or not) any fields as
needed, so there is only one place to change the init of the allocated
scsi_cmnd.

Adding a new interface to get the host/channel/target/lun is not so easy,
but IMO worthwhile.

-- Patrick Mansfield
