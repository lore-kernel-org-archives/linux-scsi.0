From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove usage of obsolete typedefs
Date: Mon, 16 May 2005 20:52:39 +0200
Message-ID: <20050516185239.GC16811@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49548 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261812AbVEPSwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 14:52:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-16 20:00:29.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-16 20:05:05.000000000 +0200
@@ -426,12 +426,12 @@
 					 struct ahc_linux_device *,
 					 struct scb *);
 static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
-					 Scsi_Cmnd *cmd);
+					 struct scsi_cmnd *cmd);
 static void ahc_linux_sem_timeout(u_long arg);
 static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
 static void ahc_linux_release_simq(u_long arg);
 static void ahc_linux_dev_timed_unfreeze(u_long arg);
-static int  ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag);
+static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
 static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
 static void ahc_linux_thread_run_complete_queue(struct ahc_softc *ahc);
 static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
@@ -512,7 +512,7 @@
 
 	with_errors = 0;
 	while ((acmd = TAILQ_FIRST(&ahc->platform_data->completeq)) != NULL) {
-		Scsi_Cmnd *cmd;
+		struct scsi_cmnd *cmd;
 
 		if (with_errors > AHC_LINUX_MAX_RETURNED_ERRORS) {
 			/*
@@ -542,7 +542,7 @@
 static __inline void
 ahc_linux_unmap_scb(struct ahc_softc *ahc, struct scb *scb)
 {
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 
 	cmd = scb->io_ctx;
 	ahc_sync_sglist(ahc, scb, BUS_DMASYNC_POSTWRITE);
@@ -582,27 +582,11 @@
 	return (consumed);
 }
 
-/************************  Host template entry points *************************/
-static int	   ahc_linux_detect(Scsi_Host_Template *);
-static int	   ahc_linux_queue(Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
-static const char *ahc_linux_info(struct Scsi_Host *);
-static int	   ahc_linux_slave_alloc(Scsi_Device *);
-static int	   ahc_linux_slave_configure(Scsi_Device *);
-static void	   ahc_linux_slave_destroy(Scsi_Device *);
-#if defined(__i386__)
-static int	   ahc_linux_biosparam(struct scsi_device*,
-				       struct block_device*,
-				       sector_t, int[]);
-#endif
-static int	   ahc_linux_bus_reset(Scsi_Cmnd *);
-static int	   ahc_linux_dev_reset(Scsi_Cmnd *);
-static int	   ahc_linux_abort(Scsi_Cmnd *);
-
 /*
  * Try to detect an Adaptec 7XXX controller.
  */
 static int
-ahc_linux_detect(Scsi_Host_Template *template)
+ahc_linux_detect(struct scsi_host_template *template)
 {
 	struct	ahc_softc *ahc;
 	int     found = 0;
@@ -683,7 +667,7 @@
  * Queue an SCB to the controller.
  */
 static int
-ahc_linux_queue(Scsi_Cmnd * cmd, void (*scsi_done) (Scsi_Cmnd *))
+ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 {
 	struct	 ahc_softc *ahc;
 	struct	 ahc_linux_device *dev;
@@ -714,7 +698,7 @@
 }
 
 static int
-ahc_linux_slave_alloc(Scsi_Device *device)
+ahc_linux_slave_alloc(struct scsi_device *device)
 {
 	struct	ahc_softc *ahc;
 
@@ -725,7 +709,7 @@
 }
 
 static int
-ahc_linux_slave_configure(Scsi_Device *device)
+ahc_linux_slave_configure(struct scsi_device *device)
 {
 	struct	ahc_softc *ahc;
 	struct	ahc_linux_device *dev;
@@ -755,7 +739,7 @@
 }
 
 static void
-ahc_linux_slave_destroy(Scsi_Device *device)
+ahc_linux_slave_destroy(struct scsi_device *device)
 {
 	struct	ahc_softc *ahc;
 	struct	ahc_linux_device *dev;
@@ -836,7 +820,7 @@
  * Abort the current SCSI command(s).
  */
 static int
-ahc_linux_abort(Scsi_Cmnd *cmd)
+ahc_linux_abort(struct scsi_cmnd *cmd)
 {
 	int error;
 
@@ -850,7 +834,7 @@
  * Attempt to send a target reset message to the device that timed out.
  */
 static int
-ahc_linux_dev_reset(Scsi_Cmnd *cmd)
+ahc_linux_dev_reset(struct scsi_cmnd *cmd)
 {
 	int error;
 
@@ -864,7 +848,7 @@
  * Reset the SCSI bus.
  */
 static int
-ahc_linux_bus_reset(Scsi_Cmnd *cmd)
+ahc_linux_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct ahc_softc *ahc;
 	int    found;
@@ -881,7 +865,7 @@
 	return SUCCESS;
 }
 
-Scsi_Host_Template aic7xxx_driver_template = {
+struct scsi_host_template aic7xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic7xxx",
 	.proc_info		= ahc_linux_proc_info,
@@ -1221,7 +1205,7 @@
 uint32_t aic7xxx_verbose;
 
 int
-ahc_linux_register_host(struct ahc_softc *ahc, Scsi_Host_Template *template)
+ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *template)
 {
 	char	 buf[80];
 	struct	 Scsi_Host *host;
@@ -2050,7 +2034,7 @@
 void
 ahc_done(struct ahc_softc *ahc, struct scb *scb)
 {
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	struct	   ahc_linux_device *dev;
 
 	LIST_REMOVE(scb, pending_links);
@@ -2204,7 +2188,7 @@
 	case SCSI_STATUS_CHECK_COND:
 	case SCSI_STATUS_CMD_TERMINATED:
 	{
-		Scsi_Cmnd *cmd;
+		struct scsi_cmnd *cmd;
 
 		/*
 		 * Copy sense information to the OS's cmd
@@ -2326,7 +2310,7 @@
 }
 
 static void
-ahc_linux_queue_cmd_complete(struct ahc_softc *ahc, Scsi_Cmnd *cmd)
+ahc_linux_queue_cmd_complete(struct ahc_softc *ahc, struct scsi_cmnd *cmd)
 {
 	/*
 	 * Typically, the complete queue has very few entries
@@ -2515,7 +2499,7 @@
 }
 
 static int
-ahc_linux_queue_recovery_cmd(Scsi_Cmnd *cmd, scb_flag flag)
+ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 {
 	struct ahc_softc *ahc;
 	struct ahc_linux_device *dev;
Index: linux-2.6/drivers/scsi/aic7xxx/aiclib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aiclib.c	2005-04-30 10:17:16.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aiclib.c	2005-05-16 20:07:27.000000000 +0200
@@ -35,7 +35,6 @@
 #include <linux/version.h>
 
 /* Core SCSI definitions */
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "aiclib.h"
 #include "cam.h"
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 19:47:59.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 20:10:23.000000000 +0200
@@ -59,6 +59,7 @@
 #ifndef _AIC7XXX_LINUX_H_
 #define _AIC7XXX_LINUX_H_
 
+#include <linux/config.h>
 #include <linux/types.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -68,16 +69,19 @@
 #include <linux/version.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
-#include <linux/config.h>
-#include <linux/slab.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahc
-#include "scsi.h"
-#include <scsi/scsi_host.h>
 
 /* Name space conflict with BSD queue macros */
 #ifdef LIST_HEAD
@@ -106,7 +110,7 @@
 /************************* Forward Declarations *******************************/
 struct ahc_softc;
 typedef struct pci_dev *ahc_dev_softc_t;
-typedef Scsi_Cmnd      *ahc_io_ctx_t;
+typedef struct scsi_cmnd      *ahc_io_ctx_t;
 
 /******************************* Byte Order ***********************************/
 #define ahc_htobe16(x)	cpu_to_be16(x)
@@ -144,7 +148,7 @@
 extern u_int aic7xxx_no_probe;
 extern u_int aic7xxx_allow_memio;
 extern int aic7xxx_detect_complete;
-extern Scsi_Host_Template aic7xxx_driver_template;
+extern struct scsi_host_template aic7xxx_driver_template;
 
 /***************************** Bus Space/DMA **********************************/
 
@@ -412,7 +416,7 @@
 #define AHC_OTAG_THRESH	500
 
 	int			lun;
-	Scsi_Device	       *scsi_device;
+	struct scsi_device       *scsi_device;
 	struct			ahc_linux_target *target;
 };
 
@@ -569,7 +573,7 @@
 
 /**************************** Initialization **********************************/
 int		ahc_linux_register_host(struct ahc_softc *,
-					Scsi_Host_Template *);
+					struct scsi_host_template *);
 
 uint64_t	ahc_linux_get_memsize(void);
 
@@ -800,13 +804,13 @@
 
 /*************************** Domain Validation ********************************/
 /*********************** Transaction Access Wrappers *************************/
-static __inline void ahc_cmd_set_transaction_status(Scsi_Cmnd *, uint32_t);
+static __inline void ahc_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
 static __inline void ahc_set_transaction_status(struct scb *, uint32_t);
-static __inline void ahc_cmd_set_scsi_status(Scsi_Cmnd *, uint32_t);
+static __inline void ahc_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
 static __inline void ahc_set_scsi_status(struct scb *, uint32_t);
-static __inline uint32_t ahc_cmd_get_transaction_status(Scsi_Cmnd *cmd);
+static __inline uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd);
 static __inline uint32_t ahc_get_transaction_status(struct scb *);
-static __inline uint32_t ahc_cmd_get_scsi_status(Scsi_Cmnd *cmd);
+static __inline uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd);
 static __inline uint32_t ahc_get_scsi_status(struct scb *);
 static __inline void ahc_set_transaction_tag(struct scb *, int, u_int);
 static __inline u_long ahc_get_transfer_length(struct scb *);
@@ -825,7 +829,7 @@
 static __inline void ahc_freeze_scb(struct scb *scb);
 
 static __inline
-void ahc_cmd_set_transaction_status(Scsi_Cmnd *cmd, uint32_t status)
+void ahc_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
 	cmd->result &= ~(CAM_STATUS_MASK << 16);
 	cmd->result |= status << 16;
@@ -838,7 +842,7 @@
 }
 
 static __inline
-void ahc_cmd_set_scsi_status(Scsi_Cmnd *cmd, uint32_t status)
+void ahc_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
 	cmd->result &= ~0xFFFF;
 	cmd->result |= status;
@@ -851,7 +855,7 @@
 }
 
 static __inline
-uint32_t ahc_cmd_get_transaction_status(Scsi_Cmnd *cmd)
+uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
 	return ((cmd->result >> 16) & CAM_STATUS_MASK);
 }
@@ -863,7 +867,7 @@
 }
 
 static __inline
-uint32_t ahc_cmd_get_scsi_status(Scsi_Cmnd *cmd)
+uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
 	return (cmd->result & 0xFFFF);
 }
