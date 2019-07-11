From: Keyur Patel <iamkeyur96@gmail.com>
Subject: [PATCH] scsi: aha1740: Use !x in place of NULL comparisons
Date: Thu, 11 Jul 2019 19:48:33 -0400
Message-ID: <20190711234833.27475-1-iamkeyur96@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: iamkeyur96@gmail.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Change (x == NULL) to !x and (x != NULL) to x, to fix
following checkpatch.pl warnings:
CHECK: Comparison to NULL could be written "!x".

Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>
---
 drivers/scsi/aha1740.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index da4150c17781..ec81b7be0a60 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -385,7 +385,7 @@ static int aha1740_queuecommand_lck(struct scsi_cmnd * SCpnt,
 	SCpnt->host_scribble = dma_alloc_coherent (&host->edev->dev,
 						   sizeof (struct aha1740_sg),
 						   &sg_dma, GFP_ATOMIC);
-	if(SCpnt->host_scribble == NULL) {
+	if (!(SCpnt->host_scribble)) {
 		printk(KERN_WARNING "aha1740: out of memory in queuecommand!\n");
 		return 1;
 	}
@@ -576,7 +576,7 @@ static int aha1740_probe (struct device *dev)
 	       translation ? "en" : "dis");
 	shpnt = scsi_host_alloc(&aha1740_template,
 			      sizeof(struct aha1740_hostdata));
-	if(shpnt == NULL)
+	if (!shpnt)
 		goto err_release_region;
 
 	shpnt->base = 0;
-- 
2.22.0
