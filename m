From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.0 aacraid driver update
Date: Fri, 22 Aug 2003 08:47:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:35787 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263343AbTHVPrL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 11:47:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

A few weeks ago Alan mentioned in an email that the 2.6 aacraid driver
was out of date with respect to the 2.4 version.  I have looked at the
2.4 version and applied updates to the current 2.6 driver.

I have tested this out on the hardware we have at OSDL, a 5400S and hp
netraid-4m.

Mark.



 drivers/scsi/aacraid/aachba.c   |   45 +++++++++++++++++---
 drivers/scsi/aacraid/aacraid.h  |   13 ++++-
 drivers/scsi/aacraid/commctrl.c |    4 -
 drivers/scsi/aacraid/commsup.c  |   89 +++++++++++++++++++++++++++++++++++-----
 drivers/scsi/aacraid/linit.c    |   80 +++++++++++++++++++++--------------
 drivers/scsi/aacraid/rx.c       |    5 ++
 drivers/scsi/aacraid/sa.c       |    4 +
 drivers/scsi/scsi_priv.h        |    2 
 drivers/scsi/scsi_syms.c        |    1 
 include/scsi/scsi_host.h        |    2 
 10 files changed, 191 insertions(+), 54 deletions(-)

===== drivers/scsi/scsi_priv.h 1.22 vs edited =====
--- 1.22/drivers/scsi/scsi_priv.h	Thu Aug  7 05:25:43 2003
+++ edited/drivers/scsi/scsi_priv.h	Tue Aug 19 14:51:39 2003
@@ -115,8 +115,6 @@
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
-int scsi_scan_host_selected(struct Scsi_Host *, unsigned int, unsigned int,
-			    unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_rescan_device(struct device *);
===== drivers/scsi/scsi_syms.c 1.45 vs edited =====
--- 1.45/drivers/scsi/scsi_syms.c	Thu Jul 31 07:32:18 2003
+++ edited/drivers/scsi/scsi_syms.c	Tue Aug 19 14:15:06 2003
@@ -34,6 +34,7 @@
 EXPORT_SYMBOL(scsi_register_interface);
 EXPORT_SYMBOL(scsi_host_alloc);
 EXPORT_SYMBOL(scsi_add_host);
+EXPORT_SYMBOL(scsi_scan_host_selected);
 EXPORT_SYMBOL(scsi_scan_host);
 EXPORT_SYMBOL(scsi_remove_host);
 EXPORT_SYMBOL(scsi_host_get);
===== drivers/scsi/aacraid/aachba.c 1.20 vs edited =====
--- 1.20/drivers/scsi/aacraid/aachba.c	Fri May  2 12:30:49 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Thu Aug 21 07:35:11 2003
@@ -503,16 +503,37 @@
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
@@ -1270,6 +1291,12 @@
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
@@ -1302,6 +1329,12 @@
 			b1 = ((u8*)scsicmd->buffer)[1];
 			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER
 					|| (b==TYPE_DISK && (b1&0x80)) ){
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if((dev->raid_scsi_mode) && (scsicmd->device->channel == 2)){
 				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
===== drivers/scsi/aacraid/aacraid.h 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/aacraid.h	Thu May  8 11:24:16 2003
+++ edited/drivers/scsi/aacraid/aacraid.h	Wed Aug 20 08:45:28 2003
@@ -527,6 +527,8 @@
 	char *	vname;
 	char *	model;
 	u16	channels;
+	int	quirks;
+#define	AAC_QUIRK_31BIT		1
 };
 
 /*
@@ -549,7 +551,7 @@
                   /* This is only valid for adapter to host command queues. */ 
 	spinlock_t	 	*lock;		/* Spinlock for this queue must take this lock before accessing the lock */
 	spinlock_t		lockdata;	/* Actual lock (used only on one side of the lock) */
-	u32 			SavedIrql;     	/* Previous IRQL when the spin lock is taken */
+	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */
 	u32			padding;	/* Padding - FIXME - can remove I believe */
 	struct aac_list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
 //	struct list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
@@ -824,6 +826,9 @@
 #define AAC_OPT_SGMAP_HOST64	cpu_to_le32(1<<10)
 #define AAC_OPT_ALARM		cpu_to_le32(1<<11)
 #define AAC_OPT_NONDASD		cpu_to_le32(1<<12)
+#define AAC_OPT_SCSI_MANAGED   	cpu_to_le32(1<<13)
+#define AAC_OPT_RAID_SCSI_MODE	cpu_to_le32(1<<14)
+#define AAC_OPT_SUPPLEMENT_ADAPTER_INFO	cpu_to_le32(1<<15)
 
 struct aac_dev
 {
@@ -873,7 +878,7 @@
 
 	struct Scsi_Host	*scsi_host_ptr;
 	struct fsa_scsi_hba	fsa_dev;
-	int			thread_pid;
+	pid_t			thread_pid;
 	int			cardtype;
 	
 	/*
@@ -896,6 +901,7 @@
 	 */
 	u8			nondasd_support; 
 	u8			pae_support;
+	u8			raid_scsi_mode;
 };
 
 #define AllocateAndMapFibSpace(dev, MapFibContext) \
@@ -1426,9 +1432,12 @@
  */
  
 #define 	AifCmdEventNotify	1	/* Notify of event */
+#define		AifEnContainerChange	4	/* Container configuration change */
 #define		AifCmdJobProgress	2	/* Progress report */
 #define		AifCmdAPIReport		3	/* Report from other user of API */
 #define		AifCmdDriverNotify	4	/* Notify host driver of event */
+#define		AifDenMorphComplete	200	/* A morph operation completed */
+#define		AifDenVolumeExtendComplete 201  /* A volume expand operation completed */
 #define		AifReqJobList		100	/* Gets back complete job list */
 #define		AifReqJobsForCtr	101	/* Gets back jobs for specific container */
 #define		AifReqJobsForScsi	102	/* Gets back jobs for specific SCSI device */ 
===== drivers/scsi/aacraid/commctrl.c 1.3 vs edited =====
--- 1.3/drivers/scsi/aacraid/commctrl.c	Fri May  2 12:30:31 2003
+++ edited/drivers/scsi/aacraid/commctrl.c	Thu Aug 21 07:58:24 2003
@@ -244,7 +244,6 @@
 		 */
 		kfree(hw_fib);
 		status = 0;
-		fibctx->jiffies = jiffies/HZ;
 	} else {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
 		if (f.wait) {
@@ -259,6 +258,7 @@
 			status = -EAGAIN;
 		}	
 	}
+	fibctx->jiffies = jiffies/HZ;
 	return status;
 }
 
@@ -437,7 +437,7 @@
 	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
 	srbcmd->cdb_size = cpu_to_le32(srbcmd->cdb_size);
 	
-	switch(srbcmd->flags){
+	switch(srbcmd->flags & (SRB_DataIn | SRB_DataOut)){
 	case SRB_DataOut:
 		data_dir = SCSI_DATA_WRITE;
 		break;
===== drivers/scsi/aacraid/commsup.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/commsup.c	Fri May  2 12:31:18 2003
+++ edited/drivers/scsi/aacraid/commsup.c	Thu Aug 21 07:52:02 2003
@@ -497,7 +497,7 @@
 	dprintk((KERN_DEBUG "  Command =               %d.\n", hw_fib->header.Command));
 	dprintk((KERN_DEBUG "  XferState  =            %x.\n", hw_fib->header.XferState));
 	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib));
-	dprintk((KERN_DEBUG "  hw_fib pa being sent=%xl\n",(ulong)fibptr->hw_fib_pa));
+	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
 	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
 	/*
 	 *	Fill in the Callback and CallbackContext if we are not
@@ -787,16 +787,75 @@
  *	dispatches it to the appropriate routine for handling.
  */
 
+#define CONTAINER_TO_BUS(cont)		(0)
+#define CONTAINER_TO_TARGET(cont)	((cont))
+#define CONTAINER_TO_LUN(cont)		(0)
+
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
-	/*
-	 * Set the status of this FIB to be Invalid parameter.
-	 *
-	 *	*(u32 *)fib->data = ST_INVAL;
-	 */
-	*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
-	fib_adapter_complete(fibptr, sizeof(u32));
+	struct aac_aifcmd * aifcmd = (struct aac_aifcmd *)hw_fib->data;
+	int busy;
+	u32 container;
+
+	/* Sniff for container changes */
+	dprintk ((KERN_INFO "AifCmdDriverNotify=%x\n", 
+				le32_to_cpu(*(u32 *)aifcmd->data)));
+	switch (le32_to_cpu(*(u32 *)aifcmd->data)) {
+	case AifDenMorphComplete:
+	case AifDenVolumeExtendComplete:
+	case AifEnContainerChange: /* Not really a driver notify Event */
+
+		busy = 0;
+		container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+		dprintk ((KERN_INFO "container=%d(%d,%d,%d,%d) ",
+		  container,
+		  (dev && dev->scsi_host_ptr)
+		    ? dev->scsi_host_ptr->host_no
+		    : -1,
+		  CONTAINER_TO_BUS(container),
+		  CONTAINER_TO_TARGET(container),
+		  CONTAINER_TO_LUN(container)));
+
+		/*
+		 *	Find the Scsi_Device associated with the SCSI address,
+		 * and mark it as changed, invalidating the cache. This deals
+		 * with changes to existing device IDs.
+		 */
+
+		if ((dev != (struct aac_dev *)NULL)
+		 && (dev->scsi_host_ptr != (struct Scsi_Host *)NULL)) {
+			Scsi_Device * device;
+
+			list_for_each_entry(device, 
+					&dev->scsi_host_ptr->my_devices, siblings) {
+				dprintk((KERN_INFO
+				  "aifd: device (%d,%d,%d,%d)?\n",
+				  dev->scsi_host_ptr->host_no,
+				  device->channel,
+				  device->id,
+				  device->lun));
+				if ((device->channel == CONTAINER_TO_BUS(container))
+				 && (device->id == CONTAINER_TO_TARGET(container))
+				 && (device->lun == CONTAINER_TO_LUN(container))) {
+					busy |= (device->access_count != 0);
+					if (busy == 0) {
+						device->removable = TRUE;
+					}
+				}
+			}
+		}
+
+		dprintk (("busy=%d\n", busy));
+
+		if (busy == 0) {
+			scsi_scan_host_selected(dev->scsi_host_ptr,
+		 		CONTAINER_TO_BUS(container),
+		 		CONTAINER_TO_TARGET(container),
+		 		CONTAINER_TO_LUN(container),
+				1);
+		}
+	}
 }
 
 /**
@@ -867,8 +926,11 @@
 			 *	We only handle AifRequest fibs from the adapter.
 			 */
 			aifcmd = (struct aac_aifcmd *) hw_fib->data;
-			if (aifcmd->command == le16_to_cpu(AifCmdDriverNotify)) {
+			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
+				/* Handle Driver Notify Events */
 				aac_handle_aif(dev, &fibptr);
+				*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
+				fib_adapter_complete(&fibptr, sizeof(u32));
 			} else {
 				struct list_head *entry;
 				/* The u32 here is important and intended. We are using
@@ -877,6 +939,10 @@
 				u32 time_now, time_last;
 				unsigned long flagv;
 				
+				/* Sniff events */
+				if (aifcmd->command == cpu_to_le32(AifCmdEventNotify))
+					aac_handle_aif(dev, &fibptr);
+
 				time_now = jiffies/HZ;
 
 				spin_lock_irqsave(&dev->fib_lock, flagv);
@@ -898,6 +964,11 @@
 					 */
 					if (fibctx->count > 20)
 					{
+						/*
+						 * It's *not* jiffies folks,
+						 * but jiffies / HZ, so do not
+						 * panic ...
+						 */
 						time_last = fibctx->jiffies;
 						/*
 						 * Has it been > 2 minutes 
===== drivers/scsi/aacraid/linit.c 1.21 vs edited =====
--- 1.21/drivers/scsi/aacraid/linit.c	Thu Jul 31 07:32:16 2003
+++ edited/drivers/scsi/aacraid/linit.c	Tue Aug 19 07:32:46 2003
@@ -86,38 +86,44 @@
  * for the card.  At that time we can remove the channels from here
  */
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
-
-	{ 0x9005, 0x0285, 0x1028, 0x0287, aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4 }, /* Dell PERC2 "Quad Channel" */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }  /* HP NetRAID-4M */
+	{ 0x1028, 0x0001, 0x1028, 0x0001, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 2/Si (Iguana/PERC2Si) */
+	{ 0x1028, 0x0002, 0x1028, 0x0002, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Opal/PERC3Di) */
+	{ 0x1028, 0x0003, 0x1028, 0x0003, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Si (SlimFast/PERC3Si */
+	{ 0x1028, 0x0004, 0x1028, 0x00d0, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Iguana FlipChip/PERC3DiF */
+	{ 0x1028, 0x0002, 0x1028, 0x00d1, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Viper/PERC3DiV) */
+	{ 0x1028, 0x0002, 0x1028, 0x00d9, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Lexus/PERC3DiL) */
+	{ 0x1028, 0x000a, 0x1028, 0x0106, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ 0x1028, 0x000a, 0x1028, 0x011b, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Dagger/PERC3DiD) */
+	{ 0x1028, 0x000a, 0x1028, 0x0121, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, 		/* PERC 3/Di (Boxster/PERC3DiB) */
+	{ 0x9005, 0x0283, 0x9005, 0x0283, aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2 }, 		/* catapult */
+	{ 0x9005, 0x0284, 0x9005, 0x0284, aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2 }, 		/* tomcat */
+	{ 0x9005, 0x0285, 0x9005, 0x0286, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT },/* Adaptec 2120S (Crusader) */
+	{ 0x9005, 0x0285, 0x9005, 0x0285, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT },/* Adaptec 2200S (Vulcan) */
+	{ 0x9005, 0x0285, 0x9005, 0x0287, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT },/* Adaptec 2200S (Vulcan-2m) */
+	{ 0x9005, 0x0285, 0x17aa, 0x0286, aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1 }, 		/* Legend S220 (Legend Crusader) */
+	{ 0x9005, 0x0285, 0x17aa, 0x0287, aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2 }, 		/* Legend S230 (Legend Vulcan) */
+
+	{ 0x9005, 0x0285, 0x9005, 0x0288, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, 		/* Adaptec 3230S (Harrier) */
+	{ 0x9005, 0x0285, 0x9005, 0x0289, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, 		/* Adaptec 3240S (Tornado) */
+	{ 0x9005, 0x0285, 0x9005, 0x028a, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, 		/* ASR-2020S PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028b, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, 		/* ASR-2020S SO-DIMM PCI-X ZCR (Terminator) */
+	{ 0x9005, 0x0285, 0x9005, 0x0290, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, 		/* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ 0x9005, 0x0285, 0x1028, 0x0291, aac_rx_init, "aacraid",  "DELL    ", "CERC SATA RAID 2 ", 2 },		/* CERC SATA RAID 2 PCI SATA 8ch (DellCorsair) */
+	{ 0x9005, 0x0285, 0x9005, 0x0292, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 2 }, 		/* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ 0x9005, 0x0285, 0x9005, 0x0293, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA ", 2 },		/* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ 0x9005, 0x0285, 0x9005, 0x0294, aac_rx_init, "aacraid",  "ADAPTEC ", "SO-DIMM SATA ZCR ", 2 },		/* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	/* ServeRAID */
+/*	{ 0x9005, 0x0250, 0x1014, 0x0279, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, */ /*  (Marco) */
+/*	{ 0x9005, 0x0250, 0x1014, 0x028c, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, */ /* (Sebring)*/
+
+	{ 0x9005, 0x0285, 0x1028, 0x0287, aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2 },			/* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, 		/* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 },			/* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4 },			/* Dell PERC2 "Quad Channel" */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }			/* HP NetRAID-4M */
 };
 
+
 #define NUM_AACTYPES	(sizeof(aac_drivers) / sizeof(struct aac_driver_ident))
 static int num_aacdrivers = NUM_AACTYPES;
 
@@ -194,7 +200,11 @@
 			if (pci_enable_device(dev))
 				continue;
 			pci_set_master(dev);
-			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
+
+			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
+				pci_set_dma_mask(dev, 0x7FFFFFFFULL);
+			else
+				pci_set_dma_mask(dev, 0xFFFFFFFFULL);
 
 			if((dev->subsystem_vendor != aac_drivers[index].subsystem_vendor) || 
 			   (dev->subsystem_device != aac_drivers[index].subsystem_device))
@@ -203,8 +213,6 @@
 			dprintk((KERN_DEBUG "%s device detected.\n", name));
 			dprintk((KERN_DEBUG "%x/%x/%x/%x.\n", vendor_id, device_id, 
 				aac_drivers[index].subsystem_vendor, aac_drivers[index].subsystem_device));
-			/* Increment the host adapter count */
-			aac_count++;
 			/*
 			 * scsi_register() allocates memory for a Scsi_Hosts structure and
 			 * links it into the linked list of host adapters. This linked list
@@ -218,6 +226,12 @@
 			 * specific information.
 			 */
 			host_ptr = scsi_register( template, sizeof(struct aac_dev) );
+			if (host_ptr == (struct Scsi_Host *)0) {
+				continue;
+			}
+
+			/* Increment the host adapter count */
+			aac_count++;
 			/* 
 			 * These three parameters can be used to allow for wide SCSI 
 			 * and for host adapters that support multiple buses.
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
===== include/scsi/scsi_host.h 1.8 vs edited =====
--- 1.8/include/scsi/scsi_host.h	Sat Aug  2 10:18:20 2003
+++ edited/include/scsi/scsi_host.h	Thu Aug 21 08:58:05 2003
@@ -494,6 +494,8 @@
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
+extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int, 
+		unsigned int, unsigned int, int);
 extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);


-- 
Mark Haverkamp <markh@osdl.org>

