From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Thu, 7 Nov 2002 08:41:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107164152.GD1292@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107182947.B15350@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@sgi.com>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@sgi.com] wrote:
> On Wed, Nov 06, 2002 at 11:39:43PM -0800, Mike Anderson wrote:
> > +	.scsi_driverfs_driver   = {
> > +		.name   = "sd",
> > +	},
> 
> can we changhe scsi_driverfs_driver to something saner? E.g. gen_driver?
> 

ok.

I did have some name changes previous, but pulled them out to reduce
collisions with the patches going on in this area.

Though my below renaming is not consitant with this thought :-).

> >  static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
> > @@ -1346,7 +1349,7 @@
> >  	if (!majors)
> >  		return -ENODEV;
> >  
> > -	rc = scsi_register_device(&sd_template);
> > +	rc = scsi_bus_driver_register(&sd_template);
> 
> Umm, no.  We don't register a bus.  Just leave the name unchanged until
> we there is some commonly agreed upon upper layer terminology.

Well we are registering a driver with the device model scsi_bus (i.e a
driver_register on scsi_bus_type).

Could we agree on terminology now as I believe scsi_register_device is
mis-leading for others reading the scsi code as it is a driver not a
device?

-andmike
--
Michael Anderson
andmike@us.ibm.com

