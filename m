From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 7/12] scsi: arcmsr: Update for ACB_ADAPTER_TYPE_C that ccb
 address can above 4GB
Date: Wed, 19 Dec 2018 16:48:16 +0800
Message-ID: <1545209296.4457.35.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Update for ACB_ADAPTER_TYPE_C that ccb address can above 4GB

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 3d2727c..39f3cd0 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1438,7 +1438,9 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 			/*need to do*/
 			flag_ccb = readl(&reg->outbound_queueport_low);
 			ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
-			pARCMSR_CDB = (struct  ARCMSR_CDB *)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/
+			if (acb->cdb_phyadd_hipart)
+				ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
+			pARCMSR_CDB = (struct  ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
 			pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 			error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
 			arcmsr_drain_donequeue(acb, pCCB, error);
@@ -1786,12 +1788,8 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 		arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;
 		ccb_post_stamp = (cdb_phyaddr | ((arc_cdb_size - 1) >> 6) | 1);
-		if (acb->cdb_phyaddr_hi32) {
-			writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);
-			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
-		} else {
-			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
-		}
+		writel(upper_32_bits(ccb->cdb_phyaddr), &phbcmu->inbound_queueport_high);
+		writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_D: {
@@ -2384,7 +2382,8 @@ static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 	struct MessageUnit_C __iomem *phbcmu;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *ccb;
-	uint32_t flag_ccb, ccb_cdb_phy, throttling = 0;
+	uint32_t flag_ccb, throttling = 0;
+	unsigned long ccb_cdb_phy;
 	int error;
 
 	phbcmu = acb->pmuC;
@@ -2394,6 +2393,8 @@ static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 	while ((flag_ccb = readl(&phbcmu->outbound_queueport_low)) !=
 			0xFFFFFFFF) {
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+		if (acb->cdb_phyadd_hipart)
+			ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
 			+ ccb_cdb_phy);
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
@@ -3401,12 +3402,14 @@ static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,
 		struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_C __iomem *reg = acb->pmuC;
-	uint32_t flag_ccb, ccb_cdb_phy;
+	uint32_t flag_ccb;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	bool error;
 	struct CommandControlBlock *pCCB;
 	uint32_t poll_ccb_done = 0, poll_count = 0;
 	int rtn;
+	unsigned long ccb_cdb_phy;
+
 polling_hbc_ccb_retry:
 	poll_count++;
 	while (1) {
@@ -3425,7 +3428,9 @@ polling_hbc_ccb_retry:
 		}
 		flag_ccb = readl(&reg->outbound_queueport_low);
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
-		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);/*frame must be 32 bytes aligned*/
+		if (acb->cdb_phyadd_hipart)
+			ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
 		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
 		/* check ifcommand done with no error*/
@@ -3801,7 +3806,6 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		if (cdb_phyaddr_hi32 != 0) {
 			struct MessageUnit_C __iomem *reg = acb->pmuC;
 
 			printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x\n",
@@ -3816,7 +3820,6 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 				return 1;
 			}
 		}
-		}
 		break;
 	case ACB_ADAPTER_TYPE_D: {
 		uint32_t __iomem *rwbuffer;
