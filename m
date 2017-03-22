From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fcoe: sanity check string size for store_ctrl_mode option
Date: Wed, 22 Mar 2017 14:01:37 +0000
Message-ID: <20170322140137.28485-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Reading and writing to mode[count - 1] implies the count should not
be less than 1 so add a sanity check for this.

Detected with CoverityScan, CID#1357345 ("Overflowed array index write")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 9cf3d56296ab..e298240c728c 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -288,7 +288,7 @@ static ssize_t store_ctlr_mode(struct device *dev,
 	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
 	char mode[FCOE_MAX_MODENAME_LEN + 1];
 
-	if (count > FCOE_MAX_MODENAME_LEN)
+	if (count < 1 || count > FCOE_MAX_MODENAME_LEN)
 		return -EINVAL;
 
 	strncpy(mode, buf, count);
-- 
2.11.0

