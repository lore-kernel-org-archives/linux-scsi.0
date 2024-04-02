Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1A21DFD0;
	Tue,  2 Apr 2024 12:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061551; cv=none; b=NacmAz2U23qmYhY8gNvsDGuZz+SFFsMLnOi7e9sqG7jqpTg57f9XagwMVRWoRAlf8zB4lrTEe0kCkgiBsjyHsdoQHtKcFT/Bd4PyR7DZmLlrJqihxRapWWmuluvGsQ4TskItMHJCEETkysn1GCRM/jQpDkPO0x/pOvPC9TaZTcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061551; c=relaxed/simple;
	bh=gyzQ1IUpOZ/Jx5C8eFPM6DJV6Bu8lAoyMT3fGp7Tx2s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LLKgeA6LIO7Zlvrvmg0CMGJA1XlG2PwRXHZFZHsiiDDaUrvUq0+//FCuYKdG02PgrCwHM0NCyAzZDq7YjG45zDIc69NmOKGozjUFAVxZh4V/jT26BUjKPjlOCyiR17AFPsdD1uI9rn3AZgZtRIw6YDpcMPchfw3G9W8v/gJBkko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMwH77oO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMwH77oO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735AFC433C7;
	Tue,  2 Apr 2024 12:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061550;
	bh=gyzQ1IUpOZ/Jx5C8eFPM6DJV6Bu8lAoyMT3fGp7Tx2s=;
	h=From:To:Subject:Date:From;
	b=FMwH77oOXzBbCrLhKLxSwhimMe0ZvvX0BrVANjRPyOqNCJr4o3ezZeylpkKEjuZMy
	 iU3cgmYn39fCVxdGGUkHJRkE7LzI4kVf3WemHMxWpf9biyhpFAZE6k0cbzOJhFrMpr
	 7rgov9g9FKqisF7gjT3v2Oo5pIOvbUYGFvqCvhu/2rbwzrW+InuiNS2gDXB/N6sp00
	 7lT/MZG3oXJZxHSEAQODlWAnnHgfZaRYJGhIWOByvdL9Q2uynoa2qpdGdIV7Q1Fl6k
	 j9hU0lEls6xzndjSykTyIANWvPK70oTtyW13Vv49BeYX9OVT/u3ZYtfsCExcUVPIBc
	 jY4O5rlFmV2SQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 00/28] Zone write plugging
Date: Tue,  2 Apr 2024 21:38:39 +0900
Message-ID: <20240402123907.512027-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
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

The series is based on block/for-next and organized as follows:

 - Patch 1 to 6 are preparatory changes for patch 7.
 - Patch 7 and 8 introduce ZWP
 - Patch 9 and 10 add zone append emulation to ZWP.
 - Patch 11 to 18 modify zoned block device drivers to use ZWP and
   prepare for the removal of ZWL.
 - Patch 19 to 28 remove zone write locking

Overall, these changes do not significantly increase the amount of code
(the higher number of addition shown by diff-stat is in fact due to a
larger amount of comments in the code).

Many thanks must go to Christoph Hellwig for comments and suggestions
he provided on earlier versions of these patches.

Performance evaluation results
==============================

Environments:
 - Intel Xeon 16-cores/32-threads, 128GB of RAM
 - Kernel:
   - ZWL (baseline): block/for-next (based on 6.9.0-rc2)
   - ZWP: block/for-next patched kernel to add zone write plugging
     (both kernels were compiled with the same configuration turning
     off most heavy debug features)

Workoads:
 - seqw4K1: 4KB sequential write, qd=1
 - seqw4K16: 4KB sequential write, qd=16
 - seqw1M16: 1MB sequential write, qd=16
 - rndw4K16: 4KB random write, qd=16
 - rndw128K16: 128KB random write, qd=16
 - btrfs workoad: Single fio job writing 128 MB files using 128 KB
   direct IOs at qd=16.

Devices:
 - nullblk (zoned): 4096 zones of 256 MB, 128 max open zones.
 - NVMe ZNS drive: 1 TB ZNS drive with 2GB zone size, 14 max open and
   active zones.
 - SMR HDD: 20 TB disk with 256MB zone size, 128 max open zones.

For ZWP, the result show the performance percentage increase (or
decrease) against ZWL (baseline) case.

1) null_blk zoned device:

             +--------+--------+-------+--------+---------+---------+
             |seqw4K1 |seqw4K16|seqw1M1|seqw1M16|rndw4K16|rndw128K16|
             |(MB/s)  | (MB/s) |(MB/s) | (MB/s) | (KIOPS)| (KIOPS)  |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWL    | 940    | 840    | 18550 | 14400  | 424    | 167      |
 |mq-deadline|        |        |       |        |        |          |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWP    | 943    | 845    | 18660 | 14770  | 461    | 165      |
 |mq-deadline| (+0%)  | (+0%)  | (+0%) | (+1%)  | (+8%)  | (-1%)    |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWP    | 756    | 668    | 16020 | 12980  | 135    | 101      |
 |    bfq    | (-19%) | (-20%) | (-13%)| (-9%)  | (-68%) | (-39%)   |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWP    | 2639   | 1715   | 28190 | 19760  | 344    | 150      |
 |   none    | (+180%)| (+104%)| (+51%)| (+37%) | (-18%) | (-10%)   |
 +-----------+--------+--------+-------+--------+--------+----------+

ZWP with mq-deadline gives performance very similar to zone write
locking, showing that zone write plugging overhead is acceptable.
But ZWP ability to run fast block devices with the none scheduler
shows brings all the benefits of zone write plugging and results in
significant performance increase for all workloads. The exception to
this are random write workloads with multiple jobs: for these, the
faster request submission rate achieved by zone write plugging results
in higher contention on null-blk zone spinlock, which degrades
performance.

2) NVMe ZNS drive:

             +--------+--------+-------+--------+--------+----------+
             |seqw4K1 |seqw4K16|seqw1M1|seqw1M16|rndw4K16|rndw128K16|
             |(MB/s)  | (MB/s) |(MB/s) | (MB/s) | (KIOPS)|  (KIOPS) |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWL    | 183    | 702    | 1066  | 1103   | 53.5   | 14.5     |
 |mq-deadline|        |        |       |        |        |          |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWP    | 183    | 719    | 1086  | 1108   | 55.6   | 14.7     |
 |mq-deadline| (-0%)  | (+1%)  | (+0%) | (+0%)  | (+3%)  | (+1%)    |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWP    | 178    | 691    | 1082  | 1106   | 30.8   | 11.5     |
 |    bfq    | (-3%)  | (-2%)  | (-0%) | (+0%)  | (-42%) | (-20%)   |
 +-----------+--------+--------+-------+--------+--------+----------+
 |    ZWP    | 190    | 666    | 1083  | 1108   | 51.4   | 14.7     |
 |   none    | (+4%)  | (-5%)  | (+0%) | (+0%)  | (-4%)  | (+0%)    |
 +-----------+--------+--------+-------+--------+--------+----------+

Zone write plugging overhead does not significantly impact performance.
Similar to nullblk, using the none scheduler leads to performance
increase for most workloads.

3) SMR SATA HDD:

             +-------+--------+-------+--------+--------+----------+
             |seqw4K1|seqw4K16|seqw1M1|seqw1M16|rndw4K16|rndw128K16|
             |(MB/s) | (MB/s) |(MB/s) | (MB/s) | (KIOPS)|  (KIOPS) |
 +-----------+-------+--------+-------+--------+--------+----------+
 |    ZWL    | 107   | 243    | 245   | 246    | 2.2    | 0.763    |
 |mq-deadline|       |        |       |        |        |          |
 +-----------+-------+--------+-------+--------+--------+----------+
 |    ZWP    | 107   | 242    | 245   | 245    | 2.2    | 0.772    |
 |mq-deadline| (+0%) | (-0%)  | (+0%) | (-0%)  | (+0%)  | (+0%)    |
 +-----------+-------+--------+-------+--------+--------+----------+
 |    ZWP    | 104   | 241    | 246   | 242    | 2.2    | 0.765    |
 |    bfq    | (-2%) | (-0%)  | (+0%) | (-0%)  | (+0%)  | (+0%)    |
 +-----------+-------+--------+-------+--------+--------+----------+
 |    ZWP    | 115   | 235    | 249   | 242    | 2.2    | 0.763    |
 |   none    | (+7%) | (-3%)  | (+1%) | (-1%)  | (+0%)  | (+0%)    |
 +-----------+-------+--------+-------+--------+--------+----------+

Performance with purely sequential write workloads at high queue depth
somewhat decrease a little when using zone write plugging. This is due
to the different IO pattern that ZWP generates where the first writes to
a zone start being issued when the end of the previous zone are still
being written. Depending on how the disk handles queued commands, seek
may be generated, slightly impacting the throughput achieved. Such pure
sequential write workloads are however rare with SMR drives.

4) Zone append tests using btrfs:

             +-------------+-------------+-----------+-------------+
             |  null-blk   |  null_blk   |    ZNS    |     SMR     |
             |  native ZA  | emulated ZA | native ZA | emulated ZA |
             |    (MB/s)   |   (MB/s)    |   (MB/s)  |    (MB/s)   |
 +-----------+-------------+-------------+-----------+-------------+
 |    ZWL    | 2441        | N/A         | 1081      | 243         |
 |mq-deadline|             |             |           |             |
 +-----------+-------------+-------------+-----------+-------------+
 |    ZWP    | 2361        | 2999        | 1085      | 239         |
 |mq-deadline| (-1%)       |             | (+0%)     | (-2%)       |
 +-----------+-------------+-------------+-----------+-------------+
 |    ZWP    | 2299        | 2730        | 1080      | 240         |
 |    bfq    | (-4%)       |             | (+0%)     | (-2%)       |
 +-----------+-------------+-------------+-----------+-------------+
 |    ZWP    | 2443        | 3152        | 1083      | 240         |
 |    none   | (+0%)       |             | (+0%)     | (-1%)       |
 +-----------+-------------+-------------+-----------+-------------+

With a more realistic use of the device though a file system, ZWP does
not introduce significant performance differences, except for SMR for
the same reason as with the fio sequential workloads at high queue
depth.

Changes from v3:
 - Rebase on block/for-next
 - Removed old patch 1 as it is already applied
 - Addressed Bart and Christoph comment in patch 4
 - Merged former patch 8 and 9 together and changed the zone write plug
   allocation to use a mempool
 - Removed the zone_wplugs_mempool_size filed from patch 8 and instead
   directly reference mempool->min_nr
 - Added review tags

Changes from v2:
 - Added Patch 1 (Christoph's comment)
 - Fixed error code setup in Patch 3 (Bart's comment)
 - Split former patch 26 into patches 27 and 28
 - Modified patch 8 (zone write plugging) introduction to remove the
   kmem_cache use and address Bart's and Christoph comments.
 - Changed from using a mempool of zone write plugs to using a simple
   free-list (patch 9)
 - Simplified patch 10 as suggested by Christoph
 - Moved common code to a helper in patch 13 as suggested by Christoph

Changes from v1:
 - Added patch 6
 - Rewrite of patch 7 to use a hash table of dynamically allocated zone
   write plugs. This results in changes in patch 11 and the addition of
   patch 8 and 9.
 - Rebased everything on 6.9.0-rc1
 - Added review tags for patches that did not change

Damien Le Moal (28):
  block: Restore sector of flush requests
  block: Remove req_bio_endio()
  block: Introduce blk_zone_update_request_bio()
  block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
  block: Allow using bio_attempt_back_merge() internally
  block: Remember zone capacity when revalidating zones
  block: Introduce zone write plugging
  block: Fake max open zones limit when there is no limit
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
  block: Replace zone_wlock debugfs entry with zone_wplugs entry
  block: Remove zone write locking
  block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
  block: Do not special-case plugging of zone write operations

 block/Kconfig                     |    5 -
 block/Makefile                    |    1 -
 block/bio.c                       |    7 +
 block/blk-core.c                  |   11 +-
 block/blk-flush.c                 |    1 +
 block/blk-merge.c                 |   22 +-
 block/blk-mq-debugfs-zoned.c      |   22 -
 block/blk-mq-debugfs.c            |    3 +-
 block/blk-mq-debugfs.h            |    6 +-
 block/blk-mq.c                    |  131 ++-
 block/blk-mq.h                    |   31 -
 block/blk-settings.c              |   46 +-
 block/blk-sysfs.c                 |    2 +-
 block/blk-zoned.c                 | 1353 +++++++++++++++++++++++++++--
 block/blk.h                       |   69 +-
 block/elevator.c                  |   46 +-
 block/elevator.h                  |    1 -
 block/genhd.c                     |    3 +-
 block/mq-deadline.c               |  176 +---
 drivers/block/null_blk/main.c     |   22 +-
 drivers/block/null_blk/null_blk.h |    2 +
 drivers/block/null_blk/zoned.c    |   23 +-
 drivers/block/ublk_drv.c          |    5 +-
 drivers/block/virtio_blk.c        |    2 +-
 drivers/md/dm-core.h              |    2 +-
 drivers/md/dm-zone.c              |  476 +---------
 drivers/md/dm.c                   |   75 +-
 drivers/md/dm.h                   |    4 +-
 drivers/nvme/host/core.c          |    2 +-
 drivers/nvme/target/zns.c         |   10 +-
 drivers/scsi/scsi_lib.c           |    1 -
 drivers/scsi/sd.c                 |    8 -
 drivers/scsi/sd.h                 |   19 -
 drivers/scsi/sd_zbc.c             |  335 +------
 include/linux/blk-mq.h            |   85 +-
 include/linux/blk_types.h         |   30 +-
 include/linux/blkdev.h            |  104 ++-
 37 files changed, 1677 insertions(+), 1464 deletions(-)
 delete mode 100644 block/blk-mq-debugfs-zoned.c

-- 
2.44.0

