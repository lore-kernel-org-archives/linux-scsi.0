From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_vhost: Convert to cmwq submission for I/O dispatch
Date: Mon,  9 Jul 2012 06:10:37 +0000
Message-ID: <1341814237-24247-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts tcm_vhost to use modern concurrency managed workqueues to
offload setup of tcm_vhost_cmd descriptors to a kworker CPU thread that is
running on the same core as the vhost thread pulling elements off the virtqueue
from within vhost_scsi_handle_vq().

This includes the addition of tcm_vhost_submission_work() to perform the
LUN lookup, target_setup_cmd_from_cdb(), transport_generic_map_mem_to_cmd()
and transport_handle_cdb_direct() calls for setup -> memory map -> backend I/O
execution.

Also, now remove the legacy tcm_vhost_new_cmd_map() code originally used to
perform memory map -> backend I/O execution from transport_processing_thread()
process context.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/tcm_vhost.c |  168 ++++++++++++++++++++++++---------------------
 drivers/vhost/tcm_vhost.h |    6 ++-
 2 files changed, 96 insertions(+), 78 deletions(-)

diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index 81b77f3..da0b8ac 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -67,6 +67,8 @@ struct vhost_scsi {
 /* Local pointer to allocated TCM configfs fabric module */
 static struct target_fabric_configfs *tcm_vhost_fabric_configfs;
 
+static struct workqueue_struct *tcm_vhost_workqueue;
+
 /* Global spinlock to protect tcm_vhost TPG list for vhost IOCTL access */
 static DEFINE_MUTEX(tcm_vhost_mutex);
 static LIST_HEAD(tcm_vhost_list);
@@ -247,55 +249,6 @@ static u32 tcm_vhost_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-/*
- * Called by struct target_core_fabric_ops->new_cmd_map()
- *
- * Always called in process context.  A non zero return value
- * here will signal to handle an exception based on the return code.
- */
-static int tcm_vhost_new_cmd_map(struct se_cmd *se_cmd)
-{
-	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
-				struct tcm_vhost_cmd, tvc_se_cmd);
-	struct scatterlist *sg_ptr, *sg_bidi_ptr = NULL;
-	u32 sg_no_bidi = 0;
-	int ret;
-	/*
-	 * Allocate the necessary tasks to complete the received CDB+data
-	 */
-	ret = target_setup_cmd_from_cdb(se_cmd, tv_cmd->tvc_cdb);
-	if (ret != 0)
-		return ret;
-	/*
-	 * Setup the struct scatterlist memory from the received
-	 * struct tcm_vhost_cmd..
-	 */
-	if (tv_cmd->tvc_sgl_count) {
-		sg_ptr = tv_cmd->tvc_sgl;
-		/*
-		 * For BIDI commands, pass in the extra READ buffer
-		 * to transport_generic_map_mem_to_cmd() below..
-		 */
-/* FIXME: Fix BIDI operation in tcm_vhost_new_cmd_map() */
-#if 0
-		if (se_cmd->se_cmd_flags & SCF_BIDI) {
-			mem_bidi_ptr = NULL;
-			sg_no_bidi = 0;
-		}
-#endif
-	} else {
-		/*
-		 * Used for DMA_NONE
-		 */
-		sg_ptr = NULL;
-	}
-
-	/* Tell the core about our preallocated memory */
-	return transport_generic_map_mem_to_cmd(se_cmd, sg_ptr,
-				tv_cmd->tvc_sgl_count, sg_bidi_ptr,
-				sg_no_bidi);
-}
-
 static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 {
 	return;
@@ -509,12 +462,6 @@ static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
 	if (bidi)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
 #endif
-	/*
-	 * From here the rest of the se_cmd will be setup and dispatched
-	 * via tcm_vhost_new_cmd_map() from TCM backend thread context
-	 * after transport_generic_handle_cdb_map() has been called from
-	 * vhost_scsi_handle_vq() below..
-	 */
 	return tv_cmd;
 }
 
@@ -611,6 +558,71 @@ static int vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *tv_cmd,
 	return 0;
 }
 
+static void tcm_vhost_submission_work(struct work_struct *work)
+{
+	struct tcm_vhost_cmd *tv_cmd =
+		container_of(work, struct tcm_vhost_cmd, work);
+	struct se_cmd *se_cmd = &tv_cmd->tvc_se_cmd;
+	struct scatterlist *sg_ptr, *sg_bidi_ptr = NULL;
+	int rc, sg_no_bidi = 0;
+	/*
+	 * Locate the struct se_lun pointer based on v_req->lun, and
+	 * attach it to struct se_cmd
+	 */
+	rc = transport_lookup_cmd_lun(&tv_cmd->tvc_se_cmd, tv_cmd->tvc_lun);
+	if (rc < 0) {
+		pr_err("Failed to look up lun: %d\n", tv_cmd->tvc_lun);
+		transport_send_check_condition_and_sense(&tv_cmd->tvc_se_cmd,
+			tv_cmd->tvc_se_cmd.scsi_sense_reason, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+		return;
+	}
+
+	rc = target_setup_cmd_from_cdb(se_cmd, tv_cmd->tvc_cdb);
+	if (rc == -ENOMEM) {
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+		return;
+	} else if (rc < 0) {
+		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
+			tcm_vhost_queue_status(se_cmd);
+		else
+			transport_send_check_condition_and_sense(se_cmd,
+					se_cmd->scsi_sense_reason, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+		return;
+	}
+
+	if (tv_cmd->tvc_sgl_count) {
+		sg_ptr = tv_cmd->tvc_sgl;
+		/*
+		 * For BIDI commands, pass in the extra READ buffer
+		 * to transport_generic_map_mem_to_cmd() below..
+		 */
+/* FIXME: Fix BIDI operation in tcm_vhost_submission_work() */
+#if 0
+		if (se_cmd->se_cmd_flags & SCF_BIDI) {
+			sg_bidi_ptr = NULL;
+			sg_no_bidi = 0;
+		}
+#endif
+	} else {
+		sg_ptr = NULL;
+	}
+
+	rc = transport_generic_map_mem_to_cmd(se_cmd, sg_ptr,
+				tv_cmd->tvc_sgl_count, sg_bidi_ptr,
+				sg_no_bidi);
+	if (rc < 0) {
+		transport_send_check_condition_and_sense(se_cmd,
+				se_cmd->scsi_sense_reason, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+		return;
+	}
+	transport_handle_cdb_direct(se_cmd);
+}
+
 static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 {
 	struct vhost_virtqueue *vq = &vs->vqs[2];
@@ -619,7 +631,7 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 	struct tcm_vhost_cmd *tv_cmd;
 	u32 exp_data_len, data_first, data_num, data_direction;
 	unsigned out, in, i;
-	int head, ret, lun;
+	int head, ret;
 
 	/* Must use ioctl VHOST_SCSI_SET_ENDPOINT */
 	tv_tpg = vs->vs_tpg;
@@ -732,10 +744,10 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 				scsi_command_size(tv_cmd->tvc_cdb), TCM_VHOST_MAX_CDB_SIZE);
 			break; /* TODO */
 		}
-		lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
+		tv_cmd->tvc_lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
-			tv_cmd->tvc_cdb[0], lun);
+			tv_cmd->tvc_cdb[0], tv_cmd->tvc_lun);
 
 		if (data_direction != DMA_NONE) {
 			ret = vhost_scsi_map_iov_to_sgl(tv_cmd, &vq->iov[data_first],
@@ -753,22 +765,13 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 		 */
 		tv_cmd->tvc_vq_desc = head;
 		/*
-		 * Locate the struct se_lun pointer based on v_req->lun, and
-		 * attach it to struct se_cmd
-		 */
-		if (transport_lookup_cmd_lun(&tv_cmd->tvc_se_cmd, lun) < 0) {
-			pr_err("Failed to look up lun: %d\n", lun);
-			/* NON_EXISTENT_LUN */
-			transport_send_check_condition_and_sense(&tv_cmd->tvc_se_cmd,
-					tv_cmd->tvc_se_cmd.scsi_sense_reason, 0);
-			continue;
-		}
-		/*
-		 * Now queue up the newly allocated se_cmd to be processed
-		 * within TCM thread context to finish the setup and dispatched
-		 * into a TCM backend struct se_device.
+		 * Dispatch tv_cmd descriptor for cmwq execution in process
+		 * context provided by tcm_vhost_workqueue.  This also ensures
+		 * tv_cmd is executed on the same kworker CPU as this vhost
+		 * thread to gain positive L2 cache locality effects..
 		 */
-		transport_generic_handle_cdb_map(&tv_cmd->tvc_se_cmd);
+		INIT_WORK(&tv_cmd->work, tcm_vhost_submission_work);
+		queue_work(tcm_vhost_workqueue, &tv_cmd->work);
 	}
 
 	mutex_unlock(&vq->mutex);
@@ -1478,7 +1481,6 @@ static struct target_core_fabric_ops tcm_vhost_ops = {
 	.tpg_alloc_fabric_acl		= tcm_vhost_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= tcm_vhost_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_vhost_tpg_get_inst_index,
-	.new_cmd_map			= tcm_vhost_new_cmd_map,
 	.release_cmd			= tcm_vhost_release_cmd,
 	.shutdown_session		= tcm_vhost_shutdown_session,
 	.close_session			= tcm_vhost_close_session,
@@ -1570,23 +1572,35 @@ static void tcm_vhost_deregister_configfs(void)
 
 static int __init tcm_vhost_init(void)
 {
-	int ret;
+	int ret = -ENOMEM;
+
+	tcm_vhost_workqueue = alloc_workqueue("tcm_vhost", 0, 0);
+	if (!tcm_vhost_workqueue)
+		goto out;
 
 	ret = vhost_scsi_register();
 	if (ret < 0)
-		return ret;
+		goto out_destroy_workqueue;
 
 	ret = tcm_vhost_register_configfs();
 	if (ret < 0)
-		return ret;
+		goto out_vhost_scsi_deregister;
 
 	return 0;
+
+out_vhost_scsi_deregister:
+	vhost_scsi_deregister();
+out_destroy_workqueue:
+	destroy_workqueue(tcm_vhost_workqueue);
+out:
+	return ret;
 };
 
 static void tcm_vhost_exit(void)
 {
 	tcm_vhost_deregister_configfs();
 	vhost_scsi_deregister();
+	destroy_workqueue(tcm_vhost_workqueue);
 };
 
 MODULE_DESCRIPTION("TCM_VHOST series fabric driver");
diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
index 0e8951b..9d6cace 100644
--- a/drivers/vhost/tcm_vhost.h
+++ b/drivers/vhost/tcm_vhost.h
@@ -9,14 +9,18 @@ struct tcm_vhost_cmd {
 	u64 tvc_tag;
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
+	/* Saved unpacked SCSI LUN for tcm_vhost_submission_work() */
+	u32 tvc_lun;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
 	/* Pointer to response */
 	struct virtio_scsi_cmd_resp __user *tvc_resp;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
-	 /* The TCM I/O descriptor that is accessed via container_of() */
+	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
+	/* work item used for cmwq dispatch to tcm_vhost_submission_work() */
+	struct work_struct work;
 	/* Copy of the incoming SCSI command descriptor block (CDB) */
 	unsigned char tvc_cdb[TCM_VHOST_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
-- 
1.7.2.5
