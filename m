From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/11] hisi_sas: modify some values in get_ata_protocol()
Date: Mon, 7 Nov 2016 20:48:37 +0800
Message-ID: <1478522920-108145-9-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25341 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbcKGMXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 07:23:45 -0500
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

Modify and add some SATA commands according to SATA protocol.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 3081eec..a5faa4d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1750,6 +1750,7 @@ static u8 get_ata_protocol(u8 cmd, int direction)
 	case ATA_CMD_NCQ_NON_DATA:
 	return SATA_PROTOCOL_FPDMA;
 
+	case ATA_CMD_DOWNLOAD_MICRO:
 	case ATA_CMD_ID_ATA:
 	case ATA_CMD_PMP_READ:
 	case ATA_CMD_READ_LOG_EXT:
@@ -1761,18 +1762,27 @@ static u8 get_ata_protocol(u8 cmd, int direction)
 	case ATA_CMD_PIO_WRITE_EXT:
 	return SATA_PROTOCOL_PIO;
 
+	case ATA_CMD_DSM:
+	case ATA_CMD_DOWNLOAD_MICRO_DMA:
+	case ATA_CMD_PMP_READ_DMA:
+	case ATA_CMD_PMP_WRITE_DMA:
 	case ATA_CMD_READ:
 	case ATA_CMD_READ_EXT:
 	case ATA_CMD_READ_LOG_DMA_EXT:
+	case ATA_CMD_READ_STREAM_DMA_EXT:
+	case ATA_CMD_TRUSTED_RCV_DMA:
+	case ATA_CMD_TRUSTED_SND_DMA:
 	case ATA_CMD_WRITE:
 	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_WRITE_FUA_EXT:
 	case ATA_CMD_WRITE_QUEUED:
 	case ATA_CMD_WRITE_LOG_DMA_EXT:
+	case ATA_CMD_WRITE_STREAM_DMA_EXT:
 	return SATA_PROTOCOL_DMA;
 
-	case ATA_CMD_DOWNLOAD_MICRO:
-	case ATA_CMD_DEV_RESET:
 	case ATA_CMD_CHK_POWER:
+	case ATA_CMD_DEV_RESET:
+	case ATA_CMD_EDD:
 	case ATA_CMD_FLUSH:
 	case ATA_CMD_FLUSH_EXT:
 	case ATA_CMD_VERIFY:
-- 
1.9.1

