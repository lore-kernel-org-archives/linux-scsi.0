From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] add use_sg_chaining option to scsi_host_template
Date: Fri, 17 Aug 2007 01:47:59 +0900
Message-ID: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60902 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934189AbXHPQs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2007 12:48:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

This is for Jens' sglist branch in the block git tree.

It enables sg chaining support for the LLDs that use scsi_for_each_sg
accessor properly.

---
>From a6e50a3b476bc193de103e8c1d95877ced38918e Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 17 Aug 2007 01:35:41 +0900
Subject: [PATCH] add use_sg_chaining option to scsi_host_template

This option is true if a low-level driver can support sg
chaining. This will be removed eventually when all the drivers are
converted to support sg chaining. q->max_phys_segments is set to
SCSI_MAX_SG_SEGMENTS if false.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/sim/simscsi.c            |    1 +
 drivers/scsi/3w-9xxx.c                |    1 +
 drivers/scsi/3w-xxxx.c                |    1 +
 drivers/scsi/BusLogic.c               |    1 +
 drivers/scsi/NCR53c406a.c             |    3 ++-
 drivers/scsi/a100u2w.c                |    1 +
 drivers/scsi/aacraid/linit.c          |    1 +
 drivers/scsi/aha1740.c                |    1 +
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    1 +
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    1 +
 drivers/scsi/aic7xxx_old.c            |    1 +
 drivers/scsi/arcmsr/arcmsr_hba.c      |    1 +
 drivers/scsi/dc395x.c                 |    1 +
 drivers/scsi/dpt_i2o.c                |    1 +
 drivers/scsi/eata.c                   |    3 ++-
 drivers/scsi/hosts.c                  |    1 +
 drivers/scsi/hptiop.c                 |    1 +
 drivers/scsi/ibmmca.c                 |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    1 +
 drivers/scsi/initio.c                 |    1 +
 drivers/scsi/ipr.c                    |    1 +
 drivers/scsi/lpfc/lpfc_scsi.c         |    2 ++
 drivers/scsi/mac53c94.c               |    1 +
 drivers/scsi/megaraid.c               |    1 +
 drivers/scsi/megaraid/megaraid_mbox.c |    1 +
 drivers/scsi/megaraid/megaraid_sas.c  |    1 +
 drivers/scsi/mesh.c                   |    1 +
 drivers/scsi/nsp32.c                  |    1 +
 drivers/scsi/pcmcia/sym53c500_cs.c    |    1 +
 drivers/scsi/qla2xxx/qla_os.c         |    2 ++
 drivers/scsi/qla4xxx/ql4_os.c         |    1 +
 drivers/scsi/qlogicfas.c              |    1 +
 drivers/scsi/scsi_lib.c               |    5 ++++-
 drivers/scsi/stex.c                   |    1 +
 drivers/scsi/sym53c416.c              |    1 +
 drivers/scsi/sym53c8xx_2/sym_glue.c   |    1 +
 drivers/scsi/u14-34f.c                |    1 +
 drivers/scsi/ultrastor.c              |    1 +
 drivers/scsi/wd7000.c                 |    1 +
 include/scsi/scsi_host.h              |   13 +++++++++++++
 40 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index e62694f..6fc2cba 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -361,6 +361,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= 1024,
 	.cmd_per_lun		= SIMSCSI_REQ_QUEUE_LEN,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static int __init
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index efd9d8d..fb14014 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1990,6 +1990,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= twa_host_attrs,
 	.emulated		= 1
 };
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c7995fc..a64153b 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2261,6 +2261,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= tw_host_attrs,
 	.emulated		= 1
 };
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 9b20617..49e1ffa 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3575,6 +3575,7 @@ static struct scsi_host_template Bus_Logic_template = {
 	.unchecked_isa_dma = 1,
 	.max_sectors = 128,
 	.use_clustering = ENABLE_CLUSTERING,
+	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 /*
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index eda8c48..3168a17 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -1066,7 +1066,8 @@ static struct scsi_host_template driver_template =
      .sg_tablesize      	= 32			/*SG_ALL*/ /*SG_NONE*/, 
      .cmd_per_lun       	= 1			/* commands per lun */, 
      .unchecked_isa_dma 	= 1			/* unchecked_isa_dma */,
-     .use_clustering    	= ENABLE_CLUSTERING                               
+     .use_clustering    	= ENABLE_CLUSTERING,
+     .use_sg_chaining           = ENABLE_SG_CHAINING,
 };
 
 #include "scsi_module.c"
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index f608d4a..d3a6d15 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1071,6 +1071,7 @@ static struct scsi_host_template inia100_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun 		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static int __devinit inia100_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a7f42a1..038980b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -944,6 +944,7 @@ static struct scsi_host_template aac_driver_template = {
 	.cmd_per_lun    		= AAC_NUM_IO_FIB, 
 #endif	
 	.use_clustering			= ENABLE_CLUSTERING,
+	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.emulated                       = 1,
 };
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index e4a4f3a..f6722fd 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -563,6 +563,7 @@ static struct scsi_host_template aha1740_template = {
 	.sg_tablesize     = AHA1740_SCATTER,
 	.cmd_per_lun      = AHA1740_CMDLUN,
 	.use_clustering   = ENABLE_CLUSTERING,
+	.use_sg_chaining  = ENABLE_SG_CHAINING,
 	.eh_abort_handler = aha1740_eh_abort_handler,
 };
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index a055a96..42c0f14 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -766,6 +766,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.slave_alloc		= ahd_linux_slave_alloc,
 	.slave_configure	= ahd_linux_slave_configure,
 	.target_alloc		= ahd_linux_target_alloc,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2e9c38f..7770bef 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -747,6 +747,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.slave_alloc		= ahc_linux_slave_alloc,
 	.slave_configure	= ahc_linux_slave_configure,
 	.target_alloc		= ahc_linux_target_alloc,
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 4998bb8..19dbc2f 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -11144,6 +11144,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors		= 2048,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 #include "scsi_module.c"
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 0ddfc21..d5039f3 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -121,6 +121,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.max_sectors    	= ARCMSR_MAX_XFER_SECTORS,
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= arcmsr_host_attrs,
 };
 static struct pci_error_handlers arcmsr_pci_error_handlers = {
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 7b8a345..d2a2026 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4765,6 +4765,7 @@ static struct scsi_host_template dc395x_driver_template = {
 	.eh_bus_reset_handler   = dc395x_eh_bus_reset,
 	.unchecked_isa_dma      = 0,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 502732a..e276d40 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3300,6 +3300,7 @@ static struct scsi_host_template adpt_template = {
 	.this_id		= 7,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static s32 adpt_scsi_register(adpt_hba* pHba)
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a83e9f1..2f685cf 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -523,7 +523,8 @@ static struct scsi_host_template driver_template = {
 	.slave_configure = eata2x_slave_configure,
 	.this_id = 7,
 	.unchecked_isa_dma = 1,
-	.use_clustering = ENABLE_CLUSTERING
+	.use_clustering = ENABLE_CLUSTERING,
+	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 96bc312..8c42539 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -342,6 +342,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->use_sg_chaining = sht->use_sg_chaining;
 
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 0e579ca..9552c93 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -634,6 +634,7 @@ static struct scsi_host_template driver_template = {
 	.unchecked_isa_dma          = 0,
 	.emulated                   = 0,
 	.use_clustering             = ENABLE_CLUSTERING,
+	.use_sg_chaining            = ENABLE_SG_CHAINING,
 	.proc_name                  = driver_name,
 	.shost_attrs                = hptiop_attrs,
 	.this_id                    = -1,
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4275d1b..a3d8d75 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1508,6 +1508,7 @@ static struct scsi_host_template ibmmca_driver_template = {
           .sg_tablesize   = 16,
           .cmd_per_lun    = 1,
           .use_clustering = ENABLE_CLUSTERING,
+          .use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 static int ibmmca_probe(struct device *dev)
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 5ecc63d..46a4b24 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1542,6 +1542,7 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
 	.use_clustering = ENABLE_CLUSTERING,
+	.use_sg_chaining = ENABLE_SG_CHAINING,
 	.shost_attrs = ibmvscsi_attrs,
 };
 
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index d9dfb69..22d40fd 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2831,6 +2831,7 @@ static struct scsi_host_template initio_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static int initio_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f142eaf..bec4139 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4949,6 +4949,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors = IPR_IOA_MAX_SECTORS,
 	.cmd_per_lun = IPR_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
+	.use_sg_chaining = ENABLE_SG_CHAINING,
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 17d7dc0..71c7e22 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1439,6 +1439,7 @@ struct scsi_host_template lpfc_template = {
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_SG_SEG_CNT,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_hba_attrs,
@@ -1461,6 +1462,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.sg_tablesize		= LPFC_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 };
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index b12ad7c..a035001 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -402,6 +402,7 @@ static struct scsi_host_template mac53c94_template = {
 	.sg_tablesize	= SG_ALL,
 	.cmd_per_lun	= 1,
 	.use_clustering	= DISABLE_CLUSTERING,
+	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *match)
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3907f67..5716e92 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4485,6 +4485,7 @@ static struct scsi_host_template megaraid_template = {
 	.sg_tablesize			= MAX_SGLIST,
 	.cmd_per_lun			= DEF_CMD_PER_LUN,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.eh_abort_handler		= megaraid_abort,
 	.eh_device_reset_handler	= megaraid_reset,
 	.eh_bus_reset_handler		= megaraid_reset,
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index c6a53dc..e4e4c6a 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -361,6 +361,7 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.sdev_attrs			= megaraid_sdev_attrs,
 	.shost_attrs			= megaraid_shost_attrs,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index ebb948c..e3c5c52 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1110,6 +1110,7 @@ static struct scsi_host_template megasas_template = {
 	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
+	.use_sg_chaining = ENABLE_SG_CHAINING,
 };
 
 /**
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 651d09b..7470ff3 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1843,6 +1843,7 @@ static struct scsi_host_template mesh_template = {
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= 2,
 	.use_clustering			= DISABLE_CLUSTERING,
+	.use_sg_chaining		= ENABLE_SG_CHAINING,
 };
 
 static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 7fed353..28161dc 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -281,6 +281,7 @@ static struct scsi_host_template nsp32_template = {
 	.cmd_per_lun			= 1,
 	.this_id			= NSP32_HOST_SCSIID,
 	.use_clustering			= DISABLE_CLUSTERING,
+	.use_sg_chaining		= ENABLE_SG_CHAINING,
 	.eh_abort_handler       	= nsp32_eh_abort,
 	.eh_bus_reset_handler		= nsp32_eh_bus_reset,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 961839e..190e2a7 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -694,6 +694,7 @@ static struct scsi_host_template sym53c500_driver_template = {
      .sg_tablesize		= 32,
      .cmd_per_lun		= 1,
      .use_clustering		= ENABLE_CLUSTERING,
+     .use_sg_chaining		= ENABLE_SG_CHAINING,
      .shost_attrs		= SYM53C500_shost_attrs
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 93c0c7e..dd61832 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -132,6 +132,7 @@ struct scsi_host_template qla2x00_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.sg_tablesize		= SG_ALL,
 
 	/*
@@ -163,6 +164,7 @@ struct scsi_host_template qla24xx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b1d565c..03b68d4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -94,6 +94,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 94baca8..2268ca1 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -197,6 +197,7 @@ static struct scsi_host_template qlogicfas_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 static __init int qlogicfas_init(void)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f05f006..7eb9972 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1674,7 +1674,10 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 * converted, so better keep it safe.
 	 */
 #ifdef ARCH_HAS_SG_CHAIN
-	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+	if (shost->use_sg_chaining)
+		blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+	else
+		blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
 #else
 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
 #endif
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 72f6d80..e3fab3a 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1123,6 +1123,7 @@ static struct scsi_host_template driver_template = {
 	.this_id			= -1,
 	.sg_tablesize			= ST_MAX_SG,
 	.cmd_per_lun			= ST_CMD_PER_LUN,
+	.use_sg_chaining		= ENABLE_SG_CHAINING,
 };
 
 static int stex_set_dma_mask(struct pci_dev * pdev)
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 92bfaea..8befab7 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -854,5 +854,6 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun =		1,
 	.unchecked_isa_dma =	1,
 	.use_clustering =	ENABLE_CLUSTERING,
+	.use_sg_chaining =	ENABLE_SG_CHAINING,
 };
 #include "scsi_module.c"
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 3db2232..db03c4c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1808,6 +1808,7 @@ static struct scsi_host_template sym2_template = {
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.max_sectors		= 0xFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 9e8232a..a0d9ef4 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -451,6 +451,7 @@ static struct scsi_host_template driver_template = {
                 .this_id                 = 7,
                 .unchecked_isa_dma       = 1,
                 .use_clustering          = ENABLE_CLUSTERING
+                .use_sg_chaining         = ENABLE_SG_CHAINING,
                 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index c08235d..ea72bbe 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -1197,5 +1197,6 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun       = ULTRASTOR_MAX_CMDS_PER_LUN,
 	.unchecked_isa_dma = 1,
 	.use_clustering    = ENABLE_CLUSTERING,
+	.use_sg_chaining   = ENABLE_SG_CHAINING,
 };
 #include "scsi_module.c"
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index d6fd425..255c611 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1671,6 +1671,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= 1,
 	.unchecked_isa_dma	= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 #include "scsi_module.c"
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b8a6a8..cbb5217 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -36,6 +36,9 @@ struct blk_queue_tags;
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
+#define DISABLE_SG_CHAINING 0
+#define ENABLE_SG_CHAINING 1
+
 enum scsi_eh_timer_return {
 	EH_NOT_HANDLED,
 	EH_HANDLED,
@@ -438,6 +441,15 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * true if the low-level driver can support sg chaining. this
+	 * will be removed eventually when all the drivers are
+	 * converted to support sg chaining.
+	 *
+	 * Status: OBSOLETE
+	 */
+	unsigned use_sg_chaining:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;
@@ -580,6 +592,7 @@ struct Scsi_Host {
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
+	unsigned use_sg_chaining:1;
 
 	/*
 	 * Host has requested that no further requests come through for the
-- 
1.5.2.4

