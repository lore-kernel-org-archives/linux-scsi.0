From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs cleanups
Date: Tue, 19 Nov 2002 16:46:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021120004632.GA2671@beaverton.ibm.com>
References: <20021119153008.GA1544@beaverton.ibm.com> <20021119164856.A11391@infradead.org> <20021119183908.GA1120@beaverton.ibm.com> <20021119231614.A27242@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021119231614.A27242@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Tue, Nov 19, 2002 at 10:39:08AM -0800, Mike Anderson wrote:
> > I was trying to ensure consistency and type checking of class_data used
> > by host of class type scsi-host.
> > 
> > In the device model the struct device contains three void pointers for
> > use by associated member. driver_data is a private data pointer for the
> > device driver. class_data is for use by the class in this case scsi-host
> > class.
> 
> Still the casts make no sense at all.  in C you can assign a void pointer
> to any other pointer and the other way around.
> 

Ok, I guess I misunderstood (read to fast) what your issue was on this. I
removed the casts.

> > 
> > The *device_driver* interfaces are possibly not needed any more as I
> > originally had them exported because they where being called directly by
> > the upper layers.  Now they are being called by the mid-layer which this
> > *.o is linked. In the future the upper layers could call these directly
> > as the operations in scsi_register_device are handled by the sysfs layer
> > if upper layers fully support the device model probe / remove / release.
> 
> But they shouldn't.  Each additional exported interface makes life harder.
> Please don't export stuff unless it's really required.
> 

I removed them.


> > The *host_class* are interfaces for the LLDD to call to register and
> > unregister as a scsi host class driver.
> > 
> > These interfaces are used in a scsi_debug patch I have beyond scsi_debug
> > 1.65 that demonstrate the used of these interfaces.
> 
> Again, see above.  What do these interfaces actually gain us over
> scsi_add_host/scsi_remove_host?  If it helps us in practice (of which I
> still need to be convienced) remove scsi_add_host/scsi_remove_host when
> exporting those, but don't keep both.
> 

The only issue with removing the scsi_add_host and scsi_remove_host and
replacing them with something like the *host_class* is that the host
class interfaces assume the caller has a struct device to pass in.
Currently there are callers of scsi_add_host that appear to not support
the new device model.

-andmike
--
Michael Anderson
andmike@us.ibm.com

