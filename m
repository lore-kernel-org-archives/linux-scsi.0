From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] tcm: Move transport_emulate_control_cdb() into __transport_execute_tasks()
Date: Wed, 13 Oct 2010 01:47:53 -0700
Message-ID: <1286959673-3424-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves control path CDB emulation transport_emulate_control_cdb()
calls from IBLOCK, FILEIO and RAMDISK spa->do_task() into a generic
location in __transport_execute_tasks().  This code is called by all
non TCM/pSCSI backstores to handle internal SCF_SCSI_DATA_SG_IO_CDB
emulation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |    3 ---
 drivers/target/target_core_iblock.c    |    3 ---
 drivers/target/target_core_rd.c        |    3 ---
 drivers/target/target_core_transport.c |   17 ++++++++++++++++-
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 62b4b4e..a5ad51c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -783,9 +783,6 @@ static int fd_do_task(struct se_task *task)
 	struct fd_request *req = task->transport_req;
 	int ret = 0;
 
-	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return transport_emulate_control_cdb(task);
-
 	req->fd_lba = task->task_lba;
 	req->fd_size = task->task_size;
 	/*
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 061c513..d999f10 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -584,9 +584,6 @@ static int iblock_do_task(struct se_task *task)
 	int write = (TASK_CMD(task)->data_direction == DMA_TO_DEVICE);
 	int ret;
 
-	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return transport_emulate_control_cdb(task);
-
 	while (bio) {
 		nbio = bio->bi_next;
 		bio->bi_next = NULL;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index fe27e59..374cd16 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -710,9 +710,6 @@ static int rd_MEMCPY_do_task(struct se_task *task)
 	struct rd_request *req = task->transport_req;
 	int ret;
 
-	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return transport_emulate_control_cdb(task);
-
 	req->rd_lba = task->task_lba;
 	req->rd_page = (req->rd_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
 	req->rd_offset = (do_div(req->rd_lba,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d02644c..e678686 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4253,7 +4253,22 @@ check_depth:
 			transport_complete_task(task, 1);
 		}
 	} else {
-		error = TRANSPORT(dev)->do_task(task);
+		/*
+		 * Currently for all virtual TCM plugins including IBLOCK, FILEIO and
+		 * RAMDISK we use the internal transport_emulate_control_cdb() logic
+		 * with struct se_subsystem_api callers for the primary SPC-3 TYPE_DISK
+		 * LUN emulation code.
+		 *
+		 * For TCM/pSCSI and all other SCF_SCSI_DATA_SG_IO_CDB I/O tasks we
+		 * call ->do_task() directly and let the underlying TCM subsystem plugin
+		 * code handle the CDB emulation.
+		 */
+		if ((TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) &&
+		    (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)))
+			error = transport_emulate_control_cdb(task);
+		else
+			error = TRANSPORT(dev)->do_task(task);
+
 		if (error != 0) {
 			cmd->transport_error_status = error;
 			atomic_set(&task->task_active, 0);
-- 
1.5.6.5
