From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 10:41:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400D5A28.1000301@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:46510 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265463AbUATQmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 11:42:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>Would it be ok to rename the sysfs file to ipr_version so I have a way 
>>to get this information until a better way comes along?
> 
> 
> I'm not too happy.  Can't you just grep dmesg output like we do for other
> drivers?

Probably. Rusty already has a patch for MODULE_VERSION, so it sounds 
like we might have this function in a reasonable amount of time.

>>IPR_IOCTL_READ_DRIVER_CFG, IPR_IOCTL_WRITE_DRIVER_CFG, 
>>IPR_IOCTL_RUN_DIAGNOSTICS, IPR_IOCTL_RESET_IOA, 
>>IPR_IOCTL_CHANGE_ADAPTER_ASSIGNMENT: these could be sysfs files.
> 
> Please change them over.

Done.

>>IPR_IOCTL_GET_TRACE: This returns the driver's internal trace. This one 
>>needs a buffer > 4k. I could create a binary sysfs file for it since, 
>>AFAIK, this size limitation does not exist for binary sysfs files.
> 
> 
> Please do.  Also what about making this and the above one conditional on
> some debugging option?

How about a kernel config option for this? I don't want to make it too 
difficult for people to enable it as it is exceedingly valuable for 
failure analysis.

>>IPR_IOCTL_UCODE_DOWNLOAD: Used to update the microcode on the adapter 
>>and on the physical disks in RAID arrays (these devices are not seen by 
>>the SCSI midlayer). These microcode images are generally between 500k 
>>and 1M in size.
> 
> 
> Can't you use the request_firmware interface for that?

I'll look into this again.

>>>Okay, this isn't good at all.  A LLDD driver shouldn't care about mode
>>>pages and all the stuff you do with it.  Please do it from userspace using
>>>the sg driver.
>>
>>Ok. Here are my reasons:
>>
>>1. First of all, this driver is setting up mode pages for devices 
>>according to how the adapter requires them to be setup to run properly. 
>>Arguably, the adapter should do this, but it doesn't.
>>
>>2. There are 2 types of devices that I setup mode pages for. The first 
>>are generic SCSI disk devices. These are seen by the mid-layer and could 
>>feasibly have their mode pages setup by userspace. But, the adapter 
>>requires qerr=1 in order to run TCQing. So I am setting that up. If I 
>>moved that into userspace, then I couldn't run TCQing until userspace 
>>setup mode page 0x0A.
> 
> 
> Doesn't sound to bad, does it?  Bootup ir hardly performance critical.

I'll get started on this.

>>The other type of device is a physical disk in a 
>>RAID array. These devices are not seen by the mid-layer. The only way 
>>for userspace to talk to them (at least in the current implementation) 
>>is through the adapter ioctl interface discussed above. For these 
>>devices, the adapter requires the mode pages to be setup as I am doing 
>>in order to run reliably.
> 
> 
> Given all the mess these invisble devices create I think they shouldn't
> be invisble but rather exported as a second pseudo-channel on the host.

Ok. That would solve a lot of problems. I will report these devices in 
as scsi disk devices. They will respond like normal SCSI disks, except 
when issued media commands (read/write) it will fail with data protect 
(07) sense data.


>>because I need to (ipr_std_inquiry). This stems from the fact that the 
>>adapter will not start any new advanced function (RAID, adapter write 
>>caching, etc) to a device until it is told by the system that the device 
>>is a "supported device" by using the "set supported devices" command.
>>
>>Complicated example: You have a RAID 5 disk array with n devices. One of 
>>them fails. You put in a replacement device of a different type. In 
>>order to be able to rebuild the disk array using the new device, the 
>>adapter needs to have a set supported devices command sent down with the 
>>vendor/product ID of the replacement device. An inquiry has to be done 
>>to get this data.
> 
> 
> Yikes.  I'd love to see designer of this hardware face by face..
> 
> Well, whats done is done and we can fix these fuckups now.  Can't you at
> least do the inquiries from userland?

Yes. Should be able to. By getting rid of all this code, one problem we 
will need to solve is the following:

1. Driver is up and running with a disk array.
2. Adapter gets reset for some reason (could be due to an adapter error)
3. Disk array device now needs a START_UNIT command.

The current mid-layer/sd will not handle this. Would you accept a patch 
to add this function?

>>>This looks very wrong.  And fortunately it seems to be only called from
>>>code that is totally misplaced in a LLDD anyway.  All scsi commands
>>>should go through the midlayer queueing.
>>
>>It is primarily used when talking to devices not known to the mid-layer, 
>>like the adapter itself, and devices that are in a disk array.
> 
> Well, you shouldn't do that.  We do in fact have interfaces to allocate
> proper scsi device without registering them with the midlayer, currently
> it's only used for the host itself (scsi_get_host_dev/scsi_free_host_dev),
> but I don't see why this can't work for other devices.

Ok, but I will still need that interface to send commands directed to 
the adapter. There is an entire sequence of commands that needs to be 
sent to the adapter before it can accept commands. If the adapter gets 
reset asynchronously at runtime due to an error, I need to be able to 
block mid-layer requests, reset the adapter, send a bunch of commands to 
the adapter, then unblock. I should be able to get rid of all the code 
that sends commands to scsi devices, though.

>>>Again, a LLDD is the very wrong place for something like that.
>>>Is there a spec for that VSET stuff somewhere?
>>
>>Unfortunately no. But I can answer any questions you might have. I 
>>wasn't sure if this was an ok thing to do or not. The midlayer is 
>>unconfiguring the device, it seemed reasonable that I should have the 
>>adapter flush the write cache and stop talking to that logical device.
> 
> We should probably always send a STOP UNIT when unconfiguring devices
> from the midlayer or and upper driver.

Sounds reasonable.

>>Build a command in DMA'able host memory (struct ipr_ioarcb), write the 
>>PCI address to a register on the adapter, the adapter DMAs down the 
>>control block, executes the command, writes the 
>>ipr_ioarcb.host_response_handle in the command control block to the host 
>>request/response queue in host memory, and signals an interrupt.
>>
>>Does that help at all?
> 
> What's the relation of all these command lists to that?

Sorry, I guess I'm missing something here. Are you saying a LLD 
shouldn't need to maintain of queue of its command blocks (like my 
pending_q and free_q)?

>>>this should be handled by the midlayer per-device and per-host state bits.
>>
>>I didn't realize a LLD was allowed to modify these.
> 
> Not directly.  But we have function to e.g. set a device offline.

Not in 2.6.1. I think this was in, then removed at some point. Anyone 
know the story on why it was removed? Should we have a 
scsi_set_host_offline as well?


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

