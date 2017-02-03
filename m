From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [REGRESSION v4.10-rc1] blkdev_issue_zeroout() returns -EREMOTEIO on
 the first call for SCSI device that doesn't support WRITE SAME
Date: Fri, 3 Feb 2017 07:55:38 +0000
Message-ID: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: ja-JP
Content-ID: <C4F9F08CC46E0741B394DB52BF94359F@gisp.nec.co.jp>
Sender: linux-block-owner@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I found following ext4 error occurs on a certain storage since v4.10-rc1:
  EXT4-fs (sdc1): Delayed block allocation failed for inode 12 at logical offset 100 with max blocks 2 with error 121
  EXT4-fs (sdc1): This should not happen!! Data will be lost

Error 121 (EREMOTEIO) was returned from blkdev_issue_zeroout().
That came from sd driver because WRITE SAME was sent to the device
which didn't support it.

The problem was introduced by commit e73c23ff736e ("block: add async
variant of blkdev_issue_zeroout"). Before the commit, blkdev_issue_zeroout
fell back to normal zero writing when WRITE SAME failed and it seems
sd driver's heuristics depends on that behaviour.

Below is a band-aid fix to restore the fallback behaviour for sd. Although
there should be better fix as retrying blindly is not a good idea...

v4.10-rc6:
  # cat /sys/block/sdc/queue/write_same_max_bytes
  33553920
  # fallocate -v -z -l 512 /dev/sdc1
  fallocate: fallocate failed: Remote I/O error
  # cat /sys/block/sdc/queue/write_same_max_bytes
  0
  # fallocate -v -z -l 512 /dev/sdc1
  # echo $?
  0

v4.9 or v4.10-rc6 + this patch:
  # grep . /sys/block/sdc/queue/write_same_max_bytes
  33553920
  # fallocate -v -z -l 512 /dev/sdc1
  # echo $?
  0
  # grep . /sys/block/sdc/queue/write_same_max_bytes
  0

diff --git a/block/blk-lib.c b/block/blk-lib.c
index f8c82a9..8e53474 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -360,6 +360,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			 sector_t nr_sects, gfp_t gfp_mask, bool discard)
 {
 	int ret;
+	int pass = 0;
 	struct bio *bio = NULL;
 	struct blk_plug plug;
 
@@ -369,6 +370,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			return 0;
 	}
 
+  retry_other_method:
 	blk_start_plug(&plug);
 	ret = __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
 			&bio, discard);
@@ -378,6 +380,11 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	}
 	blk_finish_plug(&plug);
 
+	if (ret && pass++ == 0) {
+		bio = NULL;
+		goto retry_other_method;
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.