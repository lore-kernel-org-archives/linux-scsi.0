From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 10:56:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107185617.GA3297@beaverton.ibm.com>
References: <200211071747.JAA29988@adam.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211071747.JAA29988@adam.yggdrasil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: hch@lst.de, linux-scsi@vger.kernel.org

Adam J. Richter [adam@yggdrasil.com] wrote:
> 	I know you can do driver matching with or without bus_type.match().

Well you at least need a match function or device_attach / driver_attach
will do nothing.

> 
> 	I would prefer bus_type.match because it slightly reduces the
> overhead of another patch that I posted to the generic device code:
> two fields in struct device_driver for having the generic device layer
> do the initial kmalloc and dma_alloc_consistent for the device (and do
> the failure if these allocations fail).  This can greatly reduce the
> number of rarely tested error branches (e.g., alloc_disk failure in
> st.c does not free buffer) because of the number of drivers that can
> be cleaned up a bit by it: hundreds of drivers, thousands of lines of
> code.
> 
> 	Without ->match(), these changes would result in some unnecessary
> memory allocations and frees, and a lot of unncessary memory traffic as
> I have the initial kmalloc zero filling the memory that it allocates.
> 

I am sorry I have not looked at your previous patch, but are you saying
you want to do allocations in the match routine. If so what is your bus
based cleanup entry point. The bus_type lacks a add_device /
remove_device call like device_class.


> >I believed the device_interface was the answer also. scsi generic is even mentioned \
> >in the documentation. In talking with Mochel on this issue he disagreed and said that \
> >this was not the interface to use. 
> 
> 	I'd be interested in knowing what reasons he gave.
> 

In the previous conversation I thought device_interface was the answer
for sg so I went over to talk with Mochel. If I remember correctly the
current implementation of interfaces being tied to device_classes was
not right for sg. The sg driver can only be bound to one class that
would lead to all scsi devices ending up in one class and not a more
specific class (i.e. disks, tapes, etc.).

I could have the reason wrong, but the answer was this was not the api
to use.

I will ask the question again in a new thread and I know Mochel can
give a better answer.

> >The idea of a field in struct scsi_device seems like the right approach.
> >It is just that the device model needs a better bus symmetric interface to
> >handle cleanup and handling sg insmod / rmmod post device probing.
> 
> 	Hmm, I'm not sure if this is what you're referring to, but it
> looks like in 2.5.46, register_interface never walks the list of
> devices that were already registered, and unregister_interface never
> walks that list either (that is, intf->add_device is only called when
> a new device is registered after the interface is loaded).  I wonder
> if that difference in comparison to device_driver is intentional.

This is a good point, but in my previous statment I was talking about
how the bus does not have the add / remove callbacks like the
device_class.

I might not be intentional as some issues we ran into on cleanup where
just bugs / not implemented yet.

-andmike
--
Michael Anderson
andmike@us.ibm.com

