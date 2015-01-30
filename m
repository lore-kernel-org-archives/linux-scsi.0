From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 5/8] vhost/scsi: Add common vhost_scsi_queue_desc code
Date: Fri, 30 Jan 2015 08:12:29 +0000
Message-ID: <1422605552-24797-6-git-send-email-nab@daterainc.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Move logic for typical vhost_scsi_handle_vq() -> tcm_vhost_workqueue ->
tcm_vhost_submission_work()  dispatch into vhost_scsi_queue_desc().

Can be shared by vhost_scsi_handle_vqal() code.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 049e603..756a893 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -963,6 +963,24 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
 
+static void vhost_scsi_queue_desc(struct tcm_vhost_cmd *cmd, int desc)
+{
+	/*
+	 * Save the descriptor from vhost_get_vq_desc() to be used to
+	 * complete the virtio-scsi request in TCM callback context via
+	 * tcm_vhost_queue_data_in() and tcm_vhost_queue_status()
+	 */
+	cmd->tvc_vq_desc = desc;
+	/*
+	 * Dispatch cmd descriptor for cmwq execution in process
+	 * context provided by tcm_vhost_workqueue.  This also ensures
+	 * cmd is executed on the same kworker CPU as this vhost
+	 * thread to gain positive L2 cache locality effects.
+	 */
+	INIT_WORK(&cmd->work, tcm_vhost_submission_work);
+	queue_work(tcm_vhost_workqueue, &cmd->work);
+}
+
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
@@ -1191,20 +1209,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 				continue;
 			}
 		}
-		/*
-		 * Save the descriptor from vhost_get_vq_desc() to be used to
-		 * complete the virtio-scsi request in TCM callback context via
-		 * tcm_vhost_queue_data_in() and tcm_vhost_queue_status()
-		 */
-		cmd->tvc_vq_desc = head;
-		/*
-		 * Dispatch tv_cmd descriptor for cmwq execution in process
-		 * context provided by tcm_vhost_workqueue.  This also ensures
-		 * tv_cmd is executed on the same kworker CPU as this vhost
-		 * thread to gain positive L2 cache locality effects..
-		 */
-		INIT_WORK(&cmd->work, tcm_vhost_submission_work);
-		queue_work(tcm_vhost_workqueue, &cmd->work);
+		vhost_scsi_queue_desc(cmd, head);
 	}
 out:
 	mutex_unlock(&vq->mutex);
-- 
1.9.1
