From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 09:47:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071747.JAA29988@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org

Michael Anderson wrote:
>Adam J. Richter [adam@freya.yggdrasil.com] wrote:
>> Michael Anderson wrote:
>> > The removal of detect should eventually result in other reductions /
>> > cleaner code (If the sg binding issue can be resolved cleanly).
>> 
>>       What makes you think that?  You need a way to ask "is this
>> driver interested in this device" and that's all that the code
>> remaining in scsi_device_template.detect() does after you remove the
>> side effects (i.e., the counter incrementing), and it does so about as
>> simply as possible.
>
>If we support the device probe and remove interfaces then as a device is
>registered with the scsi bus each drivers probe routine will be called
>and if it wants the device it returns 0. 
>
>If a driver is registered with the scsi bus post device probing then the
>driver_attach routine will call bus_match and driver probe for all
>devices on the bus not claimed by a driver.

	I know you can do driver matching with or without bus_type.match().

	I would prefer bus_type.match because it slightly reduces the
overhead of another patch that I posted to the generic device code:
two fields in struct device_driver for having the generic device layer
do the initial kmalloc and dma_alloc_consistent for the device (and do
the failure if these allocations fail).  This can greatly reduce the
number of rarely tested error branches (e.g., alloc_disk failure in
st.c does not free buffer) because of the number of drivers that can
be cleaned up a bit by it: hundreds of drivers, thousands of lines of
code.

	Without ->match(), these changes would result in some unnecessary
memory allocations and frees, and a lot of unncessary memory traffic as
I have the initial kmalloc zero filling the memory that it allocates.

	I'll address Christoph's point about bus_type.match() being
"racy" in a separate messsage.

	By the way, I also have other changes in my tree that I posted
ages ago that allows SCSI drivers to have the upper scsi layer
automatically set up the DMA mappings for each request's
scatter-gather list and/or sense buffer, along with a trivial change
that recasts non-gather-scatter requests as gather-scatter.  I also
have a trivial routine to clean up walking gather-scatter lists in
non-DMA drivers.  I was able to shrink a bunch of drivers with these
SCSI-specific facilities a year ago.  I want to move the sglist
mapping stuff up to the block layer and also add a facility for the
consistent DMA memory pool of stubs used to make the hardware-specific
gather-scatter lists.  Together, I believe these facilities will shrink
Linux devices dramatically.

[...]
>I believed the device_interface was the answer also. scsi generic is even mentioned \
>in the documentation. In talking with Mochel on this issue he disagreed and said that \
>this was not the interface to use. 

	I'd be interested in knowing what reasons he gave.

>The idea of a field in struct scsi_device seems like the right approach.
>It is just that the device model needs a better bus symmetric interface to
>handle cleanup and handling sg insmod / rmmod post device probing.

	Hmm, I'm not sure if this is what you're referring to, but it
looks like in 2.5.46, register_interface never walks the list of
devices that were already registered, and unregister_interface never
walks that list either (that is, intf->add_device is only called when
a new device is registered after the interface is loaded).  I wonder
if that difference in comparison to device_driver is intentional.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
