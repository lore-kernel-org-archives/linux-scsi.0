From: Keyur Patel <iamkeyur96@gmail.com>
Subject: [PATCH] scsi: g_NCR5380: Use !x in place of NULL comparisons
Date: Thu, 11 Jul 2019 19:55:46 -0400
Message-ID: <20190711235546.28081-1-iamkeyur96@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: iamkeyur96@gmail.com, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Change (x == NULL) to !x and (x != NULL) to x, to fix
following checkpatch.pl warnings:
CHECK: Comparison to NULL could be written "!x".

Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>
---
 drivers/scsi/g_NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 2ab774e62e40..6813094155d3 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -312,7 +312,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	}
 
 	instance = scsi_host_alloc(tpnt, sizeof(struct NCR5380_hostdata));
-	if (instance == NULL) {
+	if (!instance) {
 		ret = -ENOMEM;
 		goto out_unmap;
 	}
-- 
2.22.0
