From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: bdev size not updated correctly after underlying device is
	resized
Date: Wed, 16 Apr 2008 15:59:45 -0600
Message-ID: <1208383185.3859.24.camel@bluto.andrew>
References: <1207783782.31821.80.camel@bluto.andrew>
	 <20080415160314.11e9b7e1.akpm@linux-foundation.org>
	 <1208301719.24092.21.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16148 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYDPV7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2008 17:59:46 -0400
In-Reply-To: <1208301719.24092.21.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dm-devel@redhat.com, axboe@kernel.dk, andmike@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Tue, 2008-04-15 at 17:21 -0600, Andrew Patterson wrote:
> On Tue, 2008-04-15 at 16:03 -0700, Andrew Morton wrote:
> > On Wed, 09 Apr 2008 17:29:42 -0600
> > .
> > > Subject: [PATCH] Reset bdev size regardless of other openers.
> > > 
> > > A block device may be resized while online.  If the revalidate_disk
> > > routine is called after the resize, the gendisk->capacity value is
> > > updated for the device.  However, the bdev->bd_inode->i_size is not
> > > updated when the block device is opened if there are any other openers
> > > on the device.  This means that apps like LVM are unlikely to see the
> > > size change as they tend to keep their block devices open.  There is a
> > > discussion of this problem at:
> > > 
> > >   http://lkml.org/lkml/2007/7/3/83
> > > 
> > > This patch changes block_dev.c:do_open() to call bd_set_size()
> > > regardless if there are other openers on the device.  It should not be
> > > applied in its existing state as changing i_size should be protected by
> > > a lock. Also, there needs to be some analysis on the effects of changing
> > > the device size underneath an app.
> > 
> > hm, tricky.
> > 
> > I don't know what problems a change like this might cause - probably few,
> > given the rarity and slowness of block device resizing.
> 
> I have been looking through code where this might be a problem.  The
> sort of things I was worried about is where something might try and do a
> calculation based on the i_size and write/read data from there after it
> has been resized, possibly corrupting data.  The COW code in dm seems to
> come the closest, but then if you are resizing the device that has
> snapshots on it, you might be getting what you deserve.
> 
> > 
> > Presumably increasing the device size will cause les problems than
> > decreasing it would. 
> 
> Agreed.
> 
> >  Do we even support device shrinking?
> 
> Yes, this common with LVM at least.  Whether it is a good idea to do
> this with a mounted file-system on it is another matter.
> 
> > 
> > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > index 7d822fa..d13a4e5 100644
> > > --- a/fs/block_dev.c
> > > +++ b/fs/block_dev.c
> > > @@ -992,6 +992,9 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
> > >  				ret = bdev->bd_disk->fops->open(bdev->bd_inode, file);
> > >  				if (ret)
> > >  					goto out;
> > > +				/* device may have been resized with revalidate_disk */
> > > +				if (!part)
> > > +					bd_set_size(bdev, (loff_t)get_capacity(disk)<<9);
> > >  			}
> > >  			if (bdev->bd_invalidated)
> > >  				rescan_partitions(bdev->bd_disk, bdev);
> > 
> > I'd have thought that an appropriate way to fix all this would be to
> > perform the i_size update between freeze_bdev() and thaw_bdev(), when the
> > fs is quiesced.  But it's not really in my comfort zone.
> 
> Except that this is not only done with file-systems.  In my case I am
> just trying to extend an LVM logical volume after a resize but cannot
> because it is open (activated). In practice, however, it is probably
> only useful to do this with an online file-system.  Otherwise you could
> just close all openers and the resize will work fine.
> 
> > 
> 

Adding linux-scsi.  



