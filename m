From: Jes Sorensen <jes@sgi.com>
Subject: [patch] qla1280.c - remove < 2.6.0 support
Date: 16 Jan 2006 11:49:29 -0500
Message-ID: <yq0acdwt8x2.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:15550 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1751026AbWAPQtc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 11:49:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Another round of house keeping - I think it's a reasonable time to
ditch support for kernels older than 2.6.0 in the qla1280 driver.

Cheers,
Jes

Remove support for kernels older than 2.6.0.

Signed-off-by: Jes Sorensen <jes@sgi.com>

----

 drivers/scsi/qla1280.c |  311 +++----------------------------------------------
 1 files changed, 23 insertions(+), 288 deletions(-)

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c
+++ linux-2.6/drivers/scsi/qla1280.c
@@ -17,9 +17,11 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.25"
+#define QLA1280_VERSION      "3.26"
 /*****************************************************************************
     Revision History:
+    Rev  3.26, January 16, 2006 Jes Sorensen
+	- Ditch all < 2.6 support
     Rev  3.25.1, February 10, 2005 Christoph Hellwig
 	- use pci_map_single to map non-S/G requests
 	- remove qla1280_proc_info
@@ -356,25 +358,18 @@
 #include <asm/types.h>
 #include <asm/system.h>
 
-#if LINUX_VERSION_CODE >= 0x020545
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
-#else
-#include <linux/blk.h>
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-#include "sd.h"
-#endif
 
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 #include <asm/sn/io.h>
 #endif
 
-#if LINUX_VERSION_CODE < 0x020407
-#error "Kernels older than 2.4.7 are no longer supported"
+#if LINUX_VERSION_CODE < 0x020600
+#error "Kernels older than 2.6.0 are no longer supported"
 #endif
 
 
@@ -441,52 +436,6 @@
 
 #define NVRAM_DELAY()			udelay(500)	/* 2 microseconds */
 
-#if LINUX_VERSION_CODE < 0x020500
-#define HOST_LOCK			&io_request_lock
-#define irqreturn_t			void
-#define IRQ_RETVAL(foo)
-#define MSG_ORDERED_TAG			1
-
-#define DMA_BIDIRECTIONAL	SCSI_DATA_UNKNOWN
-#define DMA_TO_DEVICE		SCSI_DATA_WRITE
-#define DMA_FROM_DEVICE		SCSI_DATA_READ
-#define DMA_NONE		SCSI_DATA_NONE
-
-#ifndef HAVE_SECTOR_T
-typedef unsigned int sector_t;
-#endif
-
-static inline void
-scsi_adjust_queue_depth(struct scsi_device *device, int tag, int depth)
-{
-	if (tag) {
-		device->tagged_queue = tag;
-		device->current_tag = 0;
-	}
-	device->queue_depth = depth;
-}
-static inline struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *t, size_t s)
-{
-	return scsi_register(t, s);
-}
-static inline void scsi_host_put(struct Scsi_Host *h)
-{
-	scsi_unregister(h);
-}
-#else
-#define HOST_LOCK			ha->host->host_lock
-#endif
-#if LINUX_VERSION_CODE < 0x020600
-#define DEV_SIMPLE_TAGS(device)		device->tagged_queue
-/*
- * Hack around that qla1280_remove_one is called from
- * qla1280_release in 2.4
- */
-#undef __devexit
-#define __devexit
-#else
-#define DEV_SIMPLE_TAGS(device)		device->simple_tags
-#endif
 #if defined(__ia64__) && !defined(ia64_platform_is)
 #define ia64_platform_is(foo)		(!strcmp(x, platform_name))
 #endif
@@ -506,9 +455,6 @@
  *  QLogic Driver Support Function Prototypes.
  */
 static void qla1280_done(struct scsi_qla_host *);
-#if LINUX_VERSION_CODE < 0x020545
-static void qla1280_get_target_options(struct scsi_cmnd *, struct scsi_qla_host *);
-#endif
 static int qla1280_get_token(char *);
 static int qla1280_setup(char *s) __init;
 
@@ -610,11 +556,7 @@
 #define	CMD_SNSLEN(Cmnd)	sizeof(Cmnd->sense_buffer)
 #define	CMD_RESULT(Cmnd)	Cmnd->result
 #define	CMD_HANDLE(Cmnd)	Cmnd->host_scribble
-#if LINUX_VERSION_CODE < 0x020545
-#define CMD_REQUEST(Cmnd)	Cmnd->request.cmd
-#else
 #define CMD_REQUEST(Cmnd)	Cmnd->request->cmd
-#endif
 
 #define CMD_HOST(Cmnd)		Cmnd->device->host
 #define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
@@ -1064,10 +1006,10 @@
 	add_timer(&timer);
 
 	/* wait for the action to complete (or the timer to expire) */
-	spin_unlock_irq(HOST_LOCK);
+	spin_unlock_irq(ha->host->host_lock);
 	wait_for_completion(&wait);
 	del_timer_sync(&timer);
-	spin_lock_irq(HOST_LOCK);
+	spin_lock_irq(ha->host->host_lock);
 	sp->wait = NULL;
 
 	/* the only action we might get a fail for is abort */
@@ -1173,96 +1115,6 @@
 	return 0;
 }
 
-#if LINUX_VERSION_CODE < 0x020600
-static int
-qla1280_detect(struct scsi_host_template *template)
-{
-	struct pci_device_id *id = &qla1280_pci_tbl[0];
-	struct pci_dev *pdev = NULL;
-	int num_hosts = 0;
-
-	if (sizeof(struct srb) > sizeof(Scsi_Pointer)) {
-		printk(KERN_WARNING
-		       "qla1280: struct srb too big, aborting\n");
-		return 0;
-	}
-
-	if ((DMA_BIDIRECTIONAL != PCI_DMA_BIDIRECTIONAL) ||
-	    (DMA_TO_DEVICE != PCI_DMA_TODEVICE) ||
-	    (DMA_FROM_DEVICE != PCI_DMA_FROMDEVICE) ||
-	    (DMA_NONE != PCI_DMA_NONE)) {
-		printk(KERN_WARNING
-		       "qla1280: dma direction bits don't match\n");
-		return 0;
-	}
-
-#ifdef MODULE
-	/*
-	 * If we are called as a module, the qla1280 pointer may not be null
-	 * and it would point to our bootup string, just like on the lilo
-	 * command line.  IF not NULL, then process this config string with
-	 * qla1280_setup
-	 *
-	 * Boot time Options
-	 * To add options at boot time add a line to your lilo.conf file like:
-	 * append="qla1280=verbose,max_tags:{{255,255,255,255},{255,255,255,255}}"
-	 * which will result in the first four devices on the first two
-	 * controllers being set to a tagged queue depth of 32.
-	 */
-	if (qla1280)
-		qla1280_setup(qla1280);
-#endif
-
-	/* First Initialize QLA12160 on PCI Bus 1 Dev 2 */
-	while ((pdev = pci_find_device(id->vendor, id->device, pdev))) {
-		if (pdev->bus->number == 1 && PCI_SLOT(pdev->devfn) == 2) {
-			if (!qla1280_probe_one(pdev, id))
-				num_hosts++;
-		}
-	}
-
-	pdev = NULL;
-	/* Try and find each different type of adapter we support */
-	for (id = &qla1280_pci_tbl[0]; id->device; id++) {
-		while ((pdev = pci_find_device(id->vendor, id->device, pdev))) {
-			/*
-			 * skip QLA12160 already initialized on
-			 * PCI Bus 1 Dev 2 since we already initialized
-			 * and presented it
-			 */
-			if (id->device == PCI_DEVICE_ID_QLOGIC_ISP12160 &&
-			    pdev->bus->number == 1 &&
-			    PCI_SLOT(pdev->devfn) == 2)
-				continue;
-
-			if (!qla1280_probe_one(pdev, id))
-				num_hosts++;
-		}
-	}
-
-	return num_hosts;
-}
-
-/*
- * This looks a bit ugly as we could just pass down host to
- * qla1280_remove_one, but I want to keep qla1280_release purely a wrapper
- * around pci_driver::remove as used from 2.6 onwards.
- */
-static int
-qla1280_release(struct Scsi_Host *host)
-{
-	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
-
-	qla1280_remove_one(ha->pdev);
-	return 0;
-}
-
-static int
-qla1280_biosparam_old(Disk * disk, kdev_t dev, int geom[])
-{
-	return qla1280_biosparam(disk->device, NULL, disk->capacity, geom);
-}
-#endif
  
 /* disable risc and host interrupts */
 static inline void
@@ -1295,7 +1147,7 @@
 	ENTER_INTR ("qla1280_intr_handler");
 	ha = (struct scsi_qla_host *)dev_id;
 
-	spin_lock(HOST_LOCK);
+	spin_lock(ha->host->host_lock);
 
 	ha->isr_count++;
 	reg = ha->iobase;
@@ -1311,7 +1163,7 @@
 	if (!list_empty(&ha->done_q))
 		qla1280_done(ha);
 
-	spin_unlock(HOST_LOCK);
+	spin_unlock(ha->host->host_lock);
 
 	qla1280_enable_intrs(ha);
 
@@ -1411,11 +1263,9 @@
 		scsi_adjust_queue_depth(device, 0, default_depth);
 	}
 
-#if LINUX_VERSION_CODE > 0x020500
 	nv->bus[bus].target[target].parameter.enable_sync = device->sdtr;
 	nv->bus[bus].target[target].parameter.enable_wide = device->wdtr;
 	nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr = device->ppr;
-#endif
 
 	if (driver_setup.no_sync ||
 	    (driver_setup.sync_mask &&
@@ -1432,38 +1282,14 @@
 			nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 0;
 	}
 
-	spin_lock_irqsave(HOST_LOCK, flags);
+	spin_lock_irqsave(ha->host->host_lock, flags);
 	if (nv->bus[bus].target[target].parameter.enable_sync)
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
-	spin_unlock_irqrestore(HOST_LOCK, flags);
+	spin_unlock_irqrestore(ha->host->host_lock, flags);
 	return status;
 }
 
-#if LINUX_VERSION_CODE < 0x020545
-/**************************************************************************
- *   qla1280_select_queue_depth
- *
- *   Sets the queue depth for each SCSI device hanging off the input
- *   host adapter.  We use a queue depth of 2 for devices that do not
- *   support tagged queueing.
- **************************************************************************/
-static void
-qla1280_select_queue_depth(struct Scsi_Host *host, struct scsi_device *sdev_q)
-{
-	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
-	struct scsi_device *sdev;
-
-	ENTER("qla1280_select_queue_depth");
-	for (sdev = sdev_q; sdev; sdev = sdev->next)
-		if (sdev->host == host)
-			qla1280_slave_configure(sdev);
-
-	if (sdev_q)
-		qla1280_check_for_dead_scsi_bus(ha, sdev_q->channel);
-	LEAVE("qla1280_select_queue_depth");
-}
-#endif
 
 /*
  * qla1280_done
@@ -1523,10 +1349,6 @@
 		CMD_HANDLE(sp->cmd) = (unsigned char *)INVALID_HANDLE;
 		ha->actthreads--;
 
-#if LINUX_VERSION_CODE < 0x020500
-		if (cmd->cmnd[0] == INQUIRY)
-			qla1280_get_target_options(cmd, ha);
-#endif
 		(*(cmd)->scsi_done)(cmd);
 
 		if(sp->wait != NULL)
@@ -1655,9 +1477,7 @@
 	struct device_reg __iomem *reg;
 	int status;
 	int bus;
-#if LINUX_VERSION_CODE > 0x020500
 	unsigned long flags;
-#endif
 
 	ENTER("qla1280_initialize_adapter");
 
@@ -1695,15 +1515,12 @@
 			"NVRAM\n");
 	}
 
-#if LINUX_VERSION_CODE >= 0x020500
 	/*
 	 * It's necessary to grab the spin here as qla1280_mailbox_command
 	 * needs to be able to drop the lock unconditionally to wait
 	 * for completion.
-	 * In 2.4 ->detect is called with the io_request_lock held.
 	 */
-	spin_lock_irqsave(HOST_LOCK, flags);
-#endif
+	spin_lock_irqsave(ha->host->host_lock, flags);
 
 	status = qla1280_load_firmware(ha);
 	if (status) {
@@ -1735,9 +1552,8 @@
 
 	ha->flags.online = 1;
  out:
-#if LINUX_VERSION_CODE >= 0x020500
-	spin_unlock_irqrestore(HOST_LOCK, flags);
-#endif
+	spin_unlock_irqrestore(ha->host->host_lock, flags);
+
 	if (status)
 		dprintk(2, "qla1280_initialize_adapter: **** FAILED ****\n");
 
@@ -2650,14 +2466,14 @@
 	timer.function = qla1280_mailbox_timeout;
 	add_timer(&timer);
 
-	spin_unlock_irq(HOST_LOCK);
+	spin_unlock_irq(ha->host->host_lock);
 	WRT_REG_WORD(&reg->host_cmd, HC_SET_HOST_INT);
 	data = qla1280_debounce_register(&reg->istatus);
 
 	wait_for_completion(&wait);
 	del_timer_sync(&timer);
 
-	spin_lock_irq(HOST_LOCK);
+	spin_lock_irq(ha->host->host_lock);
 
 	ha->mailbox_wait = NULL;
 
@@ -2770,9 +2586,9 @@
 			ha->bus_settings[bus].scsi_bus_dead = 1;
 		ha->bus_settings[bus].failed_reset_count++;
 	} else {
-		spin_unlock_irq(HOST_LOCK);
+		spin_unlock_irq(ha->host->host_lock);
 		ssleep(reset_delay);
-		spin_lock_irq(HOST_LOCK);
+		spin_lock_irq(ha->host->host_lock);
 
 		ha->bus_settings[bus].scsi_bus_dead = 0;
 		ha->bus_settings[bus].failed_reset_count = 0;
@@ -3078,7 +2894,7 @@
 		(SCSI_TCN_32(cmd) | BIT_7) : SCSI_TCN_32(cmd);
 
 	/* Enable simple tag queuing if device supports it. */
-	if (DEV_SIMPLE_TAGS(cmd->device))
+	if (cmd->device->simple_tags)
 		pkt->control_flags |= cpu_to_le16(BIT_3);
 
 	/* Load SCSI command packet. */
@@ -3377,7 +3193,7 @@
 		(SCSI_TCN_32(cmd) | BIT_7) : SCSI_TCN_32(cmd);
 
 	/* Enable simple tag queuing if device supports it. */
-	if (DEV_SIMPLE_TAGS(cmd->device))
+	if (cmd->device->simple_tags)
 		pkt->control_flags |= cpu_to_le16(BIT_3);
 
 	/* Load SCSI command packet. */
@@ -3889,50 +3705,6 @@
 }
 
 
-#if LINUX_VERSION_CODE < 0x020500
-/*
- *
- */
-static void
-qla1280_get_target_options(struct scsi_cmnd *cmd, struct scsi_qla_host *ha)
-{
-	unsigned char *result;
-	struct nvram *n;
-	int bus, target, lun;
-
-	bus = SCSI_BUS_32(cmd);
-	target = SCSI_TCN_32(cmd);
-	lun = SCSI_LUN_32(cmd);
-
-	/*
-	 * Make sure to not touch anything if someone is using the
-	 * sg interface.
-	 */
-	if (cmd->use_sg || (CMD_RESULT(cmd) >> 16) != DID_OK || lun)
-		return;
-
-	result = cmd->request_buffer;
-	n = &ha->nvram;
-
-	n->bus[bus].target[target].parameter.enable_wide = 0;
-	n->bus[bus].target[target].parameter.enable_sync = 0;
-	n->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 0;
-
-        if (result[7] & 0x60)
-		n->bus[bus].target[target].parameter.enable_wide = 1;
-        if (result[7] & 0x10)
-		n->bus[bus].target[target].parameter.enable_sync = 1;
-	if ((result[2] >= 3) && (result[4] + 5 > 56) &&
-	    (result[56] & 0x4))
-		n->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 1;
-
-	dprintk(2, "get_target_options(): wide %i, sync %i, ppr %i\n",
-		n->bus[bus].target[target].parameter.enable_wide,
-		n->bus[bus].target[target].parameter.enable_sync,
-		n->bus[bus].target[target].ppr_1x160.flags.enable_ppr);
-}
-#endif
-
 /*
  *  qla1280_status_entry
  *      Processes received ISP status entry.
@@ -4271,7 +4043,7 @@
 	} else
 		printk(" Async");
 
-	if (DEV_SIMPLE_TAGS(device))
+	if (device->simple_tags)
 		printk(", Tagged queuing: depth %d", device->queue_depth);
 	printk("\n");
 }
@@ -4485,7 +4257,7 @@
 	return ret;
 }
 
-#if LINUX_VERSION_CODE >= 0x020600
+
 static struct scsi_host_template qla1280_driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "qla1280",
@@ -4504,27 +4276,7 @@
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-#else
-static struct scsi_host_template qla1280_driver_template = {
-	.proc_name		= "qla1280",
-	.name			= "Qlogic ISP 1280/12160",
-	.detect			= qla1280_detect,
-	.release		= qla1280_release,
-	.info			= qla1280_info,
-	.queuecommand		= qla1280_queuecommand,
-	.eh_abort_handler	= qla1280_eh_abort,
-	.eh_device_reset_handler= qla1280_eh_device_reset,
-	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
-	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
-	.bios_param		= qla1280_biosparam_old,
-	.can_queue		= 0xfffff,
-	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
-	.use_clustering		= ENABLE_CLUSTERING,
-	.use_new_eh_code	= 1,
-};
-#endif
+
 
 static int __devinit
 qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -4615,10 +4367,6 @@
 	host->max_sectors = 1024;
 	host->unique_id = host->host_no;
 
-#if LINUX_VERSION_CODE < 0x020545
-	host->select_queue_depths = qla1280_select_queue_depth;
-#endif
-
 	error = -ENODEV;
 
 #if MEMORY_MAPPED_IO
@@ -4666,21 +4414,15 @@
 
 	pci_set_drvdata(pdev, host);
 
-#if LINUX_VERSION_CODE >= 0x020600
 	error = scsi_add_host(host, &pdev->dev);
 	if (error)
 		goto error_disable_adapter;
 	scsi_scan_host(host);
-#else
-	scsi_set_pci_device(host, pdev);
-#endif
 
 	return 0;
 
-#if LINUX_VERSION_CODE >= 0x020600
  error_disable_adapter:
 	qla1280_disable_intrs(ha);
-#endif
  error_free_irq:
 	free_irq(pdev->irq, ha);
  error_release_region:
@@ -4712,9 +4454,7 @@
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
 
-#if LINUX_VERSION_CODE >= 0x020600
 	scsi_remove_host(host);
-#endif
 
 	qla1280_disable_intrs(ha);
 
@@ -4738,7 +4478,6 @@
 	scsi_host_put(host);
 }
 
-#if LINUX_VERSION_CODE >= 0x020600
 static struct pci_driver qla1280_pci_driver = {
 	.name		= "qla1280",
 	.id_table	= qla1280_pci_tbl,
@@ -4784,10 +4523,6 @@
 module_init(qla1280_init);
 module_exit(qla1280_exit);
 
-#else
-# define driver_template qla1280_driver_template
-# include "scsi_module.c"
-#endif
 
 MODULE_AUTHOR("Qlogic & Jes Sorensen");
 MODULE_DESCRIPTION("Qlogic ISP SCSI (qla1x80/qla1x160) driver");
