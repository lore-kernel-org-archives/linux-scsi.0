From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 06:25:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107142525.GA1292@beaverton.ibm.com>
References: <200211071225.EAA29497@adam.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211071225.EAA29497@adam.yggdrasil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: hch@lst.de, linux-scsi@vger.kernel.org

Adam J. Richter [adam@yggdrasil.com] wrote:
> 	I think we can get cleaner code by *not* doing that.
> 
> 	If we keep Scsi_Device_Template.detect and just change it so
> that it has no side effects like incrementing a counter, then we can
> shrink scsi_bus_match, previously a list of special cases, like so
> (just typed this code in, haven't tried to compile it):
> 
> 
> static int scsi_bus_match(struct device *dev, struct device_driver *drv)
> {
> 	struct Scsi_Device_Template *scsi_dev_tmpl =
> 		container_of(drv, struct Scsi_Device_Template,
> 			     scsi_driverfs_driver);
> 	struct Scsi_Device_Template *scsi_dev =
> 		container_of(dev, struct Scsi_Device, sdev_driverfs_dev);
> 
> 	return (*scsi_dev_templ->detect)(scsi_dev);
> }

I believe the second container_of should be assigned to a struct scsi_device*.

If you got it to compile it should result in some unexpected behavior.

The reason scsi_bus_match is not clean is that scsi currently does not
follow the device model correctly. We currently allow multiple object
types on the scsi bus device list. This means your second container_of
may not be operating on a struct scsi_device object.

The multiple objects in the scsi bus device list is the result of some
mis-placed nodes and trying to work around the one driver to one device
binding issue. In scsi if sg is loaded a scsi device can have up to 2
drivers (i.e. sg + sd, etc).

The removal of detect should eventually result in other reductions /
cleaner code (If the sg binding issue can be resolved cleanly). Scsi can
then move to device model probe and remove routines and the elimination
of the scsi_devicelist.

I have ran a patch on top of Christoph's previous set that renamed
sd_attach and sd_detect to sd_probe and sd_remove. The old sd_attach and
sd_detect need to just take a struct device *dev and do a
to_scsi_device. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

