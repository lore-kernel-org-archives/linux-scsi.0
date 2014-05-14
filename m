From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.2 8/16] arcmsr: remove calling
 arcmsr_hbb_enable_driver_mode
Date: Wed, 14 May 2014 19:25:00 +0800
Message-ID: <1400066700.6957.37.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Removing call arcmsr_hbb_enable_driver_mode by in-line code.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:46:14.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:46:46.000000000 +0800
@@ -879,17 +879,6 @@ static uint8_t arcmsr_abort_allcmd(struc
 	return rtnval;
 }
 
-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
-{
-	struct MessageUnit_B *reg = pacb->pmuB;
-	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {
-		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", pacb->host->host_no);
-		return false;
-	}
-    	return true;
-}
-
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
 {
 	struct scsi_cmnd *pcmd = ccb->pcmd;
@@ -2687,7 +2676,12 @@ static int arcmsr_iop_confirm(struct Ada
 			timeout \n",acb->host->host_no);
 			return 1;
 		}
-		arcmsr_hbb_enable_driver_mode(acb);
+		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+			pr_err("arcmsr%d: can't set driver mode.\n",
+				acb->host->host_no);
+			return 1;
+		}
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
