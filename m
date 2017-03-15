From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.11-rc2
Date: Wed, 15 Mar 2017 10:11:50 -0700
Message-ID: <1489597910.2387.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a rather large set of fixes.  The bulk are for lpfc correcting
a lot of issues in the new NVME driver code which just went in in the
merge window.  The others are: fix a hang in the vmware paravirt driver
caused by incorrect handling of the new MSI vector allocation.  A long
standing bug in storvsc, which recent block changes turned from being a
harmless annoyance into a hang and yet more fallout (in mpt3sas) from
the changes to device blocking.  The remainder are small fixes and
updates.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anton Blanchard (1):
      scsi: lpfc: Add shutdown method for kexec

Arnd Bergmann (1):
      scsi: qedi: fix build error without DEBUG_FS

Bart Van Assche (1):
      scsi: mpt3sas: Avoid sleeping in interrupt context

Chris Leech (1):
      scsi: libiscsi: add lock around task lists to fix list corruption regression

Christoph Hellwig (1):
      scsi: vmw_pvscsi: handle the return value from pci_alloc_irq_vectors correctly

Colin Ian King (1):
      scsi: qedi: fix missing return error code check on call to qedi_setup_int

Damien Le Moal (1):
      scsi: sd: Check for unaligned partial completion

James Smart (20):
      scsi: lpfc: revise version number to 11.2.0.10
      scsi: lpfc: code cleanups in NVME initiator discovery
      scsi: lpfc: code cleanups in NVME initiator base
      scsi: lpfc: correct rdp diag portnames
      scsi: lpfc: remove dead sli3 nvme code
      scsi: lpfc: correct double print
      scsi: lpfc: Rename LPFC_MAX_EQ_DELAY to LPFC_MAX_EQ_DELAY_EQID_CNT
      scsi: lpfc: Rework lpfc Kconfig for NVME options
      scsi: lpfc: add transport eh_timed_out reference
      scsi: lpfc: Fix eh_deadline setting for sli3 adapters.
      scsi: lpfc: add NVME exchange aborts
      scsi: lpfc: Fix nvme allocation bug on failed nvme_fc_register_localport
      scsi: lpfc: Fix IO submission if WQ is full
      scsi: lpfc: Fix NVME CMD IU byte swapped word 1 problem
      scsi: lpfc: Fix RCTL value on NVME LS request and response
      scsi: lpfc: Fix crash during Hardware error recovery on SLI3 adapters
      scsi: lpfc: fix missing spin_unlock on sql_list_lock
      scsi: lpfc: don't dereference dma_buf->iocbq before null check
      scsi: lpfc: sanity check hrq is null before dereferencing it
      scsi: lpfc: remove redundant assignment of sgel

Joe Perches (3):
      scsi: qedf: Use vsprintf extension %pad
      scsi: qedf: Fix defective logging format and argument mismatches
      scsi: qla2xxx: Fix ql_dump_buffer

Potomski, MichalX (1):
      scsi: ufs: Factor out ufshcd_read_desc_param

Raghava Aditya Renukunta (1):
      scsi: aacraid: Fix typo in blink status

Stephen Hemminger (1):
      scsi: storvsc: Workaround for virtual DVD SCSI version

Tomas Jasek (1):
      scsi: lpfc: replace init_timer by setup_timer

And the diffstat:

 drivers/scsi/Kconfig                 |  19 ++-
 drivers/scsi/aacraid/src.c           |   2 +-
 drivers/scsi/libiscsi.c              |  26 +++-
 drivers/scsi/lpfc/lpfc.h             |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c        |   9 +-
 drivers/scsi/lpfc/lpfc_crtn.h        |   4 +-
 drivers/scsi/lpfc/lpfc_ct.c          |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c     |  22 ----
 drivers/scsi/lpfc/lpfc_els.c         |  22 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c     |  24 ++--
 drivers/scsi/lpfc/lpfc_hw4.h         |   4 +-
 drivers/scsi/lpfc/lpfc_init.c        | 128 ++++++++++++-------
 drivers/scsi/lpfc/lpfc_mem.c         |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c        | 107 ++++++++++++----
 drivers/scsi/lpfc/lpfc_nvme.h        |   1 +
 drivers/scsi/lpfc/lpfc_nvmet.c       |  43 +++++--
 drivers/scsi/lpfc/lpfc_scsi.c        |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c         |  68 +++++++++--
 drivers/scsi/lpfc/lpfc_sli4.h        |   6 +
 drivers/scsi/lpfc/lpfc_version.h     |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   3 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  19 +--
 drivers/scsi/qedf/qedf_dbg.h         |  13 +-
 drivers/scsi/qedf/qedf_fip.c         |   2 +-
 drivers/scsi/qedf/qedf_io.c          |   4 +-
 drivers/scsi/qedf/qedf_main.c        |   4 +-
 drivers/scsi/qedi/qedi_debugfs.c     |  16 +--
 drivers/scsi/qedi/qedi_fw.c          |   4 +-
 drivers/scsi/qedi/qedi_gbl.h         |   8 +-
 drivers/scsi/qedi/qedi_iscsi.c       |   8 +-
 drivers/scsi/qedi/qedi_main.c        |   2 +-
 drivers/scsi/qla2xxx/qla_dbg.c       |  12 +-
 drivers/scsi/scsi_lib.c              |  14 ++-
 drivers/scsi/scsi_priv.h             |   3 -
 drivers/scsi/sd.c                    |  17 +++
 drivers/scsi/storvsc_drv.c           |  27 ++--
 drivers/scsi/ufs/ufs.h               |  22 ++--
 drivers/scsi/ufs/ufshcd.c            | 231 ++++++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd.h            |  15 +++
 drivers/scsi/vmw_pvscsi.c            |   2 +-
 include/scsi/libiscsi.h              |   1 +
 include/scsi/scsi_device.h           |   4 +
 42 files changed, 645 insertions(+), 285 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 230043c..4bf55b5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1241,19 +1241,32 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
-	depends on NVME_FC && NVME_TARGET_FC
 	select CRC_T10DIF
-	help
+	---help---
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
 
 config SCSI_LPFC_DEBUG_FS
 	bool "Emulex LightPulse Fibre Channel debugfs Support"
 	depends on SCSI_LPFC && DEBUG_FS
-	help
+	---help---
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+config LPFC_NVME_INITIATOR
+	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
+	depends on SCSI_LPFC && NVME_FC
+	---help---
+	  This enables NVME Initiator support in the Emulex lpfc driver.
+
+config LPFC_NVME_TARGET
+	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
+	depends on SCSI_LPFC && NVME_TARGET_FC
+	---help---
+	  This enables NVME Target support in the Emulex lpfc driver.
+	  Target enablement must still be enabled on a per adapter
+	  basis by module parameters.
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 2e5338d..7b0410e 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -468,7 +468,7 @@ static int aac_src_check_health(struct aac_dev *dev)
 	return -1;
 
 err_blink:
-	return (status > 16) & 0xFF;
+	return (status >> 16) & 0xFF;
 }
 
 static inline u32 aac_get_vector(struct aac_dev *dev)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 07c08ce..894b1e3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -561,8 +561,12 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
 
-	if (!list_empty(&task->running))
+	spin_lock_bh(&conn->taskqueuelock);
+	if (!list_empty(&task->running)) {
+		pr_debug_once("%s while task on list", __func__);
 		list_del_init(&task->running);
+	}
+	spin_unlock_bh(&conn->taskqueuelock);
 
 	if (conn->task == task)
 		conn->task = NULL;
@@ -784,7 +788,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (session->tt->xmit_task(task))
 			goto free_task;
 	} else {
+		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->mgmtqueue);
+		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -1475,8 +1481,10 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	 * this may be on the requeue list already if the xmit_task callout
 	 * is handling the r2ts while we are adding new ones
 	 */
+	spin_lock_bh(&conn->taskqueuelock);
 	if (list_empty(&task->running))
 		list_add_tail(&task->running, &conn->requeue);
+	spin_unlock_bh(&conn->taskqueuelock);
 	iscsi_conn_queue_work(conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1513,22 +1521,26 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 * only have one nop-out as a ping from us and targets should not
 	 * overflow us with nop-ins
 	 */
+	spin_lock_bh(&conn->taskqueuelock);
 check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
 		conn->task = list_entry(conn->mgmtqueue.next,
 					 struct iscsi_task, running);
 		list_del_init(&conn->task->running);
+		spin_unlock_bh(&conn->taskqueuelock);
 		if (iscsi_prep_mgmt_task(conn, conn->task)) {
 			/* regular RX path uses back_lock */
 			spin_lock_bh(&conn->session->back_lock);
 			__iscsi_put_task(conn->task);
 			spin_unlock_bh(&conn->session->back_lock);
 			conn->task = NULL;
+			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto done;
+		spin_lock_bh(&conn->taskqueuelock);
 	}
 
 	/* process pending command queue */
@@ -1536,19 +1548,24 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
 					running);
 		list_del_init(&conn->task->running);
+		spin_unlock_bh(&conn->taskqueuelock);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
 			fail_scsi_task(conn->task, DID_IMM_RETRY);
+			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
 			if (rc == -ENOMEM || rc == -EACCES) {
+				spin_lock_bh(&conn->taskqueuelock);
 				list_add_tail(&conn->task->running,
 					      &conn->cmdqueue);
 				conn->task = NULL;
+				spin_unlock_bh(&conn->taskqueuelock);
 				goto done;
 			} else
 				fail_scsi_task(conn->task, DID_ABORT);
+			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
@@ -1559,6 +1576,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		 * we need to check the mgmt queue for nops that need to
 		 * be sent to aviod starvation
 		 */
+		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
@@ -1578,12 +1596,15 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		conn->task = task;
 		list_del_init(&conn->task->running);
 		conn->task->state = ISCSI_TASK_RUNNING;
+		spin_unlock_bh(&conn->taskqueuelock);
 		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto done;
+		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
+	spin_unlock_bh(&conn->taskqueuelock);
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
@@ -1739,7 +1760,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			goto prepd_reject;
 		}
 	} else {
+		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->cmdqueue);
+		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -2897,6 +2920,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->cmdqueue);
 	INIT_LIST_HEAD(&conn->requeue);
+	spin_lock_init(&conn->taskqueuelock);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 0bba2e3..257bbdd 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -99,12 +99,13 @@ struct lpfc_sli2_slim;
 #define FC_MAX_ADPTMSG		64
 
 #define MAX_HBAEVT	32
+#define MAX_HBAS_NO_RESET 16
 
 /* Number of MSI-X vectors the driver uses */
 #define LPFC_MSIX_VECTORS	2
 
 /* lpfc wait event data ready flag */
-#define LPFC_DATA_READY		(1<<0)
+#define LPFC_DATA_READY		0	/* bit 0 */
 
 /* queue dump line buffer size */
 #define LPFC_LBUF_SZ		128
@@ -692,6 +693,7 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_NVME_IOQ_FLUSH      0x80000 /* NVME IO queues flushed. */
+#define NVME_XRI_ABORT_EVENT	0x100000
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 5c783ef..5c3be3e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3010,6 +3010,12 @@ MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
 static DEVICE_ATTR(lpfc_poll, S_IRUGO | S_IWUSR,
 		   lpfc_poll_show, lpfc_poll_store);
 
+int lpfc_no_hba_reset_cnt;
+unsigned long lpfc_no_hba_reset[MAX_HBAS_NO_RESET] = {
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+module_param_array(lpfc_no_hba_reset, ulong, &lpfc_no_hba_reset_cnt, 0444);
+MODULE_PARM_DESC(lpfc_no_hba_reset, "WWPN of HBAs that should not be reset");
+
 LPFC_ATTR(sli_mode, 0, 0, 3,
 	"SLI mode selector:"
 	" 0 - auto (SLI-3 if supported),"
@@ -4451,7 +4457,8 @@ lpfc_fcp_imax_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	phba->cfg_fcp_imax = (uint32_t)val;
-	for (i = 0; i < phba->io_channel_irqs; i++)
+
+	for (i = 0; i < phba->io_channel_irqs; i += LPFC_MAX_EQ_DELAY_EQID_CNT)
 		lpfc_modify_hba_eq_delay(phba, i);
 
 	return strlen(buf);
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 843dd73..54e6ac4 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -384,7 +384,7 @@ void lpfc_free_sysfs_attr(struct lpfc_vport *);
 extern struct device_attribute *lpfc_hba_attrs[];
 extern struct device_attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
-extern struct scsi_host_template lpfc_template_s3;
+extern struct scsi_host_template lpfc_template_no_hr;
 extern struct scsi_host_template lpfc_template_nvme;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
@@ -554,3 +554,5 @@ void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
 				struct lpfc_wcqe_complete *abts_cmpl);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
+extern int lpfc_no_hba_reset_cnt;
+extern unsigned long lpfc_no_hba_reset[];
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c22bb3f..d3e9af9 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -939,8 +939,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 "FC4 x%08x, Data: x%08x x%08x\n",
 					 ndlp, did, ndlp->nlp_fc4_type,
 					 FC_TYPE_FCP, FC_TYPE_NVME);
+			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		}
-		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 9f4798e..913eed82 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3653,17 +3653,6 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
 			goto pass_check;
 		}
-		/* NVME LS complete queue */
-		if (phba->sli4_hba.nvmels_cq &&
-		    phba->sli4_hba.nvmels_cq->queue_id == queid) {
-			/* Sanity check */
-			rc = lpfc_idiag_que_param_check(
-					phba->sli4_hba.nvmels_cq, index, count);
-			if (rc)
-				goto error_out;
-			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
-			goto pass_check;
-		}
 		/* FCP complete queue */
 		if (phba->sli4_hba.fcp_cq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
@@ -3738,17 +3727,6 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
 			goto pass_check;
 		}
-		/* NVME LS work queue */
-		if (phba->sli4_hba.nvmels_wq &&
-		    phba->sli4_hba.nvmels_wq->queue_id == queid) {
-			/* Sanity check */
-			rc = lpfc_idiag_que_param_check(
-					phba->sli4_hba.nvmels_wq, index, count);
-			if (rc)
-				goto error_out;
-			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
-			goto pass_check;
-		}
 		/* FCP work queue */
 		if (phba->sli4_hba.fcp_wq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2d26440..d9c61d0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5177,15 +5177,15 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 static uint32_t
 lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
-		struct lpfc_hba *phba)
+		struct lpfc_vport *vport)
 {
 
 	desc->tag = cpu_to_be32(RDP_PORT_NAMES_DESC_TAG);
 
-	memcpy(desc->port_names.wwnn, phba->wwnn,
+	memcpy(desc->port_names.wwnn, &vport->fc_nodename,
 			sizeof(desc->port_names.wwnn));
 
-	memcpy(desc->port_names.wwpn, phba->wwpn,
+	memcpy(desc->port_names.wwpn, &vport->fc_portname,
 			sizeof(desc->port_names.wwpn));
 
 	desc->length = cpu_to_be32(sizeof(desc->port_names));
@@ -5279,7 +5279,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	len += lpfc_rdp_res_link_error((struct fc_rdp_link_error_status_desc *)
 				       (len + pcmd), &rdp_context->link_stat);
 	len += lpfc_rdp_res_diag_port_names((struct fc_rdp_port_name_desc *)
-					     (len + pcmd), phba);
+					     (len + pcmd), vport);
 	len += lpfc_rdp_res_attach_port_names((struct fc_rdp_port_name_desc *)
 					(len + pcmd), vport, ndlp);
 	len += lpfc_rdp_res_fec_desc((struct fc_fec_rdp_desc *)(len + pcmd),
@@ -8371,11 +8371,17 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			spin_unlock_irq(shost->host_lock);
-			if (vport->port_type == LPFC_PHYSICAL_PORT
-				&& !(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG))
-				lpfc_issue_init_vfi(vport);
-			else
+			if (mb->mbxStatus == MBX_NOT_FINISHED)
+				break;
+			if ((vport->port_type == LPFC_PHYSICAL_PORT) &&
+			    !(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG)) {
+				if (phba->sli_rev == LPFC_SLI_REV4)
+					lpfc_issue_init_vfi(vport);
+				else
+					lpfc_initial_flogi(vport);
+			} else {
 				lpfc_initial_fdisc(vport);
+			}
 			break;
 		}
 	} else {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 194a14d..180b072 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -313,8 +313,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	if (!(vport->load_flag & FC_UNLOADING) &&
-	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
+	if (!(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
 	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) &&
@@ -641,6 +640,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 			lpfc_handle_rrq_active(phba);
 		if (phba->hba_flag & FCP_XRI_ABORT_EVENT)
 			lpfc_sli4_fcp_xri_abort_event_proc(phba);
+		if (phba->hba_flag & NVME_XRI_ABORT_EVENT)
+			lpfc_sli4_nvme_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ELS_XRI_ABORT_EVENT)
 			lpfc_sli4_els_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ASYNC_EVENT)
@@ -2173,7 +2174,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint32_t boot_flag, addr_mode;
 	uint16_t fcf_index, next_fcf_index;
 	struct lpfc_fcf_rec *fcf_rec = NULL;
-	uint16_t vlan_id;
+	uint16_t vlan_id = LPFC_FCOE_NULL_VID;
 	bool select_new_fcf;
 	int rc;
 
@@ -4020,9 +4021,11 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		rdata = rport->dd_data;
 		/* break the link before dropping the ref */
 		ndlp->rport = NULL;
-		if (rdata && rdata->pnode == ndlp)
-			lpfc_nlp_put(ndlp);
-		rdata->pnode = NULL;
+		if (rdata) {
+			if (rdata->pnode == ndlp)
+				lpfc_nlp_put(ndlp);
+			rdata->pnode = NULL;
+		}
 		/* drop reference for earlier registeration */
 		put_device(&rport->dev);
 	}
@@ -4344,9 +4347,8 @@ lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
 	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
-	init_timer(&ndlp->nlp_delayfunc);
-	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
-	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
+	setup_timer(&ndlp->nlp_delayfunc, lpfc_els_retry_delay,
+			(unsigned long)ndlp);
 	ndlp->nlp_DID = did;
 	ndlp->vport = vport;
 	ndlp->phba = vport->phba;
@@ -4606,9 +4608,9 @@ lpfc_sli4_dequeue_nport_iocbs(struct lpfc_hba *phba,
 		pring = qp->pring;
 		if (!pring)
 			continue;
-		spin_lock_irq(&pring->ring_lock);
+		spin_lock(&pring->ring_lock);
 		__lpfc_dequeue_nport_iocbs(phba, ndlp, pring, dequeue_list);
-		spin_unlock_irq(&pring->ring_lock);
+		spin_unlock(&pring->ring_lock);
 	}
 	spin_unlock_irq(&phba->hbalock);
 }
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index cfdb068..1527770 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1001,7 +1001,7 @@ struct eq_delay_info {
 	uint32_t phase;
 	uint32_t delay_multi;
 };
-#define	LPFC_MAX_EQ_DELAY	8
+#define	LPFC_MAX_EQ_DELAY_EQID_CNT	8
 
 struct sgl_page_pairs {
 	uint32_t sgl_pg0_addr_lo;
@@ -1070,7 +1070,7 @@ struct lpfc_mbx_modify_eq_delay {
 	union {
 		struct {
 			uint32_t num_eq;
-			struct eq_delay_info eq[LPFC_MAX_EQ_DELAY];
+			struct eq_delay_info eq[LPFC_MAX_EQ_DELAY_EQID_CNT];
 		} request;
 		struct {
 			uint32_t word0;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0ee429d..2697d49 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3555,6 +3555,44 @@ lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba)
 	return rc;
 }
 
+static uint64_t
+lpfc_get_wwpn(struct lpfc_hba *phba)
+{
+	uint64_t wwn;
+	int rc;
+	LPFC_MBOXQ_t *mboxq;
+	MAILBOX_t *mb;
+
+
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+						GFP_KERNEL);
+	if (!mboxq)
+		return (uint64_t)-1;
+
+	/* First get WWN of HBA instance */
+	lpfc_read_nv(phba, mboxq);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"6019 Mailbox failed , mbxCmd x%x "
+				"READ_NV, mbxStatus x%x\n",
+				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return (uint64_t) -1;
+	}
+	mb = &mboxq->u.mb;
+	memcpy(&wwn, (char *)mb->un.varRDnvp.portname, sizeof(uint64_t));
+	/* wwn is WWPN of HBA instance */
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return be64_to_cpu(wwn);
+	else
+		return (((wwn & 0xffffffff00000000) >> 32) |
+			((wwn & 0x00000000ffffffff) << 32));
+
+}
+
 /**
  * lpfc_sli4_nvme_sgl_update - update xri-sgl sizing and mapping
  * @phba: pointer to lpfc hba data structure.
@@ -3676,17 +3714,32 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	struct lpfc_vport *vport;
 	struct Scsi_Host  *shost = NULL;
 	int error = 0;
+	int i;
+	uint64_t wwn;
+	bool use_no_reset_hba = false;
+
+	wwn = lpfc_get_wwpn(phba);
+
+	for (i = 0; i < lpfc_no_hba_reset_cnt; i++) {
+		if (wwn == lpfc_no_hba_reset[i]) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"6020 Setting use_no_reset port=%llx\n",
+					wwn);
+			use_no_reset_hba = true;
+			break;
+		}
+	}
 
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
 		if (dev != &phba->pcidev->dev) {
 			shost = scsi_host_alloc(&lpfc_vport_template,
 						sizeof(struct lpfc_vport));
 		} else {
-			if (phba->sli_rev == LPFC_SLI_REV4)
+			if (!use_no_reset_hba)
 				shost = scsi_host_alloc(&lpfc_template,
 						sizeof(struct lpfc_vport));
 			else
-				shost = scsi_host_alloc(&lpfc_template_s3,
+				shost = scsi_host_alloc(&lpfc_template_no_hr,
 						sizeof(struct lpfc_vport));
 		}
 	} else if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
@@ -3734,17 +3787,14 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	INIT_LIST_HEAD(&vport->rcv_buffer_list);
 	spin_lock_init(&vport->work_port_lock);
 
-	init_timer(&vport->fc_disctmo);
-	vport->fc_disctmo.function = lpfc_disc_timeout;
-	vport->fc_disctmo.data = (unsigned long)vport;
+	setup_timer(&vport->fc_disctmo, lpfc_disc_timeout,
+			(unsigned long)vport);
 
-	init_timer(&vport->els_tmofunc);
-	vport->els_tmofunc.function = lpfc_els_timeout;
-	vport->els_tmofunc.data = (unsigned long)vport;
+	setup_timer(&vport->els_tmofunc, lpfc_els_timeout,
+			(unsigned long)vport);
 
-	init_timer(&vport->delayed_disc_tmo);
-	vport->delayed_disc_tmo.function = lpfc_delayed_disc_tmo;
-	vport->delayed_disc_tmo.data = (unsigned long)vport;
+	setup_timer(&vport->delayed_disc_tmo, lpfc_delayed_disc_tmo,
+			(unsigned long)vport);
 
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
@@ -5406,21 +5456,15 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->luns);
 
 	/* MBOX heartbeat timer */
-	init_timer(&psli->mbox_tmo);
-	psli->mbox_tmo.function = lpfc_mbox_timeout;
-	psli->mbox_tmo.data = (unsigned long) phba;
+	setup_timer(&psli->mbox_tmo, lpfc_mbox_timeout, (unsigned long)phba);
 	/* Fabric block timer */
-	init_timer(&phba->fabric_block_timer);
-	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
-	phba->fabric_block_timer.data = (unsigned long) phba;
+	setup_timer(&phba->fabric_block_timer, lpfc_fabric_block_timeout,
+			(unsigned long)phba);
 	/* EA polling mode timer */
-	init_timer(&phba->eratt_poll);
-	phba->eratt_poll.function = lpfc_poll_eratt;
-	phba->eratt_poll.data = (unsigned long) phba;
+	setup_timer(&phba->eratt_poll, lpfc_poll_eratt,
+			(unsigned long)phba);
 	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
+	setup_timer(&phba->hb_tmofunc, lpfc_hb_timeout, (unsigned long)phba);
 
 	return 0;
 }
@@ -5446,9 +5490,8 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	 */
 
 	/* FCP polling mode timer */
-	init_timer(&phba->fcp_poll_timer);
-	phba->fcp_poll_timer.function = lpfc_poll_timeout;
-	phba->fcp_poll_timer.data = (unsigned long) phba;
+	setup_timer(&phba->fcp_poll_timer, lpfc_poll_timeout,
+			(unsigned long)phba);
 
 	/* Host attention work mask setup */
 	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
@@ -5482,7 +5525,8 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* Initialize the host templates the configured values. */
 	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-	lpfc_template_s3.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_template_no_hr.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
 
 	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
 	if (phba->cfg_enable_bg) {
@@ -5617,14 +5661,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize timers used by driver
 	 */
 
-	init_timer(&phba->rrq_tmr);
-	phba->rrq_tmr.function = lpfc_rrq_timeout;
-	phba->rrq_tmr.data = (unsigned long)phba;
+	setup_timer(&phba->rrq_tmr, lpfc_rrq_timeout, (unsigned long)phba);
 
 	/* FCF rediscover timer */
-	init_timer(&phba->fcf.redisc_wait);
-	phba->fcf.redisc_wait.function = lpfc_sli4_fcf_redisc_wait_tmo;
-	phba->fcf.redisc_wait.data = (unsigned long)phba;
+	setup_timer(&phba->fcf.redisc_wait, lpfc_sli4_fcf_redisc_wait_tmo,
+			(unsigned long)phba);
 
 	/*
 	 * Control structure for handling external multi-buffer mailbox
@@ -5706,6 +5747,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* Initialize the host templates with the updated values. */
 	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
 	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_template_no_hr.sg_tablesize = phba->cfg_sg_seg_cnt;
 
 	if (phba->cfg_sg_dma_buf_size  <= LPFC_MIN_SG_SLI4_BUF_SZ)
 		phba->cfg_sg_dma_buf_size = LPFC_MIN_SG_SLI4_BUF_SZ;
@@ -5736,6 +5778,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		/* Initialize the Abort nvme buffer list used by driver */
 		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+		/* Fast-path XRI aborted CQ Event work queue list */
+		INIT_LIST_HEAD(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
 	}
 
 	/* This abort list used by worker thread */
@@ -8712,12 +8756,9 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		}
 	}
 
-	/*
-	 * Configure EQ delay multipier for interrupt coalescing using
-	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
-	 */
-	for (qidx = 0; qidx < io_channel; qidx += LPFC_MAX_EQ_DELAY)
+	for (qidx = 0; qidx < io_channel; qidx += LPFC_MAX_EQ_DELAY_EQID_CNT)
 		lpfc_modify_hba_eq_delay(phba, qidx);
+
 	return 0;
 
 out_destroy:
@@ -8973,6 +9014,11 @@ lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
 	/* Pending ELS XRI abort events */
 	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
 			 &cqelist);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Pending NVME XRI abort events */
+		list_splice_init(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue,
+				 &cqelist);
+	}
 	/* Pending asynnc events */
 	list_splice_init(&phba->sli4_hba.sp_asynce_work_queue,
 			 &cqelist);
@@ -10400,12 +10446,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 
-	/* Perform ndlp cleanup on the physical port.  The nvme and nvmet
-	 * localports are destroyed after to cleanup all transport memory.
-	 */
 	lpfc_cleanup(vport);
-	lpfc_nvmet_destroy_targetport(phba);
-	lpfc_nvme_destroy_localport(vport);
 
 	/*
 	 * Bring down the SLI Layer. This step disable all interrupts,
@@ -12018,6 +12059,7 @@ static struct pci_driver lpfc_driver = {
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= lpfc_pci_remove_one,
+	.shutdown	= lpfc_pci_remove_one,
 	.suspend        = lpfc_pci_suspend_one,
 	.resume		= lpfc_pci_resume_one,
 	.err_handler    = &lpfc_err_handler,
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index c61d8d6..5986c79 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -646,7 +646,6 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 	}
 
 	dma_buf->iocbq = lpfc_sli_get_iocbq(phba);
-	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
 	if (!dma_buf->iocbq) {
 		kfree(dma_buf->context);
 		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
@@ -658,6 +657,7 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 				"2621 Ran out of nvmet iocb/WQEs\n");
 		return NULL;
 	}
+	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
 	nvmewqe = dma_buf->iocbq;
 	wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
 	/* Initialize WQE */
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 609a908..0a4c190 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -316,7 +316,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	bf_set(wqe_dfctl, &wqe->gen_req.wge_ctl, 0);
 	bf_set(wqe_si, &wqe->gen_req.wge_ctl, 1);
 	bf_set(wqe_la, &wqe->gen_req.wge_ctl, 1);
-	bf_set(wqe_rctl, &wqe->gen_req.wge_ctl, FC_RCTL_DD_UNSOL_CTL);
+	bf_set(wqe_rctl, &wqe->gen_req.wge_ctl, FC_RCTL_ELS4_REQ);
 	bf_set(wqe_type, &wqe->gen_req.wge_ctl, FC_TYPE_NVME);
 
 	/* Word 6 */
@@ -620,15 +620,15 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 	 * Embed the payload in the last half of the WQE
 	 * WQE words 16-30 get the NVME CMD IU payload
 	 *
-	 * WQE Word 16 is already setup with flags
-	 * WQE words 17-19 get payload Words 2-4
+	 * WQE words 16-19 get payload Words 1-4
 	 * WQE words 20-21 get payload Words 6-7
 	 * WQE words 22-29 get payload Words 16-23
 	 */
-	wptr = &wqe->words[17];  /* WQE ptr */
+	wptr = &wqe->words[16];  /* WQE ptr */
 	dptr = (uint32_t *)nCmd->cmdaddr;  /* payload ptr */
-	dptr += 2;		/* Skip Words 0-1 in payload */
+	dptr++;			/* Skip Word 0 in payload */
 
+	*wptr++ = *dptr++;	/* Word 1 */
 	*wptr++ = *dptr++;	/* Word 2 */
 	*wptr++ = *dptr++;	/* Word 3 */
 	*wptr++ = *dptr++;	/* Word 4 */
@@ -978,9 +978,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			bf_set(wqe_cmd_type, &wqe->generic.wqe_com,
 			       NVME_WRITE_CMD);
 
-			/* Word 16 */
-			wqe->words[16] = LPFC_NVME_EMBED_WRITE;
-
 			phba->fc4NvmeOutputRequests++;
 		} else {
 			/* Word 7 */
@@ -1002,9 +999,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			bf_set(wqe_cmd_type, &wqe->generic.wqe_com,
 			       NVME_READ_CMD);
 
-			/* Word 16 */
-			wqe->words[16] = LPFC_NVME_EMBED_READ;
-
 			phba->fc4NvmeInputRequests++;
 		}
 	} else {
@@ -1026,9 +1020,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		/* Word 11 */
 		bf_set(wqe_cmd_type, &wqe->generic.wqe_com, NVME_READ_CMD);
 
-		/* Word 16 */
-		wqe->words[16] = LPFC_NVME_EMBED_CMD;
-
 		phba->fc4NvmeControlRequests++;
 	}
 	/*
@@ -1286,6 +1277,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	pnvme_fcreq->private = (void *)lpfc_ncmd;
 	lpfc_ncmd->nvmeCmd = pnvme_fcreq;
 	lpfc_ncmd->nrport = rport;
+	lpfc_ncmd->ndlp = ndlp;
 	lpfc_ncmd->start_time = jiffies;
 
 	lpfc_nvme_prep_io_cmd(vport, lpfc_ncmd, ndlp);
@@ -1319,7 +1311,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 				 "sid: x%x did: x%x oxid: x%x\n",
 				 ret, vport->fc_myDID, ndlp->nlp_DID,
 				 lpfc_ncmd->cur_iocbq.sli4_xritag);
-		ret = -EINVAL;
+		ret = -EBUSY;
 		goto out_free_nvme_buf;
 	}
 
@@ -1821,10 +1813,10 @@ lpfc_post_nvme_sgl_list(struct lpfc_hba *phba,
 						pdma_phys_sgl1, cur_xritag);
 				if (status) {
 					/* failure, put on abort nvme list */
-					lpfc_ncmd->exch_busy = 1;
+					lpfc_ncmd->flags |= LPFC_SBUF_XBUSY;
 				} else {
 					/* success, put on NVME buffer list */
-					lpfc_ncmd->exch_busy = 0;
+					lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
 					lpfc_ncmd->status = IOSTAT_SUCCESS;
 					num_posted++;
 				}
@@ -1854,10 +1846,10 @@ lpfc_post_nvme_sgl_list(struct lpfc_hba *phba,
 					 struct lpfc_nvme_buf, list);
 			if (status) {
 				/* failure, put on abort nvme list */
-				lpfc_ncmd->exch_busy = 1;
+				lpfc_ncmd->flags |= LPFC_SBUF_XBUSY;
 			} else {
 				/* success, put on NVME buffer list */
-				lpfc_ncmd->exch_busy = 0;
+				lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
 				lpfc_ncmd->status = IOSTAT_SUCCESS;
 				num_posted++;
 			}
@@ -2099,7 +2091,7 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_nvme_buf *lpfc_ncmd)
 	unsigned long iflag = 0;
 
 	lpfc_ncmd->nonsg_phys = 0;
-	if (lpfc_ncmd->exch_busy) {
+	if (lpfc_ncmd->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_nvme_buf_list_lock,
 					iflag);
 		lpfc_ncmd->nvmeCmd = NULL;
@@ -2135,11 +2127,12 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_nvme_buf *lpfc_ncmd)
 int
 lpfc_nvme_create_localport(struct lpfc_vport *vport)
 {
+	int ret = 0;
 	struct lpfc_hba  *phba = vport->phba;
 	struct nvme_fc_port_info nfcp_info;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
-	int len, ret = 0;
+	int len;
 
 	/* Initialize this localport instance.  The vport wwn usage ensures
 	 * that NPIV is accounted for.
@@ -2156,8 +2149,12 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	ret = nvme_fc_register_localport(&nfcp_info, &lpfc_nvme_template,
 					 &vport->phba->pcidev->dev, &localport);
+#else
+	ret = -ENOMEM;
+#endif
 	if (!ret) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME | LOG_NVME_DISC,
 				 "6005 Successfully registered local "
@@ -2173,10 +2170,10 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 		lport->vport = vport;
 		INIT_LIST_HEAD(&lport->rport_list);
 		vport->nvmei_support = 1;
+		len  = lpfc_new_nvme_buf(vport, phba->sli4_hba.nvme_xri_max);
+		vport->phba->total_nvme_bufs += len;
 	}
 
-	len  = lpfc_new_nvme_buf(vport, phba->sli4_hba.nvme_xri_max);
-	vport->phba->total_nvme_bufs += len;
 	return ret;
 }
 
@@ -2193,6 +2190,7 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport = NULL, *rport_next = NULL;
@@ -2208,7 +2206,6 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
 			 "6011 Destroying NVME localport %p\n",
 			 localport);
-
 	list_for_each_entry_safe(rport, rport_next, &lport->rport_list, list) {
 		/* The last node ref has to get released now before the rport
 		 * private memory area is released by the transport.
@@ -2222,6 +2219,7 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 					 "6008 rport fail destroy %x\n", ret);
 		wait_for_completion_timeout(&rport->rport_unreg_done, 5);
 	}
+
 	/* lport's rport list is clear.  Unregister
 	 * lport and release resources.
 	 */
@@ -2245,6 +2243,7 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 				 "Failed, status x%x\n",
 				 ret);
 	}
+#endif
 }
 
 void
@@ -2275,6 +2274,7 @@ lpfc_nvme_update_localport(struct lpfc_vport *vport)
 int
 lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	int ret = 0;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
@@ -2348,7 +2348,6 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			rpinfo.port_role |= FC_PORT_ROLE_NVME_INITIATOR;
 		rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 		rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
-
 		ret = nvme_fc_register_remoteport(localport, &rpinfo,
 						  &remote_port);
 		if (!ret) {
@@ -2384,6 +2383,9 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_type, ndlp->nlp_DID, ndlp);
 	}
 	return ret;
+#else
+	return 0;
+#endif
 }
 
 /* lpfc_nvme_unregister_port - unbind the DID and port_role from this rport.
@@ -2401,6 +2403,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 void
 lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	int ret;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
@@ -2458,7 +2461,61 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	return;
 
  input_err:
+#endif
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
 			 "6168: State error: lport %p, rport%p FCID x%06x\n",
 			 vport->localport, ndlp->rport, ndlp->nlp_DID);
 }
+
+/**
+ * lpfc_sli4_nvme_xri_aborted - Fast-path process of NVME xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @axri: pointer to the fcp xri abort wcqe structure.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 fast-path
+ * FCP aborted xri.
+ **/
+void
+lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
+			   struct sli4_wcqe_xri_aborted *axri)
+{
+	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
+	struct lpfc_nvme_buf *lpfc_ncmd, *next_lpfc_ncmd;
+	struct lpfc_nodelist *ndlp;
+	unsigned long iflag = 0;
+	int rrq_empty = 0;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return;
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	list_for_each_entry_safe(lpfc_ncmd, next_lpfc_ncmd,
+				 &phba->sli4_hba.lpfc_abts_nvme_buf_list,
+				 list) {
+		if (lpfc_ncmd->cur_iocbq.sli4_xritag == xri) {
+			list_del(&lpfc_ncmd->list);
+			lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
+			lpfc_ncmd->status = IOSTAT_SUCCESS;
+			spin_unlock(
+				&phba->sli4_hba.abts_nvme_buf_list_lock);
+
+			rrq_empty = list_empty(&phba->active_rrq_list);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			ndlp = lpfc_ncmd->ndlp;
+			if (ndlp) {
+				lpfc_set_rrq_active(
+					phba, ndlp,
+					lpfc_ncmd->cur_iocbq.sli4_lxritag,
+					rxid, 1);
+				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
+			}
+			lpfc_release_nvme_buf(phba, lpfc_ncmd);
+			if (rrq_empty)
+				lpfc_worker_wake_up(phba);
+			return;
+		}
+	}
+	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index b2fae5e..1347deb 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -57,6 +57,7 @@ struct lpfc_nvme_buf {
 	struct list_head list;
 	struct nvmefc_fcp_req *nvmeCmd;
 	struct lpfc_nvme_rport *nrport;
+	struct lpfc_nodelist *ndlp;
 
 	uint32_t timeout;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c421e17..b7739a5 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -571,6 +571,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 				"6102 Bad state IO x%x aborted\n",
 				ctxp->oxid);
+		rc = -ENXIO;
 		goto aerr;
 	}
 
@@ -580,6 +581,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 				"6152 FCP Drop IO x%x: Prep\n",
 				ctxp->oxid);
+		rc = -ENXIO;
 		goto aerr;
 	}
 
@@ -618,8 +620,9 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	ctxp->wqeq->hba_wqidx = 0;
 	nvmewqeq->context2 = NULL;
 	nvmewqeq->context3 = NULL;
+	rc = -EBUSY;
 aerr:
-	return -ENXIO;
+	return rc;
 }
 
 static void
@@ -668,9 +671,13 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED;
 
+#ifdef CONFIG_LPFC_NVME_TARGET
 	error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
 					     &phba->pcidev->dev,
 					     &phba->targetport);
+#else
+	error = -ENOMEM;
+#endif
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
 				"6025 Cannot register NVME targetport "
@@ -731,9 +738,25 @@ lpfc_nvmet_update_targetport(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_sli4_nvmet_xri_aborted - Fast-path process of nvmet xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @axri: pointer to the nvmet xri abort wcqe structure.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 fast-path
+ * NVMET aborted xri.
+ **/
+void
+lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
+			    struct sli4_wcqe_xri_aborted *axri)
+{
+	/* TODO: work in progress */
+}
+
 void
 lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 {
+#ifdef CONFIG_LPFC_NVME_TARGET
 	struct lpfc_nvmet_tgtport *tgtp;
 
 	if (phba->nvmet_support == 0)
@@ -745,6 +768,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		wait_for_completion_timeout(&tgtp->tport_unreg_done, 5);
 	}
 	phba->targetport = NULL;
+#endif
 }
 
 /**
@@ -764,6 +788,7 @@ static void
 lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			   struct hbq_dmabuf *nvmebuf)
 {
+#ifdef CONFIG_LPFC_NVME_TARGET
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_nvmet_rcv_ctx *ctxp;
@@ -844,6 +869,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	atomic_inc(&tgtp->xmt_ls_abort);
 	lpfc_nvmet_unsol_ls_issue_abort(phba, ctxp, sid, oxid);
+#endif
 }
 
 /**
@@ -865,6 +891,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 			    struct rqb_dmabuf *nvmebuf,
 			    uint64_t isr_timestamp)
 {
+#ifdef CONFIG_LPFC_NVME_TARGET
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
@@ -955,7 +982,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 
 	atomic_inc(&tgtp->rcv_fcp_cmd_drop);
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-			"6159 FCP Drop IO x%x: nvmet_fc_rcv_fcp_req x%x\n",
+			"6159 FCP Drop IO x%x: err x%x\n",
 			ctxp->oxid, rc);
 dropit:
 	lpfc_nvmeio_data(phba, "NVMET FCP DROP: xri x%x sz %d from %06x\n",
@@ -970,6 +997,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 		/* We assume a rcv'ed cmd ALWAYs fits into 1 buffer */
 		lpfc_nvmet_rq_post(phba, NULL, &nvmebuf->hbuf);
 	}
+#endif
 }
 
 /**
@@ -1114,7 +1142,7 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	bf_set(wqe_dfctl, &wqe->xmit_sequence.wge_ctl, 0);
 	bf_set(wqe_ls, &wqe->xmit_sequence.wge_ctl, 1);
 	bf_set(wqe_la, &wqe->xmit_sequence.wge_ctl, 0);
-	bf_set(wqe_rctl, &wqe->xmit_sequence.wge_ctl, FC_RCTL_DD_SOL_CTL);
+	bf_set(wqe_rctl, &wqe->xmit_sequence.wge_ctl, FC_RCTL_ELS4_REP);
 	bf_set(wqe_type, &wqe->xmit_sequence.wge_ctl, FC_TYPE_NVME);
 
 	/* Word 6 */
@@ -1445,7 +1473,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 
 	case NVMET_FCOP_RSP:
 		/* Words 0 - 2 */
-		sgel = &rsp->sg[0];
 		physaddr = rsp->rspdma;
 		wqe->fcp_trsp.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 		wqe->fcp_trsp.bde.tus.f.bdeSize = rsp->rsplen;
@@ -1681,8 +1708,8 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	struct lpfc_nodelist *ndlp;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6067 %s: Entrypoint: sid %x xri %x\n", __func__,
-			sid, xri);
+			"6067 Abort: sid %x xri x%x/x%x\n",
+			sid, xri, ctxp->wqeq->sli4_xritag);
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 
@@ -1693,7 +1720,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
 				"6134 Drop ABTS - wrong NDLP state x%x.\n",
-				ndlp->nlp_state);
+				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
 		/* No failure to an ABTS request. */
 		return 0;
@@ -1791,7 +1818,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
 				"6160 Drop ABTS - wrong NDLP state x%x.\n",
-				ndlp->nlp_state);
+				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
 		/* No failure to an ABTS request. */
 		return 0;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 9d6384a..54fd0c8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5953,12 +5953,13 @@ struct scsi_host_template lpfc_template_nvme = {
 	.track_queue_depth	= 0,
 };
 
-struct scsi_host_template lpfc_template_s3 = {
+struct scsi_host_template lpfc_template_no_hr = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
 	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
+	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
@@ -6015,7 +6016,6 @@ struct scsi_host_template lpfc_vport_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e43e5e2..1c9fa45 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,3 +1,4 @@
+
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
@@ -952,7 +953,7 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	start_sglq = sglq;
 	while (!found) {
 		if (!sglq)
-			return NULL;
+			break;
 		if (ndlp && ndlp->active_rrqs_xri_bitmap &&
 		    test_bit(sglq->sli4_lxritag,
 		    ndlp->active_rrqs_xri_bitmap)) {
@@ -12213,6 +12214,41 @@ void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli4_nvme_xri_abort_event_proc - Process nvme xri abort event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked by the worker thread to process all the pending
+ * SLI4 NVME abort XRI events.
+ **/
+void lpfc_sli4_nvme_xri_abort_event_proc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+
+	/* First, declare the fcp xri abort event has been handled */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~NVME_XRI_ABORT_EVENT;
+	spin_unlock_irq(&phba->hbalock);
+	/* Now, handle all the fcp xri abort events */
+	while (!list_empty(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue)) {
+		/* Get the first event from the head of the event queue */
+		spin_lock_irq(&phba->hbalock);
+		list_remove_head(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue,
+				 cq_event, struct lpfc_cq_event, list);
+		spin_unlock_irq(&phba->hbalock);
+		/* Notify aborted XRI for NVME work queue */
+		if (phba->nvmet_support) {
+			lpfc_sli4_nvmet_xri_aborted(phba,
+						    &cq_event->cqe.wcqe_axri);
+		} else {
+			lpfc_sli4_nvme_xri_aborted(phba,
+						   &cq_event->cqe.wcqe_axri);
+		}
+		/* Free the event processed back to the free pool */
+		lpfc_sli4_cq_event_release(phba, cq_event);
+	}
+}
+
+/**
  * lpfc_sli4_els_xri_abort_event_proc - Process els xri abort event
  * @phba: pointer to lpfc hba data structure.
  *
@@ -12709,10 +12745,22 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
+	case LPFC_NVME:
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		list_add_tail(&cq_event->list,
+			      &phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
+		/* Set the nvme xri abort event flag */
+		phba->hba_flag |= NVME_XRI_ABORT_EVENT;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0603 Invalid work queue CQE subtype (x%x)\n",
-				cq->subtype);
+				"0603 Invalid CQ subtype %d: "
+				"%08x %08x %08x %08x\n",
+				cq->subtype, wcqe->word0, wcqe->parameter,
+				wcqe->word2, wcqe->word3);
+		lpfc_sli4_cq_event_release(phba, cq_event);
 		workposted = false;
 		break;
 	}
@@ -13827,6 +13875,8 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * @startq: The starting FCP EQ to modify
  *
  * This function sends an MODIFY_EQ_DELAY mailbox command to the HBA.
+ * The command allows up to LPFC_MAX_EQ_DELAY_EQID_CNT EQ ID's to be
+ * updated in one mailbox command.
  *
  * The @phba struct is used to send mailbox command to HBA. The @startq
  * is used to get the starting FCP EQ to change.
@@ -13879,7 +13929,7 @@ lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 		eq_delay->u.request.eq[cnt].phase = 0;
 		eq_delay->u.request.eq[cnt].delay_multi = dmult;
 		cnt++;
-		if (cnt >= LPFC_MAX_EQ_DELAY)
+		if (cnt >= LPFC_MAX_EQ_DELAY_EQID_CNT)
 			break;
 	}
 	eq_delay->u.request.num_eq = cnt;
@@ -15185,17 +15235,17 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 		drq = drqp[idx];
 		cq  = cqp[idx];
 
-		if (hrq->entry_count != drq->entry_count) {
-			status = -EINVAL;
-			goto out;
-		}
-
 		/* sanity check on queue memory */
 		if (!hrq || !drq || !cq) {
 			status = -ENODEV;
 			goto out;
 		}
 
+		if (hrq->entry_count != drq->entry_count) {
+			status = -EINVAL;
+			goto out;
+		}
+
 		if (idx == 0) {
 			bf_set(lpfc_mbx_rq_create_num_pages,
 			       &rq_create->u.request,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 91153c9..710458c 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -642,6 +642,7 @@ struct lpfc_sli4_hba {
 	struct list_head sp_asynce_work_queue;
 	struct list_head sp_fcp_xri_aborted_work_queue;
 	struct list_head sp_els_xri_aborted_work_queue;
+	struct list_head sp_nvme_xri_aborted_work_queue;
 	struct list_head sp_unsol_work_queue;
 	struct lpfc_sli4_link link_state;
 	struct lpfc_sli4_lnk_info lnk_info;
@@ -794,9 +795,14 @@ void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
 			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
 void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
+void lpfc_sli4_nvme_xri_abort_event_proc(struct lpfc_hba *phba);
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
 void lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *,
 			       struct sli4_wcqe_xri_aborted *);
+void lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
+				struct sli4_wcqe_xri_aborted *axri);
+void lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
+				 struct sli4_wcqe_xri_aborted *axri);
 void lpfc_sli4_els_xri_aborted(struct lpfc_hba *,
 			       struct sli4_wcqe_xri_aborted *);
 void lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 86c6c9b..d4e95e2 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.7"
+#define LPFC_DRIVER_VERSION "11.2.0.10"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 7fe7e6e..8981806f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1442,9 +1442,6 @@ void mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt3sas_transport_functions;
 extern struct scsi_transport_template *mpt3sas_transport_template;
-extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev,
-				enum scsi_device_state new_state);
 /* trigger data externs */
 void mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 46e866c..919ba2b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2859,7 +2859,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
 
-	r = scsi_internal_device_block(sdev);
+	r = scsi_internal_device_block(sdev, false);
 	if (r == -EINVAL)
 		sdev_printk(KERN_WARNING, sdev,
 		    "device_block failed with return(%d) for handle(0x%04x)\n",
@@ -2895,7 +2895,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 		    "performing a block followed by an unblock\n",
 		    r, sas_device_priv_data->sas_target->handle);
 		sas_device_priv_data->block = 1;
-		r = scsi_internal_device_block(sdev);
+		r = scsi_internal_device_block(sdev, false);
 		if (r)
 			sdev_printk(KERN_WARNING, sdev, "retried device_block "
 			    "failed with return(%d) for handle(0x%04x)\n",
@@ -4677,7 +4677,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 	unsigned long flags;
-	unsigned int sector_sz;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 
@@ -4742,20 +4741,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
-
-	/* In case of bogus fw or device, we could end up having
-	 * unaligned partial completion. We can force alignment here,
-	 * then scsi-ml does not need to handle this misbehavior.
-	 */
-	sector_sz = scmd->device->sector_size;
-	if (unlikely(!blk_rq_is_passthrough(scmd->request) && sector_sz &&
-		     xfer_cnt % sector_sz)) {
-		sdev_printk(KERN_INFO, scmd->device,
-		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
-			    xfer_cnt, sector_sz);
-		xfer_cnt = round_down(xfer_cnt, sector_sz);
-	}
-
 	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
 		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h
index 23bd706..7d173f48 100644
--- a/drivers/scsi/qedf/qedf_dbg.h
+++ b/drivers/scsi/qedf/qedf_dbg.h
@@ -81,14 +81,17 @@ struct qedf_dbg_ctx {
 #define QEDF_INFO(pdev, level, fmt, ...)	\
 		qedf_dbg_info(pdev, __func__, __LINE__, level, fmt,	\
 			      ## __VA_ARGS__)
-
-extern void qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
+__printf(4, 5)
+void qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 			  const char *fmt, ...);
-extern void qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
+__printf(4, 5)
+void qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 			   const char *, ...);
-extern void qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func,
+__printf(4, 5)
+void qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func,
 			    u32 line, const char *, ...);
-extern void qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
+__printf(5, 6)
+void qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 			  u32 info, const char *fmt, ...);
 
 /* GRC Dump related defines */
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index 868d423..ed58b91 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -203,7 +203,7 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 			case FIP_DT_MAC:
 				mp = (struct fip_mac_desc *)desc;
 				QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
-				    "fd_mac=%pM.\n", __func__, mp->fd_mac);
+				    "fd_mac=%pM\n", mp->fd_mac);
 				ether_addr_copy(cvl_mac, mp->fd_mac);
 				break;
 			case FIP_DT_NAME:
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index ee0dcf9..46debe5 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1342,7 +1342,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		} else {
 			refcount = kref_read(&io_req->refcount);
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
-			    "%d:0:%d:%d xid=0x%0x op=0x%02x "
+			    "%d:0:%d:%lld xid=0x%0x op=0x%02x "
 			    "lba=%02x%02x%02x%02x cdb_status=%d "
 			    "fcp_resid=0x%x refcount=%d.\n",
 			    qedf->lport->host->host_no, sc_cmd->device->id,
@@ -1426,7 +1426,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 
 	sc_cmd->result = result << 16;
 	refcount = kref_read(&io_req->refcount);
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%d: Completing "
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%lld: Completing "
 	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
 	    "allowed=%d retries=%d refcount=%d.\n",
 	    qedf->lport->host->host_no, sc_cmd->device->id,
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d9d7a86..8e2a160 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2456,8 +2456,8 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	}
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-	    "BDQ PBL addr=0x%p dma=0x%llx.\n", qedf->bdq_pbl,
-	    qedf->bdq_pbl_dma);
+		  "BDQ PBL addr=0x%p dma=%pad\n",
+		  qedf->bdq_pbl, &qedf->bdq_pbl_dma);
 
 	/*
 	 * Populate BDQ PBL with physical and virtual address of individual
diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index 9559362..5941719 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -14,7 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/module.h>
 
-int do_not_recover;
+int qedi_do_not_recover;
 static struct dentry *qedi_dbg_root;
 
 void
@@ -74,22 +74,22 @@ qedi_dbg_exit(void)
 static ssize_t
 qedi_dbg_do_not_recover_enable(struct qedi_dbg_ctx *qedi_dbg)
 {
-	if (!do_not_recover)
-		do_not_recover = 1;
+	if (!qedi_do_not_recover)
+		qedi_do_not_recover = 1;
 
 	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=%d\n",
-		  do_not_recover);
+		  qedi_do_not_recover);
 	return 0;
 }
 
 static ssize_t
 qedi_dbg_do_not_recover_disable(struct qedi_dbg_ctx *qedi_dbg)
 {
-	if (do_not_recover)
-		do_not_recover = 0;
+	if (qedi_do_not_recover)
+		qedi_do_not_recover = 0;
 
 	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=%d\n",
-		  do_not_recover);
+		  qedi_do_not_recover);
 	return 0;
 }
 
@@ -141,7 +141,7 @@ qedi_dbg_do_not_recover_cmd_read(struct file *filp, char __user *buffer,
 	if (*ppos)
 		return 0;
 
-	cnt = sprintf(buffer, "do_not_recover=%d\n", do_not_recover);
+	cnt = sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover);
 	cnt = min_t(int, count, cnt - *ppos);
 	*ppos += cnt;
 	return cnt;
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c9f0ef4..2bce3ef 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1461,9 +1461,9 @@ static void qedi_tmf_work(struct work_struct *work)
 		  get_itt(tmf_hdr->rtt), get_itt(ctask->itt), cmd->task_id,
 		  qedi_conn->iscsi_conn_id);
 
-	if (do_not_recover) {
+	if (qedi_do_not_recover) {
 		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
-			 do_not_recover);
+			 qedi_do_not_recover);
 		goto abort_ret;
 	}
 
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 8e488de..63d793f 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -12,8 +12,14 @@
 
 #include "qedi_iscsi.h"
 
+#ifdef CONFIG_DEBUG_FS
+extern int qedi_do_not_recover;
+#else
+#define qedi_do_not_recover (0)
+#endif
+
 extern uint qedi_io_tracing;
-extern int do_not_recover;
+
 extern struct scsi_host_template qedi_host_template;
 extern struct iscsi_transport qedi_iscsi_transport;
 extern const struct qed_iscsi_ops *qedi_ops;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index b9f79d3..4cc4743 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -833,7 +833,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		return ERR_PTR(ret);
 	}
 
-	if (do_not_recover) {
+	if (qedi_do_not_recover) {
 		ret = -ENOMEM;
 		return ERR_PTR(ret);
 	}
@@ -957,7 +957,7 @@ static int qedi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	struct qedi_endpoint *qedi_ep;
 	int ret = 0;
 
-	if (do_not_recover)
+	if (qedi_do_not_recover)
 		return 1;
 
 	qedi_ep = ep->dd_data;
@@ -1025,7 +1025,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		}
 
 		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
-			if (do_not_recover) {
+			if (qedi_do_not_recover) {
 				QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 					  "Do not recover cid=0x%x\n",
 					  qedi_ep->iscsi_cid);
@@ -1039,7 +1039,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		}
 	}
 
-	if (do_not_recover)
+	if (qedi_do_not_recover)
 		goto ep_exit_recover;
 
 	switch (qedi_ep->state) {
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 5eda21d..8e3d928 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1805,7 +1805,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	 */
 	qedi_ops->common->update_pf_params(qedi->cdev, &qedi->pf_params);
 
-	qedi_setup_int(qedi);
+	rc = qedi_setup_int(qedi);
 	if (rc)
 		goto stop_iscsi_func;
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 21d9fb7..51b4179 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2707,13 +2707,9 @@ ql_dump_buffer(uint32_t level, scsi_qla_host_t *vha, int32_t id,
 	    "%-+5d  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n", size);
 	ql_dbg(level, vha, id,
 	    "----- -----------------------------------------------\n");
-	for (cnt = 0; cnt < size; cnt++, buf++) {
-		if (cnt % 16 == 0)
-			ql_dbg(level, vha, id, "%04x:", cnt & ~0xFU);
-		printk(" %02x", *buf);
-		if (cnt % 16 == 15)
-			printk("\n");
+	for (cnt = 0; cnt < size; cnt += 16) {
+		ql_dbg(level, vha, id, "%04x: ", cnt);
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
+			       buf + cnt, min(16U, size - cnt), false);
 	}
-	if (cnt % 16 != 0)
-		printk("\n");
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba22866..19125d7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2932,6 +2932,8 @@ EXPORT_SYMBOL(scsi_target_resume);
 /**
  * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
  * @sdev:	device to block
+ * @wait:	Whether or not to wait until ongoing .queuecommand() /
+ *		.queue_rq() calls have finished.
  *
  * Block request made by scsi lld's to temporarily stop all
  * scsi commands on the specified device. May sleep.
@@ -2949,7 +2951,7 @@ EXPORT_SYMBOL(scsi_target_resume);
  * remove the rport mutex lock and unlock calls from srp_queuecommand().
  */
 int
-scsi_internal_device_block(struct scsi_device *sdev)
+scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 {
 	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
@@ -2969,12 +2971,16 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	 * request queue. 
 	 */
 	if (q->mq_ops) {
-		blk_mq_quiesce_queue(q);
+		if (wait)
+			blk_mq_quiesce_queue(q);
+		else
+			blk_mq_stop_hw_queues(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_wait_for_queuecommand(sdev);
+		if (wait)
+			scsi_wait_for_queuecommand(sdev);
 	}
 
 	return 0;
@@ -3036,7 +3042,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
 static void
 device_block(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_block(sdev);
+	scsi_internal_device_block(sdev, true);
 }
 
 static int
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 99bfc98..f11bd10 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -188,8 +188,5 @@ static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
  */
 
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
-extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev,
-					enum scsi_device_state new_state);
 
 #endif /* _SCSI_PRIV_H */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7839f6..fb9b4d2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1783,6 +1783,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
+	unsigned int sector_size = SCpnt->device->sector_size;
+	unsigned int resid;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	struct request *req = SCpnt->request;
@@ -1813,6 +1815,21 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
 		break;
+	default:
+		/*
+		 * In case of bogus fw or device, we could end up having
+		 * an unaligned partial completion. Check this here and force
+		 * alignment.
+		 */
+		resid = scsi_get_resid(SCpnt);
+		if (resid & (sector_size - 1)) {
+			sd_printk(KERN_INFO, sdkp,
+				"Unaligned partial completion (resid=%u, sector_sz=%u)\n",
+				resid, sector_size);
+			resid = min(scsi_bufflen(SCpnt),
+				    round_up(resid, sector_size));
+			scsi_set_resid(SCpnt, resid);
+		}
 	}
 
 	if (result) {
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 638e5f4..016639d 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -400,8 +400,6 @@ MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to subchannels")
  */
 static int storvsc_timeout = 180;
 
-static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
-
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 static struct scsi_transport_template *fc_transport_template;
 #endif
@@ -1383,6 +1381,22 @@ static int storvsc_do_io(struct hv_device *device,
 	return ret;
 }
 
+static int storvsc_device_alloc(struct scsi_device *sdevice)
+{
+	/*
+	 * Set blist flag to permit the reading of the VPD pages even when
+	 * the target may claim SPC-2 compliance. MSFT targets currently
+	 * claim SPC-2 compliance while they implement post SPC-2 features.
+	 * With this flag we can correctly handle WRITE_SAME_16 issues.
+	 *
+	 * Hypervisor reports SCSI_UNKNOWN type for DVD ROM device but
+	 * still supports REPORT LUN.
+	 */
+	sdevice->sdev_bflags = BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES;
+
+	return 0;
+}
+
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 
@@ -1396,14 +1410,6 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	sdevice->no_write_same = 1;
 
 	/*
-	 * Add blist flags to permit the reading of the VPD pages even when
-	 * the target may claim SPC-2 compliance. MSFT targets currently
-	 * claim SPC-2 compliance while they implement post SPC-2 features.
-	 * With this patch we can correctly handle WRITE_SAME_16 issues.
-	 */
-	sdevice->sdev_bflags |= msft_blist_flags;
-
-	/*
 	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
 	 * if the device is a MSFT virtual device.  If the host is
 	 * WIN10 or newer, allow write_same.
@@ -1661,6 +1667,7 @@ static struct scsi_host_template scsi_driver = {
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
 	.proc_name =		"storvsc_host",
 	.eh_timed_out =		storvsc_eh_timed_out,
+	.slave_alloc =		storvsc_device_alloc,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
 	.this_id =		-1,
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 318e4a1..54deeb7 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -146,7 +146,7 @@ enum attr_idn {
 /* Descriptor idn for Query requests */
 enum desc_idn {
 	QUERY_DESC_IDN_DEVICE		= 0x0,
-	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
+	QUERY_DESC_IDN_CONFIGURATION	= 0x1,
 	QUERY_DESC_IDN_UNIT		= 0x2,
 	QUERY_DESC_IDN_RFU_0		= 0x3,
 	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
@@ -162,19 +162,13 @@ enum desc_header_offset {
 	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
 };
 
-enum ufs_desc_max_size {
-	QUERY_DESC_DEVICE_MAX_SIZE		= 0x40,
-	QUERY_DESC_CONFIGURAION_MAX_SIZE	= 0x90,
-	QUERY_DESC_UNIT_MAX_SIZE		= 0x23,
-	QUERY_DESC_INTERCONNECT_MAX_SIZE	= 0x06,
-	/*
-	 * Max. 126 UNICODE characters (2 bytes per character) plus 2 bytes
-	 * of descriptor header.
-	 */
-	QUERY_DESC_STRING_MAX_SIZE		= 0xFE,
-	QUERY_DESC_GEOMETRY_MAX_SIZE		= 0x44,
-	QUERY_DESC_POWER_MAX_SIZE		= 0x62,
-	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
+enum ufs_desc_def_size {
+	QUERY_DESC_DEVICE_DEF_SIZE		= 0x40,
+	QUERY_DESC_CONFIGURATION_DEF_SIZE	= 0x90,
+	QUERY_DESC_UNIT_DEF_SIZE		= 0x23,
+	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
+	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x44,
+	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
 };
 
 /* Unit descriptor parameters offsets in bytes*/
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc6efbd..1359913 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -100,19 +100,6 @@
 #define ufshcd_hex_dump(prefix_str, buf, len) \
 print_hex_dump(KERN_ERR, prefix_str, DUMP_PREFIX_OFFSET, 16, 4, buf, len, false)
 
-static u32 ufs_query_desc_max_size[] = {
-	QUERY_DESC_DEVICE_MAX_SIZE,
-	QUERY_DESC_CONFIGURAION_MAX_SIZE,
-	QUERY_DESC_UNIT_MAX_SIZE,
-	QUERY_DESC_RFU_MAX_SIZE,
-	QUERY_DESC_INTERCONNECT_MAX_SIZE,
-	QUERY_DESC_STRING_MAX_SIZE,
-	QUERY_DESC_RFU_MAX_SIZE,
-	QUERY_DESC_GEOMETRY_MAX_SIZE,
-	QUERY_DESC_POWER_MAX_SIZE,
-	QUERY_DESC_RFU_MAX_SIZE,
-};
-
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -2857,7 +2844,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		goto out;
 	}
 
-	if (*buf_len <= QUERY_DESC_MIN_SIZE || *buf_len > QUERY_DESC_MAX_SIZE) {
+	if (*buf_len < QUERY_DESC_MIN_SIZE || *buf_len > QUERY_DESC_MAX_SIZE) {
 		dev_err(hba->dev, "%s: descriptor buffer size (%d) is out of range\n",
 				__func__, *buf_len);
 		err = -EINVAL;
@@ -2938,6 +2925,92 @@ static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 }
 
 /**
+ * ufshcd_read_desc_length - read the specified descriptor length from header
+ * @hba: Pointer to adapter instance
+ * @desc_id: descriptor idn value
+ * @desc_index: descriptor index
+ * @desc_length: pointer to variable to read the length of descriptor
+ *
+ * Return 0 in case of success, non-zero otherwise
+ */
+static int ufshcd_read_desc_length(struct ufs_hba *hba,
+	enum desc_idn desc_id,
+	int desc_index,
+	int *desc_length)
+{
+	int ret;
+	u8 header[QUERY_DESC_HDR_SIZE];
+	int header_len = QUERY_DESC_HDR_SIZE;
+
+	if (desc_id >= QUERY_DESC_IDN_MAX)
+		return -EINVAL;
+
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+					desc_id, desc_index, 0, header,
+					&header_len);
+
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed to get descriptor header id %d",
+			__func__, desc_id);
+		return ret;
+	} else if (desc_id != header[QUERY_DESC_DESC_TYPE_OFFSET]) {
+		dev_warn(hba->dev, "%s: descriptor header id %d and desc_id %d mismatch",
+			__func__, header[QUERY_DESC_DESC_TYPE_OFFSET],
+			desc_id);
+		ret = -EINVAL;
+	}
+
+	*desc_length = header[QUERY_DESC_LENGTH_OFFSET];
+	return ret;
+
+}
+
+/**
+ * ufshcd_map_desc_id_to_length - map descriptor IDN to its length
+ * @hba: Pointer to adapter instance
+ * @desc_id: descriptor idn value
+ * @desc_len: mapped desc length (out)
+ *
+ * Return 0 in case of success, non-zero otherwise
+ */
+int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
+	enum desc_idn desc_id, int *desc_len)
+{
+	switch (desc_id) {
+	case QUERY_DESC_IDN_DEVICE:
+		*desc_len = hba->desc_size.dev_desc;
+		break;
+	case QUERY_DESC_IDN_POWER:
+		*desc_len = hba->desc_size.pwr_desc;
+		break;
+	case QUERY_DESC_IDN_GEOMETRY:
+		*desc_len = hba->desc_size.geom_desc;
+		break;
+	case QUERY_DESC_IDN_CONFIGURATION:
+		*desc_len = hba->desc_size.conf_desc;
+		break;
+	case QUERY_DESC_IDN_UNIT:
+		*desc_len = hba->desc_size.unit_desc;
+		break;
+	case QUERY_DESC_IDN_INTERCONNECT:
+		*desc_len = hba->desc_size.interc_desc;
+		break;
+	case QUERY_DESC_IDN_STRING:
+		*desc_len = QUERY_DESC_MAX_SIZE;
+		break;
+	case QUERY_DESC_IDN_RFU_0:
+	case QUERY_DESC_IDN_RFU_1:
+		*desc_len = 0;
+		break;
+	default:
+		*desc_len = 0;
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
+
+/**
  * ufshcd_read_desc_param - read the specified descriptor parameter
  * @hba: Pointer to adapter instance
  * @desc_id: descriptor idn value
@@ -2951,42 +3024,49 @@ static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 static int ufshcd_read_desc_param(struct ufs_hba *hba,
 				  enum desc_idn desc_id,
 				  int desc_index,
-				  u32 param_offset,
+				  u8 param_offset,
 				  u8 *param_read_buf,
-				  u32 param_size)
+				  u8 param_size)
 {
 	int ret;
 	u8 *desc_buf;
-	u32 buff_len;
+	int buff_len;
 	bool is_kmalloc = true;
 
-	/* safety checks */
-	if (desc_id >= QUERY_DESC_IDN_MAX)
+	/* Safety check */
+	if (desc_id >= QUERY_DESC_IDN_MAX || !param_size)
 		return -EINVAL;
 
-	buff_len = ufs_query_desc_max_size[desc_id];
-	if ((param_offset + param_size) > buff_len)
-		return -EINVAL;
+	/* Get the max length of descriptor from structure filled up at probe
+	 * time.
+	 */
+	ret = ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
 
-	if (!param_offset && (param_size == buff_len)) {
-		/* memory space already available to hold full descriptor */
-		desc_buf = param_read_buf;
-		is_kmalloc = false;
-	} else {
-		/* allocate memory to hold full descriptor */
+	/* Sanity checks */
+	if (ret || !buff_len) {
+		dev_err(hba->dev, "%s: Failed to get full descriptor length",
+			__func__);
+		return ret;
+	}
+
+	/* Check whether we need temp memory */
+	if (param_offset != 0 || param_size < buff_len) {
 		desc_buf = kmalloc(buff_len, GFP_KERNEL);
 		if (!desc_buf)
 			return -ENOMEM;
+	} else {
+		desc_buf = param_read_buf;
+		is_kmalloc = false;
 	}
 
+	/* Request for full descriptor */
 	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
-					desc_id, desc_index, 0, desc_buf,
-					&buff_len);
+					desc_id, desc_index, 0,
+					desc_buf, &buff_len);
 
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
 			__func__, desc_id, desc_index, param_offset, ret);
-
 		goto out;
 	}
 
@@ -2998,25 +3078,9 @@ static int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
-	/*
-	 * While reading variable size descriptors (like string descriptor),
-	 * some UFS devices may report the "LENGTH" (field in "Transaction
-	 * Specific fields" of Query Response UPIU) same as what was requested
-	 * in Query Request UPIU instead of reporting the actual size of the
-	 * variable size descriptor.
-	 * Although it's safe to ignore the "LENGTH" field for variable size
-	 * descriptors as we can always derive the length of the descriptor from
-	 * the descriptor header fields. Hence this change impose the length
-	 * match check only for fixed size descriptors (for which we always
-	 * request the correct size as part of Query Request UPIU).
-	 */
-	if ((desc_id != QUERY_DESC_IDN_STRING) &&
-	    (buff_len != desc_buf[QUERY_DESC_LENGTH_OFFSET])) {
-		dev_err(hba->dev, "%s: desc_buf length mismatch: buff_len %d, buff_len(desc_header) %d",
-			__func__, buff_len, desc_buf[QUERY_DESC_LENGTH_OFFSET]);
-		ret = -EINVAL;
-		goto out;
-	}
+	/* Check wherher we will not copy more data, than available */
+	if (is_kmalloc && param_size > buff_len)
+		param_size = buff_len;
 
 	if (is_kmalloc)
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
@@ -5919,8 +5983,8 @@ static int ufshcd_set_icc_levels_attr(struct ufs_hba *hba, u32 icc_level)
 static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 {
 	int ret;
-	int buff_len = QUERY_DESC_POWER_MAX_SIZE;
-	u8 desc_buf[QUERY_DESC_POWER_MAX_SIZE];
+	int buff_len = hba->desc_size.pwr_desc;
+	u8 desc_buf[hba->desc_size.pwr_desc];
 
 	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
 	if (ret) {
@@ -6017,11 +6081,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 {
 	int err;
 	u8 model_index;
-	u8 str_desc_buf[QUERY_DESC_STRING_MAX_SIZE + 1] = {0};
-	u8 desc_buf[QUERY_DESC_DEVICE_MAX_SIZE];
+	u8 str_desc_buf[QUERY_DESC_MAX_SIZE + 1] = {0};
+	u8 desc_buf[hba->desc_size.dev_desc];
 
-	err = ufshcd_read_device_desc(hba, desc_buf,
-					QUERY_DESC_DEVICE_MAX_SIZE);
+	err = ufshcd_read_device_desc(hba, desc_buf, hba->desc_size.dev_desc);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -6038,14 +6101,14 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index, str_desc_buf,
-					QUERY_DESC_STRING_MAX_SIZE, ASCII_STD);
+				QUERY_DESC_MAX_SIZE, ASCII_STD);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
 			__func__, err);
 		goto out;
 	}
 
-	str_desc_buf[QUERY_DESC_STRING_MAX_SIZE] = '\0';
+	str_desc_buf[QUERY_DESC_MAX_SIZE] = '\0';
 	strlcpy(dev_desc->model, (str_desc_buf + QUERY_DESC_HDR_SIZE),
 		min_t(u8, str_desc_buf[QUERY_DESC_LENGTH_OFFSET],
 		      MAX_MODEL_LEN));
@@ -6251,6 +6314,51 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 	hba->req_abort_count = 0;
 }
 
+static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
+{
+	int err;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_DEVICE, 0,
+		&hba->desc_size.dev_desc);
+	if (err)
+		hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_POWER, 0,
+		&hba->desc_size.pwr_desc);
+	if (err)
+		hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_INTERCONNECT, 0,
+		&hba->desc_size.interc_desc);
+	if (err)
+		hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_CONFIGURATION, 0,
+		&hba->desc_size.conf_desc);
+	if (err)
+		hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_UNIT, 0,
+		&hba->desc_size.unit_desc);
+	if (err)
+		hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_GEOMETRY, 0,
+		&hba->desc_size.geom_desc);
+	if (err)
+		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
+}
+
+static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
+{
+	hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
+	hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
+	hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
+	hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
+	hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
+	hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -6285,6 +6393,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	/* Init check for device descriptor sizes */
+	ufshcd_init_desc_sizes(hba);
+
 	ret = ufs_get_device_desc(hba, &card);
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
@@ -6320,6 +6431,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	/* set the state as operational after switching to desired gear */
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+
 	/*
 	 * If we are in error handling context or in power management callbacks
 	 * context, no need to scan the host
@@ -7774,6 +7886,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
+	/* Set descriptor lengths to specification defaults */
+	ufshcd_def_desc_sizes(hba);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7630600..cdc8bd0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -220,6 +220,15 @@ struct ufs_dev_cmd {
 	struct ufs_query query;
 };
 
+struct ufs_desc_size {
+	int dev_desc;
+	int pwr_desc;
+	int geom_desc;
+	int interc_desc;
+	int unit_desc;
+	int conf_desc;
+};
+
 /**
  * struct ufs_clk_info - UFS clock related info
  * @list: list headed by hba->clk_list_head
@@ -483,6 +492,7 @@ struct ufs_stats {
  * @clk_list_head: UFS host controller clocks list node head
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
+ * @desc_size: descriptor sizes reported by device
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
@@ -666,6 +676,7 @@ struct ufs_hba {
 	bool is_urgent_bkops_lvl_checked;
 
 	struct rw_semaphore clk_scaling_lock;
+	struct ufs_desc_size desc_size;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -832,6 +843,10 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+
+int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
+	int *desc_length);
+
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
 /* Wrapper functions for safely calling variant operations */
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ef474a7..c374e3b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1487,7 +1487,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		irq_flag &= ~PCI_IRQ_MSI;
 
 	error = pci_alloc_irq_vectors(adapter->dev, 1, 1, irq_flag);
-	if (error)
+	if (error < 0)
 		goto out_reset_adapter;
 
 	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b0e275d..583875e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -196,6 +196,7 @@ struct iscsi_conn {
 	struct iscsi_task	*task;		/* xmit task in progress */
 
 	/* xmit */
+	spinlock_t		taskqueuelock;  /* protects the next three lists */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6f22b39..080c7ce 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -472,6 +472,10 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 
+int scsi_internal_device_block(struct scsi_device *sdev, bool wait);
+int scsi_internal_device_unblock(struct scsi_device *sdev,
+				 enum scsi_device_state new_state);
+
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
 {
