From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFD] brd.ko Never supported partitions should we remove the
 dead code ?
Date: Tue, 29 Jul 2014 11:19:39 -0600
Message-ID: <1406654379.2767.1.camel@rzwisler-mobl1.amr.corp.intel.com>
References: <53D7CDDD.1000302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61518 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaG2RTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 13:19:40 -0400
In-Reply-To: <53D7CDDD.1000302@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>

On Tue, 2014-07-29 at 19:37 +0300, Boaz Harrosh wrote:
> Hi folks
> 
> I've been playing with yet unseen prd block device, and hit an issue with partitioning
> but since prd.c is a copy/paste of brd.c the same exact issue exists with brd.
> 
> It does not support partitions!
> 
> An attempt to fdisk say a couple of partitions, then mkfs && mount an individual
> partition will result in the primary device being accessed and a corrupted disk data.
> 
> If I enable max_part(=2) properly on modprobe, then fdisk a couple of partitions all
> goes well
> 
> But then if I pass the device to Kernel (Say via mount), after a call to
> 	bdev = blkdev_get_by_path(dev_name, mode, fs_type);
> 
> I get the following results: 
> (size is extracted using:	i_size_read(bdev->bd_inode);
>  part_size is extracted using:	bdev->bd_part->nr_sects << 9;
> )
> 
> dev_name == /dev/ram0
> [Jul29 17:40] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003dc24340 bd_inode=ffff88003dc24430 bd_part=ffff88003ca22848 part_size=0x40000000
> 
> dev_name == /dev/ram0p1
> [ +16.816065] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003d2f6d80 bd_inode=ffff88003d2f6e70 bd_part=ffff88003ca22848 part_size=0x40000000
> 
> dev_name == /dev/ram0p2
> [Jul29 17:41] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003dc24680 bd_inode=ffff88003dc24770 bd_part=ffff88003ca22848 part_size=0x40000000
> 
> We can see that all 3 different bdev's point to the same bd_part, which is the BUG. Funny is that bd_inode is different but contains
> same wrong size, for exactly the same reason.

Yep, I've seen this as well.  It turns out that partitions *do* work in brd if
you don't specify the 'rd_nr' module parameter, but if you do specify the
module parameter you get the partition overlapping behavior that you observed.

AFAICT the difference between these two scenarios is that when you set rd_nr,
the 'range' variable is set so something small, but when you don't set it
'range' is 1,048,576.  That's done by this bit of code in brd_init:

	if (rd_nr) {
		nr = rd_nr;
		range = rd_nr << part_shift;
	} else {
		nr = CONFIG_BLK_DEV_RAM_COUNT;
		range = 1UL << MINORBITS;
	}

The difference in behavior happens up the stack somewhere as a result of you
passing 'range' into blk_register_region().

Anyway, the quick and dirty workaround is to always have 'range' be something
large.  This is what I've done in the current master branch of the upstream
PRD tree - see commit 0256739ccab03d1662221f595b03797370c2ac12.

For what it's worth, I'm planning on updating prd (and probably brd) so that
it dynamically allocates partition numbers.  See commit
469071a37afc8a627b6b2ddf29db0a097d864845 for how this was done in the nvme
driver.

- Ross


