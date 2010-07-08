From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/7] block: push down BKL into .open and .release
Date: Thu, 08 Jul 2010 10:41:13 +0200
Message-ID: <4C358F29.4020505@kernel.dk>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-4-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1278514289-21054-4-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2010-07-07 16:51, Arnd Bergmann wrote:
> The open and release block_device_operations are currently
> called with the BKL held. In order to change that, we must
> first make sure that all drivers that currently rely
> on this have no regressions.
> 
> This blindly pushes the BKL into all .open and .release
> operations for all block drivers to prepare for the
> next step. The drivers can subsequently replace the BKL
> with their own locks or remove it completely when it can
> be shown that it is not needed.
> 
> The functions blkdev_get and blkdev_put are the only
> remaining users of the big kernel lock in the block
> layer, besides a few uses in the ioctl code, none
> of which need to serialize with blkdev_{get,put}.
> 
> Most of these two functions is also under the protection
> of bdev->bd_mutex, including the actual calls to
> ->open and ->release, and the common code does not
> access any global data structures that need the BKL.

This is missing an smp_lock.h include in i2o as well.
You seem to only add these sporadically, I think that
is a bit unsafe since you are relying on unknown
include hierarchies. That tends to break on one arch
or config even if it works in another.

-- 
Jens Axboe

