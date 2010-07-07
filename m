From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] block: remove BKL from partition code
Date: Tue, 6 Jul 2010 22:04:25 -0400
Message-ID: <20100707020425.GG2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-6-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-6-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 03, 2010 at 11:47:19PM +0200, Arnd Bergmann wrote:
> I don't see any reason why we need the BKL here.
> The functions blkdev_get, blkdev_put, blkpg_ioctl
> and blkdev_reread_part are the only remaining users
> of the big kernel lock in the block layer, and they
> all access the same fields of the bdev and gendisk
> structures, yet they always do so under the protection
> of bdev->bd_mutex.
> 
> The open and close block_device_operations have all
> been converted to grab the BKL themselves, where
> necessary, so as far I can tell it should be safe
> to remove.

The content of the patch really does not match the subject at all,
which is a rather bad thing.

Anyway, dropping from blkdev_reread_part and blkpg_ioctl is easy
enough, and fine from a quick audit of the functions.

Dropping it from blkdev_get/put also seems fine from a quick
glance.  But that should be part of pushing the BKL into
->open/release.
