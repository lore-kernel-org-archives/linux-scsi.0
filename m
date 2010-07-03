From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] block: BKL removal, version 3
Date: Sat,  3 Jul 2010 23:47:14 +0200
Message-ID: <1278193640-24223-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

This series removes the big kernel lock from the common
block layer code by pushing it into the individual
device drivers.

Following a suggestion from Christoph Hellwig,
It replaces the earlier attempt that converted the
usage of the BKL into a subsystem-wide mutex.

I'd like to get this into 2.6.36 in order to remove
the BKL from all the core kernel code.

The first larger patches should be fairly uncontroversial,
while patch 5/6 is the most critical one. I could not
see any reason why it should not work, but I'm also not
convinced that I found all the possible problems in it,
so I'd really like to get a second opinion on that one.

Arnd Bergmann (6):
  block: push down BKL into .locked_ioctl
  block: push down BKL into .open and .release
  block: push BKL into blktrace ioctls
  block: remove BKL from BLKROSET and BLKFLSBUF
  block: remove BKL from partition code
  scsi/sd: remove big kernel lock

 arch/um/drivers/ubd_kern.c          |    7 ++++-
 block/compat_ioctl.c                |   56 -----------------------------------
 block/ioctl.c                       |   21 +------------
 drivers/block/DAC960.c              |   13 +++++--
 drivers/block/amiflop.c             |   27 +++++++++++++++--
 drivers/block/aoe/aoeblk.c          |    4 ++
 drivers/block/ataflop.c             |   28 ++++++++++++++++-
 drivers/block/brd.c                 |    5 ++-
 drivers/block/cciss.c               |   31 +++++++++++++++----
 drivers/block/cpqarray.c            |   40 ++++++++++++++++++++++---
 drivers/block/drbd/drbd_main.c      |    4 ++
 drivers/block/floppy.c              |   20 ++++++++++++-
 drivers/block/loop.c                |    5 +++
 drivers/block/nbd.c                 |    5 ++-
 drivers/block/paride/pcd.c          |   21 +++++++++++--
 drivers/block/paride/pd.c           |    9 +++++-
 drivers/block/paride/pf.c           |   26 ++++++++++++----
 drivers/block/pktcdvd.c             |   16 ++++++++--
 drivers/block/swim.c                |   20 +++++++++++-
 drivers/block/swim3.c               |   30 +++++++++++++++++-
 drivers/block/ub.c                  |   27 +++++++++++++++--
 drivers/block/viodasd.c             |   19 +++++++++++-
 drivers/block/virtio_blk.c          |   15 +++++++++-
 drivers/block/xd.c                  |   15 +++++++++-
 drivers/block/xd.h                  |    2 +-
 drivers/block/xen-blkfront.c        |    9 +++++-
 drivers/block/xsysace.c             |    6 ++++
 drivers/block/z2ram.c               |   13 ++++++--
 drivers/cdrom/gdrom.c               |   19 ++++++++++--
 drivers/cdrom/viocd.c               |   21 +++++++++++--
 drivers/ide/ide-cd.c                |   30 +++++++++++++++----
 drivers/ide/ide-disk_ioctl.c        |    9 ++++-
 drivers/ide/ide-floppy_ioctl.c      |   12 +++++--
 drivers/ide/ide-gd.c                |   19 ++++++++++-
 drivers/ide/ide-tape.c              |   19 ++++++++++--
 drivers/md/dm.c                     |    7 ++++
 drivers/md/md.c                     |    6 ++++
 drivers/memstick/core/mspro_block.c |    9 +++++-
 drivers/message/i2o/i2o_block.c     |   19 +++++++++++-
 drivers/mmc/card/block.c            |    5 +++
 drivers/mtd/mtd_blkdevs.c           |   11 +++++-
 drivers/s390/block/dasd.c           |    6 ++++
 drivers/s390/block/dcssblk.c        |    5 +++
 drivers/s390/char/tape_block.c      |    8 ++++-
 drivers/scsi/sd.c                   |    3 +-
 drivers/scsi/sr.c                   |   22 ++++++++++++-
 drivers/staging/hv/blkvsc_drv.c     |    5 +++
 fs/block_dev.c                      |   10 +-----
 include/linux/blkdev.h              |    1 -
 include/linux/blktrace_api.h        |   12 +++++++
 kernel/trace/blktrace.c             |   43 ++++++++++++++++++++++++++
 51 files changed, 628 insertions(+), 167 deletions(-)
