From: akpm@osdl.org
Subject: [patch 1/1] Get I2O working with Adaptec's zero channel controllers
Date: Sat, 29 May 2004 00:13:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405290713.i4T7Dxr25622@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:53670 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262388AbUE2HOC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 03:14:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, Markus.Lidel@shadowconnect.com


From: Markus Lidel <Markus.Lidel@shadowconnect.com>

This patch now gets the ASR-2000S, ASR-2005S, ASR-2010S and ASR-2015S
controllers working with the I2O subsystem.  It tested on two different
system with ASR-2005S and ASR-2010S and reported as working.

It's also tested on i686 and x86_64 with already working I2O controllers
without a problem.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/message/i2o/i2o_block.c  |    8 -
 25-akpm/drivers/message/i2o/i2o_config.c |    2 
 25-akpm/drivers/message/i2o/i2o_core.c   |  159 ++++++++++++++++++++-----------
 25-akpm/drivers/message/i2o/i2o_scsi.c   |    6 -
 25-akpm/include/linux/i2o.h              |   14 +-
 5 files changed, 121 insertions(+), 68 deletions(-)

diff -puN drivers/message/i2o/i2o_block.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers drivers/message/i2o/i2o_block.c
--- 25/drivers/message/i2o/i2o_block.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers	Fri May 28 16:21:08 2004
+++ 25-akpm/drivers/message/i2o/i2o_block.c	Fri May 28 16:21:08 2004
@@ -280,8 +280,8 @@ static int i2ob_send(u32 m, struct i2ob_
 {
 	struct i2o_controller *c = dev->controller;
 	int tid = dev->tid;
-	unsigned long msg;
-	unsigned long mptr;
+	void *msg;
+	void *mptr;
 	u64 offset;
 	struct request *req = ireq->req;
 	int count = req->nr_sectors<<9;
@@ -291,7 +291,7 @@ static int i2ob_send(u32 m, struct i2ob_
 
 	// printk(KERN_INFO "i2ob_send called\n");
 	/* Map the message to a virtual address */
-	msg = c->mem_offset + m;
+	msg = c->msg_virt + m;
 	
 	sgnum = i2ob_build_sglist(dev, ireq);
 	
@@ -479,7 +479,7 @@ static void i2o_block_reply(struct i2o_h
 		/* Now flush the message by making it a NOP */
 		m[0]&=0x00FFFFFF;
 		m[0]|=(I2O_CMD_UTIL_NOP)<<24;
-		i2o_post_message(c, ((unsigned long)m) - c->mem_offset);
+		i2o_post_message(c, (unsigned long) m - (unsigned long) c->msg_virt);
 
 		return;
 	}
diff -puN drivers/message/i2o/i2o_config.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers drivers/message/i2o/i2o_config.c
--- 25/drivers/message/i2o/i2o_config.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers	Fri May 28 16:21:08 2004
+++ 25-akpm/drivers/message/i2o/i2o_config.c	Fri May 28 16:21:08 2004
@@ -97,7 +97,7 @@ static void i2o_cfg_reply(struct i2o_han
 	u32 *msg = (u32 *)m;
 
 	if (msg[0] & MSG_FAIL) {
-		u32 *preserved_msg = (u32*)(c->mem_offset + msg[7]);
+		u32 *preserved_msg = (u32*)(c->msg_virt + msg[7]);
 
 		printk(KERN_ERR "i2o_config: IOP failed to process the msg.\n");
 
diff -puN drivers/message/i2o/i2o_core.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers drivers/message/i2o/i2o_core.c
--- 25/drivers/message/i2o/i2o_core.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers	Fri May 28 16:21:08 2004
+++ 25-akpm/drivers/message/i2o/i2o_core.c	Fri May 28 16:21:08 2004
@@ -354,7 +354,7 @@ static void i2o_core_reply(struct i2o_ha
 
 	if (msg[0] & MSG_FAIL) // Fail bit is set
 	{
-		u32 *preserved_msg = (u32*)(c->mem_offset + msg[7]);
+		u32 *preserved_msg = (u32*)(c->msg_virt + msg[7]);
 
 		i2o_report_status(KERN_INFO, "i2o_core", msg);
 		i2o_dump_message(preserved_msg);
@@ -1794,7 +1794,7 @@ static int i2o_reset_controller(struct i
 	m=i2o_wait_message(c, "AdapterReset");
 	if(m==0xFFFFFFFF)	
 		return -ETIMEDOUT;
-	msg=(u32 *)(c->mem_offset+m);
+	msg=(u32 *)(c->msg_virt+m);
 	
 	status = pci_alloc_consistent(c->pdev, 4, &status_phys);
 	if(status == NULL) {
@@ -1923,7 +1923,7 @@ int i2o_status_get(struct i2o_controller
 	m=i2o_wait_message(c, "StatusGet");
 	if(m==0xFFFFFFFF)
 		return -ETIMEDOUT;	
-	msg=(u32 *)(c->mem_offset+m);
+	msg=(u32 *)(c->msg_virt+m);
 
 	msg[0]=NINE_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_STATUS_GET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -2344,7 +2344,7 @@ int i2o_init_outbound_q(struct i2o_contr
 	m=i2o_wait_message(c, "OutboundInit");
 	if(m==0xFFFFFFFF)
 		return -ETIMEDOUT;
-	msg=(u32 *)(c->mem_offset+m);
+	msg=(u32 *)(c->msg_virt+m);
 
 	status = pci_alloc_consistent(c->pdev, 4, &status_phys);
 	if (status==NULL) {
@@ -2618,7 +2618,7 @@ static int i2o_build_sys_table(void)
 		sys_tbl->iops[count].last_changed = sys_tbl_ind - 1; // ??
 		sys_tbl->iops[count].iop_capabilities = 
 				iop->status_block->iop_capabilities;
-		sys_tbl->iops[count].inbound_low = iop->post_port;
+		sys_tbl->iops[count].inbound_low = (u32)iop->post_port;
 		sys_tbl->iops[count].inbound_high = 0;	// FIXME: 64-bit support
 
 		count++;
@@ -2666,7 +2666,7 @@ int i2o_post_this(struct i2o_controller 
 		       c->name);
 		return -ETIMEDOUT;
 	}
-	msg = (u32 *)(c->mem_offset + m);
+	msg = (u32 *)(c->msg_virt + m);
  	memcpy_toio(msg, data, len);
 	i2o_post_message(c,m);
 	return 0;
@@ -3592,7 +3592,9 @@ static void i2o_pci_dispose(struct i2o_c
 	I2O_IRQ_WRITE32(c,0xFFFFFFFF);
 	if(c->irq > 0)
 		free_irq(c->irq, c);
-	iounmap(((u8 *)c->post_port)-0x40);
+	iounmap(c->base_virt);
+	if(c->raptor)
+		iounmap(c->msg_virt);
 
 #ifdef CONFIG_MTRR
 	if(c->mtrr_reg0 > 0)
@@ -3633,9 +3635,12 @@ int __init i2o_pci_install(struct pci_de
 {
 	struct i2o_controller *c=kmalloc(sizeof(struct i2o_controller),
 						GFP_KERNEL);
-	unsigned long mem;
-	u32 memptr = 0;
-	u32 size;
+	void *bar0_virt;
+	void *bar1_virt;
+	unsigned long bar0_phys = 0;
+	unsigned long bar1_phys = 0;
+	unsigned long bar0_size = 0;
+	unsigned long bar1_size = 0;
 	
 	int i;
 
@@ -3646,37 +3651,9 @@ int __init i2o_pci_install(struct pci_de
 	}
 	memset(c, 0, sizeof(*c));
 
-	for(i=0; i<6; i++)
-	{
-		/* Skip I/O spaces */
-		if(!(pci_resource_flags(dev, i) & IORESOURCE_IO))
-		{
-			memptr = pci_resource_start(dev, i);
-			break;
-		}
-	}
-	
-	if(i==6)
-	{
-		printk(KERN_ERR "i2o: I2O controller has no memory regions defined.\n");
-		kfree(c);
-		return -EINVAL;
-	}
-	
-	size = dev->resource[i].end-dev->resource[i].start+1;	
-	/* Map the I2O controller */
-	
-	printk(KERN_INFO "i2o: PCI I2O controller at 0x%08X size=%d\n", memptr, size);
-	mem = (unsigned long)ioremap(memptr, size);
-	if(mem==0)
-	{
-		printk(KERN_ERR "i2o: Unable to map controller.\n");
-		kfree(c);
-		return -EINVAL;
-	}
-
 	c->irq = -1;
 	c->dpt = 0;
+	c->raptor = 0;
 	c->short_req = 0;
 	c->pdev = dev;
 
@@ -3684,13 +3661,6 @@ int __init i2o_pci_install(struct pci_de
 	c->context_list_lock = SPIN_LOCK_UNLOCKED;
 #endif
 
-	c->irq_mask = mem+0x34;
-	c->post_port = mem+0x40;
-	c->reply_port = mem+0x44;
-
-	c->mem_phys = memptr;
-	c->mem_offset = mem;
-	
 	/*
 	 *	Cards that fall apart if you hit them with large I/O
 	 *	loads...
@@ -3701,6 +3671,7 @@ int __init i2o_pci_install(struct pci_de
 		c->short_req = 1;
 		printk(KERN_INFO "I2O: Symbios FC920 workarounds activated.\n");
 	}
+
 	if(dev->subsystem_vendor == PCI_VENDOR_ID_PROMISE)
 	{
 		c->promise = 1;
@@ -3712,15 +3683,85 @@ int __init i2o_pci_install(struct pci_de
 	 *	them
 	 */
 	 
-	if(dev->vendor == PCI_VENDOR_ID_DPT)
+	if(dev->vendor == PCI_VENDOR_ID_DPT) {
 		c->dpt=1;
+		if(dev->device == 0xA511)
+			c->raptor=1;
+	}
+
+	for(i=0; i<6; i++)
+	{
+		/* Skip I/O spaces */
+		if(!(pci_resource_flags(dev, i) & IORESOURCE_IO))
+		{
+			if(!bar0_phys)
+			{
+				bar0_phys = pci_resource_start(dev, i);
+				bar0_size = pci_resource_len(dev, i);
+				if(!c->raptor)
+					break;
+			}
+			else
+			{
+				bar1_phys = pci_resource_start(dev, i);
+				bar1_size = pci_resource_len(dev, i);
+				break;
+			}
+		}
+	}
+
+	if(i==6)
+	{
+		printk(KERN_ERR "i2o: I2O controller has no memory regions defined.\n");
+		kfree(c);
+		return -EINVAL;
+	}
+
+
+	/* Map the I2O controller */
+	if(!c->raptor)
+		printk(KERN_INFO "i2o: PCI I2O controller at %08lX size=%ld\n", bar0_phys, bar0_size);
+	else
+		printk(KERN_INFO "i2o: PCI I2O controller\n    BAR0 at 0x%08lX size=%ld\n    BAR1 at 0x%08lX size=%ld\n", bar0_phys, bar0_size, bar1_phys, bar1_size);
+
+	bar0_virt = ioremap(bar0_phys, bar0_size);
+	if(bar0_virt==0)
+	{
+		printk(KERN_ERR "i2o: Unable to map controller.\n");
+		kfree(c);
+		return -EINVAL;
+	}
+
+	if(c->raptor)
+	{
+		bar1_virt = ioremap(bar1_phys, bar1_size);
+		if(bar1_virt==0)
+		{
+			printk(KERN_ERR "i2o: Unable to map controller.\n");
+			kfree(c);
+			iounmap(bar0_virt);
+			return -EINVAL;
+		}
+	} else {
+		bar1_virt = bar0_virt;
+		bar1_phys = bar0_phys;
+		bar1_size = bar0_size;
+	}
+
+	c->irq_mask = bar0_virt+0x34;
+	c->post_port = bar0_virt+0x40;
+	c->reply_port = bar0_virt+0x44;
+
+	c->base_phys = bar0_phys;
+	c->base_virt = bar0_virt;
+	c->msg_phys = bar1_phys;
+	c->msg_virt = bar1_virt;
 	
 	/* 
 	 * Enable Write Combining MTRR for IOP's memory region
 	 */
 #ifdef CONFIG_MTRR
-	c->mtrr_reg0 =
-		mtrr_add(c->mem_phys, size, MTRR_TYPE_WRCOMB, 1);
+	c->mtrr_reg0 = mtrr_add(c->base_phys, bar0_size, MTRR_TYPE_WRCOMB, 1);
 	/*
 	 * If it is an INTEL i960 I/O processor then set the first 64K to
 	 * Uncacheable since the region contains the Messaging unit which
@@ -3730,14 +3771,16 @@ int __init i2o_pci_install(struct pci_de
 	if(dev->vendor == PCI_VENDOR_ID_INTEL || dev->vendor == PCI_VENDOR_ID_DPT)
 	{
 		printk(KERN_INFO "I2O: MTRR workaround for Intel i960 processor\n"); 
-		c->mtrr_reg1 =	mtrr_add(c->mem_phys, 65536, MTRR_TYPE_UNCACHABLE, 1);
+		c->mtrr_reg1 =	mtrr_add(c->base_phys, 65536, MTRR_TYPE_UNCACHABLE, 1);
 		if(c->mtrr_reg1< 0)
 		{
 			printk(KERN_INFO "i2o_pci: Error in setting MTRR_TYPE_UNCACHABLE\n");
-			mtrr_del(c->mtrr_reg0, c->mem_phys, size);
+			mtrr_del(c->mtrr_reg0, c->msg_phys, bar1_size);
 			c->mtrr_reg0 = -1;
 		}
 	}
+	if(c->raptor)
+		c->mtrr_reg1 = mtrr_add(c->msg_phys, bar1_size, MTRR_TYPE_WRCOMB, 1);
 
 #endif
 
@@ -3749,7 +3792,9 @@ int __init i2o_pci_install(struct pci_de
 	{
 		printk(KERN_ERR "i2o: Unable to install controller.\n");
 		kfree(c);
-		iounmap((void *)mem);
+		iounmap(bar0_virt);
+		if(c->raptor)
+			iounmap(bar1_virt);
 		return i;
 	}
 
@@ -3764,7 +3809,9 @@ int __init i2o_pci_install(struct pci_de
 				c->name, dev->irq);
 			c->irq = -1;
 			i2o_delete_controller(c);
-			iounmap((void *)mem);
+			iounmap(bar0_virt);
+			if(c->raptor)
+				iounmap(bar1_virt);
 			return -EBUSY;
 		}
 	}
@@ -3797,10 +3844,12 @@ int __init i2o_pci_scan(void)
 
 	while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL)
 	{
-		if((dev->class>>8)!=PCI_CLASS_INTELLIGENT_I2O)
+		if((dev->class>>8)!=PCI_CLASS_INTELLIGENT_I2O &&
+		   (dev->vendor!=PCI_VENDOR_ID_DPT || dev->device!=0xA511))
 			continue;
 
-		if((dev->class&0xFF)>1)
+		if((dev->class>>8)==PCI_CLASS_INTELLIGENT_I2O &&
+		   (dev->class&0xFF)>1)
 		{
 			printk(KERN_INFO "i2o: I2O Controller found but does not support I2O 1.5 (skipping).\n");
 			continue;
diff -puN drivers/message/i2o/i2o_scsi.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers drivers/message/i2o/i2o_scsi.c
--- 25/drivers/message/i2o/i2o_scsi.c~to-get-i2o-working-with-adaptecs-zero-channel-controllers	Fri May 28 16:21:08 2004
+++ 25-akpm/drivers/message/i2o/i2o_scsi.c	Fri May 28 16:21:08 2004
@@ -669,7 +669,7 @@ static int i2o_scsi_queuecommand(struct 
 	if(m==0xFFFFFFFF)
 		return 1;
 
-	msg = (u32 *)(c->mem_offset + m);
+	msg = (u32 *)(c->msg_virt + m);
 	
 	/*
 	 *	Put together a scsi execscb message
@@ -941,7 +941,7 @@ static int i2o_scsi_bus_reset(struct scs
 	struct Scsi_Host *host;
 	struct i2o_scsi_host *hostdata;
 	u32 m;
-	unsigned long msg;
+	void *msg;
 	unsigned long timeout;
 
 	
@@ -979,7 +979,7 @@ static int i2o_scsi_bus_reset(struct scs
 	while(time_before(jiffies, timeout));
 	
 	
-	msg = c->mem_offset + m;
+	msg = c->msg_virt + m;
 	i2o_raw_writel(FOUR_WORD_MSG_SIZE|SGL_OFFSET_0, msg);
 	i2o_raw_writel(I2O_CMD_SCSI_BUSRESET<<24|HOST_TID<<12|tid, msg+4);
 	i2o_raw_writel(scsi_context|0x80000000, msg+8);
diff -puN include/linux/i2o.h~to-get-i2o-working-with-adaptecs-zero-channel-controllers include/linux/i2o.h
--- 25/include/linux/i2o.h~to-get-i2o-working-with-adaptecs-zero-channel-controllers	Fri May 28 16:21:08 2004
+++ 25-akpm/include/linux/i2o.h	Fri May 28 16:21:08 2004
@@ -99,6 +99,7 @@ struct i2o_controller
 	int		irq;
 	int		short_req:1;	/* Use small block sizes        */
 	int		dpt:1;		/* Don't quiesce                */
+	int		raptor:1;	/* split bar                    */
 	int		promise:1;	/* Promise controller		*/
 #ifdef CONFIG_MTRR
 	int		mtrr_reg0;
@@ -109,9 +110,9 @@ struct i2o_controller
 	atomic_t users;
 	struct i2o_device *devices;		/* I2O device chain */
 	struct i2o_controller *next;		/* Controller chain */
-	unsigned long post_port;		/* Inbout port address */
-	unsigned long reply_port;		/* Outbound port address */
-	unsigned long irq_mask;			/* Interrupt register address */
+	void *post_port;			/* Inbout port address */
+	void *reply_port;			/* Outbound port address */
+	void *irq_mask;				/* Interrupt register address */
 
 	/* Dynamic LCT related data */
 	struct semaphore lct_sem;
@@ -128,8 +129,11 @@ struct i2o_controller
 	dma_addr_t hrt_phys;
 	u32 hrt_len;
 
-	unsigned long mem_offset;		/* MFA offset */
-	unsigned long mem_phys;			/* MFA physical */
+	void *base_virt;			/* base virtual address */
+	unsigned long base_phys;		/* base physical address */
+
+	void *msg_virt;				/* messages virtual address */
+	unsigned long msg_phys;			/* messages physical address */
 
 	int battery:1;				/* Has a battery backup */
 	int io_alloc:1;				/* An I/O resource was allocated */
_
