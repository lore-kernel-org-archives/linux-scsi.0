From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 08/12] scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()
Date: Fri, 15 Sep 2017 19:06:41 +0900
Message-ID: <20170915100645.17999-9-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The three values starting at byte 8 of the Zoned Block Device
Characteristics VPD page B6h are 32 bits values, not 64bits. So use
get_unaligned_be32() to retrieve the values and not get_unaligned_be64()

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Cc: <stable@vger.kernel.org>

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sd_zbc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 37b33adbb2ef..7e30d0c22930 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -385,15 +385,15 @@ static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
 	if (sdkp->device->type != TYPE_ZBC) {
 		/* Host-aware */
 		sdkp->urswrz = 1;
-		sdkp->zones_optimal_open = get_unaligned_be64(&buf[8]);
-		sdkp->zones_optimal_nonseq = get_unaligned_be64(&buf[12]);
+		sdkp->zones_optimal_open = get_unaligned_be32(&buf[8]);
+		sdkp->zones_optimal_nonseq = get_unaligned_be32(&buf[12]);
 		sdkp->zones_max_open = 0;
 	} else {
 		/* Host-managed */
 		sdkp->urswrz = buf[4] & 1;
 		sdkp->zones_optimal_open = 0;
 		sdkp->zones_optimal_nonseq = 0;
-		sdkp->zones_max_open = get_unaligned_be64(&buf[16]);
+		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
 	}
 
 	return 0;
-- 
2.13.5
