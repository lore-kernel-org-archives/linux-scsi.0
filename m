From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/8] scsi: hisi_sas: consolidate command check in hisi_sas_get_ata_protocol()
Date: Sat, 24 Mar 2018 00:05:12 +0800
Message-ID: <1521821115-120040-6-git-send-email-john.garry@huawei.com>
References: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Currently we check the fis->command value in 2 locations in
hisi_sas_get_ata_protocol() switch statement. Fix this by
consolidating the check for fis->command value to 1 location
only.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9563dfa..8557fd0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -78,22 +78,23 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
 	case ATA_CMD_STANDBYNOW1:
 	case ATA_CMD_ZAC_MGMT_OUT:
 		return HISI_SAS_SATA_PROTOCOL_NONDATA;
+
+	case ATA_CMD_SET_MAX:
+		switch (fis->features) {
+		case ATA_SET_MAX_PASSWD:
+		case ATA_SET_MAX_LOCK:
+			return HISI_SAS_SATA_PROTOCOL_PIO;
+
+		case ATA_SET_MAX_PASSWD_DMA:
+		case ATA_SET_MAX_UNLOCK_DMA:
+			return HISI_SAS_SATA_PROTOCOL_DMA;
+
+		default:
+			return HISI_SAS_SATA_PROTOCOL_NONDATA;
+		}
+
 	default:
 	{
-		if (fis->command == ATA_CMD_SET_MAX) {
-			switch (fis->features) {
-			case ATA_SET_MAX_PASSWD:
-			case ATA_SET_MAX_LOCK:
-				return HISI_SAS_SATA_PROTOCOL_PIO;
-
-			case ATA_SET_MAX_PASSWD_DMA:
-			case ATA_SET_MAX_UNLOCK_DMA:
-				return HISI_SAS_SATA_PROTOCOL_DMA;
-
-			default:
-				return HISI_SAS_SATA_PROTOCOL_NONDATA;
-			}
-		}
 		if (direction == DMA_NONE)
 			return HISI_SAS_SATA_PROTOCOL_NONDATA;
 		return HISI_SAS_SATA_PROTOCOL_PIO;
-- 
1.9.1
