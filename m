From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] virtio-scsi: Add FC transport class
Date: Thu, 14 Dec 2017 11:11:55 +0100
Message-ID: <1513246316-56019-3-git-send-email-hare@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50291 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751915AbdLNKMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 05:12:01 -0500
In-Reply-To: <1513246316-56019-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When a device announces an 'FC' protocol we should be pulling
in the FC transport class to have the rports etc setup correctly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/virtio_scsi.c | 323 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 277 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index a561e90..f925fbd 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -25,11 +25,13 @@
 #include <linux/virtio_scsi.h>
 #include <linux/cpu.h>
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_transport_fc.h>
 #include <linux/seqlock.h>
 #include <linux/blk-mq-virtio.h>
 
@@ -91,6 +93,12 @@ struct virtio_scsi_vq {
  * an atomic_t.
  */
 struct virtio_scsi_target_state {
+	struct list_head list;
+	struct fc_rport *rport;
+	struct virtio_scsi *vscsi;
+	int target_id;
+	bool removed;
+
 	seqcount_t tgt_seq;
 
 	/* Count of outstanding requests. */
@@ -117,8 +125,12 @@ struct virtio_scsi {
 	/* Protected by event_vq lock */
 	bool stop_events;
 
+	int protocol;
 	int next_target_id;
+	u64 wwnn;
+	u64 wwpn;
 	struct work_struct rescan_work;
+	struct list_head target_list;
 	spinlock_t rescan_lock;
 
 	struct virtio_scsi_vq ctrl_vq;
@@ -128,6 +140,7 @@ struct virtio_scsi {
 
 static struct kmem_cache *virtscsi_cmd_cache;
 static mempool_t *virtscsi_cmd_pool;
+static struct scsi_transport_template *virtio_transport_template;
 
 static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
 {
@@ -156,15 +169,21 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
+	struct fc_rport *rport;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
+	struct virtio_scsi_target_state *tgt;
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
 		sc, resp->response, resp->status, resp->sense_len);
 
+	rport = starget_to_rport(scsi_target(sc->device));
+	if (!rport)
+		tgt = scsi_target(sc->device)->hostdata;
+	else
+		tgt = rport->dd_data;
+
 	sc->result = resp->status;
 	virtscsi_compute_resid(sc, virtio32_to_cpu(vscsi->vdev, resp->resid));
 	switch (resp->response) {
@@ -502,10 +521,11 @@ static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
 
 static void virtio_scsi_init_hdr(struct virtio_device *vdev,
 				 struct virtio_scsi_cmd_req *cmd,
+				 int target_id,
 				 struct scsi_cmnd *sc)
 {
 	cmd->lun[0] = 1;
-	cmd->lun[1] = sc->device->id;
+	cmd->lun[1] = target_id;
 	cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
 	cmd->lun[3] = sc->device->lun & 0xff;
 	cmd->tag = cpu_to_virtio64(vdev, (unsigned long)sc);
@@ -517,12 +537,14 @@ static void virtio_scsi_init_hdr(struct virtio_device *vdev,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 				    struct virtio_scsi_cmd_req_pi *cmd_pi,
+				    int target_id,
 				    struct scsi_cmnd *sc)
 {
 	struct request *rq = sc->request;
 	struct blk_integrity *bi;
 
-	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi, sc);
+	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi,
+			     target_id, sc);
 
 	if (!rq || !scsi_prot_sg_count(sc))
 		return;
@@ -542,6 +564,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 
 static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 				 struct virtio_scsi_vq *req_vq,
+				 int target_id,
 				 struct scsi_cmnd *sc)
 {
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
@@ -564,13 +587,15 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_T10_PI)) {
-		virtio_scsi_init_hdr_pi(vscsi->vdev, &cmd->req.cmd_pi, sc);
+		virtio_scsi_init_hdr_pi(vscsi->vdev, &cmd->req.cmd_pi,
+					target_id, sc);
 		memcpy(cmd->req.cmd_pi.cdb, sc->cmnd, sc->cmd_len);
 		req_size = sizeof(cmd->req.cmd_pi);
 	} else
 #endif
 	{
-		virtio_scsi_init_hdr(vscsi->vdev, &cmd->req.cmd, sc);
+		virtio_scsi_init_hdr(vscsi->vdev, &cmd->req.cmd,
+				     target_id, sc);
 		memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 		req_size = sizeof(cmd->req.cmd);
 	}
@@ -591,11 +616,25 @@ static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
 					struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
-
+	struct virtio_scsi_target_state *tgt = NULL;
+	int target_id = sc->device->id;
+
+	if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
+		struct fc_rport *rport =
+			starget_to_rport(scsi_target(sc->device));
+		if (rport && rport->dd_data) {
+			tgt = rport->dd_data;
+			target_id = tgt->target_id;
+		}
+	} else
+		tgt = scsi_target(sc->device)->hostdata;
+	if (!tgt || tgt->removed) {
+		sc->result = DID_NO_CONNECT << 16;
+		sc->scsi_done(sc);
+		return 0;
+	}
 	atomic_inc(&tgt->reqs);
-	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], sc);
+	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], target_id, sc);
 }
 
 static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
@@ -648,16 +687,30 @@ static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
 				       struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
+	struct virtio_scsi_target_state *tgt = NULL;
 	struct virtio_scsi_vq *req_vq;
-
+	int target_id = sc->device->id;
+
+	if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
+		struct fc_rport *rport =
+			starget_to_rport(scsi_target(sc->device));
+		if (rport && rport->dd_data) {
+			tgt = rport->dd_data;
+			target_id = tgt->target_id;
+		}
+	} else
+		tgt = scsi_target(sc->device)->hostdata;
+	if (!tgt || tgt->removed) {
+		sc->result = DID_NO_CONNECT << 16;
+		sc->scsi_done(sc);
+		return 0;
+	}
 	if (shost_use_blk_mq(sh))
 		req_vq = virtscsi_pick_vq_mq(vscsi, sc);
 	else
 		req_vq = virtscsi_pick_vq(vscsi, tgt);
 
-	return virtscsi_queuecommand(vscsi, req_vq, sc);
+	return virtscsi_queuecommand(vscsi, req_vq, target_id, sc);
 }
 
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
@@ -696,12 +749,27 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
 	struct virtio_scsi_cmd *cmd;
+	struct virtio_scsi_target_state *tgt = NULL;
+	int target_id = sc->device->id;
 
 	sdev_printk(KERN_INFO, sc->device, "device reset\n");
 	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
 	if (!cmd)
 		return FAILED;
 
+	if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
+		struct fc_rport *rport =
+			starget_to_rport(scsi_target(sc->device));
+		if (rport && rport->dd_data ) {
+			tgt = rport->dd_data;
+			target_id = tgt->target_id;
+		} else
+			return FAST_IO_FAIL;
+	} else {
+		tgt = scsi_target(sc->device)->hostdata;
+		if (!tgt || tgt->removed)
+			return FAST_IO_FAIL;
+	}
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc = sc;
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
@@ -709,7 +777,7 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 		.subtype = cpu_to_virtio32(vscsi->vdev,
 					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
 		.lun[0] = 1,
-		.lun[1] = sc->device->id,
+		.lun[1] = target_id,
 		.lun[2] = (sc->device->lun >> 8) | 0x40,
 		.lun[3] = sc->device->lun & 0xff,
 	};
@@ -755,19 +823,34 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
 	struct virtio_scsi_cmd *cmd;
+	struct virtio_scsi_target_state *tgt = NULL;
+	int target_id = sc->device->id;
 
 	scmd_printk(KERN_INFO, sc, "abort\n");
 	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
 	if (!cmd)
 		return FAILED;
 
+	if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
+		struct fc_rport *rport =
+			starget_to_rport(scsi_target(sc->device));
+		if (rport && rport->dd_data ) {
+			tgt = rport->dd_data;
+			target_id = tgt->target_id;
+		} else
+			return FAST_IO_FAIL;
+	} else {
+		tgt = scsi_target(sc->device)->hostdata;
+		if (!tgt || tgt->removed)
+			return FAST_IO_FAIL;
+	}
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc = sc;
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
 		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
 		.lun[0] = 1,
-		.lun[1] = sc->device->id,
+		.lun[1] = target_id,
 		.lun[2] = (sc->device->lun >> 8) | 0x40,
 		.lun[3] = sc->device->lun & 0xff,
 		.tag = cpu_to_virtio64(vscsi->vdev, (unsigned long)sc),
@@ -777,25 +860,54 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 
 static int virtscsi_target_alloc(struct scsi_target *starget)
 {
-	struct Scsi_Host *sh = dev_to_shost(starget->dev.parent);
-	struct virtio_scsi *vscsi = shost_priv(sh);
-
-	struct virtio_scsi_target_state *tgt =
-				kmalloc(sizeof(*tgt), GFP_KERNEL);
-	if (!tgt)
-		return -ENOMEM;
-
+	struct Scsi_Host *sh;
+	struct virtio_scsi *vscsi;
+	struct fc_rport *rport;
+	struct virtio_scsi_target_state *tgt;
+
+	rport = starget_to_rport(starget);
+	if (rport) {
+		tgt = rport->dd_data;
+		sh = rport_to_shost(rport);
+		vscsi = shost_priv(sh);
+	} else {
+		sh = dev_to_shost(starget->dev.parent);
+		vscsi = shost_priv(sh);
+		spin_lock_irq(&vscsi->rescan_lock);
+		list_for_each_entry(tgt, &vscsi->target_list, list) {
+			if (tgt->target_id == starget->id) {
+				starget->hostdata = tgt;
+				break;
+			}
+		}
+		spin_unlock_irq(&vscsi->rescan_lock);
+		if (!starget->hostdata)
+			return -ENOMEM;
+		tgt = starget->hostdata;
+	}
 	seqcount_init(&tgt->tgt_seq);
 	atomic_set(&tgt->reqs, 0);
 	tgt->req_vq = &vscsi->req_vqs[0];
-
-	starget->hostdata = tgt;
+	tgt->vscsi = vscsi;
 	return 0;
 }
 
 static void virtscsi_target_destroy(struct scsi_target *starget)
 {
-	struct virtio_scsi_target_state *tgt = starget->hostdata;
+	struct fc_rport *rport;
+	struct virtio_scsi_target_state *tgt;
+
+	rport = starget_to_rport(starget);
+	if (rport) {
+		tgt = rport->dd_data;
+		rport->dd_data = NULL;
+	} else {
+		tgt = starget->hostdata;
+		starget->hostdata = NULL;
+	}
+	spin_lock_irq(&tgt->vscsi->rescan_lock);
+	list_del_init(&tgt->list);
+	spin_unlock_irq(&tgt->vscsi->rescan_lock);
 	kfree(tgt);
 }
 
@@ -821,8 +933,9 @@ static void virtscsi_rescan_work(struct work_struct *work)
 	struct virtio_scsi *vscsi =
 		container_of(work, struct virtio_scsi, rescan_work);
 	struct Scsi_Host *sh = virtio_scsi_host(vscsi->vdev);
-	int target_id, ret;
+	int target_id, ret, transport;
 	struct virtio_scsi_cmd *cmd;
+	struct virtio_scsi_target_state *tgt, *tmp, *old;
 	DECLARE_COMPLETION_ONSTACK(comp);
 
 	spin_lock_irq(&vscsi->rescan_lock);
@@ -857,27 +970,67 @@ static void virtscsi_rescan_work(struct work_struct *work)
 
 	wait_for_completion(&comp);
 	target_id = virtio32_to_cpu(vscsi->vdev, cmd->resp.rescan.id);
-	if (target_id != -1) {
-		int transport = virtio32_to_cpu(vscsi->vdev,
-						cmd->resp.rescan.transport);
-		spin_lock_irq(&vscsi->rescan_lock);
-		vscsi->next_target_id = target_id + 1;
-		spin_unlock_irq(&vscsi->rescan_lock);
-		shost_printk(KERN_INFO, sh,
-			     "found %s target %d (WWN %*phN)\n",
-			     transport == SCSI_PROTOCOL_FCP ? "FC" : "SAS",
-			     target_id, 8,
-			     cmd->resp.rescan.port_wwn);
-		scsi_scan_target(&sh->shost_gendev, 0, target_id,
-				 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
-		queue_work(system_freezable_wq, &vscsi->rescan_work);
-	} else {
+	if (target_id == -1) {
 		shost_printk(KERN_INFO, sh,
 			     "rescan: no more targets\n");
 		spin_lock_irq(&vscsi->rescan_lock);
 		vscsi->next_target_id = -1;
 		spin_unlock_irq(&vscsi->rescan_lock);
+		goto out;
+	}
+	transport = virtio32_to_cpu(vscsi->vdev, cmd->resp.rescan.transport);
+	shost_printk(KERN_INFO, sh,
+		     "found %s target %d (WWN %*phN)\n",
+		     transport == SCSI_PROTOCOL_FCP ? "FC" : "SAS",
+		     target_id, 8, cmd->resp.rescan.port_wwn);
+
+	tgt = kmalloc(sizeof(*tgt), GFP_KERNEL);
+	if (!tgt) {
+		shost_printk(KERN_WARNING, sh,
+			     "rescan: out of memory for rport\n");
+		goto out;
+	}
+	tgt->target_id = (target_id & 0xff)
+	tgt->removed = false;
+	spin_lock_irq(&vscsi->rescan_lock);
+	vscsi->next_target_id = tgt->target_id + 1;
+	list_for_each_entry(tmp, &vscsi->target_list, list) {
+		if (tgt->target_id == tmp->target_id) {
+			old = tmp;
+			break;
+		}
 	}
+	if (old) {
+		kfree(tgt);
+		tgt = old;
+	} else
+		list_add_tail(&tgt->list, &vscsi->target_list);
+	spin_unlock_irq(&vscsi->rescan_lock);
+	if (transport == SCSI_PROTOCOL_FCP) {
+		struct fc_rport_identifiers rport_ids;
+		struct fc_rport *rport;
+
+		rport_ids.node_name = wwn_to_u64(cmd->resp.rescan.node_wwn);
+		rport_ids.port_name = wwn_to_u64(cmd->resp.rescan.port_wwn);
+		rport_ids.port_id = (target_id >> 8);
+		rport = fc_remote_port_add(sh, 0, &rport_ids);
+		if (rport) {
+			tgt->rport = rport;
+			rport->dd_data = tgt;
+			fc_remote_port_rolechg(rport, FC_RPORT_ROLE_FCP_TARGET);
+		} else {
+			spin_lock_irq(&vscsi->rescan_lock);
+			list_del(&tgt->list);
+			spin_unlock_irq(&vscsi->rescan_lock);
+			kfree(tgt);
+			tgt = NULL;
+		}
+	} else {
+		scsi_scan_target(&sh->shost_gendev, 0, tgt->target_id,
+				 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
+	}
+	queue_work(system_freezable_wq, &vscsi->rescan_work);
+out:
 	mempool_free(cmd, virtscsi_cmd_pool);
 	return;
 scan_host:
@@ -920,11 +1073,15 @@ static void virtscsi_scan_host(struct virtio_scsi *vscsi)
 	if (cmd->resp.rescan.id == -1) {
 		int transport = virtio32_to_cpu(vscsi->vdev,
 						cmd->resp.rescan.transport);
+
 		shost_printk(KERN_INFO, sh,
 			     "%s host wwnn %*phN wwpn %*phN\n",
 			     transport == SCSI_PROTOCOL_FCP ? "FC" : "SAS",
 			     8, cmd->resp.rescan.node_wwn,
 			     8, cmd->resp.rescan.port_wwn);
+		vscsi->protocol = transport;
+		vscsi->wwnn = wwn_to_u64(cmd->resp.rescan.node_wwn);
+		vscsi->wwpn = wwn_to_u64(cmd->resp.rescan.port_wwn);
 	}
 	mempool_free(cmd, virtscsi_cmd_pool);
 }
@@ -932,14 +1089,31 @@ static void virtscsi_scan_host(struct virtio_scsi *vscsi)
 static void virtscsi_scan_start(struct Scsi_Host *sh)
 {
 	struct virtio_scsi *vscsi = shost_priv(sh);
+	struct virtio_scsi_target_state *tgt;
 
-	virtscsi_scan_host(vscsi);
 	spin_lock_irq(&vscsi->rescan_lock);
 	if (vscsi->next_target_id != -1) {
 		shost_printk(KERN_INFO, sh, "rescan: already running\n");
 		spin_unlock_irq(&vscsi->rescan_lock);
 		return;
 	}
+	if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
+		fc_host_node_name(sh) = vscsi->wwnn;
+		fc_host_port_name(sh) = vscsi->wwpn;
+		fc_host_port_id(sh) = 0x00ff00;
+		fc_host_port_type(sh) = FC_PORTTYPE_NPIV;
+		fc_host_port_state(sh) = FC_PORTSTATE_BLOCKED;
+		list_for_each_entry(tgt, &vscsi->target_list, list) {
+			if (tgt->rport) {
+				fc_remote_port_delete(tgt->rport);
+				tgt->rport = NULL;
+			}
+			tgt->removed = true;
+		}
+	} else {
+		list_for_each_entry(tgt, &vscsi->target_list, list)
+			tgt->removed = true;
+	}
 	vscsi->next_target_id = 0;
 	shost_printk(KERN_INFO, sh, "rescan: start\n");
 	spin_unlock_irq(&vscsi->rescan_lock);
@@ -954,12 +1128,14 @@ int virtscsi_scan_finished(struct Scsi_Host *sh, unsigned long time)
 	spin_lock_irq(&vscsi->rescan_lock);
 	if (vscsi->next_target_id != -1)
 		ret = 0;
+	else if (vscsi->protocol == SCSI_PROTOCOL_FCP)
+		fc_host_port_state(sh) = FC_PORTSTATE_ONLINE;
 	spin_unlock_irq(&vscsi->rescan_lock);
 	if (!ret)
 		flush_work(&vscsi->rescan_work);
 
-	shost_printk(KERN_INFO, sh, "rescan: %s finished\n",
-		     ret ? "" : "not");
+	shost_printk(KERN_INFO, sh, "rescan: %sfinished\n",
+		     ret ? "" : "not ");
 	return ret;
 }
 
@@ -978,6 +1154,34 @@ static ssize_t virtscsi_host_store_rescan(struct device *dev,
 	NULL,
 };
 
+static int virtscsi_issue_lip(struct Scsi_Host *shost)
+{
+	struct virtio_scsi *vscsi = shost_priv(shost);
+	unsigned long start = jiffies;
+	struct virtio_scsi_target_state *tgt;
+
+	spin_lock_irq(&vscsi->rescan_lock);
+	if (vscsi->next_target_id != -1) {
+		spin_unlock_irq(&vscsi->rescan_lock);
+		return 0;
+	}
+	fc_host_port_state(shost) = FC_PORTSTATE_BLOCKED;
+	list_for_each_entry(tgt, &vscsi->target_list, list) {
+		if (tgt->rport) {
+			fc_remote_port_delete(tgt->rport);
+			tgt->rport = NULL;
+		}
+	}
+	vscsi->next_target_id = 0;
+	spin_unlock_irq(&vscsi->rescan_lock);
+	queue_work(system_freezable_wq, &vscsi->rescan_work);
+
+	while (!virtscsi_scan_finished(shost, jiffies - start))
+		msleep(10);
+
+	return 0;
+}
+
 static struct scsi_host_template virtscsi_host_template_single = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
@@ -1066,6 +1270,20 @@ static ssize_t virtscsi_host_store_rescan(struct device *dev,
 	.track_queue_depth = 1,
 };
 
+static struct fc_function_template virtscsi_transport_functions = {
+	.dd_fcrport_size = sizeof(struct virtio_scsi_target_state *),
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_port_id = 1,
+	.show_host_port_state = 1,
+	.show_host_port_type = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+	.show_rport_dev_loss_tmo = 1,
+	.issue_fc_host_lip = virtscsi_issue_lip,
+};
+
 #define virtscsi_config_get(vdev, fld) \
 	({ \
 		typeof(((struct virtio_scsi_config *)0)->fld) __val; \
@@ -1193,7 +1411,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	vscsi->num_queues = num_queues;
 	vdev->priv = shost;
 	vscsi->next_target_id = -1;
+	vscsi->protocol = SCSI_PROTOCOL_SAS;
 	spin_lock_init(&vscsi->rescan_lock);
+	INIT_LIST_HEAD(&vscsi->target_list);
 	INIT_WORK(&vscsi->rescan_work, virtscsi_rescan_work);
 
 	err = virtscsi_init(vdev, vscsi);
@@ -1228,6 +1448,10 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	}
 #endif
 
+	virtscsi_scan_host(vscsi);
+	if (vscsi->protocol == SCSI_PROTOCOL_FCP)
+		shost->transportt = virtio_transport_template;
+
 	err = scsi_add_host(shost, &vdev->dev);
 	if (err)
 		goto scsi_add_host_failed;
@@ -1332,6 +1556,10 @@ static int __init init(void)
 		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
 		goto error;
 	}
+	virtio_transport_template =
+		fc_attach_transport(&virtscsi_transport_functions);
+	if (!virtio_transport_template)
+		goto error;
 	ret = register_virtio_driver(&virtio_scsi_driver);
 	if (ret < 0)
 		goto error;
@@ -1339,6 +1567,8 @@ static int __init init(void)
 	return 0;
 
 error:
+	if (virtio_transport_template)
+		fc_release_transport(virtio_transport_template);
 	if (virtscsi_cmd_pool) {
 		mempool_destroy(virtscsi_cmd_pool);
 		virtscsi_cmd_pool = NULL;
@@ -1352,6 +1582,7 @@ static int __init init(void)
 
 static void __exit fini(void)
 {
+	fc_release_transport(virtio_transport_template);
 	unregister_virtio_driver(&virtio_scsi_driver);
 	mempool_destroy(virtscsi_cmd_pool);
 	kmem_cache_destroy(virtscsi_cmd_cache);
-- 
1.8.5.6
