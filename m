From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 14:21:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065475266.17021.75.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:2995 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261773AbTJFVVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 17:21:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch and the two following are an update to the current 
aacraid driver.   I have incorporated updates from Mark Salyzyn's
driver as well as addressing comments from my submittal last month.
In particular, the aac_queue lock is released within
the same function that acquires it.

I have tested this out on the hardware we have at OSDL, 
a 5400S and hp netraid-4m with 1gb, 4gb, and 16gb of memory.


Last time, Christoph suggested converting the driver to be hot
plug compatible.  I'd like to wait until this gets reviewed and 
accepted before looking at that.

 drivers/scsi/aacraid/Makefile   |    2 
 drivers/scsi/aacraid/aachba.c   |  464 +++++++++++++++++++++++++++++++-------
 drivers/scsi/aacraid/aacraid.h  |  239 ++++++++++---------
 drivers/scsi/aacraid/commctrl.c |   85 ++++---
 drivers/scsi/aacraid/comminit.c |   19 +
 drivers/scsi/aacraid/commsup.c  |  479 +++++++++++++++++++++++++++++-----------
 drivers/scsi/aacraid/dpcsup.c   |   54 +++-
 drivers/scsi/aacraid/linit.c    |  113 +++++----
 drivers/scsi/aacraid/rkt.c      |  417 ++++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/rx.c       |    5 
 drivers/scsi/aacraid/sa.c       |    4 
 drivers/scsi/scsi_syms.c        |    1 
 include/scsi/scsi_device.h      |    1 
 13 files changed, 1462 insertions(+), 421 deletions(-)

===== drivers/scsi/scsi_syms.c 1.45 vs edited =====
--- 1.45/drivers/scsi/scsi_syms.c	Thu Jul 31 07:32:18 2003
+++ edited/drivers/scsi/scsi_syms.c	Tue Aug 26 14:44:58 2003
@@ -86,6 +86,7 @@
 EXPORT_SYMBOL(scsi_device_put);
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
+EXPORT_SYMBOL(scsi_rescan_device);
 EXPORT_SYMBOL(scsi_device_cancel);
 
 EXPORT_SYMBOL(__scsi_mode_sense);
===== include/scsi/scsi_device.h 1.8 vs edited =====
--- 1.8/include/scsi/scsi_device.h	Sat Sep 20 07:10:27 2003
+++ edited/include/scsi/scsi_device.h	Mon Sep 29 13:24:48 2003
@@ -106,6 +106,7 @@
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
+extern void scsi_rescan_device(struct device *);
 extern int scsi_device_cancel_cb(struct device *, void *);
 extern int scsi_device_cancel(struct scsi_device *, int);
 
===== drivers/scsi/aacraid/Makefile 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/Makefile	Wed May  7 19:18:41 2003
+++ edited/drivers/scsi/aacraid/Makefile	Tue Sep 30 15:23:50 2003
@@ -3,6 +3,6 @@
 obj-$(CONFIG_SCSI_AACRAID) := aacraid.o
 
 aacraid-objs	:= linit.o aachba.o commctrl.o comminit.o commsup.o \
-		   dpcsup.o rx.o sa.o
+		   dpcsup.o rx.o sa.o rkt.o
 
 EXTRA_CFLAGS	:= -Idrivers/scsi
===== drivers/scsi/aacraid/aachba.c 1.20 vs edited =====
--- 1.20/drivers/scsi/aacraid/aachba.c	Fri May  2 12:30:49 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Tue Sep 30 14:43:40 2003
@@ -50,9 +50,7 @@
 #define	INQD_PDT_DMASK	0x1F	/* Peripheral Device Type Mask */
 #define	INQD_PDT_QMASK	0xE0	/* Peripheral Device Qualifer Mask */
 
-#define	TARGET_LUN_TO_CONTAINER(target, lun)	(target)
-#define CONTAINER_TO_TARGET(cont)		((cont))
-#define CONTAINER_TO_LUN(cont)			(0)
+#define	ID_LUN_TO_CONTAINER(id, lun)	(id)
 
 #define MAX_FIB_DATA (sizeof(struct hw_fib) - sizeof(FIB_HEADER))
 
@@ -201,6 +199,18 @@
 static char *aac_get_status_string(u32 status);
 #endif
 
+/*
+ *	Non dasd selection is handled entirely in aachba now
+ */	
+ 
+MODULE_PARM(nondasd, "i");
+MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
+MODULE_PARM(paemode, "i");
+MODULE_PARM_DESC(paemode, "Control whether dma addressing is using PAE. 0=off, 1=on");
+
+static int nondasd = -1;
+static int paemode = -1;
+
 /**
  *	aac_get_containers	-	list containers
  *	@common: adapter to probe
@@ -265,6 +275,98 @@
 	return status;
 }
 
+static void aac_io_done(Scsi_Cmnd * scsicmd)
+{
+	unsigned long cpu_flags;
+	struct Scsi_Host *host = scsicmd->device->host;
+	spin_lock_irqsave(host->host_lock, cpu_flags);
+	scsicmd->scsi_done(scsicmd);
+	spin_unlock_irqrestore(host->host_lock, cpu_flags);
+}
+
+static void __aac_io_done(Scsi_Cmnd * scsicmd)
+{
+	scsicmd->scsi_done(scsicmd);
+}
+
+static void get_container_name_callback(void *context, struct fib * fibptr)
+{
+	struct aac_get_name_resp * get_name_reply;
+	Scsi_Cmnd * scsicmd;
+
+	scsicmd = (Scsi_Cmnd *) context;
+
+	dprintk((KERN_DEBUG "get_container_name_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
+	if (fibptr == NULL)
+		BUG();
+
+	get_name_reply = (struct aac_get_name_resp *) fib_data(fibptr);
+	/* Failure is irrelevant, using default value instead */
+	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
+	 && (get_name_reply->data[0] != '\0')) {
+		char * sp = get_name_reply->data;
+		char * dp = ((struct inquiry_data *)scsicmd->request_buffer)->inqd_pid;
+		int    count = sizeof(((struct aac_get_name_resp *)NULL)->data);
+		do {
+			if ((*sp == '\0') || (count <= 0)) {
+				*dp++ = ' ';
+			} else {
+				*dp++ = *sp++;
+			}
+		} while (--count
+		  > (sizeof(((struct aac_get_name_resp *)NULL)->data)
+		   - sizeof(((struct inquiry_data *)NULL)->inqd_pid)));
+	}
+	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+
+	fib_complete(fibptr);
+	fib_free(fibptr);
+	aac_io_done(scsicmd);
+}
+
+/**
+ *	aac_get_container_name	-	get container name, none blocking.
+ */
+static int aac_get_container_name(Scsi_Cmnd * scsicmd, int cid)
+{
+	int status;
+	struct aac_get_name *dinfo;
+	struct fib * cmd_fibcontext;
+	struct aac_dev * dev;
+
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+
+	if (!(cmd_fibcontext = fib_alloc(dev)))
+		return -ENOMEM;
+
+	fib_init(cmd_fibcontext);
+	dinfo = (struct aac_get_name *) fib_data(cmd_fibcontext);
+
+	dinfo->command = cpu_to_le32(VM_ContainerConfig);
+	dinfo->type = cpu_to_le32(CT_READ_NAME);
+	dinfo->cid = cpu_to_le32(cid);
+	dinfo->count = cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)->data));
+
+	status = fib_send(ContainerCommand, 
+		  cmd_fibcontext, 
+		  sizeof (struct aac_get_name),
+		  FsaNormal, 
+		  0, 1, 
+		  (fib_callback) get_container_name_callback, 
+		  (void *) scsicmd);
+	
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) 
+		return 0;
+		
+	printk(KERN_WARNING "aac_get_container_name: fib_send failed with status: %d.\n", status);
+	fib_complete(cmd_fibcontext);
+	fib_free(cmd_fibcontext);
+	return -1;
+}
+
 /**
  *	probe_container		-	query a logical volume
  *	@dev: device to query
@@ -444,20 +546,6 @@
 	}
 }
 
-static void aac_io_done(Scsi_Cmnd * scsicmd)
-{
-	unsigned long cpu_flags;
-	struct Scsi_Host *host = scsicmd->device->host;
-	spin_lock_irqsave(host->host_lock, cpu_flags);
-	scsicmd->scsi_done(scsicmd);
-	spin_unlock_irqrestore(host->host_lock, cpu_flags);
-}
-
-static void __aac_io_done(Scsi_Cmnd * scsicmd)
-{
-	scsicmd->scsi_done(scsicmd);
-}
-
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
@@ -503,16 +591,37 @@
 			dev->adapter_info.serial[1]);
 
 	dev->nondasd_support = 0;
+	dev->raid_scsi_mode = 0;
 	if(dev->adapter_info.options & AAC_OPT_NONDASD){
-//		dev->nondasd_support = 1;
-// dmb - temporarily disable nondasd
+		dev->nondasd_support = 1;
 	}
-	if(nondasd != -1) {  
-		dev->nondasd_support = (nondasd!=0);
+
+	/*
+	 * If the firmware supports ROMB RAID/SCSI mode and we are currently
+	 * in RAID/SCSI mode, set the flag. For now if in this mode we will
+	 * force nondasd support on. If we decide to allow the non-dasd flag
+	 * additional changes changes will have to be made to support
+	 * RAID/SCSI.  the function aac_scsi_cmd in this module will have to be
+	 * changed to support the new dev->raid_scsi_mode flag instead of
+	 * leaching off of the dev->nondasd_support flag. Also in linit.c the
+	 * function aac_detect will have to be modified where it sets up the
+	 * max number of channels based on the aac->nondasd_support flag only.
+	 */
+	if ((dev->adapter_info.options & AAC_OPT_SCSI_MANAGED)
+		&& (dev->adapter_info.options & AAC_OPT_RAID_SCSI_MODE))
+	{
+		dev->nondasd_support = 1;
+		dev->raid_scsi_mode = 1;
 	}
-	if(dev->nondasd_support != 0){
+	if (dev->raid_scsi_mode != 0)
+		printk(KERN_INFO"%s%d: ROMB RAID/SCSI mode enabled\n",dev->name, dev->id);
+		
+	if (nondasd != -1)
+		dev->nondasd_support = (nondasd!=0);
+
+	if(dev->nondasd_support != 0)
 		printk(KERN_INFO"%s%d: Non-DASD support enabled\n",dev->name, dev->id);
-	}
+
 
 	dev->pae_support = 0;
 	if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
@@ -523,9 +632,27 @@
 		dev->pae_support = (paemode!=0);
 	}
 	if(dev->pae_support != 0) {
-		printk(KERN_INFO"%s%d: 64 Bit PAE enabled\n", dev->name, dev->id);
-		pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFFFFFFFFFULL);
+		if (pci_set_dma_mask(dev->pdev, 
+					(dma_addr_t)0xFFFFFFFFFFFFFFFFULL)) {
+
+			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit PAE disabled\n", 
+				dev->name, dev->id);
+			dev->pae_support = 0;
+		} else {
+			printk(KERN_INFO"%s%d: 64 Bit PAE enabled\n", 
+				dev->name, dev->id);
+		}
+	} else {
+		/* 
+		 * Reset if Quirk 31 was used, since data 
+		 * transfers are ok.
+		 */
+		if (pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFULL)) {
+			printk(KERN_INFO"aacraid: Can't reset DMA mask.\n");
+		}
 	}
+			
+		
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
@@ -545,7 +672,7 @@
 	scsicmd = (Scsi_Cmnd *) context;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	cid =TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
 
 	lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
 	dprintk((KERN_DEBUG "read_callback[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), lba, jiffies));
@@ -559,7 +686,7 @@
 			scsicmd->use_sg,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
 				 scsicmd->request_bufflen,
 				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
@@ -573,6 +700,10 @@
 				    SENCODE_INTERNAL_TARGET_FAILURE,
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 				    0, 0);
+		memcpy(scsicmd->sense_buffer, &sense_data[cid],
+		  (sizeof(sense_data[cid]) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(sense_data[cid]));
 	}
 	fib_complete(fibptr);
 	fib_free(fibptr);
@@ -590,7 +721,7 @@
 
 	scsicmd = (Scsi_Cmnd *) context;
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	cid = TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
 
 	lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
 	dprintk((KERN_DEBUG "write_callback[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), lba, jiffies));
@@ -603,7 +734,7 @@
 			scsicmd->use_sg,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
 				 scsicmd->request_bufflen,
 				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 
@@ -618,6 +749,10 @@
 				    SENCODE_INTERNAL_TARGET_FAILURE,
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 				    0, 0);
+		memcpy(scsicmd->sense_buffer, &sense_data[cid],
+		  (sizeof(sense_data[cid]) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(sense_data[cid]));
 	}
 
 	fib_complete(fibptr);
@@ -659,9 +794,7 @@
 	 *	Alocate and initialize a Fib
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
-		scsicmd->result = DID_ERROR << 16;
-		aac_io_done(scsicmd);
-		return (-1);
+		return -1;
 	}
 
 	fib_init(cmd_fibcontext);
@@ -726,11 +859,6 @@
 		return 0;
 		
 	printk(KERN_WARNING "aac_read: fib_send failed with status: %d.\n", status);
-	/*
-	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
-	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	aac_io_done(scsicmd);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
 	return -1;
@@ -765,13 +893,11 @@
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
-		scsicmd->result = DID_ERROR << 16;
-		aac_io_done(scsicmd);
 		return -1;
 	}
 	fib_init(cmd_fibcontext);
 
-	if(dev->pae_support == 1){
+	if(dev->pae_support == 1) {
 		struct aac_write64 *writecmd;
 		writecmd = (struct aac_write64 *) fib_data(cmd_fibcontext);
 		writecmd->command = cpu_to_le32(VM_CtHostWrite64);
@@ -832,18 +958,116 @@
 		return 0;
 
 	printk(KERN_WARNING "aac_write: fib_send failed with status: %d\n", status);
+
+	fib_complete(cmd_fibcontext);
+	fib_free(cmd_fibcontext);
+	return -1;
+}
+
+static void synchronize_callback(void *context, struct fib * fibptr)
+{
+	struct aac_synchronize_reply * synchronizereply;
+	Scsi_Cmnd * scsicmd;
+
+	scsicmd = (Scsi_Cmnd *) context;
+
+	dprintk((KERN_DEBUG "synchronize_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
+	if (fibptr == NULL)
+		BUG();
+
+
+	synchronizereply = (struct aac_synchronize_reply *) fib_data(fibptr);
+	if (le32_to_cpu(synchronizereply->status) == CT_OK) {
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+	} else {
+		u32 cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+		printk(KERN_WARNING "synchronize_callback: synchronize failed, status = %d\n", synchronizereply->status);
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		set_sense((u8 *) &sense_data[cid],
+				    SENKEY_HW_ERR,
+				    SENCODE_INTERNAL_TARGET_FAILURE,
+				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
+				    0, 0);
+		memcpy(scsicmd->sense_buffer, &sense_data[cid],
+		  (sizeof(sense_data[cid]) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(sense_data[cid]));
+	}
+
+	fib_complete(fibptr);
+	fib_free(fibptr);
+	aac_io_done(scsicmd);
+}
+
+static int aac_synchronize(Scsi_Cmnd * scsicmd, int cid)
+{
+	int status;
+	struct fib * cmd_fibcontext;
+	struct aac_synchronize * synchronizecmd;
+
 	/*
-	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
+	 * Wait for all commands to complete to this specific
+	 * target (block).
 	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	aac_io_done(scsicmd);
+	Scsi_Cmnd * cmd;
+	Scsi_Device * device = scsicmd->device;
+	int active = 0;
+	unsigned long flags;
+	spin_lock_irqsave(&device->list_lock, flags);
+	list_for_each_entry(cmd, &device->cmd_list, list) {
+		if ((cmd != scsicmd) && (cmd->serial_number != 0)) {
+			++active;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device->list_lock, flags);
+	if (active) {
+		/*
+		 *	Yield the processor (requeue for later)
+		 */
+		return -1;
+	}
+
+	dprintk((KERN_DEBUG "aac_synchronize[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
+	/*
+	 *	Alocate and initialize a Fib
+	 */
+	if (!(cmd_fibcontext = fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) {
+		return -1;
+	}
+
+	fib_init(cmd_fibcontext);
+
+	synchronizecmd = (struct aac_synchronize *) fib_data(cmd_fibcontext);
+	synchronizecmd->command = cpu_to_le32(VM_ContainerConfig);
+	synchronizecmd->type = cpu_to_le32(CT_FLUSH_CACHE);
+	synchronizecmd->cid = cpu_to_le32(cid);
+	synchronizecmd->count = cpu_to_le32(sizeof(((struct aac_synchronize_reply *)NULL)->data));
+
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	status = fib_send(ContainerCommand,
+		  cmd_fibcontext,
+		  sizeof(struct aac_synchronize),
+		  FsaNormal,
+		  0, 1,
+		  (fib_callback) synchronize_callback,
+		  (void *) scsicmd);
+
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) {
+		return 0;
+	}
 
+	printk(KERN_WARNING "aac_synchronize: fib_send failed with status: %d.\n", status);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
 	return -1;
 }
 
-
 /**
  *	aac_scsi_cmd()		-	Process SCSI command
  *	@scsicmd:		SCSI command block
@@ -858,7 +1082,6 @@
 	u32 cid = 0;
 	struct fsa_scsi_hba *fsa_dev_ptr;
 	int cardtype;
-	int ret;
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	
@@ -873,18 +1096,18 @@
 	 */
 	if (scsicmd->device->id != host->this_id) {
 		if ((scsicmd->device->channel == 0) ){
-			if( (scsicmd->device->id >= AAC_MAX_TARGET) || (scsicmd->device->lun != 0)){ 
+			if( (scsicmd->device->id >= MAXIMUM_NUM_CONTAINERS) || (scsicmd->device->lun != 0)){ 
 				scsicmd->result = DID_NO_CONNECT << 16;
 				__aac_io_done(scsicmd);
 				return 0;
 			}
-			cid = TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+			cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
 
 			/*
 			 *	If the target container doesn't exist, it may have
 			 *	been newly created
 			 */
-			if (fsa_dev_ptr->valid[cid] == 0) {
+			if ((fsa_dev_ptr->valid[cid] & 1) == 0) {
 				switch (scsicmd->cmnd[0]) {
 				case INQUIRY:
 				case READ_CAPACITY:
@@ -908,7 +1131,7 @@
 			if (fsa_dev_ptr->valid[cid] == 0) {
 				scsicmd->result = DID_BAD_TARGET << 16;
 				__aac_io_done(scsicmd);
-				return -1;
+				return 0;
 			}
 		} else {  /* check for physical non-dasd devices */
 			if(dev->nondasd_support == 1){
@@ -932,8 +1155,12 @@
 			    SENKEY_ILLEGAL,
 			    SENCODE_INVALID_COMMAND,
 			    ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
+		memcpy(scsicmd->sense_buffer, &sense_data[cid],
+		  (sizeof(sense_data[cid]) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(sense_data[cid]));
 		__aac_io_done(scsicmd);
-		return -1;
+		return 0;
 	}
 
 
@@ -948,7 +1175,6 @@
 		memset(inq_data_ptr, 0, sizeof (struct inquiry_data));
 
 		inq_data_ptr->inqd_ver = 2;	/* claim compliance to SCSI-2 */
-		inq_data_ptr->inqd_dtq = 0x80;	/* set RMB bit to one indicating that the medium is removable */
 		inq_data_ptr->inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
 		inq_data_ptr->inqd_len = 31;
 		/*Format for "pad2" is  RelAdr | WBus32 | WBus16 |  Sync  | Linked |Reserved| CmdQue | SftRe */
@@ -957,14 +1183,16 @@
 		 *	Set the Vendor, Product, and Revision Level
 		 *	see: <vendor>.c i.e. aac.c
 		 */
-		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr->type[cid]);
-		if (scsicmd->device->id == host->this_id)
+		if (scsicmd->device->id == host->this_id) {
+			setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), (sizeof(container_types)/sizeof(char *)));
 			inq_data_ptr->inqd_pdt = INQD_PDT_PROC;	/* Processor device */
-		else
-			inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
-		return 0;
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+			__aac_io_done(scsicmd);
+			return 0;
+		}
+		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr->type[cid]);
+		inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
+		return aac_get_container_name(scsicmd, cid);
 	}
 	case READ_CAPACITY:
 	{
@@ -1031,7 +1259,7 @@
 		memset(&sense_data[cid], 0, sizeof (struct sense_data));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
-		return (0);
+		return 0;
 
 	case ALLOW_MEDIUM_REMOVAL:
 		dprintk((KERN_DEBUG "LOCK command.\n"));
@@ -1055,7 +1283,7 @@
 	case START_STOP:
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
-		return (0);
+		return 0;
 	}
 
 	switch (scsicmd->cmnd[0]) 
@@ -1068,22 +1296,23 @@
 			 *	containers to /dev/sd device names
 			 */
 			 
-			spin_unlock_irq(host->host_lock);
 			if  (scsicmd->request->rq_disk)
-				memcpy(fsa_dev_ptr->devname[cid],
-					scsicmd->request->rq_disk->disk_name,
-					8);
-
-			ret = aac_read(scsicmd, cid);
-			spin_lock_irq(host->host_lock);
-			return ret;
+				strlcpy(fsa_dev_ptr->devname[cid],
+					  scsicmd->request->rq_disk->disk_name,
+					  min(
+					    sizeof(fsa_dev_ptr->devname[cid]),
+					    sizeof(scsicmd->request->rq_disk->disk_name) + 1));
+
+			return aac_read(scsicmd, cid);
 
 		case WRITE_6:
 		case WRITE_10:
-			spin_unlock_irq(host->host_lock);
-			ret = aac_write(scsicmd, cid);
-			spin_lock_irq(host->host_lock);
-			return ret;
+			return aac_write(scsicmd, cid);
+
+		case SYNCHRONIZE_CACHE:
+			/* Issue FIB to tell Firmware to flush it's cache */
+			return aac_synchronize(scsicmd, cid);
+
 		default:
 			/*
 			 *	Unhandled commands
@@ -1093,11 +1322,35 @@
 			set_sense((u8 *) &sense_data[cid],
 				SENKEY_ILLEGAL, SENCODE_INVALID_COMMAND,
 			ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
+			memcpy(scsicmd->sense_buffer, &sense_data[cid],
+			  (sizeof(sense_data[cid]) > sizeof(scsicmd->sense_buffer))
+			    ? sizeof(scsicmd->sense_buffer)
+			    : sizeof(sense_data[cid]));
 			__aac_io_done(scsicmd);
-			return -1;
+			return 0;
+	}
+}
+
+static int busy_disk(struct aac_dev * dev, int cid)
+{
+	if ((dev != (struct aac_dev *)NULL)
+	 && (dev->scsi_host_ptr != (struct Scsi_Host *)NULL)) {
+		struct scsi_device *device;
+
+		list_for_each_entry(device, &dev->scsi_host_ptr->my_devices, siblings)
+		{
+			if ((device->channel == CONTAINER_CHANNEL)
+			 && (device->id == cid)
+			 && (device->lun == CONTAINER_LUN)
+			 && (atomic_read(&device->access_count) != 0)) {
+				return 1;
+			}
+		}
 	}
+	return 0;
 }
 
+
 static int query_disk(struct aac_dev *dev, void *arg)
 {
 	struct aac_query_disk qd;
@@ -1107,20 +1360,20 @@
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
-		qd.cnum = TARGET_LUN_TO_CONTAINER(qd.target, qd.lun);
-	else if ((qd.bus == -1) && (qd.target == -1) && (qd.lun == -1)) 
+		qd.cnum = ID_LUN_TO_CONTAINER(qd.id, qd.lun);
+	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) 
 	{
 		if (qd.cnum < 0 || qd.cnum >= MAXIMUM_NUM_CONTAINERS)
 			return -EINVAL;
 		qd.instance = dev->scsi_host_ptr->host_no;
-		qd.bus = 0;
-		qd.target = CONTAINER_TO_TARGET(qd.cnum);
-		qd.lun = CONTAINER_TO_LUN(qd.cnum);
+		qd.bus = CONTAINER_CHANNEL;
+		qd.id = qd.cnum;
+		qd.lun = CONTAINER_LUN;
 	}
 	else return -EINVAL;
 
 	qd.valid = fsa_dev_ptr->valid[qd.cnum];
-	qd.locked = fsa_dev_ptr->locked[qd.cnum];
+	qd.locked = fsa_dev_ptr->locked[qd.cnum] || busy_disk(dev, qd.cnum);
 	qd.deleted = fsa_dev_ptr->deleted[qd.cnum];
 
 	if (fsa_dev_ptr->devname[qd.cnum][0] == '\0')
@@ -1128,7 +1381,8 @@
 	else
 		qd.unmapped = 0;
 
-	strlcpy(qd.name, fsa_dev_ptr->devname[qd.cnum], sizeof(qd.name));
+	strlcpy(qd.name, fsa_dev_ptr->devname[qd.cnum],
+			min(sizeof(qd.name), sizeof(fsa_dev_ptr->devname[qd.cnum]) + 1));
 
 	if (copy_to_user(arg, &qd, sizeof (struct aac_query_disk)))
 		return -EFAULT;
@@ -1173,7 +1427,7 @@
 	/*
 	 *	If the container is locked, it can not be deleted by the API.
 	 */
-	if (fsa_dev_ptr->locked[dd.cnum])
+	if (fsa_dev_ptr->locked[dd.cnum] || busy_disk(dev, dd.cnum))
 		return -EBUSY;
 	else {
 		/*
@@ -1185,6 +1439,26 @@
 	}
 }
 
+static int aac_register_fib_send(struct aac_dev *dev, void *arg)
+{
+	fib_send_t callback;
+
+	if (arg == NULL) {
+		return -EINVAL;
+	}
+	callback = *((fib_send_t *)arg);
+	*((fib_send_t *)arg) = aac_fib_send;
+	if (callback == (fib_send_t)NULL) {
+		fib_send = aac_fib_send;
+		return 0;
+	}
+	if (fib_send != aac_fib_send) {
+		return -EBUSY;
+	}
+	fib_send = callback;
+	return 0;
+}
+
 int aac_dev_ioctl(struct aac_dev *dev, int cmd, void *arg)
 {
 	switch (cmd) {
@@ -1196,6 +1470,8 @@
 		return force_delete_disk(dev, arg);
 	case 2131:
 		return aac_get_containers(dev);
+	case FSACTL_REGISTER_FIB_SEND:
+		return aac_register_fib_send(dev, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -1235,7 +1511,7 @@
 			scsicmd->use_sg,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (ulong)scsicmd->SCp.ptr, scsicmd->request_bufflen,
+		pci_unmap_single(dev->pdev, (unsigned long)scsicmd->SCp.ptr, scsicmd->request_bufflen,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 
 	/*
@@ -1270,6 +1546,12 @@
 			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER 
 					|| (b==TYPE_DISK && (b1&0x80)) ){
 				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if((dev->raid_scsi_mode) && (scsicmd->device->channel == 2)) {
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
 			}
@@ -1303,6 +1585,12 @@
 			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER
 					|| (b==TYPE_DISK && (b1&0x80)) ){
 				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if((dev->raid_scsi_mode) && (scsicmd->device->channel == 2)){
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
 			}
@@ -1434,8 +1722,6 @@
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
-		scsicmd->result = DID_ERROR << 16;
-		__aac_io_done(scsicmd);
 		return -1;
 	}
 	fib_init(cmd_fibcontext);
@@ -1443,7 +1729,7 @@
 	srbcmd = (struct aac_srb*) fib_data(cmd_fibcontext);
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
 	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scsicmd->device->channel));
-	srbcmd->target   = cpu_to_le32(scsicmd->device->id);
+	srbcmd->id	 = cpu_to_le32(scsicmd->device->id);
 	srbcmd->lun      = cpu_to_le32(scsicmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
 	timeout = (scsicmd->timeout-jiffies)/HZ;
@@ -1463,7 +1749,8 @@
 		/*
 		 *	Build Scatter/Gather list
 		 */
-		fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry64));
+		fibsize = sizeof (struct aac_srb) - sizeof (struct sgentry) + 
+			((srbcmd->sg.count & 0xff) * sizeof (struct sgentry64));
 
 		/*
 		 *	Now send the Fib to the adapter
@@ -1495,11 +1782,6 @@
 	}
 
 	printk(KERN_WARNING "aac_srb: fib_send failed with status: %d\n", status);
-	/*
-	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
-	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	__aac_io_done(scsicmd);
 
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
===== drivers/scsi/aacraid/aacraid.h 1.8 vs edited =====
--- 1.8/drivers/scsi/aacraid/aacraid.h	Thu Aug 21 00:06:52 2003
+++ edited/drivers/scsi/aacraid/aacraid.h	Fri Oct  3 14:25:44 2003
@@ -4,28 +4,30 @@
 /*------------------------------------------------------------------------------
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
-#define MAXIMUM_NUM_CONTAINERS	31
+#ifndef AAC_DRIVER_BUILD
+#define AAC_DRIVER_BUILD 9999
+#endif
+#define MAXIMUM_NUM_CONTAINERS	32
 #define MAXIMUM_NUM_ADAPTERS	8
 
 #define AAC_NUM_FIB	578
 //#define AAC_NUM_IO_FIB	512
 #define AAC_NUM_IO_FIB	100
 
-#define AAC_MAX_TARGET (MAXIMUM_NUM_CONTAINERS+1)
 #define AAC_MAX_LUN	(8)
 
+#define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
+
 /*
  * These macros convert from physical channels to virtual channels
  */
 #define CONTAINER_CHANNEL	(0)
+#define CONTAINER_LUN		(0)
 #define aac_phys_to_logical(x)  (x+1)
 #define aac_logical_to_phys(x)  (x?x-1:0)
 
 #define AAC_DETAILED_STATUS_INFO
 
-extern int nondasd;
-extern int paemode;
-
 struct diskparm
 {
 	int heads;
@@ -239,92 +241,6 @@
 };
 
 /*
- * Implement our own version of these so we have 64 bit compatability
- * The adapter uses these and can only handle 32 bit addresses
- */
-
-struct aac_list_head {
-	u32 next;
-	u32 prev;
-};
-
-#define AAC_INIT_LIST_HEAD(ptr) do { \
-	(ptr)->next = (u32)(ulong)(ptr); \
-	(ptr)->prev = (u32)(ulong)(ptr); \
-} while (0)
-/**
- * aac_list_empty - tests whether a list is empty
- * @head: the list to test.
- */
-static __inline__ int aac_list_empty(struct aac_list_head *head)
-{
-	return head->next == ((u32)(ulong)head);
-}
-
-/*
- * Insert a new entry between two known consecutive entries. 
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static __inline__ void aac_list_add(struct aac_list_head * n,
-	struct aac_list_head * prev,
-	struct aac_list_head * next)
-{
-	next->prev = (u32)(ulong)n;
-	n->next = (u32)(ulong)next;
-	n->prev = (u32)(ulong)prev;
-	prev->next = (u32)(ulong)n;
-}
-
-/**
- * list_add_tail - add a new entry
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- */
-static __inline__ void aac_list_add_tail(struct aac_list_head *n, struct aac_list_head *head)
-{
-	aac_list_add(n, (struct aac_list_head*)(ulong)(head->prev), head);
-}
-
-/*
- * Delete a list entry by making the prev/next entries
- * point to each other.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static __inline__ void __aac_list_del(struct aac_list_head * p,
-				  struct aac_list_head * n)
-{
-	n->prev = (u32)(ulong)p;
-	p->next = (u32)(ulong)n;
-}
-
-/**
- * aac_list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is in an undefined state.
- */
-static __inline__ void aac_list_del(struct aac_list_head *entry)
-{
-	__aac_list_del((struct aac_list_head*)(ulong)entry->prev,(struct aac_list_head*)(ulong) entry->next);
-	entry->next = entry->prev = 0;
-}
-
-/**
- * aac_list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
- */
-#define aac_list_entry(ptr, type, member) \
-	((type *)((char *)(ptr)-(ulong)(&((type *)0)->member)))
-
-/*
  *	Assign type values to the FSA communication data structures
  */
 
@@ -357,12 +273,9 @@
 		    u32 _ReceiverTimeStart; 	// Timestamp for receipt of fib
 		    u32 _ReceiverTimeDone;	// Timestamp for completion of fib
 		} _s;
-		struct aac_list_head _FibLinks;	// Used to link Adapter Initiated Fibs on the host
-//		struct list_head _FibLinks;	// Used to link Adapter Initiated Fibs on the host
 	} _u;
 };
 
-#define FibLinks			_u._FibLinks
 
 #define FIB_DATA_SIZE_IN_BYTES (512 - sizeof(struct aac_fibhdr))
 
@@ -433,9 +346,9 @@
 #define		SendHostTime			705
 #define		LastMiscCommand			706
 
-//
-// Commands that will target the failover level on the FSA adapter
-//
+/*
+ * Commands that will target the failover level on the FSA adapter
+ */
 
 enum fib_xfer_state {
 	HostOwned 			= (1<<0),
@@ -527,6 +440,8 @@
 	char *	vname;
 	char *	model;
 	u16	channels;
+	int	quirks;
+#define	AAC_QUIRK_31BIT		1
 };
 
 /*
@@ -549,13 +464,10 @@
                   /* This is only valid for adapter to host command queues. */ 
 	spinlock_t	 	*lock;		/* Spinlock for this queue must take this lock before accessing the lock */
 	spinlock_t		lockdata;	/* Actual lock (used only on one side of the lock) */
-	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */
-	u32			padding;	/* Padding - FIXME - can remove I believe */
-	struct aac_list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
-//	struct list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
+	struct list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
                                 		        /* only valid for command queues which receive entries from the adapter. */
 	struct list_head	pendingq;		/* A queue of outstanding fib's to the adapter. */
-	u32			numpending;		/* Number of entries on outstanding queue. */
+	unsigned long		numpending;		/* Number of entries on outstanding queue. */
 	struct aac_dev *	dev;			/* Back pointer to adapter structure */
 };
 
@@ -707,6 +619,24 @@
 #define rx_writeb(AEP, CSR, value)	writeb(value, &((AEP)->regs.rx->CSR))
 #define rx_writel(AEP, CSR, value)	writel(value, &((AEP)->regs.rx->CSR))
 
+/*
+ *	Rkt Message Unit Registers (same as Rx, except a larger reserve region)
+ */
+
+#define rkt_mu_registers rx_mu_registers
+#define rkt_inbound rx_inbound
+
+struct rkt_registers {
+	struct rkt_mu_registers		MUnit;			/* 1300h - 1334h */
+	u32				reserved1[1010];	/* 1338h - 22fch */
+	struct rkt_inbound		IndexRegs;		/* 2300h -	 */
+};
+
+#define rkt_readb(AEP, CSR)		readb(&((AEP)->regs.rkt->CSR))
+#define rkt_readl(AEP, CSR)		readl(&((AEP)->regs.rkt->CSR))
+#define rkt_writeb(AEP, CSR, value)	writeb(value, &((AEP)->regs.rkt->CSR))
+#define rkt_writel(AEP, CSR, value)	writel(value, &((AEP)->regs.rkt->CSR))
+
 struct fib;
 
 typedef void (*fib_callback)(void *ctxt, struct fib *fibctx);
@@ -719,7 +649,7 @@
 	struct semaphore 	wait_sem;	// this is used to wait for the next fib to arrive.
 	int			wait;		// Set to true when thread is in WaitForSingleObject
 	unsigned long		count;		// total number of FIBs on FibList
-	struct aac_list_head	hw_fib_list;	// this holds hw_fibs which should be 32 bit addresses
+	struct list_head	fib_list;	// this holds fibs which should be 32 bit addresses
 };
 
 struct fsa_scsi_hba {
@@ -756,6 +686,11 @@
 	 *	Outstanding I/O queue.
 	 */
 	struct list_head	queue;
+	/*
+	 * 	And for the internal issue/reply queues (we may be able
+	 * 	to merge these two)
+	 */
+	struct list_head	fiblink;
 
 	void 			*data;
 	struct hw_fib		*hw_fib;		/* Actual shared object */
@@ -824,6 +759,9 @@
 #define AAC_OPT_SGMAP_HOST64	cpu_to_le32(1<<10)
 #define AAC_OPT_ALARM		cpu_to_le32(1<<11)
 #define AAC_OPT_NONDASD		cpu_to_le32(1<<12)
+#define AAC_OPT_SCSI_MANAGED   	cpu_to_le32(1<<13)
+#define AAC_OPT_RAID_SCSI_MODE	cpu_to_le32(1<<14)
+#define AAC_OPT_SUPPLEMENT_ADAPTER_INFO	cpu_to_le32(1<<15)
 
 struct aac_dev
 {
@@ -837,11 +775,10 @@
 	 */	
 	dma_addr_t		hw_fib_pa;
 	struct hw_fib		*hw_fib_va;
-	ulong			fib_base_va;
+	struct hw_fib		*aif_base_va;
 	/*
 	 *	Fib Headers
 	 */
-// dmb	struct fib              fibs[AAC_NUM_FIB]; /* Doing it here takes up too much from the scsi pool*/
 	struct fib              *fibs;
 
 	struct fib		*free_fib;
@@ -862,7 +799,6 @@
 	unsigned long		fsrev;		/* Main driver's revision number */
 	
 	struct aac_init		*init;		/* Holds initialization info to communicate with adapter */
-//	void *			init_pa; 	/* Holds physical address of the init struct */
 	dma_addr_t		init_pa; 	/* Holds physical address of the init struct */
 	
 	struct pci_dev		*pdev;		/* Our PCI interface */
@@ -873,7 +809,7 @@
 
 	struct Scsi_Host	*scsi_host_ptr;
 	struct fsa_scsi_hba	fsa_dev;
-	int			thread_pid;
+	pid_t			thread_pid;
 	int			cardtype;
 	
 	/*
@@ -883,19 +819,27 @@
 	{
 		struct sa_registers *sa;
 		struct rx_registers *rx;
+		struct rkt_registers *rkt;
 	} regs;
 	/*
 	 *	The following is the number of the individual adapter
 	 */
 	u32			devnum;
+	/*
+	 * 	AIF thread states.
+	 */
 	u32			aif_thread;
 	struct completion	aif_completion;
 	struct aac_adapter_info adapter_info;
+	u32			DeviceContainerID;
+	u32			DeviceConfigWaitingOn;
+	int			DeviceConfigNeeded;
 	/* These are in adapter info but they are in the io flow so
 	 * lets break them out so we don't have to do an AND to check them
 	 */
 	u8			nondasd_support; 
 	u8			pae_support;
+	u8			raid_scsi_mode;
 };
 
 #define AllocateAndMapFibSpace(dev, MapFibContext) \
@@ -1077,11 +1021,35 @@
 	u32		committed;
 };
 
+#define CT_FLUSH_CACHE 129
+struct aac_synchronize {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_FLUSH_CACHE */
+	u32		cid;
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		count;	/* sizeof(((struct aac_synchronize_reply *)NULL)->data) */
+};
+
+struct aac_synchronize_reply {
+	u32		dummy0;
+	u32		dummy1;
+	u32		status;	/*  CT_OK */
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		parm5;
+	u8		data[16];
+};
+
 struct aac_srb
 {
 	u32		function;
 	u32		channel;
-	u32		target;
+	u32		id;
 	u32		lun;
 	u32		timeout;
 	u32		flags;
@@ -1257,6 +1225,31 @@
 	struct aac_mntent mnt[1];
 };
 
+#define CT_READ_NAME 130
+struct aac_get_name {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_READ_NAME */
+	u32		cid;
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		count;	/* sizeof(((struct aac_get_name_resp *)NULL)->data) */
+};
+
+#define CT_OK        218
+struct aac_get_name_resp {
+	u32		dummy0;
+	u32		dummy1;
+	u32		status;	/* CT_OK */
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		parm5;
+	u8		data[16];
+};
+
 /*
  * The following command is sent to shut down each container.
  */
@@ -1270,7 +1263,7 @@
 {
 	s32	cnum;
 	s32	bus;
-	s32	target;
+	s32	id;
 	s32	lun;
 	u32	valid;
 	u32	locked;
@@ -1329,6 +1322,7 @@
 #define FSACTL_MINIPORT_REV_CHECK               CTL_CODE(2107, METHOD_BUFFERED)
 #define FSACTL_GET_PCI_INFO               	CTL_CODE(2119, METHOD_BUFFERED)
 #define FSACTL_FORCE_DELETE_DISK		CTL_CODE(2120, METHOD_NEITHER)
+#define FSACTL_REGISTER_FIB_SEND		CTL_CODE(2136, METHOD_BUFFERED)
 
 
 struct aac_common
@@ -1442,6 +1436,24 @@
 #define		AifReqAPIJobFinish	110	/* Finish a job from the API */
 
 /*
+ * Event notification
+ */
+/* General Notifications */
+#define		AifEnConfigChange	3	/* Adapter config change occurred */
+#define		AifEnContainerChange	4	/* Container configuration change */
+#define		AifEnFailoverChange	11	/* Failover space assignment changed */
+#define		AifEnEnclosureManagement 13	/* Enclosure management event */
+#define 	AifEnAddContainer	15	/* A new container was created */
+#define 	AifEnDeleteContainer	16	/* A container was deleted */
+/* Host driver notifications */
+#define		AifDenMorphComplete	200	/* A morph operation completed */
+#define		AifDenVolumeExtendComplete 201  /* A volume expand operation completed */
+
+
+#define		AifJobCtrZero		101	/* Array Zero progress */
+#define		AifJobStsSuccess	1	/* Job completes successfully */
+
+/*
  *	Adapter Initiated FIB command structures. Start with the adapter
  *	initiated FIBs that really come from the adapter, and get responded
  *	to by the host.
@@ -1472,7 +1484,13 @@
 void fib_init(struct fib * context);
 void fib_dealloc(struct fib * context);
 void aac_printf(struct aac_dev *dev, u32 val);
-int fib_send(u16 command, struct fib * context, unsigned long size, int priority, int wait, int reply, fib_callback callback, void *ctxt);
+typedef int (*fib_send_t)(u16 command, struct fib * context, 
+		unsigned long size, int priority, int wait, 
+		int reply, fib_callback callback, void *ctxt);
+extern fib_send_t fib_send;
+int aac_fib_send(u16 command, struct fib * context, unsigned long size, 
+		int priority, int wait, int reply, fib_callback callback, 
+		void *ctxt);
 int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entry **entry);
 int aac_consumer_avail(struct aac_dev * dev, struct aac_queue * q);
 void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
@@ -1485,6 +1503,7 @@
 int aac_dev_ioctl(struct aac_dev *dev, int cmd, void *arg);
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void *arg);
 int aac_rx_init(struct aac_dev *dev, unsigned long devNumber);
+int aac_rkt_init(struct aac_dev *dev, unsigned long devNumber);
 int aac_sa_init(struct aac_dev *dev, unsigned long devNumber);
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);

-- 
Mark Haverkamp <markh@osdl.org>

