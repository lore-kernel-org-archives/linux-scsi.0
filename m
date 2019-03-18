From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 00/14] Convert block layer & drivers to XArray
Date: Mon, 18 Mar 2019 12:48:07 -0700
Message-ID: <20190318194821.3470-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Liu Bo <bo.liu@linux.alibaba.com>, Dennis Zhou  <dennisszhou@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org
List-Id: linux-scsi@vger.kernel.org

I would like to remove the IDR and radix tree APIs from the kernel.
This patch series converts all the IDRs and radix trees in the block
layer and block drivers to use the XArray APIs.  Testing of these
patches has been minimal, mostly limited to compilation testing.
I would be grateful if you could take these patches through your tree.
To cut down on wasted electrons, only this cover letter is being
distributed to everyone listed by get-maintainers; the patches can
be found on the linux-block mailing list.

Please check these patches over carefully and test them; there may be
off-by-one errors, locking mistakes, or various other failures on my part.

Substantive interface changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 - The IDR and radix tree required callers to handle their own locking.
   The XArray embeds a spinlock which is taken for modifications to
   the data structure; plain lookups occur under the RCU read lock or
   under the spinlock.
 - You can take the spinlock yourself (xa_lock() and friends) to protect
   related data.
 - idr_alloc() returned -ENOSPC, radix_tree_insert() returned -EEXIST.
   xa_insert() and xa_alloc() return -EBUSY.
 - The search keys which the radix tree calls "tags", the XArray calls
   "marks".
 - There is no preloading in the XArray API.  Most users of the
   preloading APIs only needed to use it because they were trying to
   allocate under their own spinlock.  If your locking is exceptionally
   complicated, you may need to use xa_insert() with a NULL pointer.
 - The radix tree provided GFP flags as part of the tree definition;
   the XArray (like the IDR) passes GFP flags at the point of allocation.
 - radix_tree_insert() of a NULL pointer was not well-specified.  The
   XArray treats it as reserving the entry (it reads back as NULL but
   a subsequent xa_insert() to that slot will fail).
 - xa_alloc_cyclic() returns 1 if the allocation wraps, unlike
   idr_alloc_cyclic() which provides no indication.
 - There is no equivalent to idr_for_each(); the xa_for_each() iterator
   is similar to idr_for_each_entry().
 - idr_replace() has no exact equivalent.  Some users relied on its exact
   semantics of only storing if the entry was non-NULL, but all users of
   idr_replace() were able to use xa_store() or xa_cmpxchg().
 - The family of radix tree gang lookup functions have been replaced with
   xa_extract().

Matthew Wilcox (14):
  blk-cgroup: Convert to XArray
  blk-cgroup: Remove blkg_list hlist
  blk-cgroup: Reduce scope of blkg_array lock
  blk-ioc: Convert to XArray
  blk-ioc: Remove ioc's icq_list
  genhd: Convert to XArray
  bsg: Convert bsg_minor_idr to XArray
  brd: Convert to XArray
  null_blk: Convert to XArray
  loop: Convert loop_index_idr to XArray
  nbd: Convert nbd_index_idr to XArray
  zram: Convert zram_index_idr to XArray
  drbd: Convert drbd devices to XArray
  drbd: Convert peer devices to XArray

 block/bfq-cgroup.c                 |   7 +-
 block/blk-cgroup.c                 |  94 +++++++------------
 block/blk-ioc.c                    |  38 ++++----
 block/bsg.c                        |  20 ++--
 block/genhd.c                      |  42 ++++-----
 drivers/block/brd.c                |  93 ++++++------------
 drivers/block/drbd/drbd_debugfs.c  |  16 ++--
 drivers/block/drbd/drbd_int.h      |  10 +-
 drivers/block/drbd/drbd_main.c     |  77 +++++++--------
 drivers/block/drbd/drbd_nl.c       |  77 ++++++++-------
 drivers/block/drbd/drbd_proc.c     |   8 +-
 drivers/block/drbd/drbd_receiver.c |  33 +++----
 drivers/block/drbd/drbd_state.c    |  67 ++++++-------
 drivers/block/drbd/drbd_worker.c   |  20 ++--
 drivers/block/loop.c               |  88 ++++++-----------
 drivers/block/nbd.c                | 145 ++++++++++++-----------------
 drivers/block/null_blk.h           |   4 +-
 drivers/block/null_blk_main.c      |  97 ++++++++-----------
 drivers/block/zram/zram_drv.c      |  40 +++-----
 include/linux/blk-cgroup.h         |   7 +-
 include/linux/iocontext.h          |  22 ++---
 21 files changed, 419 insertions(+), 586 deletions(-)

-- 
2.20.1
