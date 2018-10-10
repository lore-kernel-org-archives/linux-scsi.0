From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 07/11] block: Introduce BLKGETNRZONES ioctl
Date: Wed, 10 Oct 2018 10:52:35 +0900
Message-ID: <20181010015239.24930-8-damien.lemoal@wdc.com>
References: <20181010015239.24930-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010015239.24930-1-damien.lemoal@wdc.com>
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

Get a zoned block device total number of zones. The device can be a
partition of the whole device. The number of zones is always 0 for
regular block devices.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/ioctl.c                 | 2 ++
 include/uapi/linux/blkzoned.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index f6d2c6f1f050..4825c78a6baa 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -534,6 +534,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
 	case BLKGETZONESZ:
 		return put_uint(arg, bdev_zone_sectors(bdev));
+	case BLKGETNRZONES:
+		return put_uint(arg, blkdev_nr_zones(bdev));
 	case HDIO_GETGEO:
 		return blkdev_getgeo(bdev, argp);
 	case BLKRAGET:
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index daf47351d519..1f96f7f41a86 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -142,5 +142,6 @@ struct blk_zone_range {
 #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
 #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
 #define BLKGETZONESZ	_IOW(0x12, 132, unsigned int)
+#define BLKGETNRZONES	_IOW(0x12, 133, unsigned int)
 
 #endif /* _UAPI_BLKZONED_H */
-- 
2.17.1
