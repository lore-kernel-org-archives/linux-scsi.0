From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 03/10] qla2xxx: Remove set-but-not-used variables
Date: Tue, 27 Jan 2015 10:33:02 +0100
Message-ID: <54C75B4E.4030502@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0088.outbound.protection.outlook.com ([157.56.111.88]:29120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895AbbA0JdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:33:10 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  2 --
 drivers/scsi/qla2xxx/qla_bsg.c    |  5 -----
 drivers/scsi/qla2xxx/qla_dbg.c    | 24 ++++++------------------
 drivers/scsi/qla2xxx/qla_init.c   |  2 --
 drivers/scsi/qla2xxx/qla_iocb.c   | 24 +++---------------------
 drivers/scsi/qla2xxx/qla_isr.c    |  3 +--
 drivers/scsi/qla2xxx/qla_mbx.c    |  4 ----
 drivers/scsi/qla2xxx/qla_mid.c    |  3 +--
 drivers/scsi/qla2xxx/qla_mr.c     | 10 +++-------
 drivers/scsi/qla2xxx/qla_nx.c     |  9 +++------
 drivers/scsi/qla2xxx/qla_nx2.c    | 12 ++++--------
 drivers/scsi/qla2xxx/qla_os.c     |  6 ++----
 drivers/scsi/qla2xxx/qla_target.c | 19 ++++---------------
 drivers/scsi/qla2xxx/qla_tmpl.c   |  3 +--
 14 files changed, 28 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 82b92c4..741d6e0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -884,7 +884,6 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
-	uint16_t actual_size;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count > DCBX_TLV_DATA_SIZE)
 		return 0;
@@ -901,7 +900,6 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 	}
 
 do_read:
-	actual_size = 0;
 	memset(ha->dcbx_tlv, 0, DCBX_TLV_DATA_SIZE);
 
 	rval = qla2x00_get_dcbx_params(vha, ha->dcbx_tlv_dma,
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e1c2a57..c26acde 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1733,7 +1733,6 @@ qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	uint16_t thread_id;
 	uint32_t rval = EXT_STATUS_OK;
 	uint16_t req_sg_cnt = 0;
 	uint16_t rsp_sg_cnt = 0;
@@ -1790,8 +1789,6 @@ qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 		goto done;
 	}
 
-	thread_id = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
-
 	mutex_lock(&ha->selflogin_lock);
 	if (vha->self_login_loop_id == 0) {
 		/* Initialize all required  fields of fcport */
@@ -2174,7 +2171,6 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 {
 	int ret = -EINVAL;
 	struct fc_rport *rport;
-	fc_port_t *fcport = NULL;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *vha;
 
@@ -2183,7 +2179,6 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 
 	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
-		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index d77fe43..ab2d5f4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -117,7 +117,7 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 {
 	int rval;
 	uint32_t cnt, stat, timer, dwords, idx;
-	uint16_t mb0, mb1;
+	uint16_t mb0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	dma_addr_t dump_dma = ha->gid_list_dma;
 	uint32_t *dump = (uint32_t *)ha->gid_list;
@@ -161,7 +161,7 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 					    &ha->mbx_cmd_flags);
 
 					mb0 = RD_REG_WORD(&reg->mailbox0);
-					mb1 = RD_REG_WORD(&reg->mailbox1);
+					RD_REG_WORD(&reg->mailbox1);
 
 					WRT_REG_DWORD(&reg->hccr,
 					    HCCRX_CLR_RISC_INT);
@@ -1039,7 +1039,6 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1047,7 +1046,6 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla24xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt;
 	void		*nxt_chain;
 	uint32_t	*last_chain = NULL;
@@ -1056,7 +1054,6 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (IS_P3P_TYPE(ha))
 		return;
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
@@ -1294,7 +1291,6 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1302,12 +1298,10 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla25xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
@@ -1613,7 +1607,6 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1621,12 +1614,10 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla81xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
@@ -1933,8 +1924,7 @@ void
 qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
-	uint32_t	cnt, reg_data;
-	uint32_t	risc_address;
+	uint32_t	cnt;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1942,12 +1932,10 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla83xx_fw_dump *fw;
-	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	risc_address = ext_mem_cnt = 0;
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
@@ -1979,16 +1967,16 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
 	dmp_reg = &reg->iobase_window;
-	reg_data = RD_REG_DWORD(dmp_reg);
+	RD_REG_DWORD(dmp_reg);
 	WRT_REG_DWORD(dmp_reg, 0);
 
 	dmp_reg = &reg->unused_4_1[0];
-	reg_data = RD_REG_DWORD(dmp_reg);
+	RD_REG_DWORD(dmp_reg);
 	WRT_REG_DWORD(dmp_reg, 0);
 
 	WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
 	dmp_reg = &reg->unused_4_1[2];
-	reg_data = RD_REG_DWORD(dmp_reg);
+	RD_REG_DWORD(dmp_reg);
 	WRT_REG_DWORD(dmp_reg, 0);
 
 	/* select PCR and disable ecc checking and correction */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e59f25b..bf8119e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3805,12 +3805,10 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
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
index fb0f514..165ab5b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -310,7 +310,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 int
 qla2x00_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
@@ -327,7 +327,6 @@ qla2x00_start_scsi(srb_t *sp)
 	struct rsp_que *rsp;
 
 	/* Setup device pointers. */
-	ret = 0;
 	vha = sp->fcport->vha;
 	ha = vha->hw;
 	reg = &ha->iobase->isp;
@@ -710,7 +709,6 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
-	struct req_que *req;
 
 	cmd = GET_CMD_SP(sp);
 
@@ -725,7 +723,6 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = vha->req;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -933,11 +930,9 @@ qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *ha, srb_t *sp,
 	dma_addr_t	sle_dma;
 	uint32_t	sle_dma_len, tot_prot_dma_len = 0;
 	struct scsi_cmnd *cmd;
-	struct scsi_qla_host *vha;
 
 	memset(&sgx, 0, sizeof(struct qla2_sgx));
 	if (sp) {
-		vha = sp->fcport->vha;
 		cmd = GET_CMD_SP(sp);
 		prot_int = cmd->device->sector_size;
 
@@ -947,7 +942,6 @@ qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *ha, srb_t *sp,
 
 		sg_prot = scsi_prot_sglist(cmd);
 	} else if (tc) {
-		vha = tc->vha;
 		prot_int      = tc->blk_sz;
 		sgx.tot_bytes = tc->bufflen;
 		sgx.cur_sg    = tc->sg;
@@ -1047,15 +1041,12 @@ qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
 	int	i;
 	uint16_t	used_dsds = tot_dsds;
 	struct scsi_cmnd *cmd;
-	struct scsi_qla_host *vha;
 
 	if (sp) {
 		cmd = GET_CMD_SP(sp);
 		sgl = scsi_sglist(cmd);
-		vha = sp->fcport->vha;
 	} else if (tc) {
 		sgl = tc->sg;
-		vha = tc->vha;
 	} else {
 		BUG();
 		return 1;
@@ -1231,7 +1222,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	uint32_t		*cur_dsd, *fcp_dl;
 	scsi_qla_host_t		*vha;
 	struct scsi_cmnd	*cmd;
-	int			sgc;
 	uint32_t		total_bytes = 0;
 	uint32_t		data_bytes;
 	uint32_t		dif_bytes;
@@ -1247,7 +1237,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	cmd = GET_CMD_SP(sp);
 
-	sgc = 0;
 	/* Update entry type to indicate Command Type CRC_2 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
 	    __constant_cpu_to_le32(COMMAND_TYPE_CRC_2);
@@ -1442,7 +1431,7 @@ crc_queuing_error:
 int
 qla24xx_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -1458,8 +1447,6 @@ qla24xx_start_scsi(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Setup device pointers. */
-	ret = 0;
-
 	qla25xx_set_que(sp, &rsp);
 	req = vha->req;
 
@@ -2088,7 +2075,6 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
-	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
 
 	memset(ct_iocb, 0, sizeof(ms_iocb_entry_t));
@@ -2139,7 +2125,6 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 			    vha->hw->req_q_map[0]);
 			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
 			avail_dsds = 5;
-			cont_iocb_prsnt = 1;
 			entry_count++;
 		}
 
@@ -2167,7 +2152,6 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
-	int cont_iocb_prsnt = 0;
 	int entry_count = 1;
 
 	ct_iocb->entry_type = CT_IOCB_TYPE;
@@ -2214,7 +2198,6 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 			    ha->req_q_map[0]);
 			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
 			avail_dsds = 5;
-			cont_iocb_prsnt = 1;
 			entry_count++;
 		}
 
@@ -2237,7 +2220,7 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 int
 qla82xx_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
@@ -2257,7 +2240,6 @@ qla82xx_start_scsi(srb_t *sp)
 	struct rsp_que *rsp = NULL;
 
 	/* Setup device pointers. */
-	ret = 0;
 	reg = &ha->iobase->isp82;
 	cmd = GET_CMD_SP(sp);
 	req = vha->req;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a04a1b1..d9f6a3d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -575,7 +575,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
-	uint32_t	rscn_entry, host_pid, tmp_pid;
+	uint32_t	rscn_entry, host_pid;
 	unsigned long	flags;
 	fc_port_t	*fcport = NULL;
 
@@ -987,7 +987,6 @@ skip_rio:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (atomic_read(&fcport->state) != FCS_ONLINE)
 				continue;
-			tmp_pid = fcport->d_id.b24;
 			if (fcport->d_id.b24 == rscn_entry) {
 				qla2x00_mark_device_lost(vha, fcport, 0, 0);
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 72971da..e0099e6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1851,7 +1851,6 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	uint32_t	iop[2];
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
-	struct rsp_que *rsp;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1061,
 	    "Entered %s.\n", __func__);
@@ -1860,7 +1859,6 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
-	rsp = req->rsp;
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
@@ -2128,7 +2126,6 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	dma_addr_t	lg_dma;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
-	struct rsp_que *rsp;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x106d,
 	    "Entered %s.\n", __func__);
@@ -2145,7 +2142,6 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
-	rsp = req->rsp;
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
 	lg->handle = MAKE_HANDLE(req->id, lg->handle);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 5c2e031..ac4465d 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -365,7 +365,6 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 void
 qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 {
-	int ret;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
 	unsigned long flags = 0;
@@ -386,7 +385,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-			ret = qla2x00_do_dpc_vp(vp);
+			qla2x00_do_dpc_vp(vp);
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 878fd3d..1843ba9 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1317,10 +1317,10 @@ int
 qlafx00_configure_devices(scsi_qla_host_t *vha)
 {
 	int  rval;
-	unsigned long flags, save_flags;
+	unsigned long flags;
 	rval = QLA_SUCCESS;
 
-	save_flags = flags = vha->dpc_flags;
+	flags = vha->dpc_flags;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2090,
 	    "Configure devices -- dpc flags =0x%lx\n", flags);
@@ -2279,7 +2279,6 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	struct sts_entry_fx00 *sts;
 	__le16		comp_status;
 	__le16		scsi_status;
-	uint16_t	ox_id;
 	__le16		lscsi_status;
 	int32_t		resid;
 	uint32_t	sense_len, par_sense_len, rsp_info_len, resid_len,
@@ -2344,7 +2343,6 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	fcport = sp->fcport;
 
-	ox_id = 0;
 	sense_len = par_sense_len = rsp_info_len = resid_len =
 		fw_resid_len = 0;
 	if (scsi_status & cpu_to_le16((uint16_t)SS_SENSE_LEN_VALID))
@@ -3071,7 +3069,7 @@ qlafx00_build_scsi_iocbs(srb_t *sp, struct cmd_type_7_fx00 *cmd_pkt,
 int
 qlafx00_start_scsi(srb_t *sp)
 {
-	int		ret, nseg;
+	int		nseg;
 	unsigned long   flags;
 	uint32_t        index;
 	uint32_t	handle;
@@ -3088,8 +3086,6 @@ qlafx00_start_scsi(srb_t *sp)
 	struct scsi_lun llun;
 
 	/* Setup device pointers. */
-	ret = 0;
-
 	rsp = ha->rsp_q_map[0];
 	req = vha->req;
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 4e33c28..5c0f950 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1740,8 +1740,8 @@ qla82xx_pci_config(scsi_qla_host_t *vha)
 	ret = pci_set_mwi(ha->pdev);
 	ha->chip_revision = ha->pdev->revision;
 	ql_dbg(ql_dbg_init, vha, 0x0043,
-	    "Chip revision:%d.\n",
-	    ha->chip_revision);
+	    "Chip revision:%d; pci_set_mwi() returned %d.\n",
+	    ha->chip_revision, ret);
 	return 0;
 }
 
@@ -2671,7 +2671,7 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 {
 	int ret;
 	uint32_t liter;
-	uint32_t sec_mask, rest_addr;
+	uint32_t rest_addr;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	int page_mode = 0;
@@ -2693,7 +2693,6 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 	}
 
 	rest_addr = ha->fdt_block_size - 1;
-	sec_mask = ~rest_addr;
 
 	ret = qla82xx_unprotect_flash(ha);
 	if (ret) {
@@ -2789,7 +2788,6 @@ qla82xx_start_iocbs(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
-	struct device_reg_82xx __iomem *reg;
 	uint32_t dbval;
 
 	/* Adjust ring index. */
@@ -2800,7 +2798,6 @@ qla82xx_start_iocbs(scsi_qla_host_t *vha)
 	} else
 		req->ring_ptr++;
 
-	reg = &ha->iobase->isp82;
 	dbval = 0x04 | (ha->portnum << 5);
 
 	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index d804d82..f478d8f 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -462,12 +462,11 @@ qla8044_flash_lock(scsi_qla_host_t *vha)
 static void
 qla8044_flash_unlock(scsi_qla_host_t *vha)
 {
-	int ret_val;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Reading FLASH_UNLOCK register unlocks the Flash */
 	qla8044_wr_reg(ha, QLA8044_FLASH_LOCK_ID, 0xFF);
-	ret_val = qla8044_rd_reg(ha, QLA8044_FLASH_UNLOCK);
+	qla8044_rd_reg(ha, QLA8044_FLASH_UNLOCK);
 }
 
 
@@ -2992,7 +2991,7 @@ qla8044_minidump_process_rddfe(struct scsi_qla_host *vha,
 	uint32_t addr1, addr2, value, data, temp, wrVal;
 	uint8_t stride, stride2;
 	uint16_t count;
-	uint32_t poll, mask, data_size, modify_mask;
+	uint32_t poll, mask, modify_mask;
 	uint32_t wait_count = 0;
 
 	uint32_t *data_ptr = *d_ptr;
@@ -3009,7 +3008,6 @@ qla8044_minidump_process_rddfe(struct scsi_qla_host *vha,
 	poll = rddfe->poll;
 	mask = rddfe->mask;
 	modify_mask = rddfe->modify_mask;
-	data_size = rddfe->data_size;
 
 	addr2 = addr1 + stride;
 
@@ -3091,7 +3089,7 @@ qla8044_minidump_process_rdmdio(struct scsi_qla_host *vha,
 	uint8_t stride1, stride2;
 	uint32_t addr3, addr4, addr5, addr6, addr7;
 	uint16_t count, loop_cnt;
-	uint32_t poll, mask;
+	uint32_t mask;
 	uint32_t *data_ptr = *d_ptr;
 
 	struct qla8044_minidump_entry_rdmdio *rdmdio;
@@ -3105,7 +3103,6 @@ qla8044_minidump_process_rdmdio(struct scsi_qla_host *vha,
 	stride2 = rdmdio->stride_2;
 	count = rdmdio->count;
 
-	poll = rdmdio->poll;
 	mask = rdmdio->mask;
 	value2 = rdmdio->value_2;
 
@@ -3165,7 +3162,7 @@ error:
 static uint32_t qla8044_minidump_process_pollwr(struct scsi_qla_host *vha,
 		struct qla8044_minidump_entry_hdr *entry_hdr, uint32_t **d_ptr)
 {
-	uint32_t addr1, addr2, value1, value2, poll, mask, r_value;
+	uint32_t addr1, addr2, value1, value2, poll, r_value;
 	uint32_t wait_count = 0;
 	struct qla8044_minidump_entry_pollwr *pollwr_hdr;
 
@@ -3176,7 +3173,6 @@ static uint32_t qla8044_minidump_process_pollwr(struct scsi_qla_host *vha,
 	value2 = pollwr_hdr->value_2;
 
 	poll = pollwr_hdr->poll;
-	mask = pollwr_hdr->mask;
 
 	while (wait_count < poll) {
 		qla8044_rd_reg_indirect(vha, addr1, &r_value);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cce1cbc..b7d7be9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2973,7 +2973,6 @@ qla2x00_shutdown(struct pci_dev *pdev)
 static void
 qla2x00_delete_all_vps(struct qla_hw_data *ha, scsi_qla_host_t *base_vha)
 {
-	struct Scsi_Host *scsi_host;
 	scsi_qla_host_t *vha;
 	unsigned long flags;
 
@@ -2984,7 +2983,7 @@ qla2x00_delete_all_vps(struct qla_hw_data *ha, scsi_qla_host_t *base_vha)
 		BUG_ON(base_vha->list.next == &ha->vp_list);
 		/* This assumes first entry in ha->vp_list is always base vha */
 		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
-		scsi_host = scsi_host_get(vha->host);
+		scsi_host_get(vha->host);
 
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
@@ -4788,7 +4787,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 static int
 qla2x00_do_dpc(void *data)
 {
-	int		rval;
 	scsi_qla_host_t *base_vha;
 	struct qla_hw_data *ha;
 
@@ -5020,7 +5018,7 @@ loop_resync_check:
 			if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
 			    &base_vha->dpc_flags))) {
 
-				rval = qla2x00_loop_resync(base_vha);
+				qla2x00_loop_resync(base_vha);
 
 				clear_bit(LOOP_RESYNC_ACTIVE,
 						&base_vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5741825..317783f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2079,7 +2079,6 @@ static inline int
 qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 {
 	uint32_t		*cur_dsd;
-	int			sgc;
 	uint32_t		transfer_length = 0;
 	uint32_t		data_bytes;
 	uint32_t		dif_bytes;
@@ -2096,7 +2095,6 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 	struct atio_from_isp *atio = &prm->cmd->atio;
 	uint16_t t16;
 
-	sgc = 0;
 	ha = vha->hw;
 
 	pkt = (struct ctio_crc2_to_fw *)vha->req->ring_ptr;
@@ -2565,7 +2563,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 
 		/* Update protection tag */
 		if (cmd->prot_sg_cnt) {
-			uint32_t i, j = 0, k = 0, num_ent;
+			uint32_t i, k = 0, num_ent;
 			struct scatterlist *sg, *sgl;
 
 
@@ -2578,7 +2576,6 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 					k += num_ent;
 					continue;
 				}
-				j = blocks_done - k - 1;
 				k = blocks_done;
 				break;
 			}
@@ -3065,7 +3062,6 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct se_cmd *se_cmd;
-	struct target_core_fabric_ops *tfo;
 	struct qla_tgt_cmd *cmd;
 
 	if (handle & CTIO_INTERMEDIATE_HANDLE_MARK) {
@@ -3083,7 +3079,6 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		return;
 
 	se_cmd = &cmd->se_cmd;
-	tfo = se_cmd->se_tfo;
 	cmd->cmd_sent_to_fw = 0;
 
 	qlt_unmap_sg(vha, cmd);
@@ -3181,13 +3176,9 @@ skip_term:
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
 		;
 	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
-		int rx_status = 0;
-
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 
-		if (unlikely(status != CTIO_SUCCESS))
-			rx_status = -EIO;
-		else
+		if (status == CTIO_SUCCESS)
 			cmd->write_data_transferred = 1;
 
 		ha->tgt.tgt_ops->handle_data(cmd);
@@ -3582,12 +3573,11 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	struct qla_tgt *tgt;
 	struct qla_tgt_sess *sess;
 	uint32_t lun, unpacked_lun;
-	int lun_size, fn;
+	int fn;
 
 	tgt = vha->vha_tgt.qla_tgt;
 
 	lun = a->u.isp24.fcp_cmnd.lun;
-	lun_size = sizeof(a->u.isp24.fcp_cmnd.lun);
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
 	    a->u.isp24.fcp_hdr.s_id);
@@ -5048,7 +5038,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	uint8_t *s_id = NULL; /* to hide compiler warnings */
 	int rc;
 	uint32_t lun, unpacked_lun;
-	int lun_size, fn;
+	int fn;
 	void *iocb;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -5075,7 +5065,6 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 
 	iocb = a;
 	lun = a->u.isp24.fcp_cmnd.lun;
-	lun_size = sizeof(lun);
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index a8c0c73..0fb4ed1 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -796,9 +796,8 @@ static void
 qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
 {
 	uint8_t v[] = { 0, 0, 0, 0, 0, 0 };
-	int rval = 0;
 
-	rval = sscanf(qla2x00_version_str, "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
+	sscanf(qla2x00_version_str, "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
 	    v+0, v+1, v+2, v+3, v+4, v+5);
 
 	tmp->driver_info[0] = v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0];
-- 
2.1.2

