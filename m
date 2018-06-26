From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 1/2] ata: Fix ZBC_OUT command block check
Date: Tue, 26 Jun 2018 20:56:54 +0900
Message-ID: <20180626115655.15562-2-damien.lemoal@wdc.com>
References: <20180626115655.15562-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180626115655.15562-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The block (LBA) specified must not exceed the last addressable LBA,
which is dev->nr_sectors - 1. So fix the correct check is
"if (block >= dev->n_sectors)" and not "if (block > dev->n_sectords)".

Additionally, the asc/ascq to return for an LBA that is not a zone start
LBA should be ILLEGAL REQUEST, regardless if the bad LBA is out of
range.

Reported-by: David Butterfield <david.butterfield@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
---
 drivers/ata/libata-scsi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6a91d04351d9..a5543751f446 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3805,8 +3805,13 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 		 */
 		goto invalid_param_len;
 	}
-	if (block > dev->n_sectors)
-		goto out_of_range;
+	if (block >= dev->n_sectors) {
+		/*
+		 * Block must be a valid zone ID (a zone start LBA).
+		 */
+		fp = 2;
+		goto invalid_fld;
+	}
 
 	all = cdb[14] & 0x1;
 
@@ -3837,10 +3842,6 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
  invalid_fld:
 	ata_scsi_set_invalid_field(qc->dev, scmd, fp, 0xff);
 	return 1;
- out_of_range:
-	/* "Logical Block Address out of range" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x00);
-	return 1;
 invalid_param_len:
 	/* "Parameter list length error" */
 	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
-- 
2.17.1
