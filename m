From: John Garry <john.garry@huawei.com>
Subject: [PATCH 09/19] scsi: hisi_sas: support zone management commands
Date: Fri, 11 Aug 2017 00:09:34 +0800
Message-ID: <1502381384-219889-10-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Add two ATA commands, ATA_CMD_ZAC_MGMT_IN and ATA_CMD_ZAC_MGMT_OUT
in hisi_sas_get_ata_protocol(), to support SATA SMR disk.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 81ad6cd..86868ec 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -61,6 +61,7 @@ u8 hisi_sas_get_ata_protocol(u8 cmd, int direction)
 	case ATA_CMD_WRITE_QUEUED:
 	case ATA_CMD_WRITE_LOG_DMA_EXT:
 	case ATA_CMD_WRITE_STREAM_DMA_EXT:
+	case ATA_CMD_ZAC_MGMT_IN:
 	return HISI_SAS_SATA_PROTOCOL_DMA;
 
 	case ATA_CMD_CHK_POWER:
@@ -73,6 +74,7 @@ u8 hisi_sas_get_ata_protocol(u8 cmd, int direction)
 	case ATA_CMD_SET_FEATURES:
 	case ATA_CMD_STANDBY:
 	case ATA_CMD_STANDBYNOW1:
+	case ATA_CMD_ZAC_MGMT_OUT:
 	return HISI_SAS_SATA_PROTOCOL_NONDATA;
 	default:
 		if (direction == DMA_NONE)
-- 
1.9.1
