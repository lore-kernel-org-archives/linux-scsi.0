From: Tejun Heo <tj@kernel.org>
Subject: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Date: Mon, 16 Aug 2010 18:51:58 +0200
Message-ID: <1281977523-19335-1-git-send-email-tj@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
List-Id: linux-scsi@vger.kernel.org

Hello,

This patchset contains five patches to convert block drivers
implementing REQ_HARDBARRIER to support REQ_FLUSH/FUA.

  0001-block-loop-implement-REQ_FLUSH-FUA-support.patch
  0002-virtio_blk-implement-REQ_FLUSH-FUA-support.patch
  0003-lguest-replace-VIRTIO_F_BARRIER-support-with-VIRTIO_.patch
  0004-md-implment-REQ_FLUSH-FUA-support.patch
  0005-dm-implement-REQ_FLUSH-FUA-support.patch

I'm fairly sure about conversions 0001-0003.  0004 should be okay
although multipath wasn't tested.  0005, I'm not quite sure about.  It
works fine for the tests I've done but there are many other targets
and code paths that I didn't test.  So, please be careful with the
last patch.  I think it would be best to route the last two through
the respective md/dm trees after the core part is merged and pulled
into those trees.

The nice thing about the conversion is that in many cases it replaces
postflush with FUA writes which can be handled by request queues lower
in the chain.  For md/dm, this replaces an array wide cacheflush with
FUA writes to only affected member devices.

After this patchset, the followings remain to be converted.

* blktrace

* scsi_error.c for some reason tests REQ_HARDBARRIER.  I think this
  part can be dropped altogether but am not sure.

* drbd and xen.  I have no idea.

These patches are on top of

  block#for-2.6.36-post (c047ab2dddeeafbd6f7c00e45a13a5c4da53ea0b)
+ block-replace-barrier-with-sequenced-flush patchset[1]
+ block-fix-incorrect-bio-request-flag-conversion-in-md patch[2]

and available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

and contain the following changes.

 Documentation/lguest/lguest.c   |   36 +++-----
 drivers/block/loop.c            |   18 ++--
 drivers/block/virtio_blk.c      |   26 ++---
 drivers/md/dm-crypt.c           |    2 
 drivers/md/dm-io.c              |   20 ----
 drivers/md/dm-log.c             |    2 
 drivers/md/dm-raid1.c           |    8 -
 drivers/md/dm-region-hash.c     |   16 +--
 drivers/md/dm-snap-persistent.c |    2 
 drivers/md/dm-snap.c            |    6 -
 drivers/md/dm-stripe.c          |    2 
 drivers/md/dm.c                 |  180 ++++++++++++++++++++--------------------
 drivers/md/linear.c             |    4 
 drivers/md/md.c                 |  117 +++++---------------------
 drivers/md/md.h                 |   23 +----
 drivers/md/multipath.c          |    4 
 drivers/md/raid0.c              |    4 
 drivers/md/raid1.c              |  175 +++++++++++++-------------------------
 drivers/md/raid1.h              |    2 
 drivers/md/raid10.c             |    7 -
 drivers/md/raid5.c              |   38 ++++----
 drivers/md/raid5.h              |    1 
 include/linux/virtio_blk.h      |    6 +
 23 files changed, 278 insertions(+), 421 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1022363
[2] http://thread.gmane.org/gmane.linux.kernel/1023435
