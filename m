From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Wed, 08 Jan 2003 12:33:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1C60D5.2070805@splentec.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <20030107194445.GC11402@redhat.com> <20030107145300.A16954@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
 >
> The hard part is making sure all of the references to scsi_device values
> are OK - that we correctly use and set the values across all of the
> scsi_devices that represent a single scsi device. It would be easy for a
> LLDD to screw this up, unless we have some sort of interface to get/set
> every value in scsi_device.

An LLDD cannot screw up.  It will be fixed in the testing phase and
given that so many eyes will check it out before it is even considered.
Plus, vendors usually test LLDDs long before they are considered
into a test tree.

> Plus we have the overhead of redundant data for the fields: type,
> scsi_level, inquiry, vendor, etc.

Implementation issue.

> And the atomic device_active might have to be re-done with SMP locking.

Implementation issue.

> I'm arguing for a linked list of structs that hold the minimum data we
> need to use them as a path - much like a scsi_device with the redundant
> fields removed (and if needed it can also point to the actual
> scsi_device). And then plugging this data (or a pointer) into a scsi_cmnd
> for use by the LLDD.

This may be an easier approach, but a scsi_cmnd stands for SCSI command.

Its a good thing to have multipathing represented as an ADT (abstract
data type).  Say something like a linked list of structs with
cost/weight member and a pointer to an actual low-level device (the infrastructure
will be more involved since multipathing will need to be notified
when a device goes away, but read further...).  Now this ADT may be embeded
into a block device and char device structs -- i.e. highest hierarchy.
(The assumption is that there won't be a device which will present
a char and block interface at the same time.)

Now since this ADT is embeded into the block/char device, we do get
notification when it goes away. So this should be ok.

The effect is that when write(fd, buf, count) is done, somewhere along
the way *before* the actual physical device (ide,scsi,etc) is referenced
multipathing has already been accomplished.  This preserves as much as possible
the current infrastructure of the kernel.

So when a low-level device (LLD) says that it cannot satisfy the request,
you *may* try another path.

In effect a low-level device *as seen from the multipath code* is the tuple
(PATH, DEVICE), and this is where a request is sent, i.e. to the tuple
(PATH, DEVICE). Where for each PATH, there can be exactly one DEVICE, since
a PATH describes a device (or access to it), but the opposite is not necessarily
true. I.e. for each DEVICE there can be zero/one to many PATHs.

> As long as we have an interface (function or macro), I'm not strongly
> opposed to the above. We can keep the scsi_allocate_device (in dire need
> of a new name), and just have it allocate and init (or not) any fields as
> needed, so there is only one place to change the init of the allocated
> scsi_cmnd.

The SCSI Core has a well-defined funtion. I'm not so sure that we
should muck it up with other well-defined functions, like multipathing.

> Adding a new interface to get the host/channel/target/lun is not so easy,
> but IMO worthwhile.

Changing all LLDD, SCSI Core, usb storage, message/fusion to use
cmd->device->{lun, id, channel, host} and scsi_get_command(),
scsi_put_command(), scsi_getset_command() was also not easy, but
doable.

There, you have a project. Please note, that this is only worthwhile
if multipathing is to go into SCSI Core.

It is *inevitable* that multipathing will be moved up into the
generic device char and block structs; sooner or later.

-- 
Luben


