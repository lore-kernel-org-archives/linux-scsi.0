From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] dpt_i2o partial iomem annotations
Date: Sun, 21 Nov 2004 18:31:45 +0000
Message-ID: <20041121183145.GB26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18076 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261778AbUKUSbt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Nov 2004 13:31:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk6-disk_on_chip/drivers/scsi/dpt_i2o.c RC10-rc2-bk6-dpt/drivers/scsi/dpt_i2o.c
--- RC10-rc2-bk6-disk_on_chip/drivers/scsi/dpt_i2o.c	Mon Oct 18 17:54:55 2004
+++ RC10-rc2-bk6-dpt/drivers/scsi/dpt_i2o.c	Sun Nov 21 10:50:55 2004
@@ -872,8 +872,8 @@
 	ulong base_addr1_phys = 0;
 	u32 hba_map0_area_size = 0;
 	u32 hba_map1_area_size = 0;
-	ulong base_addr_virt = 0;
-	ulong msg_addr_virt = 0;
+	void __iomem *base_addr_virt = NULL;
+	void __iomem *msg_addr_virt = NULL;
 
 	int raptorFlag = FALSE;
 	int i;
@@ -907,17 +907,17 @@
 	}
 
 
-	base_addr_virt = (ulong)ioremap(base_addr0_phys,hba_map0_area_size);
-	if(base_addr_virt == 0) {
+	base_addr_virt = ioremap(base_addr0_phys,hba_map0_area_size);
+	if (!base_addr_virt) {
 		PERROR("dpti: adpt_config_hba: io remap failed\n");
 		return -EINVAL;
 	}
 
         if(raptorFlag == TRUE) {
-		msg_addr_virt = (ulong)ioremap(base_addr1_phys, hba_map1_area_size );
-		if(msg_addr_virt == 0) {
+		msg_addr_virt = ioremap(base_addr1_phys, hba_map1_area_size );
+		if (!msg_addr_virt) {
 			PERROR("dpti: adpt_config_hba: io remap failed on BAR1\n");
-			iounmap((void*)base_addr_virt);
+			iounmap(base_addr_virt);
 			return -EINVAL;
 		}
 	} else {
@@ -928,9 +928,9 @@
 	pHba = kmalloc(sizeof(adpt_hba), GFP_KERNEL);
 	if( pHba == NULL) {
 		if(msg_addr_virt != base_addr_virt){
-			iounmap((void*)msg_addr_virt);
+			iounmap(msg_addr_virt);
 		}
-		iounmap((void*)base_addr_virt);
+		iounmap(base_addr_virt);
 		return -ENOMEM;
 	}
 	memset(pHba, 0, sizeof(adpt_hba));
@@ -961,10 +961,10 @@
 
 	// Set up the Virtual Base Address of the I2O Device
 	pHba->base_addr_virt = base_addr_virt;
-	pHba->msg_addr_virt = msg_addr_virt;  
-	pHba->irq_mask = (ulong)(base_addr_virt+0x30);
-	pHba->post_port = (ulong)(base_addr_virt+0x40);
-	pHba->reply_port = (ulong)(base_addr_virt+0x44);
+	pHba->msg_addr_virt = msg_addr_virt;
+	pHba->irq_mask = base_addr_virt+0x30;
+	pHba->post_port = base_addr_virt+0x40;
+	pHba->reply_port = base_addr_virt+0x44;
 
 	pHba->hrt = NULL;
 	pHba->lct = NULL;
@@ -980,12 +980,12 @@
 	spin_lock_init(&adpt_post_wait_lock);
 
 	if(raptorFlag == 0){
-		printk(KERN_INFO"Adaptec I2O RAID controller %d at %lx size=%x irq=%d\n", 
+		printk(KERN_INFO"Adaptec I2O RAID controller %d at %p size=%x irq=%d\n", 
 			hba_count-1, base_addr_virt, hba_map0_area_size, pDev->irq);
 	} else {
 		printk(KERN_INFO"Adaptec I2O RAID controller %d irq=%d\n",hba_count-1, pDev->irq);
-		printk(KERN_INFO"     BAR0 %lx - size= %x\n",base_addr_virt,hba_map0_area_size);
-		printk(KERN_INFO"     BAR1 %lx - size= %x\n",msg_addr_virt,hba_map1_area_size);
+		printk(KERN_INFO"     BAR0 %p - size= %x\n",base_addr_virt,hba_map0_area_size);
+		printk(KERN_INFO"     BAR1 %p - size= %x\n",msg_addr_virt,hba_map1_area_size);
 	}
 
 	if (request_irq (pDev->irq, adpt_isr, SA_SHIRQ, pHba->name, pHba)) {
@@ -1036,9 +1036,9 @@
 	hba_count--;
 	up(&adpt_configuration_lock);
 
-	iounmap((void*)pHba->base_addr_virt);
+	iounmap(pHba->base_addr_virt);
 	if(pHba->msg_addr_virt != pHba->base_addr_virt){
-		iounmap((void*)pHba->msg_addr_virt);
+		iounmap(pHba->msg_addr_virt);
 	}
 	if(pHba->hrt) {
 		kfree(pHba->hrt);
@@ -1222,7 +1222,7 @@
 {
 
 	u32 m = EMPTY_QUEUE;
-	u32 *msg;
+	u32 __iomem *msg;
 	ulong timeout = jiffies + 30*HZ;
 	do {
 		rmb();
@@ -1238,7 +1238,7 @@
 		schedule_timeout(1);
 	} while(m == EMPTY_QUEUE);
 		
-	msg = (u32*) (pHba->msg_addr_virt + m);
+	msg = pHba->msg_addr_virt + m;
 	memcpy_toio(msg, data, len);
 	wmb();
 
@@ -2638,7 +2638,7 @@
 
 static s32 adpt_send_nop(adpt_hba*pHba,u32 m)
 {
-	u32 *msg;
+	u32 __iomem *msg;
 	ulong timeout = jiffies + 5*HZ;
 
 	while(m == EMPTY_QUEUE){
@@ -2654,7 +2654,7 @@
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
 	}
-	msg = (u32*)(pHba->msg_addr_virt + m);
+	msg = (u32 __iomem *)(pHba->msg_addr_virt + m);
 	writel( THREE_WORD_MSG_SIZE | SGL_OFFSET_0,&msg[0]);
 	writel( I2O_CMD_UTIL_NOP << 24 | HOST_TID << 12 | 0,&msg[1]);
 	writel( 0,&msg[2]);
@@ -2668,7 +2668,7 @@
 static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 {
 	u8 *status;
-	u32 *msg = NULL;
+	u32 __iomem *msg = NULL;
 	int i;
 	ulong timeout = jiffies + TMOUT_INITOUTBOUND*HZ;
 	u32* ptr;
@@ -2690,7 +2690,7 @@
 		schedule_timeout(1);
 	} while(m == EMPTY_QUEUE);
 
-	msg=(u32 *)(pHba->msg_addr_virt+m);
+	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
 	status = kmalloc(4,GFP_KERNEL|ADDR32);
 	if (status==NULL) {
@@ -2775,7 +2775,7 @@
 {
 	ulong timeout;
 	u32 m;
-	u32 *msg;
+	u32 __iomem *msg;
 	u8 *status_block=NULL;
 	ulong status_block_bus;
 
@@ -2809,7 +2809,7 @@
 	} while(m==EMPTY_QUEUE);
 
 	
-	msg=(u32*)(pHba->msg_addr_virt+m);
+	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
 	writel(NINE_WORD_MSG_SIZE|SGL_OFFSET_0, &msg[0]);
 	writel(I2O_CMD_STATUS_GET<<24|HOST_TID<<12|ADAPTER_TID, &msg[1]);
diff -urN RC10-rc2-bk6-disk_on_chip/drivers/scsi/dpti.h RC10-rc2-bk6-dpt/drivers/scsi/dpti.h
--- RC10-rc2-bk6-disk_on_chip/drivers/scsi/dpti.h	Mon Oct 18 17:53:06 2004
+++ RC10-rc2-bk6-dpt/drivers/scsi/dpti.h	Sun Nov 21 10:50:55 2004
@@ -228,12 +228,12 @@
 	char name[32];
 	char detail[55];
 
-	ulong base_addr_virt;
-	ulong msg_addr_virt;
+	void __iomem *base_addr_virt;
+	void __iomem *msg_addr_virt;
 	ulong base_addr_phys;
-	ulong  post_port;
-	ulong  reply_port;
-	ulong  irq_mask;
+	void __iomem *post_port;
+	void __iomem *reply_port;
+	void __iomem *irq_mask;
 	u16  post_count;
 	u32  post_fifo_size;
 	u32  reply_fifo_size;
@@ -251,12 +251,12 @@
 	struct adpt_channel channel[MAX_CHANNEL];
 	struct proc_dir_entry* proc_entry;	/* /proc dir */
 
-	ulong FwDebugBuffer_P;	// Virtual Address Of FW Debug Buffer
+	void __iomem *FwDebugBuffer_P;	// Virtual Address Of FW Debug Buffer
 	u32   FwDebugBufferSize;	// FW Debug Buffer Size In Bytes
-	ulong FwDebugStrLength_P;	// Virtual Addr Of FW Debug String Len
-	ulong FwDebugFlags_P;	// Virtual Address Of FW Debug Flags 
-	ulong FwDebugBLEDflag_P;	// Virtual Addr Of FW Debug BLED
-	ulong FwDebugBLEDvalue_P;	// Virtual Addr Of FW Debug BLED
+	void __iomem *FwDebugStrLength_P;// Virtual Addr Of FW Debug String Len
+	void __iomem *FwDebugFlags_P;	// Virtual Address Of FW Debug Flags 
+	void __iomem *FwDebugBLEDflag_P;// Virtual Addr Of FW Debug BLED
+	void __iomem *FwDebugBLEDvalue_P;// Virtual Addr Of FW Debug BLED
 	u32 FwDebugFlags;
 } adpt_hba;
 
