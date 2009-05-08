From: Tejun Heo <tj@kernel.org>
Subject: [GIT PATCH] block: unify request processing model and implement peek/fetch
Date: Fri,  8 May 2009 11:53:58 +0900
Message-ID: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760073AbZEHC4S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 22:56:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-peek-fetch

Block layer has allowed two different models of request processing.
elv_next_request() is used to peek at the top of the queue, after
peeking, a LLD could start processing it immediately or dequeue and
then start processing.

The non-dequeuing behavior is mostly useful for simpler device drivers
(usually PIO based) which process requests on segment basis.  By using
the block layer queue tip as the current request pointer, they don't
have to care about request boundaries and just process things
segment-by-segment.

However, this dual mode of operations complicates and ambiguates block
layer API.  Block layer can't tell whether a request has begun
processing or not in deterministic manner.  This makes accounting
inaccurate and implementing high level features in block layer
difficult.  For example, it isn't clear when a block layer timeout
timer should be started or how queue queiscing for EH should be
implemented.  Even when problems can be worked aroudn, it makes the
implementation fragile.

Although allowing llds ignore request boundaries makes things simpler
for certain drivers, the number of drivers benefit form it aren't too
many and driver stacks which are even mildly complex have to deal with
request boundaries anyway.  Also, the benefit itself isn't that
significant.  In most cases, it is just another way of doing things
rather than the definitively better way.  IOW, if there were no such
alternative, nobody would have missed it.

This patchset converts all block layer llds to dequeuing model and
then clean up API to simplify a bit and enforce dequeueing model.
This patchset contains the following patches.

  0001-ide-dequeue-in-flight-request.patch
  0002-mg_disk-fix-queue-hang-infinite-retry-on-fs-requ.patch
  0003-mg_disk-dequeue-and-track-in-flight-request.patch
  0004-hd-dequeue-and-track-in-flight-request.patch
  0005-ataflop-dequeue-and-track-in-flight-request.patch
  0006-swim3-dequeue-in-flight-request.patch
  0007-xsysace-dequeue-in-flight-request.patch
  0008-paride-dequeue-in-flight-request.patch
  0009-ps3disk-dequeue-in-flight-request.patch
  0010-amiflop-dequeue-in-flight-request.patch
  0011-swim-dequeue-in-flight-request.patch
  0012-xd-dequeue-in-flight-request.patch
  0013-mtd_blkdevs-dequeue-in-flight-request.patch
  0014-jsflash-dequeue-in-flight-request.patch
  0015-z2ram-dequeue-in-flight-request.patch
  0016-gdrom-dequeue-in-flight-request.patch
  0017-block-convert-to-dequeueing-model-easy-ones.patch
  0018-block-implement-and-enforce-request-peek-start-fetc.patch

0001 converts ide to dequeueing model.

0002 fixes a bug in mg_disk spotted during conversion.

0003-0005 make llds which used elv_next_request() to track in-flight
request to dequeue and track it themselves.

0006-0008 convert llds which already track in-flight request to
dequeueing model.

0009 converts ps3disk.

0010-0015 convert llds which process requests one-by-one sequentially
to dequeueing model.

0016 converts gdrom which already used dequeueing model in normal
path.

0017 converts plat-omap/mailbox, floppy, viocd, mspro_block, i2o_block
and mmc/card/queue which are already pretty close to dequeueing model.

0018 changes block layer issue API such that there are three functions
- blk_peek_request(), blk_start_request() and blk_fetch_request()
where blk_fetch_request() is combination of the prevoius two.  It also
enforces dequeueing model.  Trying to complete a queued request will
trigger BUG.

Please note that conversions in 0001-0016 might not look optimal.
They're done in such a way that 0018 can mechanically convert to
blk_fetch_request() where applicable.

All changes have been compile tested.  libata, ide, hd and ubd_kern
are verified to work.  Waiting for floppy media to test it.

This patchset is on top of

  linux-2.6-block#for-2.6.31	  (f68adec3c7155a8bbf32a90cb4c4d0737df045d9)
+ linux-2.6-ide#for-next	  (03682411b1ccd38cbde2e9a6ab43884ff34fbefc)
+ block-unify-sector-and-data-len (1df2a196e28cc8f97919dc530dc1c019e1d3a968)

and contains the following changes.

 arch/arm/plat-omap/mailbox.c        |    9 +-
 arch/um/drivers/ubd_kern.c          |    3 
 block/blk-barrier.c                 |    4 -
 block/blk-core.c                    |  105 ++++++++++++++++++++++++--------
 block/blk-tag.c                     |    2 
 block/blk.h                         |    1 
 drivers/block/DAC960.c              |    4 -
 drivers/block/amiflop.c             |   47 +++++++-------
 drivers/block/ataflop.c             |   62 ++++++++++---------
 drivers/block/cciss.c               |    4 -
 drivers/block/cpqarray.c            |    4 -
 drivers/block/floppy.c              |    4 -
 drivers/block/hd.c                  |   62 ++++++++++++-------
 drivers/block/mg_disk.c             |  115 +++++++++++++++++++-----------------
 drivers/block/nbd.c                 |    4 -
 drivers/block/paride/pcd.c          |   17 +++--
 drivers/block/paride/pd.c           |   13 ++--
 drivers/block/paride/pf.c           |   13 +---
 drivers/block/ps3disk.c             |    8 +-
 drivers/block/sunvdc.c              |    3 
 drivers/block/swim.c                |   41 +++++-------
 drivers/block/swim3.c               |   46 ++++++++++----
 drivers/block/sx8.c                 |    8 --
 drivers/block/ub.c                  |    8 +-
 drivers/block/viodasd.c             |    4 -
 drivers/block/virtio_blk.c          |    4 -
 drivers/block/xd.c                  |   23 +++----
 drivers/block/xen-blkfront.c        |   15 ++--
 drivers/block/xsysace.c             |   19 +++--
 drivers/block/z2ram.c               |   13 ++--
 drivers/cdrom/gdrom.c               |   28 +++-----
 drivers/cdrom/viocd.c               |    2 
 drivers/ide/ide-atapi.c             |   14 +++-
 drivers/ide/ide-cd.c                |    8 --
 drivers/ide/ide-io.c                |   33 +++++++---
 drivers/memstick/core/mspro_block.c |    9 +-
 drivers/message/i2o/i2o_block.c     |   10 +--
 drivers/mmc/card/queue.c            |   11 ---
 drivers/mtd/mtd_blkdevs.c           |   14 ++--
 drivers/s390/block/dasd.c           |   16 +----
 drivers/s390/char/tape_block.c      |    7 --
 drivers/sbus/char/jsflash.c         |   22 +++---
 drivers/scsi/scsi_lib.c             |   10 +--
 drivers/scsi/scsi_transport_sas.c   |    4 -
 include/linux/blkdev.h              |    9 ++
 include/linux/elevator.h            |    2 
 46 files changed, 486 insertions(+), 378 deletions(-)

Thanks.

--
tejun
