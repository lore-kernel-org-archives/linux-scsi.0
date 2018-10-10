From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 06/11] block: Introduce BLKGETZONESZ ioctl
Date: Wed, 10 Oct 2018 10:52:34 +0900
Message-ID: <20181010015239.24930-7-damien.lemoal@wdc.com>
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

Get a zoned block device zone size in number of 512 B sectors.
The zone size is always 0 for regular block devices.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/ioctl.c                 | 2 ++
 include/uapi/linux/blkzoned.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 3884d810efd2..f6d2c6f1f050 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -532,6 +532,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
 	case BLKRESETZONE:
 		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
+	case BLKGETZONESZ:
+		return put_uint(arg, bdev_zone_sectors(bdev));
 	case HDIO_GETGEO:
 		return blkdev_getgeo(bdev, argp);
 	case BLKRAGET:
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index ff5a5db8906a..daf47351d519 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -137,8 +137,10 @@ struct blk_zone_range {
  *                 sector specified in the report request structure.
  * @BLKRESETZONE: Reset the write pointer of the zones in the specified
  *                sector range. The sector range must be zone aligned.
+ * @BLKGETZONESZ: Get the device zone size in number of 512 B sectors.
  */
 #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
 #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
+#define BLKGETZONESZ	_IOW(0x12, 132, unsigned int)
 
 #endif /* _UAPI_BLKZONED_H */
-- 
2.17.1
