From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 3/6] qla2xxx: remove obvious warnings
Date: Thu, 15 Mar 2012 15:06:39 -0400
Message-ID: <20120315190639.GD7685@logfs.org>
References: <20120315190512.GB7685@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120315190512.GB7685@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Get rid of a bunch of write-only variables.  In a number of cases I
suspect actual bugs to be present, so I left all of those for a second
look.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/qla_attr.c   |    2 --
 drivers/scsi/qla2xxx/qla_bsg.c    |    2 --
 drivers/scsi/qla2xxx/qla_dbg.c    |    9 ---------
 drivers/scsi/qla2xxx/qla_init.c   |    2 --
 drivers/scsi/qla2xxx/qla_iocb.c   |   17 ++---------------
 drivers/scsi/qla2xxx/qla_isr.c    |    2 --
 drivers/scsi/qla2xxx/qla_mbx.c    |    4 ----
 drivers/scsi/qla2xxx/qla_mid.c    |    3 +--
 drivers/scsi/qla2xxx/qla_nx.c     |    9 +++------
 drivers/scsi/qla2xxx/qla_os.c     |    8 +-------
 drivers/scsi/qla2xxx/qla_target.c |    8 ++------
 11 files changed, 9 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e5dd55c..79a4614 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -826,7 +826,6 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
-	uint16_t actual_size;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count > DCBX_TLV_DATA_SIZE)
 		return 0;
@@ -843,7 +842,6 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 	}
 
 do_read:
-	actual_size = 0;
 	memset(ha->dcbx_tlv, 0, DCBX_TLV_DATA_SIZE);
 
 	rval = qla2x00_get_dcbx_params(vha, ha->dcbx_tlv_dma,
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8b641a8..1ffd345 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1638,13 +1638,11 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 {
 	int ret = -EINVAL;
 	struct fc_rport *rport;
-	fc_port_t *fcport = NULL;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *vha;
 
 	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
-		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index eaffa0a..df46a76 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -790,7 +790,6 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -798,14 +797,12 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla24xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	if (IS_QLA82XX(ha))
 		return;
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 
 	if (!hardware_locked)
@@ -1031,7 +1028,6 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1039,12 +1035,10 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla25xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 
 	if (!hardware_locked)
@@ -1343,7 +1337,6 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1351,12 +1344,10 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla81xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 
 	if (!hardware_locked)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 65d994f..551ecfa 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3657,12 +3657,10 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
     uint16_t *next_loopid)
 {
 	int	rval;
-	int	retry;
 	uint8_t opts;
 	struct qla_hw_data *ha = vha->hw;
 
 	rval = QLA_SUCCESS;
-	retry = 0;
 
 	if (IS_ALOGIO_CAPABLE(ha)) {
 		if (fcport->flags & FCF_ASYNC_SENT)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d3a65e0..dc65594 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -313,7 +313,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 int
 qla2x00_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
@@ -331,7 +331,6 @@ qla2x00_start_scsi(srb_t *sp)
 	char		tag[2];
 
 	/* Setup device pointers. */
-	ret = 0;
 	vha = sp->fcport->vha;
 	ha = vha->hw;
 	reg = &ha->iobase->isp;
@@ -736,7 +735,6 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
-	struct req_que *req;
 
 	cmd = sp->cmd;
 
@@ -751,7 +749,6 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = vha->req;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -1224,8 +1221,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	uint32_t		*cur_dsd, *fcp_dl;
 	scsi_qla_host_t		*vha;
 	struct scsi_cmnd	*cmd;
-	struct scatterlist	*cur_seg;
-	int			sgc;
 	uint32_t		total_bytes = 0;
 	uint32_t		data_bytes;
 	uint32_t		dif_bytes;
@@ -1242,7 +1237,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	cmd = sp->cmd;
 
-	sgc = 0;
 	/* Update entry type to indicate Command Type CRC_2 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
 	    __constant_cpu_to_le32(COMMAND_TYPE_CRC_2);
@@ -1421,7 +1415,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	if (bundling && tot_prot_dsds) {
 		/* Walks dif segments */
-		cur_seg = scsi_prot_sglist(cmd);
 		cmd_pkt->control_flags |=
 			__constant_cpu_to_le16(CF_DIF_SEG_DESCR_ENABLE);
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
@@ -1446,7 +1439,7 @@ crc_queuing_error:
 int
 qla24xx_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -1463,8 +1456,6 @@ qla24xx_start_scsi(srb_t *sp)
 	char		tag[2];
 
 	/* Setup device pointers. */
-	ret = 0;
-
 	qla25xx_set_que(sp, &rsp);
 	req = vha->req;
 
@@ -2122,7 +2113,6 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 	int loop_iterartion = 0;
-	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
 
 	memset(ct_iocb, 0, sizeof(ms_iocb_entry_t));
@@ -2172,7 +2162,6 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
 			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
 			avail_dsds = 5;
-			cont_iocb_prsnt = 1;
 			entry_count++;
 		}
 
@@ -2197,7 +2186,6 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
         scsi_qla_host_t *vha = sp->fcport->vha;
 	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 	int loop_iterartion = 0;
-	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
 
 	ct_iocb->entry_type = CT_IOCB_TYPE;
@@ -2243,7 +2231,6 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
 			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
 			avail_dsds = 5;
-			cont_iocb_prsnt = 1;
 			entry_count++;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0ca594b..af23849 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1281,7 +1281,6 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 {
 	const char func[] = "TMF-IOCB";
 	const char *type;
-	fc_port_t *fcport;
 	srb_t *sp;
 	struct srb_iocb *iocb;
 	struct srb_ctx *ctx;
@@ -1295,7 +1294,6 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	ctx = sp->ctx;
 	iocb = ctx->u.iocb_cmd;
 	type = ctx->name;
-	fcport = sp->fcport;
 
 	if (sts->entry_status) {
 		ql_log(ql_log_warn, vha, 0x5038,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ab37dee..0092389 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1669,7 +1669,6 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	uint32_t	iop[2];
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
-	struct rsp_que *rsp;
 
 	ql_dbg(ql_dbg_mbx, vha, 0x1061, "Entered %s.\n", __func__);
 
@@ -1677,7 +1676,6 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
-	rsp = req->rsp;
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
@@ -1937,7 +1935,6 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	dma_addr_t	lg_dma;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
-	struct rsp_que *rsp;
 
 	ql_dbg(ql_dbg_mbx, vha, 0x106d, "Entered %s.\n", __func__);
 
@@ -1953,7 +1950,6 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
-	rsp = req->rsp;
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
 	lg->handle = MAKE_HANDLE(req->id, lg->handle);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2d1e5b6..dd7810e 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -369,7 +369,6 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 void
 qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 {
-	int ret;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
 	unsigned long flags = 0;
@@ -390,7 +389,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-			ret = qla2x00_do_dpc_vp(vp);
+			qla2x00_do_dpc_vp(vp);
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 94bded5..d6f34c6 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1738,10 +1738,9 @@ int
 qla82xx_pci_config(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	int ret;
 
 	pci_set_master(ha->pdev);
-	ret = pci_set_mwi(ha->pdev);
+	pci_set_mwi(ha->pdev);
 	ha->chip_revision = ha->pdev->revision;
 	ql_dbg(ql_dbg_init, vha, 0x0043,
 	    "Chip revision:%ld.\n",
@@ -2664,7 +2663,7 @@ qla82xx_calc_dsd_lists(uint16_t dsds)
 int
 qla82xx_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
@@ -2685,7 +2684,6 @@ qla82xx_start_scsi(srb_t *sp)
 	char		tag[2];
 
 	/* Setup device pointers. */
-	ret = 0;
 	reg = &ha->iobase->isp82;
 	cmd = sp->cmd;
 	req = vha->req;
@@ -3158,7 +3156,7 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 {
 	int ret;
 	uint32_t liter;
-	uint32_t sec_mask, rest_addr;
+	uint32_t rest_addr;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	int page_mode = 0;
@@ -3180,7 +3178,6 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 	}
 
 	rest_addr = ha->fdt_block_size - 1;
-	sec_mask = ~rest_addr;
 
 	ret = qla82xx_unprotect_flash(ha);
 	if (ret) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 21885ee..0df52bf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -925,7 +925,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
@@ -942,9 +941,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return ret;
 	ret = SUCCESS;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
-
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp) {
@@ -2624,14 +2620,12 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
-		struct Scsi_Host *scsi_host;
-
 		spin_lock_irqsave(&ha->vport_slock, flags);
 
 		BUG_ON(base_vha->list.next == &ha->vp_list);
 		/* This assumes first entry in ha->vp_list is always base vha */
 		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
-		scsi_host = scsi_host_get(vha->host);
+		scsi_host_get(vha->host);
 
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7cb7c7e..60bc0ed 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2422,7 +2422,6 @@ static void qla_tgt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handl
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct se_cmd *se_cmd;
-	struct target_core_fabric_ops *tfo;
 	struct qla_tgt_cmd *cmd;
 
 	ql_dbg(ql_dbg_tgt_pkt, vha, 0xe206, "qla_target(%d): handle(ctio %p status"
@@ -2444,7 +2443,6 @@ static void qla_tgt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handl
 		return;
 	}
 	se_cmd = &cmd->se_cmd;
-	tfo = se_cmd->se_tfo;
 
 	if (cmd->sg_mapped)
 		qla_tgt_unmap_sg(vha, cmd);
@@ -2843,7 +2841,7 @@ static int qla_tgt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	struct qla_tgt *tgt;
 	struct qla_tgt_sess *sess;
 	uint32_t lun, unpacked_lun;
-	int lun_size, fn, res = 0;
+	int fn, res = 0;
 
 	tgt = ha->qla_tgt;
 	if (tgt->tgt_stop) {
@@ -2853,7 +2851,6 @@ static int qla_tgt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 
 
 	lun = a->u.isp24.fcp_cmnd.lun;
-	lun_size = sizeof(a->u.isp24.fcp_cmnd.lun);
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 	sess = ha->tgt_ops->find_sess_by_s_id(vha,
 				a->u.isp24.fcp_hdr.s_id);
@@ -4102,7 +4099,7 @@ static void qla_tgt_tmr_work(struct qla_tgt *tgt,
 	uint8_t *s_id = NULL; /* to hide compiler warnings */
 	int rc, loop_id = -1; /* to hide compiler warnings */
 	uint32_t lun, unpacked_lun;
-	int lun_size, fn;
+	int fn;
 	void *iocb;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -4131,7 +4128,6 @@ static void qla_tgt_tmr_work(struct qla_tgt *tgt,
 
 	iocb = a;
 	lun = a->u.isp24.fcp_cmnd.lun;
-	lun_size = sizeof(lun);
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
-- 
1.7.9
