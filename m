From: John Garry <john.garry@huawei.com>
Subject: [PATCH 12/13] scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL scsi_cmnd
Date: Fri, 25 Jan 2019 22:22:38 +0800
Message-ID: <1548426159-225679-13-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

A NULL-pointer dereference was introduced for TMF SSP commands from the
upstreaming reworking.

Fix this by relocating the scsi_get_prot_op() callsite.

Fixes: d6a9000b81be ("scsi: hisi_sas: Add support for DIF feature for v2 hw")
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f1009e2..108683b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1035,8 +1035,8 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	struct sas_ssp_task *ssp_task = &task->ssp_task;
 	struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
 	struct hisi_sas_tmf_task *tmf = slot->tmf;
-	unsigned char prot_op = scsi_get_prot_op(scsi_cmnd);
 	int has_data = 0, priority = !!tmf;
+	unsigned char prot_op;
 	u8 *buf_cmd;
 	u32 dw1 = 0, dw2 = 0, len = 0;
 
@@ -1051,6 +1051,7 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 		dw1 |= 2 << CMD_HDR_FRAME_TYPE_OFF;
 		dw1 |= DIR_NO_DATA << CMD_HDR_DIR_OFF;
 	} else {
+		prot_op = scsi_get_prot_op(scsi_cmnd);
 		dw1 |= 1 << CMD_HDR_FRAME_TYPE_OFF;
 		switch (scsi_cmnd->sc_data_direction) {
 		case DMA_TO_DEVICE:
-- 
1.9.1
