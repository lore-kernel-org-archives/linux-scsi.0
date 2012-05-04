From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 for 3.4] virtio-scsi: fix TMF use-after-free
Date: Fri,  4 May 2012 12:32:04 +0200
Message-ID: <1336127524-28216-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab2EDKch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:32:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Hu Tao <hutao@cn.fujitsu.com>

Fix a use-after-free in the TMF path, where cmd may have been already
freed by virtscsi_complete_free when wait_for_completion restarts
executing virtscsi_tmf.  Technically a race, but in practice the command
will always be freed long before the completion waiter is awoken.

The fix is to make callers specifying a completion responsible for
freeing the command in all cases.

Cc: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
        v1->v2: same patch, with a decent commit message

 drivers/scsi/virtio_scsi.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index efccd72..1b38431 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
 
 	if (cmd->comp)
 		complete_all(cmd->comp);
-	mempool_free(cmd, virtscsi_cmd_pool);
+	else
+		mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -311,21 +312,22 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int ret;
+	int ret = FAILED;
 
 	cmd->comp = &comp;
-	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
-			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
-			       GFP_NOIO);
-	if (ret < 0)
-		return FAILED;
+	if (virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
+			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
+			      GFP_NOIO) < 0)
+		goto out;
 
 	wait_for_completion(&comp);
-	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
-	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-		return FAILED;
+	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
+	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
+		ret = SUCCESS;
 
-	return SUCCESS;
+out:
+	mempool_free(cmd, virtscsi_cmd_pool);
+	return ret;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
-- 
1.7.9.3

