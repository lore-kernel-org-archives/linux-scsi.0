From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][RFC] get rid of global array and ->init in sd.c and sr.c
Date: Thu, 24 Oct 2002 02:50:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024025030.A20656@lst.de>
References: <20021022210739.A10079@lst.de> <20021023082853.GA9341@beaverton.ibm.com> <20021023171131.A17312@lst.de> <20021023171729.GA1048@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021023171729.GA1048@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Oct 23, 2002 at 10:17:29AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, axboe@suse.dk, linux-scsi@vger.kernel.org

On Wed, Oct 23, 2002 at 10:17:29AM -0700, Mike Anderson wrote:
> ok. Sorry I did not comment on that previous device model cleanup. I do
> have a couple comments now though.
> 
> In scsi_register_device (which we should probably rename to
> scsi_bus_register_driver) we could just call
> driver_register(&tpnt->scsi_driverfs_driver).
> 
> In the upper levels just do something like this:
> 
> .
> .
> .
> 	.init_command   = sd_init_command,
>         .scsi_driverfs_driver {
> 	.name   = "sd",
> 	.bus    = &scsi_driverfs_bus_type,
> 	.probe  = sd_probe,
> 	.remove = sd_remove, },
> 
> We can also remove .tag from the template.
> 
> 
> This gives more flexibility to the upper levels in-case they need to add
> to there driver template.

Looks fine to me.  I'll do that once the driverfs/sysfs changes
settle down a bit.

