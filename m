From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.16-rc7
Date: Tue, 27 Mar 2018 07:19:33 -0700
Message-ID: <1522160373.4539.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two driver fixes (ibmvfc, iscsi_tcp) and a USB fix for devices that
give the wrong return to Read Capacity and cause a huge log spew.  The
remaining 5 patches all try to fix commit 84676c1f21e8ff5
"genirq/affinity: assign vectors to all possible CPUs") which broke the
non-mq I/O path.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (1):
      scsi: ibmvfc: Avoid unnecessary port relogin

Jianchao Wang (1):
      scsi: iscsi_tcp: set BDI_CAP_STABLE_WRITES when data digest enabled

Martin K. Petersen (1):
      scsi: sd: Remember that READ CAPACITY(16) succeeded

Ming Lei (5):
      scsi: virtio_scsi: unify scsi_host_template
      scsi: virtio_scsi: fix IO hang caused by automatic irq vector affinity
      scsi: core: introduce force_blk_mq
      scsi: megaraid_sas: fix selection of reply queue
      scsi: hpsa: fix selection of reply queue

And the diffstat:

 drivers/scsi/hosts.c                        |   1 +
 drivers/scsi/hpsa.c                         |  73 ++++++++++++----
 drivers/scsi/hpsa.h                         |   1 +
 drivers/scsi/ibmvscsi/ibmvfc.c              |   6 +-
 drivers/scsi/iscsi_tcp.c                    |   8 ++
 drivers/scsi/megaraid/megaraid_sas.h        |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |  39 ++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  12 +--
 drivers/scsi/sd.c                           |   2 +
 drivers/scsi/virtio_scsi.c                  | 129 ++++------------------------
 include/scsi/scsi_host.h                    |   3 +
 11 files changed, 128 insertions(+), 147 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index dd9464920456..ef22b275d050 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -474,6 +474,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost->dma_boundary = 0xffffffff;
 
 	shost->use_blk_mq = scsi_use_blk_mq;
+	shost->use_blk_mq = scsi_use_blk_mq || shost->hostt->force_blk_mq;
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 87b260e403ec..31423b6dc26d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1045,11 +1045,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c,
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 		if (unlikely(!h->msix_vectors))
 			return;
-		if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
-			c->Header.ReplyQueue =
-				raw_smp_processor_id() % h->nreply_queues;
-		else
-			c->Header.ReplyQueue = reply_queue % h->nreply_queues;
+		c->Header.ReplyQueue = reply_queue;
 	}
 }
 
@@ -1063,10 +1059,7 @@ static void set_ioaccel1_performant_mode(struct ctlr_info *h,
 	 * Tell the controller to post the reply to the queue for this
 	 * processor.  This seems to give the best I/O throughput.
 	 */
-	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
-		cp->ReplyQueue = smp_processor_id() % h->nreply_queues;
-	else
-		cp->ReplyQueue = reply_queue % h->nreply_queues;
+	cp->ReplyQueue = reply_queue;
 	/*
 	 * Set the bits in the address sent down to include:
 	 *  - performant mode bit (bit 0)
@@ -1087,10 +1080,7 @@ static void set_ioaccel2_tmf_performant_mode(struct ctlr_info *h,
 	/* Tell the controller to post the reply to the queue for this
 	 * processor.  This seems to give the best I/O throughput.
 	 */
-	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
-		cp->reply_queue = smp_processor_id() % h->nreply_queues;
-	else
-		cp->reply_queue = reply_queue % h->nreply_queues;
+	cp->reply_queue = reply_queue;
 	/* Set the bits in the address sent down to include:
 	 *  - performant mode bit not used in ioaccel mode 2
 	 *  - pull count (bits 0-3)
@@ -1109,10 +1099,7 @@ static void set_ioaccel2_performant_mode(struct ctlr_info *h,
 	 * Tell the controller to post the reply to the queue for this
 	 * processor.  This seems to give the best I/O throughput.
 	 */
-	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
-		cp->reply_queue = smp_processor_id() % h->nreply_queues;
-	else
-		cp->reply_queue = reply_queue % h->nreply_queues;
+	cp->reply_queue = reply_queue;
 	/*
 	 * Set the bits in the address sent down to include:
 	 *  - performant mode bit not used in ioaccel mode 2
@@ -1157,6 +1144,8 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 {
 	dial_down_lockup_detection_during_fw_flash(h, c);
 	atomic_inc(&h->commands_outstanding);
+
+	reply_queue = h->reply_map[raw_smp_processor_id()];
 	switch (c->cmd_type) {
 	case CMD_IOACCEL1:
 		set_ioaccel1_performant_mode(h, c, reply_queue);
@@ -7376,6 +7365,26 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
 	h->msix_vectors = 0;
 }
 
+static void hpsa_setup_reply_map(struct ctlr_info *h)
+{
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	for (queue = 0; queue < h->msix_vectors; queue++) {
+		mask = pci_irq_get_affinity(h->pdev, queue);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask)
+			h->reply_map[cpu] = queue;
+	}
+	return;
+
+fallback:
+	for_each_possible_cpu(cpu)
+		h->reply_map[cpu] = 0;
+}
+
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
  * controllers that are capable. If not, we use legacy INTx mode.
  */
@@ -7771,6 +7780,10 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	err = hpsa_interrupt_mode(h);
 	if (err)
 		goto clean1;
+
+	/* setup mapping between CPU and reply queue */
+	hpsa_setup_reply_map(h);
+
 	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
 		goto clean2;	/* intmode+region, pci */
@@ -8480,6 +8493,28 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
 	return wq;
 }
 
+static void hpda_free_ctlr_info(struct ctlr_info *h)
+{
+	kfree(h->reply_map);
+	kfree(h);
+}
+
+static struct ctlr_info *hpda_alloc_ctlr_info(void)
+{
+	struct ctlr_info *h;
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return NULL;
+
+	h->reply_map = kzalloc(sizeof(*h->reply_map) * nr_cpu_ids, GFP_KERNEL);
+	if (!h->reply_map) {
+		kfree(h);
+		return NULL;
+	}
+	return h;
+}
+
 static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int dac, rc;
@@ -8517,7 +8552,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * the driver.  See comments in hpsa.h for more info.
 	 */
 	BUILD_BUG_ON(sizeof(struct CommandList) % COMMANDLIST_ALIGNMENT);
-	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	h = hpda_alloc_ctlr_info();
 	if (!h) {
 		dev_err(&pdev->dev, "Failed to allocate controller head\n");
 		return -ENOMEM;
@@ -8916,7 +8951,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	h->lockup_detected = NULL;			/* init_one 2 */
 	/* (void) pci_disable_pcie_error_reporting(pdev); */	/* init_one 1 */
 
-	kfree(h);					/* init_one 1 */
+	hpda_free_ctlr_info(h);				/* init_one 1 */
 }
 
 static int hpsa_suspend(__attribute__((unused)) struct pci_dev *pdev,
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 018f980a701c..fb9f5e7f8209 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -158,6 +158,7 @@ struct bmic_controller_parameters {
 #pragma pack()
 
 struct ctlr_info {
+	unsigned int *reply_map;
 	int	ctlr;
 	char	devname[8];
 	char    *product_name;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b1b1d3a3b173..daefe8172b04 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3579,11 +3579,9 @@ static void ibmvfc_tgt_implicit_logout(struct ibmvfc_target *tgt)
 static int ibmvfc_adisc_needs_plogi(struct ibmvfc_passthru_mad *mad,
 				    struct ibmvfc_target *tgt)
 {
-	if (memcmp(&mad->fc_iu.response[2], &tgt->ids.port_name,
-		   sizeof(tgt->ids.port_name)))
+	if (wwn_to_u64((u8 *)&mad->fc_iu.response[2]) != tgt->ids.port_name)
 		return 1;
-	if (memcmp(&mad->fc_iu.response[4], &tgt->ids.node_name,
-		   sizeof(tgt->ids.node_name)))
+	if (wwn_to_u64((u8 *)&mad->fc_iu.response[4]) != tgt->ids.node_name)
 		return 1;
 	if (be32_to_cpu(mad->fc_iu.response[6]) != tgt->scsi_id)
 		return 1;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6198559abbd8..dd66c11399a2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -37,6 +37,7 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/module.h>
+#include <linux/backing-dev.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -954,6 +955,13 @@ static int iscsi_sw_tcp_slave_alloc(struct scsi_device *sdev)
 
 static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 {
+	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(sdev->host);
+	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_conn *conn = session->leadconn;
+
+	if (conn->datadgst_en)
+		sdev->request_queue->backing_dev_info->capabilities
+			|= BDI_CAP_STABLE_WRITES;
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
 	blk_queue_dma_alignment(sdev->request_queue, 0);
 	return 0;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ba6503f37756..27fab8235ea5 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2128,6 +2128,7 @@ enum MR_PD_TYPE {
 
 struct megasas_instance {
 
+	unsigned int *reply_map;
 	__le32 *producer;
 	dma_addr_t producer_h;
 	__le32 *consumer;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0f1d88f272be..7b2bed5ab04c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5165,6 +5165,26 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 		instance->use_seqnum_jbod_fp = false;
 }
 
+static void megasas_setup_reply_map(struct megasas_instance *instance)
+{
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	for (queue = 0; queue < instance->msix_vectors; queue++) {
+		mask = pci_irq_get_affinity(instance->pdev, queue);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask)
+			instance->reply_map[cpu] = queue;
+	}
+	return;
+
+fallback:
+	for_each_possible_cpu(cpu)
+		instance->reply_map[cpu] = cpu % instance->msix_vectors;
+}
+
 /**
  * megasas_init_fw -	Initializes the FW
  * @instance:		Adapter soft state
@@ -5343,6 +5363,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			goto fail_setup_irqs;
 	}
 
+	megasas_setup_reply_map(instance);
+
 	dev_info(&instance->pdev->dev,
 		"firmware supports msix\t: (%d)", fw_msix_count);
 	dev_info(&instance->pdev->dev,
@@ -6123,20 +6145,29 @@ static inline int megasas_alloc_mfi_ctrl_mem(struct megasas_instance *instance)
  */
 static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
 {
+	instance->reply_map = kzalloc(sizeof(unsigned int) * nr_cpu_ids,
+				      GFP_KERNEL);
+	if (!instance->reply_map)
+		return -ENOMEM;
+
 	switch (instance->adapter_type) {
 	case MFI_SERIES:
 		if (megasas_alloc_mfi_ctrl_mem(instance))
-			return -ENOMEM;
+			goto fail;
 		break;
 	case VENTURA_SERIES:
 	case THUNDERBOLT_SERIES:
 	case INVADER_SERIES:
 		if (megasas_alloc_fusion_context(instance))
-			return -ENOMEM;
+			goto fail;
 		break;
 	}
 
 	return 0;
+ fail:
+	kfree(instance->reply_map);
+	instance->reply_map = NULL;
+	return -ENOMEM;
 }
 
 /*
@@ -6148,6 +6179,7 @@ static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
  */
 static inline void megasas_free_ctrl_mem(struct megasas_instance *instance)
 {
+	kfree(instance->reply_map);
 	if (instance->adapter_type == MFI_SERIES) {
 		if (instance->producer)
 			pci_free_consistent(instance->pdev, sizeof(u32),
@@ -6540,7 +6572,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		pci_free_irq_vectors(instance->pdev);
 fail_init_mfi:
 	scsi_host_put(host);
-
 fail_alloc_instance:
 	pci_disable_device(pdev);
 
@@ -6746,6 +6777,8 @@ megasas_resume(struct pci_dev *pdev)
 	if (rval < 0)
 		goto fail_reenable_msix;
 
+	megasas_setup_reply_map(instance);
+
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_reset_reply_desc(instance);
 		if (megasas_ioc_init_fusion(instance)) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index dc8e850fbfd2..5ec3b74e8aed 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2641,11 +2641,8 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			fp_possible = (io_info.fpOkForIo > 0) ? true : false;
 	}
 
-	/* Use raw_smp_processor_id() for now until cmd->request->cpu is CPU
-	   id by default, not CPU group id, otherwise all MSI-X queues won't
-	   be utilized */
-	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
-		raw_smp_processor_id() % instance->msix_vectors : 0;
+	cmd->request_desc->SCSIIO.MSIxIndex =
+		instance->reply_map[raw_smp_processor_id()];
 
 	praid_context = &io_request->RaidContext;
 
@@ -2971,10 +2968,9 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 	}
 
 	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
-	cmd->request_desc->SCSIIO.MSIxIndex =
-		instance->msix_vectors ?
-		(raw_smp_processor_id() % instance->msix_vectors) : 0;
 
+	cmd->request_desc->SCSIIO.MSIxIndex =
+		instance->reply_map[raw_smp_processor_id()];
 
 	if (!fp_possible) {
 		/* system pd firmware path */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b45f7fc5620..13ec1b5ef75c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2513,6 +2513,8 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 				sector_size = old_sector_size;
 				goto got_data;
 			}
+			/* Remember that READ CAPACITY(16) succeeded */
+			sdp->try_rc_10_first = 0;
 		}
 	}
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7c28e8d4955a..45d04631888a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -91,9 +91,6 @@ struct virtio_scsi_vq {
 struct virtio_scsi_target_state {
 	seqcount_t tgt_seq;
 
-	/* Count of outstanding requests. */
-	atomic_t reqs;
-
 	/* Currently active virtqueue for requests sent to this target. */
 	struct virtio_scsi_vq *req_vq;
 };
@@ -152,8 +149,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
@@ -210,8 +205,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	}
 
 	sc->scsi_done(sc);
-
-	atomic_dec(&tgt->reqs);
 }
 
 static void virtscsi_vq_done(struct virtio_scsi *vscsi,
@@ -529,11 +522,20 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 }
 #endif
 
-static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
-				 struct virtio_scsi_vq *req_vq,
+static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
+						  struct scsi_cmnd *sc)
+{
+	u32 tag = blk_mq_unique_tag(sc->request);
+	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
+
+	return &vscsi->req_vqs[hwq];
+}
+
+static int virtscsi_queuecommand(struct Scsi_Host *shost,
 				 struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
+	struct virtio_scsi *vscsi = shost_priv(shost);
+	struct virtio_scsi_vq *req_vq = virtscsi_pick_vq_mq(vscsi, sc);
 	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
 	unsigned long flags;
 	int req_size;
@@ -576,79 +578,6 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 	return 0;
 }
 
-static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
-					struct scsi_cmnd *sc)
-{
-	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
-
-	atomic_inc(&tgt->reqs);
-	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], sc);
-}
-
-static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
-						  struct scsi_cmnd *sc)
-{
-	u32 tag = blk_mq_unique_tag(sc->request);
-	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
-
-	return &vscsi->req_vqs[hwq];
-}
-
-static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
-					       struct virtio_scsi_target_state *tgt)
-{
-	struct virtio_scsi_vq *vq;
-	unsigned long flags;
-	u32 queue_num;
-
-	local_irq_save(flags);
-	if (atomic_inc_return(&tgt->reqs) > 1) {
-		unsigned long seq;
-
-		do {
-			seq = read_seqcount_begin(&tgt->tgt_seq);
-			vq = tgt->req_vq;
-		} while (read_seqcount_retry(&tgt->tgt_seq, seq));
-	} else {
-		/* no writes can be concurrent because of atomic_t */
-		write_seqcount_begin(&tgt->tgt_seq);
-
-		/* keep previous req_vq if a reader just arrived */
-		if (unlikely(atomic_read(&tgt->reqs) > 1)) {
-			vq = tgt->req_vq;
-			goto unlock;
-		}
-
-		queue_num = smp_processor_id();
-		while (unlikely(queue_num >= vscsi->num_queues))
-			queue_num -= vscsi->num_queues;
-		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
- unlock:
-		write_seqcount_end(&tgt->tgt_seq);
-	}
-	local_irq_restore(flags);
-
-	return vq;
-}
-
-static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
-				       struct scsi_cmnd *sc)
-{
-	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
-	struct virtio_scsi_vq *req_vq;
-
-	if (shost_use_blk_mq(sh))
-		req_vq = virtscsi_pick_vq_mq(vscsi, sc);
-	else
-		req_vq = virtscsi_pick_vq(vscsi, tgt);
-
-	return virtscsi_queuecommand(vscsi, req_vq, sc);
-}
-
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
@@ -775,7 +704,6 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
 		return -ENOMEM;
 
 	seqcount_init(&tgt->tgt_seq);
-	atomic_set(&tgt->reqs, 0);
 	tgt->req_vq = &vscsi->req_vqs[0];
 
 	starget->hostdata = tgt;
@@ -805,33 +733,13 @@ static enum blk_eh_timer_return virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	return BLK_EH_RESET_TIMER;
 }
 
-static struct scsi_host_template virtscsi_host_template_single = {
-	.module = THIS_MODULE,
-	.name = "Virtio SCSI HBA",
-	.proc_name = "virtio_scsi",
-	.this_id = -1,
-	.cmd_size = sizeof(struct virtio_scsi_cmd),
-	.queuecommand = virtscsi_queuecommand_single,
-	.change_queue_depth = virtscsi_change_queue_depth,
-	.eh_abort_handler = virtscsi_abort,
-	.eh_device_reset_handler = virtscsi_device_reset,
-	.eh_timed_out = virtscsi_eh_timed_out,
-	.slave_alloc = virtscsi_device_alloc,
-
-	.dma_boundary = UINT_MAX,
-	.use_clustering = ENABLE_CLUSTERING,
-	.target_alloc = virtscsi_target_alloc,
-	.target_destroy = virtscsi_target_destroy,
-	.track_queue_depth = 1,
-};
-
-static struct scsi_host_template virtscsi_host_template_multi = {
+static struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
 	.cmd_size = sizeof(struct virtio_scsi_cmd),
-	.queuecommand = virtscsi_queuecommand_multi,
+	.queuecommand = virtscsi_queuecommand,
 	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
@@ -844,6 +752,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.target_destroy = virtscsi_target_destroy,
 	.map_queues = virtscsi_map_queues,
 	.track_queue_depth = 1,
+	.force_blk_mq = 1,
 };
 
 #define virtscsi_config_get(vdev, fld) \
@@ -936,7 +845,6 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	u32 sg_elems, num_targets;
 	u32 cmd_per_lun;
 	u32 num_queues;
-	struct scsi_host_template *hostt;
 
 	if (!vdev->config->get) {
 		dev_err(&vdev->dev, "%s failure: config access disabled\n",
@@ -949,12 +857,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 
-	if (num_queues == 1)
-		hostt = &virtscsi_host_template_single;
-	else
-		hostt = &virtscsi_host_template_multi;
-
-	shost = scsi_host_alloc(hostt,
+	shost = scsi_host_alloc(&virtscsi_host_template,
 		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
 	if (!shost)
 		return -ENOMEM;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index a8b7bf879ced..9c1e4bad6581 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -452,6 +452,9 @@ struct scsi_host_template {
 	/* True if the controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
+	/* True if the low-level driver supports blk-mq only */
+	unsigned force_blk_mq:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
