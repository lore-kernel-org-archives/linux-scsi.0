From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 14:21:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065475285.17021.79.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:6835 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261783AbTJFVV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 17:21:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

===== drivers/scsi/aacraid/dpcsup.c 1.4 vs edited =====
--- 1.4/drivers/scsi/aacraid/dpcsup.c	Fri May  2 12:31:00 2003
+++ edited/drivers/scsi/aacraid/dpcsup.c	Wed Oct  1 15:26:48 2003
@@ -73,11 +73,12 @@
 	 */
 	while(aac_consumer_get(dev, q, &entry))
 	{
-		u32 fast ;
-		fast = (entry->addr & cpu_to_le32(0x01));
-		hwfib = (struct hw_fib *)((char *)dev->hw_fib_va + 
-				((entry->addr & ~0x01) - dev->hw_fib_pa));
-		fib = &dev->fibs[hwfib->header.SenderData];
+		int fast;
+		u32 index;
+		index = le32_to_cpu(entry->addr);
+		fast = index & 0x01;
+		fib = &dev->fibs[index >> 1];
+		hwfib = fib->hw_fib;
 
 		aac_consumer_free(dev, q, HostNormRespQueue);
 		/*
@@ -170,31 +171,50 @@
 	 *	up the waiters until there are no more QEs. We then return
 	 *	back to the system.
 	 */
+	dprintk((KERN_INFO
+	  "dev=%p, dev->comm_phys=%x, dev->comm_addr=%p, dev->comm_size=%u\n",
+	  dev, (u32)dev->comm_phys, dev->comm_addr, (unsigned)dev->comm_size));
+
 	while(aac_consumer_get(dev, q, &entry))
 	{
+		struct fib fibctx;
 		struct hw_fib * hw_fib;
-		hw_fib = (struct hw_fib *)((char *)dev->hw_fib_va + 
-				((entry->addr & ~0x01) - dev->hw_fib_pa));
+		u32 index;
+		struct fib *fib = &fibctx;
+
+		index = le32_to_cpu(entry->addr / sizeof(struct hw_fib));
+		hw_fib = &dev->aif_base_va[index];
 
-		if (dev->aif_thread) {
-		        aac_list_add_tail(&hw_fib->header.FibLinks, &q->cmdq);
+		/*
+		 *	Allocate a FIB at all costs. For non queued stuff
+		 *	we can just use the stack so we are happy. We need
+		 *	a fib object in order to manage the linked lists
+		 */
+		if (dev->aif_thread)
+			if((fib = kmalloc(sizeof(struct fib), GFP_ATOMIC))==NULL)
+				fib = &fibctx;
+			
+		memset(fib, 0, sizeof(struct fib));
+		INIT_LIST_HEAD(&fib->fiblink);
+		fib->type = FSAFS_NTC_FIB_CONTEXT;
+		fib->size = sizeof(struct fib);
+		fib->hw_fib = hw_fib;
+		fib->data = hw_fib->data;
+		fib->dev = dev;
+		
+		if (dev->aif_thread && fib != &fibctx)
+		{		
+			list_add_tail(&fib->fiblink, &q->cmdq);
 	 	        aac_consumer_free(dev, q, HostNormCmdQueue);
 		        wake_up_interruptible(&q->cmdready);
 		} else {
-			struct fib fibctx;
 	 	        aac_consumer_free(dev, q, HostNormCmdQueue);
 			spin_unlock_irqrestore(q->lock, flags);
-			memset(&fibctx, 0, sizeof(struct fib));
-			fibctx.type = FSAFS_NTC_FIB_CONTEXT;
-			fibctx.size = sizeof(struct fib);
-			fibctx.hw_fib = hw_fib;
-			fibctx.data = hw_fib->data;
-			fibctx.dev = dev;
 			/*
 			 *	Set the status of this FIB
 			 */
 			*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
-			fib_adapter_complete(&fibctx, sizeof(u32));
+			fib_adapter_complete(fib, sizeof(u32));
 			spin_lock_irqsave(q->lock, flags);
 		}		
 	}
===== drivers/scsi/aacraid/linit.c 1.22 vs edited =====
--- 1.22/drivers/scsi/aacraid/linit.c	Tue Aug 26 09:25:41 2003
+++ edited/drivers/scsi/aacraid/linit.c	Tue Sep 30 15:29:05 2003
@@ -35,8 +35,8 @@
  *	
  */
 
-#define AAC_DRIVER_VERSION		"1.1.2"
-#define AAC_DRIVER_BUILD_DATE		__DATE__
+#define AAC_DRIVER_VERSION		0x01010400
+#define AAC_DRIVER_BUILD_DATE		__DATE__ " " __TIME__
 
 #include <linux/module.h>
 #include <linux/config.h>
@@ -63,18 +63,12 @@
 MODULE_AUTHOR("Red Hat Inc and Adaptec");
 MODULE_DESCRIPTION("Supports Dell PERC2, 2/Si, 3/Si, 3/Di, Adaptec Advanced Raid Products, and HP NetRAID-4M devices. http://domsch.com/linux/ or http://linux.adaptec.com");
 MODULE_LICENSE("GPL");
-MODULE_PARM(nondasd, "i");
-MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
-MODULE_PARM(paemode, "i");
-MODULE_PARM_DESC(paemode, "Control whether dma addressing is using PAE. 0=off, 1=on");
-
-int nondasd=-1;
-int paemode=-1;
 
 struct aac_dev *aac_devices[MAXIMUM_NUM_ADAPTERS];
 
 static unsigned aac_count = 0;
 static int aac_cfg_major = -1;
+unsigned long aac_driver_version = AAC_DRIVER_VERSION;
 
 /*
  * Because of the way Linux names scsi devices, the order in this table has
@@ -85,37 +79,52 @@
  * In the future we should add a fib that reports the number of channels
  * for the card.  At that time we can remove the channels from here
  */
+
 static struct aac_driver_ident aac_drivers[] = {
-	{ 0x1028, 0x0001, 0x1028, 0x0001, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 2/Si */
-	{ 0x1028, 0x0002, 0x1028, 0x0002, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x0003, 0x1028, 0x0003, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
-	{ 0x1028, 0x0004, 0x1028, 0x00d0, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
-	{ 0x1028, 0x0002, 0x1028, 0x00d1, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x0002, 0x1028, 0x00d9, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x0106, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x011b, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x0121, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x9005, 0x0283, 0x9005, 0x0283, aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2 }, /* catapult*/
-	{ 0x9005, 0x0284, 0x9005, 0x0284, aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2 }, /* tomcat*/
-	{ 0x9005, 0x0285, 0x9005, 0x0286, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1 }, /* Adaptec 2120S (Crusader)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0285, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0287, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan-2m)*/
-	{ 0x9005, 0x0285, 0x17aa, 0x0286, aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1 }, /* Legend S220*/
-	{ 0x9005, 0x0285, 0x17aa, 0x0287, aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2 }, /* Legend S230*/
-
-	{ 0x9005, 0x0285, 0x9005, 0x0288, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0289, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028a, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028b, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0290, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
-	{ 0x9005, 0x0250, 0x1014, 0x0279, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Marco)*/
-	{ 0x9005, 0x0250, 0x1014, 0x028c, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Sebring)*/
+	{ 0x1028, 0x0001, 0x1028, 0x0001, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 2/Si (Iguana/PERC2Si) */
+	{ 0x1028, 0x0002, 0x1028, 0x0002, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Opal/PERC3Di) */
+	{ 0x1028, 0x0003, 0x1028, 0x0003, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si (SlimFast/PERC3Si */
+	{ 0x1028, 0x0004, 0x1028, 0x00d0, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
+	{ 0x1028, 0x0002, 0x1028, 0x00d1, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Viper/PERC3DiV) */
+	{ 0x1028, 0x0002, 0x1028, 0x00d9, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Lexus/PERC3DiL) */
+	{ 0x1028, 0x000a, 0x1028, 0x0106, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 1, AAC_QUIRK_31BIT }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ 0x1028, 0x000a, 0x1028, 0x011b, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Dagger/PERC3DiD) */
+	{ 0x1028, 0x000a, 0x1028, 0x0121, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Boxster/PERC3DiB) */
+	{ 0x9005, 0x0283, 0x9005, 0x0283, aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT }, /* catapult */
+	{ 0x9005, 0x0284, 0x9005, 0x0284, aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT }, /* tomcat */
+	{ 0x9005, 0x0285, 0x9005, 0x0286, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT }, /* Adaptec 2120S (Crusader) */
+	{ 0x9005, 0x0285, 0x9005, 0x0285, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan) */
+	{ 0x9005, 0x0285, 0x9005, 0x0287, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan-2m) */
+	{ 0x9005, 0x0285, 0x17aa, 0x0286, aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT }, /* Legend S220 (Legend Crusader) */
+	{ 0x9005, 0x0285, 0x17aa, 0x0287, aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT }, /* Legend S230 (Legend Vulcan) */
+
+	{ 0x9005, 0x0285, 0x9005, 0x0288, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier) */
+	{ 0x9005, 0x0285, 0x9005, 0x0289, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado) */
+	{ 0x9005, 0x0285, 0x9005, 0x028a, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028b, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S SO-DIMM PCI-X ZCR (Terminator) */
+/*	{ 0x9005, 0x0286, 0x9005, 0x028c, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, */ /* ASR-2230S PCI-X (Lancer pre-production) */
+	{ 0x9005, 0x0286, 0x9005, 0x028c, aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ 0x9005, 0x0285, 0x9005, 0x0290, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 1 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ 0x9005, 0x0285, 0x1028, 0x0291, aac_rx_init, "aacraid",  "DELL    ", "CERC SR2        ", 1 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ 0x9005, 0x0285, 0x9005, 0x0292, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 1 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ 0x9005, 0x0285, 0x9005, 0x0293, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA", 1 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ 0x9005, 0x0285, 0x9005, 0x0294, aac_rx_init, "aacraid",  "ADAPTEC ", "SO-DIMM SATA ZCR", 1 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ 0x9005, 0x0285, 0x0E11, 0x0295, aac_rx_init, "aacraid",  "ADAPTEC ", "SATA 6Channel   ", 1 }, /* SATA 6Ch (Bearcat) */
 
-	{ 0x9005, 0x0285, 0x1028, 0x0287, aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2 }, /* Perc 320/DC*/
+	{ 0x9005, 0x0285, 0x1028, 0x0287, aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
 	{ 0x1011, 0x0046, 0x9005, 0x0365, aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
 	{ 0x1011, 0x0046, 0x9005, 0x0364, aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4 }, /* Dell PERC2 "Quad Channel" */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }  /* HP NetRAID-4M */
+	{ 0x1011, 0x0046, 0x9005, 0x1364, aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT }, /* Dell PERC2/QC */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }, /* HP NetRAID-4M */
+
+	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID,
+					  aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Dell Catchall */
+	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID,
+					  aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Legend Catchall */
+	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID,
+					  aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Adaptec Catch All */
+	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID,
+					  aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec Rocket Catch All */
 };
 
 #define NUM_AACTYPES	(sizeof(aac_drivers) / sizeof(struct aac_driver_ident))
@@ -174,8 +183,13 @@
 	struct aac_dev *aac;
 	struct fsa_scsi_hba *fsa_dev_ptr;
 	char *name = NULL;
+	int ret;
 	
-	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n", AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
+	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%d.%d.%d %s)\n", 
+			AAC_DRIVER_VERSION >> 24, 
+			(AAC_DRIVER_VERSION >> 16) & 0xFF, 
+			(AAC_DRIVER_VERSION >> 8) & 0xFF, 
+			AAC_DRIVER_BUILD_DATE);
 
 	/* setting up the proc directory structure */
 	template->proc_name = "aacraid";
@@ -194,8 +208,17 @@
 			if (pci_enable_device(dev))
 				continue;
 			pci_set_master(dev);
-			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
 
+			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
+				ret = pci_set_dma_mask(dev, 0x7FFFFFFFULL);
+			else
+				ret = pci_set_dma_mask(dev, 0xFFFFFFFFULL);
+
+			if (ret) {
+				printk(KERN_WARNING "aacraid: Can't set DMA mask.\n");
+				continue;
+			}
+				
 			if((dev->subsystem_vendor != aac_drivers[index].subsystem_vendor) || 
 			   (dev->subsystem_device != aac_drivers[index].subsystem_device))
 					continue;
@@ -203,8 +226,6 @@
 			dprintk((KERN_DEBUG "%s device detected.\n", name));
 			dprintk((KERN_DEBUG "%x/%x/%x/%x.\n", vendor_id, device_id, 
 				aac_drivers[index].subsystem_vendor, aac_drivers[index].subsystem_device));
-			/* Increment the host adapter count */
-			aac_count++;
 			/*
 			 * scsi_register() allocates memory for a Scsi_Hosts structure and
 			 * links it into the linked list of host adapters. This linked list
@@ -218,6 +239,12 @@
 			 * specific information.
 			 */
 			host_ptr = scsi_register( template, sizeof(struct aac_dev) );
+			if (!host_ptr) {
+				continue;
+			}
+
+			/* Increment the host adapter count */
+			aac_count++;
 			/* 
 			 * These three parameters can be used to allow for wide SCSI 
 			 * and for host adapters that support multiple buses.
@@ -278,13 +305,12 @@
 			dprintk((KERN_DEBUG "Device has %d logical channels\n",host_ptr->max_channel));
 			aac_get_containers(aac);
 			aac_devices[aac_count-1] = aac;
-//			spin_unlock_irqrestore(&aac->fib_lock, flags);
 
 			/*
 			 * dmb - we may need to move the setting of these parms somewhere else once
 			 * we get a fib that can report the actual numbers
 			 */
-			host_ptr->max_id = AAC_MAX_TARGET;
+			host_ptr->max_id = MAXIMUM_NUM_CONTAINERS;
 			host_ptr->max_lun = AAC_MAX_LUN;
 
 		}
@@ -514,7 +540,7 @@
 }
 
 /**
- *	aac_queuedepth		-	compute queue depths
+ *	aac_slave_configure		-	compute queue depths
  *	@host:	SCSI host in question
  *	@dev:	SCSI device we are considering
  *
@@ -543,7 +569,6 @@
 		Handle SCSI ioctls
  *----------------------------------------------------------------------------*/
 static int aac_ioctl(Scsi_Device * scsi_dev_ptr, int cmd, void * arg)
-/*----------------------------------------------------------------------------*/
 {
 	struct aac_dev *dev;
 	dprintk((KERN_DEBUG "aac_ioctl.\n"));
===== drivers/scsi/aacraid/rkt.c 1.1 vs edited =====
--- 1.1/drivers/scsi/aacraid/rkt.c	Thu Oct  2 07:32:58 2003
+++ edited/drivers/scsi/aacraid/rkt.c	Fri Oct  3 14:27:34 2003
@@ -0,0 +1,417 @@
+/*
+ *	Adaptec AAC series RAID controller driver
+ *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *
+ * based on the old aacraid driver that is..
+ * Adaptec aacraid device driver for Linux.
+ *
+ * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Module Name:
+ *  rkt.c
+ *
+ * Abstract: Hardware miniport for Drawbridge specific hardware functions.
+ *
+ */
+
+#include <linux/config.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/completion.h>
+# include <linux/interrupt.h>
+#include <asm/semaphore.h>
+#include "scsi.h"
+#include "hosts.h"
+
+#include "aacraid.h"
+
+static irqreturn_t aac_rkt_intr(int irq, void *dev_id, struct pt_regs *regs)
+{
+	struct aac_dev *dev = dev_id;
+	unsigned long bellbits;
+	u8 intstat, mask;
+	intstat = rkt_readb(dev, MUnit.OISR);
+	/*
+	 *	Read mask and invert because drawbridge is reversed.
+	 *	This allows us to only service interrupts that have 
+	 *	been enabled.
+	 */
+	mask = ~(rkt_readb(dev, MUnit.OIMR));
+	/* Check to see if this is our interrupt.  If it isn't just return */
+	if (intstat & mask) 
+	{
+		bellbits = rkt_readl(dev, OutboundDoorbellReg);
+		if (bellbits & DoorBellPrintfReady) {
+			aac_printf(dev, le32_to_cpu(rkt_readl (dev, IndexRegs.Mailbox[5])));
+			rkt_writel(dev, MUnit.ODR,DoorBellPrintfReady);
+			rkt_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
+		}
+		else if (bellbits & DoorBellAdapterNormCmdReady) {
+			aac_command_normal(&dev->queues->queue[HostNormCmdQueue]);
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdReady);
+		}
+		else if (bellbits & DoorBellAdapterNormRespReady) {
+			aac_response_normal(&dev->queues->queue[HostNormRespQueue]);
+			rkt_writel(dev, MUnit.ODR,DoorBellAdapterNormRespReady);
+		}
+		else if (bellbits & DoorBellAdapterNormCmdNotFull) {
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+		}
+		else if (bellbits & DoorBellAdapterNormRespNotFull) {
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
+			rkt_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
+		}
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+/**
+ *	aac_rkt_enable_interrupt	-	Enable event reporting
+ *	@dev: Adapter
+ *	@event: Event to enable
+ *
+ *	Enable event reporting from the i960 for a given event.
+ */
+ 
+static void aac_rkt_enable_interrupt(struct aac_dev * dev, u32 event)
+{
+	switch (event) {
+
+	case HostNormCmdQue:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_1);
+		break;
+
+	case HostNormRespQue:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_2);
+		break;
+
+	case AdapNormCmdNotFull:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_3);
+		break;
+
+	case AdapNormRespNotFull:
+		dev->irq_mask &= ~(OUTBOUNDDOORBELL_4);
+		break;
+	}
+}
+
+/**
+ *	aac_rkt_disable_interrupt	-	Disable event reporting
+ *	@dev: Adapter
+ *	@event: Event to enable
+ *
+ *	Disable event reporting from the i960 for a given event.
+ */
+
+static void aac_rkt_disable_interrupt(struct aac_dev *dev, u32 event)
+{
+	switch (event) {
+
+	case HostNormCmdQue:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_1);
+		break;
+
+	case HostNormRespQue:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_2);
+		break;
+
+	case AdapNormCmdNotFull:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_3);
+		break;
+
+	case AdapNormRespNotFull:
+		dev->irq_mask |= (OUTBOUNDDOORBELL_4);
+		break;
+	}
+}
+
+/**
+ *	rkt_sync_cmd	-	send a command and wait
+ *	@dev: Adapter
+ *	@command: Command to execute
+ *	@p1: first parameter
+ *	@ret: adapter status
+ *
+ *	This routine will send a synchronous comamnd to the adapter and wait 
+ *	for its	completion.
+ */
+
+static int rkt_sync_cmd(struct aac_dev *dev, u32 command, u32 p1, u32 *status)
+{
+	unsigned long start;
+	int ok;
+	/*
+	 *	Write the command into Mailbox 0
+	 */
+	rkt_writel(dev, InboundMailbox0, cpu_to_le32(command));
+	/*
+	 *	Write the parameters into Mailboxes 1 - 4
+	 */
+	rkt_writel(dev, InboundMailbox1, cpu_to_le32(p1));
+	rkt_writel(dev, InboundMailbox2, 0);
+	rkt_writel(dev, InboundMailbox3, 0);
+	rkt_writel(dev, InboundMailbox4, 0);
+	/*
+	 *	Clear the synch command doorbell to start on a clean slate.
+	 */
+	rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
+	/*
+	 *	Disable doorbell interrupts
+	 */
+	rkt_writeb(dev, MUnit.OIMR, rkt_readb(dev, MUnit.OIMR) | 0x04);
+	/*
+	 *	Force the completion of the mask register write before issuing
+	 *	the interrupt.
+	 */
+	rkt_readb (dev, MUnit.OIMR);
+	/*
+	 *	Signal that there is a new synch command
+	 */
+	rkt_writel(dev, InboundDoorbellReg, INBOUNDDOORBELL_0);
+
+	ok = 0;
+	start = jiffies;
+
+	/*
+	 *	Wait up to 30 seconds
+	 */
+	while (time_before(jiffies, start+30*HZ)) 
+	{
+		udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
+		/*
+		 *	Mon960 will set doorbell0 bit when it has completed the command.
+		 */
+		if (rkt_readl(dev, OutboundDoorbellReg) & OUTBOUNDDOORBELL_0) {
+			/*
+			 *	Clear the doorbell.
+			 */
+			rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
+			ok = 1;
+			break;
+		}
+		/*
+		 *	Yield the processor in case we are slow 
+		 */
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1);
+	}
+	if (ok != 1) {
+		/*
+		 *	Restore interrupt mask even though we timed out
+		 */
+		rkt_writeb(dev, MUnit.OIMR, rkt_readl(dev, MUnit.OIMR) & 0xfb);
+		return -ETIMEDOUT;
+	}
+	/*
+	 *	Pull the synch status from Mailbox 0.
+	 */
+	*status = le32_to_cpu(rkt_readl(dev, IndexRegs.Mailbox[0]));
+	/*
+	 *	Clear the synch command doorbell.
+	 */
+	rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
+	/*
+	 *	Restore interrupt mask
+	 */
+	rkt_writeb(dev, MUnit.OIMR, rkt_readl(dev, MUnit.OIMR) & 0xfb);
+	return 0;
+
+}
+
+/**
+ *	aac_rkt_interrupt_adapter	-	interrupt adapter
+ *	@dev: Adapter
+ *
+ *	Send an interrupt to the i960 and breakpoint it.
+ */
+
+static void aac_rkt_interrupt_adapter(struct aac_dev *dev)
+{
+	u32 ret;
+	rkt_sync_cmd(dev, BREAKPOINT_REQUEST, 0, &ret);
+}
+
+/**
+ *	aac_rkt_notify_adapter		-	send an event to the adapter
+ *	@dev: Adapter
+ *	@event: Event to send
+ *
+ *	Notify the i960 that something it probably cares about has
+ *	happened.
+ */
+
+static void aac_rkt_notify_adapter(struct aac_dev *dev, u32 event)
+{
+	switch (event) {
+
+	case AdapNormCmdQue:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_1);
+		break;
+	case HostNormRespNotFull:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_4);
+		break;
+	case AdapNormRespQue:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_2);
+		break;
+	case HostNormCmdNotFull:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_3);
+		break;
+	case HostShutdown:
+/*		rkt_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, &ret); */
+		break;
+	case FastIo:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_6);
+		break;
+	case AdapPrintfDone:
+		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_5);
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+/**
+ *	aac_rkt_start_adapter		-	activate adapter
+ *	@dev:	Adapter
+ *
+ *	Start up processing on an i960 based AAC adapter
+ */
+
+static void aac_rkt_start_adapter(struct aac_dev *dev)
+{
+	u32 status;
+	struct aac_init *init;
+
+	init = dev->init;
+	init->HostElapsedSeconds = cpu_to_le32(jiffies/HZ);
+	/*
+	 *	Tell the adapter we are back and up and running so it will scan
+	 *	its command queues and enable our interrupts
+	 */
+	dev->irq_mask = (DoorBellPrintfReady | OUTBOUNDDOORBELL_1 | OUTBOUNDDOORBELL_2 | OUTBOUNDDOORBELL_3 | OUTBOUNDDOORBELL_4);
+	/*
+	 *	First clear out all interrupts.  Then enable the one's that we
+	 *	can handle.
+	 */
+	rkt_writeb(dev, MUnit.OIMR, 0xff);
+	rkt_writel(dev, MUnit.ODR, 0xffffffff);
+/*	rkt_writeb(dev, MUnit.OIMR, ~(u8)OUTBOUND_DOORBELL_INTERRUPT_MASK); */
+	rkt_writeb(dev, MUnit.OIMR, 0xfb);
+
+	/* We can only use a 32 bit address here */
+	rkt_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &status);
+}
+
+/**
+ *	aac_rkt_init	-	initialize an i960 based AAC card
+ *	@dev: device to configure
+ *	@devnum: adapter number
+ *
+ *	Allocate and set up resources for the i960 based AAC variants. The 
+ *	device_interface in the commregion will be allocated and linked 
+ *	to the comm region.
+ */
+
+int aac_rkt_init(struct aac_dev *dev, unsigned long num)
+{
+	unsigned long start;
+	unsigned long status;
+	int instance;
+	const char * name;
+
+	dev->devnum = num;
+	instance = dev->id;
+	name     = dev->name;
+
+	/*
+	 *	Map in the registers from the adapter.
+	 */
+	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
+	{	
+		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
+		return -1;
+	}
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & SELF_TEST_FAILED) {
+		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
+		return -1;
+	}
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_PANIC) {
+		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
+		return -1;
+	}
+	start = jiffies;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
+	 */
+	while (!(rkt_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_UP_AND_RUNNING)) 
+	{
+		if(time_after(jiffies, start+180*HZ))
+		{
+			status = rkt_readl(dev, IndexRegs.Mailbox[7]) >> 16;
+			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %ld.\n", dev->name, instance, status);
+			return -1;
+		}
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1);
+	}
+	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
+	{
+		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name, instance);
+		return -1;
+	}
+	/*
+	 *	Fill in the function dispatch table.
+	 */
+	dev->a_ops.adapter_interrupt = aac_rkt_interrupt_adapter;
+	dev->a_ops.adapter_enable_int = aac_rkt_enable_interrupt;
+	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
+	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
+	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
+
+	if (aac_init_adapter(dev) == NULL)
+		return -1;
+	/*
+	 *	Start any kernel threads needed
+	 */
+	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
+	if(dev->thread_pid < 0)
+	{
+		printk(KERN_ERR "aacraid: Unable to create rkt thread.\n");
+		return -1;
+	}	
+	/*
+	 *	Tell the adapter that all is configured, and it can start
+	 *	accepting requests
+	 */
+	aac_rkt_start_adapter(dev);
+	return 0;
+}
===== drivers/scsi/aacraid/rx.c 1.4 vs edited =====
--- 1.4/drivers/scsi/aacraid/rx.c	Fri May  2 12:31:27 2003
+++ edited/drivers/scsi/aacraid/rx.c	Mon Aug 18 10:45:02 2003
@@ -403,6 +403,11 @@
 	 *	Start any kernel threads needed
 	 */
 	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
+	if(dev->thread_pid < 0)
+	{
+		printk(KERN_ERR "aacraid: Unable to create rx thread.\n");
+		return -1;
+	}	
 	/*
 	 *	Tell the adapter that all is configured, and it can start
 	 *	accepting requests
===== drivers/scsi/aacraid/sa.c 1.5 vs edited =====
--- 1.5/drivers/scsi/aacraid/sa.c	Fri May  2 12:31:09 2003
+++ edited/drivers/scsi/aacraid/sa.c	Mon Aug 18 10:46:31 2003
@@ -387,6 +387,10 @@
 	 *	Start any kernel threads needed
 	 */
 	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
+	if (dev->thread_pid < 0) {
+	     printk(KERN_ERR "aacraid: Unable to create command thread.\n");
+	     return -1;
+	}
 	/*
 	 *	Tell the adapter that all is configure, and it can start 
 	 *	accepting requests

-- 
Mark Haverkamp <markh@osdl.org>

