From: Tejun Heo <tj@kernel.org>
Subject: Re: Kernel crashing on eject SD card
Date: Wed, 15 Feb 2012 09:26:17 -0800
Message-ID: <20120215172617.GB24986@google.com>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
 <20120212220836.6aa7fa4d@stein>
 <20120212222027.71651e8b@stein>
 <20120213021813.GA589@redhat.com>
 <1329154831.4f394b0f3c69c@www.imp.polymtl.ca>
 <4F3A4220.4010901@ce.jp.nec.com>
 <20120214162858.GM12117@google.com>
 <4F3B1ED3.4000706@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3B1ED3.4000706@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

This seems like the right approach to me, but..

On Wed, Feb 15, 2012 at 11:56:19AM +0900, Jun'ichi Nomura wrote:
> +int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
> +{
> +	int res;
> +
> +	res = drop_partitions(disk, bdev);
> +	if (res)
> +		return res;
> +

Hmmm... shouldn't we have set_capacity(disk, 0) here?

> +	check_disk_size_change(disk, bdev);
> +	bdev->bd_invalidated = 0;
> +	/* tell userspace that the media / partition table may have changed */
> +	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);

Also, we really shouldn't be generating KOBJ_CHANGE after every
-ENOMEDIUM open.  This can easily lead to infinite loop.  We should
generate this iff we actually dropped partitions && modified the size.

Thanks.

-- 
tejun
