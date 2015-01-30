From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/8] vhost/scsi: Convert completion path to use memcpy_toiovecend
Date: Fri, 30 Jan 2015 08:12:26 +0000
Message-ID: <1422605552-24797-3-git-send-email-nab@daterainc.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Required for ANY_LAYOUT support when the incoming virtio-scsi response
header + fixed size sense buffer payload may span more than a single
iovec entry.

This changes existing code to save cmd->tvc_resp_iod instead of the
first single iovec base pointer from &vq->iov[out].

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 01c01cb..a03ac41 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -87,8 +87,8 @@ struct tcm_vhost_cmd {
 	struct scatterlist *tvc_sgl;
 	struct scatterlist *tvc_prot_sgl;
 	struct page **tvc_upages;
-	/* Pointer to response */
-	struct virtio_scsi_cmd_resp __user *tvc_resp;
+	/* Pointer to response header iovec */
+	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
 	/* Pointer to vhost_virtqueue for the cmd */
@@ -703,7 +703,8 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 						 se_cmd->scsi_sense_length);
 		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
 		       se_cmd->scsi_sense_length);
-		ret = copy_to_user(cmd->tvc_resp, &v_rsp, sizeof(v_rsp));
+		ret = memcpy_toiovecend(cmd->tvc_resp_iov, (unsigned char *)&v_rsp,
+					0, sizeof(v_rsp));
 		if (likely(ret == 0)) {
 			struct vhost_scsi_virtqueue *q;
 			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
@@ -1159,7 +1160,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
-		cmd->tvc_resp = vq->iov[out].iov_base;
+		cmd->tvc_resp_iov = &vq->iov[out];
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			cmd->tvc_cdb[0], cmd->tvc_lun);
-- 
1.9.1
