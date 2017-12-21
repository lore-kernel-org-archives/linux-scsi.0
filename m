From: Jeremy Cline <jeremy@jcline.org>
Subject: [PATCH] scsi: sd: Use warn for logs about no caching info
Date: Thu, 21 Dec 2017 20:50:05 +0000
Message-ID: <010001607ad7197e-2f933a99-5ecd-4245-acd8-acfe3e3bdf9a-000000@email.amazonses.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>
List-Id: linux-scsi@vger.kernel.org

When no caching mode information can be found for a disk, use the
warning log level rather than error. It is common for this to occur
with cheap USB sticks.

Signed-off-by: Jeremy Cline <jeremy@jcline.org>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a028ab3322a9..9838d94b047e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2789,7 +2789,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		sd_first_printk(KERN_WARNING, sdkp, "No Caching mode page found\n");
 		goto defaults;
 
 	Page_found:
@@ -2844,7 +2844,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				"Assuming drive cache: write back\n");
 		sdkp->WCE = 1;
 	} else {
-		sd_first_printk(KERN_ERR, sdkp,
+		sd_first_printk(KERN_WARNING, sdkp,
 				"Assuming drive cache: write through\n");
 		sdkp->WCE = 0;
 	}
-- 
2.14.3
