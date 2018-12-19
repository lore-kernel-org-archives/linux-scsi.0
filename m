From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 5/12] scsi: arcmsr: Update for ACB_ADAPTER_TYPE_A that ccb
 address can above 4GB
Date: Wed, 19 Dec 2018 16:43:15 +0800
Message-ID: <1545208995.4457.29.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Update for ACB_ADAPTER_TYPE_A that ccb address can above 4GB

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 5353dbb..2ff1c9a 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1382,10 +1382,12 @@ static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct Comma
 static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 {
 	int i = 0;
-	uint32_t flag_ccb, ccb_cdb_phy;
+	uint32_t flag_ccb;
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	bool error;
 	struct CommandControlBlock *pCCB;
+	unsigned long ccb_cdb_phy, cdb_phy_hipart;
+
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
@@ -1397,7 +1399,10 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
 		while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
 				&& (i++ < acb->maxOutstanding)) {
-			pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
+			ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
+			if (acb->cdb_phyadd_hipart)
+				ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
+			pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
 			pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 			error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
 			arcmsr_drain_donequeue(acb, pCCB, error);
@@ -2333,8 +2338,13 @@ static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	struct CommandControlBlock *pCCB;
 	bool error;
+	unsigned long cdb_phy_addr;
+
 	while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
-		pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
+		cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
+		if (acb->cdb_phyadd_hipart)
+			cdb_phy_addr = cdb_phy_addr | acb->cdb_phyadd_hipart;
+		pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + cdb_phy_addr);
 		pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
 		arcmsr_drain_donequeue(acb, pCCB, error);
@@ -3258,7 +3268,9 @@ static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;
 	int rtn;
 	bool error;
-	polling_hba_ccb_retry:
+	unsigned long ccb_cdb_phy;
+
+polling_hba_ccb_retry:
 	poll_count++;
 	outbound_intstatus = readl(&reg->outbound_intstatus) & acb->outbound_int_enable;
 	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
@@ -3276,7 +3288,10 @@ static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
 				goto polling_hba_ccb_retry;
 			}
 		}
-		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
+		ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
+		if (acb->cdb_phyadd_hipart)
+			ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
 		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
