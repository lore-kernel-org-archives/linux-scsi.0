From: Boaz Harrosh <boaz@plexistor.com>
Subject: [PATCH 2/2] brd: Fix brd_direct_access with partitions
Date: Wed, 30 Jul 2014 17:18:47 +0300
Message-ID: <53D8FEC7.8020804@plexistor.com>
References: <53D7CDDD.1000302@gmail.com> <1406654379.2767.1.camel@rzwisler-mobl1.amr.corp.intel.com> <53D8D2C4.1030101@gmail.com> <53D8FE1F.1060009@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53D8FE1F.1060009@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nick Piggin <npiggin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


When brd_direct_access() is called on a partition-bdev
it would access the wrong sector. And caller would then
corrupt the device's data.

This is a preliminary fix, Matthew Wilcox has a patch
in his DAX patchset which will define a global wrapper
to bdev->bd_disk->fops->direct_access that will do the
proper checks and translations before calling a driver
global member. (The way it is done at the rest of the
block stack)

CC: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 92334f6..7506864 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -378,9 +378,10 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
 
 	if (!brd)
 		return -ENODEV;
+	sector += get_start_sect(bdev);
 	if (sector & (PAGE_SECTORS-1))
 		return -EINVAL;
-	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
+	if (unlikely(sector + PAGE_SECTORS > part_nr_sects_read(bdev->bd_part)))
 		return -ERANGE;
 	page = brd_insert_page(brd, sector);
 	if (!page)
-- 
1.9.3
