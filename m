From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.18-rc5
Date: Fri, 20 Jul 2018 11:30:13 -0700
Message-ID: <1532111413.10292.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A set of 8 obvious fixes.  Three (2 qla2xxx and the cxlflash oopses)
are regressions, two from 4.17 and one from the merge window.  The hpsa
change is user visible, but it fixes an error users have complained
about.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chuck Anderson (1):
      scsi: qla2xxx: Fix NULL pointer dereference for fcport search

Cédric Le Goater (1):
      scsi: cxlflash: fix assignment of the backend operations

Damien Le Moal (1):
      scsi: sd_zbc: Fix variable type and bogus comment

Don Brace (1):
      scsi: hpsa: correct enclosure sas address

Manish Rangankar (1):
      scsi: qedi: Send driver state to MFW

Quinn Tran (1):
      scsi: qla2xxx: Fix inconsistent DMA mem alloc/free

Saurav Kashyap (1):
      scsi: qedf: Send the driver state to MFW

himanshu.madhani@cavium.com (1):
      scsi: qla2xxx: Fix kernel crash due to late workqueue allocation

and the diffstat:

 drivers/scsi/cxlflash/main.h    |  4 ++--
 drivers/scsi/hpsa.c             | 25 +++++++++++++++++++++----
 drivers/scsi/hpsa.h             |  1 +
 drivers/scsi/qedf/qedf_main.c   | 12 ++++++++++++
 drivers/scsi/qedi/qedi_main.c   | 11 +++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |  2 ++
 drivers/scsi/qla2xxx/qla_gs.c   | 40 ++++++++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++++------
 drivers/scsi/qla2xxx/qla_os.c   |  4 ++--
 drivers/scsi/sd_zbc.c           |  5 +++--
 10 files changed, 88 insertions(+), 30 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 2a3977823812..a39be94d110c 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -107,12 +107,12 @@ cxlflash_assign_ops(struct dev_dependent_vals *ddv)
 {
 	const struct cxlflash_backend_ops *ops = NULL;
 
-#ifdef CONFIG_OCXL
+#ifdef CONFIG_OCXL_BASE
 	if (ddv->flags & CXLFLASH_OCXL_DEV)
 		ops = &cxlflash_ocxl_ops;
 #endif
 
-#ifdef CONFIG_CXL
+#ifdef CONFIG_CXL_BASE
 	if (!(ddv->flags & CXLFLASH_OCXL_DEV))
 		ops = &cxlflash_cxl_ops;
 #endif
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 15c7f3b6f35e..58bb70b886d7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3440,11 +3440,11 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
 	u16 bmic_device_index = 0;
 
-	bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
-
-	encl_dev->sas_address =
+	encl_dev->eli =
 		hpsa_get_enclosure_logical_identifier(h, scsi3addr);
 
+	bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
+
 	if (encl_dev->target == -1 || encl_dev->lun == -1) {
 		rc = IO_OK;
 		goto out;
@@ -9697,7 +9697,24 @@ hpsa_sas_get_linkerrors(struct sas_phy *phy)
 static int
 hpsa_sas_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
 {
-	*identifier = rphy->identify.sas_address;
+	struct Scsi_Host *shost = phy_to_shost(rphy);
+	struct ctlr_info *h;
+	struct hpsa_scsi_dev_t *sd;
+
+	if (!shost)
+		return -ENXIO;
+
+	h = shost_to_hba(shost);
+
+	if (!h)
+		return -ENXIO;
+
+	sd = hpsa_find_device_by_sas_rphy(h, rphy);
+	if (!sd)
+		return -ENXIO;
+
+	*identifier = sd->eli;
+
 	return 0;
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fb9f5e7f8209..59e023696fff 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -68,6 +68,7 @@ struct hpsa_scsi_dev_t {
 #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
 	u64 sas_address;
+	u64 eli;			/* from report diags. */
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
 	unsigned char rev;		/* byte 2 of inquiry data */
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 90394cef0f41..0a5dd5595dd3 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3295,6 +3295,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 	init_completion(&qedf->flogi_compl);
 
+	status = qed_ops->common->update_drv_state(qedf->cdev, true);
+	if (status)
+		QEDF_ERR(&(qedf->dbg_ctx),
+			"Failed to send drv state to MFW.\n");
+
 	memset(&link_params, 0, sizeof(struct qed_link_params));
 	link_params.link_up = true;
 	status = qed_ops->common->set_link(qedf->cdev, &link_params);
@@ -3343,6 +3348,7 @@ static int qedf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void __qedf_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedf_ctx *qedf;
+	int rc;
 
 	if (!pdev) {
 		QEDF_ERR(NULL, "pdev is NULL.\n");
@@ -3437,6 +3443,12 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 		qed_ops->common->set_power_state(qedf->cdev, PCI_D0);
 		pci_set_drvdata(pdev, NULL);
 	}
+
+	rc = qed_ops->common->update_drv_state(qedf->cdev, false);
+	if (rc)
+		QEDF_ERR(&(qedf->dbg_ctx),
+			"Failed to send drv state to MFW.\n");
+
 	qed_ops->common->slowpath_stop(qedf->cdev);
 	qed_ops->common->remove(qedf->cdev);
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cf274a79e77a..091ec1207bea 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2273,6 +2273,7 @@ static int qedi_setup_boot_info(struct qedi_ctx *qedi)
 static void __qedi_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
+	int rval;
 
 	if (qedi->tmf_thread) {
 		flush_workqueue(qedi->tmf_thread);
@@ -2302,6 +2303,10 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	if (mode == QEDI_MODE_NORMAL)
 		qedi_free_iscsi_pf_param(qedi);
 
+	rval = qedi_ops->common->update_drv_state(qedi->cdev, false);
+	if (rval)
+		QEDI_ERR(&qedi->dbg_ctx, "Failed to send drv state to MFW\n");
+
 	if (!test_bit(QEDI_IN_OFFLINE, &qedi->flags)) {
 		qedi_ops->common->slowpath_stop(qedi->cdev);
 		qedi_ops->common->remove(qedi->cdev);
@@ -2576,6 +2581,12 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		if (qedi_setup_boot_info(qedi))
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "No iSCSI boot target configured\n");
+
+		rc = qedi_ops->common->update_drv_state(qedi->cdev, true);
+		if (rc)
+			QEDI_ERR(&qedi->dbg_ctx,
+				 "Failed to send drv state to MFW\n");
+
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9442e18aef6f..0f94b1d62d3f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -361,6 +361,8 @@ struct ct_arg {
 	dma_addr_t	rsp_dma;
 	u32		req_size;
 	u32		rsp_size;
+	u32		req_allocated_size;
+	u32		rsp_allocated_size;
 	void		*req;
 	void		*rsp;
 	port_id_t	id;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 4bc2b66b299f..2c35b0b2baa0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -556,7 +556,7 @@ static void qla2x00_async_sns_sp_done(void *s, int rc)
 		/* please ignore kernel warning. otherwise, we have mem leak. */
 		if (sp->u.iocb_cmd.u.ctarg.req) {
 			dma_free_coherent(&vha->hw->pdev->dev,
-			    sizeof(struct ct_sns_pkt),
+			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 			    sp->u.iocb_cmd.u.ctarg.req,
 			    sp->u.iocb_cmd.u.ctarg.req_dma);
 			sp->u.iocb_cmd.u.ctarg.req = NULL;
@@ -564,7 +564,7 @@ static void qla2x00_async_sns_sp_done(void *s, int rc)
 
 		if (sp->u.iocb_cmd.u.ctarg.rsp) {
 			dma_free_coherent(&vha->hw->pdev->dev,
-			    sizeof(struct ct_sns_pkt),
+			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 			    sp->u.iocb_cmd.u.ctarg.rsp,
 			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
@@ -617,6 +617,7 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.req) {
 		ql_log(ql_log_warn, vha, 0xd041,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -627,6 +628,7 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
 	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd042,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -712,6 +714,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.req) {
 		ql_log(ql_log_warn, vha, 0xd041,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -722,6 +725,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd042,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -802,6 +806,7 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.req) {
 		ql_log(ql_log_warn, vha, 0xd041,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -812,6 +817,7 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd042,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -909,6 +915,7 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.req) {
 		ql_log(ql_log_warn, vha, 0xd041,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -919,6 +926,7 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
 	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd042,
 		    "%s: Failed to allocate ct_sns request.\n",
@@ -3388,14 +3396,14 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
 {
 	if (sp->u.iocb_cmd.u.ctarg.req) {
 		dma_free_coherent(&vha->hw->pdev->dev,
-			sizeof(struct ct_sns_pkt),
+			sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 			sp->u.iocb_cmd.u.ctarg.req,
 			sp->u.iocb_cmd.u.ctarg.req_dma);
 		sp->u.iocb_cmd.u.ctarg.req = NULL;
 	}
 	if (sp->u.iocb_cmd.u.ctarg.rsp) {
 		dma_free_coherent(&vha->hw->pdev->dev,
-			sizeof(struct ct_sns_pkt),
+			sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 			sp->u.iocb_cmd.u.ctarg.rsp,
 			sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
@@ -3596,14 +3604,14 @@ static void qla2x00_async_gpnid_sp_done(void *s, int res)
 		/* please ignore kernel warning. otherwise, we have mem leak. */
 		if (sp->u.iocb_cmd.u.ctarg.req) {
 			dma_free_coherent(&vha->hw->pdev->dev,
-				sizeof(struct ct_sns_pkt),
+				sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 				sp->u.iocb_cmd.u.ctarg.req,
 				sp->u.iocb_cmd.u.ctarg.req_dma);
 			sp->u.iocb_cmd.u.ctarg.req = NULL;
 		}
 		if (sp->u.iocb_cmd.u.ctarg.rsp) {
 			dma_free_coherent(&vha->hw->pdev->dev,
-				sizeof(struct ct_sns_pkt),
+				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 				sp->u.iocb_cmd.u.ctarg.rsp,
 				sp->u.iocb_cmd.u.ctarg.rsp_dma);
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
@@ -3654,6 +3662,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 		sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
 		GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.req) {
 		ql_log(ql_log_warn, vha, 0xd041,
 		    "Failed to allocate ct_sns request.\n");
@@ -3663,6 +3672,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
 		sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
 		GFP_KERNEL);
+	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
 	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd042,
 		    "Failed to allocate ct_sns request.\n");
@@ -4142,14 +4152,14 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 			 */
 			if (sp->u.iocb_cmd.u.ctarg.req) {
 				dma_free_coherent(&vha->hw->pdev->dev,
-				    sizeof(struct ct_sns_pkt),
+				    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 				    sp->u.iocb_cmd.u.ctarg.req,
 				    sp->u.iocb_cmd.u.ctarg.req_dma);
 				sp->u.iocb_cmd.u.ctarg.req = NULL;
 			}
 			if (sp->u.iocb_cmd.u.ctarg.rsp) {
 				dma_free_coherent(&vha->hw->pdev->dev,
-				    sizeof(struct ct_sns_pkt),
+				    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 				    sp->u.iocb_cmd.u.ctarg.rsp,
 				    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 				sp->u.iocb_cmd.u.ctarg.rsp = NULL;
@@ -4179,14 +4189,14 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		/* please ignore kernel warning. Otherwise, we have mem leak. */
 		if (sp->u.iocb_cmd.u.ctarg.req) {
 			dma_free_coherent(&vha->hw->pdev->dev,
-			    sizeof(struct ct_sns_pkt),
+			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 			    sp->u.iocb_cmd.u.ctarg.req,
 			    sp->u.iocb_cmd.u.ctarg.req_dma);
 			sp->u.iocb_cmd.u.ctarg.req = NULL;
 		}
 		if (sp->u.iocb_cmd.u.ctarg.rsp) {
 			dma_free_coherent(&vha->hw->pdev->dev,
-			    sizeof(struct ct_sns_pkt),
+			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 			    sp->u.iocb_cmd.u.ctarg.rsp,
 			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
@@ -4281,14 +4291,14 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 done_free_sp:
 	if (sp->u.iocb_cmd.u.ctarg.req) {
 		dma_free_coherent(&vha->hw->pdev->dev,
-		    sizeof(struct ct_sns_pkt),
+		    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 		    sp->u.iocb_cmd.u.ctarg.req,
 		    sp->u.iocb_cmd.u.ctarg.req_dma);
 		sp->u.iocb_cmd.u.ctarg.req = NULL;
 	}
 	if (sp->u.iocb_cmd.u.ctarg.rsp) {
 		dma_free_coherent(&vha->hw->pdev->dev,
-		    sizeof(struct ct_sns_pkt),
+		    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 		    sp->u.iocb_cmd.u.ctarg.rsp,
 		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
@@ -4349,6 +4359,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 		sp->u.iocb_cmd.u.ctarg.req = dma_zalloc_coherent(
 			&vha->hw->pdev->dev, sizeof(struct ct_sns_pkt),
 			&sp->u.iocb_cmd.u.ctarg.req_dma, GFP_KERNEL);
+		sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
 		if (!sp->u.iocb_cmd.u.ctarg.req) {
 			ql_log(ql_log_warn, vha, 0xffff,
 			    "Failed to allocate ct_sns request.\n");
@@ -4366,6 +4377,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 		sp->u.iocb_cmd.u.ctarg.rsp = dma_zalloc_coherent(
 			&vha->hw->pdev->dev, rspsz,
 			&sp->u.iocb_cmd.u.ctarg.rsp_dma, GFP_KERNEL);
+		sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
 		if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 			ql_log(ql_log_warn, vha, 0xffff,
 			    "Failed to allocate ct_sns request.\n");
@@ -4425,14 +4437,14 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 done_free_sp:
 	if (sp->u.iocb_cmd.u.ctarg.req) {
 		dma_free_coherent(&vha->hw->pdev->dev,
-		    sizeof(struct ct_sns_pkt),
+		    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
 		    sp->u.iocb_cmd.u.ctarg.req,
 		    sp->u.iocb_cmd.u.ctarg.req_dma);
 		sp->u.iocb_cmd.u.ctarg.req = NULL;
 	}
 	if (sp->u.iocb_cmd.u.ctarg.rsp) {
 		dma_free_coherent(&vha->hw->pdev->dev,
-		    sizeof(struct ct_sns_pkt),
+		    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 		    sp->u.iocb_cmd.u.ctarg.rsp,
 		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7b675243bd16..db0e3279e07a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -591,12 +591,14 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				conflict_fcport =
 					qla2x00_find_fcport_by_wwpn(vha,
 					    e->port_name, 0);
-				ql_dbg(ql_dbg_disc, vha, 0x20e6,
-				    "%s %d %8phC post del sess\n",
-				    __func__, __LINE__,
-				    conflict_fcport->port_name);
-				qlt_schedule_sess_for_deletion
-					(conflict_fcport);
+				if (conflict_fcport) {
+					qlt_schedule_sess_for_deletion
+						(conflict_fcport);
+					ql_dbg(ql_dbg_disc, vha, 0x20e6,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    conflict_fcport->port_name);
+				}
 			}
 
 			/* FW already picked this loop id for another fcport */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e881fce7477a..9f309e572be4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3180,6 +3180,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "req->req_q_in=%p req->req_q_out=%p rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
+	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+
 	if (ha->isp_ops->initialize_adapter(base_vha)) {
 		ql_log(ql_log_fatal, base_vha, 0x00d6,
 		    "Failed to initialize adapter - Adapter flags %x.\n",
@@ -3216,8 +3218,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
-	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
-
 	if (ha->mqenable) {
 		bool mq = false;
 		bool startit = false;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a14fef11776e..2bf3bf73886e 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -391,7 +391,8 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
  * Check that all zones of the device are equal. The last zone can however
  * be smaller. The zone size must also be a power of two number of LBAs.
  *
- * Returns the zone size in bytes upon success or an error code upon failure.
+ * Returns the zone size in number of blocks upon success or an error code
+ * upon failure.
  */
 static s64 sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
@@ -401,7 +402,7 @@ static s64 sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	unsigned char *rec;
 	unsigned int buf_len;
 	unsigned int list_length;
-	int ret;
+	s64 ret;
 	u8 same;
 
 	/* Get a buffer */
