From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/8 ver2] scsi-drivers Don't use SG_ALL as allocation
 size
Date: Thu, 17 Jan 2008 20:57:21 +0200
Message-ID: <478FA511.6000208@panasas.com>
References: <478F8435.5000907@panasas.com> <478F85E7.20503@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:57744 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYAQS54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 13:57:56 -0500
In-Reply-To: <478F85E7.20503@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Subject: [PATCH] scsi-drivers Don't use SG_ALL as allocation size

  below list of drivers have used SG_ALL as a size to
  preallocate maximum possible command's sg-count.
  This is no longer possible since the maximum is not
  set at compile time but as a run time configuration.

  A better schema can be advised with a more dynamic allocation.
  Perhaps from a kmem_cache.

  Affected drivers/files:
	drivers/scsi/atari_scsi.[ch]
	drivers/scsi/eata_pio.c
	drivers/scsi/ibmvscsi/ibmvscsi.[ch]
	drivers/scsi/mac53c94.c
	drivers/scsi/mesh.c
	drivers/scsi/nsp32.h
	drivers/scsi/qla1280.c

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/atari_scsi.c        |    8 ++++----
 drivers/scsi/atari_scsi.h        |    4 ++--
 drivers/scsi/eata_pio.c          |    5 ++++-
 drivers/scsi/ibmvscsi/ibmvscsi.c |    8 +++++---
 drivers/scsi/ibmvscsi/ibmvscsi.h |    1 +
 drivers/scsi/mac53c94.c          |    8 ++++++--
 drivers/scsi/mesh.c              |    5 ++++-
 drivers/scsi/nsp32.h             |    2 +-
 drivers/scsi/qla1280.c           |    3 ++-
 9 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index f5732d8..b47b61d 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -620,7 +620,8 @@ int atari_scsi_detect(struct scsi_host_template *host)
 	/* Force sg_tablesize to 0 on a Falcon! */
 	host->sg_tablesize =
 		!IS_A_TT() ? ATARI_FALCON_SG_TABLESIZE :
-		(setup_sg_tablesize >= 0) ? setup_sg_tablesize : ATARI_TT_SG_TABLESIZE;
+		(setup_sg_tablesize > 0) ? setup_sg_tablesize :
+							ATARI_TT_SG_TABLESIZE;
 
 	if (setup_hostid >= 0)
 		host->this_id = setup_hostid;
@@ -792,9 +793,8 @@ void __init atari_scsi_setup(char *str, int *ints)
 	if (ints[0] >= 3) {
 		if (ints[3] >= 0) {
 			setup_sg_tablesize = ints[3];
-			/* Must be <= SG_ALL (255) */
-			if (setup_sg_tablesize > SG_ALL)
-				setup_sg_tablesize = SG_ALL;
+			if (setup_sg_tablesize > ATARI_TT_SG_TABLESIZE)
+				setup_sg_tablesize = ATARI_TT_SG_TABLESIZE;
 		}
 	}
 	if (ints[0] >= 4) {
diff --git a/drivers/scsi/atari_scsi.h b/drivers/scsi/atari_scsi.h
index efadb8d..21b8c91 100644
--- a/drivers/scsi/atari_scsi.h
+++ b/drivers/scsi/atari_scsi.h
@@ -35,11 +35,11 @@ int atari_scsi_release (struct Scsi_Host *);
 
 #define ATARI_TT_CAN_QUEUE		16
 #define ATARI_TT_CMD_PER_LUN		8
-#define ATARI_TT_SG_TABLESIZE		SG_ALL
+#define ATARI_TT_SG_TABLESIZE		255
 
 #define ATARI_FALCON_CAN_QUEUE		8
 #define ATARI_FALCON_CMD_PER_LUN	1
-#define ATARI_FALCON_SG_TABLESIZE	SG_NONE
+#define ATARI_FALCON_SG_TABLESIZE	1
 
 #define	DEFAULT_USE_TAGGED_QUEUING	0
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index b5a6092..8913d9d 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -691,6 +691,9 @@ static unsigned int print_selftest(unsigned int base)
 	return (!(inb(base + HA_RSTATUS) & HA_SERROR));
 }
 
+/* FIXME: is this driver sg-chainning ready? */
+#define EATA_MAX_SG 255
+
 static int register_pio_HBA(long base, struct get_conf *gc, struct pci_dev *pdev)
 {
 	unsigned long size = 0;
@@ -801,7 +804,7 @@ static int register_pio_HBA(long base, struct get_conf *gc, struct pci_dev *pdev
 	sh->this_id = gc->scsi_id[3];
 	sh->can_queue = 1;
 	sh->cmd_per_lun = 1;
-	sh->sg_tablesize = SG_ALL;
+	sh->sg_tablesize = EATA_MAX_SG;
 
 	hd->channel = 0;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 78d46a9..9b1fc94 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -173,7 +173,8 @@ static void release_event_pool(struct event_pool *pool,
 			++in_use;
 		if (pool->events[i].ext_list) {
 			dma_free_coherent(hostdata->dev,
-				  SG_ALL * sizeof(struct srp_direct_buf),
+				  IBMVSCSI_MAX_SG *
+						sizeof(struct srp_direct_buf),
 				  pool->events[i].ext_list,
 				  pool->events[i].ext_list_token);
 		}
@@ -423,7 +424,8 @@ static int map_sg_data(struct scsi_cmnd *cmd,
 	if (!evt_struct->ext_list) {
 		evt_struct->ext_list = (struct srp_direct_buf *)
 			dma_alloc_coherent(dev,
-					   SG_ALL * sizeof(struct srp_direct_buf),
+					   IBMVSCSI_MAX_SG *
+						sizeof(struct srp_direct_buf),
 					   &evt_struct->ext_list_token, 0);
 		if (!evt_struct->ext_list) {
 			sdev_printk(KERN_ERR, cmd->device,
@@ -1598,7 +1600,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun = 16,
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
-	.sg_tablesize = SG_ALL,
+	.sg_tablesize = IBMVSCSI_MAX_SG,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ibmvscsi_attrs,
 };
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
index 46e850e..e3e3a2e 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -46,6 +46,7 @@ struct Scsi_Host;
 
 #define IBMVSCSI_MAX_REQUESTS_DEFAULT 100
 #define IBMVSCSI_MAX_CMDS_PER_LUN 64
+#define IBMVSCSI_MAX_SG 255
 
 /* ------------------------------------------------------------
  * Data Structures
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index b12ad7c..9ef0272 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -392,6 +392,9 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 	cmd->SCp.this_residual = total;
 }
 
+/* Dynamicaly allocated at init */
+#define MAC53c94_MAX_SG 255
+
 static struct scsi_host_template mac53c94_template = {
 	.proc_name	= "53c94",
 	.name		= "53C94",
@@ -399,7 +402,7 @@ static struct scsi_host_template mac53c94_template = {
 	.eh_host_reset_handler = mac53c94_host_reset,
 	.can_queue	= 1,
 	.this_id	= 7,
-	.sg_tablesize	= SG_ALL,
+	.sg_tablesize	= MAC53c94_MAX_SG,
 	.cmd_per_lun	= 1,
 	.use_clustering	= DISABLE_CLUSTERING,
 };
@@ -464,7 +467,8 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 	 * XXX FIXME: Use DMA consistent routines
 	 */
        	dma_cmd_space = kmalloc((host->sg_tablesize + 2) *
-       				sizeof(struct dbdma_cmd), GFP_KERNEL);
+				sizeof(struct dbdma_cmd),
+				GFP_KERNEL | GFP_DMA);
        	if (dma_cmd_space == 0) {
        		printk(KERN_ERR "mac53c94: couldn't allocate dma "
        		       "command space for %s\n", node->full_name);
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 651d09b..2a8654a 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1832,6 +1832,9 @@ static int mesh_shutdown(struct macio_dev *mdev)
 	return 0;
 }
 
+/* allocated at probe time */
+#define MESH_MAX_SG 255
+
 static struct scsi_host_template mesh_template = {
 	.proc_name			= "mesh",
 	.name				= "MESH",
@@ -1840,7 +1843,7 @@ static struct scsi_host_template mesh_template = {
 	.eh_host_reset_handler		= mesh_host_reset,
 	.can_queue			= 20,
 	.this_id			= 7,
-	.sg_tablesize			= SG_ALL,
+	.sg_tablesize			= MESH_MAX_SG,
 	.cmd_per_lun			= 2,
 	.use_clustering			= DISABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index 6715ecb..ace52f5 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -444,7 +444,7 @@ typedef u16 u16_le;
 /************************************************************************
  * structure for DMA/Scatter Gather list
  */
-#define NSP32_SG_SIZE		SG_ALL
+#define NSP32_SG_SIZE		255
 
 typedef struct _nsp32_sgtable {
 	/* values must be little endian */
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 68c0d09..c0319da 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -422,6 +422,7 @@
 #define IS_ISP1x160(ha)        (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160 || \
 				ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160)
 
+#define QLA_MAX_SG 255
 
 static int qla1280_probe_one(struct pci_dev *, const struct pci_device_id *);
 static void qla1280_remove_one(struct pci_dev *);
@@ -4201,7 +4202,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.bios_param		= qla1280_biosparam,
 	.can_queue		= 0xfffff,
 	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= QLA_MAX_SG,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-- 
1.5.3.3


