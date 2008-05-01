From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to
	dma_alloc_coherent
Date: Fri, 2 May 2008 01:06:39 +0200
Message-ID: <20080501230632.GA19832@xs4all.net>
References: <20080501230211.GA19796@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1516 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764905AbYEAXGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 19:06:42 -0400
Received: from n2o.xs4all.nl (n2o.xs4all.nl [194.109.0.112])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id m41N6dSr093910
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 01:06:40 +0200 (CEST)
	(envelope-from miquels@cistron.nl)
Received: from mikevs by n2o.xs4all.nl with local (Exim 4.69)
	(envelope-from <miquels@cistron.nl>)
	id 1JrhrL-0005A1-Jn
	for linux-scsi@vger.kernel.org; Fri, 02 May 2008 01:06:39 +0200
Content-Disposition: inline
In-Reply-To: <20080501230211.GA19796@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to dma_alloc_coherent

Remove virt_to_bus/bus_to_virt code from dpt_i2o, and use
dma_alloc_coherent() / dma_free_coherent().

This is in preparation of 64-bit support, dma_alloc_coherent()
can allocate memory in the lower 32 bits of physical memory
which is needed because the HBA only supports message blocks under 4GB

This code is based in part on the unofficial adaptec 64-bit
dpt_i2o driver update that I got from Mark Salyzyn at Adaptec.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

diff -ruN linux-2.6.25/drivers/scsi/dpt_i2o.c ../linux-2.6.25-dpt64-01/drivers/scsi/dpt_i2o.c
--- linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-05-01 23:22:42.000000000 +0200
+++ ../linux-2.6.25-dpt64-01/drivers/scsi/dpt_i2o.c	2008-05-01 23:33:06.000000000 +0200
@@ -29,11 +29,6 @@
 /*#define DEBUG 1 */
 /*#define UARTDELAY 1 */
 
-/* On the real kernel ADDR32 should always be zero for 2.4. GFP_HIGH allocates
-   high pages. Keep the macro around because of the broken unmerged ia64 tree */
-
-#define ADDR32 (0)
-
 #include <linux/module.h>
 
 MODULE_AUTHOR("Deanna Bonds, with _lots_ of help from Mark Salyzyn");
@@ -108,9 +103,10 @@
 
 static DEFINE_MUTEX(adpt_configuration_lock);
 
-static struct i2o_sys_tbl *sys_tbl = NULL;
-static int sys_tbl_ind = 0;
-static int sys_tbl_len = 0;
+static struct i2o_sys_tbl *sys_tbl;
+static dma_addr_t sys_tbl_pa;
+static int sys_tbl_ind;
+static int sys_tbl_len;
 
 static adpt_hba* hba_chain = NULL;
 static int hba_count = 0;
@@ -142,6 +138,16 @@
  *============================================================================
  */
 
+static inline u32 dma_high(dma_addr_t addr)
+{
+	return upper_32_bits(addr);
+}
+
+static inline u32 dma_low(dma_addr_t addr)
+{
+	return (u32)addr;
+}
+
 static u8 adpt_read_blink_led(adpt_hba* host)
 {
 	if(host->FwDebugBLEDflag_P != 0) {
@@ -279,11 +285,12 @@
 	u32 len;
 	u32 reqlen;
 	u8* buf;
+	dma_addr_t addr;
 	u8  scb[16];
 	s32 rcode;
 
 	memset(msg, 0, sizeof(msg));
-	buf = kmalloc(80,GFP_KERNEL|ADDR32);
+	buf = dma_alloc_coherent(&pHba->pDev->dev, 80, &addr, GFP_KERNEL);
 	if(!buf){
 		printk(KERN_ERR"%s: Could not allocate buffer\n",pHba->name);
 		return;
@@ -328,7 +335,7 @@
 	/* Now fill in the SGList and command */
 	*lenptr = len;
 	*mptr++ = 0xD0000000|direction|len;
-	*mptr++ = virt_to_bus(buf);
+	*mptr++ = addr;
 
 	// Send it on it's way
 	rcode = adpt_i2o_post_wait(pHba, msg, reqlen<<2, 120);
@@ -336,7 +343,7 @@
 		sprintf(pHba->detail, "Adaptec I2O RAID");
 		printk(KERN_INFO "%s: Inquiry Error (%d)\n",pHba->name,rcode);
 		if (rcode != -ETIME && rcode != -EINTR)
-			kfree(buf);
+			dma_free_coherent(&pHba->pDev->dev, 80, buf, addr);
 	} else {
 		memset(pHba->detail, 0, sizeof(pHba->detail));
 		memcpy(&(pHba->detail), "Vendor: Adaptec ", 16);
@@ -345,7 +352,7 @@
 		memcpy(&(pHba->detail[40]), " FW: ", 4);
 		memcpy(&(pHba->detail[44]), (u8*) &buf[32], 4);
 		pHba->detail[48] = '\0';	/* precautionary */
-		kfree(buf);
+		dma_free_coherent(&pHba->pDev->dev, 80, buf, addr);
 	}
 	adpt_i2o_status_get(pHba);
 	return ;
@@ -621,7 +628,6 @@
 	return len;
 }
 
-
 /*===========================================================================
  * Error Handling routines
  *===========================================================================
@@ -877,6 +883,9 @@
 	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
 		return -EINVAL;
 
+	/* adapter only supports message blocks below 4GB */
+	pci_set_consistent_dma_mask(pDev, DMA_32BIT_MASK);
+
 	base_addr0_phys = pci_resource_start(pDev,0);
 	hba_map0_area_size = pci_resource_len(pDev,0);
 
@@ -1021,10 +1030,24 @@
 	if(pHba->msg_addr_virt != pHba->base_addr_virt){
 		iounmap(pHba->msg_addr_virt);
 	}
-	kfree(pHba->hrt);
-	kfree(pHba->lct);
-	kfree(pHba->status_block);
-	kfree(pHba->reply_pool);
+	if(pHba->hrt) {
+		dma_free_coherent(&pHba->pDev->dev,
+			pHba->hrt->num_entries * pHba->hrt->entry_len << 2,
+			pHba->hrt, pHba->hrt_pa);
+	}
+	if(pHba->lct) {
+		dma_free_coherent(&pHba->pDev->dev, pHba->lct_size,
+			pHba->lct, pHba->lct_pa);
+	}
+	if(pHba->status_block) {
+		dma_free_coherent(&pHba->pDev->dev, sizeof(i2o_status_block),
+			pHba->status_block, pHba->status_block_pa);
+	}
+	if(pHba->reply_pool) {
+		dma_free_coherent(&pHba->pDev->dev,
+			pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+			pHba->reply_pool, pHba->reply_pool_pa);
+	}
 
 	for(d = pHba->devices; d ; d = next){
 		next = d->next;
@@ -1239,6 +1262,7 @@
 {
 	u32 msg[8];
 	u8* status;
+	dma_addr_t addr;
 	u32 m = EMPTY_QUEUE ;
 	ulong timeout = jiffies + (TMOUT_IOPRESET*HZ);
 
@@ -1261,12 +1285,13 @@
 		schedule_timeout_uninterruptible(1);
 	} while (m == EMPTY_QUEUE);
 
-	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	status = dma_alloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
 	if(status == NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
+	memset(status,0,4);
 
 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -1274,8 +1299,8 @@
 	msg[3]=0;
 	msg[4]=0;
 	msg[5]=0;
-	msg[6]=virt_to_bus(status);
-	msg[7]=0;     
+	msg[6]=dma_low(addr);
+	msg[7]=dma_high(addr);
 
 	memcpy_toio(pHba->msg_addr_virt+m, msg, sizeof(msg));
 	wmb();
@@ -1285,7 +1310,10 @@
 	while(*status == 0){
 		if(time_after(jiffies,timeout)){
 			printk(KERN_WARNING"%s: IOP Reset Timeout\n",pHba->name);
-			kfree(status);
+			/* We lose 4 bytes of "status" here, but we cannot
+			   free these because controller may awake and corrupt
+			   those bytes at any time */
+			/* dma_free_coherent(&pHba->pDev->dev, 4, buf, addr); */
 			return -ETIMEDOUT;
 		}
 		rmb();
@@ -1304,6 +1332,10 @@
 			}
 			if(time_after(jiffies,timeout)){
 				printk(KERN_ERR "%s:Timeout waiting for IOP Reset.\n",pHba->name);
+				/* We lose 4 bytes of "status" here, but we
+				   cannot free these because controller may
+				   awake and corrupt those bytes at any time */
+				/* dma_free_coherent(&pHba->pDev->dev, 4, buf, addr); */
 				return -ETIMEDOUT;
 			}
 			schedule_timeout_uninterruptible(1);
@@ -1320,7 +1352,7 @@
 		PDEBUG("%s: Reset completed.\n", pHba->name);
 	}
 
-	kfree(status);
+	dma_free_coherent(&pHba->pDev->dev, 4, status, addr);
 #ifdef UARTDELAY
 	// This delay is to allow someone attached to the card through the debug UART to 
 	// set up the dump levels that they want before the rest of the initialization sequence
@@ -1592,6 +1624,7 @@
 	u32 i = 0;
 	u32 rcode = 0;
 	void *p = NULL;
+	dma_addr_t addr;
 	ulong flags = 0;
 
 	memset(&msg, 0, MAX_MESSAGE_SIZE*4);
@@ -1646,7 +1679,7 @@
 			}
 			sg_size = sg[i].flag_count & 0xffffff;      
 			/* Allocate memory for the transfer */
-			p = kmalloc(sg_size, GFP_KERNEL|ADDR32);
+			p = dma_alloc_coherent(&pHba->pDev->dev, sg_size, &addr, GFP_KERNEL);
 			if(!p) {
 				printk(KERN_DEBUG"%s: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 						pHba->name,sg_size,i,sg_count);
@@ -1743,12 +1776,17 @@
 
 
 cleanup:
-	if (rcode != -ETIME && rcode != -EINTR)
+	if (rcode != -ETIME && rcode != -EINTR) {
+		struct sg_simple_element *sg =
+				(struct sg_simple_element*) (msg +sg_offset);
 		kfree (reply);
-	while(sg_index) {
-		if(sg_list[--sg_index]) {
-			if (rcode != -ETIME && rcode != -EINTR)
-				kfree(sg_list[sg_index]);
+		while(sg_index) {
+			if(sg_list[--sg_index]) {
+				dma_free_coherent(&pHba->pDev->dev,
+					sg[sg_index].flag_count & 0xffffff,
+					sg_list[sg_index],
+					sg[sg_index].addr_bus);
+			}
 		}
 	}
 	return rcode;
@@ -1965,7 +2003,16 @@
 				goto out;
 			}
 		}
-		reply = bus_to_virt(m);
+		if (pHba->reply_pool_pa <= m &&
+		    m < pHba->reply_pool_pa +
+			(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4)) {
+			reply = (u8 *)pHba->reply_pool +
+						(m - pHba->reply_pool_pa);
+		} else {
+			/* Ick, we should *never* be here */
+			printk(KERN_ERR "dpti: reply frame not from pool\n");
+			reply = (u8 *)bus_to_virt(m);
+		}
 
 		if (readl(reply) & MSG_FAIL) {
 			u32 old_m = readl(reply+28); 
@@ -2008,6 +2055,7 @@
 		} else { // SCSI message
 			cmd = (struct scsi_cmnd*) readl(reply+12); 
 			if(cmd != NULL){
+				scsi_dma_unmap(cmd);
 				if(cmd->serial_number != 0) { // If not timedout
 					adpt_i2o_to_scsi(reply, cmd);
 				}
@@ -2156,7 +2204,7 @@
 	host->max_lun = 256;
 	host->max_channel = pHba->top_scsi_channel + 1;
 	host->cmd_per_lun = 1;
-	host->unique_id = (uint) pHba;
+	host->unique_id = (u32)sys_tbl_pa + pHba->unit;
 	host->sg_tablesize = pHba->sg_tablesize;
 	host->can_queue = pHba->post_fifo_size;
 
@@ -2596,11 +2644,10 @@
 static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 {
 	u8 *status;
+	dma_addr_t addr;
 	u32 __iomem *msg = NULL;
 	int i;
 	ulong timeout = jiffies + TMOUT_INITOUTBOUND*HZ;
-	u32* ptr;
-	u32 outbound_frame;  // This had to be a 32 bit address
 	u32 m;
 
 	do {
@@ -2619,13 +2666,14 @@
 
 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
-	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	status = dma_alloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
 	if (!status) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
+	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2634,7 +2682,7 @@
 	writel(4096, &msg[4]);		/* Host page frame size */
 	writel((REPLY_FRAME_SIZE)<<16|0x80, &msg[5]);	/* Outbound msg frame size and Initcode */
 	writel(0xD0000004, &msg[6]);		/* Simple SG LE, EOB */
-	writel(virt_to_bus(status), &msg[7]);
+	writel((u32)addr, &msg[7]);
 
 	writel(m, pHba->post_port);
 	wmb();
@@ -2649,6 +2697,10 @@
 		rmb();
 		if(time_after(jiffies,timeout)){
 			printk(KERN_WARNING"%s: Timeout Initializing\n",pHba->name);
+			/* We lose 4 bytes of "status" here, but we
+			   cannot free these because controller may
+			   awake and corrupt those bytes at any time */
+			/* dma_free_coherent(&pHba->pDev->dev, 4, status, addr); */
 			return -ETIMEDOUT;
 		}
 		schedule_timeout_uninterruptible(1);
@@ -2657,25 +2709,30 @@
 	// If the command was successful, fill the fifo with our reply
 	// message packets
 	if(*status != 0x04 /*I2O_EXEC_OUTBOUND_INIT_COMPLETE*/) {
-		kfree(status);
+		dma_free_coherent(&pHba->pDev->dev, 4, status, addr);
 		return -2;
 	}
-	kfree(status);
+	dma_free_coherent(&pHba->pDev->dev, 4, status, addr);
 
-	kfree(pHba->reply_pool);
+	if(pHba->reply_pool != NULL) {
+		dma_free_coherent(&pHba->pDev->dev,
+			pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+			pHba->reply_pool, pHba->reply_pool_pa);
+	}
 
-	pHba->reply_pool = kzalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
+	pHba->reply_pool = dma_alloc_coherent(&pHba->pDev->dev,
+				pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+				&pHba->reply_pool_pa, GFP_KERNEL);
 	if (!pHba->reply_pool) {
 		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
 		return -ENOMEM;
 	}
+	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
 
-	ptr = pHba->reply_pool;
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
-		outbound_frame = (u32)virt_to_bus(ptr);
-		writel(outbound_frame, pHba->reply_port);
+		writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
+			pHba->reply_port);
 		wmb();
-		ptr +=  REPLY_FRAME_SIZE;
 	}
 	adpt_i2o_status_get(pHba);
 	return 0;
@@ -2699,11 +2756,11 @@
 	u32 m;
 	u32 __iomem *msg;
 	u8 *status_block=NULL;
-	ulong status_block_bus;
 
 	if(pHba->status_block == NULL) {
-		pHba->status_block = (i2o_status_block*)
-			kmalloc(sizeof(i2o_status_block),GFP_KERNEL|ADDR32);
+		pHba->status_block = dma_alloc_coherent(&pHba->pDev->dev,
+					sizeof(i2o_status_block),
+					&pHba->status_block_pa, GFP_KERNEL);
 		if(pHba->status_block == NULL) {
 			printk(KERN_ERR
 			"dpti%d: Get Status Block failed; Out of memory. \n", 
@@ -2713,7 +2770,6 @@
 	}
 	memset(pHba->status_block, 0, sizeof(i2o_status_block));
 	status_block = (u8*)(pHba->status_block);
-	status_block_bus = virt_to_bus(pHba->status_block);
 	timeout = jiffies+TMOUT_GETSTATUS*HZ;
 	do {
 		rmb();
@@ -2738,8 +2794,8 @@
 	writel(0, &msg[3]);
 	writel(0, &msg[4]);
 	writel(0, &msg[5]);
-	writel(((u32)status_block_bus)&0xffffffff, &msg[6]);
-	writel(0, &msg[7]);
+	writel( dma_low(pHba->status_block_pa), &msg[6]);
+	writel( dma_high(pHba->status_block_pa), &msg[7]);
 	writel(sizeof(i2o_status_block), &msg[8]); // 88 bytes
 
 	//post message
@@ -2819,7 +2875,9 @@
 	}
 	do {
 		if (pHba->lct == NULL) {
-			pHba->lct = kmalloc(pHba->lct_size, GFP_KERNEL|ADDR32);
+			pHba->lct = dma_alloc_coherent(&pHba->pDev->dev,
+					pHba->lct_size, &pHba->lct_pa,
+					GFP_KERNEL);
 			if(pHba->lct == NULL) {
 				printk(KERN_CRIT "%s: Lct Get failed. Out of memory.\n",
 					pHba->name);
@@ -2835,7 +2893,7 @@
 		msg[4] = 0xFFFFFFFF;	/* All devices */
 		msg[5] = 0x00000000;	/* Report now */
 		msg[6] = 0xD0000000|pHba->lct_size;
-		msg[7] = virt_to_bus(pHba->lct);
+		msg[7] = (u32)pHba->lct_pa;
 
 		if ((ret=adpt_i2o_post_wait(pHba, msg, sizeof(msg), 360))) {
 			printk(KERN_ERR "%s: LCT Get failed (status=%#10x.\n", 
@@ -2846,7 +2904,8 @@
 
 		if ((pHba->lct->table_size << 2) > pHba->lct_size) {
 			pHba->lct_size = pHba->lct->table_size << 2;
-			kfree(pHba->lct);
+			dma_free_coherent(&pHba->pDev->dev, pHba->lct_size,
+					pHba->lct, pHba->lct_pa);
 			pHba->lct = NULL;
 		}
 	} while (pHba->lct == NULL);
@@ -2871,25 +2930,30 @@
 
 static int adpt_i2o_build_sys_table(void)
 {
-	adpt_hba* pHba = NULL;
+	adpt_hba* pHba = hba_chain;
 	int count = 0;
 
+	if (sys_tbl)
+		dma_free_coherent(&pHba->pDev->dev, sys_tbl_len,
+					sys_tbl, sys_tbl_pa);
+
 	sys_tbl_len = sizeof(struct i2o_sys_tbl) +	// Header + IOPs
 				(hba_count) * sizeof(struct i2o_sys_tbl_entry);
 
-	kfree(sys_tbl);
-
-	sys_tbl = kzalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
+	sys_tbl = dma_alloc_coherent(&pHba->pDev->dev,
+				sys_tbl_len, &sys_tbl_pa, GFP_KERNEL);
 	if (!sys_tbl) {
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
+	memset(sys_tbl, 0, sys_tbl_len);
 
 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
 	sys_tbl->change_ind = sys_tbl_ind++;
 
 	for(pHba = hba_chain; pHba; pHba = pHba->next) {
+		u64 addr;
 		// Get updated Status Block so we have the latest information
 		if (adpt_i2o_status_get(pHba)) {
 			sys_tbl->num_entries--;
@@ -2905,8 +2969,9 @@
 		sys_tbl->iops[count].frame_size = pHba->status_block->inbound_frame_size;
 		sys_tbl->iops[count].last_changed = sys_tbl_ind - 1; // ??
 		sys_tbl->iops[count].iop_capabilities = pHba->status_block->iop_capabilities;
-		sys_tbl->iops[count].inbound_low = (u32)virt_to_bus(pHba->post_port);
-		sys_tbl->iops[count].inbound_high = (u32)((u64)virt_to_bus(pHba->post_port)>>32);
+		addr = pHba->base_addr_phys + 0x40;
+		sys_tbl->iops[count].inbound_low = dma_low(addr);
+		sys_tbl->iops[count].inbound_high = dma_high(addr);
 
 		count++;
 	}
@@ -3042,7 +3107,8 @@
 
 	do {
 		if (pHba->hrt == NULL) {
-			pHba->hrt=kmalloc(size, GFP_KERNEL|ADDR32);
+			pHba->hrt = dma_alloc_coherent(&pHba->pDev->dev,
+					size, &pHba->hrt_pa, GFP_KERNEL);
 			if (pHba->hrt == NULL) {
 				printk(KERN_CRIT "%s: Hrt Get failed; Out of memory.\n", pHba->name);
 				return -ENOMEM;
@@ -3054,7 +3120,7 @@
 		msg[2]= 0;
 		msg[3]= 0;
 		msg[4]= (0xD0000000 | size);    /* Simple transaction */
-		msg[5]= virt_to_bus(pHba->hrt);   /* Dump it here */
+		msg[5]= (u32)pHba->hrt_pa;	/* Dump it here */
 
 		if ((ret = adpt_i2o_post_wait(pHba, msg, sizeof(msg),20))) {
 			printk(KERN_ERR "%s: Unable to get HRT (status=%#10x)\n", pHba->name, ret);
@@ -3062,8 +3128,10 @@
 		}
 
 		if (pHba->hrt->num_entries * pHba->hrt->entry_len << 2 > size) {
-			size = pHba->hrt->num_entries * pHba->hrt->entry_len << 2;
-			kfree(pHba->hrt);
+			int newsize = pHba->hrt->num_entries * pHba->hrt->entry_len << 2;
+			dma_free_coherent(&pHba->pDev->dev, size,
+				pHba->hrt, pHba->hrt_pa);
+			size = newsize;
 			pHba->hrt = NULL;
 		}
 	} while(pHba->hrt == NULL);
@@ -3077,33 +3145,54 @@
 			int group, int field, void *buf, int buflen)
 {
 	u16 opblk[] = { 1, 0, I2O_PARAMS_FIELD_GET, group, 1, field };
-	u8 *resblk;
+	u8 *opblk_va;
+	dma_addr_t opblk_pa;
+	u8 *resblk_va;
+	dma_addr_t resblk_pa;
 
 	int size;
 
 	/* 8 bytes for header */
-	resblk = kmalloc(sizeof(u8) * (8+buflen), GFP_KERNEL|ADDR32);
-	if (resblk == NULL) {
+	resblk_va = dma_alloc_coherent(&pHba->pDev->dev,
+			sizeof(u8) * (8 + buflen), &resblk_pa, GFP_KERNEL);
+	if (resblk_va == NULL) {
 		printk(KERN_CRIT "%s: query scalar failed; Out of memory.\n", pHba->name);
 		return -ENOMEM;
 	}
 
+	opblk_va = dma_alloc_coherent(&pHba->pDev->dev,
+			sizeof(opblk), &opblk_pa, GFP_KERNEL);
+	if (opblk_va == NULL) {
+		dma_free_coherent(&pHba->pDev->dev, sizeof(u8) * (8+buflen),
+			resblk_va, resblk_pa);
+		printk(KERN_CRIT "%s: query operatio failed; Out of memory.\n",
+			pHba->name);
+		return -ENOMEM;
+	}
 	if (field == -1)  		/* whole group */
 			opblk[4] = -1;
 
+	memcpy(opblk_va, opblk, sizeof(opblk));
 	size = adpt_i2o_issue_params(I2O_CMD_UTIL_PARAMS_GET, pHba, tid, 
-		opblk, sizeof(opblk), resblk, sizeof(u8)*(8+buflen));
+		opblk_va, opblk_pa, sizeof(opblk),
+		resblk_va, resblk_pa, sizeof(u8)*(8+buflen));
+	dma_free_coherent(&pHba->pDev->dev, sizeof(opblk), opblk_va, opblk_pa);
 	if (size == -ETIME) {
+		dma_free_coherent(&pHba->pDev->dev, sizeof(u8) * (8+buflen),
+							resblk_va, resblk_pa);
 		printk(KERN_WARNING "%s: issue params failed; Timed out.\n", pHba->name);
 		return -ETIME;
 	} else if (size == -EINTR) {
+		dma_free_coherent(&pHba->pDev->dev, sizeof(u8) * (8+buflen),
+							resblk_va, resblk_pa);
 		printk(KERN_WARNING "%s: issue params failed; Interrupted.\n", pHba->name);
 		return -EINTR;
 	}
 			
-	memcpy(buf, resblk+8, buflen);  /* cut off header */
+	memcpy(buf, resblk_va+8, buflen);  /* cut off header */
 
-	kfree(resblk);
+	dma_free_coherent(&pHba->pDev->dev, sizeof(u8) * (8+buflen),
+						resblk_va, resblk_pa);
 	if (size < 0)
 		return size;	
 
@@ -3120,10 +3209,11 @@
  *	ResultCount, ErrorInfoSize, BlockStatus and BlockSize.
  */
 static int adpt_i2o_issue_params(int cmd, adpt_hba* pHba, int tid, 
-		  void *opblk, int oplen, void *resblk, int reslen)
+		  void *opblk_va,  dma_addr_t opblk_pa, int oplen,
+		void *resblk_va, dma_addr_t resblk_pa, int reslen)
 {
 	u32 msg[9]; 
-	u32 *res = (u32 *)resblk;
+	u32 *res = (u32 *)resblk_va;
 	int wait_status;
 
 	msg[0] = NINE_WORD_MSG_SIZE | SGL_OFFSET_5;
@@ -3132,12 +3222,12 @@
 	msg[3] = 0;
 	msg[4] = 0;
 	msg[5] = 0x54000000 | oplen;	/* OperationBlock */
-	msg[6] = virt_to_bus(opblk);
+	msg[6] = (u32)opblk_pa;
 	msg[7] = 0xD0000000 | reslen;	/* ResultBlock */
-	msg[8] = virt_to_bus(resblk);
+	msg[8] = (u32)resblk_pa;
 
 	if ((wait_status = adpt_i2o_post_wait(pHba, msg, sizeof(msg), 20))) {
-		printk("adpt_i2o_issue_params: post_wait failed (%p)\n", resblk);
+		printk("adpt_i2o_issue_params: post_wait failed (%p)\n", resblk_va);
    		return wait_status; 	/* -DetailedStatus */
 	}
 
@@ -3240,7 +3330,7 @@
 	 * Private i/o space declaration  
 	 */
 	msg[6] = 0x54000000 | sys_tbl_len;
-	msg[7] = virt_to_phys(sys_tbl);
+	msg[7] = (u32)sys_tbl_pa;
 	msg[8] = 0x54000000 | 0;
 	msg[9] = 0;
 	msg[10] = 0xD4000000 | 0;
diff -ruN linux-2.6.25/drivers/scsi/dpti.h ../linux-2.6.25-dpt64-01/drivers/scsi/dpti.h
--- linux-2.6.25/drivers/scsi/dpti.h	2008-05-01 23:22:42.000000000 +0200
+++ ../linux-2.6.25-dpt64-01/drivers/scsi/dpti.h	2008-05-01 23:29:10.000000000 +0200
@@ -228,14 +228,18 @@
 	u32  post_fifo_size;
 	u32  reply_fifo_size;
 	u32* reply_pool;
+	dma_addr_t reply_pool_pa;
 	u32  sg_tablesize;	// Scatter/Gather List Size.       
 	u8  top_scsi_channel;
 	u8  top_scsi_id;
 	u8  top_scsi_lun;
 
 	i2o_status_block* status_block;
+	dma_addr_t status_block_pa;
 	i2o_hrt* hrt;
+	dma_addr_t hrt_pa;
 	i2o_lct* lct;
+	dma_addr_t lct_pa;
 	uint lct_size;
 	struct i2o_device* devices;
 	struct adpt_channel channel[MAX_CHANNEL];
@@ -271,7 +275,8 @@
 static const char *adpt_i2o_get_class_name(int class);
 #endif
 static int adpt_i2o_issue_params(int cmd, adpt_hba* pHba, int tid, 
-		  void *opblk, int oplen, void *resblk, int reslen);
+		  void *opblk, dma_addr_t opblk_pa, int oplen,
+		  void *resblk, dma_addr_t resblk_pa, int reslen);
 static int adpt_i2o_post_wait(adpt_hba* pHba, u32* msg, int len, int timeout);
 static int adpt_i2o_lct_get(adpt_hba* pHba);
 static int adpt_i2o_parse_lct(adpt_hba* pHba);
