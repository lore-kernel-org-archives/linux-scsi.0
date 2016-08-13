From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi
 disks?
Date: Sat, 13 Aug 2016 08:23:20 -0700
Message-ID: <1471101800.2397.9.camel@HansenPartnership.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
	 <1471047451.2407.95.camel@HansenPartnership.com>
	 <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
	 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-08-12 at 21:57 -0700, Dan Williams wrote:
> On Fri, Aug 12, 2016 at 5:29 PM, Dan Williams <
> dan.j.williams@intel.com> wrote:
> > On Fri, Aug 12, 2016 at 5:17 PM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > > On Fri, 2016-08-12 at 14:29 -0700, Dan Williams wrote:
> > > > Before spending effort trying to flush the destruction of old
> > > > bdi
> > > > instances before new ones are registered, is it rather time to
> > > > complete the conversion of sd to only use dynamically allocated
> > > > devt?
> > > 
> > > Do we have to go that far?  Surely your fix is extensible: the
> > > only
> > > reason it doesn't work for us is that the gendisk holds the
> > > parent
> > > without a reference, so we can free the SCSI device before its
> > > child
> > > gendisk (good job no-one actually uses gendisk->parent after
> > > we've
> > > released it ...).  If we fix that it would mean SCSI can't
> > > release the
> > > sdev until after the queue is dead and the bdi namespace
> > > released, so
> > > isn't something like this the easy fix?
> > > 
> > > James
> > > 
> > > ---
> > > 
> > > diff --git a/block/genhd.c b/block/genhd.c
> > > index fcd6d4f..54ae4ae 100644
> > > --- a/block/genhd.c
> > > +++ b/block/genhd.c
> > > @@ -514,7 +514,7 @@ static void register_disk(struct device
> > > *parent, struct gendisk *disk)
> > >         struct hd_struct *part;
> > >         int err;
> > > 
> > > -       ddev->parent = parent;
> > > +       ddev->parent = get_device(parent);
> > > 
> > >         dev_set_name(ddev, "%s", disk->disk_name);
> > > 
> > > @@ -1144,6 +1144,7 @@ static void disk_release(struct device
> > > *dev)
> > >         hd_free_part(&disk->part0);
> > >         if (disk->queue)
> > >                 blk_put_queue(disk->queue);
> > > +       put_device(dev->parent);
> > >         kfree(disk);
> > >  }
> > >  struct class block_class = {
> > 
> > Looks ok at first glance to me.
> > 
> > We do hold a reference on the parent device, but it gets dropped at
> > device_unregister() time and this moves it out to the final put.

We do?  Where?

> > However, this does leave static devt block-device-drivers that
> > register a disk without a parent device susceptible to the race... 
> > I think those exist given all the drivers still using add_disk()
> > after commit 52c44d93c26f "block: remove ->driverfs_dev".

It does?  The race is the fact that the parent can be removed before
the child meaning if the parent name is re-registered before the child
dies we get a duplicate name in bdi space.

> So I tried the attached and it makes the libnvdimm unit tests start
> crashing.

Well, the attached is clearly buggy, isn't it?  You're trying to do a
get on the parent before the parent is actually set.  Why don't you
just try the incremental patch I sent instead of trying to rework it?

>   A couple crash logs attached.  Not yet sure what assumption
> is getting violated, but how about that conversion of scsi to use
> dynamic devt? ;-)

It's completely orthogonal.  The problem is in hierarchy lifetimes:
switching from static to dynamic allocation won't change that at all. 
 You don't see this problem in nvme because the parent control device's
lifetime belongs to the controller not the disk.  In SCSI the parent is
our representation of the SCSI device whose lifetime is governed at the
SCSI level and effectively represents the disk.

James


