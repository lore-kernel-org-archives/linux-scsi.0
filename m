From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
Date: Tue,  6 Jan 2015 20:18:05 +0000
Message-ID: <1420575485-16447-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

While looking at hch's recent conversion to drop the MSG_*_TAG
definitions, I noticed a long standing bug in vhost-scsi where
the VIRTIO_SCSI_S_* attribute definitions where incorrectly
being passed directly into target_submit_cmd_map_sgls().

This patch adds the missing virtio-scsi to TCM/SAM task attribute
conversion.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 01c01cb..d695b16 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -911,6 +911,23 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 	return 0;
 }
 
+static int vhost_scsi_to_tcm_attr(int attr)
+{
+	switch (attr) {
+	case VIRTIO_SCSI_S_SIMPLE:
+		return TCM_SIMPLE_TAG;
+	case VIRTIO_SCSI_S_ORDERED:
+		return TCM_ORDERED_TAG;
+	case VIRTIO_SCSI_S_HEAD:
+		return TCM_HEAD_TAG;
+	case VIRTIO_SCSI_S_ACA:
+		return TCM_ACA_TAG;
+	default:
+		break;
+	}
+	return TCM_SIMPLE_TAG;
+}
+
 static void tcm_vhost_submission_work(struct work_struct *work)
 {
 	struct tcm_vhost_cmd *cmd =
@@ -936,9 +953,10 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
 			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
-			cmd->tvc_task_attr, cmd->tvc_data_direction,
-			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			NULL, 0, sg_prot_ptr, cmd->tvc_prot_sgl_count);
+			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
+			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
+			cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-- 
1.9.1
