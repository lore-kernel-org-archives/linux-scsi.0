From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/6] tcm/ramdisk: Add special case for TFO->task_sg_chaining=1 with RAMDISK_DR
Date: Mon,  6 Sep 2010 14:37:20 -0700
Message-ID: <1283809040-13682-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a special case for RAMDISK_DR using the TFO->task_sg_chaining
presented in commit a552ae31039ca8, which is required as RAMDISK_DR is used in
READ-ONLY mode for our virtual LUN0.  This is done in order to setup
struct se_task->task_sg[] for the RAMDISK_DR struct se_task I/O descriptor,
and map internal ramdisk memory into SGLs used by transport_do_task_sg_chain().

Also note this patch currently prevents SCF_SCSI_DATA_SG_IO_CDB WRITE to
RAMDISK_DR backstores to prevent potentially multiple pci_map_sg() WRITE
calls to the same internally mapped RAMDISK_DR struct scatterlist memory.
This limitiation only effects RAMDISK_DR, and does not effect RAMDISK_MCP.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c |   45 +++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index c66fb77..dbf3b4c 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -40,6 +40,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
 #include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
 
 #include "target_core_rd.h"
 
@@ -1007,9 +1008,11 @@ static int rd_DIRECT_do_se_mem_map(
 	struct se_mem *in_se_mem,
 	struct se_mem **out_se_mem,
 	u32 *se_mem_cnt,
-	u32 *task_offset)
+	u32 *task_offset_in)
 {
+	struct se_cmd *cmd = task->task_se_cmd;
 	struct rd_request *req = (struct rd_request *) task->transport_req;
+	u32 task_offset = *task_offset_in;
 	int ret;
 
 	req->rd_lba = task->task_lba;
@@ -1023,12 +1026,46 @@ static int rd_DIRECT_do_se_mem_map(
 
 	if (req->rd_offset)
 		ret = rd_DIRECT_with_offset(task, se_mem_list, se_mem_cnt,
-				task_offset);
+				task_offset_in);
 	else
 		ret = rd_DIRECT_without_offset(task, se_mem_list, se_mem_cnt,
-				task_offset);
+				task_offset_in);
+
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	if (CMD_TFO(cmd)->task_sg_chaining == 0)
+		return 0;
+	/*
+	 * Currently prevent writers from multiple HW fabrics doing
+	 * pci_map_sg() to RD_DR's internal scatterlist memory.
+	 */
+	if (cmd->data_direction == SE_DIRECTION_WRITE) {
+		printk(KERN_ERR "SE_DIRECTION_WRITE not supported for"
+				" RAMDISK_DR with task_sg_chaining=1\n");
+		return -1;
+	}
+	/*
+	 * Special case for if task_sg_chaining is enabled, then
+	 * we setup struct se_task->task_sg[], as it will be used by
+	 * transport_do_task_sg_chain() for creating chainged SGLs
+	 * across multiple struct se_task->task_sg[].
+	 *
+	 * Note that kfree(task->task_sg); does not need to be called
+	 * in rd_DIRECT_free_DMA(), because transport_free_dev_tasks()
+	 * will already be taking care of this for all TCM subsystem
+	 * plugins.
+	 */
+	if (!(transport_calc_sg_num(task,
+			list_entry(T_TASK(cmd)->t_mem_list->next,
+				   struct se_mem, se_list),
+			task_offset)))
+		return -1;	
+
+	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
+			list_entry(T_TASK(cmd)->t_mem_list->next,
+				   struct se_mem, se_list),
+			out_se_mem, se_mem_cnt, task_offset_in);
 }
 
 /*	rd_DIRECT_free_DMA():
-- 
1.5.6.5
