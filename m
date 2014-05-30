From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 8/9] scsi: virtscsi: work around to abort a scmd
Date: Fri, 30 May 2014 16:15:46 +0800
Message-ID: <1401437747-2097-9-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:47593 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaE3INf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:13:35 -0400
Received: by mail-yk0-f175.google.com with SMTP id 131so1221601ykp.6
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:13:33 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

This patch is just an "eg and test-issue" for this series. The main
changes is that when abort a scmd, distinguishing the case of removing
from the case of not found. ( I think it should be better to remove the
scmd directly from vq, but for the time being, I have no idea about
this detail in virtio)

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/scsi/virtio_scsi.c | 61 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b26f1a5..d08aae5 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -31,8 +31,14 @@
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
 
+/* should be per virtscsi dev */
+static struct list_head active_cmds = LIST_HEAD_INIT(active_cmds);
+static spinlock_t cmds_lock;
+
 /* Command queue element */
 struct virtio_scsi_cmd {
+	struct list_head list;
+	unsigned long abort;
 	struct scsi_cmnd *sc;
 	struct completion *comp;
 	union {
@@ -148,6 +154,18 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
+	unsigned long flags;
+	int skip = 0;
+	spin_lock_irqsave(&cmds_lock, flags);
+	list_del_init(&cmd->list);
+	if (cmd->abort)
+		skip = 1;
+	spin_unlock_irqrestore(&cmds_lock, flags);
+	if (skip) {
+		mempool_free(cmd, virtscsi_cmd_pool);
+		return;
+	}
+
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
 	struct virtio_scsi_target_state *tgt =
@@ -273,11 +291,16 @@ static void virtscsi_req_done(struct virtqueue *vq)
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
+	unsigned long flags;
 
 	if (cmd->comp)
 		complete_all(cmd->comp);
-	else
+	else {
+		spin_lock_irqsave(&cmds_lock, flags);
+		list_del_init(&cmd->list);
+		spin_unlock_irqrestore(&cmds_lock, flags);
 		mempool_free(cmd, virtscsi_cmd_pool);
+	}
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -477,6 +500,10 @@ static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
 	int err;
 	bool needs_kick = false;
 
+	spin_lock_irqsave(&cmds_lock, flags);
+	list_add_tail(&cmd->list, &active_cmds);
+	spin_unlock_irqrestore(&cmds_lock, flags);
+
 	spin_lock_irqsave(&vq->vq_lock, flags);
 	err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size, gfp);
 	if (!err)
@@ -495,6 +522,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 {
 	struct virtio_scsi_cmd *cmd;
 	int ret;
+	unsigned long flags;
 
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
@@ -511,6 +539,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 		goto out;
 
 	memset(cmd, 0, sizeof(*cmd));
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->sc = sc;
 	cmd->req.cmd = (struct virtio_scsi_cmd_req){
 		.lun[0] = 1,
@@ -530,8 +559,12 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
 			      GFP_ATOMIC) == 0)
 		ret = 0;
-	else
+	else {
+		spin_lock_irqsave(&cmds_lock, flags);
+		list_del_init(&cmd->list);
+		spin_unlock_irqrestore(&cmds_lock, flags);
 		mempool_free(cmd, virtscsi_cmd_pool);
+	}
 
 out:
 	return ret;
@@ -590,6 +623,7 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
 	int ret = FAILED;
+	unsigned long flags;
 
 	cmd->comp = &comp;
 	if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
@@ -603,6 +637,9 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 		ret = SUCCESS;
 
 out:
+	spin_lock_irqsave(&cmds_lock, flags);
+	list_del_init(&cmd->list);
+	spin_unlock_irqrestore(&cmds_lock, flags);
 	mempool_free(cmd, virtscsi_cmd_pool);
 	return ret;
 }
@@ -618,6 +655,7 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(cmd, 0, sizeof(*cmd));
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->sc = sc;
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
@@ -634,13 +672,31 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
 	struct virtio_scsi_cmd *cmd;
+	struct virtio_scsi_cmd *entry, *tmp;
+	unsigned long flags, found = 0;
 
 	scmd_printk(KERN_INFO, sc, "abort\n");
+	spin_lock_irqsave(&cmds_lock, flags);
+	list_for_each_entry_safe(entry, tmp, &active_cmds, list) {
+		if (entry->sc == sc) {
+			list_del_init(&entry->list);
+			/* mark the virtio_scsi_cmd as aborted
+			 */
+			entry->abort = 1;
+			found = 1;
+		}
+
+	}
+	spin_unlock_irqrestore(&cmds_lock, flags);
+	if (found)
+		return SUCCESS_REMOVE;
+
 	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
 	if (!cmd)
 		return FAILED;
 
 	memset(cmd, 0, sizeof(*cmd));
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->sc = sc;
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
@@ -1030,6 +1086,7 @@ static int __init init(void)
 	if (ret < 0)
 		goto error;
 
+	spin_lock_init(&cmds_lock);
 	return 0;
 
 error:
-- 
1.8.1.4

