From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 1/7] bfa: update bfa driver to version 2.1.2.1 part 1
Date: Thu, 19 Nov 2009 16:09:34 -0800
Message-ID: <1258675774-17598-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:26563 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbZKTAJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 19:09:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/Makefile             |    6 +-
 drivers/scsi/bfa/bfa_cb_ioim_macros.h |    2 +-
 drivers/scsi/bfa/bfad.c               |  442 ++++++++++++++++++++-------------
 drivers/scsi/bfa/bfad_attr.c          |  199 +++++++++++----
 drivers/scsi/bfa/bfad_attr.h          |    9 -
 drivers/scsi/bfa/bfad_drv.h           |   37 ++--
 drivers/scsi/bfa/bfad_fwimg.c         |    2 +
 drivers/scsi/bfa/bfad_im.c            |   81 +++----
 drivers/scsi/bfa/bfad_im.h            |    7 +-
 drivers/scsi/bfa/bfad_intr.c          |   14 +-
 drivers/scsi/bfa/bfad_os.c            |    2 -
 11 files changed, 482 insertions(+), 319 deletions(-)

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 1d60094..619e62a 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -2,8 +2,8 @@ obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 
 bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
 
-bfa-y += bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_lps.o
-bfa-y += bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
+bfa-y += bfa_core.o bfa_ioc.o bfa_ioc_ct.o bfa_ioc_cb.o bfa_iocfc.o bfa_fcxp.o
+bfa-y += bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
 bfa-y += bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o
 bfa-y += bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o
 bfa-y += bfa_csdebug.o bfa_sm.o plog.o
@@ -12,4 +12,4 @@ bfa-y += fcbuild.o fabric.o fcpim.o vfapi.o fcptm.o bfa_fcs.o bfa_fcs_port.o
 bfa-y += bfa_fcs_uf.o bfa_fcs_lport.o fab.o fdmi.o ms.o ns.o scn.o loop.o
 bfa-y += lport_api.o n2n.o rport.o rport_api.o rport_ftrs.o vport.o
 
-ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna
+ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna -DBFA_PERF_BUILD
diff --git a/drivers/scsi/bfa/bfa_cb_ioim_macros.h b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
index 961fe43..0d4f749 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim_macros.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
@@ -129,7 +129,7 @@ bfa_cb_ioim_get_sgaddr(struct bfad_ioim_s *dio, int sgeid)
 	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
 	addr = (u64) sg_dma_address(sge);
 
-	return *((union bfi_addr_u *) &addr);
+	return *(union bfi_addr_u *) &addr;
 }
 
 static inline u32
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index b52b773..9b09053 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/kthread.h>
 #include "bfad_drv.h"
 #include "bfad_im.h"
 #include "bfad_tm.h"
@@ -33,28 +34,29 @@
 BFA_TRC_FILE(LDRV, BFAD);
 static DEFINE_MUTEX(bfad_mutex);
 LIST_HEAD(bfad_list);
-static int      bfad_inst;
+static	int	bfad_inst;
 int bfad_supported_fc4s;
 
-static char     *host_name;
-static char     *os_name;
-static char     *os_patch;
-static int      num_rports;
-static int      num_ios;
-static int      num_tms;
-static int      num_fcxps;
-static int      num_ufbufs;
-static int      reqq_size;
-static int      rspq_size;
-static int      num_sgpgs;
-static int      rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
-static int      bfa_io_max_sge = BFAD_IO_MAX_SGE;
-static int      log_level = BFA_LOG_WARNING;
-static int      ioc_auto_recover = BFA_TRUE;
-static int      ipfc_enable = BFA_FALSE;
-static int      ipfc_mtu = -1;
-int 		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
-int      	bfa_linkup_delay = -1;
+static char	*host_name;
+static char	*os_name;
+static char	*os_patch;
+static int	num_rports;
+static int	num_ios;
+static int	num_tms;
+static int	num_fcxps;
+static int	num_ufbufs;
+static int	reqq_size;
+static int	rspq_size;
+static int	num_sgpgs;
+static int	rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
+static int	bfa_io_max_sge = BFAD_IO_MAX_SGE;
+static int	log_level = BFA_LOG_WARNING;
+static int	ioc_auto_recover = BFA_TRUE;
+static int	ipfc_enable = BFA_FALSE;
+static int	ipfc_mtu = -1;
+static int	fdmi_enable = BFA_TRUE;
+int		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
+int		bfa_linkup_delay = -1;
 
 module_param(os_name, charp, S_IRUGO | S_IWUSR);
 module_param(os_patch, charp, S_IRUGO | S_IWUSR);
@@ -74,18 +76,19 @@ module_param(log_level, int, S_IRUGO | S_IWUSR);
 module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
 module_param(ipfc_enable, int, S_IRUGO | S_IWUSR);
 module_param(ipfc_mtu, int, S_IRUGO | S_IWUSR);
+module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
 module_param(bfa_linkup_delay, int, S_IRUGO | S_IWUSR);
 
 /*
  * Stores the module parm num_sgpgs value;
  * used to reset for bfad next instance.
  */
-static int num_sgpgs_parm;
+static int	num_sgpgs_parm;
 
 static bfa_status_t
 bfad_fc4_probe(struct bfad_s *bfad)
 {
-	int             rc;
+	int		rc;
 
 	rc = bfad_im_probe(bfad);
 	if (rc != BFA_STATUS_OK)
@@ -95,6 +98,9 @@ bfad_fc4_probe(struct bfad_s *bfad)
 
 	if (ipfc_enable)
 		bfad_ipfc_probe(bfad);
+
+	bfad->bfad_flags |= BFAD_FC4_PROBE_DONE;
+
 ext:
 	return rc;
 }
@@ -106,6 +112,8 @@ bfad_fc4_probe_undo(struct bfad_s *bfad)
 	bfad_tm_probe_undo(bfad);
 	if (ipfc_enable)
 		bfad_ipfc_probe_undo(bfad);
+
+	bfad->bfad_flags &= ~BFAD_FC4_PROBE_DONE;
 }
 
 static void
@@ -122,7 +130,7 @@ bfad_fc4_probe_post(struct bfad_s *bfad)
 static bfa_status_t
 bfad_fc4_port_new(struct bfad_s *bfad, struct bfad_port_s *port, int roles)
 {
-	int             rc = BFA_STATUS_FAILED;
+	int		rc = BFA_STATUS_FAILED;
 
 	if (roles & BFA_PORT_ROLE_FCP_IM)
 		rc = bfad_im_port_new(bfad, port);
@@ -171,16 +179,24 @@ bfad_hcb_comp(void *arg, bfa_status_t status)
 void
 bfa_cb_init(void *drv, bfa_status_t init_status)
 {
-	struct bfad_s  *bfad = drv;
+	struct bfad_s	      *bfad = drv;
 
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
 
-
-
 /**
  *  BFA_FCS callbacks
  */
@@ -197,8 +213,8 @@ bfa_fcb_port_new(struct bfad_s *bfad, struct bfa_fcs_port_s *port,
 		 enum bfa_port_role roles, struct bfad_vf_s *vf_drv,
 		 struct bfad_vport_s *vp_drv)
 {
-	bfa_status_t    rc;
-	struct bfad_port_s *port_drv;
+	bfa_status_t	rc;
+	struct bfad_port_s    *port_drv;
 
 	if (!vp_drv && !vf_drv) {
 		port_drv = &bfad->pport;
@@ -229,11 +245,9 @@ void
 bfa_fcb_port_delete(struct bfad_s *bfad, enum bfa_port_role roles,
 		    struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
 {
-	struct bfad_port_s *port_drv;
+	struct bfad_port_s    *port_drv;
 
-	/*
-	 * this will be only called from rmmod context
-	 */
+	/* this will be only called from rmmod context */
 	if (vp_drv && !vp_drv->comp_del) {
 		port_drv = bfad_get_drv_port(bfad, vf_drv, vp_drv);
 		bfa_trc(bfad, roles);
@@ -293,7 +307,7 @@ bfa_status_t
 bfa_fcb_rport_alloc(struct bfad_s *bfad, struct bfa_fcs_rport_s **rport,
 		    struct bfad_rport_s **rport_drv)
 {
-	bfa_status_t    rc = BFA_STATUS_OK;
+	bfa_status_t	rc = BFA_STATUS_OK;
 
 	*rport_drv = kzalloc(sizeof(struct bfad_rport_s), GFP_ATOMIC);
 	if (*rport_drv == NULL) {
@@ -307,12 +321,10 @@ ext:
 	return rc;
 }
 
-
-
 void
 bfad_hal_mem_release(struct bfad_s *bfad)
 {
-	int             i;
+	int		i;
 	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
 	struct bfa_mem_elem_s *meminfo_elem;
 
@@ -364,13 +376,13 @@ bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg)
 	 * otherwise, the default values will be shown as 0 in sysfs
 	 */
 	num_rports = bfa_cfg->fwcfg.num_rports;
-	num_ios    = bfa_cfg->fwcfg.num_ioim_reqs;
-	num_tms	   = bfa_cfg->fwcfg.num_tskim_reqs;
-	num_fcxps  = bfa_cfg->fwcfg.num_fcxp_reqs;
+	num_ios = bfa_cfg->fwcfg.num_ioim_reqs;
+	num_tms = bfa_cfg->fwcfg.num_tskim_reqs;
+	num_fcxps = bfa_cfg->fwcfg.num_fcxp_reqs;
 	num_ufbufs = bfa_cfg->fwcfg.num_uf_bufs;
-	reqq_size  = bfa_cfg->drvcfg.num_reqq_elems;
-	rspq_size  = bfa_cfg->drvcfg.num_rspq_elems;
-	num_sgpgs  = bfa_cfg->drvcfg.num_sgpgs;
+	reqq_size = bfa_cfg->drvcfg.num_reqq_elems;
+	rspq_size = bfa_cfg->drvcfg.num_rspq_elems;
+	num_sgpgs = bfa_cfg->drvcfg.num_sgpgs;
 }
 
 bfa_status_t
@@ -390,7 +402,7 @@ bfad_hal_mem_alloc(struct bfad_s *bfad)
 
 retry:
 	bfad_update_hal_cfg(&bfad->ioc_cfg);
-	bfad->cfg_data.ioc_queue_depth = bfad->ioc_cfg.fwcfg.num_ioim_reqs;
+	bfad->cfg_data.ioc_queue_depth = bfad->ioc_cfg.fwcfg.num_ioim_reqs ;
 	bfa_cfg_get_meminfo(&bfad->ioc_cfg, hal_meminfo);
 
 	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
@@ -417,14 +429,16 @@ retry:
 				 * num_sgpages try with half the value.
 				 */
 				if (num_sgpgs > min_num_sgpgs) {
-					printk(KERN_INFO "bfad[%d]: memory"
-						" allocation failed with"
-						" num_sgpgs: %d\n",
+					printk(KERN_INFO
+						"bfad[%d]: memory"
+						" allocation failed"
+						" with num_sgpgs: %d\n",
 						bfad->inst_no, num_sgpgs);
 					nextLowerInt(&num_sgpgs);
-					printk(KERN_INFO "bfad[%d]: trying to"
-						" allocate memory with"
-						" num_sgpgs: %d\n",
+					printk(KERN_INFO
+						"bfad[%d]: trying"
+						" to allocate memory"
+						" with num_sgpgs: %d\n",
 						bfad->inst_no, num_sgpgs);
 					retry_count++;
 					goto retry;
@@ -468,9 +482,9 @@ bfa_status_t
 bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 		  struct bfa_port_cfg_s *port_cfg)
 {
-	struct bfad_vport_s *vport;
-	int             rc = BFA_STATUS_OK;
-	unsigned long   flags;
+	struct bfad_vport_s   *vport;
+	int		rc = BFA_STATUS_OK;
+	unsigned long	flags;
 	struct completion fcomp;
 
 	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
@@ -520,8 +534,8 @@ bfa_status_t
 bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
 	       struct bfa_port_cfg_s *port_cfg)
 {
-	struct bfad_vf_s *vf;
-	int             rc = BFA_STATUS_OK;
+	struct bfad_vf_s      *vf;
+	int		rc = BFA_STATUS_OK;
 
 	vf = kzalloc(sizeof(struct bfad_vf_s), GFP_KERNEL);
 	if (!vf) {
@@ -540,9 +554,9 @@ ext:
 void
 bfad_bfa_tmo(unsigned long data)
 {
-	struct bfad_s  *bfad = (struct bfad_s *)data;
-	unsigned long   flags;
-	struct list_head  doneq;
+	struct bfad_s	      *bfad = (struct bfad_s *) data;
+	unsigned long	flags;
+	struct list_head	       doneq;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
@@ -558,7 +572,8 @@ bfad_bfa_tmo(unsigned long data)
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	}
 
-	mod_timer(&bfad->hal_tmo, jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+	mod_timer(&bfad->hal_tmo,
+		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
 }
 
 void
@@ -568,14 +583,15 @@ bfad_init_timer(struct bfad_s *bfad)
 	bfad->hal_tmo.function = bfad_bfa_tmo;
 	bfad->hal_tmo.data = (unsigned long)bfad;
 
-	mod_timer(&bfad->hal_tmo, jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+	mod_timer(&bfad->hal_tmo,
+		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
 }
 
 int
 bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 {
-	unsigned long   bar0_len;
-	int             rc = -ENODEV;
+	unsigned long	bar0_len;
+	int		rc = -ENODEV;
 
 	if (pci_enable_device(pdev)) {
 		BFA_PRINTF(BFA_ERR, "pci_enable_device fail %p\n", pdev);
@@ -587,7 +603,6 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 
 	pci_set_master(pdev);
 
-
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
 			BFA_PRINTF(BFA_ERR, "pci_set_dma_mask fail %p\n", pdev);
@@ -642,13 +657,13 @@ bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 void
 bfad_fcs_port_cfg(struct bfad_s *bfad)
 {
-	struct bfa_port_cfg_s port_cfg;
+	struct bfa_port_cfg_s  port_cfg;
 	struct bfa_pport_attr_s attr;
-	char            symname[BFA_SYMNAME_MAXLEN];
+	char		symname[BFA_SYMNAME_MAXLEN];
 
 	sprintf(symname, "%s-%d", BFAD_DRIVER_NAME, bfad->inst_no);
 	memcpy(port_cfg.sym_name.symname, symname, strlen(symname));
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 	port_cfg.nwwn = attr.nwwn;
 	port_cfg.pwwn = attr.pwwn;
 
@@ -658,10 +673,9 @@ bfad_fcs_port_cfg(struct bfad_s *bfad)
 bfa_status_t
 bfad_drv_init(struct bfad_s *bfad)
 {
-	bfa_status_t    rc;
-	unsigned long   flags;
+	bfa_status_t	rc;
+	unsigned long	flags;
 	struct bfa_fcs_driver_info_s driver_info;
-	int             i;
 
 	bfad->cfg_data.rport_del_timeout = rport_del_timeout;
 	bfad->cfg_data.lun_queue_depth = bfa_lun_queue_depth;
@@ -673,7 +687,7 @@ bfad_drv_init(struct bfad_s *bfad)
 		printk(KERN_WARNING "bfad%d bfad_hal_mem_alloc failure\n",
 		       bfad->inst_no);
 		printk(KERN_WARNING
-			"Not enough memory to attach all Brocade HBA ports,"
+		       "Not enough memory to attach all Brocade HBA ports,"
 			" System may need more memory.\n");
 		goto out_hal_mem_alloc_failure;
 	}
@@ -681,12 +695,7 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_init_log(&bfad->bfa, bfad->logmod);
 	bfa_init_trc(&bfad->bfa, bfad->trcmod);
 	bfa_init_aen(&bfad->bfa, bfad->aen);
-	INIT_LIST_HEAD(&bfad->file_q);
-	INIT_LIST_HEAD(&bfad->file_free_q);
-	for (i = 0; i < BFAD_AEN_MAX_APPS; i++) {
-		bfa_q_qe_init(&bfad->file_buf[i].qe);
-		list_add_tail(&bfad->file_buf[i].qe, &bfad->file_free_q);
-	}
+	memset(bfad->file_map, 0, sizeof(bfad->file_map));
 	bfa_init_plog(&bfad->bfa, &bfad->plog_buf);
 	bfa_plog_init(&bfad->plog_buf);
 	bfa_plog_str(&bfad->plog_buf, BFA_PL_MID_DRVR, BFA_PL_EID_DRIVER_START,
@@ -697,9 +706,7 @@ bfad_drv_init(struct bfad_s *bfad)
 
 	init_completion(&bfad->comp);
 
-	/*
-	 * Enable Interrupt and wait bfa_init completion
-	 */
+	/* Enable Interrupt and wait bfa_init completion */
 	if (bfad_setup_intr(bfad)) {
 		printk(KERN_WARNING "bfad%d: bfad_setup_intr failed\n",
 		       bfad->inst_no);
@@ -710,11 +717,9 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_init(&bfad->bfa);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	/*
-	 * Set up interrupt handler for each vectors
-	 */
-	if ((bfad->bfad_flags & BFAD_MSIX_ON)
-	    && bfad_install_msix_handler(bfad)) {
+	/* Set up interrupt handler for each vectors */
+	if ((bfad->bfad_flags & BFAD_MSIX_ON) &&
+	    bfad_install_msix_handler(bfad)) {
 		printk(KERN_WARNING "%s: install_msix failed, bfad%d\n",
 		       __func__, bfad->inst_no);
 	}
@@ -739,18 +744,25 @@ bfad_drv_init(struct bfad_s *bfad)
 	strncpy(driver_info.os_device_name, bfad->pci_name,
 		sizeof(driver_info.os_device_name - 1));
 
-	/*
-	 * FCS INIT
-	 */
+	/* FCS INIT */
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_fcs_log_init(&bfad->bfa_fcs, bfad->logmod);
 	bfa_fcs_trc_init(&bfad->bfa_fcs, bfad->trcmod);
 	bfa_fcs_aen_init(&bfad->bfa_fcs, bfad->aen);
-	bfa_fcs_init(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
+	bfa_fcs_attach(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
+
+	/* Do FCS init only when HAL init is done */
+	if ((bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
+		bfa_fcs_init(&bfad->bfa_fcs);
+		bfad->bfad_flags |= BFAD_FCS_INIT_DONE;
+	}
+
 	bfa_fcs_driver_info_init(&bfad->bfa_fcs, &driver_info);
+	bfa_fcs_set_fdmi_param(&bfad->bfa_fcs, fdmi_enable);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	bfad->bfad_flags |= BFAD_DRV_INIT_DONE;
+
 	return BFA_STATUS_OK;
 
 out_setup_intr_failure:
@@ -763,18 +775,27 @@ out_hal_mem_alloc_failure:
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
-	bfa_assert(list_empty(&bfad->file_q));
 	bfad_hal_mem_release(bfad);
+
+	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
 }
 
 void
 bfad_drv_start(struct bfad_s *bfad)
 {
-	unsigned long   flags;
+	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_start(&bfad->bfa);
@@ -788,7 +809,7 @@ bfad_drv_start(struct bfad_s *bfad)
 void
 bfad_drv_stop(struct bfad_s *bfad)
 {
-	unsigned long   flags;
+	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	init_completion(&bfad->comp);
@@ -808,11 +829,9 @@ bfad_drv_stop(struct bfad_s *bfad)
 bfa_status_t
 bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role)
 {
-	int             rc = BFA_STATUS_OK;
+	int		rc = BFA_STATUS_OK;
 
-	/*
-	 * Allocate scsi_host for the physical port
-	 */
+	/* Allocate scsi_host for the physical port */
 	if ((bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IM)
 	    && (role & BFA_PORT_ROLE_FCP_IM)) {
 		if (bfad->pport.im_port == NULL) {
@@ -836,6 +855,7 @@ out:
 void
 bfad_uncfg_pport(struct bfad_s *bfad)
 {
+
 	if ((bfad->pport.roles & BFA_PORT_ROLE_FCP_IPFC) && ipfc_enable) {
 		bfad_ipfc_port_delete(bfad, &bfad->pport);
 		bfad->pport.roles &= ~BFA_PORT_ROLE_FCP_IPFC;
@@ -859,9 +879,89 @@ bfad_drv_log_level_set(struct bfad_s *bfad)
 		bfa_log_set_level_all(&bfad->log_data, log_level);
 }
 
- /*
-  *  PCI_entry PCI driver entries * {
-  */
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
+bfad_worker(void *ptr)
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
+
+/*
+ *  PCI_entry PCI driver entries * {
+ */
 
 /**
  * PCI probe entry.
@@ -869,13 +969,10 @@ bfad_drv_log_level_set(struct bfad_s *bfad)
 int
 bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
-	struct bfad_s  *bfad;
-	int             error = -ENODEV, retval;
-	char            buf[16];
+	struct bfad_s	*bfad;
+	int		error = -ENODEV, retval;
 
-	/*
-	 * For single port cards - only claim function 0
-	 */
+	/* For single port cards - only claim function 0 */
 	if ((pdev->device == BFA_PCI_DEVICE_ID_FC_8G1P)
 	    && (PCI_FUNC(pdev->devfn) != 0))
 		return -ENODEV;
@@ -895,15 +992,12 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_alloc_trace_failure;
 	}
 
-	/*
-	 * LOG/TRACE INIT
-	 */
+	/* LOG/TRACE INIT */
 	bfa_trc_init(bfad->trcmod);
 	bfa_trc(bfad, bfad_inst);
 
 	bfad->logmod = &bfad->log_data;
-	sprintf(buf, "%d", bfad_inst);
-	bfa_log_init(bfad->logmod, buf, bfa_os_printf);
+	bfa_log_init(bfad->logmod, (char *)pci_name(pdev), bfa_os_printf);
 
 	bfad_drv_log_level_set(bfad);
 
@@ -933,57 +1027,40 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 	bfad->ref_count = 0;
 	bfad->pport.bfad = bfad;
 
+	bfad->bfad_tsk = kthread_create(bfad_worker, (void *) bfad, "%s",
+						"bfad_worker");
+	if (IS_ERR(bfad->bfad_tsk)) {
+		printk(KERN_INFO "bfad[%d]: Kernel thread"
+				  " creation failed!\n",
+				bfad->inst_no);
+		goto out_kthread_create_failure;
+	}
+
 	retval = bfad_drv_init(bfad);
 	if (retval != BFA_STATUS_OK)
 		goto out_drv_init_failure;
 	if (!(bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
-		printk(KERN_WARNING "bfad%d: hal init failed\n", bfad->inst_no);
+		bfad->bfad_flags |= BFAD_HAL_INIT_FAIL;
+		printk(KERN_WARNING "bfad%d: hal init failed\n",
+					bfad->inst_no);
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
-
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
+	kthread_stop(bfad->bfad_tsk);
+	bfad->bfad_tsk = NULL;
 
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
@@ -1003,11 +1080,16 @@ out:
 void
 bfad_pci_remove(struct pci_dev *pdev)
 {
-	struct bfad_s  *bfad = pci_get_drvdata(pdev);
-	unsigned long   flags;
+	struct bfad_s	      *bfad = pci_get_drvdata(pdev);
+	unsigned long	flags;
 
 	bfa_trc(bfad, bfad->inst_no);
 
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (bfad->bfad_tsk != NULL)
+		kthread_stop(bfad->bfad_tsk);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
 	if ((bfad->bfad_flags & BFAD_DRV_INIT_DONE)
 	    && !(bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
 
@@ -1024,13 +1106,25 @@ bfad_pci_remove(struct pci_dev *pdev)
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
@@ -1041,7 +1135,6 @@ hal_detach:
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	bfad_hal_mem_release(bfad);
 remove_sysfs:
-
 	mutex_lock(&bfad_mutex);
 	bfad_inst--;
 	list_del(&bfad->list_entry);
@@ -1052,28 +1145,27 @@ remove_sysfs:
 	kfree(bfad);
 }
 
-
 static struct pci_device_id bfad_id_table[] = {
 	{
-	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
-	 .device = BFA_PCI_DEVICE_ID_FC_8G2P,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
-	 },
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_FC_8G2P,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
 	{
-	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
-	 .device = BFA_PCI_DEVICE_ID_FC_8G1P,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
-	 },
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_FC_8G1P,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
 	{
-	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
-	 .device = BFA_PCI_DEVICE_ID_CT,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
-	 .class = (PCI_CLASS_SERIAL_FIBER << 8),
-	 .class_mask = ~0,
-	 },
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_CT,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = (PCI_CLASS_SERIAL_FIBER << 8),
+		.class_mask = ~0,
+	},
 
 	{0, 0},
 };
@@ -1090,10 +1182,11 @@ static struct pci_driver bfad_pci_driver = {
 /**
  *  Linux driver module functions
  */
+
 bfa_status_t
 bfad_fc4_module_init(void)
 {
-	int             rc;
+	int		rc;
 
 	rc = bfad_im_module_init();
 	if (rc != BFA_STATUS_OK)
@@ -1118,10 +1211,10 @@ bfad_fc4_module_exit(void)
 /**
  * Driver module init.
  */
-static int      __init
+static int __init
 bfad_init(void)
 {
-	int             error = 0;
+	int		error = 0;
 
 	printk(KERN_INFO "Brocade BFA FC/FCOE SCSI driver - version: %s\n",
 	       BFAD_DRIVER_VERSION);
@@ -1148,7 +1241,7 @@ bfad_init(void)
 	error = pci_register_driver(&bfad_pci_driver);
 
 	if (error) {
-		printk(KERN_WARNING "bfad pci_register_driver failure\n");
+		printk(KERN_WARNING "pci_register_driver failure\n");
 		goto ext;
 	}
 
@@ -1162,7 +1255,7 @@ ext:
 /**
  * Driver module exit.
  */
-static void     __exit
+static void __exit
 bfad_exit(void)
 {
 	pci_unregister_driver(&bfad_pci_driver);
@@ -1180,3 +1273,4 @@ MODULE_AUTHOR("Brocade Communications Systems, Inc.");
 MODULE_VERSION(BFAD_DRIVER_VERSION);
 
 
+
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 9129ae3..7044441 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -120,10 +120,6 @@ bfad_im_get_host_port_id(struct Scsi_Host *shost)
 			bfa_os_hton3b(bfa_fcs_port_get_fcid(port->fcs_port));
 }
 
-
-
-
-
 struct Scsi_Host *
 bfad_os_starget_to_shost(struct scsi_target *starget)
 {
@@ -141,7 +137,7 @@ bfad_im_get_host_port_type(struct Scsi_Host *shost)
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_pport_attr_s attr;
 
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 
 	switch (attr.port_type) {
 	case BFA_PPORT_TYPE_NPORT:
@@ -173,7 +169,7 @@ bfad_im_get_host_port_state(struct Scsi_Host *shost)
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_pport_attr_s attr;
 
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 
 	switch (attr.port_state) {
 	case BFA_PPORT_ST_LINKDOWN:
@@ -210,7 +206,7 @@ bfad_im_get_host_active_fc4s(struct Scsi_Host *shost)
 	       sizeof(fc_host_active_fc4s(shost)));
 
 	if (port->supported_fc4s &
-		(BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
+			(BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
 		fc_host_active_fc4s(shost)[2] = 1;
 
 	if (port->supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
@@ -230,7 +226,7 @@ bfad_im_get_host_speed(struct Scsi_Host *shost)
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_pport_attr_s attr;
 
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 	switch (attr.speed) {
 	case BFA_PPORT_SPEED_8GBPS:
 		fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
@@ -285,7 +281,7 @@ bfad_im_get_stats(struct Scsi_Host *shost)
 	init_completion(&fcomp.comp);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	memset(hstats, 0, sizeof(struct fc_host_statistics));
-	rc = bfa_pport_get_stats(&bfad->bfa,
+	rc = bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
 				     (union bfa_pport_stats_u *) hstats,
 				     bfad_hcb_comp, &fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -312,7 +308,8 @@ bfad_im_reset_stats(struct Scsi_Host *shost)
 
 	init_completion(&fcomp.comp);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	rc = bfa_pport_clear_stats(&bfad->bfa, bfad_hcb_comp, &fcomp);
+	rc = bfa_port_clear_stats(BFA_FCPORT(&bfad->bfa), bfad_hcb_comp,
+					&fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	if (rc != BFA_STATUS_OK)
@@ -420,13 +417,11 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
+	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			ioc_attr.adapter_attr.serial_num);
+	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
+	return snprintf(buf, PAGE_SIZE, "%s\n", serial_num);
 }
 
 static ssize_t
@@ -436,12 +431,11 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc_attr.adapter_attr.model);
+	bfa_get_adapter_model(&bfad->bfa, model);
+	return snprintf(buf, PAGE_SIZE, "%s\n", model);
 }
 
 static ssize_t
@@ -451,13 +445,11 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
+	char model_descr[BFA_ADAPTER_MODEL_DESCR_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			ioc_attr.adapter_attr.model_descr);
+	bfa_get_adapter_model(&bfad->bfa, model_descr);
+	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
 }
 
 static ssize_t
@@ -481,15 +473,14 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
-
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	struct bfad_s *bfad = im_port->bfad;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char fw_ver[BFA_VERSION_LEN];
 
+	bfa_get_adapter_model(&bfad->bfa, model);
+	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
 	return snprintf(buf, PAGE_SIZE, "Brocade %s FV%s DV%s\n",
-			ioc_attr.adapter_attr.model,
-			ioc_attr.adapter_attr.fw_ver, BFAD_DRIVER_VERSION);
+			model, fw_ver, BFAD_DRIVER_VERSION);
 }
 
 static ssize_t
@@ -499,12 +490,11 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
+	char hw_ver[BFA_VERSION_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc_attr.adapter_attr.hw_ver);
+	bfa_get_pci_chip_rev(&bfad->bfa, hw_ver);
+	return snprintf(buf, PAGE_SIZE, "%s\n", hw_ver);
 }
 
 static ssize_t
@@ -521,13 +511,11 @@ bfad_im_optionrom_version_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
+	char optrom_ver[BFA_VERSION_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			ioc_attr.adapter_attr.optrom_ver);
+	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
+	return snprintf(buf, PAGE_SIZE, "%s\n", optrom_ver);
 }
 
 static ssize_t
@@ -537,12 +525,11 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
+	char fw_ver[BFA_VERSION_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc_attr.adapter_attr.fw_ver);
+	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
+	return snprintf(buf, PAGE_SIZE, "%s\n", fw_ver);
 }
 
 static ssize_t
@@ -552,12 +539,10 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s *bfad = im_port->bfad;
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc_attr.adapter_attr.nports);
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			bfa_get_nports(&bfad->bfa));
 }
 
 static ssize_t
@@ -592,6 +577,106 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
 }
 
+static int
+bfad_im_parse_wwn(const char *buf, u8 *wwn)
+{
+	unsigned int i, j;
+	memset(wwn, 0, 8);
+
+	/* Validate and store the new name */
+	for (i = 0, j = 0; i < 16; i++) {
+		if ((*buf >= '0') && (*buf <= '9'))
+			j = ((j << 4) | (*buf++ - '0'));
+		else if ((*buf >= 'a') && (*buf <= 'f'))
+			j = ((j << 4) | ((*buf++ - 'a') + 10));
+		else if ((*buf >= 'A') && (*buf <= 'F'))
+			j = ((j << 4) | ((*buf++ - 'A') + 10));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t
+bfad_im_vport_create(struct device *cdev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfa_port_cfg_s port_cfg;
+	u8 wwn[8];
+	int status;
+
+	memset(&port_cfg, 0, sizeof(port_cfg));
+	status = bfad_im_parse_wwn(&buf[0], wwn);
+	if (status)
+		return status;
+	memcpy(&port_cfg.pwwn, wwn, sizeof(wwn));
+
+	status = bfad_im_parse_wwn(&buf[17], wwn);
+	if (status)
+		return status;
+	memcpy(&port_cfg.nwwn, wwn, sizeof(wwn));
+
+	port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
+	status = bfad_vport_create(bfad, 0, &port_cfg);
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	return count;
+}
+
+static ssize_t
+bfad_im_vport_delete(struct device *cdev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(cdev);
+	struct bfad_im_port_s *im_port =
+		(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	u8 wwn[8];
+	int status;
+	unsigned long flags;
+	struct bfa_fcs_vport_s *fcs_vport;
+	struct bfad_vport_s *bfad_vport;
+	struct completion fcomp;
+
+	status = bfad_im_parse_wwn(&buf[0], wwn);
+	if (status)
+		return status;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, *(wwn_t *)wwn);
+	if (fcs_vport == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return -EINVAL;
+	}
+
+	bfad_vport = fcs_vport->vport_drv;
+	bfad_vport->drv_port.flags |= BFAD_PORT_DELETE;
+	bfad_vport->comp_del = &fcomp;
+	init_completion(bfad_vport->comp_del);
+
+	status = bfa_fcs_vport_delete(fcs_vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	wait_for_completion(bfad_vport->comp_del);
+
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	bfad_os_scsi_host_free(bfad, bfad_vport->drv_port.im_port);
+	kfree(bfad_vport);
+	return count;
+}
+
 static          DEVICE_ATTR(serial_number, S_IRUGO,
 				bfad_im_serial_num_show, NULL);
 static          DEVICE_ATTR(model, S_IRUGO, bfad_im_model_show, NULL);
@@ -613,6 +698,8 @@ static          DEVICE_ATTR(number_of_ports, S_IRUGO,
 static          DEVICE_ATTR(driver_name, S_IRUGO, bfad_im_drv_name_show, NULL);
 static          DEVICE_ATTR(number_of_discovered_ports, S_IRUGO,
 				bfad_im_num_of_discovered_ports_show, NULL);
+static		DEVICE_ATTR(vport_create, S_IWUSR, NULL, bfad_im_vport_create);
+static		DEVICE_ATTR(vport_delete, S_IWUSR, NULL, bfad_im_vport_delete);
 
 struct device_attribute *bfad_im_host_attrs[] = {
 	&dev_attr_serial_number,
@@ -627,6 +714,8 @@ struct device_attribute *bfad_im_host_attrs[] = {
 	&dev_attr_number_of_ports,
 	&dev_attr_driver_name,
 	&dev_attr_number_of_discovered_ports,
+	&dev_attr_vport_create,
+	&dev_attr_vport_delete,
 	NULL,
 };
 
diff --git a/drivers/scsi/bfa/bfad_attr.h b/drivers/scsi/bfa/bfad_attr.h
index 4d3312d..bf01020 100644
--- a/drivers/scsi/bfa/bfad_attr.h
+++ b/drivers/scsi/bfa/bfad_attr.h
@@ -17,9 +17,6 @@
 
 #ifndef __BFAD_ATTR_H__
 #define __BFAD_ATTR_H__
-/**
- *  bfad_attr.h VMware driver configuration interface module.
- */
 
 /**
  *  FC_transport_template FC transport template
@@ -52,12 +49,6 @@ bfad_im_get_starget_port_name(struct scsi_target *starget);
 void
 bfad_im_get_host_port_id(struct Scsi_Host *shost);
 
-/**
- * FC transport template entry, issue a LIP.
- */
-int
-bfad_im_issue_fc_host_lip(struct Scsi_Host *shost);
-
 struct Scsi_Host*
 bfad_os_starget_to_shost(struct scsi_target *starget);
 
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 172c81e..15703b8 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -46,10 +46,9 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "2.0.0.0"
+#define BFAD_DRIVER_VERSION    "2.1.2.1"
 #endif
 
-
 #define BFAD_IRQ_FLAGS IRQF_SHARED
 
 /*
@@ -62,6 +61,9 @@
 #define BFAD_HAL_START_DONE			0x00000010
 #define BFAD_PORT_ONLINE			0x00000020
 #define BFAD_RPORT_ONLINE			0x00000040
+#define BFAD_FCS_INIT_DONE			0x00000080
+#define BFAD_HAL_INIT_FAIL			0x00000100
+#define BFAD_FC4_PROBE_DONE			0x00000200
 
 #define BFAD_PORT_DELETE			0x00000001
 
@@ -137,12 +139,16 @@ struct bfad_cfg_param_s {
 	u32        binding_method;
 };
 
-#define BFAD_AEN_MAX_APPS 8
-struct bfad_aen_file_s {
-	struct list_head  qe;
-	struct bfad_s *bfad;
-	s32 ri;
-	s32 app_id;
+union bfad_tmp_buf {
+	/* From struct bfa_adapter_attr_s */
+	char            manufacturer[BFA_ADAPTER_MFG_NAME_LEN];
+	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
+	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char            fw_ver[BFA_VERSION_LEN];
+	char            optrom_ver[BFA_VERSION_LEN];
+
+	/* From struct bfa_ioc_pci_attr_s */
+	u8         chip_rev[BFA_IOC_CHIP_REV_LEN];  /*  chip revision */
 };
 
 /*
@@ -168,6 +174,7 @@ struct bfad_s {
 	u32        inst_no;	/* BFAD instance number */
 	u32        bfad_flags;
 	spinlock_t      bfad_lock;
+	struct task_struct *bfad_tsk;
 	struct bfad_cfg_param_s cfg_data;
 	struct bfad_msix_s msix_tab[MAX_MSIX_ENTRY];
 	int             nvec;
@@ -183,18 +190,12 @@ struct bfad_s {
 	struct bfa_log_mod_s  *logmod;
 	struct bfa_aen_s      *aen;
 	struct bfa_aen_s       aen_buf;
-	struct bfad_aen_file_s file_buf[BFAD_AEN_MAX_APPS];
-	struct list_head         file_q;
-	struct list_head         file_free_q;
+	void		*file_map[BFA_AEN_MAX_APP];
 	struct bfa_plog_s      plog_buf;
 	int             ref_count;
 	bfa_boolean_t	ipfc_enabled;
+	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
-
-	struct kobject *bfa_kobj;
-	struct kobject *ioc_kobj;
-	struct kobject *pport_kobj;
-	struct kobject *lport_kobj;
 };
 
 /*
@@ -245,7 +246,7 @@ struct bfad_hal_comp {
 do {                                            	\
 	int j;                                  	\
 	(*x)--;    		                	\
-	for (j = 1; j < (sizeof(int) * 8); j <<= 1)     \
+	for (j = 1; j < (sizeof(int) * 8); j <<= 1)	\
 		(*x) = (*x) | (*x) >> j;        	\
 	(*x)++;                  	        	\
 	(*x) = (*x) >> 1;                       	\
@@ -258,6 +259,7 @@ bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
 			       struct bfa_port_cfg_s *port_cfg);
 bfa_status_t    bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role);
 bfa_status_t    bfad_drv_init(struct bfad_s *bfad);
+bfa_status_t	bfad_start_ops(struct bfad_s *bfad);
 void            bfad_drv_start(struct bfad_s *bfad);
 void            bfad_uncfg_pport(struct bfad_s *bfad);
 void            bfad_drv_stop(struct bfad_s *bfad);
@@ -280,6 +282,7 @@ void		bfad_drv_log_level_set(struct bfad_s *bfad);
 bfa_status_t	bfad_fc4_module_init(void);
 void		bfad_fc4_module_exit(void);
 
+int bfad_worker(void *ptr);
 void bfad_pci_remove(struct pci_dev *pdev);
 int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid);
 void bfad_os_rport_online_wait(struct bfad_s *bfad);
diff --git a/drivers/scsi/bfa/bfad_fwimg.c b/drivers/scsi/bfa/bfad_fwimg.c
index 2c2082d..2ad65f2 100644
--- a/drivers/scsi/bfa/bfad_fwimg.c
+++ b/drivers/scsi/bfa/bfad_fwimg.c
@@ -41,6 +41,8 @@ u32 *bfi_image_cb;
 
 #define	BFAD_FW_FILE_CT	"ctfw.bin"
 #define	BFAD_FW_FILE_CB	"cbfw.bin"
+MODULE_FIRMWARE(BFAD_FW_FILE_CT);
+MODULE_FIRMWARE(BFAD_FW_FILE_CB);
 
 u32 *
 bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index ae3a068..f3e8282 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -43,11 +43,11 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 	struct bfad_s         *bfad = drv;
 	struct bfad_itnim_data_s *itnim_data;
 	struct bfad_itnim_s *itnim;
+	u8         host_status = DID_OK;
 
 	switch (io_status) {
 	case BFI_IOIM_STS_OK:
 		bfa_trc(bfad, scsi_status);
-		cmnd->result = ScsiResult(DID_OK, scsi_status);
 		scsi_set_resid(cmnd, 0);
 
 		if (sns_len > 0) {
@@ -56,8 +56,18 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 				sns_len = SCSI_SENSE_BUFFERSIZE;
 			memcpy(cmnd->sense_buffer, sns_info, sns_len);
 		}
-		if (residue > 0)
+		if (residue > 0) {
+			bfa_trc(bfad, residue);
 			scsi_set_resid(cmnd, residue);
+			if (!sns_len && (scsi_status == SAM_STAT_GOOD) &&
+				(scsi_bufflen(cmnd) - residue) <
+					cmnd->underflow) {
+				bfa_trc(bfad, 0);
+				host_status = DID_ERROR;
+			}
+		}
+		cmnd->result = ScsiResult(host_status, scsi_status);
+
 		break;
 
 	case BFI_IOIM_STS_ABORTED:
@@ -167,17 +177,15 @@ bfad_im_info(struct Scsi_Host *shost)
 	static char     bfa_buf[256];
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfa_ioc_attr_s  ioc_attr;
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	bfa_get_adapter_model(&bfad->bfa, model);
 
 	memset(bfa_buf, 0, sizeof(bfa_buf));
 	snprintf(bfa_buf, sizeof(bfa_buf),
 		 "Brocade FC/FCOE Adapter, " "model: %s hwpath: %s driver: %s",
-		 ioc_attr.adapter_attr.model, bfad->pci_name,
-		 BFAD_DRIVER_VERSION);
+		 model, bfad->pci_name, BFAD_DRIVER_VERSION);
 	return bfa_buf;
 }
 
@@ -501,16 +509,6 @@ void bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim)
 }
 
 /**
- * Path TOV processing begin notification -- dummy for linux
- */
-void
-bfa_fcb_itnim_tov_begin(struct bfad_itnim_s *itnim)
-{
-}
-
-
-
-/**
  * Allocate a Scsi_Host for a port.
  */
 int
@@ -691,9 +689,6 @@ bfad_im_probe_undo(struct bfad_s *bfad)
 	}
 }
 
-
-
-
 int
 bfad_os_scsi_add_host(struct Scsi_Host *shost, struct bfad_im_port_s *im_port,
 			struct bfad_s *bfad)
@@ -830,7 +825,6 @@ bfad_im_module_init(void)
 		fc_attach_transport(&bfad_im_fc_function_template);
 	if (!bfad_im_scsi_transport_template)
 		return BFA_STATUS_ENOMEM;
-
 	return BFA_STATUS_OK;
 }
 
@@ -893,8 +887,6 @@ bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 }
 
 
-
-
 struct bfad_itnim_s *
 bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id)
 {
@@ -931,10 +923,9 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	struct Scsi_Host *host = im_port->shost;
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfad_port_s    *port = im_port->port;
-	union attr {
-		struct bfa_pport_attr_s pattr;
-		struct bfa_ioc_attr_s  ioc_attr;
-	} attr;
+	struct bfa_pport_attr_s pattr;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char fw_ver[BFA_VERSION_LEN];
 
 	fc_host_node_name(host) =
 		bfa_os_htonll((bfa_fcs_port_get_nwwn(port->fcs_port)));
@@ -948,26 +939,24 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	if (bfad_supported_fc4s & (BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
 		/* For FCP type 0x08 */
 		fc_host_supported_fc4s(host)[2] = 1;
-	if (bfad_supported_fc4s | BFA_PORT_ROLE_FCP_IPFC)
+	if (bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
 		/* For LLC/SNAP type 0x05 */
 		fc_host_supported_fc4s(host)[3] = 0x20;
 	/* For fibre channel services type 0x20 */
 	fc_host_supported_fc4s(host)[7] = 1;
 
-	memset(&attr.ioc_attr, 0, sizeof(attr.ioc_attr));
-	bfa_get_attr(&bfad->bfa, &attr.ioc_attr);
+	bfa_get_adapter_model(&bfad->bfa, model);
+	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
 	sprintf(fc_host_symbolic_name(host), "Brocade %s FV%s DV%s",
-		attr.ioc_attr.adapter_attr.model,
-		attr.ioc_attr.adapter_attr.fw_ver, BFAD_DRIVER_VERSION);
+		model, fw_ver, BFAD_DRIVER_VERSION);
 
 	fc_host_supported_speeds(host) = 0;
 	fc_host_supported_speeds(host) |=
 		FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT | FC_PORTSPEED_2GBIT |
 		FC_PORTSPEED_1GBIT;
 
-	memset(&attr.pattr, 0, sizeof(attr.pattr));
-	bfa_pport_get_attr(&bfad->bfa, &attr.pattr);
-	fc_host_maxframe_size(host) = attr.pattr.pport_cfg.maxfrsize;
+	bfa_fcport_get_attr(&bfad->bfa, &pattr);
+	fc_host_maxframe_size(host) = pattr.pport_cfg.maxfrsize;
 }
 
 static void
@@ -1155,7 +1144,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	hal_io = bfa_ioim_alloc(&bfad->bfa, (struct bfad_ioim_s *) cmnd,
 				    itnim->bfa_itnim, sg_cnt);
 	if (!hal_io) {
-		printk(KERN_WARNING "hal_io failure\n");
+		bfa_trc(bfad, 0);
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		scsi_dma_unmap(cmnd);
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1203,28 +1192,26 @@ int
 bfad_os_get_linkup_delay(struct bfad_s *bfad)
 {
 
-	u8         nwwns = 0;
+	uint8_t         nwwns = 0;
 	wwn_t           *wwns;
-	int             ldelay;
+	int 		linkup_delay;
 
 	/*
 	 * Querying for the boot target port wwns
 	 * -- read from boot information in flash.
 	 * If nwwns > 0 => boot over SAN and set bfa_linkup_delay = 30
-	 * else => local boot machine set bfa_linkup_delay = 10
+	 * else => local boot machine set bfa_linkup_delay = 0
 	 */
 
 	bfa_iocfc_get_bootwwns(&bfad->bfa, &nwwns, &wwns);
 
 	if (nwwns > 0) {
-		/* If boot over SAN; linkup_delay = 30sec */
-		ldelay = 30;
+		/* If Boot over SAN set linkup_delay = 30sec */
+		linkup_delay = 30;
 	} else {
-		/* If local boot; linkup_delay = 10sec */
-		ldelay = 0;
+		/* If local boot; no linkup_delay */
+		linkup_delay = 0;
 	}
 
-	return ldelay;
+	return linkup_delay;
 }
-
-
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 189a5b2..6fc8907 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -23,7 +23,6 @@
 
 #define FCPI_NAME " fcpim"
 
-void bfad_flags_set(struct bfad_s *bfad, u32 flags);
 bfa_status_t bfad_im_module_init(void);
 void bfad_im_module_exit(void);
 bfa_status_t bfad_im_probe(struct bfad_s *bfad);
@@ -117,7 +116,7 @@ struct bfad_fcp_binding {
 struct bfad_im_s {
 	struct bfad_s         *bfad;
 	struct workqueue_struct *drv_workq;
-	char   drv_workq_name[BFAD_KOBJ_NAME_LEN];
+	char            drv_workq_name[BFAD_KOBJ_NAME_LEN];
 };
 
 struct Scsi_Host *bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port,
@@ -126,7 +125,6 @@ bfa_status_t bfad_os_thread_workq(struct bfad_s *bfad);
 void bfad_os_destroy_workq(struct bfad_im_s *im);
 void bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv);
 void bfad_os_fc_host_init(struct bfad_im_port_s *im_port);
-void bfad_os_init_work(struct bfad_im_port_s *im_port);
 void bfad_os_scsi_host_free(struct bfad_s *bfad,
 				 struct bfad_im_port_s *im_port);
 void bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim,
@@ -136,9 +134,6 @@ struct bfad_itnim_s *bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id);
 int bfad_os_scsi_add_host(struct Scsi_Host *shost,
 		struct bfad_im_port_s *im_port, struct bfad_s *bfad);
 
-/*
- * scsi_host_template entries
- */
 void bfad_im_itnim_unmap(struct bfad_im_port_s  *im_port,
 			 struct bfad_itnim_s *itnim);
 
diff --git a/drivers/scsi/bfa/bfad_intr.c b/drivers/scsi/bfa/bfad_intr.c
index 7de8832..422e1d5 100644
--- a/drivers/scsi/bfa/bfad_intr.c
+++ b/drivers/scsi/bfa/bfad_intr.c
@@ -23,8 +23,11 @@ BFA_TRC_FILE(LDRV, INTR);
 /**
  *  bfa_isr BFA driver interrupt functions
  */
-static int msix_disable;
-module_param(msix_disable, int, S_IRUGO | S_IWUSR);
+static int msix_disable_cb;
+static int msix_disable_ct;
+module_param(msix_disable_cb, int, S_IRUGO | S_IWUSR);
+module_param(msix_disable_ct, int, S_IRUGO | S_IWUSR);
+
 /**
  * Line based interrupt handler.
  */
@@ -141,6 +144,7 @@ bfad_setup_intr(struct bfad_s *bfad)
 	int error = 0;
 	u32 mask = 0, i, num_bit = 0, max_bit = 0;
 	struct msix_entry msix_entries[MAX_MSIX_ENTRY];
+	struct pci_dev *pdev = bfad->pcidev;
 
 	/* Call BFA to get the msix map for this PCI function.  */
 	bfa_msix_getvecs(&bfad->bfa, &mask, &num_bit, &max_bit);
@@ -148,7 +152,9 @@ bfad_setup_intr(struct bfad_s *bfad)
 	/* Set up the msix entry table */
 	bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
 
-	if (!msix_disable) {
+	if ((pdev->device == BFA_PCI_DEVICE_ID_CT && !msix_disable_ct) ||
+	    (pdev->device != BFA_PCI_DEVICE_ID_CT && !msix_disable_cb)) {
+
 		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
 		if (error) {
 			/*
@@ -209,5 +215,3 @@ bfad_remove_intr(struct bfad_s *bfad)
 		free_irq(bfad->pcidev->irq, bfad);
 	}
 }
-
-
diff --git a/drivers/scsi/bfa/bfad_os.c b/drivers/scsi/bfa/bfad_os.c
index faf47b4..40145a1 100644
--- a/drivers/scsi/bfa/bfad_os.c
+++ b/drivers/scsi/bfa/bfad_os.c
@@ -46,5 +46,3 @@ bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
 
 	printk(tmp);
 }
-
-
-- 
1.6.5.2

