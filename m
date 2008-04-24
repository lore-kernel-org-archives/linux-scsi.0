From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH 1/2] dpt_i2o: 64 bit support (take 4)
Date: Thu, 24 Apr 2008 23:33:59 +0200
Message-ID: <20080424213355.GA21682@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4432 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYDXVeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 17:34:10 -0400
Received: from n2o.xs4all.nl (n2o.xs4all.nl [194.109.0.112])
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id m3OLXxYA025898
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 23:34:08 +0200 (CEST)
	(envelope-from miquels@cistron.nl)
Received: from mikevs by n2o.xs4all.nl with local (Exim 4.67)
	(envelope-from <miquels@cistron.nl>)
	id 1Jp94p-0005dv-AG
	for linux-scsi@vger.kernel.org; Thu, 24 Apr 2008 23:33:59 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've taken out the ifdef __linux__ code that was added, and
I removed the unused reboot_notifier code.

As before, 1/2 is the 64 bit code, 2/2 is the sysfs code.

# -----

This patch is an update for drivers/scsi/dpt_i2o.c.
It applies to both 2.6.24.4 and 2.6.25

It contains the following changes:

* 64 bit code based on unofficial Adaptec 64 bit driver
* removes scsi_module.c dependency, adds module_init / module_exit
  this is needed because we need to pass the proper device to
  scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
  code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
  because the dev pointer it is passed is NULL.
* adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
  can create /dev/dptiX dynamically

Obviously there are more cleanups that can be done to this code,
but we need to start somewhere. Patch has been tested heavily on
both 32 and 64 bit x86 platforms.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

diff -ruN orig/linux-2.6.25/drivers/scsi/Kconfig linux-2.6.25/drivers/scsi/Kconfig
--- orig/linux-2.6.25/drivers/scsi/Kconfig	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/scsi/Kconfig	2008-04-18 23:09:44.000000000 +0200
@@ -504,10 +504,9 @@
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
 
-# All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on !64BIT && SCSI && PCI && VIRT_TO_BUS
+	depends on SCSI && PCI && VIRT_TO_BUS
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
diff -ruN orig/linux-2.6.25/drivers/scsi/dpt/dptsig.h linux-2.6.25/drivers/scsi/dpt/dptsig.h
--- orig/linux-2.6.25/drivers/scsi/dpt/dptsig.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/scsi/dpt/dptsig.h	2008-04-24 22:32:35.000000000 +0200
@@ -30,14 +30,9 @@
 /* DPT SIGNATURE SPEC AND HEADER FILE                           */
 /* Signature Version 1 (sorry no 'A')                           */
 
-/* to make sure we are talking the same size under all OS's     */
 typedef unsigned char sigBYTE;
 typedef unsigned short sigWORD;
-#if (defined(_MULTI_DATAMODEL) && defined(sun) && !defined(_ILP32))
-typedef uint32_t sigLONG;
-#else
-typedef unsigned long sigLONG;
-#endif
+typedef unsigned int sigLONG;
 
 /*
  * use sigWORDLittleEndian for:
diff -ruN orig/linux-2.6.25/drivers/scsi/dpt/osd_util.h linux-2.6.25/drivers/scsi/dpt/osd_util.h
--- orig/linux-2.6.25/drivers/scsi/dpt/osd_util.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/scsi/dpt/osd_util.h	2008-04-24 22:34:31.000000000 +0200
@@ -185,7 +185,7 @@
    typedef unsigned char   uCHAR;
    typedef unsigned short  uSHORT;
    typedef unsigned int    uINT;
-   typedef unsigned long   uLONG;
+   typedef unsigned int    uLONG;
 
    typedef union {
 	 uCHAR        u8[4];
diff -ruN orig/linux-2.6.25/drivers/scsi/dpt_i2o.c linux-2.6.25/drivers/scsi/dpt_i2o.c
--- orig/linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-24 22:30:29.000000000 +0200
@@ -108,27 +108,26 @@
 
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
 
+#ifdef CONFIG_COMPAT
+static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
+#endif
+
 static const struct file_operations adpt_fops = {
 	.ioctl		= adpt_ioctl,
 	.open		= adpt_open,
-	.release	= adpt_close
-};
-
-#ifdef REBOOT_NOTIFIER
-static struct notifier_block adpt_reboot_notifier =
-{
-	 adpt_reboot_event,
-	 NULL,
-	 0
-};
+	.release	= adpt_close,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= compat_adpt_ioctl,
 #endif
+};
 
 /* Structures and definitions for synchronous message posting.
  * See adpt_i2o_post_wait() for description
@@ -151,6 +150,21 @@
  *============================================================================
  */
 
+static inline int dpt_dma64(adpt_hba *pHba)
+{
+	return (sizeof(dma_addr_t) > 4 && (pHba)->dma64);
+}
+
+static inline u32 dma_high(dma_addr_t addr)
+{
+	return (u32) ((u64)addr >> 32);
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
@@ -178,8 +192,6 @@
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
 
-	adpt_init();
-
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
@@ -248,7 +260,7 @@
 	}
 
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if( adpt_scsi_register(pHba,sht) < 0){
+		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
@@ -282,7 +294,7 @@
 
 static void adpt_inquiry(adpt_hba* pHba)
 {
-	u32 msg[14]; 
+	u32 msg[17]; 
 	u32 *mptr;
 	u32 *lenptr;
 	int direction;
@@ -290,11 +302,12 @@
 	u32 len;
 	u32 reqlen;
 	u8* buf;
+	dma_addr_t addr;
 	u8  scb[16];
 	s32 rcode;
 
 	memset(msg, 0, sizeof(msg));
-	buf = kmalloc(80,GFP_KERNEL|ADDR32);
+	buf = pci_alloc_consistent(pHba->pDev, 80, &addr);
 	if(!buf){
 		printk(KERN_ERR"%s: Could not allocate buffer\n",pHba->name);
 		return;
@@ -305,7 +318,10 @@
 	direction = 0x00000000;	
 	scsidir  =0x40000000;	// DATA IN  (iop<--dev)
 
-	reqlen = 14;		// SINGLE SGE
+	if (dpt_dma64(pHba))
+		reqlen = 17;		// SINGLE SGE, 64 bit
+	else
+		reqlen = 14;		// SINGLE SGE, 32 bit
 	/* Stick the headers on */
 	msg[0] = reqlen<<16 | SGL_OFFSET_12;
 	msg[1] = (0xff<<24|HOST_TID<<12|ADAPTER_TID);
@@ -338,8 +354,16 @@
 
 	/* Now fill in the SGList and command */
 	*lenptr = len;
-	*mptr++ = 0xD0000000|direction|len;
-	*mptr++ = virt_to_bus(buf);
+	if (dpt_dma64(pHba)) {
+		*mptr++ = (0x7C<<24)+(2<<16)+0x02; /* Enable 64 bit */
+		*mptr++ = 1 << PAGE_SHIFT;
+		*mptr++ = 0xD0000000|direction|len;
+		*mptr++ = dma_low(addr);
+		*mptr++ = dma_high(addr);
+	} else {
+		*mptr++ = 0xD0000000|direction|len;
+		*mptr++ = addr;
+	}
 
 	// Send it on it's way
 	rcode = adpt_i2o_post_wait(pHba, msg, reqlen<<2, 120);
@@ -347,7 +371,7 @@
 		sprintf(pHba->detail, "Adaptec I2O RAID");
 		printk(KERN_INFO "%s: Inquiry Error (%d)\n",pHba->name,rcode);
 		if (rcode != -ETIME && rcode != -EINTR)
-			kfree(buf);
+			pci_free_consistent(pHba->pDev, 80, buf, addr);
 	} else {
 		memset(pHba->detail, 0, sizeof(pHba->detail));
 		memcpy(&(pHba->detail), "Vendor: Adaptec ", 16);
@@ -356,7 +380,7 @@
 		memcpy(&(pHba->detail[40]), " FW: ", 4);
 		memcpy(&(pHba->detail[44]), (u8*) &buf[32], 4);
 		pHba->detail[48] = '\0';	/* precautionary */
-		kfree(buf);
+		pci_free_consistent(pHba->pDev, 80, buf, addr);
 	}
 	adpt_i2o_status_get(pHba);
 	return ;
@@ -632,6 +656,100 @@
 	return len;
 }
 
+/*
+ *	Turn a struct scsi_cmnd * into a unique 32 bit 'context'.
+ */
+static u32 adpt_cmd_to_context(struct scsi_cmnd *cmd)
+{
+#if BITS_PER_LONG == 32
+	return (u32)(unsigned long)cmd;
+#else
+	return (u32)cmd->serial_number;
+#endif
+}
+
+/*
+ *	Go from a u32 'context' to a struct scsi_cmnd * .
+ *	This could probably be made more efficient.
+ */
+static struct scsi_cmnd *
+	adpt_cmd_from_context(adpt_hba * pHba, u32 context)
+{
+#if BITS_PER_LONG == 32
+	return (struct scsi_cmnd*)(unsigned long)context;
+#else
+	struct scsi_cmnd * cmd;
+	struct scsi_device * d;
+
+	if (context == 0)
+		return NULL;
+
+	spin_unlock(pHba->host->host_lock);
+	shost_for_each_device(d, pHba->host) {
+		unsigned long flags;
+		spin_lock_irqsave(&d->list_lock, flags);
+		list_for_each_entry(cmd, &d->cmd_list, list) {
+			if (((u32)cmd->serial_number == context)) {
+				spin_unlock_irqrestore(&d->list_lock, flags);
+				scsi_device_put(d);
+				spin_lock(pHba->host->host_lock);
+				return cmd;
+			}
+		}
+		spin_unlock_irqrestore(&d->list_lock, flags);
+	}
+	spin_lock(pHba->host->host_lock);
+
+	return NULL;
+#endif
+}
+
+/*
+ *	Turn a pointer to ioctl reply data into an u32 'context'
+ */
+static u32 adpt_ioctl_to_context(adpt_hba * pHba, void *reply)
+{
+#if BITS_PER_LONG == 32
+	return (u32)(unsigned long)reply;
+#else
+	ulong flags = 0;
+	u32 nr, i;
+
+	spin_lock_irqsave(pHba->host->host_lock, flags);
+	nr =  sizeof(pHba->ioctl_reply_context) /
+		sizeof(pHba->ioctl_reply_context[0]);
+	for (i = 0; i < nr; i++) {
+		if (pHba->ioctl_reply_context[i] == NULL) {
+			pHba->ioctl_reply_context[i] = reply;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(pHba->host->host_lock, flags);
+	if (i >= nr) {
+		kfree (reply);
+		printk(KERN_WARNING"%s: Too many outstanding "
+				"ioctl commands\n", pHba->name);
+		return (u32)-1;
+	}
+
+	return i;
+#endif
+}
+
+/*
+ *	Go from an u32 'context' to a pointer to ioctl reply data.
+ */
+static void *adpt_ioctl_from_context(adpt_hba *pHba, u32 context)
+{
+#if BITS_PER_LONG == 32
+	return (void *)(unsigned long)context;
+#else
+	void *p = pHba->ioctl_reply_context[context];
+	pHba->ioctl_reply_context[context] = NULL;
+
+	return p;
+#endif
+}
 
 /*===========================================================================
  * Error Handling routines
@@ -660,7 +778,7 @@
 	msg[1] = I2O_CMD_SCSI_ABORT<<24|HOST_TID<<12|dptdevice->tid;
 	msg[2] = 0;
 	msg[3]= 0; 
-	msg[4] = (u32)cmd;
+	msg[4] = adpt_cmd_to_context(cmd);
 	if (pHba->host)
 		spin_lock_irq(pHba->host->host_lock);
 	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
@@ -861,27 +979,6 @@
 	 printk(KERN_INFO "Adaptec I2O controllers down.\n");
 }
 
-/*
- * reboot/shutdown notification.
- *
- * - Quiesce each IOP in the system
- *
- */
-
-#ifdef REBOOT_NOTIFIER
-static int adpt_reboot_event(struct notifier_block *n, ulong code, void *p)
-{
-
-	 if(code != SYS_RESTART && code != SYS_HALT && code != SYS_POWER_OFF)
-		  return NOTIFY_DONE;
-
-	 adpt_i2o_sys_shutdown();
-
-	 return NOTIFY_DONE;
-}
-#endif
-
-
 static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
 {
 
@@ -893,6 +990,7 @@
 	u32 hba_map1_area_size = 0;
 	void __iomem *base_addr_virt = NULL;
 	void __iomem *msg_addr_virt = NULL;
+	int dma64 = 0;
 
 	int raptorFlag = FALSE;
 
@@ -906,8 +1004,20 @@
 	}
 
 	pci_set_master(pDev);
-	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
-		return -EINVAL;
+	/*
+	 *	Only try to enable DMA 64 bit mode mode if the dma_addr_t
+	 *	type can hold 64 bit addresses.
+	 */
+	if (sizeof(dma_addr_t) == 8 &&
+	    pci_set_dma_mask(pDev, DMA_64BIT_MASK) == 0) {
+		dma64 = 1;
+	} else {
+		if (pci_set_dma_mask(pDev, DMA_32BIT_MASK) != 0)
+			return -EINVAL;
+	}
+
+	/* Make sure pci_alloc_consistent returns 32 bit addresses */
+	pci_set_consistent_dma_mask(pDev, DMA_32BIT_MASK);
 
 	base_addr0_phys = pci_resource_start(pDev,0);
 	hba_map0_area_size = pci_resource_len(pDev,0);
@@ -929,6 +1039,19 @@
 		raptorFlag = TRUE;
 	}
 
+#if BITS_PER_LONG == 64
+	/* x86_64 machines need more optimal mappings */
+	if (raptorFlag == TRUE) {
+		if (hba_map0_area_size > 128)
+			hba_map0_area_size = 128;
+		if (hba_map1_area_size > 524288)
+			hba_map1_area_size = 524288;
+	} else {
+		if (hba_map0_area_size > 524288)
+			hba_map0_area_size = 524288;
+	}
+#endif
+
 	base_addr_virt = ioremap(base_addr0_phys,hba_map0_area_size);
 	if (!base_addr_virt) {
 		pci_release_regions(pDev);
@@ -991,16 +1114,22 @@
 	pHba->state = DPTI_STATE_RESET;
 	pHba->pDev = pDev;
 	pHba->devices = NULL;
+	pHba->dma64 = dma64;
 
 	// Initializing the spinlocks
 	spin_lock_init(&pHba->state_lock);
 	spin_lock_init(&adpt_post_wait_lock);
 
 	if(raptorFlag == 0){
-		printk(KERN_INFO"Adaptec I2O RAID controller %d at %p size=%x irq=%d\n", 
-			hba_count-1, base_addr_virt, hba_map0_area_size, pDev->irq);
+		printk(KERN_INFO "Adaptec I2O RAID controller"
+				 " %d at %p size=%x irq=%d%s\n", 
+			hba_count-1, base_addr_virt,
+			hba_map0_area_size, pDev->irq,
+			dma64 ? " (64-bit DMA)" : "");
 	} else {
-		printk(KERN_INFO"Adaptec I2O RAID controller %d irq=%d\n",hba_count-1, pDev->irq);
+		printk(KERN_INFO"Adaptec I2O RAID controller %d irq=%d%s\n",
+			hba_count-1, pDev->irq,
+			dma64 ? " (64-bit DMA)" : "");
 		printk(KERN_INFO"     BAR0 %p - size= %x\n",base_addr_virt,hba_map0_area_size);
 		printk(KERN_INFO"     BAR1 %p - size= %x\n",msg_addr_virt,hba_map1_area_size);
 	}
@@ -1053,10 +1182,26 @@
 	if(pHba->msg_addr_virt != pHba->base_addr_virt){
 		iounmap(pHba->msg_addr_virt);
 	}
-	kfree(pHba->hrt);
-	kfree(pHba->lct);
-	kfree(pHba->status_block);
-	kfree(pHba->reply_pool);
+	if(pHba->FwDebugBuffer_P)
+	   	iounmap(pHba->FwDebugBuffer_P);
+	if(pHba->hrt) {
+		pci_free_consistent(pHba->pDev,
+			pHba->hrt->num_entries * pHba->hrt->entry_len << 2,
+			pHba->hrt, pHba->hrt_pa);
+	}
+	if(pHba->lct) {
+		pci_free_consistent(pHba->pDev, pHba->lct_size,
+			pHba->lct, pHba->lct_pa);
+	}
+	if(pHba->status_block) {
+		pci_free_consistent(pHba->pDev, sizeof(i2o_status_block),
+			pHba->status_block, pHba->status_block_pa);
+	}
+	if(pHba->reply_pool) {
+		pci_free_consistent(pHba->pDev,
+			pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+			pHba->reply_pool, pHba->reply_pool_pa);
+	}
 
 	for(d = pHba->devices; d ; d = next){
 		next = d->next;
@@ -1075,23 +1220,10 @@
 	pci_dev_put(pHba->pDev);
 	kfree(pHba);
 
-	if(hba_count <= 0){
+	if(hba_count <= 0)
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
-	}
 }
 
-
-static int adpt_init(void)
-{
-	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
-#ifdef REBOOT_NOTIFIER
-	register_reboot_notifier(&adpt_reboot_notifier);
-#endif
-
-	return 0;
-}
-
-
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
 {
 	struct adpt_device* d;
@@ -1283,6 +1415,7 @@
 {
 	u32 msg[8];
 	u8* status;
+	dma_addr_t addr;
 	u32 m = EMPTY_QUEUE ;
 	ulong timeout = jiffies + (TMOUT_IOPRESET*HZ);
 
@@ -1305,12 +1438,13 @@
 		schedule_timeout_uninterruptible(1);
 	} while (m == EMPTY_QUEUE);
 
-	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	status = pci_alloc_consistent(pHba->pDev, 4, &addr);
 	if(status == NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
+	memset(status,0,4);
 
 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -1318,8 +1452,8 @@
 	msg[3]=0;
 	msg[4]=0;
 	msg[5]=0;
-	msg[6]=virt_to_bus(status);
-	msg[7]=0;     
+	msg[6]=dma_low(addr);
+	msg[7]=dma_high(addr);
 
 	memcpy_toio(pHba->msg_addr_virt+m, msg, sizeof(msg));
 	wmb();
@@ -1329,7 +1463,10 @@
 	while(*status == 0){
 		if(time_after(jiffies,timeout)){
 			printk(KERN_WARNING"%s: IOP Reset Timeout\n",pHba->name);
-			kfree(status);
+			/* We lose 4 bytes of "status" here, but we cannot
+			   free these because controller may awake and corrupt
+			   those bytes at any time */
+			/* pci_free_consistent(pHba->pDev, 4, buf, addr); */
 			return -ETIMEDOUT;
 		}
 		rmb();
@@ -1348,6 +1485,10 @@
 			}
 			if(time_after(jiffies,timeout)){
 				printk(KERN_ERR "%s:Timeout waiting for IOP Reset.\n",pHba->name);
+				/* We lose 4 bytes of "status" here, but we
+				   cannot free these because controller may
+				   awake and corrupt those bytes at any time */
+				/* pci_free_consistent(pHba->pDev, 4, buf, addr); */
 				return -ETIMEDOUT;
 			}
 			schedule_timeout_uninterruptible(1);
@@ -1364,7 +1505,7 @@
 		PDEBUG("%s: Reset completed.\n", pHba->name);
 	}
 
-	kfree(status);
+	pci_free_consistent(pHba->pDev, 4, status, addr);
 #ifdef UARTDELAY
 	// This delay is to allow someone attached to the card through the debug UART to 
 	// set up the dump levels that they want before the rest of the initialization sequence
@@ -1636,6 +1777,7 @@
 	u32 i = 0;
 	u32 rcode = 0;
 	void *p = NULL;
+	dma_addr_t addr;
 	ulong flags = 0;
 
 	memset(&msg, 0, MAX_MESSAGE_SIZE*4);
@@ -1668,7 +1810,10 @@
 	}
 	sg_offset = (msg[0]>>4)&0xf;
 	msg[2] = 0x40000000; // IOCTL context
-	msg[3] = (u32)reply;
+	msg[3] = adpt_ioctl_to_context(pHba, reply);
+	if (msg[3] == (u32)-1)
+		return -EBUSY;
+
 	memset(sg_list,0, sizeof(sg_list[0])*pHba->sg_tablesize);
 	if(sg_offset) {
 		// TODO 64bit fix
@@ -1690,7 +1835,7 @@
 			}
 			sg_size = sg[i].flag_count & 0xffffff;      
 			/* Allocate memory for the transfer */
-			p = kmalloc(sg_size, GFP_KERNEL|ADDR32);
+			p = pci_alloc_consistent(pHba->pDev, sg_size, &addr);
 			if(!p) {
 				printk(KERN_DEBUG"%s: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 						pHba->name,sg_size,i,sg_count);
@@ -1708,7 +1853,7 @@
 				}
 			}
 			//TODO 64bit fix
-			sg[i].addr_bus = (u32)virt_to_bus(p);
+			sg[i].addr_bus = addr;
 		}
 	}
 
@@ -1762,7 +1907,7 @@
 			/* Copy out the SG list to user's buffer if necessary */
 			if(! (sg[j].flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR*/)) {
 				sg_size = sg[j].flag_count & 0xffffff; 
-				// TODO 64bit fix
+				// TODO 64bit fix, mgmt app currently 32 bit
 				if (copy_to_user((void __user *)sg[j].addr_bus,sg_list[j], sg_size)) {
 					printk(KERN_WARNING"%s: Could not copy %p TO user %x\n",pHba->name, sg_list[j], sg[j].addr_bus);
 					rcode = -EFAULT;
@@ -1787,12 +1932,17 @@
 
 
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
+				pci_free_consistent(pHba->pDev,
+					sg[sg_index].flag_count & 0xffffff,
+					sg_list[sg_index],
+					sg[sg_index].addr_bus);
+			}
 		}
 	}
 	return rcode;
@@ -1978,6 +2128,38 @@
 	return error;
 }
 
+#ifdef CONFIG_COMPAT
+static long compat_adpt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode;
+	long ret;
+ 
+	inode = file->f_dentry->d_inode;
+ 
+	lock_kernel();
+ 
+	switch(cmd) {
+		case DPT_SIGNATURE:
+		case I2OUSRCMD:
+		case DPT_CTRLINFO:
+		case DPT_SYSINFO:
+		case DPT_BLINKLED:
+		case I2ORESETCMD:
+		case I2ORESCANCMD:
+		case (DPT_TARGET_BUSY & 0xFFFF):
+		case DPT_TARGET_BUSY:
+			ret = adpt_ioctl(inode, file, cmd, arg);
+			break;
+		default:
+			ret =  -ENOIOCTLCMD;
+	}
+ 
+	unlock_kernel();
+ 
+	return ret;
+}
+#endif
 
 static irqreturn_t adpt_isr(int irq, void *dev_id)
 {
@@ -2009,7 +2191,16 @@
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
@@ -2029,7 +2220,7 @@
 		} 
 		context = readl(reply+8);
 		if(context & 0x40000000){ // IOCTL
-			void *p = (void *)readl(reply+12);
+			void *p = adpt_ioctl_from_context(pHba, readl(reply+12));
 			if( p != NULL) {
 				memcpy_fromio(p, reply, REPLY_FRAME_SIZE * 4);
 			}
@@ -2043,15 +2234,17 @@
 				status = I2O_POST_WAIT_OK;
 			}
 			if(!(context & 0x40000000)) {
-				cmd = (struct scsi_cmnd*) readl(reply+12); 
+				cmd = adpt_cmd_from_context(pHba,
+							readl(reply+12));
 				if(cmd != NULL) {
 					printk(KERN_WARNING"%s: Apparent SCSI cmd in Post Wait Context - cmd=%p context=%x\n", pHba->name, cmd, context);
 				}
 			}
 			adpt_i2o_post_wait_complete(context, status);
 		} else { // SCSI message
-			cmd = (struct scsi_cmnd*) readl(reply+12); 
+			cmd = adpt_cmd_from_context (pHba, readl(reply+12));
 			if(cmd != NULL){
+				scsi_dma_unmap(cmd);
 				if(cmd->serial_number != 0) { // If not timedout
 					adpt_i2o_to_scsi(reply, cmd);
 				}
@@ -2072,6 +2265,7 @@
 	int i;
 	u32 msg[MAX_MESSAGE_SIZE];
 	u32* mptr;
+	u32* lptr;
 	u32 *lenptr;
 	int direction;
 	int scsidir;
@@ -2079,6 +2273,7 @@
 	u32 len;
 	u32 reqlen;
 	s32 rcode;
+	dma_addr_t addr;
 
 	memset(msg, 0 , sizeof(msg));
 	len = scsi_bufflen(cmd);
@@ -2118,7 +2313,7 @@
 	// I2O_CMD_SCSI_EXEC
 	msg[1] = ((0xff<<24)|(HOST_TID<<12)|d->tid);
 	msg[2] = 0;
-	msg[3] = (u32)cmd;	/* We want the SCSI control block back */
+	msg[3] = adpt_cmd_to_context(cmd);  /* Want SCSI control block back */
 	// Our cards use the transaction context as the tag for queueing
 	// Adaptec/DPT Private stuff 
 	msg[4] = I2O_CMD_SCSI_EXEC|(DPT_ORGANIZATION_ID<<16);
@@ -2136,7 +2331,13 @@
 	memcpy(mptr, cmd->cmnd, cmd->cmd_len);
 	mptr+=4;
 	lenptr=mptr++;		/* Remember me - fill in when we know */
-	reqlen = 14;		// SINGLE SGE
+	if (dpt_dma64(pHba)) {
+		reqlen = 16;		// SINGLE SGE
+		*mptr++ = (0x7C<<24)+(2<<16)+0x02; /* Enable 64 bit */
+		*mptr++ = 1 << PAGE_SHIFT;
+	} else {
+		reqlen = 14;		// SINGLE SGE
+	}
 	/* Now fill in the SGList and command */
 
 	nseg = scsi_dma_map(cmd);
@@ -2146,12 +2347,16 @@
 
 		len = 0;
 		scsi_for_each_sg(cmd, sg, nseg, i) {
+			lptr = mptr;
 			*mptr++ = direction|0x10000000|sg_dma_len(sg);
 			len+=sg_dma_len(sg);
-			*mptr++ = sg_dma_address(sg);
+			addr = sg_dma_address(sg);
+			*mptr++ = dma_low(addr);
+			if (dpt_dma64(pHba))
+				*mptr++ = dma_high(addr);
 			/* Make this an end of list */
 			if (i == nseg - 1)
-				mptr[-2] = direction|0xD0000000|sg_dma_len(sg);
+				*lptr = direction|0xD0000000|sg_dma_len(sg);
 		}
 		reqlen = mptr - msg;
 		*lenptr = len;
@@ -2177,13 +2382,13 @@
 }
 
 
-static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
+static s32 adpt_scsi_host_alloc(adpt_hba* pHba, struct scsi_host_template *sht)
 {
-	struct Scsi_Host *host = NULL;
+	struct Scsi_Host *host;
 
-	host = scsi_register(sht, sizeof(adpt_hba*));
+	host = scsi_host_alloc(sht, sizeof(adpt_hba*));
 	if (host == NULL) {
-		printk ("%s: scsi_register returned NULL\n",pHba->name);
+		printk("%s: scsi_host_alloc returned NULL\n", pHba->name);
 		return -1;
 	}
 	host->hostdata[0] = (unsigned long)pHba;
@@ -2200,7 +2405,7 @@
 	host->max_lun = 256;
 	host->max_channel = pHba->top_scsi_channel + 1;
 	host->cmd_per_lun = 1;
-	host->unique_id = (uint) pHba;
+	host->unique_id = (u32)sys_tbl_pa + pHba->unit;
 	host->sg_tablesize = pHba->sg_tablesize;
 	host->can_queue = pHba->post_fifo_size;
 
@@ -2640,11 +2845,10 @@
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
@@ -2663,13 +2867,14 @@
 
 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
-	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	status = pci_alloc_consistent(pHba->pDev, 4, &addr);
 	if (!status) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
+	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2678,7 +2883,7 @@
 	writel(4096, &msg[4]);		/* Host page frame size */
 	writel((REPLY_FRAME_SIZE)<<16|0x80, &msg[5]);	/* Outbound msg frame size and Initcode */
 	writel(0xD0000004, &msg[6]);		/* Simple SG LE, EOB */
-	writel(virt_to_bus(status), &msg[7]);
+	writel((u32)addr, &msg[7]);
 
 	writel(m, pHba->post_port);
 	wmb();
@@ -2693,6 +2898,10 @@
 		rmb();
 		if(time_after(jiffies,timeout)){
 			printk(KERN_WARNING"%s: Timeout Initializing\n",pHba->name);
+			/* We lose 4 bytes of "status" here, but we
+			   cannot free these because controller may
+			   awake and corrupt those bytes at any time */
+			/* pci_free_consistent(pHba->pDev, 4, status, addr); */
 			return -ETIMEDOUT;
 		}
 		schedule_timeout_uninterruptible(1);
@@ -2701,25 +2910,30 @@
 	// If the command was successful, fill the fifo with our reply
 	// message packets
 	if(*status != 0x04 /*I2O_EXEC_OUTBOUND_INIT_COMPLETE*/) {
-		kfree(status);
+		pci_free_consistent(pHba->pDev, 4, status, addr);
 		return -2;
 	}
-	kfree(status);
+	pci_free_consistent(pHba->pDev, 4, status, addr);
 
-	kfree(pHba->reply_pool);
+	if(pHba->reply_pool != NULL) {
+		pci_free_consistent(pHba->pDev,
+			pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+			pHba->reply_pool, pHba->reply_pool_pa);
+	}
 
-	pHba->reply_pool = kzalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
+	pHba->reply_pool = (u32*)pci_alloc_consistent(pHba->pDev,
+				pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+				&pHba->reply_pool_pa);
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
@@ -2743,11 +2957,11 @@
 	u32 m;
 	u32 __iomem *msg;
 	u8 *status_block=NULL;
-	ulong status_block_bus;
 
 	if(pHba->status_block == NULL) {
 		pHba->status_block = (i2o_status_block*)
-			kmalloc(sizeof(i2o_status_block),GFP_KERNEL|ADDR32);
+		    pci_alloc_consistent(pHba->pDev, sizeof(i2o_status_block),
+			&pHba->status_block_pa);
 		if(pHba->status_block == NULL) {
 			printk(KERN_ERR
 			"dpti%d: Get Status Block failed; Out of memory. \n", 
@@ -2757,7 +2971,6 @@
 	}
 	memset(pHba->status_block, 0, sizeof(i2o_status_block));
 	status_block = (u8*)(pHba->status_block);
-	status_block_bus = virt_to_bus(pHba->status_block);
 	timeout = jiffies+TMOUT_GETSTATUS*HZ;
 	do {
 		rmb();
@@ -2782,8 +2995,8 @@
 	writel(0, &msg[3]);
 	writel(0, &msg[4]);
 	writel(0, &msg[5]);
-	writel(((u32)status_block_bus)&0xffffffff, &msg[6]);
-	writel(0, &msg[7]);
+	writel( dma_low(pHba->status_block_pa), &msg[6]);
+	writel( dma_high(pHba->status_block_pa), &msg[7]);
 	writel(sizeof(i2o_status_block), &msg[8]); // 88 bytes
 
 	//post message
@@ -2812,7 +3025,17 @@
 	}
 
 	// Calculate the Scatter Gather list size
-	pHba->sg_tablesize = (pHba->status_block->inbound_frame_size * 4 -40)/ sizeof(struct sg_simple_element);
+	if (dpt_dma64(pHba)) {
+		pHba->sg_tablesize
+		  = ((pHba->status_block->inbound_frame_size * 4
+		  - 14 * sizeof(u32))
+		  / (sizeof(struct sg_simple_element) + sizeof(u32)));
+	} else {
+		pHba->sg_tablesize
+		  = ((pHba->status_block->inbound_frame_size * 4
+		  - 12 * sizeof(u32))
+		  / sizeof(struct sg_simple_element));
+	}
 	if (pHba->sg_tablesize > SG_LIST_ELEMENTS) {
 		pHba->sg_tablesize = SG_LIST_ELEMENTS;
 	}
@@ -2863,7 +3086,8 @@
 	}
 	do {
 		if (pHba->lct == NULL) {
-			pHba->lct = kmalloc(pHba->lct_size, GFP_KERNEL|ADDR32);
+			pHba->lct = pci_alloc_consistent(pHba->pDev,
+					pHba->lct_size, &pHba->lct_pa);
 			if(pHba->lct == NULL) {
 				printk(KERN_CRIT "%s: Lct Get failed. Out of memory.\n",
 					pHba->name);
@@ -2879,7 +3103,7 @@
 		msg[4] = 0xFFFFFFFF;	/* All devices */
 		msg[5] = 0x00000000;	/* Report now */
 		msg[6] = 0xD0000000|pHba->lct_size;
-		msg[7] = virt_to_bus(pHba->lct);
+		msg[7] = (u32)pHba->lct_pa;
 
 		if ((ret=adpt_i2o_post_wait(pHba, msg, sizeof(msg), 360))) {
 			printk(KERN_ERR "%s: LCT Get failed (status=%#10x.\n", 
@@ -2890,7 +3114,8 @@
 
 		if ((pHba->lct->table_size << 2) > pHba->lct_size) {
 			pHba->lct_size = pHba->lct->table_size << 2;
-			kfree(pHba->lct);
+			pci_free_consistent(pHba->pDev, pHba->lct_size,
+					pHba->lct, pHba->lct_pa);
 			pHba->lct = NULL;
 		}
 	} while (pHba->lct == NULL);
@@ -2901,13 +3126,19 @@
 	// I2O_DPT_EXEC_IOP_BUFFERS_GROUP_NO;
 	if(adpt_i2o_query_scalar(pHba, 0 , 0x8000, -1, buf, sizeof(buf))>=0) {
 		pHba->FwDebugBufferSize = buf[1];
-		pHba->FwDebugBuffer_P    = pHba->base_addr_virt + buf[0];
-		pHba->FwDebugFlags_P     = pHba->FwDebugBuffer_P + FW_DEBUG_FLAGS_OFFSET;
-		pHba->FwDebugBLEDvalue_P = pHba->FwDebugBuffer_P + FW_DEBUG_BLED_OFFSET;
-		pHba->FwDebugBLEDflag_P  = pHba->FwDebugBLEDvalue_P + 1;
-		pHba->FwDebugStrLength_P = pHba->FwDebugBuffer_P + FW_DEBUG_STR_LENGTH_OFFSET;
-		pHba->FwDebugBuffer_P += buf[2]; 
-		pHba->FwDebugFlags = 0;
+		pHba->FwDebugBuffer_P = ioremap(pHba->base_addr_phys + buf[0],
+						pHba->FwDebugBufferSize);
+		if (pHba->FwDebugBuffer_P) {
+			pHba->FwDebugFlags_P     = pHba->FwDebugBuffer_P +
+							FW_DEBUG_FLAGS_OFFSET;
+			pHba->FwDebugBLEDvalue_P = pHba->FwDebugBuffer_P +
+							FW_DEBUG_BLED_OFFSET;
+			pHba->FwDebugBLEDflag_P  = pHba->FwDebugBLEDvalue_P + 1;
+			pHba->FwDebugStrLength_P = pHba->FwDebugBuffer_P +
+						FW_DEBUG_STR_LENGTH_OFFSET;
+			pHba->FwDebugBuffer_P += buf[2]; 
+			pHba->FwDebugFlags = 0;
+		}
 	}
 
 	return 0;
@@ -2915,25 +3146,29 @@
 
 static int adpt_i2o_build_sys_table(void)
 {
-	adpt_hba* pHba = NULL;
+	adpt_hba* pHba = hba_chain;
 	int count = 0;
 
+	if (sys_tbl)
+		pci_free_consistent(pHba->pDev, sys_tbl_len,
+					sys_tbl, sys_tbl_pa);
+
 	sys_tbl_len = sizeof(struct i2o_sys_tbl) +	// Header + IOPs
 				(hba_count) * sizeof(struct i2o_sys_tbl_entry);
 
-	kfree(sys_tbl);
-
-	sys_tbl = kzalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
+	sys_tbl = pci_alloc_consistent(pHba->pDev, sys_tbl_len, &sys_tbl_pa);
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
@@ -2949,8 +3184,9 @@
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
@@ -3086,7 +3322,8 @@
 
 	do {
 		if (pHba->hrt == NULL) {
-			pHba->hrt=kmalloc(size, GFP_KERNEL|ADDR32);
+			pHba->hrt = pci_alloc_consistent(pHba->pDev,
+					size, &pHba->hrt_pa);
 			if (pHba->hrt == NULL) {
 				printk(KERN_CRIT "%s: Hrt Get failed; Out of memory.\n", pHba->name);
 				return -ENOMEM;
@@ -3098,7 +3335,7 @@
 		msg[2]= 0;
 		msg[3]= 0;
 		msg[4]= (0xD0000000 | size);    /* Simple transaction */
-		msg[5]= virt_to_bus(pHba->hrt);   /* Dump it here */
+		msg[5]= (u32)pHba->hrt_pa;	/* Dump it here */
 
 		if ((ret = adpt_i2o_post_wait(pHba, msg, sizeof(msg),20))) {
 			printk(KERN_ERR "%s: Unable to get HRT (status=%#10x)\n", pHba->name, ret);
@@ -3106,8 +3343,10 @@
 		}
 
 		if (pHba->hrt->num_entries * pHba->hrt->entry_len << 2 > size) {
-			size = pHba->hrt->num_entries * pHba->hrt->entry_len << 2;
-			kfree(pHba->hrt);
+			int newsize = pHba->hrt->num_entries * pHba->hrt->entry_len << 2;
+			pci_free_consistent(pHba->pDev, size,
+				pHba->hrt, pHba->hrt_pa);
+			size = newsize;
 			pHba->hrt = NULL;
 		}
 	} while(pHba->hrt == NULL);
@@ -3121,33 +3360,53 @@
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
+	resblk_va = pci_alloc_consistent(pHba->pDev, sizeof(u8) * (8 + buflen),
+						&resblk_pa);
+	if (resblk_va == NULL) {
 		printk(KERN_CRIT "%s: query scalar failed; Out of memory.\n", pHba->name);
 		return -ENOMEM;
 	}
 
+	opblk_va = pci_alloc_consistent(pHba->pDev, sizeof(opblk), &opblk_pa);
+	if (opblk_va == NULL) {
+		pci_free_consistent(pHba->pDev, sizeof(u8) * (8+buflen),
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
+	pci_free_consistent(pHba->pDev, sizeof(opblk), opblk_va, opblk_pa);
 	if (size == -ETIME) {
+		pci_free_consistent(pHba->pDev, sizeof(u8) * (8+buflen),
+							resblk_va, resblk_pa);
 		printk(KERN_WARNING "%s: issue params failed; Timed out.\n", pHba->name);
 		return -ETIME;
 	} else if (size == -EINTR) {
+		pci_free_consistent(pHba->pDev, sizeof(u8) * (8+buflen),
+							resblk_va, resblk_pa);
 		printk(KERN_WARNING "%s: issue params failed; Interrupted.\n", pHba->name);
 		return -EINTR;
 	}
 			
-	memcpy(buf, resblk+8, buflen);  /* cut off header */
+	memcpy(buf, resblk_va+8, buflen);  /* cut off header */
 
-	kfree(resblk);
+	pci_free_consistent(pHba->pDev, sizeof(u8) * (8+buflen),
+						resblk_va, resblk_pa);
 	if (size < 0)
 		return size;	
 
@@ -3164,10 +3423,11 @@
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
@@ -3176,12 +3436,12 @@
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
 
@@ -3284,7 +3544,7 @@
 	 * Private i/o space declaration  
 	 */
 	msg[6] = 0x54000000 | sys_tbl_len;
-	msg[7] = virt_to_phys(sys_tbl);
+	msg[7] = (u32)sys_tbl_pa;
 	msg[8] = 0x54000000 | 0;
 	msg[9] = 0;
 	msg[10] = 0xD4000000 | 0;
@@ -3323,11 +3583,10 @@
 #endif
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
-	.detect			= adpt_detect,
-	.release		= adpt_release,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
@@ -3341,5 +3600,48 @@
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-#include "scsi_module.c"
+
+static int __init adpt_init(void)
+{
+	int		error;
+	adpt_hba	*pHba, *next;
+
+	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+
+	error = adpt_detect(&driver_template);
+	if (error < 0)
+		return error;
+	if (hba_chain == NULL)
+		return -ENODEV;
+
+	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+		error = scsi_add_host(pHba->host, &pHba->pDev->dev);
+		if (error)
+			goto fail;
+		scsi_scan_host(pHba->host);
+	}
+	return 0;
+fail:
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
+		scsi_remove_host(pHba->host);
+	}
+	return error;
+}
+
+static void __exit adpt_exit(void)
+{
+	adpt_hba	*pHba, *next;
+
+	for (pHba = hba_chain; pHba; pHba = pHba->next)
+		scsi_remove_host(pHba->host);
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
+		adpt_release(pHba->host);
+	}
+}
+
+module_init(adpt_init);
+module_exit(adpt_exit);
+
 MODULE_LICENSE("GPL");
diff -ruN orig/linux-2.6.25/drivers/scsi/dpti.h linux-2.6.25/drivers/scsi/dpti.h
--- orig/linux-2.6.25/drivers/scsi/dpti.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/scsi/dpti.h	2008-04-24 22:36:29.000000000 +0200
@@ -84,7 +84,6 @@
 #define PCI_DPT_DEVICE_ID         (0xA501)	// DPT PCI I2O Device ID
 #define PCI_DPT_RAPTOR_DEVICE_ID  (0xA511)	
 
-//#define REBOOT_NOTIFIER 1
 /* Debugging macro from Linux Device Drivers - Rubini */
 #undef PDEBUG
 #ifdef DEBUG
@@ -229,14 +228,19 @@
 	u32  post_fifo_size;
 	u32  reply_fifo_size;
 	u32* reply_pool;
+	dma_addr_t reply_pool_pa;
 	u32  sg_tablesize;	// Scatter/Gather List Size.       
 	u8  top_scsi_channel;
 	u8  top_scsi_id;
 	u8  top_scsi_lun;
+	u8  dma64;
 
 	i2o_status_block* status_block;
+	dma_addr_t status_block_pa;
 	i2o_hrt* hrt;
+	dma_addr_t hrt_pa;
 	i2o_lct* lct;
+	dma_addr_t lct_pa;
 	uint lct_size;
 	struct i2o_device* devices;
 	struct adpt_channel channel[MAX_CHANNEL];
@@ -249,6 +253,7 @@
 	void __iomem *FwDebugBLEDflag_P;// Virtual Addr Of FW Debug BLED
 	void __iomem *FwDebugBLEDvalue_P;// Virtual Addr Of FW Debug BLED
 	u32 FwDebugFlags;
+	u32 *ioctl_reply_context[4];
 } adpt_hba;
 
 struct sg_simple_element {
@@ -264,9 +269,6 @@
 static int adpt_init(void);
 static int adpt_i2o_build_sys_table(void);
 static irqreturn_t adpt_isr(int irq, void *dev_id);
-#ifdef REBOOT_NOTIFIER
-static int adpt_reboot_event(struct notifier_block *n, ulong code, void *p);
-#endif
 
 static void adpt_i2o_report_hba_unit(adpt_hba* pHba, struct i2o_device *d);
 static int adpt_i2o_query_scalar(adpt_hba* pHba, int tid, 
@@ -275,7 +277,8 @@
 static const char *adpt_i2o_get_class_name(int class);
 #endif
 static int adpt_i2o_issue_params(int cmd, adpt_hba* pHba, int tid, 
-		  void *opblk, int oplen, void *resblk, int reslen);
+		  void *opblk, dma_addr_t opblk_pa, int oplen,
+		  void *resblk, dma_addr_t resblk_pa, int reslen);
 static int adpt_i2o_post_wait(adpt_hba* pHba, u32* msg, int len, int timeout);
 static int adpt_i2o_lct_get(adpt_hba* pHba);
 static int adpt_i2o_parse_lct(adpt_hba* pHba);
@@ -289,7 +292,7 @@
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
+static s32 adpt_scsi_host_alloc(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);

