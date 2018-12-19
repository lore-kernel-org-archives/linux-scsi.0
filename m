From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 6/12] scsi: arcmsr: Update for ACB_ADAPTER_TYPE_B that ccb
 address can above 4GB
Date: Wed, 19 Dec 2018 16:45:46 +0800
Message-ID: <1545209146.4457.32.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Update for ACB_ADAPTER_TYPE_B that ccb address can above 4GB

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 2ff1c9a..3d2727c 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1418,7 +1418,10 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 			flag_ccb = reg->done_qbuffer[i];
 			if (flag_ccb != 0) {
 				reg->done_qbuffer[i] = 0;
-				pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
+				ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
+				if (acb->cdb_phyadd_hipart)
+					ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
+				pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
 				pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 				error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
 				arcmsr_drain_donequeue(acb, pCCB, error);
@@ -2358,13 +2361,18 @@ static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	struct CommandControlBlock *pCCB;
 	bool error;
+	unsigned long cdb_phy_addr;
+
 	index = reg->doneq_index;
 	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
-		reg->done_qbuffer[index] = 0;
-		pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
+		cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
+		if (acb->cdb_phyadd_hipart)
+			cdb_phy_addr = cdb_phy_addr | acb->cdb_phyadd_hipart;
+		pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + cdb_phy_addr);
 		pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
 		arcmsr_drain_donequeue(acb, pCCB, error);
+		reg->done_qbuffer[index] = 0;
 		index++;
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
 		reg->doneq_index = index;
@@ -3329,8 +3337,9 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 	uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
 	int index, rtn;
 	bool error;
-	polling_hbb_ccb_retry:
+	unsigned long ccb_cdb_phy;
 
+polling_hbb_ccb_retry:
 	poll_count++;
 	/* clear doorbell interrupt */
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
@@ -3356,7 +3365,10 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
 		reg->doneq_index = index;
 		/* check if command done with no error*/
-		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
+		ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
+		if (acb->cdb_phyadd_hipart)
+			ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
 		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
