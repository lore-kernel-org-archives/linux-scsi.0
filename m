From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take
 2
Date: Mon, 06 Sep 2004 15:48:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413CE933.70509@us.ibm.com>
References: <413557CB.8010008@cs.wisc.edu> <20040901162042.GC26753@null.msp.redhat.com> <20040906143251.GB21646@lst.de> <20040906163336.GE642@parcelfarce.linux.theplanet.co.uk> <413CA924.8030904@cs.wisc.edu> <413CB265.3070304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:3808 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267408AbUIFWvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 18:51:37 -0400
In-Reply-To: <413CB265.3070304@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

Mike Christie wrote:

> Mike Christie wrote:
> 
>> Matthew Wilcox wrote:
>>
>>> On Mon, Sep 06, 2004 at 04:32:51PM +0200, Christoph Hellwig wrote:
>>>
>>>> On Wed, Sep 01, 2004 at 11:20:42AM -0500, AJ Lewis wrote:
>>>>
>>>>> Do we want all these attributes in the scsi_host class, or should 
>>>>> we put them
>>>>> in the iscsi devices directory?  So in 
>>>>> /sys/bus/iscsi-sfnet/devices/iscsi1 -
>>>
>>>
>>>
>>>
>>> Woah, woah, woah.  What's this "iscsi-sfnet" directory in sysfs?  That's
>>> just wrong. 
>>
>>
>>
>> It is only a pseudo bus for the driver from Christoph's suggestion,
>> that's just to make probing and removing of the driver's devices 
>> easier (it
>> looks like a normal scsi driver now).
> 
> 
> Oh yeah, just to add so you do not have to read through the entire thread.
> As you know struct device_driver's need a bus to attach devices through,
> so a scsi_host could have a pci_driver, parent pci_dev and the pci bus
> for this purpose. Since this driver is software the iscsi-sfnet bus and
> iscsi-sfnet driver are a virtual bus and driver to emulate what the pci
> bus does for normal drivers.
> 
> For my comment where I state we look like a normal scsi driver I just mean
> in our struct device_driver->probe we do the scsi_alloc/add_host() and 
> in our
> struct device_driver-?reomve we do the scsi_remove/put_host().

For bus usage and virtual drivers like this and scsi_debug, would it be 
better to just have a single virtual bus for all virtual drivers to 
share, or should we instead modify the scsi_bus so that it can handle 
ULD and virtual LLD struct device_driver attachments. Today, the 
scsi_bus seems to be used for upper layer drivers becuase they are the 
only ones needing to attach UL struct device_drivers to scsi devices, 
but instead of scsi_debug or iscsi-sfnet implementing its own virtual 
bus the scsi_bus could manage a low level virtual driver's scsi_host 
parent's devices.

Also, with James's patch we have scsi_devices and scsi_targets off the 
scsi_bus, does scsi_host's shost_gendev belong there too? What is the 
purpose of the scsi_bus?


> 
>>  No way is that crap going into the kernel.  We have to have
>>
>>> *one* iscsi infrastructure, not a dozen.
>>>
>>
>> Don't worry, there is no way we are going to put transport, scsi or
>> anything like that there. This driver will use the scsi-ml infrastucture
>> for sysfs and this includes using the transport classes. I think this 
>> comment
>> from AJ, was just in error when he was unaware of scsi-ml's transport 
>> classes.
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

