From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Wed, 10 Nov 2010 14:59:25 +0100
Message-ID: <4CDAA53D.2050001@fusionio.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de> <4CC3326E.5020009@fusionio.com> <20101110134227.GA4963@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:36497 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab0KJN7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 08:59:31 -0500
In-Reply-To: <20101110134227.GA4963@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-11-10 14:42, Christoph Hellwig wrote:
> On Sat, Oct 23, 2010 at 09:07:26PM +0200, Jens Axboe wrote:
>> Thanks Christoph, applied for 2.6.37 (but with a few days of brewing).
> 
> So, what's the plan?  I'd really hate to see 2.6.37 getting released
> with those stale barrier bits left in.

It's queued up, I'll be pushing this out this week:

  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (1):
      block: remove REQ_HARDBARRIER

Daniel J Blueman (1):
      ioprio: fix RCU locking around task dereference

Jens Axboe (7):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-2.6.37/drivers
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      block: take care not to overflow when calculating total iov length
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      bio: take care not overflow page count when mapping/copying user data
      cciss: fix proc warning on attempt to remove non-existant directory
      Merge branch 'for-2.6.37/drivers' into for-linus

Lars Ellenberg (6):
      drbd: consolidate explicit drbd_md_sync into drbd_create_new_uuid
      drbd: tag a few error messages with "assert failed"
      drbd: fix potential deadlock on detach
      drbd: fix potential data divergence after multiple failures
      drbd: fix a misleading printk
      drbd: rate limit an error message

Mike Snitzer (1):
      block: read i_size with i_size_read()

Philipp Reisner (4):
      drbd: Silenced an assert
      drbd: Removed the BIO_RW_BARRIER support form the receiver/epoch code
      drbd: REQ_HARDBARRIER -> REQ_FUA transition for meta data accesses
      drbd: Removed checks for REQ_HARDBARRIER on incomming BIOs

Sergey Senozhatsky (1):
      ioprio: rcu_read_lock/unlock protect find_task_by_vpid call (V2)

Stephen M. Cameron (5):
      cciss: fix board status waiting code
      cciss: Use kernel provided PCI state save and restore functions
      cciss: limit commands allocated on reset_devices
      cciss: use usleep_range not msleep for small sleeps
      cciss: remove controllers supported by hpsa

Vasiliy Kulikov (1):
      block: ioctl: fix information leak to userland

 block/blk-core.c                   |   11 +--
 block/blk-map.c                    |    2 +
 block/compat_ioctl.c               |    4 +-
 block/elevator.c                   |    4 +-
 block/ioctl.c                      |    7 +-
 block/scsi_ioctl.c                 |   34 ++++--
 drivers/block/aoe/aoeblk.c         |    3 -
 drivers/block/cciss.c              |  131 ++++++++++------------
 drivers/block/cciss.h              |    4 +
 drivers/block/drbd/drbd_actlog.c   |   42 ++++---
 drivers/block/drbd/drbd_int.h      |   52 ++++-----
 drivers/block/drbd/drbd_main.c     |  148 ++++++++++++++-----------
 drivers/block/drbd/drbd_nl.c       |   25 +++-
 drivers/block/drbd/drbd_proc.c     |    1 -
 drivers/block/drbd/drbd_receiver.c |  217 ++++++------------------------------
 drivers/block/drbd/drbd_req.c      |   38 +++----
 drivers/block/drbd/drbd_worker.c   |   23 +----
 drivers/block/loop.c               |    6 -
 drivers/block/xen-blkfront.c       |    2 -
 drivers/md/md.c                    |   20 ++--
 drivers/scsi/scsi_error.c          |   18 +--
 drivers/usb/storage/uas.c          |    5 +-
 fs/bio.c                           |   23 ++++-
 fs/ioprio.c                        |   18 +++-
 include/linux/bio.h                |    4 -
 include/linux/blk_types.h          |    6 +-
 include/linux/blkdev.h             |    3 +-
 include/linux/drbd.h               |    2 +-
 kernel/trace/blktrace.c            |    4 -
 29 files changed, 360 insertions(+), 497 deletions(-)

-- 
Jens Axboe

