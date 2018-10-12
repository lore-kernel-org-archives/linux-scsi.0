From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 05/11] block: Limit allocation of zone
	descriptors for report zones
Date: Fri, 12 Oct 2018 11:30:06 +0900
Message-ID: <20181012023012.29923-6-damien.lemoal@wdc.com>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012023012.29923-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

There is no point in allocating more zone descriptors than the number of
zones a block device has for doing a zone report. Avoid doing that in
blkdev_report_zones_ioctl() by limiting the number of zone decriptors
allocated internally to process the user request.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 32e377f755d8..bb4ed69f917f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -355,8 +355,7 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!rep.nr_zones)
 		return -EINVAL;
 
-	if (rep.nr_zones > INT_MAX / sizeof(struct blk_zone))
-		return -ERANGE;
+	rep.nr_zones = min(blkdev_nr_zones(bdev), rep.nr_zones);
 
 	zones = kvmalloc_array(rep.nr_zones, sizeof(struct blk_zone),
 			       GFP_KERNEL | __GFP_ZERO);
-- 
2.17.1
