From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 01/11] scsi: sd_zbc: Rearrange code
Date: Fri, 12 Oct 2018 11:30:02 +0900
Message-ID: <20181012023012.29923-2-damien.lemoal@wdc.com>
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

Move the urswrz check out of sd_zbc_read_zones() and into
sd_zbc_read_zoned_characteristics() where that value is obtained (read
from the disk zoned characteristics VPD page). Since this function now
does more than simply reading the VPD page, rename it to
sd_zbc_check_zoned_characteristics().
Also fix the error message displayed when reading that VPD page fails.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd_zbc.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 412c1787dcd9..0b7d8787f785 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -305,19 +305,19 @@ void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 }
 
 /**
- * sd_zbc_read_zoned_characteristics - Read zoned block device characteristics
+ * sd_zbc_check_zoned_characteristics - Check zoned block device characteristics
  * @sdkp: Target disk
  * @buf: Buffer where to store the VPD page data
  *
- * Read VPD page B6.
+ * Read VPD page B6, get information and check that reads are unconstrained.
  */
-static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
-					     unsigned char *buf)
+static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
+					      unsigned char *buf)
 {
 
 	if (scsi_get_vpd_page(sdkp->device, 0xb6, buf, 64)) {
 		sd_printk(KERN_NOTICE, sdkp,
-			  "Unconstrained-read check failed\n");
+			  "Read zoned characteristics VPD page failed\n");
 		return -ENODEV;
 	}
 
@@ -335,6 +335,18 @@ static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
 		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
 	}
 
+	/*
+	 * Check for unconstrained reads: host-managed devices with
+	 * constrained reads (drives failing read after write pointer)
+	 * are not supported.
+	 */
+	if (!sdkp->urswrz) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+			  "constrained reads devices are not supported\n");
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
@@ -675,24 +687,11 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 		 */
 		return 0;
 
-	/* Get zoned block device characteristics */
-	ret = sd_zbc_read_zoned_characteristics(sdkp, buf);
+	/* Check zoned block device characteristics (unconstrained reads) */
+	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
 	if (ret)
 		goto err;
 
-	/*
-	 * Check for unconstrained reads: host-managed devices with
-	 * constrained reads (drives failing read after write pointer)
-	 * are not supported.
-	 */
-	if (!sdkp->urswrz) {
-		if (sdkp->first_scan)
-			sd_printk(KERN_NOTICE, sdkp,
-			  "constrained reads devices are not supported\n");
-		ret = -ENODEV;
-		goto err;
-	}
-
 	/* Check capacity */
 	ret = sd_zbc_check_capacity(sdkp, buf);
 	if (ret)
-- 
2.17.1
