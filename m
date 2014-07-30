From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] brd: Fix the partitions BUG
Date: Wed, 30 Jul 2014 10:50:17 -0600
Message-ID: <1406739017.2767.9.camel@rzwisler-mobl1.amr.corp.intel.com>
References: <53D7CDDD.1000302@gmail.com>
	 <1406654379.2767.1.camel@rzwisler-mobl1.amr.corp.intel.com>
	 <53D8D2C4.1030101@gmail.com> <53D8FE1F.1060009@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53D8FE1F.1060009@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Nick Piggin <npiggin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-07-30 at 17:15 +0300, Boaz Harrosh wrote:
> With current code after a call to:
> 	bdev = blkdev_get_by_path(dev_name, mode, fs_type);
> 	size = i_size_read(bdev->bd_inode);
> 	part_size  = bdev->bd_part->nr_sects << 9;
> 
> I get the following bad results:
> dev_name == /dev/ram0
>   foo: [foo_mount:880] size=0x40000000 bdev=ffff88003dc24340 \
> 	bd_inode=ffff88003dc24430 bd_part=ffff88003ca22848 part_size=0x40000000
> dev_name == /dev/ram0p1
>   foo: [foo_mount:880] size=0x40000000 bdev=ffff88003d2f6d80 \
> 	bd_inode=ffff88003d2f6e70 bd_part=ffff88003ca22848 part_size=0x40000000
> dev_name == /dev/ram0p2
>   foo: [foo_mount:880] size=0x40000000 bdev=ffff88003dc24680 \
> 	bd_inode=ffff88003dc24770 bd_part=ffff88003ca22848 part_size=0x40000000
> Note how all three bdev(s) point to the same bd_part.
> 
> This is do to a single bad clubber in brd_probe() which is
> removed in this patch:
> -	*part = 0;
> 
> because of this all 3 bdev(s) above get to point to the same bd_part[0]
> 
> While at it fix/rename brd_init_one() since all devices are created on
> load of driver, brd_probe() will never be called with a new un-created
> device.
> brd_init_one() is now renamed to brd_find() which is what it does.
> 
> TODO: There is one more partitions BUG regarding
>       brd_direct_access() which is fixed on the next patch.
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/brd.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index c7d138e..92334f6 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -523,22 +523,20 @@ static void brd_free(struct brd_device *brd)
>  	kfree(brd);
>  }
>  
> -static struct brd_device *brd_init_one(int i)
> +static struct brd_device *brd_find(int i)
>  {
>  	struct brd_device *brd;
>  
>  	list_for_each_entry(brd, &brd_devices, brd_list) {
>  		if (brd->brd_number == i)
> -			goto out;
> +			return brd;
>  	}
>  
> -	brd = brd_alloc(i);
> -	if (brd) {
> -		add_disk(brd->brd_disk);
> -		list_add_tail(&brd->brd_list, &brd_devices);
> -	}
> -out:
> -	return brd;
> +	/* brd always allocates all its devices at load time, therefor
> +	 * brd_probe will never be called with a new brd_number
> +	 */
> +	printk(KERN_EROR "brd: brd_find unexpected device %d\n", i);

s/KERN_EROR/KERN_ERR/

> +	return NULL;
>  }
>  
>  static void brd_del_one(struct brd_device *brd)
> @@ -554,11 +552,10 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
>  	struct kobject *kobj;
>  
>  	mutex_lock(&brd_devices_mutex);
> -	brd = brd_init_one(MINOR(dev) >> part_shift);
> +	brd = brd_find(MINOR(dev) >> part_shift);
>  	kobj = brd ? get_disk(brd->brd_disk) : NULL;
>  	mutex_unlock(&brd_devices_mutex);
>  
> -	*part = 0;
>  	return kobj;
>  }

It is possible to create new block devices with BRD at runtime:

	# mknod /dev/new_brd b 1 4 
	# fdisk -l /dev/new_brd

This causes a new BRD disk to be created, and hits your error case:

	Jul 30 10:40:57 alara kernel: brd: brd_find unexpected device 4
	
I guess in general I'm not saying that BRD needs to have partitions - indeed
it may not give you much in the way of added functionality.  As the code
currently stands partitions aren't surfaced anyway
(GENHD_FL_SUPPRESS_PARTITION_INFO is set).  For PRD, however, I *do* want to
enable partitions correctly because eventually I'd like to enhance PRD so that
it *does* actually handle NVDIMMs correctly, and for that partitions do make
sense.  And if I have to implement and debug partitions for PRD, it's easy to
stick them in BRD in case anyone wants to use them.

- Ross
