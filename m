From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi disks?
Date: Fri, 12 Aug 2016 17:29:30 -0700
Message-ID: <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
 <1471047451.2407.95.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1471047451.2407.95.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 12, 2016 at 5:17 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2016-08-12 at 14:29 -0700, Dan Williams wrote:
>> Before spending effort trying to flush the destruction of old bdi
>> instances before new ones are registered, is it rather time to
>> complete the conversion of sd to only use dynamically allocated devt?
>
> Do we have to go that far?  Surely your fix is extensible: the only
> reason it doesn't work for us is that the gendisk holds the parent
> without a reference, so we can free the SCSI device before its child
> gendisk (good job no-one actually uses gendisk->parent after we've
> released it ...).  If we fix that it would mean SCSI can't release the
> sdev until after the queue is dead and the bdi namespace released, so
> isn't something like this the easy fix?
>
> James
>
> ---
>
> diff --git a/block/genhd.c b/block/genhd.c
> index fcd6d4f..54ae4ae 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -514,7 +514,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
>         struct hd_struct *part;
>         int err;
>
> -       ddev->parent = parent;
> +       ddev->parent = get_device(parent);
>
>         dev_set_name(ddev, "%s", disk->disk_name);
>
> @@ -1144,6 +1144,7 @@ static void disk_release(struct device *dev)
>         hd_free_part(&disk->part0);
>         if (disk->queue)
>                 blk_put_queue(disk->queue);
> +       put_device(dev->parent);
>         kfree(disk);
>  }
>  struct class block_class = {

Looks ok at first glance to me.

We do hold a reference on the parent device, but it gets dropped at
device_unregister() time and this moves it out to the final put.
However, this does leave static devt block-device-drivers that
register a disk without a parent device susceptible to the race... I
think those exist given all the drivers still using add_disk() after
commit 52c44d93c26f "block: remove ->driverfs_dev".
