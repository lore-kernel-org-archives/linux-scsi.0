From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 08:27:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107162748.GB1292@beaverton.ibm.com>
References: <200211071532.HAA21625@freya.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211071532.HAA21625@freya.yggdrasil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@freya.yggdrasil.com>
Cc: hch@lst.de, linux-scsi@vger.kernel.org

Adam J. Richter [adam@freya.yggdrasil.com] wrote:
> Michael Anderson wrote:
> >The removal of detect should eventually result in other reductions /
> >cleaner code (If the sg binding issue can be resolved cleanly).
> 
> 	What makes you think that?  You need a way to ask "is this
> driver interested in this device" and that's all that the code
> remaining in scsi_device_template.detect() does after you remove the
> side effects (i.e., the counter incrementing), and it does so about as
> simply as possible.

If we support the device probe and remove interfaces then as a device is
registered with the scsi bus each drivers probe routine will be called
and if it wants the device it returns 0. 

If a driver is registered with the scsi bus post device probing then the
driver_attach routine will call bus_match and driver probe for all
devices on the bus not claimed by a driver.

> 
> 	I haven't looked at it closely, but there seems to be
> workaround in the generic device code for its inability to bind more
> than one driver to a device: struct device_interface, which seems to
> duplicate much of the generic driver interface but lacks
> device->driver_data, which we could compensate for by adding
> a field in struct scsi_device:
> 

I believed the device_interface was the answer also. scsi generic is even mentioned in the documentation. In talking with Mochel on this issue he disagreed and said that this was not the interface to use. 

The idea of a field in struct scsi_device seems like the right approach.
It is just that the device model needs a better bus symmetric interface to
handle cleanup and handling sg insmod / rmmod post device probing.

-andmike
--
Michael Anderson
andmike@us.ibm.com

