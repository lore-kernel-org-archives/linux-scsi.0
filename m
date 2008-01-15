From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] remove use_sg_chaining
Date: Tue, 15 Jan 2008 11:52:58 -0600
Message-ID: <1200419579.9273.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45456 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbYAORxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 12:53:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id F2A228282
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2008 11:53:02 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id koYeeAzM+Lh5 for <linux-scsi@vger.kernel.org>;
	Tue, 15 Jan 2008 11:52:59 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 799528279
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2008 11:52:59 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

this patch depends on the sg branch of the block tree

James

---
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 15 Jan 2008 11:11:46 -0600
Subject: remove use_sg_chaining

With the sg table code, every SCSI driver is now either chain capable
or broken, so there's no need to have a check in the host template.

Also tidy up the code by moving the scatterlist size defines into the
SCSI includes and permit the last entry of the scatterlist pools not
to be a power of two.
---
 arch/ia64/hp/sim/simscsi.c            |    1 -
 drivers/scsi/3w-9xxx.c                |    1 -
 drivers/scsi/3w-xxxx.c                |    1 -
 drivers/scsi/BusLogic.c               |    1 -
 drivers/scsi/NCR53c406a.c             |    1 -
 drivers/scsi/a100u2w.c                |    1 -
 drivers/scsi/aacraid/linit.c          |    1 -
 drivers/scsi/aha1740.c                |    1 -
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    1 -
 drivers/scsi/aic7xxx_old.c            |    1 -
 drivers/scsi/arcmsr/arcmsr_hba.c      |    1 -
 drivers/scsi/dc395x.c                 |    1 -
 drivers/scsi/dpt_i2o.c                |    1 -
 drivers/scsi/eata.c                   |    1 -
 drivers/scsi/hosts.c                  |    1 -
 drivers/scsi/hptiop.c                 |    1 -
 drivers/scsi/ibmmca.c                 |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    1 -
 drivers/scsi/initio.c                 |    1 -
 drivers/scsi/iscsi_tcp.c              |    1 -
 drivers/scsi/lpfc/lpfc_scsi.c         |    2 -
 drivers/scsi/mac53c94.c               |    1 -
 drivers/scsi/megaraid.c               |    1 -
 drivers/scsi/megaraid/megaraid_mbox.c |    1 -
 drivers/scsi/megaraid/megaraid_sas.c  |    1 -
 drivers/scsi/mesh.c                   |    1 -
 drivers/scsi/nsp32.c                  |    1 -
 drivers/scsi/pcmcia/sym53c500_cs.c    |    1 -
 drivers/scsi/qla1280.c                |    1 -
 drivers/scsi/qla2xxx/qla_os.c         |    2 -
 drivers/scsi/qla4xxx/ql4_os.c         |    1 -
 drivers/scsi/qlogicfas.c              |    1 -
 drivers/scsi/scsi_lib.c               |   72 ++++++++-------------------------
 drivers/scsi/stex.c                   |    1 -
 drivers/scsi/sym53c416.c              |    1 -
 drivers/scsi/sym53c8xx_2/sym_glue.c   |    1 -
 drivers/scsi/u14-34f.c                |    1 -
 drivers/scsi/ultrastor.c              |    1 -
 drivers/scsi/wd7000.c                 |    1 -
 include/scsi/scsi.h                   |   19 +++++++++
 include/scsi/scsi_host.h              |   13 ------
 42 files changed, 36 insertions(+), 109 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 6ef9b52..7661bb0 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -360,7 +360,6 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= 1024,
 	.cmd_per_lun		= SIMSCSI_REQ_QUEUE_LEN,
 	.use_clustering		= DISABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static int __init
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 1c24483..b4912d1 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1990,7 +1990,6 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= twa_host_attrs,
 	.emulated		= 1
 };
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 59716eb..d095321 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2261,7 +2261,6 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= tw_host_attrs,
 	.emulated		= 1
 };
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index ead47c1..4d3ebb1 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3575,7 +3575,6 @@ static struct scsi_host_template Bus_Logic_template = {
 	.unchecked_isa_dma = 1,
 	.max_sectors = 128,
 	.use_clustering = ENABLE_CLUSTERING,
-	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 /*
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 137d065..6961f78 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -1065,7 +1065,6 @@ static struct scsi_host_template driver_template =
      .cmd_per_lun       	= 1			/* commands per lun */, 
      .unchecked_isa_dma 	= 1			/* unchecked_isa_dma */,
      .use_clustering    	= ENABLE_CLUSTERING,
-     .use_sg_chaining           = ENABLE_SG_CHAINING,
 };
 
 #include "scsi_module.c"
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index d3a6d15..f608d4a 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1071,7 +1071,6 @@ static struct scsi_host_template inia100_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun 		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static int __devinit inia100_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 143e4c1..c844288 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1000,7 +1000,6 @@ static struct scsi_host_template aac_driver_template = {
 	.cmd_per_lun    		= AAC_NUM_IO_FIB, 
 #endif	
 	.use_clustering			= ENABLE_CLUSTERING,
-	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.emulated                       = 1,
 };
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index be58a0b..7c45d88 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -563,7 +563,6 @@ static struct scsi_host_template aha1740_template = {
 	.sg_tablesize     = AHA1740_SCATTER,
 	.cmd_per_lun      = AHA1740_CMDLUN,
 	.use_clustering   = ENABLE_CLUSTERING,
-	.use_sg_chaining  = ENABLE_SG_CHAINING,
 	.eh_abort_handler = aha1740_eh_abort_handler,
 };
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 0e4708f..4eed504 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -766,7 +766,6 @@ struct scsi_host_template aic79xx_driver_template = {
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.slave_alloc		= ahd_linux_slave_alloc,
 	.slave_configure	= ahd_linux_slave_configure,
 	.target_alloc		= ahd_linux_target_alloc,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index e310e41..d6d074a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -747,7 +747,6 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.slave_alloc		= ahc_linux_slave_alloc,
 	.slave_configure	= ahc_linux_slave_configure,
 	.target_alloc		= ahc_linux_target_alloc,
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index bcb0b87..3bfd929 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -11141,7 +11141,6 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= 2048,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 #include "scsi_module.c"
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d80dba9..f4a202e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -122,7 +122,6 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.max_sectors    	= ARCMSR_MAX_XFER_SECTORS,
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= arcmsr_host_attrs,
 };
 #ifdef CONFIG_SCSI_ARCMSR_AER
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index f93c73c..22ef371 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4763,7 +4763,6 @@ static struct scsi_host_template dc395x_driver_template = {
 	.eh_bus_reset_handler   = dc395x_eh_bus_reset,
 	.unchecked_isa_dma      = 0,
 	.use_clustering         = DISABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 577b34c..86ac271 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3340,7 +3340,6 @@ static struct scsi_host_template driver_template = {
 	.this_id		= 7,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 #include "scsi_module.c"
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 05163ce..8be3d76 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -524,7 +524,6 @@ static struct scsi_host_template driver_template = {
 	.this_id = 7,
 	.unchecked_isa_dma = 1,
 	.use_clustering = ENABLE_CLUSTERING,
-	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 9a10b43..7e69efb 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -342,7 +342,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 	shost->active_mode = sht->supported_mode;
-	shost->use_sg_chaining = sht->use_sg_chaining;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index e7b2f35..443a4c1 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -906,7 +906,6 @@ static struct scsi_host_template driver_template = {
 	.unchecked_isa_dma          = 0,
 	.emulated                   = 0,
 	.use_clustering             = ENABLE_CLUSTERING,
-	.use_sg_chaining            = ENABLE_SG_CHAINING,
 	.proc_name                  = driver_name,
 	.shost_attrs                = hptiop_attrs,
 	.this_id                    = -1,
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index db004a4..4d15a62 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1501,7 +1501,6 @@ static struct scsi_host_template ibmmca_driver_template = {
           .sg_tablesize   = 16,
           .cmd_per_lun    = 1,
           .use_clustering = ENABLE_CLUSTERING,
-          .use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 static int ibmmca_probe(struct device *dev)
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3081901..78d46a9 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1600,7 +1600,6 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
 	.use_clustering = ENABLE_CLUSTERING,
-	.use_sg_chaining = ENABLE_SG_CHAINING,
 	.shost_attrs = ibmvscsi_attrs,
 };
 
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 01bf018..52238ee 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2832,7 +2832,6 @@ static struct scsi_host_template initio_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static int initio_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e5be5fd..b6f99df 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1933,7 +1933,6 @@ static struct scsi_host_template iscsi_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 883c915..6d8c814 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1464,7 +1464,6 @@ struct scsi_host_template lpfc_template = {
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_hba_attrs,
@@ -1487,7 +1486,6 @@ struct scsi_host_template lpfc_vport_template = {
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 };
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index a035001..b12ad7c 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -402,7 +402,6 @@ static struct scsi_host_template mac53c94_template = {
 	.sg_tablesize	= SG_ALL,
 	.cmd_per_lun	= 1,
 	.use_clustering	= DISABLE_CLUSTERING,
-	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *match)
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 765c24d..4d59ae8 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4490,7 +4490,6 @@ static struct scsi_host_template megaraid_template = {
 	.sg_tablesize			= MAX_SGLIST,
 	.cmd_per_lun			= DEF_CMD_PER_LUN,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.eh_abort_handler		= megaraid_abort,
 	.eh_device_reset_handler	= megaraid_reset,
 	.eh_bus_reset_handler		= megaraid_reset,
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 24e32e4..6db77c0 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -361,7 +361,6 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.sdev_attrs			= megaraid_sdev_attrs,
 	.shost_attrs			= megaraid_shost_attrs,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index d7ec921..672c759 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1192,7 +1192,6 @@ static struct scsi_host_template megasas_template = {
 	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
-	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 /**
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 7470ff3..651d09b 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1843,7 +1843,6 @@ static struct scsi_host_template mesh_template = {
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= 2,
 	.use_clustering			= DISABLE_CLUSTERING,
-	.use_sg_chaining		= ENABLE_SG_CHAINING,
 };
 
 static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 28161dc..7fed353 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -281,7 +281,6 @@ static struct scsi_host_template nsp32_template = {
 	.cmd_per_lun			= 1,
 	.this_id			= NSP32_HOST_SCSIID,
 	.use_clustering			= DISABLE_CLUSTERING,
-	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.eh_abort_handler       	= nsp32_eh_abort,
 	.eh_bus_reset_handler		= nsp32_eh_bus_reset,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 969b938..3454a57 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -692,7 +692,6 @@ static struct scsi_host_template sym53c500_driver_template = {
      .sg_tablesize		= 32,
      .cmd_per_lun		= 1,
      .use_clustering		= ENABLE_CLUSTERING,
-     .use_sg_chaining		= ENABLE_SG_CHAINING,
      .shost_attrs		= SYM53C500_shost_attrs
 };
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index c94906a..68c0d09 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4204,7 +4204,6 @@ static struct scsi_host_template qla1280_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a5bcf1f..78d1103 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -132,7 +132,6 @@ struct scsi_host_template qla2x00_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.sg_tablesize		= SG_ALL,
 
 	/*
@@ -164,7 +163,6 @@ struct scsi_host_template qla24xx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f55b9f7..b128da5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -94,7 +94,6 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 1769f96..1e874f1 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -197,7 +197,6 @@ static struct scsi_host_template qlogicfas_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static __init int qlogicfas_init(void)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f89a85..542ad03 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bio.h>
+#include <linux/bitops.h>
 #include <linux/blkdev.h>
 #include <linux/completion.h>
 #include <linux/kernel.h>
@@ -34,13 +35,6 @@
 #define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
-/*
- * The maximum number of SG segments that we will put inside a scatterlist
- * (unless chaining is used). Should ideally fit inside a single page, to
- * avoid a higher order allocation.
- */
-#define SCSI_MAX_SG_SEGMENTS	128
-
 struct scsi_host_sg_pool {
 	size_t		size;
 	char		*name;
@@ -49,18 +43,25 @@ struct scsi_host_sg_pool {
 };
 
 #define SP(x) { x, "sgpool-" #x }
+#if (SCSI_MAX_SG_SEGMENTS < 32)
+#error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
+#endif
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
 	SP(8),
 	SP(16),
-#if (SCSI_MAX_SG_SEGMENTS > 16)
-	SP(32),
 #if (SCSI_MAX_SG_SEGMENTS > 32)
-	SP(64),
+	SP(32),
 #if (SCSI_MAX_SG_SEGMENTS > 64)
+	SP(64),
+#if (SCSI_MAX_SG_SEGMENTS > 128)
 	SP(128),
+#if (SCSI_MAX_SG_SEGMENTS > 256)
+#error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
 #endif
 #endif
 #endif
+#endif
+	SP(SCSI_MAX_SG_SEGMENTS)
 };
 #undef SP
 
@@ -710,42 +711,16 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
-/*
- * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
- * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
- */
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
 
-	switch (nents) {
-	case 1 ... 8:
+	BUG_ON(nents > SCSI_MAX_SG_SEGMENTS);
+
+	if (nents <= 8)
 		index = 0;
-		break;
-	case 9 ... 16:
-		index = 1;
-		break;
-#if (SCSI_MAX_SG_SEGMENTS > 16)
-	case 17 ... 32:
-		index = 2;
-		break;
-#if (SCSI_MAX_SG_SEGMENTS > 32)
-	case 33 ... 64:
-		index = 3;
-		break;
-#if (SCSI_MAX_SG_SEGMENTS > 64)
-	case 65 ... 128:
-		index = 4;
-		break;
-#endif
-#endif
-#endif
-	default:
-		printk(KERN_ERR "scsi: bad segment count=%d\n", nents);
-		BUG();
-	}
+	else
+		index = get_count_order(nents) - 3;
 
 	return index;
 }
@@ -1614,20 +1589,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 * this limit is imposed by hardware restrictions
 	 */
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-
-	/*
-	 * In the future, sg chaining support will be mandatory and this
-	 * ifdef can then go away. Right now we don't have all archs
-	 * converted, so better keep it safe.
-	 */
-#ifdef ARCH_HAS_SG_CHAIN
-	if (shost->use_sg_chaining)
-		blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
-	else
-		blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
-#else
-	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
-#endif
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
 
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index e3fab3a..72f6d80 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1123,7 +1123,6 @@ static struct scsi_host_template driver_template = {
 	.this_id			= -1,
 	.sg_tablesize			= ST_MAX_SG,
 	.cmd_per_lun			= ST_CMD_PER_LUN,
-	.use_sg_chaining		= ENABLE_SG_CHAINING,
 };
 
 static int stex_set_dma_mask(struct pci_dev * pdev)
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 1f6fd16..6325901 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -840,6 +840,5 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun =		1,
 	.unchecked_isa_dma =	1,
 	.use_clustering =	ENABLE_CLUSTERING,
-	.use_sg_chaining =	ENABLE_SG_CHAINING,
 };
 #include "scsi_module.c"
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 21e926d..9716019 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1681,7 +1681,6 @@ static struct scsi_host_template sym2_template = {
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.max_sectors		= 0xFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 4bc5407..662c004 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -451,7 +451,6 @@ static struct scsi_host_template driver_template = {
                 .this_id                 = 7,
                 .unchecked_isa_dma       = 1,
                 .use_clustering          = ENABLE_CLUSTERING,
-                .use_sg_chaining         = ENABLE_SG_CHAINING,
                 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 1d3b029..d86302c 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -1197,6 +1197,5 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun       = ULTRASTOR_MAX_CMDS_PER_LUN,
 	.unchecked_isa_dma = 1,
 	.use_clustering    = ENABLE_CLUSTERING,
-	.use_sg_chaining   = ENABLE_SG_CHAINING,
 };
 #include "scsi_module.c"
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index b4304ae..c975c01 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1671,7 +1671,6 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= 1,
 	.unchecked_isa_dma	= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 #include "scsi_module.c"
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 702fcfe..056c5af 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,6 +11,25 @@
 #include <linux/types.h>
 
 /*
+ * The maximum number of SG segments that we will put inside a
+ * scatterlist (unless chaining is used). Should ideally fit inside a
+ * single page, to avoid a higher order allocation.  We could define this
+ * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The 
+ * minimum value is 32
+ */
+#define SCSI_MAX_SG_SEGMENTS	128
+
+/*
+ * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
+ * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
+ */
+#ifdef ARCH_HAS_SG_CHAIN
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
+#else
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
+#endif
+
+/*
  *	SCSI command lengths
  */
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index cb2bcab..5c58d59 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -39,9 +39,6 @@ struct blk_queue_tags;
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
-#define DISABLE_SG_CHAINING 0
-#define ENABLE_SG_CHAINING 1
-
 enum scsi_eh_timer_return {
 	EH_NOT_HANDLED,
 	EH_HANDLED,
@@ -446,15 +443,6 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
-	 * true if the low-level driver can support sg chaining. this
-	 * will be removed eventually when all the drivers are
-	 * converted to support sg chaining.
-	 *
-	 * Status: OBSOLETE
-	 */
-	unsigned use_sg_chaining:1;
-
-	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;
@@ -598,7 +586,6 @@ struct Scsi_Host {
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
-	unsigned use_sg_chaining:1;
 
 	/*
 	 * Host has requested that no further requests come through for the
-- 
1.5.3.7



