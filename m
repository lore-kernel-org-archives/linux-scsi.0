From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH 3/4] dpt_i2o: 64 bit support
Date: Fri, 2 May 2008 01:07:27 +0200
Message-ID: <20080501230724.GA19844@xs4all.net>
References: <20080501230211.GA19796@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3313 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbYEAXHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 19:07:35 -0400
Received: from n2o.xs4all.nl (n2o.xs4all.nl [194.109.0.112])
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id m41N7SDe085212
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 01:07:33 +0200 (CEST)
	(envelope-from miquels@cistron.nl)
Received: from mikevs by n2o.xs4all.nl with local (Exim 4.69)
	(envelope-from <miquels@cistron.nl>)
	id 1Jrhs7-0005AD-UJ
	for linux-scsi@vger.kernel.org; Fri, 02 May 2008 01:07:27 +0200
Content-Disposition: inline
In-Reply-To: <20080501230211.GA19796@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[PATCH 3/4] dpt_i2o: 64 bit support

This is the code to actually support 64 bit platforms. 64 bit
DMA is enabled on both x86_32 PAE and 64 bit platforms.

This code is based in part on the unofficial adaptec 64-bit
dpt_i2o driver update that I got from Mark Salyzyn at Adaptec.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

diff -ruN linux-2.6.25/drivers/scsi/Kconfig ../linux-2.6.25-dpt64-02/drivers/scsi/Kconfig
--- linux-2.6.25/drivers/scsi/Kconfig	2008-05-01 17:00:19.000000000 +0200
+++ ../linux-2.6.25-dpt64-02/drivers/scsi/Kconfig	2008-04-18 23:09:44.000000000 +0200
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
diff -ruN linux-2.6.25/drivers/scsi/dpt/dpti_ioctl.h ../linux-2.6.25-dpt64-02/drivers/scsi/dpt/dpti_ioctl.h
--- linux-2.6.25/drivers/scsi/dpt/dpti_ioctl.h	2008-04-17 04:49:44.000000000 +0200
+++ ../linux-2.6.25-dpt64-02/drivers/scsi/dpt/dpti_ioctl.h	2008-05-01 15:59:40.000000000 +0200
@@ -89,7 +89,7 @@
 	int      njobs;            /* # of jobs sent to HA            */
 	int      qdepth;           /* Controller queue depth.         */
 	int      wakebase;         /* mpx wakeup base index.          */
-	uLONG    SGsize;           /* Scatter/Gather list size.       */
+	uINT     SGsize;           /* Scatter/Gather list size.       */
 	unsigned heads;            /* heads for drives on cntlr.      */
 	unsigned sectors;          /* sectors for drives on cntlr.    */
 	uCHAR    do_drive32;       /* Flag for Above 16 MB Ability    */
@@ -97,8 +97,8 @@
 	char     idPAL[4];         /* 4 Bytes Of The ID Pal           */
 	uCHAR    primary;          /* 1 For Primary, 0 For Secondary  */
 	uCHAR    eataVersion;      /* EATA Version                    */
-	uLONG    cpLength;         /* EATA Command Packet Length      */
-	uLONG    spLength;         /* EATA Status Packet Length       */
+	uINT     cpLength;         /* EATA Command Packet Length      */
+	uINT     spLength;         /* EATA Status Packet Length       */
 	uCHAR    drqNum;           /* DRQ Index (0,5,6,7)             */
 	uCHAR    flag1;            /* EATA Flags 1 (Byte 9)           */
 	uCHAR    flag2;            /* EATA Flags 2 (Byte 30)          */
@@ -107,23 +107,23 @@
 typedef struct {
 	uSHORT length;		// Remaining length of this
 	uSHORT drvrHBAnum;	// Relative HBA # used by the driver
-	uLONG baseAddr;		// Base I/O address
+	uINT baseAddr;		// Base I/O address
 	uSHORT blinkState;	// Blink LED state (0=Not in blink LED)
 	uCHAR pciBusNum;	// PCI Bus # (Optional)
 	uCHAR pciDeviceNum;	// PCI Device # (Optional)
 	uSHORT hbaFlags;	// Miscellaneous HBA flags
 	uSHORT Interrupt;	// Interrupt set for this device.
 #   if (defined(_DPT_ARC))
-	uLONG baseLength;
+	uINT baseLength;
 	ADAPTER_OBJECT *AdapterObject;
 	LARGE_INTEGER DmaLogicalAddress;
 	PVOID DmaVirtualAddress;
 	LARGE_INTEGER ReplyLogicalAddress;
 	PVOID ReplyVirtualAddress;
 #   else
-	uLONG reserved1;	// Reserved for future expansion
-	uLONG reserved2;	// Reserved for future expansion
-	uLONG reserved3;	// Reserved for future expansion
+	uINT reserved1;		// Reserved for future expansion
+	uINT reserved2;		// Reserved for future expansion
+	uINT reserved3;		// Reserved for future expansion
 #   endif
 } drvrHBAinfo_S;
 
diff -ruN linux-2.6.25/drivers/scsi/dpt/dptsig.h ../linux-2.6.25-dpt64-02/drivers/scsi/dpt/dptsig.h
--- linux-2.6.25/drivers/scsi/dpt/dptsig.h	2008-04-17 04:49:44.000000000 +0200
+++ ../linux-2.6.25-dpt64-02/drivers/scsi/dpt/dptsig.h	2008-05-01 14:39:25.000000000 +0200
@@ -33,11 +33,7 @@
 /* to make sure we are talking the same size under all OS's     */
 typedef unsigned char sigBYTE;
 typedef unsigned short sigWORD;
-#if (defined(_MULTI_DATAMODEL) && defined(sun) && !defined(_ILP32))
-typedef uint32_t sigLONG;
-#else
-typedef unsigned long sigLONG;
-#endif
+typedef unsigned int sigINT;
 
 /*
  * use sigWORDLittleEndian for:
@@ -300,7 +296,7 @@
     sigBYTE dsFiletype;          /* type of file */
     sigBYTE dsFiletypeFlags;     /* flags to specify load type, etc. */
     sigBYTE dsOEM;               /* OEM file was created for */
-    sigLONG dsOS;                /* which Operating systems */
+    sigINT  dsOS;                /* which Operating systems */
     sigWORD dsCapabilities;      /* RAID levels, etc. */
     sigWORD dsDeviceSupp;        /* Types of SCSI devices supported */
     sigWORD dsAdapterSupp;       /* DPT adapter families supported */
diff -ruN linux-2.6.25/drivers/scsi/dpt/sys_info.h ../linux-2.6.25-dpt64-02/drivers/scsi/dpt/sys_info.h
--- linux-2.6.25/drivers/scsi/dpt/sys_info.h	2008-04-17 04:49:44.000000000 +0200
+++ ../linux-2.6.25-dpt64-02/drivers/scsi/dpt/sys_info.h	2008-05-01 15:16:26.000000000 +0200
@@ -145,8 +145,8 @@
    uCHAR        smartROMRevision;
    uSHORT       flags;                  /* See bit definitions above */
    uSHORT       conventionalMemSize;    /* in KB */
-   uLONG        extendedMemSize;        /* in KB */
-   uLONG        osType;                 /* Same as DPTSIG's definition */
+   uINT         extendedMemSize;        /* in KB */
+   uINT         osType;                 /* Same as DPTSIG's definition */
    uCHAR        osMajorVersion;
    uCHAR        osMinorVersion;         /* The OS version */
    uCHAR        osRevision;
diff -ruN linux-2.6.25/drivers/scsi/dpt_i2o.c ../linux-2.6.25-dpt64-02/drivers/scsi/dpt_i2o.c
--- linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-05-01 23:34:03.000000000 +0200
+++ ../linux-2.6.25-dpt64-02/drivers/scsi/dpt_i2o.c	2008-05-01 16:38:58.000000000 +0200
@@ -111,10 +116,17 @@
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
+	.release	= adpt_close,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= compat_adpt_ioctl,
+#endif
 };
 
 /* Structures and definitions for synchronous message posting.
@@ -138,6 +150,11 @@
  *============================================================================
  */
 
+static inline int dpt_dma64(adpt_hba *pHba)
+{
+	return (sizeof(dma_addr_t) > 4 && (pHba)->dma64);
+}
+
 static inline u32 dma_high(dma_addr_t addr)
 {
 	return upper_32_bits(addr);
@@ -277,7 +294,7 @@
 
 static void adpt_inquiry(adpt_hba* pHba)
 {
-	u32 msg[14]; 
+	u32 msg[17]; 
 	u32 *mptr;
 	u32 *lenptr;
 	int direction;
@@ -301,7 +318,10 @@
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
@@ -334,8 +354,16 @@
 
 	/* Now fill in the SGList and command */
 	*lenptr = len;
-	*mptr++ = 0xD0000000|direction|len;
-	*mptr++ = addr;
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
@@ -628,6 +656,92 @@
 	return len;
 }
 
+/*
+ *	Turn a struct scsi_cmnd * into a unique 32 bit 'context'.
+ */
+static u32 adpt_cmd_to_context(struct scsi_cmnd *cmd)
+{
+	return (u32)cmd->serial_number;
+}
+
+/*
+ *	Go from a u32 'context' to a struct scsi_cmnd * .
+ *	This could probably be made more efficient.
+ */
+static struct scsi_cmnd *
+	adpt_cmd_from_context(adpt_hba * pHba, u32 context)
+{
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
+	nr = ARRAY_SIZE(pHba->ioctl_reply_context);
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
+
 /*===========================================================================
  * Error Handling routines
  *===========================================================================
@@ -655,7 +769,7 @@
 	msg[1] = I2O_CMD_SCSI_ABORT<<24|HOST_TID<<12|dptdevice->tid;
 	msg[2] = 0;
 	msg[3]= 0; 
-	msg[4] = (u32)cmd;
+	msg[4] = adpt_cmd_to_context(cmd);
 	if (pHba->host)
 		spin_lock_irq(pHba->host->host_lock);
 	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
@@ -867,6 +981,7 @@
 	u32 hba_map1_area_size = 0;
 	void __iomem *base_addr_virt = NULL;
 	void __iomem *msg_addr_virt = NULL;
+	int dma64 = 0;
 
 	int raptorFlag = FALSE;
 
@@ -880,7 +995,16 @@
 	}
 
 	pci_set_master(pDev);
-	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
+
+	/*
+	 *	See if we should enable dma64 mode.
+	 */
+	if (sizeof(dma_addr_t) > 4 &&
+	    pci_set_dma_mask(pDev, DMA_64BIT_MASK) == 0) {
+		if (dma_get_required_mask(&pDev->dev) > DMA_32BIT_MASK)
+			dma64 = 1;
+	}
+	if (!dma64 && pci_set_dma_mask(pDev, DMA_32BIT_MASK) != 0)
 		return -EINVAL;
 
 	/* adapter only supports message blocks below 4GB */
@@ -906,6 +1030,25 @@
 		raptorFlag = TRUE;
 	}
 
+#if BITS_PER_LONG == 64
+	/*
+	 *	The original Adaptec 64 bit driver has this comment here:
+	 *	"x86_64 machines need more optimal mappings"
+	 *
+	 *	I assume some HBAs report ridiculously large mappings
+	 *	and we need to limit them on platforms with IOMMUs.
+	 */
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
@@ -968,16 +1111,22 @@
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
@@ -1030,6 +1179,8 @@
 	if(pHba->msg_addr_virt != pHba->base_addr_virt){
 		iounmap(pHba->msg_addr_virt);
 	}
+	if(pHba->FwDebugBuffer_P)
+	   	iounmap(pHba->FwDebugBuffer_P);
 	if(pHba->hrt) {
 		dma_free_coherent(&pHba->pDev->dev,
 			pHba->hrt->num_entries * pHba->hrt->entry_len << 2,
@@ -1657,10 +1808,13 @@
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
-		// TODO 64bit fix
+		// TODO add 64 bit API
 		struct sg_simple_element *sg =  (struct sg_simple_element*) (msg+sg_offset);
 		sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
 		if (sg_count > pHba->sg_tablesize){
@@ -1689,15 +1843,15 @@
 			sg_list[sg_index++] = p; // sglist indexed with input frame, not our internal frame.
 			/* Copy in the user's SG buffer if necessary */
 			if(sg[i].flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR*/) {
-				// TODO 64bit fix
-				if (copy_from_user(p,(void __user *)sg[i].addr_bus, sg_size)) {
+				// sg_simple_element API is 32 bit
+				if (copy_from_user(p,(void __user *)(ulong)sg[i].addr_bus, sg_size)) {
 					printk(KERN_DEBUG"%s: Could not copy SG buf %d FROM user\n",pHba->name,i);
 					rcode = -EFAULT;
 					goto cleanup;
 				}
 			}
-			//TODO 64bit fix
-			sg[i].addr_bus = (u32)virt_to_bus(p);
+			/* sg_simple_element API is 32 bit, but addr < 4GB */
+			sg[i].addr_bus = addr;
 		}
 	}
 
@@ -1725,7 +1879,7 @@
 	if(sg_offset) {
 	/* Copy back the Scatter Gather buffers back to user space */
 		u32 j;
-		// TODO 64bit fix
+		// TODO add 64 bit API
 		struct sg_simple_element* sg;
 		int sg_size;
 
@@ -1745,14 +1899,14 @@
 		}
 		sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
 
-		// TODO 64bit fix
+		// TODO add 64 bit API
 		sg 	 = (struct sg_simple_element*)(msg + sg_offset);
 		for (j = 0; j < sg_count; j++) {
 			/* Copy out the SG list to user's buffer if necessary */
 			if(! (sg[j].flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR*/)) {
 				sg_size = sg[j].flag_count & 0xffffff; 
-				// TODO 64bit fix
-				if (copy_to_user((void __user *)sg[j].addr_bus,sg_list[j], sg_size)) {
+				// sg_simple_element API is 32 bit
+				if (copy_to_user((void __user *)(ulong)sg[j].addr_bus,sg_list[j], sg_size)) {
 					printk(KERN_WARNING"%s: Could not copy %p TO user %x\n",pHba->name, sg_list[j], sg[j].addr_bus);
 					rcode = -EFAULT;
 					goto cleanup;
@@ -1972,6 +2126,38 @@
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
@@ -2032,7 +2218,7 @@
 		} 
 		context = readl(reply+8);
 		if(context & 0x40000000){ // IOCTL
-			void *p = (void *)readl(reply+12);
+			void *p = adpt_ioctl_from_context(pHba, readl(reply+12));
 			if( p != NULL) {
 				memcpy_fromio(p, reply, REPLY_FRAME_SIZE * 4);
 			}
@@ -2046,14 +2232,15 @@
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
 				scsi_dma_unmap(cmd);
 				if(cmd->serial_number != 0) { // If not timedout
@@ -2076,6 +2263,7 @@
 	int i;
 	u32 msg[MAX_MESSAGE_SIZE];
 	u32* mptr;
+	u32* lptr;
 	u32 *lenptr;
 	int direction;
 	int scsidir;
@@ -2083,6 +2271,7 @@
 	u32 len;
 	u32 reqlen;
 	s32 rcode;
+	dma_addr_t addr;
 
 	memset(msg, 0 , sizeof(msg));
 	len = scsi_bufflen(cmd);
@@ -2122,7 +2311,7 @@
 	// I2O_CMD_SCSI_EXEC
 	msg[1] = ((0xff<<24)|(HOST_TID<<12)|d->tid);
 	msg[2] = 0;
-	msg[3] = (u32)cmd;	/* We want the SCSI control block back */
+	msg[3] = adpt_cmd_to_context(cmd);  /* Want SCSI control block back */
 	// Our cards use the transaction context as the tag for queueing
 	// Adaptec/DPT Private stuff 
 	msg[4] = I2O_CMD_SCSI_EXEC|(DPT_ORGANIZATION_ID<<16);
@@ -2140,7 +2329,13 @@
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
@@ -2150,12 +2345,16 @@
 
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
@@ -2824,7 +3023,17 @@
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
@@ -2916,13 +3125,19 @@
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
diff -ruN linux-2.6.25/drivers/scsi/dpti.h ../linux-2.6.25-dpt64-02/drivers/scsi/dpti.h
--- linux-2.6.25/drivers/scsi/dpti.h	2008-05-01 23:34:03.000000000 +0200
+++ ../linux-2.6.25-dpt64-02/drivers/scsi/dpti.h	2008-04-24 22:36:29.000000000 +0200
@@ -233,6 +233,7 @@
 	u8  top_scsi_channel;
 	u8  top_scsi_id;
 	u8  top_scsi_lun;
+	u8  dma64;
 
 	i2o_status_block* status_block;
 	dma_addr_t status_block_pa;
@@ -252,6 +253,7 @@
 	void __iomem *FwDebugBLEDflag_P;// Virtual Addr Of FW Debug BLED
 	void __iomem *FwDebugBLEDvalue_P;// Virtual Addr Of FW Debug BLED
 	u32 FwDebugFlags;
+	u32 *ioctl_reply_context[4];
 } adpt_hba;
 
 struct sg_simple_element {
