From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH][RFC] get rid of global array and ->init in sd.c and sr.c
Date: Wed, 23 Oct 2002 10:17:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021023171729.GA1048@beaverton.ibm.com>
References: <20021022210739.A10079@lst.de> <20021023082853.GA9341@beaverton.ibm.com> <20021023171131.A17312@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021023171131.A17312@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, axboe@suse.dk, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> On Wed, Oct 23, 2002 at 01:28:53AM -0700, Mike Anderson wrote:
> > Looks good. I ran it on a system with ips, aic, scsi_debug and qla2x00
> > as a module. 
> > 
> > When I applied the patch I got a quite a few rejects on sd.c and sr.c. I
> > fixed up sd.c, but did not run sr.c. My view is based off James
> > scsi-misc-2.5.
> > 
> > I noticed the patch seems to include some of your driver_register
> > removals (preiously posted) in init_sd and exit_sd, but there are no
> > adds to scsi_register_device or scsi_unregister_device.
> 
> The patch is again 2.5.44 + my previous two patch (devicefs stuff
> and ->finish removal).

ok. Sorry I did not comment on that previous device model cleanup. I do
have a couple comments now though.

In scsi_register_device (which we should probably rename to
scsi_bus_register_driver) we could just call
driver_register(&tpnt->scsi_driverfs_driver).

In the upper levels just do something like this:

.
.
.
	.init_command   = sd_init_command,
        .scsi_driverfs_driver {
	.name   = "sd",
	.bus    = &scsi_driverfs_bus_type,
	.probe  = sd_probe,
	.remove = sd_remove, },

We can also remove .tag from the template.


This gives more flexibility to the upper levels in-case they need to add
to there driver template.


-andmike
--
Michael Anderson
andmike@us.ibm.com

