From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: Allow activation of scsi-mq per-driver
Date: Fri, 22 Jan 2016 14:41:28 +0100
Message-ID: <1453470088-43959-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbcAVNlf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 08:41:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

Allow the activation of the scsi-mq feature on a per-driver bassis as opposed
to the current stack global (de)activation.

This allows us to have setups which can combine "slow" rotational media and
fast media on two different HBA types.

The following is from a host with rotational disks behind a HP SAS Adapter and
a fibre channel array behind a Emulex FC Adapter. The hpsa driver does not
support scsi-mq yet (and has rotational disks attached to it), but the lpfc
does. This patch allows an optimal combination of the scsi-mq enabled lpfc
driver and the hpsa driver which still uses a single queue scsi layer and thus
can make use of IO schedulers.

host:~ # cat /sys/block/sd?/queue/scheduler
noop deadline [cfq]
none
none
none
none
none
none
none
none
none
none
none
none
none
none
none
none

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/fnic/fnic_main.c | 10 ++++++++++
 drivers/scsi/hosts.c          |  2 +-
 drivers/scsi/lpfc/lpfc_init.c |  8 ++++++++
 drivers/scsi/virtio_scsi.c    | 11 +++++++++++
 include/scsi/scsi_host.h      |  3 ---
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 58ce902..dcb06eb 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -83,6 +83,15 @@ static unsigned int fnic_max_qdepth = FNIC_DFLT_QUEUE_DEPTH;
 module_param(fnic_max_qdepth, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_max_qdepth, "Queue depth to report for each LUN");
 
+#ifdef CONFIG_SCSI_MQ_DEFAULT
+static bool fnic_use_blk_mq = true;
+#else
+static bool fnic_use_blk_mq = false;
+#endif
+
+module_param_named(use_blk_mq, fnic_use_blk_mq, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(use_blk_mq, "Use blk-mq for fnic");
+
 static struct libfc_function_template fnic_transport_template = {
 	.frame_send = fnic_send,
 	.lport_set_port_id = fnic_set_port_id,
@@ -567,6 +576,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 host->host_no);
 
 	host->transportt = fnic_fc_transport;
+	host->use_blk_mq = fnic_use_blk_mq;
 
 	err = fnic_stats_debugfs_init(fnic);
 	if (err) {
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 94025c5..d64288a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -479,7 +479,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	shost->use_blk_mq = scsi_use_blk_mq && !shost->hostt->disable_blk_mq;
+	shost->use_blk_mq = scsi_use_blk_mq;
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index db9446c..2ea7704 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -86,6 +86,13 @@ static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 
+#ifdef CONFIG_SCSI_MQ_DEFAULT
+static bool lpfc_use_blk_mq = true;
+#else
+static bool lpfc_use_blk_mq = false;
+#endif
+module_param_named(use_blk_mq, lpfc_use_blk_mq, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(use_blk_mq, "Use blk-mq for lpfc driver");
 /**
  * lpfc_config_port_prep - Perform lpfc initialization prior to config port
  * @phba: pointer to lpfc hba data structure.
@@ -3311,6 +3318,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->this_id = -1;
 	shost->max_cmd_len = 16;
 	shost->nr_hw_queues = phba->cfg_fcp_io_channel;
+	shost->use_blk_mq = lpfc_use_blk_mq;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		shost->dma_boundary =
 			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7dbbb29..a6e7294 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -34,6 +34,14 @@
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
 
+#ifdef CONFIG_SCSI_MQ_DEFAULT
+static bool virtio_use_blk_mq = true;
+#else
+static bool virtio_use_blk_mq = false;
+#endif
+module_param_named(use_blk_mq, virtio_use_blk_mq, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(use_blk_mq, "Use blk-mq for virtio_scsi driver");
+
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
@@ -976,6 +984,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (!shost)
 		return -ENOMEM;
 
+	if (hostt == &virtscsi_host_template_multi)
+		shost->use_blk_mq = virtio_use_blk_mq;
+
 	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;
 	shost->sg_tablesize = sg_elems;
 	vscsi = shost_priv(shost);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..3d6a2de 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -495,9 +495,6 @@ struct scsi_host_template {
 	 */
 	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
-
-	/* temporary flag to disable blk-mq I/O path */
-	bool disable_blk_mq;
 };
 
 /*
-- 
1.8.5.6

