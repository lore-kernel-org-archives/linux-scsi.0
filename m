From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 10:42:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071842.KAA30050@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: andmike@us.ibm.com, hch@lst.de, linux-scsi@vger.kernel.org

>adam@yggdrasil.com said:
>> 	I would prefer bus_type.match because it slightly reduces the
>> overhead of another patch that I posted to the generic device code:
>> two fields in struct device_driver for having the generic device layer
>> do the initial kmalloc and dma_alloc_consistent for the device (and do
>> the failure if these allocations fail).  This can greatly reduce the
>> number of rarely tested error branches (e.g., alloc_disk failure in
>> st.c does not free buffer) because of the number of drivers that can
>> be cleaned up a bit by it: hundreds of drivers, thousands of lines of
>> code. 

>This worries me: dma_alloc_consistent will always fail on fully incoherent 
>architectures (like some PA-RISC ones), then you have to fall back to doing 
>the writeback, invalidates in the driver (which we can't abstract out because 
>the only the driver knows the sync points).  You can't really treat 
>dma_alloc_consistent failure as anything other than an indication that you 
>have to use a different dma access method.

>Since dma_alloc_consistent cannot properly fail on an x86 (unless 
>__get_free_pages does), do we really want to clutter up the main line with 
>lots of fallbacks that would be useless on the predominant architecture?

	All of the drivers that I've looked at abort if the initial
pci_alloc_consistent fails.  Those are the drivers that I had in mind
to use this facility.

	I'd be interested in pointers to drivers that soldier on after
{pci,sbus}_alloc_consistent fails (I think those are the only two
versions in 2.5.46).

	Bear in mind that these things are optional facilities, so
drivers that do not want to use them do not have to.

	If there really are a number of device drivers that want to
be able to continue on if the initial dma_alloc_consistent fails,
especially if they all do the same thing, like, say, try vmalloc,
then, yes I would like add a flag to support and a flag in struct
device or something to communicate the result of the memory allocation,
rather than have the same logic replicated over N device drivers.
It could be conditionally compiled and probably put into a separate
inline routine in drivers/base/bus.c if needed for cleanliness.

	Sorry I don't have time to write a more detailed response.  I
have to leave now and may not have much internet access for the next
ten days.  So, please excuse me if I'm not able to respond further for
a while.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
