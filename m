From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v5 2/2] arcmsr: simplify of updating doneq_index and
 postq_index
Date: Mon, 15 Sep 2014 19:05:33 +0800
Message-ID: <1410779133.4774.27.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch is to modify previous patch 16/17 and it is relative to
http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr

change since v4:
1. add spin_lock in arcmsr_done4abort_postqueue for protect doneq_index.
2. fix spinlock area in arcmsr_hbaD_polling_ccbdone.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-09-12 12:43:16.956653000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-09-15 18:53:44.483743000 +0800
@@ -1121,7 +1121,7 @@ static void arcmsr_drain_donequeue(struc
 static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 {
 	int i = 0;
-	uint32_t flag_ccb;
+	uint32_t flag_ccb, ccb_cdb_phy;
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	bool error;
 	struct CommandControlBlock *pCCB;
@@ -1165,10 +1165,6 @@ static void arcmsr_done4abort_postqueue(
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C __iomem *reg = acb->pmuC;
-		struct  ARCMSR_CDB *pARCMSR_CDB;
-		uint32_t flag_ccb, ccb_cdb_phy;
-		bool error;
-		struct CommandControlBlock *pCCB;
 		while ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
 			/*need to do*/
 			flag_ccb = readl(&reg->outbound_queueport_low);
@@ -1182,35 +1178,25 @@ static void arcmsr_done4abort_postqueue(
 		break;
 	case ACB_ADAPTER_TYPE_D: {
 		struct MessageUnit_D  *pmu = acb->pmuD;
-		uint32_t ccb_cdb_phy, outbound_write_pointer;
-		uint32_t doneq_index, index_stripped, addressLow, residual;
-		bool error;
-		struct CommandControlBlock *pCCB;
+		uint32_t outbound_write_pointer;
+		uint32_t doneq_index, index_stripped, addressLow, residual, toggle;
+		unsigned long flags;
 
-		outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
-		doneq_index = pmu->doneq_index;
 		residual = atomic_read(&acb->ccboutstandingcount);
 		for (i = 0; i < residual; i++) {
-			while ((doneq_index & 0xFFF) !=
+			spin_lock_irqsave(&acb->doneq_lock, flags);
+			outbound_write_pointer =
+				pmu->done_qbuffer[0].addressLow + 1;
+			doneq_index = pmu->doneq_index;
+			if ((doneq_index & 0xFFF) !=
 				(outbound_write_pointer & 0xFFF)) {
-				if (doneq_index & 0x4000) {
-					index_stripped = doneq_index & 0xFFF;
-					index_stripped += 1;
-					index_stripped %=
-						ARCMSR_MAX_ARC1214_DONEQUEUE;
-					pmu->doneq_index = index_stripped ?
-						(index_stripped | 0x4000) :
-						(index_stripped + 1);
-				} else {
-					index_stripped = doneq_index;
-					index_stripped += 1;
-					index_stripped %=
-						ARCMSR_MAX_ARC1214_DONEQUEUE;
-					pmu->doneq_index = index_stripped ?
-						index_stripped :
-						((index_stripped | 0x4000) + 1);
-				}
+				toggle = doneq_index & 0x4000;
+				index_stripped = (doneq_index & 0xFFF) + 1;
+				index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+				pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
+					((toggle ^ 0x4000) + 1);
 				doneq_index = pmu->doneq_index;
+				spin_unlock_irqrestore(&acb->doneq_lock, flags);
 				addressLow = pmu->done_qbuffer[doneq_index &
 					0xFFF].addressLow;
 				ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
@@ -1224,11 +1210,10 @@ static void arcmsr_done4abort_postqueue(
 				arcmsr_drain_donequeue(acb, pCCB, error);
 				writel(doneq_index,
 					pmu->outboundlist_read_pointer);
+			} else {
+				spin_unlock_irqrestore(&acb->doneq_lock, flags);
+				mdelay(10);
 			}
-			mdelay(10);
-			outbound_write_pointer =
-				pmu->done_qbuffer[0].addressLow + 1;
-			doneq_index = pmu->doneq_index;
 		}
 		pmu->postq_index = 0;
 		pmu->doneq_index = 0x40FF;
@@ -1461,7 +1446,7 @@ static void arcmsr_post_ccb(struct Adapt
 	case ACB_ADAPTER_TYPE_D: {
 		struct MessageUnit_D  *pmu = acb->pmuD;
 		u16 index_stripped;
-		u16 postq_index;
+		u16 postq_index, toggle;
 		unsigned long flags;
 		struct InBound_SRB *pinbound_srb;
 
@@ -1472,19 +1457,11 @@ static void arcmsr_post_ccb(struct Adapt
 		pinbound_srb->addressLow = dma_addr_lo32(cdb_phyaddr);
 		pinbound_srb->length = ccb->arc_cdb_size >> 2;
 		arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
-		if (postq_index & 0x4000) {
-			index_stripped = postq_index & 0xFF;
-			index_stripped += 1;
-			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
-			pmu->postq_index = index_stripped ?
-				(index_stripped | 0x4000) : index_stripped;
-		} else {
-			index_stripped = postq_index;
-			index_stripped += 1;
-			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
-			pmu->postq_index = index_stripped ? index_stripped :
-				(index_stripped | 0x4000);
-		}
+		toggle = postq_index & 0x4000;
+		index_stripped = postq_index + 1;
+		index_stripped &= (ARCMSR_MAX_ARC1214_POSTQUEUE - 1);
+		pmu->postq_index = index_stripped ? (index_stripped | toggle) :
+			(toggle ^ 0x4000);
 		writel(postq_index, pmu->inboundlist_write_pointer);
 		spin_unlock_irqrestore(&acb->postq_lock, flags);
 		break;
@@ -1999,7 +1976,7 @@ static void arcmsr_hbaC_postqueue_isr(st
 
 static void arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
 {
-	u32 outbound_write_pointer, doneq_index, index_stripped;
+	u32 outbound_write_pointer, doneq_index, index_stripped, toggle;
 	uint32_t addressLow, ccb_cdb_phy;
 	int error;
 	struct MessageUnit_D  *pmu;
@@ -2013,21 +1990,11 @@ static void arcmsr_hbaD_postqueue_isr(st
 	doneq_index = pmu->doneq_index;
 	if ((doneq_index & 0xFFF) != (outbound_write_pointer & 0xFFF)) {
 		do {
-			if (doneq_index & 0x4000) {
-				index_stripped = doneq_index & 0xFFF;
-				index_stripped += 1;
-				index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
-				pmu->doneq_index = index_stripped
-					? (index_stripped | 0x4000) :
-					(index_stripped + 1);
-			} else {
-				index_stripped = doneq_index;
-				index_stripped += 1;
-				index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
-				pmu->doneq_index = index_stripped
-					? index_stripped :
-					((index_stripped | 0x4000) + 1);
-			}
+			toggle = doneq_index & 0x4000;
+			index_stripped = (doneq_index & 0xFFF) + 1;
+			index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+			pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
+				((toggle ^ 0x4000) + 1);
 			doneq_index = pmu->doneq_index;
 			addressLow = pmu->done_qbuffer[doneq_index &
 				0xFFF].addressLow;
@@ -2843,7 +2810,7 @@ static bool arcmsr_hbaD_get_config(struc
 	char __iomem *iop_firm_version;
 	char __iomem *iop_device_map;
 	u32 count;
-	struct MessageUnit_D *reg ;
+	struct MessageUnit_D *reg;
 	void *dma_coherent2;
 	dma_addr_t dma_coherent_handle2;
 	struct pci_dev *pdev = acb->pdev;
@@ -3176,7 +3143,7 @@ static int arcmsr_hbaD_polling_ccbdone(s
 {
 	bool error;
 	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
-	int rtn, doneq_index, index_stripped, outbound_write_pointer;
+	int rtn, doneq_index, index_stripped, outbound_write_pointer, toggle;
 	unsigned long flags;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *pCCB;
@@ -3185,9 +3152,11 @@ static int arcmsr_hbaD_polling_ccbdone(s
 polling_hbaD_ccb_retry:
 	poll_count++;
 	while (1) {
+		spin_lock_irqsave(&acb->doneq_lock, flags);
 		outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
 		doneq_index = pmu->doneq_index;
 		if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
+			spin_unlock_irqrestore(&acb->doneq_lock, flags);
 			if (poll_ccb_done) {
 				rtn = SUCCESS;
 				break;
@@ -3200,23 +3169,13 @@ polling_hbaD_ccb_retry:
 				goto polling_hbaD_ccb_retry;
 			}
 		}
-		spin_lock_irqsave(&acb->doneq_lock, flags);
-		if (doneq_index & 0x4000) {
-			index_stripped = doneq_index & 0xFFF;
-			index_stripped += 1;
-			index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
-			pmu->doneq_index = index_stripped ?
-				(index_stripped | 0x4000) :
-				(index_stripped + 1);
-		} else {
-			index_stripped = doneq_index;
-			index_stripped += 1;
-			index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
-			pmu->doneq_index = index_stripped ? index_stripped :
-				((index_stripped | 0x4000) + 1);
-		}
-		spin_unlock_irqrestore(&acb->doneq_lock, flags);
+		toggle = doneq_index & 0x4000;
+		index_stripped = (doneq_index & 0xFFF) + 1;
+		index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+		pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
+				((toggle ^ 0x4000) + 1);
 		doneq_index = pmu->doneq_index;
+		spin_unlock_irqrestore(&acb->doneq_lock, flags);
 		flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
