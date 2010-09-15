From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] tcm_loop: Add DMA_BIDIRECTIONAL CDB support
Date: Wed, 15 Sep 2010 05:06:52 -0700
Message-ID: <1284552412-30567-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:46987 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753284Ab0IOMG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 08:06:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch series adds DMA_BIDIRECTIONAL CDB to the TCM_Loop Virtual SCSI
LLD module.  This includes the following changes:

	*) Add call to include/scsi/scsi_cmnd.h:scsi_bidi_cmnd() to set
	   TCM struct se_cmd internal data_direction in tcm_loop_allocate_core_cmd()
	*) Update tcm_loop_new_cmd_map() to handle BIDI READ payload from scsi_in()
	*) Drop DMA_BIDIRECTIONAL usage check from tcm_loop_queuecommand()
	*) Add tcm_loop_slave_alloc() and tcm_loop_slave_configure() handlers for
	   struct scsi_host_template to set QUEUE_FLAG_BIDI in the former.

So far this has been tested together with commit 1f8f3eda132c using XDWRITE_READ_10
via BSG userspace code on a v2.6.36-rc3 kernel.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   48 ++++++++++++++++++------
 1 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 644f978..c4139d8 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -64,6 +64,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	struct tcm_loop_nexus *tl_nexus = tl_hba->tl_nexus;
 	struct tcm_loop_cmd *tl_cmd;
 	int sam_task_attr;
+	enum dma_data_direction data_direction;
 
 	if (!(tl_nexus)) {
 		scmd_printk(KERN_ERR, sc, "TCM_Loop I_T Nexus"
@@ -81,6 +82,13 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	 * Save the pointer to struct scsi_cmnd *sc
 	 */
 	tl_cmd->sc = sc;
+	/*
+	 * Check for scsi_bidi_cmnd() to signal TCM Core for DMA_BIDIRECTIONAL
+	 */
+	if (scsi_bidi_cmnd(sc))
+		data_direction = DMA_BIDIRECTIONAL;
+	else
+		data_direction = sc->sc_data_direction;
 
 	/*
 	 * Locate the SAM Task Attr from struct scsi_cmnd *
@@ -105,7 +113,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			scsi_bufflen(sc), sc->sc_data_direction, sam_task_attr,
+			scsi_bufflen(sc), data_direction, sam_task_attr,
 			&tl_cmd->tl_sense_buf[0]);
 	/*
 	 * Locate the struct se_lun pointer and attach it to struct se_cmd
@@ -128,14 +136,16 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 /*
  * Called by struct target_core_fabric_ops->new_cmd_map()
  *
- * Always called in process context
+ * Always called in process context.  A non zero return value
+ * here will signal to handle an exception based on the return code.
  */
 int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
-	void *mem_ptr;
+	void *mem_ptr, *mem_bidi_ptr = NULL;
+	u32 sg_no_bidi = 0;
 	int ret;
 	/*
 	 * Allocate the necessary tasks to complete the received CDB+data
@@ -163,6 +173,16 @@ int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 	if (scsi_sg_count(sc)) {
 		se_cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM;
 		mem_ptr = (void *)scsi_sglist(sc);
+		/*
+		 * For BIDI commands, pass in the extra READ buffer
+		 * to transport_generic_map_mem_to_cmd() below..
+		 */
+		if (se_cmd->data_direction == DMA_BIDIRECTIONAL) {
+			struct scsi_data_buffer *sdb = scsi_in(sc);
+
+			mem_bidi_ptr = (void *)sdb->table.sgl;
+			sg_no_bidi = sdb->table.nents;
+		}
 	} else {
 		/*
 		 * Used for DMA_NONE
@@ -322,15 +342,6 @@ static int tcm_loop_queuecommand(
 	}
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	se_tpg = &tl_tpg->tl_se_tpg;
-
-	if (sc->sc_data_direction == DMA_BIDIRECTIONAL) {
-		spin_lock_irq(host->host_lock);
-		printk(KERN_ERR "Unsupported BIDI sc->sc_data_direction: %d\n",
-			sc->sc_data_direction);	
-		sc->result = host_byte(DID_ERROR);
-		(*done)(sc);
-		return 0;
-	}
 	/*
 	 * Determine the SAM Task Attribute and allocate tl_cmd and
 	 * tl_cmd->tl_se_cmd from TCM infrastructure
@@ -446,6 +457,17 @@ release:
 	return ret;
 }
 
+static int tcm_loop_slave_alloc(struct scsi_device *sd)
+{
+	set_bit(QUEUE_FLAG_BIDI, &sd->request_queue->queue_flags);
+	return 0;
+}
+
+static int tcm_loop_slave_configure(struct scsi_device *sd)
+{
+	return 0;
+}
+
 static struct scsi_host_template tcm_loop_driver_template = {
 	.proc_info		= tcm_loop_proc_info,
 	.proc_name		= "tcm_loopback",
@@ -468,6 +490,8 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.cmd_per_lun		= TL_SCSI_CMD_PER_LUN,
 	.max_sectors		= TL_SCSI_MAX_SECTORS,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.slave_alloc		= tcm_loop_slave_alloc,
+	.slave_configure	= tcm_loop_slave_configure,
 	.module			= THIS_MODULE,
 };
 
-- 
1.5.6.5

