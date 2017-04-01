From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.11-rc4
Date: Sat, 01 Apr 2017 09:13:44 -0700
Message-ID: <1491063224.3128.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thirteen small fixes: The hopefully final effort to get the lpfc nvme
kconfig problems sorted, there's one important sg fix (user can induce
read after end of buffer) and one minor enhancement (adding an extra
PCI ID to qedi). The rest are a set of minor fixes, which mostly occur
as user visible in error legs or on specific devices.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: lpfc: fix building without debugfs support

Bart Van Assche (3):
      scsi: scsi_dh_alua: Warn if the first argument of alua_rtpg_queue() is NULL
      scsi: scsi_dh_alua: Ensure that alua_activate() calls the completion function
      scsi: scsi_dh_alua: Check scsi_device_get() return value

Bill Kuzeja (1):
      scsi: qla2xxx: Fix crash in qla2xxx_eh_abort on bad ptr

Dick Kennedy (1):
      scsi: lpfc: Fix PT2PT PRLI reject

Jaehoon Chung (1):
      scsi: ufs: remove the duplicated checking for supporting clkscaling

John Garry (1):
      scsi: libsas: fix ata xfer length

Manish Rangankar (1):
      scsi: qedi: Add PCI device-ID for QL41xxx adapters.

Raghava Aditya Renukunta (1):
      scsi: aacraid: Fix potential null access

Tomas Henzl (1):
      scsi: hpsa: fix volume offline state

Tomas Winkler (1):
      scsi: ufshcd-platform: remove the useless cast in ERR_PTR/IS_ERR

peter chang (1):
      scsi: sg: check length passed to SG_NEXT_CMD_LEN

And the diffstat:

 drivers/scsi/aacraid/commsup.c             | 14 +++++------
 drivers/scsi/device_handler/scsi_dh_alua.c | 38 +++++++++++++++++++-----------
 drivers/scsi/hpsa.c                        |  1 +
 drivers/scsi/libsas/sas_ata.c              |  2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h           | 22 ++++++++++-------
 drivers/scsi/lpfc/lpfc_els.c               |  3 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c             |  4 ++--
 drivers/scsi/qedi/qedi_main.c              |  1 +
 drivers/scsi/qla2xxx/qla_os.c              |  3 ++-
 drivers/scsi/sg.c                          |  2 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c           |  4 ++--
 drivers/scsi/ufs/ufshcd.c                  |  2 --
 12 files changed, 57 insertions(+), 39 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a3ad042..c8172f1 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2056,7 +2056,6 @@ static int fillup_pools(struct aac_dev *dev, struct hw_fib **hw_fib_pool,
 {
 	struct hw_fib **hw_fib_p;
 	struct fib **fib_p;
-	int rcode = 1;
 
 	hw_fib_p = hw_fib_pool;
 	fib_p = fib_pool;
@@ -2074,11 +2073,11 @@ static int fillup_pools(struct aac_dev *dev, struct hw_fib **hw_fib_pool,
 		}
 	}
 
+	/*
+	 * Get the actual number of allocated fibs
+	 */
 	num = hw_fib_p - hw_fib_pool;
-	if (!num)
-		rcode = 0;
-
-	return rcode;
+	return num;
 }
 
 static void wakeup_fibctx_threads(struct aac_dev *dev,
@@ -2186,7 +2185,6 @@ static void aac_process_events(struct aac_dev *dev)
 	struct fib *fib;
 	unsigned long flags;
 	spinlock_t *t_lock;
-	unsigned int rcode;
 
 	t_lock = dev->queues->queue[HostNormCmdQueue].lock;
 	spin_lock_irqsave(t_lock, flags);
@@ -2269,8 +2267,8 @@ static void aac_process_events(struct aac_dev *dev)
 		 * Fill up fib pointer pools with actual fibs
 		 * and hw_fibs
 		 */
-		rcode = fillup_pools(dev, hw_fib_pool, fib_pool, num);
-		if (!rcode)
+		num = fillup_pools(dev, hw_fib_pool, fib_pool, num);
+		if (!num)
 			goto free_mem;
 
 		/*
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 48e2001..c01b47e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -113,7 +113,7 @@ struct alua_queue_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static void alua_rtpg_work(struct work_struct *work);
-static void alua_rtpg_queue(struct alua_port_group *pg,
+static bool alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force);
 static void alua_check(struct scsi_device *sdev, bool force);
@@ -862,7 +862,13 @@ static void alua_rtpg_work(struct work_struct *work)
 	kref_put(&pg->kref, release_port_group);
 }
 
-static void alua_rtpg_queue(struct alua_port_group *pg,
+/**
+ * alua_rtpg_queue() - cause RTPG to be submitted asynchronously
+ *
+ * Returns true if and only if alua_rtpg_work() will be called asynchronously.
+ * That function is responsible for calling @qdata->fn().
+ */
+static bool alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force)
 {
@@ -870,8 +876,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	unsigned long flags;
 	struct workqueue_struct *alua_wq = kaluad_wq;
 
-	if (!pg)
-		return;
+	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
+		return false;
 
 	spin_lock_irqsave(&pg->lock, flags);
 	if (qdata) {
@@ -884,14 +890,12 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		pg->flags |= ALUA_PG_RUN_RTPG;
 		kref_get(&pg->kref);
 		pg->rtpg_sdev = sdev;
-		scsi_device_get(sdev);
 		start_queue = 1;
 	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
 		pg->flags |= ALUA_PG_RUN_RTPG;
 		/* Do not queue if the worker is already running */
 		if (!(pg->flags & ALUA_PG_RUNNING)) {
 			kref_get(&pg->kref);
-			sdev = NULL;
 			start_queue = 1;
 		}
 	}
@@ -900,13 +904,17 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		alua_wq = kaluad_sync_wq;
 	spin_unlock_irqrestore(&pg->lock, flags);
 
-	if (start_queue &&
-	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
-				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
-		if (sdev)
-			scsi_device_put(sdev);
-		kref_put(&pg->kref, release_port_group);
+	if (start_queue) {
+		if (queue_delayed_work(alua_wq, &pg->rtpg_work,
+				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS)))
+			sdev = NULL;
+		else
+			kref_put(&pg->kref, release_port_group);
 	}
+	if (sdev)
+		scsi_device_put(sdev);
+
+	return true;
 }
 
 /*
@@ -1007,11 +1015,13 @@ static int alua_activate(struct scsi_device *sdev,
 		mutex_unlock(&h->init_mutex);
 		goto out;
 	}
-	fn = NULL;
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	alua_rtpg_queue(pg, sdev, qdata, true);
+	if (alua_rtpg_queue(pg, sdev, qdata, true))
+		fn = NULL;
+	else
+		err = SCSI_DH_DEV_OFFLINED;
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0d0be77..9d659aa 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3885,6 +3885,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		volume_offline = hpsa_volume_offline(h, scsi3addr);
+		this_device->volume_offline = volume_offline;
 		if (volume_offline == HPSA_LV_FAILED) {
 			rc = HPSA_LV_FAILED;
 			dev_err(&h->pdev->dev,
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 763f012..87f5e694 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -221,7 +221,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->num_scatter = qc->n_elem;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
-			xfer += sg->length;
+			xfer += sg_dma_len(sg);
 
 		task->total_xfer_len = xfer;
 		task->num_scatter = si;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index c05f56c..7b7d314 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -44,14 +44,6 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
-enum {
-	DUMP_FCP,
-	DUMP_NVME,
-	DUMP_MBX,
-	DUMP_ELS,
-	DUMP_NVMELS,
-};
-
 /* nvmestat output buffer size */
 #define LPFC_NVMESTAT_SIZE 8192
 #define LPFC_NVMEKTIME_SIZE 8192
@@ -283,8 +275,22 @@ struct lpfc_idiag {
 	struct lpfc_idiag_offset offset;
 	void *ptr_private;
 };
+
+#else
+
+#define lpfc_nvmeio_data(phba, fmt, arg...) \
+	no_printk(fmt, ##arg)
+
 #endif
 
+enum {
+	DUMP_FCP,
+	DUMP_NVME,
+	DUMP_MBX,
+	DUMP_ELS,
+	DUMP_NVMELS,
+};
+
 /* Mask for discovery_trace */
 #define LPFC_DISC_TRC_ELS_CMD		0x1	/* Trace ELS commands */
 #define LPFC_DISC_TRC_ELS_RSP		0x2	/* Trace ELS response */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d9c61d0..a5ca37e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7968,7 +7968,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvPRLI++;
-		if (vport->port_state < LPFC_DISC_AUTH) {
+		if ((vport->port_state < LPFC_DISC_AUTH) &&
+		    (vport->fc_flag & FC_FABRIC)) {
 			rjt_err = LSRJT_UNABLE_TPC;
 			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 7ca868f..acba1b6 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -520,7 +520,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_hba *phba = ctxp->phba;
 	struct lpfc_iocbq *nvmewqeq;
 	unsigned long iflags;
-	int rc, id;
+	int rc;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (phba->ktime_on) {
@@ -530,7 +530,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 			ctxp->ts_nvme_data = ktime_get_ns();
 	}
 	if (phba->cpucheck_on & LPFC_CHECK_NVMET_IO) {
-		id = smp_processor_id();
+		int id = smp_processor_id();
 		ctxp->cpu = id;
 		if (id < LPFC_CHECK_CPU_CNT)
 			phba->cpucheck_xmt_io[id]++;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 8e3d928..92775a8 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2007,6 +2007,7 @@ static void qedi_remove(struct pci_dev *pdev)
 
 static struct pci_device_id qedi_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, 0x165E) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, 0x8084) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qedi_pci_tbl);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1fed235..f28d38e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1651,7 +1651,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 				/* Don't abort commands in adapter during EEH
 				 * recovery as it's not accessible/responding.
 				 */
-				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy) {
+				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy &&
+				    (sp->type == SRB_SCSI_CMD)) {
 					/* Get a reference to the sp and drop the lock.
 					 * The reference ensures this sp->done() call
 					 * - and not the call in qla2xxx_eh_abort() -
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 29b8650..225abaa 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -996,6 +996,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		result = get_user(val, ip);
 		if (result)
 			return result;
+		if (val > SG_MAX_CDB_SIZE)
+			return -ENOMEM;
 		sfp->next_cmd_len = (val > 0) ? val : 0;
 		return 0;
 	case SG_GET_VERSION_NUM:
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index a72a4ba..8e5e6c0 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -309,8 +309,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mmio_base = devm_ioremap_resource(dev, mem_res);
-	if (IS_ERR(*(void **)&mmio_base)) {
-		err = PTR_ERR(*(void **)&mmio_base);
+	if (IS_ERR(mmio_base)) {
+		err = PTR_ERR(mmio_base);
 		goto out;
 	}
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e8c26e6..096e95b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4662,8 +4662,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		}
 		if (ufshcd_is_clkscaling_supported(hba))
 			hba->clk_scaling.active_reqs--;
-		if (ufshcd_is_clkscaling_supported(hba))
-			hba->clk_scaling.active_reqs--;
 	}
 
 	/* clear corresponding bits of completed commands */
