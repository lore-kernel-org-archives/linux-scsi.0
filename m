From: akpm@linux-foundation.org
Subject: [patch 20/28] drivers/scsi/ips.c: remove kernel 2.4 code
Date: Thu, 10 May 2007 23:01:04 -0700
Message-ID: <200705110601.l4B614nY008175@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759188AbXEKGJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:09:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de, aacraid@adaptec.com, ipslinux@adaptec.com

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: <aacraid@adaptec.com>
Cc: <ipslinux@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |  145 +++++--------------------------------------
 drivers/scsi/ips.h |   44 -------------
 2 files changed, 20 insertions(+), 169 deletions(-)

diff -puN drivers/scsi/ips.c~drivers-scsi-ipsc-remove-kernel-24-code drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~drivers-scsi-ipsc-remove-kernel-24-code
+++ a/drivers/scsi/ips.c
@@ -211,19 +211,6 @@ module_param(ips, charp, 0);
 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
 #endif
 
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
-#include <linux/blk.h>
-#include "sd.h"
-#define IPS_LOCK_SAVE(lock,flags) spin_lock_irqsave(&io_request_lock,flags)
-#define IPS_UNLOCK_RESTORE(lock,flags) spin_unlock_irqrestore(&io_request_lock,flags)
-#ifndef __devexit_p
-#define __devexit_p(x) x
-#endif
-#else
-#define IPS_LOCK_SAVE(lock,flags) do{spin_lock(lock);(void)flags;}while(0)
-#define IPS_UNLOCK_RESTORE(lock,flags) do{spin_unlock(lock);(void)flags;}while(0)
-#endif
-
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
                          DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
                          PCI_DMA_BIDIRECTIONAL : \
@@ -381,24 +368,13 @@ static struct scsi_host_template ips_dri
 	.eh_abort_handler	= ips_eh_abort,
 	.eh_host_reset_handler	= ips_eh_reset,
 	.proc_name		= "ips",
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	.proc_info		= ips_proc_info,
 	.slave_configure	= ips_slave_configure,
-#else
-	.proc_info		= ips_proc24_info,
-	.select_queue_depths	= ips_select_queue_depth,
-#endif
 	.bios_param		= ips_biosparam,
 	.this_id		= -1,
 	.sg_tablesize		= IPS_MAX_SG,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	.use_new_eh_code	= 1,
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)  &&  LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    .highmem_io          = 1,   
-#endif
 };
 
 
@@ -731,7 +707,7 @@ ips_release(struct Scsi_Host *sh)
 	/* free IRQ */
 	free_irq(ha->irq, ha);
 
-	IPS_REMOVE_HOST(sh);
+	scsi_remove_host(sh);
 	scsi_host_put(sh);
 
 	ips_released_controllers++;
@@ -813,7 +789,6 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 	ips_ha_t *ha;
 	ips_copp_wait_item_t *item;
 	int ret;
-	unsigned long cpu_flags;
 	struct Scsi_Host *host;
 
 	METHOD_TRACE("ips_eh_abort", 1);
@@ -830,7 +805,7 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 	if (!ha->active)
 		return (FAILED);
 
-	IPS_LOCK_SAVE(host->host_lock, cpu_flags);
+	spin_lock(host->host_lock);
 
 	/* See if the command is on the copp queue */
 	item = ha->copp_waitlist.head;
@@ -851,7 +826,7 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 		ret = (FAILED);
 	}
 
-	IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
+	spin_unlock(host->host_lock);
 	return ret;
 }
 
@@ -1176,18 +1151,10 @@ static int ips_queue(struct scsi_cmnd *S
 /*   Set bios geometry for the controller                                   */
 /*                                                                          */
 /****************************************************************************/
-static int
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-ips_biosparam(Disk * disk, kdev_t dev, int geom[])
-{
-	ips_ha_t *ha = (ips_ha_t *) disk->device->host->hostdata;
-	unsigned long capacity = disk->capacity;
-#else
-ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-	      sector_t capacity, int geom[])
+static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+			 sector_t capacity, int geom[])
 {
 	ips_ha_t *ha = (ips_ha_t *) sdev->host->hostdata;
-#endif
 	int heads;
 	int sectors;
 	int cylinders;
@@ -1225,70 +1192,6 @@ ips_biosparam(struct scsi_device *sdev, 
 	return (0);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-
-/* ips_proc24_info is a wrapper around ips_proc_info *
- * for compatibility with the 2.4 scsi parameters    */
-static int
-ips_proc24_info(char *buffer, char **start, off_t offset, int length,
-		              int hostno, int func)
-{
-	int i;
-
-	for (i = 0; i < ips_next_controller; i++) {
-		if (ips_sh[i] && ips_sh[i]->host_no == hostno) {
-			return ips_proc_info(ips_sh[i], buffer, start,
-					     offset, length, func);
-		}
-	}
-	return -EINVAL;	
-}
-
-/****************************************************************************/
-/*                                                                          */
-/* Routine Name: ips_select_queue_depth                                     */
-/*                                                                          */
-/* Routine Description:                                                     */
-/*                                                                          */
-/*   Select queue depths for the devices on the contoller                   */
-/*                                                                          */
-/****************************************************************************/
-static void
-ips_select_queue_depth(struct Scsi_Host *host, struct scsi_device * scsi_devs)
-{
-	struct scsi_device *device;
-	ips_ha_t *ha;
-	int count = 0;
-	int min;
-
-	ha = IPS_HA(host);
-	min = ha->max_cmds / 4;
-
-	for (device = scsi_devs; device; device = device->next) {
-		if (device->host == host) {
-			if ((device->channel == 0) && (device->type == 0))
-				count++;
-		}
-	}
-
-	for (device = scsi_devs; device; device = device->next) {
-		if (device->host == host) {
-			if ((device->channel == 0) && (device->type == 0)) {
-				device->queue_depth =
-				    (ha->max_cmds - 1) / count;
-				if (device->queue_depth < min)
-					device->queue_depth = min;
-			} else {
-				device->queue_depth = 2;
-			}
-
-			if (device->queue_depth < 2)
-				device->queue_depth = 2;
-		}
-	}
-}
-
-#else
 /****************************************************************************/
 /*                                                                          */
 /* Routine Name: ips_slave_configure                                        */
@@ -1316,7 +1219,6 @@ ips_slave_configure(struct scsi_device *
 	SDptr->skip_ms_page_3f = 1;
 	return 0;
 }
-#endif
 
 /****************************************************************************/
 /*                                                                          */
@@ -1331,7 +1233,6 @@ static irqreturn_t
 do_ipsintr(int irq, void *dev_id)
 {
 	ips_ha_t *ha;
-	unsigned long cpu_flags;
 	struct Scsi_Host *host;
 	int irqstatus;
 
@@ -1347,16 +1248,16 @@ do_ipsintr(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	IPS_LOCK_SAVE(host->host_lock, cpu_flags);
+	spin_lock(host->host_lock);
 
 	if (!ha->active) {
-		IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
+		spin_unlock(host->host_lock);
 		return IRQ_HANDLED;
 	}
 
 	irqstatus = (*ha->func.intr) (ha);
 
-	IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
+	spin_unlock(host->host_lock);
 
 	/* start the next command */
 	ips_next(ha, IPS_INTR_ON);
@@ -2730,7 +2631,6 @@ ips_next(ips_ha_t * ha, int intr)
 	struct scsi_cmnd *q;
 	ips_copp_wait_item_t *item;
 	int ret;
-	unsigned long cpu_flags = 0;
 	struct Scsi_Host *host;
 	METHOD_TRACE("ips_next", 1);
 
@@ -2742,7 +2642,7 @@ ips_next(ips_ha_t * ha, int intr)
 	 * this command won't time out
 	 */
 	if (intr == IPS_INTR_ON)
-		IPS_LOCK_SAVE(host->host_lock, cpu_flags);
+		spin_lock(host->host_lock);
 
 	if ((ha->subsys->param[3] & 0x300000)
 	    && (ha->scb_activelist.count == 0)) {
@@ -2769,14 +2669,14 @@ ips_next(ips_ha_t * ha, int intr)
 		item = ips_removeq_copp_head(&ha->copp_waitlist);
 		ha->num_ioctl++;
 		if (intr == IPS_INTR_ON)
-			IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
+			spin_unlock(host->host_lock);
 		scb->scsi_cmd = item->scsi_cmd;
 		kfree(item);
 
 		ret = ips_make_passthru(ha, scb->scsi_cmd, scb, intr);
 
 		if (intr == IPS_INTR_ON)
-			IPS_LOCK_SAVE(host->host_lock, cpu_flags);
+			spin_lock(host->host_lock);
 		switch (ret) {
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
@@ -2846,7 +2746,7 @@ ips_next(ips_ha_t * ha, int intr)
 		SC = ips_removeq_wait(&ha->scb_waitlist, q);
 
 		if (intr == IPS_INTR_ON)
-			IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);	/* Unlock HA after command is taken off queue */
+			spin_unlock(host->host_lock);	/* Unlock HA after command is taken off queue */
 
 		SC->result = DID_OK;
 		SC->host_scribble = NULL;
@@ -2919,7 +2819,7 @@ ips_next(ips_ha_t * ha, int intr)
 			scb->dcdb.transfer_length = 0;
 		}
 		if (intr == IPS_INTR_ON)
-			IPS_LOCK_SAVE(host->host_lock, cpu_flags);
+			spin_lock(host->host_lock);
 
 		ret = ips_send_cmd(ha, scb);
 
@@ -2958,7 +2858,7 @@ ips_next(ips_ha_t * ha, int intr)
 	}			/* end while */
 
 	if (intr == IPS_INTR_ON)
-		IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
+		spin_unlock(host->host_lock);
 }
 
 /****************************************************************************/
@@ -7004,7 +6904,6 @@ ips_register_scsi(int index)
 	kfree(oldha);
 	ips_sh[index] = sh;
 	ips_ha[index] = ha;
-	IPS_SCSI_SET_DEVICE(sh, ha);
 
 	/* Store away needed values for later use */
 	sh->io_port = ha->io_addr;
@@ -7016,17 +6915,16 @@ ips_register_scsi(int index)
 	sh->cmd_per_lun = sh->hostt->cmd_per_lun;
 	sh->unchecked_isa_dma = sh->hostt->unchecked_isa_dma;
 	sh->use_clustering = sh->hostt->use_clustering;
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
 	sh->max_sectors = 128;
-#endif
 
 	sh->max_id = ha->ntargets;
 	sh->max_lun = ha->nlun;
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	IPS_ADD_HOST(sh, NULL);
+	scsi_add_host(sh, NULL);
+	scsi_scan_host(sh);
+
 	return 0;
 }
 
@@ -7069,7 +6967,7 @@ ips_module_init(void)
 		return -ENODEV;
 	ips_driver_template.module = THIS_MODULE;
 	ips_order_controllers();
-	if (IPS_REGISTER_HOSTS(&ips_driver_template)) {
+	if (!ips_detect(&ips_driver_template)) {
 		pci_unregister_driver(&ips_pci_driver);
 		return -ENODEV;
 	}
@@ -7087,7 +6985,6 @@ ips_module_init(void)
 static void __exit
 ips_module_exit(void)
 {
-	IPS_UNREGISTER_HOSTS(&ips_driver_template);
 	pci_unregister_driver(&ips_pci_driver);
 	unregister_reboot_notifier(&ips_notifier);
 }
@@ -7443,15 +7340,9 @@ ips_init_phase2(int index)
 	return SUCCESS;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,9)
 MODULE_LICENSE("GPL");
-#endif
-
 MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING);
-
-#ifdef MODULE_VERSION
 MODULE_VERSION(IPS_VER_STRING);
-#endif
 
 
 /*
diff -puN drivers/scsi/ips.h~drivers-scsi-ipsc-remove-kernel-24-code drivers/scsi/ips.h
--- a/drivers/scsi/ips.h~drivers-scsi-ipsc-remove-kernel-24-code
+++ a/drivers/scsi/ips.h
@@ -58,10 +58,6 @@
    /*
     * Some handy macros
     */
-   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined CONFIG_HIGHIO
-      #define IPS_HIGHIO
-   #endif
-
    #define IPS_HA(x)                   ((ips_ha_t *) x->hostdata)
    #define IPS_COMMAND_ID(ha, scb)     (int) (scb - ha->scbs)
    #define IPS_IS_TROMBONE(ha)         (((ha->device_id == IPS_DEVICEID_COPPERHEAD) && \
@@ -84,38 +80,8 @@
     #define IPS_SGLIST_SIZE(ha)       (IPS_USE_ENH_SGLIST(ha) ? \
                                          sizeof(IPS_ENH_SG_LIST) : sizeof(IPS_STD_SG_LIST))
 
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,4)
-      #define pci_set_dma_mask(dev,mask) ( mask > 0xffffffff ? 1:0 )
-      #define scsi_set_pci_device(sh,dev) (0)
-   #endif
-
-   #ifndef IRQ_NONE
-      typedef void irqreturn_t;
-      #define IRQ_NONE
-      #define IRQ_HANDLED
-      #define IRQ_RETVAL(x)
-   #endif
-   
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-      #define IPS_REGISTER_HOSTS(SHT)      scsi_register_module(MODULE_SCSI_HA,SHT)
-      #define IPS_UNREGISTER_HOSTS(SHT)    scsi_unregister_module(MODULE_SCSI_HA,SHT)
-      #define IPS_ADD_HOST(shost,device)
-      #define IPS_REMOVE_HOST(shost)
-      #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_pci_device(sh, (ha)->pcidev)
-      #define IPS_PRINTK(level, pcidev, format, arg...)                 \
-            printk(level "%s %s:" format , "ips" ,     \
-            (pcidev)->slot_name , ## arg)
-      #define scsi_host_alloc(sh,size)         scsi_register(sh,size)
-      #define scsi_host_put(sh)             scsi_unregister(sh)
-   #else
-      #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))
-      #define IPS_UNREGISTER_HOSTS(SHT)
-      #define IPS_ADD_HOST(shost,device)   do { scsi_add_host(shost,device); scsi_scan_host(shost); } while (0)
-      #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)
-      #define IPS_SCSI_SET_DEVICE(sh,ha)   do { } while (0)
-      #define IPS_PRINTK(level, pcidev, format, arg...)                 \
+  #define IPS_PRINTK(level, pcidev, format, arg...)                 \
             dev_printk(level , &((pcidev)->dev) , format , ## arg)
-   #endif
 
    #define MDELAY(n)			\
 	do {				\
@@ -134,7 +100,7 @@
    #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
 
-   #if (BITS_PER_LONG > 32) || (defined CONFIG_HIGHMEM64G && defined IPS_HIGHIO)
+   #if (BITS_PER_LONG > 32) || defined(CONFIG_HIGHMEM64G)
       #define IPS_ENABLE_DMA64        (1)
    #else
       #define IPS_ENABLE_DMA64        (0)
@@ -451,16 +417,10 @@
    /*
     * Scsi_Host Template
     */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-   static int ips_proc24_info(char *, char **, off_t, int, int, int);
-   static void ips_select_queue_depth(struct Scsi_Host *, struct scsi_device *);
-   static int ips_biosparam(Disk *disk, kdev_t dev, int geom[]);
-#else
    static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
    static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int geom[]);
    static int ips_slave_configure(struct scsi_device *SDptr);
-#endif
 
 /*
  * Raid Command Formats
_
