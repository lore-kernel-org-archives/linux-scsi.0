From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC] [PATCH 5/9] drivers/scsi/ips.c Removal of old scsi code
Date: Sat, 12 Aug 2006 23:02:50 +0200
Message-ID: <44DE41FA.7010405@gmail.com>
References: <44DE3E5E.3020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:28050 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1422694AbWHLVCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 17:02:15 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1295188nfc
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 14:02:14 -0700 (PDT)
In-Reply-To: <44DE3E5E.3020605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, ipslinux@adaptec.com

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/ips.c linux-work/drivers/scsi/ips.c
--- linux-work-clean/drivers/scsi/ips.c	2006-08-12 01:51:16.000000000 +0200
+++ linux-work/drivers/scsi/ips.c	2006-08-12 21:52:02.000000000 +0200
@@ -185,11 +185,7 @@

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
@@ -1324,7 +1228,6 @@ ips_slave_configure(struct scsi_device *
 	SDptr->skip_ms_page_3f = 1;
 	return 0;
 }
-#endif

 /****************************************************************************/
 /*                                                                          */
@@ -7029,11 +6932,7 @@ ips_register_scsi(int index)
 	sh->cmd_per_lun = sh->hostt->cmd_per_lun;
 	sh->unchecked_isa_dma = sh->hostt->unchecked_isa_dma;
 	sh->use_clustering = sh->hostt->use_clustering;
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
 	sh->max_sectors = 128;
-#endif
-
 	sh->max_id = ha->ntargets;
 	sh->max_lun = ha->nlun;
 	sh->max_channel = ha->nbus - 1;
@@ -7456,10 +7355,7 @@ ips_init_phase2(int index)
 	return SUCCESS;
 }

-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,9)
 MODULE_LICENSE("GPL");
-#endif
-
 MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING);

 #ifdef MODULE_VERSION

