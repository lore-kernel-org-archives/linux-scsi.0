From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.14 RFC PATCH 0/2] dm rq: eliminate historic blk-mq and .request_fn queue stacking restrictions
Date: Thu, 13 Jul 2017 17:12:15 -0400
Message-ID: <20170713211217.52361-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: hch@lst.de
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Please review the 2 patches in this series.  I'm left on-the-fence
about whether there is any point re-enabling "dm-mq stacked on old
.request_fn device(s)" -- especially given the awkward details
documented in the 1/2 patch header.

I welcome any feedback on this, thanks!

BTW, I tested these changes using mptest:
 git://github.com/snitm/mptest.git

with the following permutations ('runtest' script tweaked before each
permutation):

echo N > /sys/module/scsi_mod/parameters/use_blk_mq
echo N > /sys/module/dm_mod/parameters/use_blk_mq

echo Y > /sys/module/scsi_mod/parameters/use_blk_mq
echo Y > /sys/module/dm_mod/parameters/use_blk_mq

echo Y > /sys/module/scsi_mod/parameters/use_blk_mq
echo N > /sys/module/dm_mod/parameters/use_blk_mq

echo N > /sys/module/scsi_mod/parameters/use_blk_mq
echo Y > /sys/module/dm_mod/parameters/use_blk_mq

Mike Snitzer (2):
  dm rq: avoid deadlock if dm-mq is stacked on old .request_fn device(s)
  dm rq: eliminate historic blk-mq and .request_fn queue stacking restrictions

 drivers/md/dm-mpath.c         | 16 ++++++++++++++--
 drivers/md/dm-rq.c            | 13 +++++--------
 drivers/md/dm-table.c         | 31 +++----------------------------
 drivers/md/dm-target.c        |  4 ++--
 drivers/md/dm.h               |  1 -
 include/linux/device-mapper.h |  3 ++-
 6 files changed, 26 insertions(+), 42 deletions(-)

-- 
2.10.1
