From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 1/8] vhost/scsi: Convert completion path to use copy_to_iter
Date: Fri,  6 Feb 2015 05:06:34 +0000
Message-ID: <1423199201-14659-2-git-send-email-nab@daterainc.com>
References: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:62754 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbBFFjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 00:39:47 -0500
Received: by mail-oi0-f50.google.com with SMTP id h136so10378637oig.9
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2015 21:39:46 -0800 (PST)
In-Reply-To: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>, Al Viro <viro@zeniv.linux.org.uk>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Required for ANY_LAYOUT support when the incoming virtio-scsi response
header + fixed size sense buffer payload may span more than a single
iovec entry.

This changes existing code to save cmd->tvc_resp_iov instead of the
first single iovec base pointer from &vq->iov[out].

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 01c01cb..29dfdf6 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -72,6 +72,8 @@ struct tcm_vhost_cmd {
 	int tvc_vq_desc;
 	/* virtio-scsi initiator task attribute */
 	int tvc_task_attr;
+	/* virtio-scsi response incoming iovecs */
+	int tvc_in_iovs;
 	/* virtio-scsi initiator data direction */
 	enum dma_data_direction tvc_data_direction;
 	/* Expected data transfer length from virtio-scsi header */
@@ -87,8 +89,8 @@ struct tcm_vhost_cmd {
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
@@ -682,6 +684,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 	struct tcm_vhost_cmd *cmd;
 	struct llist_node *llnode;
 	struct se_cmd *se_cmd;
+	struct iov_iter iov_iter;
 	int ret, vq;
 
 	bitmap_zero(signal, VHOST_SCSI_MAX_VQ);
@@ -703,8 +706,11 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 						 se_cmd->scsi_sense_length);
 		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
 		       se_cmd->scsi_sense_length);
-		ret = copy_to_user(cmd->tvc_resp, &v_rsp, sizeof(v_rsp));
-		if (likely(ret == 0)) {
+
+		iov_iter_init(&iov_iter, READ, cmd->tvc_resp_iov,
+			      cmd->tvc_in_iovs, sizeof(v_rsp));
+		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
+		if (likely(ret == sizeof(v_rsp))) {
 			struct vhost_scsi_virtqueue *q;
 			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
 			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
@@ -1159,7 +1165,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
-		cmd->tvc_resp = vq->iov[out].iov_base;
+		cmd->tvc_resp_iov = &vq->iov[out];
+		cmd->tvc_in_iovs = in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			cmd->tvc_cdb[0], cmd->tvc_lun);
-- 
1.9.1

