From: <kgudipat@brocade.com>
Subject: [PATCH 09/32] bfa: Resume BFA operations after firmware mismatch is resolved.
Date: Wed, 3 Mar 2010 17:44:02 -0800
Message-ID: <1267667042-23769-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47656 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:44:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- bfad.c & bfad_drv.h:
		* Created a kernel thread from pci_probe that does the bfad start operations
		  after BFA init done on a firmware mismatch.
		* The kernel thread on a fw mismatch waits for an event from IOC call back and
		  is woken up from bfa_cb_init() on BFA init success.
		* In normal cases of no firmware mismatch this thread is terminated in pci_probe.

	- bfa_fcs_lport.c, fabric.c, fcs_lport.h & vport.c:
		* Split the lport init to attach time and init time code, so that proper config
		  attributes are set after firmware mismatch.

	- bfa_iocfc.c:
		* Handle an IOC timer issue, where the IOC timer would expire before the init
		  completion and send Init fail event to the driver, however IOC init continues
		  and completes successfully at the later stage. The bfa and driver were not
		  handling this kind of deferred init completion.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |   30 ++++--
 drivers/scsi/bfa/bfa_iocfc.c     |    6 +-
 drivers/scsi/bfa/bfad.c          |  189 ++++++++++++++++++++++++++++++--------
 drivers/scsi/bfa/bfad_drv.h      |   12 ++-
 drivers/scsi/bfa/fabric.c        |    4 +-
 drivers/scsi/bfa/fcs_lport.h     |    7 +-
 drivers/scsi/bfa/vport.c         |    3 +-
 7 files changed, 192 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index c7ab257..3d62e45 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -873,36 +873,46 @@ bfa_fcs_port_is_online(struct bfa_fcs_port_s *port)
 }
 
 /**
- * Logical port initialization of base or virtual port.
- * Called by fabric for base port or by vport for virtual ports.
+ * Attach time initialization of logical ports.
  */
 void
-bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
-		   u16 vf_id, struct bfa_port_cfg_s *port_cfg,
-		   struct bfa_fcs_vport_s *vport)
+bfa_fcs_lport_attach(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
+		uint16_t vf_id, struct bfa_fcs_vport_s *vport)
 {
 	lport->fcs = fcs;
 	lport->fabric = bfa_fcs_vf_lookup(fcs, vf_id);
-	bfa_os_assign(lport->port_cfg, *port_cfg);
 	lport->vport = vport;
 	lport->lp_tag = (vport) ? bfa_lps_get_tag(vport->lps) :
 			 bfa_lps_get_tag(lport->fabric->lps);
 
 	INIT_LIST_HEAD(&lport->rport_q);
 	lport->num_rports = 0;
+}
+
+/**
+ * Logical port initialization of base or virtual port.
+ * Called by fabric for base port or by vport for virtual ports.
+ */
 
-	lport->bfad_port =
-		bfa_fcb_port_new(fcs->bfad, lport, lport->port_cfg.roles,
+void
+bfa_fcs_lport_init(struct bfa_fcs_port_s *lport,
+		struct bfa_port_cfg_s *port_cfg)
+{
+	struct bfa_fcs_vport_s *vport = lport->vport;
+
+	bfa_os_assign(lport->port_cfg, *port_cfg);
+
+	lport->bfad_port = bfa_fcb_port_new(lport->fcs->bfad, lport,
+				lport->port_cfg.roles,
 				lport->fabric->vf_drv,
 				vport ? vport->vport_drv : NULL);
+
 	bfa_fcs_port_aen_post(lport, BFA_LPORT_AEN_NEW);
 
 	bfa_sm_set_state(lport, bfa_fcs_port_sm_uninit);
 	bfa_sm_send_event(lport, BFA_FCS_PORT_SM_CREATE);
 }
 
-
-
 /**
  *  fcs_lport_api
  */
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index b5e7224..137591c 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -336,8 +336,10 @@ bfa_iocfc_init_cb(void *bfa_arg, bfa_boolean_t complete)
 			bfa_cb_init(bfa->bfad, BFA_STATUS_OK);
 		else
 			bfa_cb_init(bfa->bfad, BFA_STATUS_FAILED);
-	} else
-		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+	} else {
+		if (bfa->iocfc.cfgdone)
+			bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+	}
 }
 
 static void
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 965dfb5..4ccaeae 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/kthread.h>
 #include "bfad_drv.h"
 #include "bfad_im.h"
 #include "bfad_tm.h"
@@ -97,6 +98,8 @@ bfad_fc4_probe(struct bfad_s *bfad)
 
 	if (ipfc_enable)
 		bfad_ipfc_probe(bfad);
+
+	bfad->bfad_flags |= BFAD_FC4_PROBE_DONE;
 ext:
 	return rc;
 }
@@ -108,6 +111,7 @@ bfad_fc4_probe_undo(struct bfad_s *bfad)
 	bfad_tm_probe_undo(bfad);
 	if (ipfc_enable)
 		bfad_ipfc_probe_undo(bfad);
+	bfad->bfad_flags &= ~BFAD_FC4_PROBE_DONE;
 }
 
 static void
@@ -175,9 +179,19 @@ bfa_cb_init(void *drv, bfa_status_t init_status)
 {
 	struct bfad_s  *bfad = drv;
 
-	if (init_status == BFA_STATUS_OK)
+	if (init_status == BFA_STATUS_OK) {
 		bfad->bfad_flags |= BFAD_HAL_INIT_DONE;
 
+		/* If BFAD_HAL_INIT_FAIL flag is set:
+		 * Wake up the kernel thread to start
+		 * the bfad operations after HAL init done
+		 */
+		if ((bfad->bfad_flags & BFAD_HAL_INIT_FAIL)) {
+			bfad->bfad_flags &= ~BFAD_HAL_INIT_FAIL;
+			wake_up_process(bfad->bfad_tsk);
+		}
+	}
+
 	complete(&bfad->comp);
 }
 
@@ -749,7 +763,13 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_fcs_trc_init(&bfad->bfa_fcs, bfad->trcmod);
 	bfa_fcs_aen_init(&bfad->bfa_fcs, bfad->aen);
 	bfa_fcs_attach(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
-	bfa_fcs_init(&bfad->bfa_fcs);
+
+	/* Do FCS init only when HAL init is done */
+	if ((bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
+		bfa_fcs_init(&bfad->bfa_fcs);
+		bfad->bfad_flags |= BFAD_FCS_INIT_DONE;
+	}
+
 	bfa_fcs_driver_info_init(&bfad->bfa_fcs, &driver_info);
 	bfa_fcs_set_fdmi_param(&bfad->bfa_fcs, fdmi_enable);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -767,12 +787,22 @@ out_hal_mem_alloc_failure:
 void
 bfad_drv_uninit(struct bfad_s *bfad)
 {
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	init_completion(&bfad->comp);
+	bfa_stop(&bfad->bfa);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(&bfad->comp);
+
 	del_timer_sync(&bfad->hal_tmo);
 	bfa_isr_disable(&bfad->bfa);
 	bfa_detach(&bfad->bfa);
 	bfad_remove_intr(bfad);
 	bfa_assert(list_empty(&bfad->file_q));
 	bfad_hal_mem_release(bfad);
+
+	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
 }
 
 void
@@ -863,6 +893,86 @@ bfad_drv_log_level_set(struct bfad_s *bfad)
 		bfa_log_set_level_all(&bfad->log_data, log_level);
 }
 
+bfa_status_t
+bfad_start_ops(struct bfad_s *bfad)
+{
+	int retval;
+
+	/* PPORT FCS config */
+	bfad_fcs_port_cfg(bfad);
+
+	retval = bfad_cfg_pport(bfad, BFA_PORT_ROLE_FCP_IM);
+	if (retval != BFA_STATUS_OK)
+		goto out_cfg_pport_failure;
+
+	/* BFAD level FC4 (IM/TM/IPFC) specific resource allocation */
+	retval = bfad_fc4_probe(bfad);
+	if (retval != BFA_STATUS_OK) {
+		printk(KERN_WARNING "bfad_fc4_probe failed\n");
+		goto out_fc4_probe_failure;
+	}
+
+	bfad_drv_start(bfad);
+
+	/*
+	 * If bfa_linkup_delay is set to -1 default; try to retrive the
+	 * value using the bfad_os_get_linkup_delay(); else use the
+	 * passed in module param value as the bfa_linkup_delay.
+	 */
+	if (bfa_linkup_delay < 0) {
+
+		bfa_linkup_delay = bfad_os_get_linkup_delay(bfad);
+		bfad_os_rport_online_wait(bfad);
+		bfa_linkup_delay = -1;
+
+	} else {
+		bfad_os_rport_online_wait(bfad);
+	}
+
+	bfa_log(bfad->logmod, BFA_LOG_LINUX_DEVICE_CLAIMED, bfad->pci_name);
+
+	return BFA_STATUS_OK;
+
+out_fc4_probe_failure:
+	bfad_fc4_probe_undo(bfad);
+	bfad_uncfg_pport(bfad);
+out_cfg_pport_failure:
+	return BFA_STATUS_FAILED;
+}
+
+int
+bfad_worker (void *ptr)
+{
+	struct bfad_s *bfad;
+	unsigned long   flags;
+
+	bfad = (struct bfad_s *)ptr;
+
+	while (!kthread_should_stop()) {
+
+		/* Check if the FCS init is done from bfad_drv_init;
+		 * if not done do FCS init and set the flag.
+		 */
+		if (!(bfad->bfad_flags & BFAD_FCS_INIT_DONE)) {
+			spin_lock_irqsave(&bfad->bfad_lock, flags);
+			bfa_fcs_init(&bfad->bfa_fcs);
+			bfad->bfad_flags |= BFAD_FCS_INIT_DONE;
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		}
+
+		/* Start the bfad operations after HAL init done */
+		bfad_start_ops(bfad);
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfad->bfad_tsk = NULL;
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+		break;
+	}
+
+	return 0;
+}
+
  /*
   *  PCI_entry PCI driver entries * {
   */
@@ -937,57 +1047,39 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 	bfad->ref_count = 0;
 	bfad->pport.bfad = bfad;
 
+	bfad->bfad_tsk = kthread_create(bfad_worker, (void *) bfad, "%s",
+					"bfad_worker");
+	if (IS_ERR(bfad->bfad_tsk)) {
+		printk(KERN_INFO "bfad[%d]: Kernel thread"
+			" creation failed!\n",
+			bfad->inst_no);
+		goto out_kthread_create_failure;
+	}
+
 	retval = bfad_drv_init(bfad);
 	if (retval != BFA_STATUS_OK)
 		goto out_drv_init_failure;
 	if (!(bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
+		bfad->bfad_flags |= BFAD_HAL_INIT_FAIL;
 		printk(KERN_WARNING "bfad%d: hal init failed\n", bfad->inst_no);
 		goto ok;
 	}
 
-	/*
-	 * PPORT FCS config
-	 */
-	bfad_fcs_port_cfg(bfad);
-
-	retval = bfad_cfg_pport(bfad, BFA_PORT_ROLE_FCP_IM);
+	retval = bfad_start_ops(bfad);
 	if (retval != BFA_STATUS_OK)
-		goto out_cfg_pport_failure;
+		goto out_start_ops_failure;
 
-	/*
-	 * BFAD level FC4 (IM/TM/IPFC) specific resource allocation
-	 */
-	retval = bfad_fc4_probe(bfad);
-	if (retval != BFA_STATUS_OK) {
-		printk(KERN_WARNING "bfad_fc4_probe failed\n");
-		goto out_fc4_probe_failure;
-	}
-
-	bfad_drv_start(bfad);
+	kthread_stop(bfad->bfad_tsk);
+	bfad->bfad_tsk = NULL;
 
-	/*
-	 * If bfa_linkup_delay is set to -1 default; try to retrive the
-	 * value using the bfad_os_get_linkup_delay(); else use the
-	 * passed in module param value as the bfa_linkup_delay.
-	 */
-	if (bfa_linkup_delay < 0) {
-		bfa_linkup_delay = bfad_os_get_linkup_delay(bfad);
-		bfad_os_rport_online_wait(bfad);
-		bfa_linkup_delay = -1;
-	} else {
-		bfad_os_rport_online_wait(bfad);
-	}
-
-	bfa_log(bfad->logmod, BFA_LOG_LINUX_DEVICE_CLAIMED, bfad->pci_name);
 ok:
 	return 0;
 
-out_fc4_probe_failure:
-	bfad_fc4_probe_undo(bfad);
-	bfad_uncfg_pport(bfad);
-out_cfg_pport_failure:
+out_start_ops_failure:
 	bfad_drv_uninit(bfad);
 out_drv_init_failure:
+	kthread_stop(bfad->bfad_tsk);
+out_kthread_create_failure:
 	mutex_lock(&bfad_mutex);
 	bfad_inst--;
 	list_del(&bfad->list_entry);
@@ -1012,6 +1104,11 @@ bfad_pci_remove(struct pci_dev *pdev)
 
 	bfa_trc(bfad, bfad->inst_no);
 
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (bfad->bfad_tsk != NULL)
+		kthread_stop(bfad->bfad_tsk);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
 	if ((bfad->bfad_flags & BFAD_DRV_INIT_DONE)
 	    && !(bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
 
@@ -1028,13 +1125,25 @@ bfad_pci_remove(struct pci_dev *pdev)
 		goto remove_sysfs;
 	}
 
-	if (bfad->bfad_flags & BFAD_HAL_START_DONE)
+	if (bfad->bfad_flags & BFAD_HAL_START_DONE) {
 		bfad_drv_stop(bfad);
+	} else if (bfad->bfad_flags & BFAD_DRV_INIT_DONE) {
+		/* Invoking bfa_stop() before bfa_detach
+		 * when HAL and DRV init are success
+		 * but HAL start did not occur.
+		 */
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		init_completion(&bfad->comp);
+		bfa_stop(&bfad->bfa);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		wait_for_completion(&bfad->comp);
+	}
 
 	bfad_remove_intr(bfad);
-
 	del_timer_sync(&bfad->hal_tmo);
-	bfad_fc4_probe_undo(bfad);
+
+	if (bfad->bfad_flags & BFAD_FC4_PROBE_DONE)
+		bfad_fc4_probe_undo(bfad);
 
 	if (bfad->bfad_flags & BFAD_CFG_PPORT_DONE)
 		bfad_uncfg_pport(bfad);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 26e5774..3740a44 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -62,7 +62,9 @@
 #define BFAD_HAL_START_DONE			0x00000010
 #define BFAD_PORT_ONLINE			0x00000020
 #define BFAD_RPORT_ONLINE			0x00000040
-
+#define BFAD_FCS_INIT_DONE                      0x00000080
+#define BFAD_HAL_INIT_FAIL                      0x00000100
+#define BFAD_FC4_PROBE_DONE                     0x00000200
 #define BFAD_PORT_DELETE			0x00000001
 
 /*
@@ -168,6 +170,7 @@ struct bfad_s {
 	u32        inst_no;	/* BFAD instance number */
 	u32        bfad_flags;
 	spinlock_t      bfad_lock;
+	struct task_struct *bfad_tsk;
 	struct bfad_cfg_param_s cfg_data;
 	struct bfad_msix_s msix_tab[MAX_MSIX_ENTRY];
 	int             nvec;
@@ -258,6 +261,7 @@ bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
 			       struct bfa_port_cfg_s *port_cfg);
 bfa_status_t    bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role);
 bfa_status_t    bfad_drv_init(struct bfad_s *bfad);
+bfa_status_t	bfad_start_ops(struct bfad_s *bfad);
 void            bfad_drv_start(struct bfad_s *bfad);
 void            bfad_uncfg_pport(struct bfad_s *bfad);
 void            bfad_drv_stop(struct bfad_s *bfad);
@@ -280,6 +284,12 @@ void		bfad_drv_log_level_set(struct bfad_s *bfad);
 bfa_status_t	bfad_fc4_module_init(void);
 void		bfad_fc4_module_exit(void);
 
+bfa_status_t	bfad_os_kthread_create(struct bfad_s *bfad);
+void		bfad_os_kthread_stop(struct bfad_s *bfad);
+void		bfad_os_kthread_wakeup(struct bfad_s *bfad);
+int		bfad_os_kthread_should_stop(void);
+int		bfad_worker (void *ptr);
+
 void bfad_pci_remove(struct pci_dev *pdev);
 int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid);
 void bfad_os_rport_online_wait(struct bfad_s *bfad);
diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index e229898..20a686a 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -136,8 +136,7 @@ bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
 	case BFA_FCS_FABRIC_SM_CREATE:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_created);
 		bfa_fcs_fabric_init(fabric);
-		bfa_fcs_lport_init(&fabric->bport, fabric->fcs, FC_VF_ID_NULL,
-				   &fabric->bport.port_cfg, NULL);
+		bfa_fcs_lport_init(&fabric->bport, &fabric->bport.port_cfg);
 		break;
 
 	case BFA_FCS_FABRIC_SM_LINK_UP:
@@ -841,6 +840,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 	bfa_wc_up(&fabric->wc);	/* For the base port */
 
 	bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
+	bfa_fcs_lport_attach(&fabric->bport, fabric->fcs, FC_VF_ID_NULL, NULL);
 }
 
 void
diff --git a/drivers/scsi/bfa/fcs_lport.h b/drivers/scsi/bfa/fcs_lport.h
index ae744ba..a6508c8 100644
--- a/drivers/scsi/bfa/fcs_lport.h
+++ b/drivers/scsi/bfa/fcs_lport.h
@@ -84,9 +84,10 @@ void bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
  * Following routines will be called by Fabric to indicate port
  * online/offline to vport.
  */
-void bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
-			u16 vf_id, struct bfa_port_cfg_s *port_cfg,
-			struct bfa_fcs_vport_s *vport);
+void bfa_fcs_lport_attach(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
+			uint16_t vf_id, struct bfa_fcs_vport_s *vport);
+void bfa_fcs_lport_init(struct bfa_fcs_port_s *lport,
+			struct bfa_port_cfg_s *port_cfg);
 void bfa_fcs_port_online(struct bfa_fcs_port_s *port);
 void bfa_fcs_port_offline(struct bfa_fcs_port_s *port);
 void bfa_fcs_port_delete(struct bfa_fcs_port_s *port);
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 3dce9e1..13f7371 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -662,7 +662,8 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 	vport->vport_drv = vport_drv;
 	bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
 
-	bfa_fcs_lport_init(&vport->lport, fcs, vf_id, vport_cfg, vport);
+	bfa_fcs_lport_attach(&vport->lport, fcs, vf_id, vport);
+	bfa_fcs_lport_init(&vport->lport, vport_cfg);
 
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_CREATE);
 
-- 
1.6.5.3

