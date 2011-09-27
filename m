From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC] Pass information about device open/close to low-level driver
Date: Tue, 27 Sep 2011 09:19:30 +0200
Message-ID: <4E817902.3050605@redhat.com>
References: <Pine.LNX.4.44L0.1109261543240.1773-100000@iolanthe.rowland.org> <20110926201216.GA18666@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1I0HTr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2011 03:19:47 -0400
In-Reply-To: <20110926201216.GA18666@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 09/26/2011 10:12 PM, Christoph Hellwig wrote:
> On Mon, Sep 26, 2011 at 04:10:32PM -0400, Alan Stern wrote:
>> James:
>>
>> Something like the patch below has been requested by the virtualization
>> people.
>
> Who are "the virtualization people"?
>
> Either way this idea is a really bad one, and if you check history long
> enough you'd notice we had all that crap in kernel before 2.6 and got
> rid of it all.

That would be me. A small correction to Alan's reply to this I'm not
in contact with vmware about this although I'm sure they would like to
have this functionality too.

The problem these patches try to address is that currently it is possible
to disconnect a usb device driver from a usb device through usbfs / the unbind
sysfs attribute, making the device driver see the device in essence get
unplugged. There is no way for the driver to cancel this, since it is just
like a real unplug.

However since this is a software disconnect not a hardware disconnect it
would be very convenient if the driver could say, no not right now I'm busy.

The use case for this is redirection of usb devices to virtual machines. I'm
working on this for qemu and qemu+spice, when a usb device on a linux host /
linux spice client gets redirected to a vm, we currently start by making
a disconnect ioctl to the usbfs device node, to detach the kernel driver
so that qemu or the spice client can take over the device. This causes
problems when a user first copies a bunch of large files to a usb stick, and
then immediately afterwards selects redirect this usb stick to the vm.
Usually the user does this without first unmounting the stick. So the usb mass
storage driver (and the scsi subsystem after it) see a device disconnect while
some buffered writes still needed flushing -> not good!

For use cases where userspace takes over from a kernel device driver it would
be very nice if userspace could ask the kernel driver nicely to disconnect,
for this a new try_disconnect ioctl would be added to the usbfs ioctls.

In order for the usb mass storage driver to implement this try_disconnect, it
needs to know if its "downstream" scsi devices are in use or not, that is what
this patch is for.

There have already been a lot of discussions on other lists about this, so
let me try to address this biggest complaint against this patch set so far:
"why not do this in userspace".

4 reasons:
1) This is hardware resource management, hw resource management is the kernels task
2) It cannot be done race free in userspace, one can parse sysfs, figure out which
    block devices belong to the usb device, and see if they are mounted, but between
    the check and the disconnect ioctl they may get mounted
3) One needs to not only check for mounts but also for fsck / mkfs / fdisk on
    the block device nodes, this means parsing lsof output for all processes,
    something the userspace process in question likely will not have the rights
    for
4) If you look at the entirety of the patchset Alan posted for this it is quite small
    the code to implement 2 + 3 *which won't even work properly* will be one or more
    orders larger and more complex

Thanks & Regards,

Hans
