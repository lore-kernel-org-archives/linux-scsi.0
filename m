From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Thu, 7 Nov 2002 18:21:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108022158.GD1292@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com> <20021107164152.GD1292@beaverton.ibm.com> <20021108012047.A17391@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021108012047.A17391@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Thu, Nov 07, 2002 at 08:41:52AM -0800, Mike Anderson wrote:
> > > > -	rc = scsi_register_device(&sd_template);
> > > > +	rc = scsi_bus_driver_register(&sd_template);
> > > 
> > > Umm, no.  We don't register a bus.  Just leave the name unchanged until
> > > we there is some commonly agreed upon upper layer terminology.
> > 
> > Well we are registering a driver with the device model scsi_bus (i.e a
> > driver_register on scsi_bus_type).
> 
> We register a scsi upperlayer driver with the midlayer, we don't care
> about the implementation, and it's certainly not a bus.  I do btw
> disagree strongly with using the device model bus type for upper level
> drivers.  We have a bus in scsi, and that's the connection between the
> HBA and the devices.  To make any sense out of the device model these
> devices must be childs of the HBA.
> 

Is the disagreement the function name, bus name, or the concept of
registering these drivers with sysfs?

I know the model is not an exact fit, but if we want to use the sysfs
infrastructure all drivers must be associated with a bus. HBAs belong to
there parent bus. They can have associations which I added in this patch
to create a scsi-host class. We cannot create a bus under the HBA. All
buses are default set to a parent of bus_subsys.

The /bus/scsi is a logical bus (an aggregation of all scsi buses). The
upperlayer drivers are the only drivers that should show up under
/bus/scsi/drivers and the only drivers that can bind with scsi_devices.  

In this patch I did remove the extra node that the devices where setting
under and now the scsi devices are children of the HBA. The
/bus/scsi/devices are only links to child devices of the HBA.

> > Could we agree on terminology now as I believe scsi_register_device is
> > mis-leading for others reading the scsi code as it is a driver not a
> > device?
> 
> The device terminology in scsi is misleading but it's used at least
> consistantly.  Feel free to submit a patch that changes it to upper
> or something like that once scsi settles down a bit before 2.6.
> 

Well I wanted to name scsi_bus_driver_register something other than
scsi_register_device as I am calling scsi_register_device from this
function so that if we get probe / remove working only the internals of
this function need to change (while that is not exactly true there will
need to be small changes in the upper also). 

Do you see a problem with "scsi_upper_driver_register" being added now?

-andmike
--
Michael Anderson
andmike@us.ibm.com

