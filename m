From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Do not set cmd_per_lun to 1 in the host template
Date: Wed, 29 Apr 2015 08:57:34 +0200
Message-ID: <1430290654-109136-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbbD2G5h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 02:57:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

'0' is now used as the default cmd_per_lun value,
so there's no need to explicitly set it to '1' in the
host template.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/cciss_scsi.c          | 1 -
 drivers/firewire/sbp2.c             | 1 -
 drivers/s390/scsi/zfcp_scsi.c       | 1 -
 drivers/scsi/NCR53c406a.c           | 1 -
 drivers/scsi/a100u2w.c              | 1 -
 drivers/scsi/aha152x.c              | 1 -
 drivers/scsi/aha1542.c              | 1 -
 drivers/scsi/aha1740.c              | 1 -
 drivers/scsi/aha1740.h              | 1 -
 drivers/scsi/aic94xx/aic94xx_init.c | 1 -
 drivers/scsi/arm/arxescsi.c         | 1 -
 drivers/scsi/arm/cumana_2.c         | 1 -
 drivers/scsi/arm/eesox.c            | 1 -
 drivers/scsi/atp870u.c              | 1 -
 drivers/scsi/atp870u.h              | 1 -
 drivers/scsi/dpt_i2o.c              | 1 -
 drivers/scsi/fdomain.c              | 1 -
 drivers/scsi/imm.c                  | 1 -
 drivers/scsi/initio.c               | 1 -
 drivers/scsi/isci/init.c            | 1 -
 drivers/scsi/mac53c94.c             | 1 -
 drivers/scsi/mvsas/mv_init.c        | 1 -
 drivers/scsi/nsp32.c                | 1 -
 drivers/scsi/pcmcia/nsp_cs.c        | 1 -
 drivers/scsi/pcmcia/qlogic_stub.c   | 1 -
 drivers/scsi/pcmcia/sym53c500_cs.c  | 1 -
 drivers/scsi/pm8001/pm8001_init.c   | 1 -
 drivers/scsi/ppa.c                  | 1 -
 drivers/scsi/ps3rom.c               | 1 -
 drivers/scsi/qla1280.c              | 1 -
 drivers/scsi/qlogicfas.c            | 1 -
 drivers/scsi/qlogicpti.c            | 1 -
 drivers/scsi/sym53c416.c            | 1 -
 drivers/scsi/wd719x.c               | 1 -
 drivers/scsi/wd719x.h               | 2 --
 drivers/staging/rts5208/rtsx.c      | 1 -
 drivers/usb/image/microtek.c        | 1 -
 drivers/usb/storage/scsiglue.c      | 1 -
 drivers/usb/storage/uas.c           | 1 -
 include/linux/libata.h              | 2 --
 40 files changed, 42 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index ecd845c..1537302 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -84,7 +84,6 @@ static struct scsi_host_template cciss_driver_template = {
 	.show_info		= cciss_scsi_show_info,
 	.queuecommand		= cciss_scsi_queue_command,
 	.this_id		= 7,
-	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
 	/* Can't have eh_bus_reset_handler or eh_host_reset_handler for cciss */
 	.eh_device_reset_handler= cciss_eh_device_reset_handler,
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index c22606f..6bac039 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1611,7 +1611,6 @@ static struct scsi_host_template scsi_driver_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
 };
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 75f4bfc..b3c6ff4 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -297,7 +297,6 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2) * 8,
 				   /* GCD, adjusted later */
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
-	.cmd_per_lun		 = 1,
 	.use_clustering		 = 1,
 	.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 42c7161..6e110c6 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -1064,7 +1064,6 @@ static struct scsi_host_template driver_template =
      .can_queue         	= 1			/* can_queue */,        
      .this_id           	= 7			/* SCSI ID of the chip */,
      .sg_tablesize      	= 32			/*SG_ALL*/ /*SG_NONE*/, 
-     .cmd_per_lun       	= 1			/* commands per lun */, 
      .unchecked_isa_dma 	= 1			/* unchecked_isa_dma */,
      .use_clustering    	= ENABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 7e33a61..cac6b37 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1078,7 +1078,6 @@ static struct scsi_host_template inia100_template = {
 	.can_queue		= 1,
 	.this_id		= 1,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun 		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e31c460..f44d048 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2922,7 +2922,6 @@ static struct scsi_host_template aha152x_driver_template = {
 	.can_queue			= 1,
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
-	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.slave_alloc			= aha152x_adjust_queue,
 };
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ec43276..c0c4eae 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -951,7 +951,6 @@ static struct scsi_host_template driver_template = {
 	.can_queue		= AHA1542_MAILBOXES, 
 	.this_id		= 7,
 	.sg_tablesize		= 16,
-	.cmd_per_lun		= 1,
 	.unchecked_isa_dma	= 1, 
 	.use_clustering		= ENABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 31ace4b..bad35ff 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -544,7 +544,6 @@ static struct scsi_host_template aha1740_template = {
 	.can_queue        = AHA1740_ECBS,
 	.this_id          = 7,
 	.sg_tablesize     = AHA1740_SCATTER,
-	.cmd_per_lun      = AHA1740_CMDLUN,
 	.use_clustering   = ENABLE_CLUSTERING,
 	.eh_abort_handler = aha1740_eh_abort_handler,
 };
diff --git a/drivers/scsi/aha1740.h b/drivers/scsi/aha1740.h
index af23fd6..b0c5603 100644
--- a/drivers/scsi/aha1740.h
+++ b/drivers/scsi/aha1740.h
@@ -149,6 +149,5 @@ struct ecb {			/* Enhanced Control Block 6.1 */
 
 #define AHA1740_ECBS 32
 #define AHA1740_SCATTER 16
-#define AHA1740_CMDLUN 1
 
 #endif
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 02a2512..4b135cc 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -65,7 +65,6 @@ static struct scsi_host_template aic94xx_sht = {
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
-	.cmd_per_lun		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 32d2321..3110736 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -245,7 +245,6 @@ static struct scsi_host_template arxescsi_template = {
 	.can_queue			= 0,
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
-	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "arxescsi",
 };
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index abc66f5..faa1bee 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -367,7 +367,6 @@ static struct scsi_host_template cumanascsi2_template = {
 	.this_id			= 7,
 	.sg_tablesize			= SCSI_MAX_SG_CHAIN_SEGMENTS,
 	.dma_boundary			= IOMD_DMA_BOUNDARY,
-	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "cumanascsi2",
 };
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 5bf3c0d..a8ad688 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -486,7 +486,6 @@ static struct scsi_host_template eesox_template = {
 	.this_id			= 7,
 	.sg_tablesize			= SCSI_MAX_SG_CHAIN_SEGMENTS,
 	.dma_boundary			= IOMD_DMA_BOUNDARY,
-	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "eesox",
 };
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 0836433..05301bc 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3158,7 +3158,6 @@ static struct scsi_host_template atp870u_template = {
      .can_queue         	= qcnt			/* can_queue */,
      .this_id           	= 7			/* SCSI ID */,
      .sg_tablesize      	= ATP870U_SCATTER	/*SG_ALL*/ /*SG_NONE*/,
-     .cmd_per_lun       	= ATP870U_CMDLUN		/* commands per lun */,
      .use_clustering    	= ENABLE_CLUSTERING,
      .max_sectors		= ATP870U_MAX_SECTORS,
 };
diff --git a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
index 62bae64..5cf6256 100644
--- a/drivers/scsi/atp870u.h
+++ b/drivers/scsi/atp870u.h
@@ -10,7 +10,6 @@
 #define MAX_SENSE 	14
 #define qcnt	       	32
 #define ATP870U_SCATTER 	128
-#define ATP870U_CMDLUN  	1
 
 #define MAX_ADAPTER	8
 #define MAX_SCSI_ID	16
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 2806cfb..f35ed53 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3562,7 +3562,6 @@ static struct scsi_host_template driver_template = {
 	.slave_configure	= adpt_slave_configure,
 	.can_queue		= MAX_TO_IOP_MESSAGES,
 	.this_id		= 7,
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index fff6829..eefe14d 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1764,7 +1764,6 @@ struct scsi_host_template fdomain_driver_template = {
 	.can_queue		= 1,
 	.this_id		= 6,
 	.sg_tablesize		= 64,
-	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 89a8266..4e1a632 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1109,7 +1109,6 @@ static struct scsi_host_template imm_template = {
 	.bios_param		= imm_biosparam,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
 	.slave_alloc		= imm_adjust_queue,
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e5dae7b..6a926ba 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2833,7 +2833,6 @@ static struct scsi_host_template initio_template = {
 	.can_queue		= MAX_TARGETS * i91u_MAXQUEUE,
 	.this_id		= 1,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index cd41b63..0dfcabe 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -160,7 +160,6 @@ static struct scsi_host_template isci_sht = {
 	.change_queue_depth		= sas_change_queue_depth,
 	.bios_param			= sas_bios_param,
 	.can_queue			= ISCI_CAN_QUEUE_VAL,
-	.cmd_per_lun			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= SG_ALL,
 	.max_sectors			= SCSI_DEFAULT_MAX_SECTORS,
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 0adb2e0..1412266 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -403,7 +403,6 @@ static struct scsi_host_template mac53c94_template = {
 	.can_queue	= 1,
 	.this_id	= 7,
 	.sg_tablesize	= SG_ALL,
-	.cmd_per_lun	= 1,
 	.use_clustering	= DISABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 53030b0..d40d734 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -56,7 +56,6 @@ static struct scsi_host_template mvs_sht = {
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
-	.cmd_per_lun		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index c6077ce..53c8477 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -274,7 +274,6 @@ static struct scsi_host_template nsp32_template = {
 	.can_queue			= 1,
 	.sg_tablesize			= NSP32_SG_SIZE,
 	.max_sectors			= 128,
-	.cmd_per_lun			= 1,
 	.this_id			= NSP32_HOST_SCSIID,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.eh_abort_handler       	= nsp32_eh_abort,
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 1b6c883..5fb6eef 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -86,7 +86,6 @@ static struct scsi_host_template nsp_driver_template = {
 	.can_queue		 = 1,
 	.this_id		 = NSP_INITIATOR_ID,
 	.sg_tablesize		 = SG_ALL,
-	.cmd_per_lun		 = 1,
 	.use_clustering		 = DISABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index bcaf89f..c670dc7 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -72,7 +72,6 @@ static struct scsi_host_template qlogicfas_driver_template = {
 	.can_queue		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 155f957..20011c8 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -680,7 +680,6 @@ static struct scsi_host_template sym53c500_driver_template = {
      .can_queue			= 1,
      .this_id			= 7,
      .sg_tablesize		= 32,
-     .cmd_per_lun		= 1,
      .use_clustering		= ENABLE_CLUSTERING,
      .shost_attrs		= SYM53C500_shost_attrs
 };
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 6555591..a132f26 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -78,7 +78,6 @@ static struct scsi_host_template pm8001_sht = {
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
-	.cmd_per_lun		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 1db8b26..ee00e27 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -974,7 +974,6 @@ static struct scsi_host_template ppa_template = {
 	.bios_param		= ppa_biosparam,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
 	.slave_alloc		= ppa_adjust_queue,
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 5298def..4924424 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -347,7 +347,6 @@ static struct scsi_host_template ps3rom_host_template = {
 	.can_queue =		1,
 	.this_id =		7,
 	.sg_tablesize =		SG_ALL,
-	.cmd_per_lun =		1,
 	.emulated =             1,		/* only sg driver uses this */
 	.max_sectors =		PS3ROM_MAX_SECTORS,
 	.use_clustering =	ENABLE_CLUSTERING,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index c68a66e..5d0ec42 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4217,7 +4217,6 @@ static struct scsi_host_template qla1280_driver_template = {
 	.can_queue		= 0xfffff,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index a22bb1b..61cac87 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -193,7 +193,6 @@ static struct scsi_host_template qlogicfas_driver_template = {
 	.can_queue		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index fe12270..676385f 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1287,7 +1287,6 @@ static struct scsi_host_template qpti_template = {
 	.can_queue		= QLOGICPTI_REQ_QUEUE_LEN,
 	.this_id		= 7,
 	.sg_tablesize		= QLOGICPTI_MAX_SG(QLOGICPTI_REQ_QUEUE_LEN),
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 0b7819f..5bdcbe8 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -838,7 +838,6 @@ static struct scsi_host_template driver_template = {
 	.can_queue =		1,
 	.this_id =		SYM53C416_SCSI_ID,
 	.sg_tablesize =		32,
-	.cmd_per_lun =		1,
 	.unchecked_isa_dma =	1,
 	.use_clustering =	ENABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 289ad01..61346aa 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -882,7 +882,6 @@ static struct scsi_host_template wd719x_template = {
 	.can_queue			= 255,
 	.this_id			= 7,
 	.sg_tablesize			= WD719X_SG,
-	.cmd_per_lun			= WD719X_CMD_PER_LUN,
 	.use_clustering			= ENABLE_CLUSTERING,
 };
 
diff --git a/drivers/scsi/wd719x.h b/drivers/scsi/wd719x.h
index 185e30e..9c6dd45 100644
--- a/drivers/scsi/wd719x.h
+++ b/drivers/scsi/wd719x.h
@@ -2,8 +2,6 @@
 #define _WD719X_H_
 
 #define WD719X_SG 255		/* Scatter/gather size */
-#define WD719X_CMD_PER_LUN 1	/* We should be able to do linked commands, but
-				 * this is 1 for now to be safe. */
 
 struct wd719x_sglist {
 	__le32 ptr;
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index d64b6ed..aed49bf 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -230,7 +230,6 @@ static struct scsi_host_template rtsx_host_template = {
 
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
-	.cmd_per_lun =			1,
 
 	/* unknown initiator id */
 	.this_id =			-1,
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 6431d08..a4dbb0c 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -635,7 +635,6 @@ static struct scsi_host_template mts_scsi_host_template = {
 	.sg_tablesize =		SG_ALL,
 	.can_queue =		1,
 	.this_id =		-1,
-	.cmd_per_lun =		1,
 	.use_clustering =	1,
 	.emulated =		1,
 	.slave_alloc =		mts_slave_alloc,
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 0e400f3..996ef1e 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -558,7 +558,6 @@ struct scsi_host_template usb_stor_host_template = {
 
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
-	.cmd_per_lun =			1,
 
 	/* unknown initiator id */
 	.this_id =			-1,
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 6cdabdc..56b97fe 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -803,7 +803,6 @@ static struct scsi_host_template uas_host_template = {
 	.can_queue = 65536,	/* Is there a limit on the _host_ ? */
 	.this_id = -1,
 	.sg_tablesize = SG_NONE,
-	.cmd_per_lun = 1,	/* until we override it */
 	.skip_settle_delay = 1,
 	.use_blk_tags = 1,
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 8dad4a3..1402291 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -134,7 +134,6 @@ enum {
 	ATA_ALL_DEVICES		= (1 << ATA_MAX_DEVICES) - 1,
 
 	ATA_SHT_EMULATED	= 1,
-	ATA_SHT_CMD_PER_LUN	= 1,
 	ATA_SHT_THIS_ID		= -1,
 	ATA_SHT_USE_CLUSTERING	= 1,
 
@@ -1354,7 +1353,6 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.can_queue		= ATA_DEF_QUEUE,		\
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,		\
 	.this_id		= ATA_SHT_THIS_ID,		\
-	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,		\
 	.emulated		= ATA_SHT_EMULATED,		\
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,	\
 	.proc_name		= drv_name,			\
-- 
1.8.5.2

