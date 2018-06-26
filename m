From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] ata: Fix ZBC_OUT all bit handling
Date: Tue, 26 Jun 2018 16:18:38 +0900
Message-ID: <20180626071838.15140-3-damien.lemoal@wdc.com>
References: <20180626071838.15140-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180626071838.15140-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If the ALL bit is set in the ZBC_OUT command, the command zone ID field
(block) should be ignored.

Reported-by: David Butterfield <david.butterfield@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-scsi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a5543751f446..aad1b01447de 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3805,7 +3805,14 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 		 */
 		goto invalid_param_len;
 	}
-	if (block >= dev->n_sectors) {
+
+	all = cdb[14] & 0x1;
+	if (all) {
+		/*
+		 * Ignore the block address (zone ID) as defined by ZBC.
+		 */
+		block = 0;
+	} else if (block >= dev->n_sectors) {
 		/*
 		 * Block must be a valid zone ID (a zone start LBA).
 		 */
@@ -3813,8 +3820,6 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 	}
 
-	all = cdb[14] & 0x1;
-
 	if (ata_ncq_enabled(qc->dev) &&
 	    ata_fpdma_zac_mgmt_out_supported(qc->dev)) {
 		tf->protocol = ATA_PROT_NCQ_NODATA;
-- 
2.17.1
