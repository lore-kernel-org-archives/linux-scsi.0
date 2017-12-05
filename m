From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 11/17] scsi: arcmsr: fix clear doorbell queue on
 ACB_ADAPTER_TYPE_B controller
Date: Tue, 05 Dec 2017 10:02:16 +0800
Message-ID: <1512439336.4577.63.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

fix clear doorbell queue on ACB_ADAPTER_TYPE_B controller

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:45:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:45:34.000000000 +0800
@@ -4196,10 +4196,19 @@ static void arcmsr_clear_doorbell_queue_
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		/*clear interrupt and message state*/
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+		uint32_t outbound_doorbell, i;
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		/* let IOP know data has been read */
+		for(i=0; i < 200; i++) {
+			msleep(20);
+			outbound_doorbell = readl(reg->iop2drv_doorbell);
+			if( outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
+				writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+				writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
+			} else
+				break;
+		}
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
