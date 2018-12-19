From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 4/12] scsi: arcmsr: Update arcmsr_alloc_ccb_pool for ccb
 buffer address can above 4GB
Date: Wed, 19 Dec 2018 16:34:58 +0800
Message-ID: <1545208498.4457.26.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Update arcmsr_alloc_ccb_pool for ccb buffer address can above 4GB

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 256fe9a..9041edc 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -747,6 +747,7 @@ struct AdapterControlBlock
 	uint32_t		outbound_int_enable;
 	uint32_t		cdb_phyaddr_hi32;
 	uint32_t		reg_mu_acc_handle0;
+	uint64_t		cdb_phyadd_hipart;
 	spinlock_t		eh_lock;
 	spinlock_t		ccblist_lock;
 	spinlock_t		postq_lock;
@@ -855,11 +856,11 @@ struct AdapterControlBlock
 *******************************************************************************
 */
 struct CommandControlBlock{
-	/*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
+	/*x32:sizeof struct_CCB=(64+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
 	struct list_head		list;		/*x32: 8byte, x64: 16byte*/
 	struct scsi_cmnd		*pcmd;		/*8 bytes pointer of linux scsi command */
 	struct AdapterControlBlock	*acb;		/*x32: 4byte, x64: 8byte*/
-	uint32_t			cdb_phyaddr;	/*x32: 4byte, x64: 4byte*/
+	unsigned long			cdb_phyaddr;	/*x32: 4byte, x64: 8byte*/
 	uint32_t			arc_cdb_size;	/*x32:4byte,x64:4byte*/
 	uint16_t			ccb_flags;	/*x32: 2byte, x64: 2byte*/
 #define	CCB_FLAG_READ		0x0000
@@ -875,10 +876,10 @@ struct CommandControlBlock{
 	uint32_t			smid;
 #if BITS_PER_LONG == 64
 	/*  ======================512+64 bytes========================  */
-		uint32_t		reserved[4];	/*16 byte*/
+		uint32_t		reserved[3];	/*12 byte*/
 #else
 	/*  ======================512+32 bytes========================  */
-	//	uint32_t		reserved;	/*4  byte*/
+		uint32_t		reserved[8];	/*32  byte*/
 #endif
 	/*  =======================================================   */
 	struct ARCMSR_CDB		arcmsr_cdb;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e1c75ca..5353dbb 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -694,11 +694,11 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	dma_addr_t dma_coherent_handle;
 	struct CommandControlBlock *ccb_tmp;
 	int i = 0, j = 0;
-	dma_addr_t cdb_phyaddr;
+	unsigned long cdb_phyaddr, next_ccb_phy;
 	unsigned long roundup_ccbsize;
 	unsigned long max_xfer_len;
 	unsigned long max_sg_entrys;
-	uint32_t  firm_config_version;
+	uint32_t  firm_config_version, curr_phy_upper32;
 
 	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
 		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
@@ -726,9 +726,10 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	memset(dma_coherent, 0, acb->uncache_size);
 	acb->ccbsize = roundup_ccbsize;
 	ccb_tmp = dma_coherent;
+	curr_phy_upper32 = upper_32_bits(dma_coherent_handle);
 	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned long)dma_coherent_handle;
 	for(i = 0; i < acb->maxFreeCCB; i++){
-		cdb_phyaddr = dma_coherent_handle + offsetof(struct CommandControlBlock, arcmsr_cdb);
+		cdb_phyaddr = (unsigned long)dma_coherent_handle + offsetof(struct CommandControlBlock, arcmsr_cdb);
 		switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A:
 		case ACB_ADAPTER_TYPE_B:
@@ -744,9 +745,16 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		ccb_tmp->acb = acb;
 		ccb_tmp->smid = (u32)i << 16;
 		INIT_LIST_HEAD(&ccb_tmp->list);
-		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
+		next_ccb_phy = dma_coherent_handle + roundup_ccbsize;
+		if (upper_32_bits(next_ccb_phy) != curr_phy_upper32) {
+			acb->maxFreeCCB = i;
+			acb->host->can_queue = i;
+			break;
+		}
+		else
+			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
 		ccb_tmp = (struct CommandControlBlock *)((unsigned long)ccb_tmp + roundup_ccbsize);
-		dma_coherent_handle = dma_coherent_handle + roundup_ccbsize;
+		dma_coherent_handle = next_ccb_phy;
 	}
 	acb->dma_coherent_handle2 = dma_coherent_handle;
 	acb->dma_coherent2 = ccb_tmp;
@@ -3701,6 +3709,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 	cdb_phyaddr = lower_32_bits(dma_coherent_handle);
 	cdb_phyaddr_hi32 = upper_32_bits(dma_coherent_handle);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
+	acb->cdb_phyadd_hipart = ((uint64_t)cdb_phyaddr_hi32) << 32;
 	/*
 	***********************************************************************
 	**    if adapter type B, set window of "post command Q"
