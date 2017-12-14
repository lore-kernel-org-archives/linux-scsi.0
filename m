From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] virtio-scsi: implement target rescan
Date: Thu, 14 Dec 2017 11:11:54 +0100
Message-ID: <1513246316-56019-2-git-send-email-hare@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50293 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751574AbdLNKMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 05:12:00 -0500
In-Reply-To: <1513246316-56019-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Implement the 'rescan' virtio-scsi feature. Rescanning works by
sending a 'rescan' virtio-scsi command with the next requested
target id to the backend. The backend will respond with the next
used target id or '-1' if no more targets are found.
This avoids scanning all possible targets.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/virtio_scsi.c       | 239 ++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_scsi.h |  15 +++
 2 files changed, 250 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7c28e8d..a561e90 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -46,12 +46,14 @@ struct virtio_scsi_cmd {
 		struct virtio_scsi_cmd_req_pi    cmd_pi;
 		struct virtio_scsi_ctrl_tmf_req  tmf;
 		struct virtio_scsi_ctrl_an_req   an;
+		struct virtio_scsi_rescan_req    rescan;
 	} req;
 	union {
 		struct virtio_scsi_cmd_resp      cmd;
 		struct virtio_scsi_ctrl_tmf_resp tmf;
 		struct virtio_scsi_ctrl_an_resp  an;
 		struct virtio_scsi_event         evt;
+		struct virtio_scsi_rescan_resp   rescan;
 	} resp;
 } ____cacheline_aligned_in_smp;
 
@@ -115,6 +117,10 @@ struct virtio_scsi {
 	/* Protected by event_vq lock */
 	bool stop_events;
 
+	int next_target_id;
+	struct work_struct rescan_work;
+	spinlock_t rescan_lock;
+
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
 	struct virtio_scsi_vq req_vqs[];
@@ -318,6 +324,11 @@ static void virtscsi_cancel_event_work(struct virtio_scsi *vscsi)
 
 	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
 		cancel_work_sync(&vscsi->event_list[i].work);
+
+	spin_lock_irq(&vscsi->rescan_lock);
+	vscsi->next_target_id = -1;
+	spin_unlock_irq(&vscsi->rescan_lock);
+	cancel_work_sync(&vscsi->rescan_work);
 }
 
 static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
@@ -805,6 +816,168 @@ static enum blk_eh_timer_return virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	return BLK_EH_RESET_TIMER;
 }
 
+static void virtscsi_rescan_work(struct work_struct *work)
+{
+	struct virtio_scsi *vscsi =
+		container_of(work, struct virtio_scsi, rescan_work);
+	struct Scsi_Host *sh = virtio_scsi_host(vscsi->vdev);
+	int target_id, ret;
+	struct virtio_scsi_cmd *cmd;
+	DECLARE_COMPLETION_ONSTACK(comp);
+
+	spin_lock_irq(&vscsi->rescan_lock);
+	target_id = vscsi->next_target_id;
+	if (target_id == -1) {
+		shost_printk(KERN_INFO, sh, "rescan: terminated\n");
+		spin_unlock_irq(&vscsi->rescan_lock);
+		return;
+	}
+	spin_unlock_irq(&vscsi->rescan_lock);
+
+	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
+	if (!cmd) {
+		shost_printk(KERN_INFO, sh, "rescan: no memory\n");
+		goto scan_host;
+	}
+	shost_printk(KERN_INFO, sh, "rescan: next target %d\n", target_id);
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->comp = &comp;
+	cmd->sc = NULL;
+	cmd->req.rescan = (struct virtio_scsi_rescan_req){
+		.type = VIRTIO_SCSI_T_RESCAN,
+		.next_id = cpu_to_virtio32(vscsi->vdev, target_id),
+	};
+
+	ret = virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd, sizeof(cmd->req.rescan),
+				sizeof(cmd->resp.rescan));
+	if (ret < 0) {
+		mempool_free(cmd, virtscsi_cmd_pool);
+		goto scan_host;
+	}
+
+	wait_for_completion(&comp);
+	target_id = virtio32_to_cpu(vscsi->vdev, cmd->resp.rescan.id);
+	if (target_id != -1) {
+		int transport = virtio32_to_cpu(vscsi->vdev,
+						cmd->resp.rescan.transport);
+		spin_lock_irq(&vscsi->rescan_lock);
+		vscsi->next_target_id = target_id + 1;
+		spin_unlock_irq(&vscsi->rescan_lock);
+		shost_printk(KERN_INFO, sh,
+			     "found %s target %d (WWN %*phN)\n",
+			     transport == SCSI_PROTOCOL_FCP ? "FC" : "SAS",
+			     target_id, 8,
+			     cmd->resp.rescan.port_wwn);
+		scsi_scan_target(&sh->shost_gendev, 0, target_id,
+				 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
+		queue_work(system_freezable_wq, &vscsi->rescan_work);
+	} else {
+		shost_printk(KERN_INFO, sh,
+			     "rescan: no more targets\n");
+		spin_lock_irq(&vscsi->rescan_lock);
+		vscsi->next_target_id = -1;
+		spin_unlock_irq(&vscsi->rescan_lock);
+	}
+	mempool_free(cmd, virtscsi_cmd_pool);
+	return;
+scan_host:
+	spin_lock_irq(&vscsi->rescan_lock);
+	vscsi->next_target_id = -1;
+	spin_unlock_irq(&vscsi->rescan_lock);
+	shost_printk(KERN_INFO, sh, "rescan: scan host\n");
+	scsi_scan_host(sh);
+}
+
+static void virtscsi_scan_host(struct virtio_scsi *vscsi)
+{
+	struct Scsi_Host *sh = virtio_scsi_host(vscsi->vdev);
+	int ret;
+	struct virtio_scsi_cmd *cmd;
+	DECLARE_COMPLETION_ONSTACK(comp);
+
+	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
+	if (!cmd) {
+		shost_printk(KERN_INFO, sh, "rescan: no memory\n");
+		return;
+	}
+	shost_printk(KERN_INFO, sh, "rescan: scan host\n");
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->comp = &comp;
+	cmd->sc = NULL;
+	cmd->req.rescan = (struct virtio_scsi_rescan_req){
+		.type = VIRTIO_SCSI_T_RESCAN,
+		.next_id = cpu_to_virtio32(vscsi->vdev, -1),
+	};
+
+	ret = virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd, sizeof(cmd->req.rescan),
+				sizeof(cmd->resp.rescan));
+	if (ret < 0) {
+		mempool_free(cmd, virtscsi_cmd_pool);
+		return;
+	}
+
+	wait_for_completion(&comp);
+	if (cmd->resp.rescan.id == -1) {
+		int transport = virtio32_to_cpu(vscsi->vdev,
+						cmd->resp.rescan.transport);
+		shost_printk(KERN_INFO, sh,
+			     "%s host wwnn %*phN wwpn %*phN\n",
+			     transport == SCSI_PROTOCOL_FCP ? "FC" : "SAS",
+			     8, cmd->resp.rescan.node_wwn,
+			     8, cmd->resp.rescan.port_wwn);
+	}
+	mempool_free(cmd, virtscsi_cmd_pool);
+}
+
+static void virtscsi_scan_start(struct Scsi_Host *sh)
+{
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
+	virtscsi_scan_host(vscsi);
+	spin_lock_irq(&vscsi->rescan_lock);
+	if (vscsi->next_target_id != -1) {
+		shost_printk(KERN_INFO, sh, "rescan: already running\n");
+		spin_unlock_irq(&vscsi->rescan_lock);
+		return;
+	}
+	vscsi->next_target_id = 0;
+	shost_printk(KERN_INFO, sh, "rescan: start\n");
+	spin_unlock_irq(&vscsi->rescan_lock);
+	queue_work(system_freezable_wq, &vscsi->rescan_work);
+}
+
+int virtscsi_scan_finished(struct Scsi_Host *sh, unsigned long time)
+{
+	struct virtio_scsi *vscsi = shost_priv(sh);
+	int ret = 1;
+
+	spin_lock_irq(&vscsi->rescan_lock);
+	if (vscsi->next_target_id != -1)
+		ret = 0;
+	spin_unlock_irq(&vscsi->rescan_lock);
+	if (!ret)
+		flush_work(&vscsi->rescan_work);
+
+	shost_printk(KERN_INFO, sh, "rescan: %s finished\n",
+		     ret ? "" : "not");
+	return ret;
+}
+
+static ssize_t virtscsi_host_store_rescan(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	virtscsi_scan_start(shost);
+	return count;
+}
+static DEVICE_ATTR(rescan, S_IWUSR, NULL, virtscsi_host_store_rescan);
+
+static struct device_attribute *virtscsi_shost_attrs[] = {
+	&dev_attr_rescan,
+	NULL,
+};
+
 static struct scsi_host_template virtscsi_host_template_single = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
@@ -846,6 +1019,53 @@ static enum blk_eh_timer_return virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	.track_queue_depth = 1,
 };
 
+static struct scsi_host_template virtscsi_host_template_single_rescan = {
+	.module = THIS_MODULE,
+	.name = "Virtio SCSI HBA",
+	.proc_name = "virtio_scsi",
+	.this_id = -1,
+	.cmd_size = sizeof(struct virtio_scsi_cmd),
+	.queuecommand = virtscsi_queuecommand_single,
+	.change_queue_depth = virtscsi_change_queue_depth,
+	.eh_abort_handler = virtscsi_abort,
+	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_eh_timed_out,
+	.slave_alloc = virtscsi_device_alloc,
+	.scan_start = virtscsi_scan_start,
+	.scan_finished = virtscsi_scan_finished,
+	.shost_attrs = virtscsi_shost_attrs,
+
+	.dma_boundary = UINT_MAX,
+	.use_clustering = ENABLE_CLUSTERING,
+	.target_alloc = virtscsi_target_alloc,
+	.target_destroy = virtscsi_target_destroy,
+	.track_queue_depth = 1,
+};
+
+static struct scsi_host_template virtscsi_host_template_multi_rescan = {
+	.module = THIS_MODULE,
+	.name = "Virtio SCSI HBA",
+	.proc_name = "virtio_scsi",
+	.this_id = -1,
+	.cmd_size = sizeof(struct virtio_scsi_cmd),
+	.queuecommand = virtscsi_queuecommand_multi,
+	.change_queue_depth = virtscsi_change_queue_depth,
+	.eh_abort_handler = virtscsi_abort,
+	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_eh_timed_out,
+	.slave_alloc = virtscsi_device_alloc,
+	.scan_start = virtscsi_scan_start,
+	.scan_finished = virtscsi_scan_finished,
+	.shost_attrs = virtscsi_shost_attrs,
+
+	.dma_boundary = UINT_MAX,
+	.use_clustering = ENABLE_CLUSTERING,
+	.target_alloc = virtscsi_target_alloc,
+	.target_destroy = virtscsi_target_destroy,
+	.map_queues = virtscsi_map_queues,
+	.track_queue_depth = 1,
+};
+
 #define virtscsi_config_get(vdev, fld) \
 	({ \
 		typeof(((struct virtio_scsi_config *)0)->fld) __val; \
@@ -949,10 +1169,17 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 
-	if (num_queues == 1)
-		hostt = &virtscsi_host_template_single;
-	else
-		hostt = &virtscsi_host_template_multi;
+	if (num_queues == 1) {
+		if (virtio_has_feature(vdev, VIRTIO_SCSI_F_RESCAN))
+			hostt = &virtscsi_host_template_single_rescan;
+		else
+			hostt = &virtscsi_host_template_single;
+	} else {
+		if (virtio_has_feature(vdev, VIRTIO_SCSI_F_RESCAN))
+			hostt = &virtscsi_host_template_multi_rescan;
+		else
+			hostt = &virtscsi_host_template_multi;
+	}
 
 	shost = scsi_host_alloc(hostt,
 		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
@@ -965,6 +1192,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	vscsi->vdev = vdev;
 	vscsi->num_queues = num_queues;
 	vdev->priv = shost;
+	vscsi->next_target_id = -1;
+	spin_lock_init(&vscsi->rescan_lock);
+	INIT_WORK(&vscsi->rescan_work, virtscsi_rescan_work);
 
 	err = virtscsi_init(vdev, vscsi);
 	if (err)
@@ -1067,6 +1297,7 @@ static int virtscsi_restore(struct virtio_device *vdev)
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	VIRTIO_SCSI_F_T10_PI,
 #endif
+	VIRTIO_SCSI_F_RESCAN,
 };
 
 static struct virtio_driver virtio_scsi_driver = {
diff --git a/include/uapi/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
index cc18ef8..762622e 100644
--- a/include/uapi/linux/virtio_scsi.h
+++ b/include/uapi/linux/virtio_scsi.h
@@ -96,6 +96,19 @@ struct virtio_scsi_ctrl_an_resp {
 	__u8 response;
 } __attribute__((packed));
 
+/* Target rescan */
+struct virtio_scsi_rescan_req {
+	__virtio32 type;
+	__virtio32 next_id;
+} __attribute__((packed));
+
+struct virtio_scsi_rescan_resp {
+	__virtio32 id;
+	__virtio32 transport;
+	uint8_t node_wwn[8];
+	uint8_t port_wwn[8];
+} __attribute__((packed));
+
 struct virtio_scsi_event {
 	__virtio32 event;
 	__u8 lun[8];
@@ -120,6 +133,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_F_HOTPLUG                  1
 #define VIRTIO_SCSI_F_CHANGE                   2
 #define VIRTIO_SCSI_F_T10_PI                   3
+#define VIRTIO_SCSI_F_RESCAN                   4
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
@@ -140,6 +154,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_T_TMF                      0
 #define VIRTIO_SCSI_T_AN_QUERY                 1
 #define VIRTIO_SCSI_T_AN_SUBSCRIBE             2
+#define VIRTIO_SCSI_T_RESCAN                   3
 
 /* Valid TMF subtypes.  */
 #define VIRTIO_SCSI_T_TMF_ABORT_TASK           0
-- 
1.8.5.6
