From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] bring lost 2.5 changes to qla1280 back
Date: Sat, 20 Sep 2003 11:27:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920092738.GA20910@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:10222 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261758AbTITJ1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 05:27:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org


--- 1.47/drivers/scsi/qla1280.c	Tue Sep  2 18:55:00 2003
+++ edited/drivers/scsi/qla1280.c	Sat Sep 20 11:16:01 2003
@@ -16,9 +16,11 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.23.35"
+#define QLA1280_VERSION      "3.23.36"
 /*****************************************************************************
     Revision History:
+    Rev  3.23.36 September 19, 2003, Christoph Hellwig
+	- Reintegrate lost fixes from Linux 2.5
     Rev  3.23.35 August 14, 2003, Jes Sorensen
 	- Build against 2.6
     Rev  3.23.34 July 23, 2003, Jes Sorensen
@@ -152,8 +154,8 @@
 	- Provide compat macros for pci_enable_device(), pci_find_subsys()
 	  and scsi_set_pci_device()
 	- Call scsi_set_pci_device() for all devices
-	- Reduce size of kernel version dependant device probe code
-	- Move duplicate probe/init code to seperate function
+	- Reduce size of kernel version dependent device probe code
+	- Move duplicate probe/init code to separate function
 	- Handle error if qla1280_mem_alloc() fails
 	- Kill OFFSET() macro and use Linux's PCI definitions instead
         - Kill private structure defining PCI config space (struct config_reg)
@@ -311,14 +313,15 @@
 #include <asm/types.h>
 #include <asm/system.h>
 
-#if LINUX_VERSION_CODE < 0x020545
+#if LINUX_VERSION_CODE >= 0x020545
+#include <scsi/scsi_host.h>
+#else
 #include <linux/blk.h>
+#include "hosts.h"
 #include "sd.h"
-#else
-#include <scsi/scsi_host.h>
 #endif
+
 #include "scsi.h"
-#include "hosts.h"
 
 #if LINUX_VERSION_CODE < 0x020407
 #error "Kernels older than 2.4.7 are no longer supported"
@@ -423,13 +426,13 @@
 static int qla1280_slave_configure(Scsi_Device *);
 #if LINUX_VERSION_CODE < 0x020545
 static void qla1280_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
-void qla1280_get_target_options(struct scsi_cmnd *, struct scsi_qla_host *);
+static void qla1280_get_target_options(struct scsi_cmnd *, struct scsi_qla_host *);
 #endif
 
 static int qla1280_return_status(struct response * sts, Scsi_Cmnd * cp);
 static void qla1280_mem_free(struct scsi_qla_host *ha);
-void qla1280_do_dpc(void *p);
 static int qla1280_get_token(char *);
+static int qla1280_setup(char *s) __init;
 static inline void qla1280_enable_intrs(struct scsi_qla_host *);
 static inline void qla1280_disable_intrs(struct scsi_qla_host *);
 
@@ -644,10 +647,10 @@
 #define	PROC_BUF	&qla1280_buffer[len]
 
 #if LINUX_VERSION_CODE < 0x020600
-int qla1280_proc_info(char *buffer, char **start, off_t offset, int length,
+static int qla1280_proc_info(char *buffer, char **start, off_t offset, int length,
 		      int hostno, int inout)
 #else
-int qla1280_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+static int qla1280_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 		      off_t offset, int length, int inout)
 #endif
 {
@@ -882,9 +885,6 @@
 	printk(KERN_INFO "qla1280: %s found on PCI bus %i, dev %i\n",
 	       bdp->name, pdev->bus->number, PCI_SLOT(pdev->devfn));
 
-#if LINUX_VERSION_CODE >= 0x020545
-	template->slave_configure = qla1280_slave_configure;
-#endif
 	host = scsi_register(template, sizeof(struct scsi_qla_host));
 	if (!host) {
 		printk(KERN_WARNING
@@ -910,7 +910,7 @@
 
 	if (qla1280_mem_alloc(ha)) {
 		printk(KERN_INFO "qla1x160: Failed to get memory\n");
-		goto error;
+		goto error_scsi_unregister;
 	}
 
 	ha->ports = bdp->numPorts;
@@ -945,25 +945,22 @@
 			"qla1280", ha)) {
 		printk("qla1280 : Failed to reserve interrupt %d already "
 		       "in use\n", host->irq);
-		goto error_mem_alloced;
+		goto error_iounmap;
 	}
 #if !MEMORY_MAPPED_IO
 	/* Register the I/O space with Linux */
-	if (check_region(host->io_port, 0xff)) {
+	if (!request_region(host->io_port, 0xff, "qla1280")) {
 		printk("qla1280: Failed to reserve i/o region 0x%04lx-0x%04lx"
 		       " already in use\n",
 		       host->io_port, host->io_port + 0xff);
-		free_irq(host->irq, ha);
-		goto error_mem_alloced;
+		goto error_free_irq;
 	}
 
-	request_region(host->io_port, 0xff, "qla1280");
 #endif
-
 	/* load the F/W, read paramaters, and init the H/W */
 	if (qla1280_initialize_adapter(ha)) {
 		printk(KERN_INFO "qla1x160: Failed to initialize adapter\n");
-		goto error_mem_alloced;
+		goto error_release_region;
 	}
 
 	/* set our host ID  (need to do something about our two IDs) */
@@ -971,13 +968,22 @@
 
 	return host;
 
+ error_release_region:
+#if !MEMORY_MAPPED_IO
+	release_region(host->io_port, 0xff);
+ error_free_irq:
+#endif
+	free_irq(host->irq, ha);
+ error_iounmap:
+#if MEMORY_MAPPED_IO
+	if (ha->mmpbase)
+		iounmap((void *)(((unsigned long) ha->mmpbase) & PAGE_MASK));
+#endif
  error_mem_alloced:
 	qla1280_mem_free(ha);
-
+ error_scsi_unregister:
+	scsi_unregister(host);
  error:
-	if (host) {
-		scsi_unregister(host);
-	}
 	return NULL;
 }
 
@@ -995,7 +1001,7 @@
  * Returns:
  *  num - number of host adapters found.
  **************************************************************************/
-int
+static int
 qla1280_detect(Scsi_Host_Template * template)
 {
 	struct pci_dev *pdev = NULL;
@@ -1126,7 +1132,7 @@
  *   Free the passed in Scsi_Host memory structures prior to unloading the
  *   module.
  **************************************************************************/
-int
+static int
 qla1280_release(struct Scsi_Host *host)
 {
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
@@ -1162,7 +1168,7 @@
  *   qla1280_info
  *     Return a string describing the driver.
  **************************************************************************/
-const char *
+static const char *
 qla1280_info(struct Scsi_Host *host)
 {
 	static char qla1280_scsi_name_buffer[125];
@@ -1194,7 +1200,7 @@
  * handling).   Unfortunely, it sometimes calls the scheduler in interrupt
  * context which is a big NO! NO!.
  **************************************************************************/
-int
+static int
 qla1280_queuecommand(Scsi_Cmnd * cmd, void (*fn) (Scsi_Cmnd *))
 {
 	struct scsi_qla_host *ha;
@@ -1283,7 +1289,7 @@
  *      DEVICE RESET message - on the offending target before pulling
  *      the SCSI bus reset line.
  **************************************************************************/
-int
+static int
 qla1280_error_action(Scsi_Cmnd * cmd, enum action action)
 {
 	struct scsi_qla_host *ha;
@@ -1483,7 +1489,7 @@
  *   qla1280_abort
  *     Abort the specified SCSI command(s).
  **************************************************************************/
-int
+static int
 qla1280_eh_abort(struct scsi_cmnd * cmd)
 {
 	return qla1280_error_action(cmd, ABORT_COMMAND);
@@ -1493,7 +1499,7 @@
  *   qla1280_device_reset
  *     Reset the specified SCSI device
  **************************************************************************/
-int
+static int
 qla1280_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	return qla1280_error_action(cmd, DEVICE_RESET);
@@ -1503,7 +1509,7 @@
  *   qla1280_bus_reset
  *     Reset the specified bus.
  **************************************************************************/
-int
+static int
 qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	return qla1280_error_action(cmd, BUS_RESET);
@@ -1513,7 +1519,7 @@
  *   qla1280_adapter_reset
  *     Reset the specified adapter (both channels)
  **************************************************************************/
-int
+static int
 qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 {
 	return qla1280_error_action(cmd, ADAPTER_RESET);
@@ -1523,7 +1529,7 @@
  * qla1280_biosparam
  *   Return the disk geometry for the given SCSI device.
  **************************************************************************/
-int
+static int
 #if LINUX_VERSION_CODE < 0x020545
 qla1280_biosparam(Disk * disk, kdev_t dev, int geom[])
 #else
@@ -1594,36 +1600,6 @@
 	return IRQ_RETVAL(handled);
 }
 
-/**************************************************************************
- *   qla1280_do_dpc
- *
- * Description:
- * This routine is a task that is schedule by the interrupt handler
- * to perform the background processing for interrupts.  We put it
- * on a task queue that is consumed whenever the scheduler runs; that's
- * so you can do anything (i.e. put the process to sleep etc).  In fact, the
- * mid-level tries to sleep when it reaches the driver threshold
- * "host->can_queue". This can cause a panic if we were in our interrupt
- * code .
- **************************************************************************/
-void
-qla1280_do_dpc(void *p)
-{
-	struct scsi_qla_host *ha = (struct scsi_qla_host *) p;
-	unsigned long cpu_flags;
-
-	spin_lock_irqsave(HOST_LOCK, cpu_flags);
-
-	if (ha->flags.reset_marker)
-		qla1280_rst_aen(ha);
-
-	if (ha->done_q_first)
-		qla1280_done(ha, &ha->done_q_first, &ha->done_q_last);
-
-	spin_unlock_irqrestore(HOST_LOCK, cpu_flags);
-}
-
-
 static int
 qla12160_set_target_parameters(struct scsi_qla_host *ha, int bus, int target)
 {
@@ -4524,7 +4500,7 @@
 /*
  *
  */
-void
+static void
 qla1280_get_target_options(struct scsi_cmnd *cmd, struct scsi_qla_host *ha)
 {
 	unsigned char *result;
@@ -4849,11 +4825,6 @@
 	return ret;
 }
 
-
-static Scsi_Host_Template driver_template = QLA1280_LINUX_TEMPLATE;
-#include "scsi_module.c"
-
-
 /************************************************************************
  * qla1280_check_for_dead_scsi_bus                                      *
  *                                                                      *
@@ -4998,7 +4969,7 @@
  *   ql1280_dump_device
  *
  **************************************************************************/
-void
+static void
 ql1280_dump_device(struct scsi_qla_host *ha)
 {
 
@@ -5050,7 +5021,7 @@
  *   Handle boot parameters. This really needs to be changed so one
  *   can specify per adapter parameters.
  **************************************************************************/
-int __init
+static int __init
 qla1280_setup(char *s)
 {
 	char *cp, *ptr;
@@ -5136,6 +5107,32 @@
 	return ret;
 }
 
+static Scsi_Host_Template driver_template = {
+	.proc_info		= qla1280_proc_info,
+	.name			= "Qlogic ISP 1280/12160",
+	.detect			= qla1280_detect,
+	.release		= qla1280_release,
+	.info			= qla1280_info,
+	.queuecommand		= qla1280_queuecommand,
+#if LINUX_VERSION_CODE >= 0x020545
+	.slave_configure	= qla1280_slave_configure,
+#endif
+	.eh_abort_handler	= qla1280_eh_abort,
+	.eh_device_reset_handler= qla1280_eh_device_reset,
+	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
+	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
+	.bios_param		= qla1280_biosparam,
+	.can_queue		= 255,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 3,
+	.use_clustering		= ENABLE_CLUSTERING,
+#if LINUX_VERSION_CODE < 0x020545
+	.use_new_eh_code	= 1,
+#endif
+};
+
+#include "scsi_module.c"
 
 /*
  * Overrides for Emacs so that we almost follow Linus's tabbing style.
--- 1.21/drivers/scsi/qla1280.h	Fri Aug 15 01:08:54 2003
+++ edited/drivers/scsi/qla1280.h	Fri Sep 19 15:46:31 2003
@@ -20,8 +20,6 @@
 #ifndef	_IO_HBA_QLA1280_H	/* wrapper symbol for kernel use */
 #define	_IO_HBA_QLA1280_H	/* subject to change without notice */
 
-#ifndef HOSTS_C			/* included in hosts.c */
-
 /*
  * Data bit definitions.
  */
@@ -1105,68 +1103,5 @@
  */
 #define SUBDEV(b, t, l)		((b << (MAX_T_BITS + MAX_L_BITS)) | (t << MAX_L_BITS) | l)
 #define LU_Q(ha, b, t, l)	(ha->dev[SUBDEV(b, t, l)])
-
-#endif				/* HOSTS_C */
-
-/*
- *  Linux - SCSI Driver Interface Function Prototypes.
- */
-#if LINUX_VERSION_CODE < 0x020600
-int qla1280_proc_info(char *, char **, off_t, int, int, int);
-#else
-int qla1280_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
-#endif
-const char *qla1280_info(struct Scsi_Host *host);
-int qla1280_detect(Scsi_Host_Template *);
-int qla1280_release(struct Scsi_Host *);
-int qla1280_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-#if LINUX_VERSION_CODE < 0x020545
-int qla1280_biosparam(Disk *, kdev_t, int[]);
-#else
-int qla1280_biosparam(struct scsi_device *, struct block_device *,
-		      sector_t, int *);
-#endif
-int __init qla1280_setup(char *s);
-int qla1280_eh_abort(struct scsi_cmnd * cmd);
-int qla1280_eh_device_reset(struct scsi_cmnd *cmd);
-int qla1280_eh_bus_reset(struct scsi_cmnd *cmd);
-int qla1280_eh_adapter_reset(struct scsi_cmnd *cmd);
-
-#if LINUX_VERSION_CODE < 0x020545
-#define USE_NEW_EH	.use_new_eh_code= 1
-#else
-#define USE_NEW_EH
-#endif
-
-/*
- * Scsi_Host_template (see hosts.h)
- * Device driver Interfaces to mid-level SCSI driver.
- */
-
-#define QLA1280_LINUX_TEMPLATE {				\
-	.module = NULL,						\
-	.proc_dir = NULL,					\
-	.proc_info = qla1280_proc_info,				\
-	.name = "Qlogic ISP 1280/12160",			\
-	.detect = qla1280_detect,				\
-	.release = qla1280_release,				\
-	.info = qla1280_info,					\
-	.queuecommand = qla1280_queuecommand,			\
-	.eh_strategy_handler = NULL,				\
-	.eh_abort_handler = qla1280_eh_abort,			\
-	.eh_device_reset_handler = qla1280_eh_device_reset,	\
-	.eh_bus_reset_handler = qla1280_eh_bus_reset,		\
-	.eh_host_reset_handler = qla1280_eh_adapter_reset,	\
-	.bios_param = qla1280_biosparam,			\
-	.can_queue = 255,	/* max simultaneous cmds      */\
-	.this_id = -1,		/* scsi id of host adapter    */\
-	.sg_tablesize = SG_ALL,	/* max scatter-gather cmds    */\
-	.cmd_per_lun = 3,	/* cmds per lun (linked cmds) */\
-	.present = 0,		/* number of 1280's present   */\
-	.unchecked_isa_dma = 0,	/* no memory DMA restrictions */\
-	.use_clustering = ENABLE_CLUSTERING,			\
-	.emulated = 0,						\
-	USE_NEW_EH						\
-}
 
 #endif				/* _IO_HBA_QLA1280_H */

