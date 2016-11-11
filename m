From: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/12] block: cleanup direct access to bvec table
Date: Fri, 11 Nov 2016 20:05:28 +0800
Message-ID: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, "open list:NVM EXPRESS TARGET DRIVER" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "open list:DEVICE-MAPPER  LVM" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:TARGET SUBSYSTEM" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "open list:DRBD DRIVER" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, "open list:TARGET SUBSYSTEM" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Guoqing Jiang <gqjiang-IBi9RG/b67k@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, "open list:SOFTWARE RAID Multiple Disks SUPPORT" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache-u79uwXL29Tb/PtFMR13I2A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patchset cleans up direct access to bvec table.

The 1st patch passes bvec table to bio_init(), so that
direct access to bvec table in bio initialization is avoided.

For other patches, most of them uses bio_add_page()
to replace hardcode style of adding page to bvec,
and others avoids to access bio->bi_vcnt.

The most special one is to use bvec iterator helpers
to implement .get_page/.next_page for dm-io.c

One big motivation is to prepare for supporting multipage
bvec, but this patchset is one good cleanup too even not
for that purpose.

Thanks,
Ming

Ming Lei (12):
  block: bio: pass bvec table to bio_init()
  block: drbd: remove impossible failure handling
  block: floppy: use bio_add_page()
  target: avoid to access .bi_vcnt directly
  bcache: debug: avoid to access .bi_io_vec directly
  dm: crypt: use bio_add_page()
  dm: use bvec iterator helpers to implement .get_page and .next_page
  dm: dm.c: replace 'bio->bi_vcnt == 1' with !bio_multiple_segments
  fs: logfs: convert to bio_add_page() in sync_request()
  fs: logfs: use bio_add_page() in __bdev_writeseg()
  fs: logfs: use bio_add_page() in do_erase()
  fs: logfs: remove unnecesary check

 block/bio.c                        |   8 ++-
 drivers/block/drbd/drbd_receiver.c |  14 +----
 drivers/block/floppy.c             |  10 ++--
 drivers/md/bcache/debug.c          |  11 ++--
 drivers/md/bcache/io.c             |   4 +-
 drivers/md/bcache/journal.c        |   4 +-
 drivers/md/bcache/movinggc.c       |   6 +--
 drivers/md/bcache/request.c        |   2 +-
 drivers/md/bcache/super.c          |  12 ++---
 drivers/md/bcache/writeback.c      |   5 +-
 drivers/md/dm-bufio.c              |   4 +-
 drivers/md/dm-crypt.c              |   8 +--
 drivers/md/dm-io.c                 |  34 ++++++++----
 drivers/md/dm-rq.c                 |   7 ++-
 drivers/md/dm.c                    |   2 +-
 drivers/md/multipath.c             |   2 +-
 drivers/md/raid5-cache.c           |   2 +-
 drivers/md/raid5.c                 |   9 +---
 drivers/nvme/target/io-cmd.c       |   4 +-
 drivers/target/target_core_pscsi.c |   8 +--
 fs/logfs/dev_bdev.c                | 106 +++++++++++++------------------------
 include/linux/bio.h                |   3 +-
 22 files changed, 107 insertions(+), 158 deletions(-)

-- 
2.7.4
