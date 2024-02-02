Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C812E17998;
	Fri,  2 Feb 2024 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859067; cv=none; b=i5AQPs9sSQuzoDthrGkJp7zFul/fM4hi+9/y7PiwQ6dnNeYYn347hEnFqsGyEcXRYrq/y5NPjznYr45Qicfnczbe7vcJq0Xj0jma/uiCKhV/xSsoq3ZQC8mQrNQoGi3wZdMUGMgihVRTnJKGki/f8VgyN5jl1eUaHNrgej0mCUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859067; c=relaxed/simple;
	bh=c5GTW7wgpfIZkih7w/OJt9S4JHy6Bb+j837pYNdKZHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Beh+N8kC9hHQGuDdgjk7Ol2Dr/+vVND/gCHzstuXcvifR3XtQNqKm54mOW+P6kp3lTv1gIPVcg22AgRTotzt9oEQKhhZ81GzPqqh1osI86DxYKB8PqkIrV0/5eadyeFnFaxmvlCe8J127I8JyC6Lz/zrfCFMQrevRatou21tYAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9vw+rPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9vw+rPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F21C433C7;
	Fri,  2 Feb 2024 07:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859067;
	bh=c5GTW7wgpfIZkih7w/OJt9S4JHy6Bb+j837pYNdKZHw=;
	h=From:To:Cc:Subject:Date:From;
	b=B9vw+rPSDNZ6fkDXgTli3gico951GoLYrXv26zvB1qDP2uKx6EUJd1+O8tDbh5ywA
	 JITIsYPmbwesDUDwAJoOPFCiHtB+3/U1l7mMJ14uDUpVnw21rEUYPvTkmSKc1xtuRE
	 tCTl1ZAsFAHfcm3nRhIvnTL4qsO6yraOQ+OfkoNpAq1kNqoxQrwyL83sx2aCJ6Fu7G
	 snCkkX0LtHGQ/tWsvDRb6UPwOLwUIfIbpMDfYcgKmfR8H5hG+lGWgsZOR0dK3EfoTU
	 cI868wSwKCVSg+A2UCmwMRFIvqv7HfAlIsCCTBnySd1L9PPYysa8V3Fua2fp2I71yl
	 IbRrmLrBqpTow==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 00/26] Zone write plugging
Date: Fri,  2 Feb 2024 16:30:38 +0900
Message-ID: <20240202073104.2418230-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patch series introduces zone write plugging (ZWP) as the new
mechanism to control the ordering of writes to zoned block devices.
ZWP replaces zone write locking (ZWL) which is implemented only by
mq-deadline today. ZWP also allows emulating zone append operations
using regular writes for zoned devices that do not natively support this
operation (e.g. SMR HDDs). This patch series removes the scsi disk
driver and device mapper zone append emulation to use ZWP emulation.

Unlike ZWL which operates on requests, ZWP operates on BIOs. A zone
write plug is simply a BIO list that is atomically manipulated using a
spinlock and a kblockd submission work. A write BIO to a zone is
"plugged" to delay its execution if a write BIO for the same zone was
already issued, that is, if a write request for the same zone is being
executed. The next plugged BIO is unplugged and issued once the write
request completes.

This mechanism allows to:
 - Untangle zone write ordering from the block IO schedulers. This
   allows removing the restriction on using only mq-deadline for zoned
   block devices. Any block IO scheduler, including "none" can be used.
 - Zone write plugging operates on BIOs instead of requests. Plugged
   BIOs waiting for execution thus do not hold scheduling tags and thus
   do not prevent other BIOs from being submitted to the device (reads
   or writes to other zones). Depending on the workload, this can
   significantly improve the device use and the performance.
 - Both blk-mq (request) based zoned devices and BIO-based devices (e.g.
   device mapper) can use ZWP. It is mandatory for the
   former but optional for the latter: BIO-based driver can use zone
   write plugging to implement write ordering guarantees, or the drivers
   can implement their own if needed.
 - The code is less invasive in the block layer and in device drivers.
   ZWP implementation is mostly limited to blk-zoned.c, with some small
   changes in blk-mq.c, blk-merge.c and bio.c.

Performance evaluation results are shown below.

The series is organized as follows:

 - Patch 1 to 5 are preparatory changes for patch 6.
 - Patch 6 introduce ZWP
 - Patch 7 and 8 add zone append emulation to ZWP.
 - Patch 9 to 16 modify zoned block device drivers to use ZWP and
   prepare for the removal of ZWL.
 - Patch 17 to 24 remove zone write locking
 - Finally, Patch 24 and 25 improve ZWP (memory usage reduction and
   debugfs attributes).

Overall, these changes do not increase the amount of code (small
reduction achieved looking at the diff-stat, but in fact, the reduction
is much larger if comments are ignored).

Many thanks must go to Christoph Hellwig for comments and suggestions
he provided on earlier versions of these patches.

Performance evaluation results
==============================

Environments:
 - Xeon 8-cores/16-threads, 128GB of RAM
 - Kernel:
   - Baseline: 6.8-rc2, Linus tree as of 2024-02-01
   - Baseline-next: Jens block/for-next branch as of 2024-02-01
   - ZWP: Jens block/for-next patched to add zone write plugging
   (all kernels were compiled with the same configuration turning off
   most heavy debug features)

Workoads:
 - seqw4K1: 4KB sequential write, qd=1
 - seqw4K16: 4KB sequential write, qd=16
 - seqw1M16: 1MB sequential write, qd=16
 - rndw4K16: 4KB random write, qd=16
 - rndw128K16: 128KB random write, qd=16
 - btrfs workoad: Single fio job writing 128 MB files using 128 KB
   direct IOs at qd=16.

Devices:
 - nullblk (zoned): 4096 zones of 256 MB, no zone resource limits.
 - NVMe ZNS drive: 1 TB ZNS drive with 2GB zone size, 14 max open/active
   zones.
 - SMR HDD: 26 TB disk with 256MB zone size and 128 max open zones.

For ZWP, the result show the performance percentage increase (or
decrease) against current for-next.

1) null_blk zoned device:

               +---------+----------+----------+----------+------------+
               | seqw4K1 | seqw4K16 | seqw1M16 | rndw4K16 | rndw128K16 |
               | (MB/s)  |  (MB/s)  |  (MB/s)  |  (KIOPS) |   (KIOPS)  |
+--------------+---------+----------+----------+----------+------------+
|   Baseline   | 1005    | 881      | 15600    | 564      | 217        |
|  mq-deadline |         |          |          |          |            |
+--------------+---------+----------+----------+----------+------------+
| Baseline-next| 921     | 813      | 14300    | 817      | 330        |
|  mq-deadline |         |          |          |          |            |
+--------------+---------+----------+----------+----------+------------+
|      ZWP     | 946     | 826      | 15000    | 935      | 358        |
|  mq-deadline |(+2%)    | (+1%)    | (+4%)    | (+14%)   | (+8%)      |
+--------------+---------+----------+----------+----------+------------+
|      ZWP     | 2937    | 1882     | 19900    | 2286     | 709        |
|     none     | (+218%) | (+131%)  | (+39%)   | (+179%)  | (+114%)    |
+--------------+---------+----------+----------+----------+------------+

For-next mq-deadline changes and ZWP significantly increase random write
performance but slightly reduce sequential write performance compared to
ZWL.  However, ZWP ability to run fast block devices with the none
scheduler result in very large performance increase for all workloads.

2) NVMe ZNS drive:

               +---------+----------+----------+----------+------------+
               | seqw4K1 | seqw4K16 | seqw1M16 | rndw4K16 | rndw128K16 |
               | (MB/s)  |  (MB/s)  |  (MB/s)  |  (KIOPS) |   (KIOPS)  |
+--------------+---------+----------+----------+----------+------------+
|   Baseline   | 183     | 798      | 1104     | 53.5     | 14.6       |
|  mq-deadline |         |          |          |          |            |
+--------------+---------+----------+----------+----------+------------+
| Baseline-next| 180     | 261      | 1113     | 51.6     | 14.9       |
|  mq-deadline |         |          |          |          |            |
+--------------+---------+----------+----------+----------+------------+
|      ZWP     | 181     | 671      | 1109     | 51.7     | 14.7       |
|  mq-deadline |(+0%)    | (+157%)  | (+0%)    | (+0%)    | (-1%)      |
+--------------+---------+----------+----------+----------+------------+
|      ZWP     | 190     | 660      | 1106     | 51.4     | 15.1       |
|     none     | (+5%)   | (+152%)  | (+0%)    | (-0%)    | (+1%)      |
+--------------+---------+----------+----------+----------+------------+

The current block/for-next significantly regress sequential small write
performace at high queue depth due to lost BIO merge oportunities.
ZWP corrects this but is not as efficient as ZWL for this workload.

3) SMR SATA HDD:

               +---------+----------+----------+----------+------------+
               | seqw4K1 | seqw4K16 | seqw1M16 | rndw4K16 | rndw128K16 |
               | (MB/s)  |  (MB/s)  |  (MB/s)  |  (IOPS)  |   (IOPS)   |
+--------------+---------+----------+----------+----------+------------+
|   Baseline   | 121     | 251      | 251      | 2471     | 664        |
|  mq-deadline |         |          |          |          |            |
+--------------+---------+----------+----------+----------+------------+
| Baseline-next| 121     | 137      | 249      | 2428     | 649        |
|  mq-deadline |         |          |          |          |            |
+--------------+---------+----------+----------+----------+------------+
|      ZWP     | 118     | 137      | 251      | 2415     | 651        |
|  mq-deadline |(-2%)    | (+0%)    | (+0%)    | (+0%)    | (+0%)      |
+--------------+---------+----------+----------+----------+------------+
|      ZWP     | 117     | 238      | 251      | 2400     | 666        |
|     none     | (-3%)   | (+73%)   | (+0%)    | (-1%)    | (+2%)      |
+--------------+---------+----------+----------+----------+------------+

Same observation as for ZNS: for-next regress sequential high QD
performance but ZWP brings back better performance, still slightly lower
than with ZWL.

4) Zone append tests using btrfs:

                +-------------+-------------+-----------+-------------+
                |  null-blk   |  null_blk   |    ZNS    |     SMR     |
                |  native ZA  | emulated ZA | native ZA | emulated ZA |
                |    (MB/s)   |   (MB/s)    |   (MB/s)  |    (MB/s)   |
+---------------+-------------+-------------+-----------+-------------+
|    Baseline   | 2412        | N/A         | 1080      | 203         |
|   mq-deadline |             |             |           |             |
+---------------+-------------+-------------+-----------+-------------+
| Baseline-next | 2471        | N/A         | 1084      | 209         |
|  mq-deadline  |             |             |           |             |
+---------------+-------------+-------------+-----------+-------------+
|      ZWP      | 2397        | 3025        | 1085      | 245         |
|  mq-deadline  | (-2%)       |             | (+0%)     | (+17%)      |
+---------------+-------------+-------------+-----------+-------------+
|      ZWP      | 2614        | 3301        | 1082      | 247         |
|      none     | (+5%)       |             | (-0%)     | (+18%)      |
+---------------+-------------+-------------+-----------+-------------+

With a more realistic use of the device by the FS, ZWP significantly
improves SMR HDD performance thanks to the more efficient zone append
emulation compared to ZWL.

Damien Le Moal (26):
  block: Restore sector of flush requests
  block: Remove req_bio_endio()
  block: Introduce bio_straddle_zones() and bio_offset_from_zone_start()
  block: Introduce blk_zone_complete_request_bio()
  block: Allow using bio_attempt_back_merge() internally
  block: Introduce zone write plugging
  block: Allow zero value of max_zone_append_sectors queue limit
  block: Implement zone append emulation
  block: Allow BIO-based drivers to use blk_revalidate_disk_zones()
  dm: Use the block layer zone append emulation
  scsi: sd: Use the block layer zone append emulation
  ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
  null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
  null_blk: Introduce zone_append_max_sectors attribute
  null_blk: Introduce fua attribute
  nvmet: zns: Do not reference the gendisk conv_zones_bitmap
  block: Remove BLK_STS_ZONE_RESOURCE
  block: Simplify blk_revalidate_disk_zones() interface
  block: mq-deadline: Remove support for zone write locking
  block: Remove elevator required features
  block: Do not check zone type in blk_check_zone_append()
  block: Move zone related debugfs attribute to blk-zoned.c
  block: Remove zone write locking
  block: Do not special-case plugging of zone write operations
  block: Reduce zone write plugging memory usage
  block: Add zone_active_wplugs debugfs entry

 block/Kconfig                     |    4 -
 block/Makefile                    |    1 -
 block/bio.c                       |    7 +
 block/blk-core.c                  |   13 +-
 block/blk-flush.c                 |    1 +
 block/blk-merge.c                 |   22 +-
 block/blk-mq-debugfs-zoned.c      |   22 -
 block/blk-mq-debugfs.c            |    4 +-
 block/blk-mq-debugfs.h            |   11 +-
 block/blk-mq.c                    |  134 ++--
 block/blk-mq.h                    |   31 -
 block/blk-settings.c              |   51 +-
 block/blk-sysfs.c                 |    2 +-
 block/blk-zoned.c                 | 1143 ++++++++++++++++++++++++++---
 block/blk.h                       |   69 +-
 block/elevator.c                  |   46 +-
 block/elevator.h                  |    1 -
 block/genhd.c                     |    2 +-
 block/mq-deadline.c               |  176 +----
 drivers/block/null_blk/main.c     |   52 +-
 drivers/block/null_blk/null_blk.h |    2 +
 drivers/block/null_blk/zoned.c    |   32 +-
 drivers/block/ublk_drv.c          |    4 +-
 drivers/block/virtio_blk.c        |    2 +-
 drivers/md/dm-core.h              |   11 +-
 drivers/md/dm-zone.c              |  470 ++----------
 drivers/md/dm.c                   |   44 +-
 drivers/md/dm.h                   |    7 -
 drivers/nvme/host/zns.c           |    2 +-
 drivers/nvme/target/zns.c         |   10 +-
 drivers/scsi/scsi_lib.c           |    1 -
 drivers/scsi/sd.c                 |    8 -
 drivers/scsi/sd.h                 |   19 -
 drivers/scsi/sd_zbc.c             |  335 +--------
 include/linux/blk-mq.h            |   85 +--
 include/linux/blk_types.h         |   30 +-
 include/linux/blkdev.h            |  102 ++-
 37 files changed, 1453 insertions(+), 1503 deletions(-)
 delete mode 100644 block/blk-mq-debugfs-zoned.c

-- 
2.43.0

