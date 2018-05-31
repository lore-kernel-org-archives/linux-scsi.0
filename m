From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aic7xxx: aic79xx: fix potential null pointer dereference on ahd
Date: Thu, 31 May 2018 13:31:17 +0100
Message-ID: <20180531123117.32118-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

If AHD_DEBUG is enabled and ahd_platform_alloc fails then ahd is set
to null and the debug printk dereferences ahd when passing it to
ahd_name.  Fix this by moving the debug printk to before the call
to ahd_platform_alloc where ahd is not null at that point.

Detected by CoverityScan, CID#100296 ("Explicit null dereference")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 034f4eebb160..3efd4cdc40a0 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6112,10 +6112,6 @@ ahd_alloc(void *platform_arg, char *name)
 	ahd->int_coalescing_stop_threshold =
 	    AHD_INT_COALESCING_STOP_THRESHOLD_DEFAULT;
 
-	if (ahd_platform_alloc(ahd, platform_arg) != 0) {
-		ahd_free(ahd);
-		ahd = NULL;
-	}
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MEMORY) != 0) {
 		printk("%s: scb size = 0x%x, hscb size = 0x%x\n",
@@ -6123,6 +6119,10 @@ ahd_alloc(void *platform_arg, char *name)
 		       (u_int)sizeof(struct hardware_scb));
 	}
 #endif
+	if (ahd_platform_alloc(ahd, platform_arg) != 0) {
+		ahd_free(ahd);
+		ahd = NULL;
+	}
 	return (ahd);
 }
 
-- 
2.17.0
