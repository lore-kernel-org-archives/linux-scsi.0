From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] scsi: remove LINUX_VERSION_CODE macro usage from ips
Date: Sat, 14 Jan 2006 18:57:19 +0200
Message-ID: <1137257840.9318.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:23719 "EHLO
	mail.cs.helsinki.fi") by vger.kernel.org with ESMTP
	id S1750940AbWANQ5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 11:57:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes LINUX_VERSION_CODE macro usage from the ips driver in
drivers/scsi/.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 drivers/scsi/ips.c |  103 -----------------------------------------------------
 drivers/scsi/ips.h |   46 +++++------------------
 2 files changed, 11 insertions(+), 138 deletions(-)

Index: 2.6/drivers/scsi/ips.c
===================================================================
--- 2.6.orig/drivers/scsi/ips.c
+++ 2.6/drivers/scsi/ips.c
@@ -184,11 +184,7 @@
 
 #include "scsi.h"
 
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
-#include "hosts.h"
-#else
 #include <scsi/scsi_host.h>
-#endif
 
 #include "ips.h"
 
@@ -217,18 +213,8 @@ module_param(ips, charp, 0);
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
 #define IPS_LOCK_SAVE(lock,flags) do{spin_lock(lock);(void)flags;}while(0)
 #define IPS_UNLOCK_RESTORE(lock,flags) do{spin_unlock(lock);(void)flags;}while(0)
-#endif
 
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
                          DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
@@ -385,24 +371,13 @@ static struct scsi_host_template ips_dri
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
 
 
@@ -1185,17 +1160,10 @@ ips_queue(Scsi_Cmnd * SC, void (*done) (
 /*                                                                          */
 /****************************************************************************/
 static int
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-ips_biosparam(Disk * disk, kdev_t dev, int geom[])
-{
-	ips_ha_t *ha = (ips_ha_t *) disk->device->host->hostdata;
-	unsigned long capacity = disk->capacity;
-#else
 ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 	      sector_t capacity, int geom[])
 {
 	ips_ha_t *ha = (ips_ha_t *) sdev->host->hostdata;
-#endif
 	int heads;
 	int sectors;
 	int cylinders;
@@ -1233,70 +1201,6 @@ ips_biosparam(struct scsi_device *sdev, 
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
@@ -1321,7 +1225,6 @@ ips_slave_configure(struct scsi_device *
 	}
 	return 0;
 }
-#endif
 
 /****************************************************************************/
 /*                                                                          */
@@ -7025,10 +6928,7 @@ ips_register_scsi(int index)
 	sh->unchecked_isa_dma = sh->hostt->unchecked_isa_dma;
 	sh->use_clustering = sh->hostt->use_clustering;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
 	sh->max_sectors = 128;
-#endif
-
 	sh->max_id = ha->ntargets;
 	sh->max_lun = ha->nlun;
 	sh->max_channel = ha->nbus - 1;
@@ -7451,10 +7351,7 @@ ips_init_phase2(int index)
 	return SUCCESS;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,9)
 MODULE_LICENSE("GPL");
-#endif
-
 MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING);
 
 #ifdef MODULE_VERSION
Index: 2.6/drivers/scsi/ips.h
===================================================================
--- 2.6.orig/drivers/scsi/ips.h
+++ 2.6/drivers/scsi/ips.h
@@ -57,7 +57,7 @@
    /*
     * Some handy macros
     */
-   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined CONFIG_HIGHIO
+   #if defined CONFIG_HIGHIO
       #define IPS_HIGHIO
    #endif
 
@@ -83,11 +83,6 @@
     #define IPS_SGLIST_SIZE(ha)       (IPS_USE_ENH_SGLIST(ha) ? \
                                          sizeof(IPS_ENH_SG_LIST) : sizeof(IPS_STD_SG_LIST))
 
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,4)
-      #define pci_set_dma_mask(dev,mask) ( mask > 0xffffffff ? 1:0 )
-      #define scsi_set_pci_device(sh,dev) (0)
-   #endif
-
    #ifndef IRQ_NONE
       typedef void irqreturn_t;
       #define IRQ_NONE
@@ -95,26 +90,13 @@
       #define IRQ_RETVAL(x)
    #endif
    
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
-            dev_printk(level , &((pcidev)->dev) , format , ## arg)
-   #endif
+   #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))
+   #define IPS_UNREGISTER_HOSTS(SHT)
+   #define IPS_ADD_HOST(shost,device)   do { scsi_add_host(shost,device); scsi_scan_host(shost); } while (0)
+   #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)
+   #define IPS_SCSI_SET_DEVICE(sh,ha)   do { } while (0)
+   #define IPS_PRINTK(level, pcidev, format, arg...)                 \
+         dev_printk(level , &((pcidev)->dev) , format , ## arg)
 
    #ifndef MDELAY
       #define MDELAY mdelay
@@ -448,16 +430,10 @@
    /*
     * Scsi_Host Template
     */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-   static int ips_proc24_info(char *, char **, off_t, int, int, int);
-   static void ips_select_queue_depth(struct Scsi_Host *, struct scsi_device *);
-   static int ips_biosparam(Disk *disk, kdev_t dev, int geom[]);
-#else
-   static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
-   static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
+static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int geom[]);
-   static int ips_slave_configure(struct scsi_device *SDptr);
-#endif
+static int ips_slave_configure(struct scsi_device *SDptr);
 
 /*
  * Raid Command Formats


