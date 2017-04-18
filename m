From: Colin King <colin.king@canonical.com>
Subject: [PATCH] [SCSI] aic7xxx: remove redundant assignment to error
Date: Tue, 18 Apr 2017 12:53:27 +0100
Message-ID: <20170418115327.6833-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

error is initially assigned to ENOENT and a few statements later
is re-assigned to the error return from the call to ahd_wait_seeprom,
hence the initial assignment is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 95d8f25cbcca..f5a2714ed82c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -10077,7 +10077,6 @@ ahd_write_seeprom(struct ahd_softc *ahd, uint16_t *buf,
 	int   retval;
 
 	AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
-	error = ENOENT;
 
 	/* Place the chip into write-enable mode */
 	ahd_outb(ahd, SEEADR, SEEOP_EWEN_ADDR);
-- 
2.11.0

