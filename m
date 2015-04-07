From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Fix COMPARE_AND_WRITE with SG_TO_MEM_NOALLOC handling
Date: Tue,  7 Apr 2015 23:34:42 +0000
Message-ID: <1428449682-387-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug for COMPARE_AND_WRITE handling with
fabrics using SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC.

It adds the missing allocation for cmd->t_bidi_data_sg within
transport_generic_new_cmd() that is used by COMPARE_AND_WRITE
for the initial READ payload, even if the fabric is already
providing a pre-allocated buffer for cmd->t_data_sg.

Also, fix zero-length COMPARE_AND_WRITE handling within the
compare_and_write_callback() and target_complete_ok_work()
to queue the response, skipping the initial READ.

This fixes COMPARE_AND_WRITE emulation with loopback, vhost,
and xen-backend fabric drivers using SG_TO_MEM_NOALLOC.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c       |   15 ++++++++-----
 drivers/target/target_core_transport.c |   37 ++++++++++++++++++++++++++++----
 include/target/target_core_base.h      |    2 +-
 3 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 315ff64..0064ffe 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -321,7 +321,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	return 0;
 }
 
-static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd)
+static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success)
 {
 	unsigned char *buf, *addr;
 	struct scatterlist *sg;
@@ -385,7 +385,7 @@ sbc_execute_rw(struct se_cmd *cmd)
 			       cmd->data_direction);
 }
 
-static sense_reason_t compare_and_write_post(struct se_cmd *cmd)
+static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -408,7 +408,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
-static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
+static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool success)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *write_sg = NULL, *sg;
@@ -423,11 +423,16 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 
 	/*
 	 * Handle early failure in transport_generic_request_failure(),
-	 * which will not have taken ->caw_mutex yet..
+	 * which will not have taken ->caw_sem yet..
 	 */
-	if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
+	if (!success && (!cmd->t_data_sg || !cmd->t_bidi_data_sg))
 		return TCM_NO_SENSE;
 	/*
+	 * Handle special case for zero-length COMPARE_AND_WRITE
+	 */
+	if (!cmd->data_length)
+		goto out;
+	/*
 	 * Immediately exit + release dev->caw_sem if command has already
 	 * been failed with a non-zero SCSI status.
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b671ebb..303ae98 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1647,11 +1647,11 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	transport_complete_task_attr(cmd);
 	/*
 	 * Handle special case for COMPARE_AND_WRITE failure, where the
-	 * callback is expected to drop the per device ->caw_mutex.
+	 * callback is expected to drop the per device ->caw_sem.
 	 */
 	if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
 	     cmd->transport_complete_callback)
-		cmd->transport_complete_callback(cmd);
+		cmd->transport_complete_callback(cmd, false);
 
 	switch (sense_reason) {
 	case TCM_NON_EXISTENT_LUN:
@@ -2048,8 +2048,12 @@ static void target_complete_ok_work(struct work_struct *work)
 	if (cmd->transport_complete_callback) {
 		sense_reason_t rc;
 
-		rc = cmd->transport_complete_callback(cmd);
+		rc = cmd->transport_complete_callback(cmd, true);
 		if (!rc && !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
+			if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
+			    !cmd->data_length)
+				goto queue_rsp;
+
 			return;
 		} else if (rc) {
 			ret = transport_send_check_condition_and_sense(cmd,
@@ -2063,6 +2067,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		}
 	}
 
+queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
 		spin_lock(&cmd->se_lun->lun_sep_lock);
@@ -2166,6 +2171,16 @@ static inline void transport_reset_sgl_orig(struct se_cmd *cmd)
 static inline void transport_free_pages(struct se_cmd *cmd)
 {
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
+		/*
+		 * Release special case READ buffer payload required for
+		 * SG_TO_MEM_NOALLOC to function with COMPARE_AND_WRITE
+		 */
+		if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) {
+			transport_free_sgl(cmd->t_bidi_data_sg,
+					   cmd->t_bidi_data_nents);
+			cmd->t_bidi_data_sg = NULL;
+			cmd->t_bidi_data_nents = 0;
+		}
 		transport_reset_sgl_orig(cmd);
 		return;
 	}
@@ -2318,6 +2333,7 @@ sense_reason_t
 transport_generic_new_cmd(struct se_cmd *cmd)
 {
 	int ret = 0;
+	bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
 
 	/*
 	 * Determine is the TCM fabric module has already allocated physical
@@ -2326,7 +2342,6 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) &&
 	    cmd->data_length) {
-		bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
 
 		if ((cmd->se_cmd_flags & SCF_BIDI) ||
 		    (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE)) {
@@ -2357,6 +2372,20 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 				       cmd->data_length, zero_flag);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	} else if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
+		    cmd->data_length) {
+		/*
+		 * Special case for COMPARE_AND_WRITE with fabrics
+		 * using SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC.
+		 */
+		u32 caw_length = cmd->t_task_nolb *
+				 cmd->se_dev->dev_attrib.block_size;
+
+		ret = target_alloc_sgl(&cmd->t_bidi_data_sg,
+				       &cmd->t_bidi_data_nents,
+				       caw_length, zero_flag);
+		if (ret < 0)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
 	 * If this command is not a write we can execute it right here,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fe25a78..8d4f0a2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -524,7 +524,7 @@ struct se_cmd {
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
 	sense_reason_t		(*execute_rw)(struct se_cmd *, struct scatterlist *,
 					      u32, enum dma_data_direction);
-	sense_reason_t (*transport_complete_callback)(struct se_cmd *);
+	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool);
 
 	unsigned char		*t_task_cdb;
 	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
-- 
1.7.10.4
