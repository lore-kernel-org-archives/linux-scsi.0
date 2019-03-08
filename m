From: <sagar.biradar@microchip.com>
Subject: [PATCH] scsi: aacraid: Fix performance issue(QD) on logical drives
Date: Thu, 7 Mar 2019 23:26:41 -0800
Message-ID: <1552030001-10658-1-git-send-email-sagar.biradar@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, aacraid@microsemi.com, dave.carroll@microchip.com, scott.benesh@microchip.com, stable@vger.kernel.org, sagar.biradar@microchip.com
List-Id: linux-scsi@vger.kernel.org

From: Sagar Biradar <sagar.biradar@microchip.com>

To: Martin K. Petersen <martin.petersen@oracle.com>
To: James Bottomley <jejb@linux.vnet.ibm.com>
cc: linux-scsi <linux-scsi@vger.kernel.org>
cc: aacraid@microsemi.com
cc: Dave Carroll <dave.carroll@microchip.com>
cc: Scott Benesh <scott.benesh@microchip.com>
cc: stable@vger.kernel.org

Fix performance issue where the queue depth for SmartIOC logical
volumes is set to 1, and allow the usual logical volume code
to be executed

Fixes: a052865fe2871a3888 (aacraid: Set correct Queue Depth for HBA1000
RAW disks)

Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/linit.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7e56a11..cceffac 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -413,13 +413,16 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	if (chn < AAC_MAX_BUSES && tid < AAC_MAX_TARGETS && aac->sa_firmware) {
 		devtype = aac->hba_map[chn][tid].devtype;
 
-		if (devtype == AAC_DEVTYPE_NATIVE_RAW)
+		if (devtype == AAC_DEVTYPE_NATIVE_RAW) {
 			depth = aac->hba_map[chn][tid].qd_limit;
-		else if (devtype == AAC_DEVTYPE_ARC_RAW)
+			set_timeout = 1;
+			goto common_config;
+		}
+		if (devtype == AAC_DEVTYPE_ARC_RAW) {
 			set_qd_dev_type = true;
-
-		set_timeout = 1;
-		goto common_config;
+			set_timeout = 1;
+			goto common_config;
+		}
 	}
 
 	if (aac->jbod && (sdev->type == TYPE_DISK))
-- 
1.8.3.1
