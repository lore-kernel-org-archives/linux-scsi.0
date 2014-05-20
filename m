From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] virtio_scsi: don't call virtqueue_add_sgs(... GFP_NOIO) holding spinlock.
Date: Tue, 20 May 2014 14:42:45 +0930
Message-ID: <87tx8lhw36.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:38529 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaETFM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 01:12:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanha@linux.vnet.ibm.com, pbonzini@redhat.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This triggers every time we do a SCSI abort:

virtscsi_tmf -> virtscsi_kick_cmd (grab lock and call) -> virtscsi_add_cmd
	-> virtqueue_add_sgs (GFP_NOIO)

Logs look like this:
 sd 0:0:0:0: [sda] abort
 BUG: sleeping function called from invalid context at mm/slub.c:966
 in_atomic(): 1, irqs_disabled(): 1, pid: 6, name: kworker/u2:0
 3 locks held by kworker/u2:0/6:
  #0:  ("scsi_tmf_%d"shost->host_no){......}, at: [<c0153180>] process_one_work+0xe0/0x3d0
  #1:  ((&(&cmd->abort_work)->work)){......}, at: [<c0153180>] process_one_work+0xe0/0x3d0
  #2:  (&(&virtscsi_vq->vq_lock)->rlock){......}, at: [<c043f508>] virtscsi_kick_cmd+0x18/0x1b0
 CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.15.0-rc5+ #110
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-rc1-0-gb1d4dc9-20140515_140003-nilsson.home.kraxel.org 04/01/2014
 Workqueue: scsi_tmf_0 scmd_eh_abort_handler

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index db3b494e5926..62757afd93bb 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -433,11 +433,10 @@ static void virtscsi_event_done(struct virtqueue *vq)
  * @cmd		: command structure
  * @req_size	: size of the request buffer
  * @resp_size	: size of the response buffer
- * @gfp	: flags to use for memory allocations
  */
 static int virtscsi_add_cmd(struct virtqueue *vq,
 			    struct virtio_scsi_cmd *cmd,
-			    size_t req_size, size_t resp_size, gfp_t gfp)
+			    size_t req_size, size_t resp_size)
 {
 	struct scsi_cmnd *sc = cmd->sc;
 	struct scatterlist *sgs[4], req, resp;
@@ -469,19 +468,19 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
 	if (in)
 		sgs[out_num + in_num++] = in->sgl;
 
-	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
+	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, GFP_ATOMIC);
 }
 
 static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
 			     struct virtio_scsi_cmd *cmd,
-			     size_t req_size, size_t resp_size, gfp_t gfp)
+			     size_t req_size, size_t resp_size)
 {
 	unsigned long flags;
 	int err;
 	bool needs_kick = false;
 
 	spin_lock_irqsave(&vq->vq_lock, flags);
-	err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size, gfp);
+	err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
 	if (!err)
 		needs_kick = virtqueue_kick_prepare(vq->vq);
 
@@ -530,8 +529,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 
 	if (virtscsi_kick_cmd(req_vq, cmd,
-			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
-			      GFP_ATOMIC) == 0)
+			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd) == 0)
 		ret = 0;
 	else
 		mempool_free(cmd, virtscsi_cmd_pool);
@@ -596,8 +594,7 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 
 	cmd->comp = &comp;
 	if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
-			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
-			      GFP_NOIO) < 0)
+			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf) < 0)
 		goto out;
 
 	wait_for_completion(&comp);
