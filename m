From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 3/4] scsi: arcmsr: Sleep to avoid CPU stuck too long for
 waiting adapter ready
Date: Thu, 15 Mar 2018 14:37:40 +0800
Message-ID: <1521095860.31371.34.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Sleep to avoid CPU stuck too long for waiting adapter ready.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 2f52c53..732b5d9 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3807,6 +3807,8 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_A: {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		do {
+			if (!(acb->acb_flags & ACB_F_IOP_INITED))
+				msleep(20);
 			firmware_state = readl(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
 		}
@@ -3815,6 +3817,8 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		do {
+			if (!(acb->acb_flags & ACB_F_IOP_INITED))
+				msleep(20);
 			firmware_state = readl(reg->iop2drv_doorbell);
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);
 		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
@@ -3823,6 +3827,8 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		do {
+			if (!(acb->acb_flags & ACB_F_IOP_INITED))
+				msleep(20);
 			firmware_state = readl(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
 		}
@@ -3830,6 +3836,8 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_D: {
 		struct MessageUnit_D *reg = acb->pmuD;
 		do {
+			if (!(acb->acb_flags & ACB_F_IOP_INITED))
+				msleep(20);
 			firmware_state = readl(reg->outbound_msgaddr1);
 		} while ((firmware_state &
 			ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
@@ -3838,6 +3846,8 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_E: {
 		struct MessageUnit_E __iomem *reg = acb->pmuE;
 		do {
+			if (!(acb->acb_flags & ACB_F_IOP_INITED))
+				msleep(20);
 			firmware_state = readl(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_HBEMU_MESSAGE_FIRMWARE_OK) == 0);
 		}
