From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 14/17] arcmsr: fix sparse warning and error
Date: Tue, 19 Aug 2014 15:20:31 +0800
Message-ID: <1408432831.4748.68.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Fix sparse utility checking error and warning.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:40:48.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:41:02.000000000 +0800
@@ -78,7 +78,7 @@ MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 #define	ARCMSR_SLEEPTIME	10
 #define	ARCMSR_RETRYCOUNT	12
 
-wait_queue_head_t wait_q;
+static wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
@@ -332,7 +332,7 @@ static uint8_t arcmsr_hbaB_wait_msgint_r
 
 static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
-	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
 	int i;
 
 	for (i = 0; i < 2000; i++) {
@@ -382,7 +382,7 @@ static void arcmsr_hbaB_flush_cache(stru
 
 static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *reg = pACB->pmuC;
 	int retry_count = 30;/* enlarge wait flush adapter cache time: 10 minute */
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
@@ -800,7 +800,7 @@ static uint8_t arcmsr_hbaB_abort_allcmd(
 }
 static uint8_t arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *reg = pACB->pmuC;
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
@@ -888,7 +888,7 @@ static u32 arcmsr_disable_outbound_ints(
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C:{
-		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		/* disable all outbound interrupt */
 		orig_mask = readl(&reg->host_int_mask); /* disable outbound message0 int */
 		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
@@ -1012,8 +1012,9 @@ static void arcmsr_done4abort_postqueue(
 		/*clear all outbound posted Q*/
 		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* clear doorbell interrupt */
 		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
-			if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
-				writel(0, &reg->done_qbuffer[i]);
+			flag_ccb = reg->done_qbuffer[i];
+			if (flag_ccb != 0) {
+				reg->done_qbuffer[i] = 0;
 				pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
 				pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 				error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
@@ -1026,7 +1027,7 @@ static void arcmsr_done4abort_postqueue(
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		struct  ARCMSR_CDB *pARCMSR_CDB;
 		uint32_t flag_ccb, ccb_cdb_phy;
 		bool error;
@@ -1144,7 +1145,7 @@ static void arcmsr_enable_outbound_ints(
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK | ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
 		writel(intmask_org & mask, &reg->host_int_mask);
 		acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;
@@ -1231,12 +1232,12 @@ static void arcmsr_post_ccb(struct Adapt
 		uint32_t ending_index, index = reg->postq_index;
 
 		ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
-		writel(0, &reg->post_qbuffer[ending_index]);
+		reg->post_qbuffer[ending_index] = 0;
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
-						 &reg->post_qbuffer[index]);
+			reg->post_qbuffer[index] =
+				cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE;
 		} else {
-			writel(cdb_phyaddr, &reg->post_qbuffer[index]);
+			reg->post_qbuffer[index] = cdb_phyaddr;
 		}
 		index++;
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to 0 */
@@ -1245,7 +1246,7 @@ static void arcmsr_post_ccb(struct Adapt
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
 		uint32_t ccb_post_stamp, arc_cdb_size;
 
 		arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;
@@ -1287,7 +1288,7 @@ static void arcmsr_hbaB_stop_bgrb(struct
 
 static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *reg = pACB->pmuC;
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
@@ -1321,7 +1322,7 @@ static void arcmsr_free_ccb_pool(struct 
 	dma_free_coherent(&acb->pdev->dev, acb->uncache_size, acb->dma_coherent, acb->dma_coherent_handle);
 }
 
-void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
+static void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
@@ -1393,7 +1394,7 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
 		qbuffer = (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;
 		}
 	}
@@ -1417,7 +1418,7 @@ static struct QBUFFER __iomem *arcmsr_ge
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
 	}
 
@@ -1613,7 +1614,7 @@ static void arcmsr_hbaA_doorbell_isr(str
 static void arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t outbound_doorbell;
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *reg = pACB->pmuC;
 	/*
 	*******************************************************************
 	**  Maybe here we need to check wrqbuffer_lock is lock or not
@@ -1659,8 +1660,8 @@ static void arcmsr_hbaB_postqueue_isr(st
 	struct CommandControlBlock *pCCB;
 	bool error;
 	index = reg->doneq_index;
-	while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {
-		writel(0, &reg->done_qbuffer[index]);
+	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
+		reg->done_qbuffer[index] = 0;
 		pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
 		pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
@@ -1673,13 +1674,13 @@ static void arcmsr_hbaB_postqueue_isr(st
 
 static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_C *phbcmu;
+	struct MessageUnit_C __iomem *phbcmu;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *ccb;
 	uint32_t flag_ccb, ccb_cdb_phy, throttling = 0;
 	int error;
 
-	phbcmu = (struct MessageUnit_C *)acb->pmuC;
+	phbcmu = acb->pmuC;
 	/* areca cdb command done */
 	/* Use correct offset and size for syncing */
 
@@ -1711,7 +1712,7 @@ static void arcmsr_hbaC_postqueue_isr(st
 */
 static void arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A *reg  = acb->pmuA;
+	struct MessageUnit_A __iomem *reg  = acb->pmuA;
 	/*clear interrupt and message state*/
 	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
@@ -1735,7 +1736,7 @@ static void arcmsr_hbaB_message_isr(stru
 */
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_C *reg  = acb->pmuC;
+	struct MessageUnit_C __iomem *reg  = acb->pmuC;
 	/*clear interrupt and message state*/
 	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, &reg->outbound_doorbell_clear);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
@@ -1796,7 +1797,7 @@ static int arcmsr_hbaB_handle_isr(struct
 static int arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t host_interrupt_status;
-	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
 	/*
 	*********************************************
 	**   check outbound intstatus
@@ -2202,7 +2203,7 @@ static struct CommandControlBlock *arcms
 		list_del_init(&ccb->list);
 	}else{
 		spin_unlock_irqrestore(&acb->ccblist_lock, flags);
-		return 0;
+		return NULL;
 	}
 	spin_unlock_irqrestore(&acb->ccblist_lock, flags);
 	return ccb;
@@ -2437,11 +2438,11 @@ static bool arcmsr_hbaB_get_config(struc
 static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
 {
 	uint32_t intmask_org, Index, firmware_state = 0;
-	struct MessageUnit_C *reg = pACB->pmuC;
+	struct MessageUnit_C __iomem *reg = pACB->pmuC;
 	char *acb_firm_model = pACB->firm_model;
 	char *acb_firm_version = pACB->firm_version;
-	char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);    /*firm_model,15,60-67*/
-	char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);  /*firm_version,17,68-83*/
+	char __iomem *iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);    /*firm_model,15,60-67*/
+	char __iomem *iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);  /*firm_version,17,68-83*/
 	int count;
 	/* disable all outbound interrupt */
 	intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
@@ -2589,7 +2590,8 @@ static int arcmsr_hbaB_polling_ccbdone(s
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	while(1){
 		index = reg->doneq_index;
-		if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {
+		flag_ccb = reg->done_qbuffer[index];
+		if (flag_ccb == 0) {
 			if (poll_ccb_done){
 				rtn = SUCCESS;
 				break;
@@ -2602,7 +2604,7 @@ static int arcmsr_hbaB_polling_ccbdone(s
 				goto polling_hbb_ccb_retry;
 			}
 		}
-		writel(0, &reg->done_qbuffer[index]);
+		reg->done_qbuffer[index] = 0;
 		index++;
 		/*if last index number set it to 0 */
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
@@ -2639,7 +2641,7 @@ static int arcmsr_hbaB_polling_ccbdone(s
 
 static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb, struct CommandControlBlock *poll_ccb)
 {
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+	struct MessageUnit_C __iomem *reg = acb->pmuC;
 	uint32_t flag_ccb, ccb_cdb_phy;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	bool error;
@@ -2802,7 +2804,7 @@ static int arcmsr_iop_confirm(struct Ada
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		if (cdb_phyaddr_hi32 != 0) {
-			struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+			struct MessageUnit_C __iomem *reg = acb->pmuC;
 
 			printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x\n",
 					acb->adapter_index, cdb_phyaddr_hi32);
@@ -2843,7 +2845,7 @@ static void arcmsr_wait_firmware_ready(s
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		do {
 			firmware_state = readl(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
@@ -2875,7 +2877,7 @@ static void arcmsr_hbaA_request_device_m
 
 static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B __iomem *reg = acb->pmuB;
+	struct MessageUnit_B *reg = acb->pmuB;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 		return;
@@ -2960,7 +2962,7 @@ static void arcmsr_hbaB_start_bgrb(struc
 
 static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 {
-	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+	struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
 	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &phbcmu->inbound_doorbell);
@@ -3007,7 +3009,7 @@ static void arcmsr_clear_doorbell_queue_
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		uint32_t outbound_doorbell, i;
 		/* empty doorbell Qbuffer if door bell ringed */
 		outbound_doorbell = readl(&reg->outbound_doorbell);
