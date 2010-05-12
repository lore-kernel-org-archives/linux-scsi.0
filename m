From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] [TCM_Loop]: Add proper HBA defaults to struct Scsi_Host
Date: Wed, 12 May 2010 00:35:28 -0700
Message-ID: <1273649728-21723-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:45158 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584Ab0ELFSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 01:18:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.e>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes the original hardcoded values and uses the following defs for
TCM_Loop fabric module defaults for the struct Scsi_Host LLD.  The defaults for
struct scsi_host_template->[can_queue,cmd_per_lun] have been increased to 1024,
and ->max_sectors to 256.

This patch also proper sets ->max_cmd_len=16 in tcm_loop_driver_probe() that was
causing 16-byte CDBs to fail with TCM_Loop ports and SG_IO.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_core.h        |   14 ++++++++++++++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    9 +++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index cb0aeb5..a160082 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -1,6 +1,20 @@
 #define TCM_LOOP_VERSION		"v1.0"
 #define TL_NAA_SAS_ADDR_LEN		64
 #define TL_TPGS_PER_HBA			32
+/*
+ * Defaults for struct scsi_host_template tcm_loop_driver_template
+ *
+ * We use large can_queue and cmd_per_lun here and let TCM enforce
+ * the underlying se_device_t->queue_depth.
+ */
+#define TL_SCSI_CAN_QUEUE		1024
+#define TL_SCSI_CMD_PER_LUN		1024
+#define TL_SCSI_MAX_SECTORS		256
+#define TL_SCSI_SG_TABLESIZE		256
+/*
+ * Used in tcm_loop_driver_probe() for struct Scsi_Host->max_cmd_len
+ */
+#define TL_SCSI_MAX_CMD_LEN		16
 
 #ifdef TCM_LOOP_CDB_DEBUG
 # define TL_CDB_DEBUG(x...)		printk(KERN_INFO x)
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 5417579..66c02c9 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -391,11 +391,11 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.eh_device_reset_handler = NULL,
 	.eh_host_reset_handler	= NULL,
 	.bios_param		= NULL,
-	.can_queue		= 1,
+	.can_queue		= TL_SCSI_CAN_QUEUE,
 	.this_id		= -1,
-	.sg_tablesize		= 256,
-	.cmd_per_lun		= 1,
-	.max_sectors		= 128,
+	.sg_tablesize		= TL_SCSI_SG_TABLESIZE,
+	.cmd_per_lun		= TL_SCSI_CMD_PER_LUN,
+	.max_sectors		= TL_SCSI_MAX_SECTORS,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.module			= THIS_MODULE,
 };
@@ -426,6 +426,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh->max_id = 2;
 	sh->max_lun = 0;
 	sh->max_channel = 0;
+	sh->max_cmd_len = TL_SCSI_MAX_CMD_LEN;
 
 	error = scsi_add_host(sh, &tl_hba->dev);
 	if (error) {
-- 
1.5.6.5

