From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 4/8] hisi_sas: add prep_abort_v2_hw()
Date: Wed, 24 Aug 2016 19:05:50 +0800
Message-ID: <1472036754-156813-5-git-send-email-john.garry@huawei.com>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:51529 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcHXKsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2016 06:48:24 -0400
In-Reply-To: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

Add function to prepare the an internal abort
for v2 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f965604..fec1675 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -174,6 +174,10 @@
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
@@ -214,6 +218,8 @@
 #define CMD_HDR_DIF_SGL_LEN_MSK		(0xffff << CMD_HDR_DIF_SGL_LEN_OFF)
 #define CMD_HDR_DATA_SGL_LEN_OFF	16
 #define CMD_HDR_DATA_SGL_LEN_MSK	(0xffff << CMD_HDR_DATA_SGL_LEN_OFF)
+#define CMD_HDR_ABORT_IPTT_OFF		16
+#define CMD_HDR_ABORT_IPTT_MSK		(0xffff << CMD_HDR_ABORT_IPTT_OFF)
 
 /* Completion header */
 /* dw0 */
@@ -1775,6 +1781,32 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+static int prep_abort_v2_hw(struct hisi_hba *hisi_hba,
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
+			       ((dev_is_sata(dev) ? 1:0) <<
+				CMD_HDR_ABORT_DEVICE_TYPE_OFF) |
+			       (abort_flag << CMD_HDR_ABORT_FLAG_OFF));
+
+	/* dw1 */
+	hdr->dw1 = cpu_to_le32(device_id << CMD_HDR_DEV_ID_OFF);
+
+	/* dw7 */
+	hdr->dw7 = cpu_to_le32(tag_to_abort << CMD_HDR_ABORT_IPTT_OFF);
+	hdr->transfer_tags = cpu_to_le32(slot->idx);
+
+	return 0;
+}
+
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -2239,6 +2271,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.prep_smp = prep_smp_v2_hw,
 	.prep_ssp = prep_ssp_v2_hw,
 	.prep_stp = prep_ata_v2_hw,
+	.prep_abort = prep_abort_v2_hw,
 	.get_free_slot = get_free_slot_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
 	.slot_complete = slot_complete_v2_hw,
-- 
1.9.1

