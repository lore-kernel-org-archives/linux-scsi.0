From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.10-rc6
Date: Fri, 03 Feb 2017 13:17:13 -0800
Message-ID: <1486156633.2431.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A single fix this time: a fix for a virtqueue removal bug which only
appears to affect S390, but which results in the queue hanging forever
thus causing the machine to fail shutdown.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Eric Farman (1):
      scsi: virtio_scsi: Reject commands when virtqueue is broken

And the diffstat:

 drivers/scsi/virtio_scsi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index ec91bd0..c680d76 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -534,7 +534,9 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 {
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
+	unsigned long flags;
 	int req_size;
+	int ret;
 
 	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
 
@@ -562,8 +564,15 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 		req_size = sizeof(cmd->req.cmd);
 	}
 
-	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd)) != 0)
+	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
+	if (ret == -EIO) {
+		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
+		spin_lock_irqsave(&req_vq->vq_lock, flags);
+		virtscsi_complete_cmd(vscsi, cmd);
+		spin_unlock_irqrestore(&req_vq->vq_lock, flags);
+	} else if (ret != 0) {
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	return 0;
 }
 
