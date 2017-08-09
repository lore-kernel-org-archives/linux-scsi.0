From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: dpt_i2o: remove redundant null check on array device
Date: Wed,  9 Aug 2017 11:17:41 +0100
Message-ID: <20170809101741.19163-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The null check on pHba->channel[chan].device is redundant because
device is an array and hence can never be null. Remove the check.

Detected by CoverityScan, CID#115362 ("Array compared against 0")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/dpt_i2o.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 256dd6791fcc..fd172b0890d3 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1169,11 +1169,6 @@ static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u6
 	if(chan < 0 || chan >= MAX_CHANNEL)
 		return NULL;
 	
-	if( pHba->channel[chan].device == NULL){
-		printk(KERN_DEBUG"Adaptec I2O RAID: Trying to find device before they are allocated\n");
-		return NULL;
-	}
-
 	d = pHba->channel[chan].device[id];
 	if(!d || d->tid == 0) {
 		return NULL;
-- 
2.11.0
