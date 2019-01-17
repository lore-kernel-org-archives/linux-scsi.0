From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 2/3] scsi: arcmsr: Fix suspend/resume of ACB_ADAPTER_TYPE_B
 part 2
Date: Thu, 17 Jan 2019 11:45:03 +0800
Message-ID: <1547696703.4339.21.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index a94c513..b98c632 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -508,9 +508,9 @@ struct MessageUnit_A
 struct MessageUnit_B
 {
 	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
-	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+	volatile uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
-	uint32_t	doneq_index;
+	volatile uint32_t	doneq_index;
 	uint32_t	__iomem *drv2iop_doorbell;
 	uint32_t	__iomem *drv2iop_doorbell_mask;
 	uint32_t	__iomem *iop2drv_doorbell;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 5736434..88053b1 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1113,7 +1113,11 @@ static int arcmsr_resume(struct pci_dev *pdev)
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		reg->post_qbuffer[0] = 0;
+		uint32_t i;
+		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
+			reg->post_qbuffer[i] = 0;
+			reg->done_qbuffer[i] = 0;
+		}
 		reg->postq_index = 0;
 		reg->doneq_index = 0;
 		break;
