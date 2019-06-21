From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>
Subject: [PATCH 0/4] open, close, finish zone support
Date: Fri, 21 Jun 2019 15:07:07 +0200
Message-ID: <20190621130711.21986-1-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com, hch@lst.de, damien.lemoal@wdc.com, chaitanya.kulkarni@wdc.com, dmitry.fomichev@wdc.com, ajay.joshi@wdc.com, aravind.ramesh@wdc.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, snitzer@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch serie adds support for explicit control of zone transitions.

To test it, one can use an updated blkzone version that is available
here:

  https://github.com/MatiasBjorling/util-linux.git zonemgmt

blkzone can be compiled with:

  ./autogen.sh
  ./configure
  make blkzone

After that, the binary is available in the compile directory.

Regards,
Matias

Ajay Joshi (4):
  block: add zone open, close and finish support
  null_blk: add zone open, close, and finish support
  scsi: sd_zbc: add zone open, close, and finish support
  dm: add zone open, close and finish support

 block/blk-core.c               |  3 ++
 block/blk-zoned.c              | 51 +++++++++++++++++++++---------
 block/ioctl.c                  |  5 ++-
 drivers/block/null_blk.h       |  4 +--
 drivers/block/null_blk_main.c  | 13 ++++++--
 drivers/block/null_blk_zoned.c | 33 ++++++++++++++++++--
 drivers/md/dm-flakey.c         |  7 ++---
 drivers/md/dm-linear.c         |  2 +-
 drivers/md/dm.c                |  5 +--
 drivers/scsi/sd.c              | 15 ++++++++-
 drivers/scsi/sd.h              |  6 ++--
 drivers/scsi/sd_zbc.c          | 18 ++++++++---
 include/linux/blk_types.h      | 35 +++++++++++++++++++--
 include/linux/blkdev.h         | 57 +++++++++++++++++++++++++++++-----
 include/uapi/linux/blkzoned.h  | 17 ++++++++--
 15 files changed, 221 insertions(+), 50 deletions(-)

-- 
2.19.1
