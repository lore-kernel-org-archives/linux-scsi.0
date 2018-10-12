From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v4 03/11] scsi: sd_zbc: Fix sd_zbc_check_zones()
	error checks
Date: Fri, 12 Oct 2018 19:08:42 +0900
Message-ID: <20181012100850.23316-4-damien.lemoal@wdc.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012100850.23316-1-damien.lemoal@wdc.com>
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

The unsigned 32 bits overflow check for the zone size value is already
done within sd_zbc_check_zones() with the test:

} else if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {

so there is no need to check again for an out of range value in
sd_zbc_read_zones(). Simplify the code and fix sd_zbc_check_zones()
error return to -EFBIG instead of -ENODEV if the zone size is too large.
Change the return type of sd_zbc_check_zones() to an int for the error
code and return the zone size (zone_blocks) through a u32 pointer to
avoid overflowing the signed 32 return value.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ca73c46931c0..0678e1e108b0 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -373,7 +373,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
  * Returns the zone size in number of blocks upon success or an error code
  * upon failure.
  */
-static s64 sd_zbc_check_zones(struct scsi_disk *sdkp)
+static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 {
 	u64 zone_blocks = 0;
 	sector_t max_lba, block = 0;
@@ -381,7 +381,7 @@ static s64 sd_zbc_check_zones(struct scsi_disk *sdkp)
 	unsigned char *rec;
 	unsigned int buf_len;
 	unsigned int list_length;
-	s64 ret;
+	int ret;
 	u8 same;
 
 	/* Get a buffer */
@@ -472,9 +472,10 @@ static s64 sd_zbc_check_zones(struct scsi_disk *sdkp)
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Zone size too large\n");
-		ret = -ENODEV;
+		ret = -EFBIG;
 	} else {
-		ret = zone_blocks;
+		*zblocks = zone_blocks;
+		ret = 0;
 	}
 
 out_free:
@@ -668,7 +669,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp, u32 zone_blocks)
 
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
-	int64_t zone_blocks;
+	u32 zone_blocks;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))
@@ -687,12 +688,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	 * Check zone size: only devices with a constant zone size (except
 	 * an eventual last runt zone) that is a power of 2 are supported.
 	 */
-	zone_blocks = sd_zbc_check_zones(sdkp);
-	ret = -EFBIG;
-	if (zone_blocks != (u32)zone_blocks)
-		goto err;
-	ret = zone_blocks;
-	if (ret < 0)
+	ret = sd_zbc_check_zones(sdkp, &zone_blocks);
+	if (ret != 0)
 		goto err;
 
 	/* The drive satisfies the kernel restrictions: set it up */
-- 
2.17.1
