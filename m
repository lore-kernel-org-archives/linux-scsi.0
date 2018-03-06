From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.16-rc4
Date: Tue, 06 Mar 2018 12:54:10 -0800
Message-ID: <1520369650.19117.0.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch is mostly fixes for driver specific issues (nine of them)
and the storvsc performance improvement with interrupt handling which
was dropped from the previous fixes pull request.  We also have two
regressions: one is a double call_rcu() in ATA error handling and the
other is a missed conversion to BLK_STS_OK in
__scsi_error_from_host_byte().

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: core: Avoid that ATA error handling can trigger a kernel hang or oops

Darren Trapp (1):
      scsi: qla2xxx: Fix FC-NVMe LUN discovery

Hannes Reinecke (4):
      scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()
      scsi: qla2xxx: ensure async flags are reset correctly
      scsi: qla2xxx: do not check login_state if no loop id is assigned
      scsi: qla2xxx: Fixup locking for session deletion

Manish Rangankar (1):
      scsi: qedi: Fix kernel crash during port toggle

Mauricio Faria de Oliveira (1):
      scsi: mpt3sas: fix oops in error handlers after shutdown/unload

Michael Kelley (EOSG) (1):
      scsi: storvsc: Spread interrupts when picking a channel for I/O requests

Shivasharan S (1):
      scsi: megaraid_sas: Do not use 32-bit atomic request descriptor for Ventura controllers

Sreekanth Reddy (1):
      scsi: mpt3sas: wait for and flush running commands on shutdown/unload

himanshu.madhani@cavium.com (1):
      scsi: qla2xxx: Fix NULL pointer crash due to active timer for ABTS

And the diffstat:

 drivers/scsi/hosts.c                        |  3 --
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 42 ++++++++----------------
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  8 ++---
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  3 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 21 +++++++++---
 drivers/scsi/qedi/qedi_fw.c                 |  5 +++
 drivers/scsi/qla2xxx/qla_def.h              |  5 +--
 drivers/scsi/qla2xxx/qla_gs.c               |  5 +++
 drivers/scsi/qla2xxx/qla_init.c             | 51 ++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c               | 14 ++++++--
 drivers/scsi/qla2xxx/qla_target.c           | 17 ++++------
 drivers/scsi/scsi_error.c                   |  5 +--
 drivers/scsi/scsi_lib.c                     |  4 +++
 drivers/scsi/storvsc_drv.c                  |  3 +-
 include/scsi/scsi_cmnd.h                    |  3 ++
 include/scsi/scsi_host.h                    |  2 --
 16 files changed, 115 insertions(+), 76 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 57bf43e34863..dd9464920456 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -328,8 +328,6 @@ static void scsi_host_dev_release(struct device *dev)
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
-	destroy_rcu_head(&shost->rcu);
-
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
 		 * Free the shost_dev device name here if scsi_host_alloc()
@@ -404,7 +402,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
-	init_rcu_head(&shost->rcu);
 
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
 	if (index < 0)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 073ced07e662..dc8e850fbfd2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -216,36 +216,30 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 /**
  * megasas_fire_cmd_fusion -	Sends command to the FW
  * @instance:			Adapter soft state
- * @req_desc:			32bit or 64bit Request descriptor
+ * @req_desc:			64bit Request descriptor
  *
- * Perform PCI Write. Ventura supports 32 bit Descriptor.
- * Prior to Ventura (12G) MR controller supports 64 bit Descriptor.
+ * Perform PCI Write.
  */
 
 static void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
 		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
 {
-	if (instance->adapter_type == VENTURA_SERIES)
-		writel(le32_to_cpu(req_desc->u.low),
-			&instance->reg_set->inbound_single_queue_port);
-	else {
 #if defined(writeq) && defined(CONFIG_64BIT)
-		u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
-				le32_to_cpu(req_desc->u.low));
+	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
+		le32_to_cpu(req_desc->u.low));
 
-		writeq(req_data, &instance->reg_set->inbound_low_queue_port);
+	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
 #else
-		unsigned long flags;
-		spin_lock_irqsave(&instance->hba_lock, flags);
-		writel(le32_to_cpu(req_desc->u.low),
-			&instance->reg_set->inbound_low_queue_port);
-		writel(le32_to_cpu(req_desc->u.high),
-			&instance->reg_set->inbound_high_queue_port);
-		mmiowb();
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
+	unsigned long flags;
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	writel(le32_to_cpu(req_desc->u.low),
+		&instance->reg_set->inbound_low_queue_port);
+	writel(le32_to_cpu(req_desc->u.high),
+		&instance->reg_set->inbound_high_queue_port);
+	mmiowb();
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
 #endif
-	}
 }
 
 /**
@@ -982,7 +976,6 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	const char *sys_info;
 	MFI_CAPABILITIES *drv_ops;
 	u32 scratch_pad_2;
-	unsigned long flags;
 	ktime_t time;
 	bool cur_fw_64bit_dma_capable;
 
@@ -1121,14 +1114,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	/* For Ventura also IOC INIT required 64 bit Descriptor write. */
-	spin_lock_irqsave(&instance->hba_lock, flags);
-	writel(le32_to_cpu(req_desc.u.low),
-	       &instance->reg_set->inbound_low_queue_port);
-	writel(le32_to_cpu(req_desc.u.high),
-	       &instance->reg_set->inbound_high_queue_port);
-	mmiowb();
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
+	megasas_fire_cmd_fusion(instance, &req_desc);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59a87ca328d3..0aafbfd1b746 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6297,14 +6297,14 @@ _base_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
 }
 
 /**
- * _wait_for_commands_to_complete - reset controller
+ * mpt3sas_wait_for_commands_to_complete - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
  *
  * This function is waiting 10s for all pending commands to complete
  * prior to putting controller in reset.
  */
-static void
-_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
 
@@ -6377,7 +6377,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 			is_fault = 1;
 	}
 	_base_reset_handler(ioc, MPT3_IOC_PRE_RESET);
-	_wait_for_commands_to_complete(ioc);
+	mpt3sas_wait_for_commands_to_complete(ioc);
 	_base_mask_interrupts(ioc);
 	r = _base_make_ioc_ready(ioc, type);
 	if (r)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 789bc421424b..99ccf83b8c51 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1433,6 +1433,9 @@ void mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 
 int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
 
+void
+mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc);
+
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 74fca184dba9..c2ea13c7e37e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2835,7 +2835,8 @@ scsih_abort(struct scsi_cmnd *scmd)
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -2898,7 +2899,8 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -2961,7 +2963,8 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		starget_printk(KERN_INFO, starget, "target been deleted! scmd(%p)\n",
 			scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3019,7 +3022,7 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	    ioc->name, scmd);
 	scsi_print_command(scmd);
 
-	if (ioc->is_driver_loading) {
+	if (ioc->is_driver_loading || ioc->remove_host) {
 		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
 		    ioc->name);
 		r = FAILED;
@@ -4453,7 +4456,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		st = scsi_cmd_priv(scmd);
 		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
-		if (ioc->pci_error_recovery)
+		if (ioc->pci_error_recovery || ioc->remove_host)
 			scmd->result = DID_NO_CONNECT << 16;
 		else
 			scmd->result = DID_RESET << 16;
@@ -9739,6 +9742,10 @@ static void scsih_remove(struct pci_dev *pdev)
 	unsigned long flags;
 
 	ioc->remove_host = 1;
+
+	mpt3sas_wait_for_commands_to_complete(ioc);
+	_scsih_flush_running_cmds(ioc);
+
 	_scsih_fw_event_cleanup_queue(ioc);
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
@@ -9815,6 +9822,10 @@ scsih_shutdown(struct pci_dev *pdev)
 	unsigned long flags;
 
 	ioc->remove_host = 1;
+
+	mpt3sas_wait_for_commands_to_complete(ioc);
+	_scsih_flush_running_cmds(ioc);
+
 	_scsih_fw_event_cleanup_queue(ioc);
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 20a9259304f2..03c772c223fa 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -761,6 +761,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 	iscsi_cid = cqe->conn_id;
 	qedi_conn = qedi->cid_que.conn_cid_tbl[iscsi_cid];
+	if (!qedi_conn) {
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "icid not found 0x%x\n", cqe->conn_id);
+		return;
+	}
 
 	/* Based on this itt get the corresponding qedi_cmd */
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index be7d6824581a..c9689f97c307 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -261,9 +261,9 @@
 struct name_list_extended {
 	struct get_name_list_extended *l;
 	dma_addr_t		ldma;
-	struct list_head 	fcports;	/* protect by sess_list */
+	struct list_head	fcports;
+	spinlock_t		fcports_lock;
 	u32			size;
-	u8			sent;
 };
 /*
  * Timeout timer counts in seconds
@@ -2217,6 +2217,7 @@ typedef struct {
 
 /* FCP-4 types */
 #define FC4_TYPE_FCP_SCSI	0x08
+#define FC4_TYPE_NVME		0x28
 #define FC4_TYPE_OTHER		0x0
 #define FC4_TYPE_UNKNOWN	0xff
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5bf9a59432f6..403fa096f8c8 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3179,6 +3179,7 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->free(sp);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
@@ -3370,6 +3371,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->free(sp);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
@@ -3971,6 +3973,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
 	spin_unlock_irqrestore(&vha->work_lock, flags);
+
+	if ((fc4type == FC4_TYPE_FCP_SCSI) && vha->flags.nvme_enabled)
+		qla24xx_async_gpnft(vha, FC4_TYPE_NVME);
 }
 
 static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2dea1129d396..00329dda6179 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -213,6 +213,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	sp->free(sp);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
@@ -263,7 +264,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 done_free_sp:
 	sp->free(sp);
 done:
-	fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	return rval;
 }
 
@@ -271,6 +272,7 @@ void
 qla2x00_async_prlo_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	/* Don't re-login in target mode */
 	if (!fcport->tgt_session)
 		qla2x00_mark_device_lost(vha, fcport, 1, 0);
@@ -284,6 +286,7 @@ qla2x00_async_prlo_sp_done(void *s, int res)
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	struct scsi_qla_host *vha = sp->vha;
 
+	sp->fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
 		qla2x00_post_async_prlo_done_work(sp->fcport->vha, sp->fcport,
 		    lio->u.logio.data);
@@ -322,6 +325,7 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 done_free_sp:
 	sp->free(sp);
 done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
@@ -375,6 +379,8 @@ qla2x00_async_adisc_sp_done(void *ptr, int res)
 	    "Async done-%s res %x %8phC\n",
 	    sp->name, res, sp->fcport->port_name);
 
+	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+
 	memset(&ea, 0, sizeof(ea));
 	ea.event = FCME_ADISC_DONE;
 	ea.rc = res;
@@ -425,7 +431,7 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 done_free_sp:
 	sp->free(sp);
 done:
-	fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	qla2x00_post_async_adisc_work(vha, fcport, data);
 	return rval;
 }
@@ -643,8 +649,7 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 		    (loop_id & 0x7fff));
 	}
 
-	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	vha->gnl.sent = 0;
+	spin_lock_irqsave(&vha->gnl.fcports_lock, flags);
 
 	INIT_LIST_HEAD(&h);
 	fcport = tf = NULL;
@@ -653,12 +658,16 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 
 	list_for_each_entry_safe(fcport, tf, &h, gnl_entry) {
 		list_del_init(&fcport->gnl_entry);
+		spin_lock(&vha->hw->tgt.sess_lock);
 		fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+		spin_unlock(&vha->hw->tgt.sess_lock);
 		ea.fcport = fcport;
 
 		qla2x00_fcport_event_handler(vha, &ea);
 	}
+	spin_unlock_irqrestore(&vha->gnl.fcports_lock, flags);
 
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	/* create new fcport if fw has knowledge of new sessions */
 	for (i = 0; i < n; i++) {
 		port_id_t id;
@@ -710,18 +719,21 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
 
-	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	spin_lock_irqsave(&vha->gnl.fcports_lock, flags);
+	if (!list_empty(&fcport->gnl_entry)) {
+		spin_unlock_irqrestore(&vha->gnl.fcports_lock, flags);
+		rval = QLA_SUCCESS;
+		goto done;
+	}
+
+	spin_lock(&vha->hw->tgt.sess_lock);
 	fcport->disc_state = DSC_GNL;
 	fcport->last_rscn_gen = fcport->rscn_gen;
 	fcport->last_login_gen = fcport->login_gen;
+	spin_unlock(&vha->hw->tgt.sess_lock);
 
 	list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports);
-	if (vha->gnl.sent) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		return QLA_SUCCESS;
-	}
-	vha->gnl.sent = 1;
-	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	spin_unlock_irqrestore(&vha->gnl.fcports_lock, flags);
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -1049,6 +1061,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fc_port_t *fcport = ea->fcport;
 	struct port_database_24xx *pd;
 	struct srb *sp = ea->sp;
+	uint8_t	ls;
 
 	pd = (struct port_database_24xx *)sp->u.iocb_cmd.u.mbx.in;
 
@@ -1061,7 +1074,12 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
 
-	switch (pd->current_login_state) {
+	if (fcport->fc4f_nvme)
+		ls = pd->current_login_state >> 4;
+	else
+		ls = pd->current_login_state & 0xf;
+
+	switch (ls) {
 	case PDS_PRLI_COMPLETE:
 		__qla24xx_parse_gpdb(vha, fcport, pd);
 		break;
@@ -1151,8 +1169,9 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (fcport->scan_state != QLA_FCPORT_FOUND)
 		return 0;
 
-	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
+	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
+	    ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
+	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
 		return 0;
 
 	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
@@ -1527,6 +1546,7 @@ qla24xx_abort_sp_done(void *ptr, int res)
 	srb_t *sp = ptr;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
+	del_timer(&sp->u.iocb_cmd.timer);
 	complete(&abt->u.abt.comp);
 }
 
@@ -1791,6 +1811,7 @@ qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	qla2x00_mark_device_lost(vha, fcport, 1, 0);
 	qlt_logo_completion_handler(fcport, data[0]);
 	fcport->login_gen++;
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return;
 }
 
@@ -1798,6 +1819,7 @@ void
 qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	if (data[0] == MBS_COMMAND_COMPLETE) {
 		qla2x00_update_fcport(vha, fcport);
 
@@ -1805,7 +1827,6 @@ qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	}
 
 	/* Retry login. */
-	fcport->flags &= ~FCF_ASYNC_SENT;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 	else
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index afcb5567998a..285911e81728 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4577,6 +4577,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
+	spin_lock_init(&vha->gnl.fcports_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
 	init_waitqueue_head(&vha->vref_waitq);
 
@@ -4806,9 +4807,12 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			fcport->d_id = e->u.new_sess.id;
 			fcport->flags |= FCF_FABRIC_DEVICE;
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
-			if (e->u.new_sess.fc4_type == FC4_TYPE_FCP_SCSI)
+			if (e->u.new_sess.fc4_type == FC4_TYPE_FCP_SCSI) {
 				fcport->fc4_type = FC4_TYPE_FCP_SCSI;
-
+			} else if (e->u.new_sess.fc4_type == FC4_TYPE_NVME) {
+				fcport->fc4_type = FC4_TYPE_OTHER;
+				fcport->fc4f_nvme = FC4_TYPE_NVME;
+			}
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
 		} else {
@@ -4877,6 +4881,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			}
 			qlt_plogi_ack_unref(vha, pla);
 		} else {
+			fc_port_t *dfcp = NULL;
+
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			tfcp = qla2x00_find_fcport_by_nportid(vha,
 			    &e->u.new_sess.id, 1);
@@ -4899,11 +4905,13 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 				default:
 					fcport->login_pause = 1;
 					tfcp->conflict = fcport;
-					qlt_schedule_sess_for_deletion(tfcp);
+					dfcp = tfcp;
 					break;
 				}
 			}
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+			if (dfcp)
+				qlt_schedule_sess_for_deletion(tfcp);
 
 			wwn = wwn_to_u64(fcport->node_name);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 896b2d8bd803..b49ac85f3de2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1224,10 +1224,10 @@ static void qla24xx_chk_fcp_state(struct fc_port *sess)
 	}
 }
 
-/* ha->tgt.sess_lock supposed to be held on entry */
 void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
+	struct qla_hw_data *ha = sess->vha->hw;
 	unsigned long flags;
 
 	if (sess->disc_state == DSC_DELETE_PEND)
@@ -1244,16 +1244,16 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 			return;
 	}
 
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	if (sess->deleted == QLA_SESS_DELETED)
 		sess->logout_on_delete = 0;
 
-	spin_lock_irqsave(&sess->vha->work_lock, flags);
 	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
-		spin_unlock_irqrestore(&sess->vha->work_lock, flags);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return;
 	}
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	sess->disc_state = DSC_DELETE_PEND;
 
@@ -1262,13 +1262,10 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion\n", sess);
 
-	/* use cancel to push work element through before re-queue */
-	cancel_work_sync(&sess->del_work);
 	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
-	queue_work(sess->vha->hw->wq, &sess->del_work);
+	WARN_ON(!queue_work(sess->vha->hw->wq, &sess->del_work));
 }
 
-/* ha->tgt.sess_lock supposed to be held on entry */
 static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 {
 	struct fc_port *sess;
@@ -1451,8 +1448,8 @@ qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
 
 	sess->local = 1;
-	qlt_schedule_sess_for_deletion(sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	qlt_schedule_sess_for_deletion(sess);
 }
 
 static inline int test_tgt_sess_count(struct qla_tgt *tgt)
@@ -1512,10 +1509,8 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	 * Lock is needed, because we still can get an incoming packet.
 	 */
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	tgt->tgt_stop = 1;
 	qlt_clear_tgt_db(tgt);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 	mutex_unlock(&qla_tgt_mutex);
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d042915ce895..ca53a5f785ee 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -223,7 +223,8 @@ static void scsi_eh_reset(struct scsi_cmnd *scmd)
 
 static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
-	struct Scsi_Host *shost = container_of(head, typeof(*shost), rcu);
+	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
+	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -259,7 +260,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	 * Ensure that all tasks observe the host state change before the
 	 * host_failed change.
 	 */
-	call_rcu(&shost->rcu, scsi_eh_inc_host_failed);
+	call_rcu(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5cbc69b2b1ae..c9844043504e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -670,6 +670,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	if (!blk_rq_is_scsi(req)) {
 		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
 		cmd->flags &= ~SCMD_INITIALIZED;
+		destroy_rcu_head(&cmd->rcu);
 	}
 
 	if (req->mq_ctx) {
@@ -719,6 +720,8 @@ static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
 		int result)
 {
 	switch (host_byte(result)) {
+	case DID_OK:
+		return BLK_STS_OK;
 	case DID_TRANSPORT_FAILFAST:
 		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
@@ -1150,6 +1153,7 @@ static void scsi_initialize_rq(struct request *rq)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	scsi_req_init(&cmd->req);
+	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
 }
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8eadb30115aa..620510787763 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1310,7 +1310,8 @@ static int storvsc_do_io(struct hv_device *device,
 			 */
 			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
 				    cpumask_of_node(cpu_to_node(q_num)));
-			for_each_cpu(tgt_cpu, &alloced_mask) {
+			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
+					outgoing_channel->target_cpu + 1) {
 				if (tgt_cpu != outgoing_channel->target_cpu) {
 					outgoing_channel =
 					stor_device->stor_chns[tgt_cpu];
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 949a016dd7fa..0382ceab2eba 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -69,6 +69,9 @@ struct scsi_cmnd {
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
 	struct delayed_work abort_work;
+
+	struct rcu_head rcu;
+
 	int eh_eflags;		/* Used by error handlr */
 
 	/*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 1a1df0d21ee3..a8b7bf879ced 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -571,8 +571,6 @@ struct Scsi_Host {
 		struct blk_mq_tag_set	tag_set;
 	};
 
-	struct rcu_head rcu;
-
 	atomic_t host_busy;		   /* commands actually active on low-level */
 	atomic_t host_blocked;
 
