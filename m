From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs	take
 2
Date: Mon, 06 Sep 2004 19:46:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413D20F9.6000704@us.ibm.com>
References: <413557CB.8010008@cs.wisc.edu>	<20040901162042.GC26753@null.msp.redhat.com>	<20040906143251.GB21646@lst.de>	<20040906163336.GE642@parcelfarce.linux.theplanet.co.uk>	<413CA924.8030904@cs.wisc.edu> <413CB265.3070304@cs.wisc.edu> 	<413CE933.70509@us.ibm.com> <1094512278.1761.63.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:46827 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267509AbUIGCtt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 22:49:49 -0400
In-Reply-To: <1094512278.1761.63.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2004-09-06 at 18:48, Mike Christie wrote:
> 
>>For bus usage and virtual drivers like this and scsi_debug, would it be 
>>better to just have a single virtual bus for all virtual drivers to 
>>share, or should we instead modify the scsi_bus so that it can handle 
>>ULD and virtual LLD struct device_driver attachments. Today, the 
>>scsi_bus seems to be used for upper layer drivers becuase they are the 
>>only ones needing to attach UL struct device_drivers to scsi devices, 
>>but instead of scsi_debug or iscsi-sfnet implementing its own virtual 
>>bus the scsi_bus could manage a low level virtual driver's scsi_host 
>>parent's devices.
>>
>>Also, with James's patch we have scsi_devices and scsi_targets off the 
>>scsi_bus, does scsi_host's shost_gendev belong there too? What is the 
>>purpose of the scsi_bus?> 
> 
> 
> Using a virtual bus only makes sense when you actually have multiple
> virtual drivers that need to attach.  Thus, we only have one virtual
> scsi bus (scsi_bus_type) and it's only used for the generic device
> embedded in struct scsi_device.  We use it only to attach the various
> ULDs.  The host and target devices just have a null bus.

In that first target patch you sent it had the target dev's bus set to 
scsi_bus_type. That caused my confusion as to what the bus was for. I 
see the new patch with this removed. Nevermind.

> I'm not quite sure what you want to use another bus type for?  It sounds
> like you really want to be using a device class instead.  The difference
> is
> 
> - classes provide (potentially multiple) interfaces to existing devices;
> - busses are used for keeping track of attached devices and matching
> them to their drivers.
> 
> Unless you really have a use for device matching and driver attachment,
> you probably just want to stick with classes.
> 

We just needed something to track the driver's scsi_hosts. It was also 
used becuase we used a struct device_driver to hang setup attributes 
(non iscsi related attrs needed to setup our driver's devices without an 
ioctl) off of like scsi_debug (this is why I asked about a single 
virtual bus for both of us to share).

Since we followed the suggestion to do a host per transport endpoint 
when we rmmod the driver we just need some way to loop over every 
scsi_host and free them up. We had a linked list of scsi_hosts. 
Christoph suggested a class or bus instead of the linked list, and had 
preferred the bus. Now you are suggesting to use a class. It wouldn't be 
ok to go back to the single host would it? In that case we would not 
need a class, bus, or linked list?
