From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 18/22] scsi: hisi_sas: add v3 code to send internal abort command
Date: Thu, 25 May 2017 20:05:07 +0800
Message-ID: <1495713911-80476-19-git-send-email-john.garry@huawei.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add code to prepare internal abort command.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index c8b6997..6273368 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -165,6 +165,10 @@
 /* HW dma structures */
 /* Delivery queue header */
 /* dw0 */
+#define CMD_HDR_ABORT_FLAG_OFF		0
+#define CMD_HDR_ABORT_FLAG_MSK		(0x3 << CMD_HDR_ABORT_FLAG_OFF)
+#define CMD_HDR_ABORT_DEVICE_TYPE_OFF	2
+#define CMD_HDR_ABORT_DEVICE_TYPE_MSK	(0x1 << CMD_HDR_ABORT_DEVICE_TYPE_OFF)
 #define CMD_HDR_RESP_REPORT_OFF		5
 #define CMD_HDR_RESP_REPORT_MSK		(0x1 << CMD_HDR_RESP_REPORT_OFF)
 #define CMD_HDR_TLR_CTRL_OFF		6
@@ -204,6 +208,11 @@
 #define CMD_HDR_DIF_SGL_LEN_MSK		(0xffff << CMD_HDR_DIF_SGL_LEN_OFF)
 #define CMD_HDR_DATA_SGL_LEN_OFF	16
 #define CMD_HDR_DATA_SGL_LEN_MSK	(0xffff << CMD_HDR_DATA_SGL_LEN_OFF)
+/* dw7 */
+#define CMD_HDR_ADDR_MODE_SEL_OFF		15
+#define CMD_HDR_ADDR_MODE_SEL_MSK		(1 << CMD_HDR_ADDR_MODE_SEL_OFF)
+#define CMD_HDR_ABORT_IPTT_OFF		16
+#define CMD_HDR_ABORT_IPTT_MSK		(0xffff << CMD_HDR_ABORT_IPTT_OFF)
 
 /* Completion header */
 /* dw0 */
@@ -929,6 +938,34 @@ static int prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+static int prep_abort_v3_hw(struct hisi_hba *hisi_hba,
+		struct hisi_sas_slot *slot,
+		int device_id, int abort_flag, int tag_to_abort)
+{
+	struct sas_task *task = slot->task;
+	struct domain_device *dev = task->dev;
+	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
+	struct hisi_sas_port *port = slot->port;
+
+	/* dw0 */
+	hdr->dw0 = cpu_to_le32((5 << CMD_HDR_CMD_OFF) | /*abort*/
+			       (port->id << CMD_HDR_PORT_OFF) |
+				   ((dev_is_sata(dev) ? 1:0)
+					<< CMD_HDR_ABORT_DEVICE_TYPE_OFF) |
+					(abort_flag
+					 << CMD_HDR_ABORT_FLAG_OFF));
+
+	/* dw1 */
+	hdr->dw1 = cpu_to_le32(device_id
+			<< CMD_HDR_DEV_ID_OFF);
+
+	/* dw7 */
+	hdr->dw7 = cpu_to_le32(tag_to_abort << CMD_HDR_ABORT_IPTT_OFF);
+	hdr->transfer_tags = cpu_to_le32(slot->idx);
+
+	return 0;
+}
+
 static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -1689,6 +1726,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	.prep_ssp = prep_ssp_v3_hw,
 	.prep_smp = prep_smp_v3_hw,
 	.prep_stp = prep_ata_v3_hw,
+	.prep_abort = prep_abort_v3_hw,
 	.get_free_slot = get_free_slot_v3_hw,
 	.start_delivery = start_delivery_v3_hw,
 	.slot_complete = slot_complete_v3_hw,
-- 
1.9.1
