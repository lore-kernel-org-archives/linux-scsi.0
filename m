From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 13:38:58 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120133858.A15671@infradead.org>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:54533 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265501AbUATNjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 08:39:02 -0500
Content-Disposition: inline
In-Reply-To: <400C3E70.9040702@us.ibm.com>; from brking@us.ibm.com on Mon, Jan 19, 2004 at 02:30:40PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 19, 2004 at 02:30:40PM -0600, Brian King wrote:
> Would it be ok to rename the sysfs file to ipr_version so I have a way 
> to get this information until a better way comes along?

I'm not too happy.  Can't you just grep dmesg output like we do for other
drivers?

> IPR_IOCTL_READ_DRIVER_CFG, IPR_IOCTL_WRITE_DRIVER_CFG, 
> IPR_IOCTL_RUN_DIAGNOSTICS, IPR_IOCTL_RESET_IOA, 
> IPR_IOCTL_CHANGE_ADAPTER_ASSIGNMENT: these could be sysfs files.

Please change them over.

> IPR_IOCTL_PASSTHRU: Allows user space to build adapter/device commands 
> to send to the adapter. This includes RAID configuration, cache recovery 
> commands, etc. This ioctl allows me to push all the RAID configuration 
> complexity into userspace.

Ok, fine with me

> IPR_IOCTL_RUN_DIAGNOSTICS: This one could be a sysfs file.

See above.

> IPR_IOCTL_DUMP_IOA: This ioctl is called by a userspace daemon. When 
> called, it goes to sleep and waits (interruptibly) for a severe adapter 
> error to occur. When this happens, the driver "dumps" the adapter's 
> memory. After the adapter is reset, the daemon wakes up and writes the 
> dump file to the filesystem. The dump file is usually around 2-4Meg in 
> size.

Okay..


> IPR_IOCTL_GET_TRACE: This returns the driver's internal trace. This one 
> needs a buffer > 4k. I could create a binary sysfs file for it since, 
> AFAIK, this size limitation does not exist for binary sysfs files.

Please do.  Also what about making this and the above one conditional on
some debugging option?

> IPR_IOCTL_RECLAIM_CACHE: This is used to perform cache storage 
> reclaimation on the adapter. It takes parameters from userspace, sends a 
> command to the adapter, resets the adapter, then returns data to the user.

Okay..

> IPR_IOCTL_UCODE_DOWNLOAD: Used to update the microcode on the adapter 
> and on the physical disks in RAID arrays (these devices are not seen by 
> the SCSI midlayer). These microcode images are generally between 500k 
> and 1M in size.

Can't you use the request_firmware interface for that?

> > Okay, this isn't good at all.  A LLDD driver shouldn't care about mode
> > pages and all the stuff you do with it.  Please do it from userspace using
> > the sg driver.
> 
> Ok. Here are my reasons:
> 
> 1. First of all, this driver is setting up mode pages for devices 
> according to how the adapter requires them to be setup to run properly. 
> Arguably, the adapter should do this, but it doesn't.
> 
> 2. There are 2 types of devices that I setup mode pages for. The first 
> are generic SCSI disk devices. These are seen by the mid-layer and could 
> feasibly have their mode pages setup by userspace. But, the adapter 
> requires qerr=1 in order to run TCQing. So I am setting that up. If I 
> moved that into userspace, then I couldn't run TCQing until userspace 
> setup mode page 0x0A.

Doesn't sound to bad, does it?  Bootup ir hardly performance critical.

> The other type of device is a physical disk in a 
> RAID array. These devices are not seen by the mid-layer. The only way 
> for userspace to talk to them (at least in the current implementation) 
> is through the adapter ioctl interface discussed above. For these 
> devices, the adapter requires the mode pages to be setup as I am doing 
> in order to run reliably.

Given all the mess these invisble devices create I think they shouldn't
be invisble but rather exported as a second pseudo-channel on the host.

> > Can you explain what these vsets are supposed to do?  And why a scsi_scan quirk can't
> > be done instead of doing this in a LLDD?
> 
> I was expecting this one;) VSET stands for Volume Set. A VSET is a 
> logical disk created by the adapter firmware representing a disk array. 
> The reason a scsi_scan quirk does not work is because they also do not 
> have any reasonable product ID in their standard inquiry data to parse on.

Another reason why we should allow the driver setting quirk flags in
struct scsi_device in ->slave_alloc.  Unfortunately the patch from the usb
people to do it braindeadly in the host template got accepted instead.

> because I need to (ipr_std_inquiry). This stems from the fact that the 
> adapter will not start any new advanced function (RAID, adapter write 
> caching, etc) to a device until it is told by the system that the device 
> is a "supported device" by using the "set supported devices" command.
> 
> Complicated example: You have a RAID 5 disk array with n devices. One of 
> them fails. You put in a replacement device of a different type. In 
> order to be able to rebuild the disk array using the new device, the 
> adapter needs to have a set supported devices command sent down with the 
> vendor/product ID of the replacement device. An inquiry has to be done 
> to get this data.

Yikes.  I'd love to see designer of this hardware face by face..

Well, whats done is done and we can fix these fuckups now.  Can't you at
least do the inquiries from userland?

> > This looks very wrong.  And fortunately it seems to be only called from
> > code that is totally misplaced in a LLDD anyway.  All scsi commands
> > should go through the midlayer queueing.
> 
> It is primarily used when talking to devices not known to the mid-layer, 
> like the adapter itself, and devices that are in a disk array.


Well, you shouldn't do that.  We do in fact have interfaces to allocate
proper scsi device without registering them with the midlayer, currently
it's only used for the host itself (scsi_get_host_dev/scsi_free_host_dev),
but I don't see why this can't work for other devices.

> > Again, a LLDD is the very wrong place for something like that.
> > Is there a spec for that VSET stuff somewhere?
> 
> Unfortunately no. But I can answer any questions you might have. I 
> wasn't sure if this was an ok thing to do or not. The midlayer is 
> unconfiguring the device, it seemed reasonable that I should have the 
> adapter flush the write cache and stop talking to that logical device.

We should probably always send a STOP UNIT when unconfiguring devices
from the midlayer or and upper driver.

> Build a command in DMA'able host memory (struct ipr_ioarcb), write the 
> PCI address to a register on the adapter, the adapter DMAs down the 
> control block, executes the command, writes the 
> ipr_ioarcb.host_response_handle in the command control block to the host 
> request/response queue in host memory, and signals an interrupt.
> 
> Does that help at all?

What's the relation of all these command lists to that?

> > 
> > this should be handled by the midlayer per-device and per-host state bits.
> 
> I didn't realize a LLD was allowed to modify these.

Not directly.  But we have function to e.g. set a device offline.

