From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/6] scsi: hisi_sas: Change the type of some numbers to unsigned
Date: Wed, 29 May 2019 17:58:45 +0800
Message-ID: <1559123927-160502-5-git-send-email-john.garry@huawei.com>
References: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

It reports a error as follows from some tools at two places in our code:
runtime error: left shift of 4 by 29 places cannot be represented in type
'int'
So change the type of the two number to unsigned to avoid the error.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3efb1e72bdab..492ada65d41a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1344,7 +1344,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
 		hdr->dw0 |= cpu_to_le32(3 << CMD_HDR_CMD_OFF);
 	else
-		hdr->dw0 |= cpu_to_le32(4 << CMD_HDR_CMD_OFF);
+		hdr->dw0 |= cpu_to_le32(4U << CMD_HDR_CMD_OFF);
 
 	switch (task->data_dir) {
 	case DMA_TO_DEVICE:
@@ -1412,7 +1412,7 @@ static void prep_abort_v3_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_port *port = slot->port;
 
 	/* dw0 */
-	hdr->dw0 = cpu_to_le32((5 << CMD_HDR_CMD_OFF) | /*abort*/
+	hdr->dw0 = cpu_to_le32((5U << CMD_HDR_CMD_OFF) | /*abort*/
 			       (port->id << CMD_HDR_PORT_OFF) |
 				   (dev_is_sata(dev)
 					<< CMD_HDR_ABORT_DEVICE_TYPE_OFF) |
-- 
2.17.1
