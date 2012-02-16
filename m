From: Tejun Heo <tj@kernel.org>
Subject: Re: Kernel crashing on eject SD card
Date: Thu, 16 Feb 2012 08:36:30 -0800
Message-ID: <20120216163630.GH24986@google.com>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
 <20120212220836.6aa7fa4d@stein>
 <20120212222027.71651e8b@stein>
 <20120213021813.GA589@redhat.com>
 <1329154831.4f394b0f3c69c@www.imp.polymtl.ca>
 <4F3A4220.4010901@ce.jp.nec.com>
 <20120214162858.GM12117@google.com>
 <4F3B1ED3.4000706@ce.jp.nec.com>
 <20120215172617.GB24986@google.com>
 <4F3C5B4E.3080606@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3C5B4E.3080606@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Feb 16, 2012 at 10:26:38AM +0900, Jun'ichi Nomura wrote:
> >> +int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
> >> +{
> >> +	int res;
> >> +
> >> +	res = drop_partitions(disk, bdev);
> >> +	if (res)
> >> +		return res;
> >> +
> > 
> > Hmmm... shouldn't we have set_capacity(disk, 0) here?
> 
> Added.
> I wasn't sure whether I should leave it to drivers.

The problem is that we shouldn't call into drivers without first
opening the device, so....

> But it seems capacity 0 for ENOMEDIUM device is reasonable.

Yeah, I *think* it should be okay.

> >> +	check_disk_size_change(disk, bdev);
> >> +	bdev->bd_invalidated = 0;
> >> +	/* tell userspace that the media / partition table may have changed */
> >> +	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
> > 
> > Also, we really shouldn't be generating KOBJ_CHANGE after every
> > -ENOMEDIUM open.  This can easily lead to infinite loop.  We should
> > generate this iff we actually dropped partitions && modified the size.
> 
> invalidate_partitions() is called only when bd_invalidated is set.
> So KOBJ_CHANGE is not raised for every ENOMEDIUM open.

Ah, okay.

> I put it explicit in the function to make it safer for
> possible misuse.
> 
> How about this?
> 
> ---------------------------------------------------------
> Do not call drivers when invalidating partitions for -ENOMEDIUM
> 
> When a scsi driver returns -ENOMEDIUM for open(),
> __blkdev_get() calls rescan_partitions(), which ends up calling
> sd_revalidate_disk() without getting a refcount of scsi_device.
> 
> That could lead to oops like this:
> 
>   process A                  process B
>   ----------------------------------------------
>   sys_open
>     __blkdev_get
>       sd_open
>         returns -ENOMEDIUM
>                              scsi_remove_device
>                                <scsi_device torn down>
>       rescan_partitions
>         sd_revalidate_disk
>           <oops>
> 
> Oopses are reported here:
> http://marc.info/?l=linux-scsi&m=132388619710052
> 
> This patch separates the partition invalidation from rescan_partitions()
> and use it for -ENOMEDIUM case. 

Yeah, this looks good to me.

Thank you.

-- 
tejun
