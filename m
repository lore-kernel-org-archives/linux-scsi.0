From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Fri, 8 Nov 2002 01:20:47 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108012047.A17391@infradead.org>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com> <20021107164152.GD1292@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107164152.GD1292@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Nov 07, 2002 at 08:41:52AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 08:41:52AM -0800, Mike Anderson wrote:
> > > -	rc = scsi_register_device(&sd_template);
> > > +	rc = scsi_bus_driver_register(&sd_template);
> > 
> > Umm, no.  We don't register a bus.  Just leave the name unchanged until
> > we there is some commonly agreed upon upper layer terminology.
> 
> Well we are registering a driver with the device model scsi_bus (i.e a
> driver_register on scsi_bus_type).

We register a scsi upperlayer driver with the midlayer, we don't care
about the implementation, and it's certainly not a bus.  I do btw
disagree strongly with using the device model bus type for upper level
drivers.  We have a bus in scsi, and that's the connection between the
HBA and the devices.  To make any sense out of the device model these
devices must be childs of the HBA.

> Could we agree on terminology now as I believe scsi_register_device is
> mis-leading for others reading the scsi code as it is a driver not a
> device?

The device terminology in scsi is misleading but it's used at least
consistantly.  Feel free to submit a patch that changes it to upper
or something like that once scsi settles down a bit before 2.6.

