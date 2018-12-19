From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 8/12] scsi: arcmsr: Update for ACB_ADAPTER_TYPE_D that ccb
 address can above 4GB
Date: Wed, 19 Dec 2018 16:51:14 +0800
Message-ID: <1545209474.4457.38.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Update for ACB_ADAPTER_TYPE_D that ccb address can above 4GB

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 39f3cd0..8cc2134 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1468,9 +1468,13 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 					((toggle ^ 0x4000) + 1);
 				doneq_index = pmu->doneq_index;
 				spin_unlock_irqrestore(&acb->doneq_lock, flags);
+				cdb_phy_hipart = pmu->done_qbuffer[doneq_index &
+					0xFFF].addressHigh;
 				addressLow = pmu->done_qbuffer[doneq_index &
 					0xFFF].addressLow;
 				ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+				if (acb->cdb_phyadd_hipart)
+					ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
 				pARCMSR_CDB = (struct  ARCMSR_CDB *)
 					(acb->vir2phy_offset + ccb_cdb_phy);
 				pCCB = container_of(pARCMSR_CDB,
@@ -1802,8 +1806,8 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 		spin_lock_irqsave(&acb->postq_lock, flags);
 		postq_index = pmu->postq_index;
 		pinbound_srb = (struct InBound_SRB *)&(pmu->post_qbuffer[postq_index & 0xFF]);
-		pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);
-		pinbound_srb->addressLow = dma_addr_lo32(cdb_phyaddr);
+		pinbound_srb->addressHigh = upper_32_bits(ccb->cdb_phyaddr);
+		pinbound_srb->addressLow = cdb_phyaddr;
 		pinbound_srb->length = ccb->arc_cdb_size >> 2;
 		arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
 		toggle = postq_index & 0x4000;
@@ -2415,12 +2419,12 @@ static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 static void arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	u32 outbound_write_pointer, doneq_index, index_stripped, toggle;
-	uint32_t addressLow, ccb_cdb_phy;
+	uint32_t addressLow;
 	int error;
 	struct MessageUnit_D  *pmu;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *ccb;
-	unsigned long flags;
+	unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
 
 	spin_lock_irqsave(&acb->doneq_lock, flags);
 	pmu = acb->pmuD;
@@ -2434,9 +2438,13 @@ static void arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
 			pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
 				((toggle ^ 0x4000) + 1);
 			doneq_index = pmu->doneq_index;
+			cdb_phy_hipart = pmu->done_qbuffer[doneq_index &
+				0xFFF].addressHigh;
 			addressLow = pmu->done_qbuffer[doneq_index &
 				0xFFF].addressLow;
 			ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+			if (acb->cdb_phyadd_hipart)
+				ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
 			arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
 				+ ccb_cdb_phy);
 			ccb = container_of(arcmsr_cdb,
@@ -3464,9 +3472,9 @@ static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
 				struct CommandControlBlock *poll_ccb)
 {
 	bool error;
-	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
+	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb;
 	int rtn, doneq_index, index_stripped, outbound_write_pointer, toggle;
-	unsigned long flags;
+	unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *pCCB;
 	struct MessageUnit_D *pmu = acb->pmuD;
@@ -3498,8 +3506,12 @@ polling_hbaD_ccb_retry:
 				((toggle ^ 0x4000) + 1);
 		doneq_index = pmu->doneq_index;
 		spin_unlock_irqrestore(&acb->doneq_lock, flags);
+		cdb_phy_hipart = pmu->done_qbuffer[doneq_index &
+				0xFFF].addressHigh;
 		flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+		if (acb->cdb_phyadd_hipart)
+			ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
 			ccb_cdb_phy);
 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
