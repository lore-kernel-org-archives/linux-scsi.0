From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 23/35] scsi: Use kmemdup rather than duplicating its implementation
Date: Thu,  4 Jul 2019 00:30:22 +0800
Message-ID: <20190703163022.410-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Hannes Reinecke <hare@kernel.org>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>
List-Id: linux-scsi@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

 drivers/scsi/myrb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 539ac8ce4fcd..5e6b5e7ae93a 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1658,14 +1658,12 @@ static int myrb_ldev_slave_alloc(struct scsi_device *sdev)
 	if (!ldev_info)
 		return -ENXIO;
 
-	sdev->hostdata = kzalloc(sizeof(*ldev_info), GFP_KERNEL);
+	sdev->hostdata = kmemdup(ldev_info, sizeof(*ldev_info), GFP_KERNEL);
 	if (!sdev->hostdata)
 		return -ENOMEM;
 	dev_dbg(&sdev->sdev_gendev,
 		"slave alloc ldev %d state %x\n",
 		ldev_num, ldev_info->state);
-	memcpy(sdev->hostdata, ldev_info,
-	       sizeof(*ldev_info));
 	switch (ldev_info->raid_level) {
 	case MYRB_RAID_LEVEL0:
 		level = RAID_LEVEL_LINEAR;
-- 
2.11.0
