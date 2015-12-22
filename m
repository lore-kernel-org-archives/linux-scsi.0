From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 47/77] ncr5380: Fix and cleanup scsi_host_template initializers
Date: Tue, 22 Dec 2015 12:18:25 +1100
Message-ID: <20151222011750.776106983@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-cleanup-scsi_host_template-initializers
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Add missing .module initializer. Use distinct .proc_name values for the
g_NCR5380 and g_NCR5380_mmio modules. Remove pointless CAN_QUEUE and
CMD_PER_LUN override macros. Cleanup whitespace and code style.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_scsi.c |    2 +-
 drivers/scsi/dmx3191d.c   |    1 +
 drivers/scsi/dtc.c        |   32 ++++++++++++++++----------------
 drivers/scsi/dtc.h        |    8 --------
 drivers/scsi/g_NCR5380.c  |   26 +++++++++++++-------------
 drivers/scsi/g_NCR5380.h  |   10 ++--------
 drivers/scsi/mac_scsi.c   |   28 ++++++++++++++--------------
 drivers/scsi/pas16.c      |   32 ++++++++++++++++----------------
 drivers/scsi/pas16.h      |    8 --------
 drivers/scsi/sun3_scsi.c  |    6 +++---
 drivers/scsi/t128.c       |   32 ++++++++++++++++----------------
 drivers/scsi/t128.h       |    8 --------
 12 files changed, 82 insertions(+), 111 deletions(-)

Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2015-12-22 12:16:41.000000000 +1100
@@ -49,6 +49,7 @@
 
 
 static struct scsi_host_template dmx3191d_driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= DMX3191D_DRIVER_NAME,
 	.name			= "Domex DMX3191D",
 	.info			= NCR5380_info,
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-12-22 12:16:41.000000000 +1100
@@ -436,21 +436,21 @@ static int dtc_release(struct Scsi_Host
 }
 
 static struct scsi_host_template driver_template = {
-	.name				= "DTC 3180/3280 ",
-	.detect				= dtc_detect,
-	.release			= dtc_release,
-	.proc_name			= "dtc3x80",
-	.show_info			= dtc_show_info,
-	.write_info			= dtc_write_info,
-	.info				= dtc_info,
-	.queuecommand			= dtc_queue_command,
-	.eh_abort_handler		= dtc_abort,
-	.eh_bus_reset_handler		= dtc_bus_reset,
-	.bios_param     		= dtc_biosparam,
-	.can_queue      		= CAN_QUEUE,
-	.this_id        		= 7,
-	.sg_tablesize   		= SG_ALL,
-	.cmd_per_lun    		= CMD_PER_LUN,
-	.use_clustering 		= DISABLE_CLUSTERING,
+	.name			= "DTC 3180/3280",
+	.detect			= dtc_detect,
+	.release		= dtc_release,
+	.proc_name		= "dtc3x80",
+	.show_info		= dtc_show_info,
+	.write_info		= dtc_write_info,
+	.info			= dtc_info,
+	.queuecommand		= dtc_queue_command,
+	.eh_abort_handler	= dtc_abort,
+	.eh_bus_reset_handler	= dtc_bus_reset,
+	.bios_param		= dtc_biosparam,
+	.can_queue		= 32,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 2,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2015-12-22 12:16:07.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2015-12-22 12:16:41.000000000 +1100
@@ -10,14 +10,6 @@
 #ifndef DTC3280_H
 #define DTC3280_H
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 32 
-#endif
-
 #define NCR5380_implementation_fields \
     void __iomem *base
 
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-22 12:16:41.000000000 +1100
@@ -305,7 +305,6 @@ static int __init generic_NCR5380_detect
 		}
 	}
 #endif
-	tpnt->proc_name = "g_NCR5380";
 
 	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 		if (!(overrides[current_override].NCR5380_map_name))
@@ -715,20 +714,21 @@ static int generic_NCR5380_dma_xfer_len(
 #include "NCR5380.c"
 
 static struct scsi_host_template driver_template = {
-	.show_info      	= generic_NCR5380_show_info,
-	.name           	= "Generic NCR5380/NCR53C400 SCSI",
-	.detect         	= generic_NCR5380_detect,
-	.release        	= generic_NCR5380_release_resources,
-	.info           	= generic_NCR5380_info,
-	.queuecommand   	= generic_NCR5380_queue_command,
+	.proc_name		= DRV_MODULE_NAME,
+	.show_info		= generic_NCR5380_show_info,
+	.name			= "Generic NCR5380/NCR53C400 SCSI",
+	.detect			= generic_NCR5380_detect,
+	.release		= generic_NCR5380_release_resources,
+	.info			= generic_NCR5380_info,
+	.queuecommand		= generic_NCR5380_queue_command,
 	.eh_abort_handler	= generic_NCR5380_abort,
 	.eh_bus_reset_handler	= generic_NCR5380_bus_reset,
-	.bios_param     	= NCR5380_BIOSPARAM,
-	.can_queue      	= CAN_QUEUE,
-        .this_id        	= 7,
-        .sg_tablesize   	= SG_ALL,
-	.cmd_per_lun    	= CMD_PER_LUN,
-        .use_clustering		= DISABLE_CLUSTERING,
+	.bios_param		= NCR5380_BIOSPARAM,
+	.can_queue		= 16,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 2,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 
 #include "scsi_module.c"
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2015-12-22 12:16:07.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2015-12-22 12:16:41.000000000 +1100
@@ -21,18 +21,11 @@
 #define NCR5380_BIOSPARAM NULL
 #endif
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 16
-#endif
-
 #define __STRVAL(x) #x
 #define STRVAL(x) __STRVAL(x)
 
 #ifndef SCSI_G_NCR5380_MEM
+#define DRV_MODULE_NAME "g_NCR5380"
 
 #define NCR5380_map_type int
 #define NCR5380_map_name port
@@ -53,6 +46,7 @@
 
 #else 
 /* therefore SCSI_G_NCR5380_MEM */
+#define DRV_MODULE_NAME "g_NCR5380_mmio"
 
 #define NCR5380_map_type unsigned long
 #define NCR5380_map_name base
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2015-12-22 12:16:41.000000000 +1100
@@ -309,20 +309,20 @@ static int macscsi_pwrite(struct Scsi_Ho
 #define PFX                     DRV_MODULE_NAME ": "
 
 static struct scsi_host_template mac_scsi_template = {
-	.module				= THIS_MODULE,
-	.proc_name			= DRV_MODULE_NAME,
-	.show_info			= macscsi_show_info,
-	.write_info			= macscsi_write_info,
-	.name				= "Macintosh NCR5380 SCSI",
-	.info				= macscsi_info,
-	.queuecommand			= macscsi_queue_command,
-	.eh_abort_handler		= macscsi_abort,
-	.eh_bus_reset_handler		= macscsi_bus_reset,
-	.can_queue			= 16,
-	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
-	.cmd_per_lun			= 2,
-	.use_clustering			= DISABLE_CLUSTERING
+	.module			= THIS_MODULE,
+	.proc_name		= DRV_MODULE_NAME,
+	.show_info		= macscsi_show_info,
+	.write_info		= macscsi_write_info,
+	.name			= "Macintosh NCR5380 SCSI",
+	.info			= macscsi_info,
+	.queuecommand		= macscsi_queue_command,
+	.eh_abort_handler	= macscsi_abort,
+	.eh_bus_reset_handler	= macscsi_bus_reset,
+	.can_queue		= 16,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 2,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 
 static int __init mac_scsi_probe(struct platform_device *pdev)
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-12-22 12:16:41.000000000 +1100
@@ -546,22 +546,22 @@ static int pas16_release(struct Scsi_Hos
 }
 
 static struct scsi_host_template driver_template = {
-	.name           = "Pro Audio Spectrum-16 SCSI",
-	.detect         = pas16_detect,
-	.release        = pas16_release,
-	.proc_name      = "pas16",
-	.show_info      = pas16_show_info,
-	.write_info     = pas16_write_info,
-	.info           = pas16_info,
-	.queuecommand   = pas16_queue_command,
-	.eh_abort_handler = pas16_abort,
-	.eh_bus_reset_handler = pas16_bus_reset,
-	.bios_param     = pas16_biosparam, 
-	.can_queue      = CAN_QUEUE,
-	.this_id        = 7,
-	.sg_tablesize   = SG_ALL,
-	.cmd_per_lun    = CMD_PER_LUN,
-	.use_clustering = DISABLE_CLUSTERING,
+	.name			= "Pro Audio Spectrum-16 SCSI",
+	.detect			= pas16_detect,
+	.release		= pas16_release,
+	.proc_name		= "pas16",
+	.show_info		= pas16_show_info,
+	.write_info		= pas16_write_info,
+	.info			= pas16_info,
+	.queuecommand		= pas16_queue_command,
+	.eh_abort_handler	= pas16_abort,
+	.eh_bus_reset_handler	= pas16_bus_reset,
+	.bios_param		= pas16_biosparam,
+	.can_queue		= 32,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 2,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
 
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2015-12-22 12:16:07.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2015-12-22 12:16:41.000000000 +1100
@@ -95,14 +95,6 @@
 #define OPERATION_MODE_1 0xec03
 #define IO_CONFIG_3 0xf002
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 32 
-#endif
-
 #define NCR5380_implementation_fields /* none */
 
 #define PAS16_io_port(reg) (instance->io_port + pas16_offset[(reg)])
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2015-12-22 12:15:56.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2015-12-22 12:16:41.000000000 +1100
@@ -463,13 +463,13 @@ static struct scsi_host_template sun3_sc
 	.name			= SUN3_SCSI_NAME,
 	.info			= sun3scsi_info,
 	.queuecommand		= sun3scsi_queue_command,
-	.eh_abort_handler      	= sun3scsi_abort,
-	.eh_bus_reset_handler  	= sun3scsi_bus_reset,
+	.eh_abort_handler	= sun3scsi_abort,
+	.eh_bus_reset_handler	= sun3scsi_bus_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_NONE,
 	.cmd_per_lun		= 2,
-	.use_clustering		= DISABLE_CLUSTERING
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 
 static int __init sun3_scsi_probe(struct platform_device *pdev)
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/t128.c	2015-12-22 12:16:41.000000000 +1100
@@ -390,21 +390,21 @@ MODULE_LICENSE("GPL");
 #include "NCR5380.c"
 
 static struct scsi_host_template driver_template = {
-	.name           = "Trantor T128/T128F/T228",
-	.detect         = t128_detect,
-	.release        = t128_release,
-	.proc_name      = "t128",
-	.show_info      = t128_show_info,
-	.write_info     = t128_write_info,
-	.info           = t128_info,
-	.queuecommand   = t128_queue_command,
-	.eh_abort_handler = t128_abort,
-	.eh_bus_reset_handler    = t128_bus_reset,
-	.bios_param     = t128_biosparam,
-	.can_queue      = CAN_QUEUE,
-        .this_id        = 7,
-	.sg_tablesize   = SG_ALL,
-	.cmd_per_lun    = CMD_PER_LUN,
-	.use_clustering = DISABLE_CLUSTERING,
+	.name			= "Trantor T128/T128F/T228",
+	.detect			= t128_detect,
+	.release		= t128_release,
+	.proc_name		= "t128",
+	.show_info		= t128_show_info,
+	.write_info		= t128_write_info,
+	.info			= t128_info,
+	.queuecommand		= t128_queue_command,
+	.eh_abort_handler	= t128_abort,
+	.eh_bus_reset_handler	= t128_bus_reset,
+	.bios_param		= t128_biosparam,
+	.can_queue		= 32,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 2,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2015-12-22 12:16:07.000000000 +1100
+++ linux/drivers/scsi/t128.h	2015-12-22 12:16:41.000000000 +1100
@@ -67,14 +67,6 @@
 
 #define T_DATA_REG_OFFSET	0x1e00	/* rw 512 bytes long */
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 32
-#endif
-
 #define NCR5380_implementation_fields \
     void __iomem *base
 
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-12-22 12:16:37.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2015-12-22 12:16:41.000000000 +1100
@@ -781,7 +781,7 @@ static struct scsi_host_template atari_s
 	.eh_abort_handler	= atari_scsi_abort,
 	.eh_bus_reset_handler	= atari_scsi_bus_reset,
 	.this_id		= 7,
-	.use_clustering		= DISABLE_CLUSTERING
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 
 static int __init atari_scsi_probe(struct platform_device *pdev)
