From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][RFC] get rid of global array and ->init in sd.c and sr.c
Date: Wed, 23 Oct 2002 17:11:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021023171131.A17312@lst.de>
References: <20021022210739.A10079@lst.de> <20021023082853.GA9341@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021023082853.GA9341@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Oct 23, 2002 at 01:28:53AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, axboe@suse.dk, linux-scsi@vger.kernel.org

On Wed, Oct 23, 2002 at 01:28:53AM -0700, Mike Anderson wrote:
> Looks good. I ran it on a system with ips, aic, scsi_debug and qla2x00
> as a module. 
> 
> When I applied the patch I got a quite a few rejects on sd.c and sr.c. I
> fixed up sd.c, but did not run sr.c. My view is based off James
> scsi-misc-2.5.
> 
> I noticed the patch seems to include some of your driver_register
> removals (preiously posted) in init_sd and exit_sd, but there are no
> adds to scsi_register_device or scsi_unregister_device.

The patch is again 2.5.44 + my previous two patch (devicefs stuff
and ->finish removal).

> 
> Christoph Hellwig [hch@lst.de] wrote:
> > +	list_for_each(p, &sd_devlist) {
> > +		sdkp = list_entry(p, struct scsi_disk, list);
> >  		sdp = sdkp->device;
> >  		if (sdp && (sdp->host == shp) && (sdp->id == scsi_id)) {
> >  			retval = MKDEV_SD(dsk_nr);
> >  			break;
> 
> Might consider using list_for_each_entry since you always do both.

Yupp.

> I received a compile failures on sector_t until I put back the scsi.h
> include.

Umm, rhigh.  There are far to many users of sd.h to do such a change.
I'll submt a patch to get rid of all those sd.h users in some time.

