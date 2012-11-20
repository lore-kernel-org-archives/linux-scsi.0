From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: [PATCH] csiostor: Fix sparse warnings.
Date: Tue, 20 Nov 2012 18:15:40 +0530
Message-ID: <1353415540-557-1-git-send-email-naresh@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:12538 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2KTHKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2012 02:10:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: naresh@chelsio.com

This patch fixes sparse warnings related to endian-ness, which were
reported by the 0-day kernel build and testing tool.

Signed-off-by: Naresh Kumar Inna <naresh@chelsio.com>
---
 drivers/scsi/csiostor/csio_attr.c     |   34 ++++++------
 drivers/scsi/csiostor/csio_hw.c       |   14 +++---
 drivers/scsi/csiostor/csio_hw.h       |    6 +--
 drivers/scsi/csiostor/csio_lnode.c    |   91 +++++++++++++++++----------------
 drivers/scsi/csiostor/csio_mb.c       |   62 ++++++++---------------
 drivers/scsi/csiostor/csio_rnode.c    |   11 ++--
 drivers/scsi/csiostor/csio_scsi.c     |    8 ++--
 drivers/scsi/csiostor/t4fw_api_stor.h |   12 ++--
 8 files changed, 110 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/csio_attr.c
index c8cf857..065a87a 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -89,7 +89,7 @@ csio_reg_rnode(struct csio_rnode *rn)
 	spin_unlock_irq(shost->host_lock);
 
 	sp = &rn->rn_sparm;
-	rport->maxframe_size		= sp->csp.sp_bb_data;
+	rport->maxframe_size = ntohs(sp->csp.sp_bb_data);
 	if (ntohs(sp->clsp[2].cp_class) & FC_CPC_VALID)
 		rport->supported_classes = FC_COS_CLASS3;
 	else
@@ -192,7 +192,7 @@ csio_fchost_attr_init(struct csio_lnode *ln)
 	fc_host_supported_speeds(shost) = FC_PORTSPEED_10GBIT |
 		FC_PORTSPEED_1GBIT;
 
-	fc_host_maxframe_size(shost) = ln->ln_sparm.csp.sp_bb_data;
+	fc_host_maxframe_size(shost) = ntohs(ln->ln_sparm.csp.sp_bb_data);
 	memset(fc_host_supported_fc4s(shost), 0,
 		sizeof(fc_host_supported_fc4s(shost)));
 	fc_host_supported_fc4s(shost)[7] = 1;
@@ -325,23 +325,23 @@ csio_get_stats(struct Scsi_Host *shost)
 	memset(&fcoe_port_stats, 0, sizeof(struct fw_fcoe_port_stats));
 	csio_get_phy_port_stats(hw, ln->portid, &fcoe_port_stats);
 
-	fhs->tx_frames  += (fcoe_port_stats.tx_bcast_frames +
-				fcoe_port_stats.tx_mcast_frames +
-				fcoe_port_stats.tx_ucast_frames +
-				fcoe_port_stats.tx_offload_frames);
-	fhs->tx_words  += (fcoe_port_stats.tx_bcast_bytes +
-			   fcoe_port_stats.tx_mcast_bytes +
-			   fcoe_port_stats.tx_ucast_bytes +
-			   fcoe_port_stats.tx_offload_bytes) /
+	fhs->tx_frames  += (be64_to_cpu(fcoe_port_stats.tx_bcast_frames) +
+			    be64_to_cpu(fcoe_port_stats.tx_mcast_frames) +
+			    be64_to_cpu(fcoe_port_stats.tx_ucast_frames) +
+			    be64_to_cpu(fcoe_port_stats.tx_offload_frames));
+	fhs->tx_words  += (be64_to_cpu(fcoe_port_stats.tx_bcast_bytes) +
+			   be64_to_cpu(fcoe_port_stats.tx_mcast_bytes) +
+			   be64_to_cpu(fcoe_port_stats.tx_ucast_bytes) +
+			   be64_to_cpu(fcoe_port_stats.tx_offload_bytes)) /
 							CSIO_WORD_TO_BYTE;
-	fhs->rx_frames += (fcoe_port_stats.rx_bcast_frames +
-				fcoe_port_stats.rx_mcast_frames +
-				fcoe_port_stats.rx_ucast_frames);
-	fhs->rx_words += (fcoe_port_stats.rx_bcast_bytes +
-				fcoe_port_stats.rx_mcast_bytes +
-				fcoe_port_stats.rx_ucast_bytes) /
+	fhs->rx_frames += (be64_to_cpu(fcoe_port_stats.rx_bcast_frames) +
+			   be64_to_cpu(fcoe_port_stats.rx_mcast_frames) +
+			   be64_to_cpu(fcoe_port_stats.rx_ucast_frames));
+	fhs->rx_words += (be64_to_cpu(fcoe_port_stats.rx_bcast_bytes) +
+			  be64_to_cpu(fcoe_port_stats.rx_mcast_bytes) +
+			  be64_to_cpu(fcoe_port_stats.rx_ucast_bytes)) /
 							CSIO_WORD_TO_BYTE;
-	fhs->error_frames += fcoe_port_stats.rx_err_frames;
+	fhs->error_frames += be64_to_cpu(fcoe_port_stats.rx_err_frames);
 	fhs->fcp_input_requests +=  ln->stats.n_input_requests;
 	fhs->fcp_output_requests +=  ln->stats.n_output_requests;
 	fhs->fcp_control_requests +=  ln->stats.n_control_requests;
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 963c6c1..8ecdb94 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -169,7 +169,7 @@ csio_set_reg_field(struct csio_hw *hw, uint32_t reg, uint32_t mask,
  *	is assigned the 64-bit ECC word for the read data.
  */
 int
-csio_hw_mc_read(struct csio_hw *hw, uint32_t addr, uint32_t *data,
+csio_hw_mc_read(struct csio_hw *hw, uint32_t addr, __be32 *data,
 		uint64_t *ecc)
 {
 	int i;
@@ -209,7 +209,7 @@ csio_hw_mc_read(struct csio_hw *hw, uint32_t addr, uint32_t *data,
  *	is assigned the 64-bit ECC word for the read data.
  */
 int
-csio_hw_edc_read(struct csio_hw *hw, int idx, uint32_t addr, uint32_t *data,
+csio_hw_edc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 		uint64_t *ecc)
 {
 	int i;
@@ -249,7 +249,7 @@ csio_hw_edc_read(struct csio_hw *hw, int idx, uint32_t addr, uint32_t *data,
  *      address @addr.
  */
 static int
-csio_mem_win_rw(struct csio_hw *hw, u32 addr, __be32 *data, int dir)
+csio_mem_win_rw(struct csio_hw *hw, u32 addr, u32 *data, int dir)
 {
 	int i;
 
@@ -296,7 +296,7 @@ csio_memory_rw(struct csio_hw *hw, int mtype, u32 addr, u32 len,
 {
 	uint32_t pos, start, end, offset, memoffset;
 	int ret;
-	__be32 *data;
+	uint32_t *data;
 
 	/*
 	 * Argument sanity checks ...
@@ -379,7 +379,7 @@ csio_memory_rw(struct csio_hw *hw, int mtype, u32 addr, u32 len,
 }
 
 static int
-csio_memory_write(struct csio_hw *hw, int mtype, u32 addr, u32 len, __be32 *buf)
+csio_memory_write(struct csio_hw *hw, int mtype, u32 addr, u32 len, u32 *buf)
 {
 	return csio_memory_rw(hw, mtype, addr, len, buf, 0);
 }
@@ -429,6 +429,7 @@ csio_hw_seeprom_read(struct csio_hw *hw, uint32_t addr, uint32_t *data)
 
 	pci_read_config_dword(hw->pdev, base + PCI_VPD_DATA, data);
 	*data = le32_to_cpu(*data);
+
 	return 0;
 }
 
@@ -926,7 +927,7 @@ csio_hw_fw_dload(struct csio_hw *hw, uint8_t *fw_data, uint32_t size)
 	int ret;
 	uint32_t i;
 	uint8_t first_page[SF_PAGE_SIZE];
-	const uint32_t *p = (const uint32_t *)fw_data;
+	const __be32 *p = (const __be32 *)fw_data;
 	struct fw_hdr *hdr = (struct fw_hdr *)fw_data;
 	uint32_t sf_sec_size;
 
@@ -2116,7 +2117,6 @@ csio_hw_flash_config(struct csio_hw *hw, u32 *fw_cfg_param, char *path)
 	const struct firmware *cf;
 	struct pci_dev *pci_dev = hw->pdev;
 	struct device *dev = &pci_dev->dev;
-
 	unsigned int mtype = 0, maddr = 0;
 	uint32_t *cfg_data;
 	int value_to_add = 0;
diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 2a9b052..9edcca4 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -658,10 +658,8 @@ void csio_intr_disable(struct csio_hw *, bool);
 struct csio_lnode *csio_lnode_alloc(struct csio_hw *);
 int csio_config_queues(struct csio_hw *);
 
-int csio_hw_mc_read(struct csio_hw *, uint32_t,
-			      uint32_t *, uint64_t *);
-int csio_hw_edc_read(struct csio_hw *, int, uint32_t, uint32_t *,
-			       uint64_t *);
+int csio_hw_mc_read(struct csio_hw *, uint32_t, __be32 *, uint64_t *);
+int csio_hw_edc_read(struct csio_hw *, int, uint32_t, __be32 *, uint64_t *);
 int csio_hw_init(struct csio_hw *);
 void csio_hw_exit(struct csio_hw *);
 #endif /* ifndef __CSIO_HW_H__ */
diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 551959e..5322c81 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -214,7 +214,7 @@ csio_fill_ct_iu(void *buf, uint8_t type, uint8_t sub_type, uint16_t op)
 	cmd->ct_rev = FC_CT_REV;
 	cmd->ct_fs_type = type;
 	cmd->ct_fs_subtype = sub_type;
-	cmd->ct_cmd = op;
+	cmd->ct_cmd = htons(op);
 }
 
 static int
@@ -285,11 +285,13 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	void *cmd;
 	uint8_t *pld;
 	uint32_t len = 0;
+	__be32 val;
+	__be16 mfs;
+	uint32_t numattrs = 0;
 	struct csio_lnode *ln = fdmi_req->lnode;
 	struct fs_fdmi_attrs *attrib_blk;
 	struct fc_fdmi_port_name *port_name;
 	uint8_t buf[64];
-	uint32_t val;
 	uint8_t *fc4_type;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
@@ -311,7 +313,7 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 
 	/* Prepare CT hdr for RPA cmd */
 	memset(cmd, 0, FC_CT_HDR_LEN);
-	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, htons(FC_FDMI_RPA));
+	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, FC_FDMI_RPA);
 
 	/* Prepare RPA payload */
 	pld = (uint8_t *)csio_ct_get_pld(cmd);
@@ -331,12 +333,12 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	fc4_type[7] = 1;
 	csio_append_attrib(&pld, FC_FDMI_PORT_ATTR_FC4TYPES,
 			   fc4_type, FC_FDMI_PORT_ATTR_FC4TYPES_LEN);
-	attrib_blk->numattrs++;
+	numattrs++;
 	val = htonl(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
 	csio_append_attrib(&pld, FC_FDMI_PORT_ATTR_SUPPORTEDSPEED,
 			   (uint8_t *)&val,
 			   FC_FDMI_PORT_ATTR_SUPPORTEDSPEED_LEN);
-	attrib_blk->numattrs++;
+	numattrs++;
 
 	if (hw->pport[ln->portid].link_speed == FW_PORT_CAP_SPEED_1G)
 		val = htonl(FC_PORTSPEED_1GBIT);
@@ -347,24 +349,24 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	csio_append_attrib(&pld, FC_FDMI_PORT_ATTR_CURRENTPORTSPEED,
 			   (uint8_t *)&val,
 			   FC_FDMI_PORT_ATTR_CURRENTPORTSPEED_LEN);
-	attrib_blk->numattrs++;
+	numattrs++;
 
-	val = htonl(ln->ln_sparm.csp.sp_bb_data);
+	mfs = ln->ln_sparm.csp.sp_bb_data;
 	csio_append_attrib(&pld, FC_FDMI_PORT_ATTR_MAXFRAMESIZE,
-			   (uint8_t *)&val, FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN);
-	attrib_blk->numattrs++;
+			   (uint8_t *)&mfs, FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN);
+	numattrs++;
 
 	strcpy(buf, "csiostor");
 	csio_append_attrib(&pld, FC_FDMI_PORT_ATTR_OSDEVICENAME, buf,
 			   (uint16_t)strlen(buf));
-	attrib_blk->numattrs++;
+	numattrs++;
 
 	if (!csio_hostname(buf, sizeof(buf))) {
 		csio_append_attrib(&pld, FC_FDMI_PORT_ATTR_HOSTNAME,
 				   buf, (uint16_t)strlen(buf));
-		attrib_blk->numattrs++;
+		numattrs++;
 	}
-	attrib_blk->numattrs = ntohl(attrib_blk->numattrs);
+	attrib_blk->numattrs = htonl(numattrs);
 	len = (uint32_t)(pld - (uint8_t *)cmd);
 
 	/* Submit FDMI RPA request */
@@ -388,7 +390,8 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	void *cmd;
 	uint8_t *pld;
 	uint32_t len = 0;
-	uint32_t maxpayload = htonl(65536);
+	uint32_t numattrs = 0;
+	__be32  maxpayload = htonl(65536);
 	struct fc_fdmi_hba_identifier *hbaid;
 	struct csio_lnode *ln = fdmi_req->lnode;
 	struct fc_fdmi_rpl *reg_pl;
@@ -413,7 +416,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 
 	/* Prepare CT hdr for RHBA cmd */
 	memset(cmd, 0, FC_CT_HDR_LEN);
-	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, htons(FC_FDMI_RHBA));
+	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, FC_FDMI_RHBA);
 	len = FC_CT_HDR_LEN;
 
 	/* Prepare RHBA payload */
@@ -424,7 +427,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 
 	/* Register one port per hba */
 	reg_pl = (struct fc_fdmi_rpl *)pld;
-	reg_pl->numport = ntohl(1);
+	reg_pl->numport = htonl(1);
 	memcpy(&reg_pl->port[0].portname, csio_ln_wwpn(ln), 8);
 	pld += sizeof(*reg_pl);
 
@@ -436,42 +439,42 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_NODENAME, csio_ln_wwnn(ln),
 			   FC_FDMI_HBA_ATTR_NODENAME_LEN);
-	attrib_blk->numattrs++;
+	numattrs++;
 
 	memset(buf, 0, sizeof(buf));
 
 	strcpy(buf, "Chelsio Communications");
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_MANUFACTURER, buf,
 			   (uint16_t)strlen(buf));
-	attrib_blk->numattrs++;
+	numattrs++;
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_SERIALNUMBER,
 			   hw->vpd.sn, (uint16_t)sizeof(hw->vpd.sn));
-	attrib_blk->numattrs++;
+	numattrs++;
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_MODEL, hw->vpd.id,
 			   (uint16_t)sizeof(hw->vpd.id));
-	attrib_blk->numattrs++;
+	numattrs++;
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_MODELDESCRIPTION,
 			   hw->model_desc, (uint16_t)strlen(hw->model_desc));
-	attrib_blk->numattrs++;
+	numattrs++;
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_HARDWAREVERSION,
 			   hw->hw_ver, (uint16_t)sizeof(hw->hw_ver));
-	attrib_blk->numattrs++;
+	numattrs++;
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_FIRMWAREVERSION,
 			   hw->fwrev_str, (uint16_t)strlen(hw->fwrev_str));
-	attrib_blk->numattrs++;
+	numattrs++;
 
 	if (!csio_osname(buf, sizeof(buf))) {
 		csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_OSNAMEVERSION,
 				   buf, (uint16_t)strlen(buf));
-		attrib_blk->numattrs++;
+		numattrs++;
 	}
 
 	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_MAXCTPAYLOAD,
 			   (uint8_t *)&maxpayload,
 			   FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
 	len = (uint32_t)(pld - (uint8_t *)cmd);
-	attrib_blk->numattrs++;
-	attrib_blk->numattrs = ntohl(attrib_blk->numattrs);
+	numattrs++;
+	attrib_blk->numattrs = htonl(numattrs);
 
 	/* Submit FDMI RHBA request */
 	spin_lock_irq(&hw->lock);
@@ -518,7 +521,7 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 
 	/* Prepare FDMI DPRT cmd */
 	memset(cmd, 0, FC_CT_HDR_LEN);
-	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, htons(FC_FDMI_DPRT));
+	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, FC_FDMI_DPRT);
 	len = FC_CT_HDR_LEN;
 	port_name = (struct fc_fdmi_port_name *)csio_ct_get_pld(cmd);
 	memcpy(&port_name->portname, csio_ln_wwpn(ln), 8);
@@ -567,7 +570,7 @@ csio_ln_fdmi_start(struct csio_lnode *ln, void *context)
 	/* Prepare FDMI DHBA cmd */
 	cmd = fdmi_req->dma_buf.vaddr;
 	memset(cmd, 0, FC_CT_HDR_LEN);
-	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, htons(FC_FDMI_DHBA));
+	csio_fill_ct_iu(cmd, FC_FST_MGMT, FC_FDMI_SUBTYPE, FC_FDMI_DHBA);
 	len = FC_CT_HDR_LEN;
 
 	hbaid = (struct fc_fdmi_hba_identifier *)csio_ct_get_pld(cmd);
@@ -599,6 +602,7 @@ csio_ln_vnp_read_cbfn(struct csio_hw *hw, struct csio_mb *mbp)
 	struct fc_els_csp *csp;
 	struct fc_els_cssp *clsp;
 	enum fw_retval retval;
+	__be32 nport_id;
 
 	retval = FW_CMD_RETVAL_GET(ntohl(rsp->alloc_to_len16));
 	if (retval != FW_SUCCESS) {
@@ -610,10 +614,9 @@ csio_ln_vnp_read_cbfn(struct csio_hw *hw, struct csio_mb *mbp)
 	spin_lock_irq(&hw->lock);
 
 	memcpy(ln->mac, rsp->vnport_mac, sizeof(ln->mac));
-	memcpy(&ln->nport_id, &rsp->vnport_mac[3],
-			sizeof(uint8_t)*3);
-	ln->nport_id = ntohl(ln->nport_id);
-	ln->nport_id = ln->nport_id>>8;
+	memcpy(&nport_id, &rsp->vnport_mac[3], sizeof(uint8_t)*3);
+	ln->nport_id = ntohl(nport_id);
+	ln->nport_id = ln->nport_id >> 8;
 
 	/* Update WWNs */
 	/*
@@ -628,18 +631,18 @@ csio_ln_vnp_read_cbfn(struct csio_hw *hw, struct csio_mb *mbp)
 	csp = (struct fc_els_csp *)rsp->cmn_srv_parms;
 	ln->ln_sparm.csp.sp_hi_ver = csp->sp_hi_ver;
 	ln->ln_sparm.csp.sp_lo_ver = csp->sp_lo_ver;
-	ln->ln_sparm.csp.sp_bb_cred = ntohs(csp->sp_bb_cred);
-	ln->ln_sparm.csp.sp_features = ntohs(csp->sp_features);
-	ln->ln_sparm.csp.sp_bb_data = ntohs(csp->sp_bb_data);
-	ln->ln_sparm.csp.sp_r_a_tov = ntohl(csp->sp_r_a_tov);
-	ln->ln_sparm.csp.sp_e_d_tov = ntohl(csp->sp_e_d_tov);
+	ln->ln_sparm.csp.sp_bb_cred = csp->sp_bb_cred;
+	ln->ln_sparm.csp.sp_features = csp->sp_features;
+	ln->ln_sparm.csp.sp_bb_data = csp->sp_bb_data;
+	ln->ln_sparm.csp.sp_r_a_tov = csp->sp_r_a_tov;
+	ln->ln_sparm.csp.sp_e_d_tov = csp->sp_e_d_tov;
 
 	/* Copy word 0 & word 1 of class sparam */
 	clsp = (struct fc_els_cssp *)rsp->clsp_word_0_1;
-	ln->ln_sparm.clsp[2].cp_class = ntohs(clsp->cp_class);
-	ln->ln_sparm.clsp[2].cp_init = ntohs(clsp->cp_init);
-	ln->ln_sparm.clsp[2].cp_recip = ntohs(clsp->cp_recip);
-	ln->ln_sparm.clsp[2].cp_rdfs = ntohs(clsp->cp_rdfs);
+	ln->ln_sparm.clsp[2].cp_class = clsp->cp_class;
+	ln->ln_sparm.clsp[2].cp_init = clsp->cp_init;
+	ln->ln_sparm.clsp[2].cp_recip = clsp->cp_recip;
+	ln->ln_sparm.clsp[2].cp_rdfs = clsp->cp_rdfs;
 
 	spin_unlock_irq(&hw->lock);
 
@@ -1499,7 +1502,7 @@ csio_fcoe_fwevt_handler(struct csio_hw *hw, __u8 cpl_op, __be64 *cmd)
 			/* HW un lock here */
 		} else {
 			csio_warn(hw, "Unexpected FCOE LINK status:0x%x\n",
-				    ntohl(lcmd->lstatus));
+				  lcmd->lstatus);
 			CSIO_INC_STATS(hw, n_cpl_unexp);
 		}
 	} else if (cpl_op == CPL_FW6_PLD) {
@@ -1663,7 +1666,7 @@ csio_ln_prep_ecwr(struct csio_ioreq *io_req, uint32_t wr_len,
 		      uint32_t did, uint32_t flow_id, uint8_t *fw_wr)
 {
 	struct fw_fcoe_els_ct_wr *wr;
-	uint32_t port_id;
+	__be32 port_id;
 
 	wr  = (struct fw_fcoe_els_ct_wr *)fw_wr;
 	wr->op_immdlen = cpu_to_be32(FW_WR_OP(FW_FCOE_ELS_CT_WR) |
@@ -1676,8 +1679,8 @@ csio_ln_prep_ecwr(struct csio_ioreq *io_req, uint32_t wr_len,
 	wr->ctl_pri = 0;
 	wr->cp_en_class = 0;
 	wr->cookie = io_req->fw_handle;
-	wr->iqid = (uint16_t)cpu_to_be16(csio_q_physiqid(
-			io_req->lnode->hwp, io_req->iq_idx));
+	wr->iqid = cpu_to_be16(csio_q_physiqid(
+					io_req->lnode->hwp, io_req->iq_idx));
 	wr->fl_to_sp =  FW_FCOE_ELS_CT_WR_SP(1);
 	wr->tmo_val = (uint8_t) io_req->tmo;
 	port_id = htonl(sid);
diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 7aaf102..5b27c48 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1119,13 +1119,11 @@ csio_fcoe_read_portparams_init_mb(struct csio_hw *hw, struct csio_mb *mbp,
 } /* csio_fcoe_read_portparams_init_mb */
 
 void
-csio_mb_process_portparams_rsp(
-				struct csio_hw *hw,
+csio_mb_process_portparams_rsp(struct csio_hw *hw,
 				struct csio_mb *mbp,
 				enum fw_retval *retval,
 				struct fw_fcoe_port_cmd_params *portparams,
-				struct fw_fcoe_port_stats  *portstats
-			     )
+				struct fw_fcoe_port_stats *portstats)
 {
 	struct fw_fcoe_stats_cmd *rsp = (struct fw_fcoe_stats_cmd *)(mbp->mb);
 	struct fw_fcoe_port_stats stats;
@@ -1142,50 +1140,32 @@ csio_mb_process_portparams_rsp(
 		memcpy(dst, src, (portparams->nstats * 8));
 		if (portparams->idx == 1) {
 			/* Get the first 6 flits from the Mailbox */
-			portstats->tx_bcast_bytes	=
-					be64_to_cpu(stats.tx_bcast_bytes);
-			portstats->tx_bcast_frames	=
-					be64_to_cpu(stats.tx_bcast_frames);
-			portstats->tx_mcast_bytes	=
-					be64_to_cpu(stats.tx_mcast_bytes);
-			portstats->tx_mcast_frames	=
-					be64_to_cpu(stats.tx_mcast_frames);
-			portstats->tx_ucast_bytes	=
-					be64_to_cpu(stats.tx_ucast_bytes);
-			portstats->tx_ucast_frames	=
-					be64_to_cpu(stats.tx_ucast_frames);
+			portstats->tx_bcast_bytes = stats.tx_bcast_bytes;
+			portstats->tx_bcast_frames = stats.tx_bcast_frames;
+			portstats->tx_mcast_bytes = stats.tx_mcast_bytes;
+			portstats->tx_mcast_frames = stats.tx_mcast_frames;
+			portstats->tx_ucast_bytes = stats.tx_ucast_bytes;
+			portstats->tx_ucast_frames = stats.tx_ucast_frames;
 		}
 		if (portparams->idx == 7) {
 			/* Get the second 6 flits from the Mailbox */
-			portstats->tx_drop_frames	=
-				be64_to_cpu(stats.tx_drop_frames);
-			portstats->tx_offload_bytes	=
-				be64_to_cpu(stats.tx_offload_bytes);
-			portstats->tx_offload_frames	=
-				be64_to_cpu(stats.tx_offload_frames);
+			portstats->tx_drop_frames = stats.tx_drop_frames;
+			portstats->tx_offload_bytes = stats.tx_offload_bytes;
+			portstats->tx_offload_frames = stats.tx_offload_frames;
 #if 0
-			portstats->rx_pf_bytes		=
-					be64_to_cpu(stats.rx_pf_bytes);
-			portstats->rx_pf_frames		=
-					be64_to_cpu(stats.rx_pf_frames);
+			portstats->rx_pf_bytes = stats.rx_pf_bytes;
+			portstats->rx_pf_frames	= stats.rx_pf_frames;
 #endif
-			portstats->rx_bcast_bytes	=
-					be64_to_cpu(stats.rx_bcast_bytes);
-			portstats->rx_bcast_frames	=
-					be64_to_cpu(stats.rx_bcast_frames);
-			portstats->rx_mcast_bytes	=
-					be64_to_cpu(stats.rx_mcast_bytes);
+			portstats->rx_bcast_bytes = stats.rx_bcast_bytes;
+			portstats->rx_bcast_frames = stats.rx_bcast_frames;
+			portstats->rx_mcast_bytes = stats.rx_mcast_bytes;
 		}
 		if (portparams->idx == 13) {
 			/* Get the last 4 flits from the Mailbox */
-			portstats->rx_mcast_frames	=
-					be64_to_cpu(stats.rx_mcast_frames);
-			portstats->rx_ucast_bytes	=
-					be64_to_cpu(stats.rx_ucast_bytes);
-			portstats->rx_ucast_frames	=
-					be64_to_cpu(stats.rx_ucast_frames);
-			portstats->rx_err_frames	=
-					be64_to_cpu(stats.rx_err_frames);
+			portstats->rx_mcast_frames = stats.rx_mcast_frames;
+			portstats->rx_ucast_bytes = stats.rx_ucast_bytes;
+			portstats->rx_ucast_frames = stats.rx_ucast_frames;
+			portstats->rx_err_frames = stats.rx_err_frames;
 		}
 	}
 }
@@ -1414,7 +1394,7 @@ csio_mb_issue(struct csio_hw *hw, struct csio_mb *mbp)
 							  (hw, data_reg + i));
 			csio_wr_reg32(hw, 0, ctl_reg);
 
-			if (FW_CMD_RETVAL_GET(*(mbp->mb)))
+			if (csio_mb_fw_retval(mbp) != FW_SUCCESS)
 				CSIO_INC_STATS(mbm, n_err);
 
 			CSIO_INC_STATS(mbm, n_rsp);
diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/csio_rnode.c
index b0ae430..51c6a38 100644
--- a/drivers/scsi/csiostor/csio_rnode.c
+++ b/drivers/scsi/csiostor/csio_rnode.c
@@ -303,9 +303,9 @@ csio_confirm_rnode(struct csio_lnode *ln, uint32_t rdev_flowid,
 	uint8_t rport_type;
 	struct csio_rnode *rn, *match_rn;
 	uint32_t vnp_flowid;
-	uint32_t *port_id;
+	__be32 *port_id;
 
-	port_id = (uint32_t *)&rdevp->r_id[0];
+	port_id = (__be32 *)&rdevp->r_id[0];
 	rport_type =
 		FW_RDEV_WR_RPORT_TYPE_GET(rdevp->rd_xfer_rdy_to_rport_type);
 
@@ -439,9 +439,9 @@ csio_rn_verify_rparams(struct csio_lnode *ln, struct csio_rnode *rn,
 	uint8_t null[8];
 	uint8_t rport_type;
 	uint8_t fc_class;
-	uint32_t *did;
+	__be32 *did;
 
-	did = (uint32_t *) &rdevp->r_id[0];
+	did = (__be32 *) &rdevp->r_id[0];
 	rport_type =
 		FW_RDEV_WR_RPORT_TYPE_GET(rdevp->rd_xfer_rdy_to_rport_type);
 	switch (rport_type) {
@@ -529,9 +529,10 @@ csio_rn_verify_rparams(struct csio_lnode *ln, struct csio_rnode *rn,
 	rn->nport_id = (ntohl(*did) >> 8) & CSIO_DID_MASK;
 	memcpy(csio_rn_wwnn(rn), rdevp->wwnn, 8);
 	memcpy(csio_rn_wwpn(rn), rdevp->wwpn, 8);
-	rn->rn_sparm.csp.sp_bb_data = ntohs(rdevp->rcv_fr_sz);
+	rn->rn_sparm.csp.sp_bb_data = rdevp->rcv_fr_sz;
 	fc_class = FW_RDEV_WR_CLASS_GET(rdevp->vft_to_qos);
 	rn->rn_sparm.clsp[fc_class - 1].cp_class = htons(FC_CPC_VALID);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index fdbd7da..ddd38e5 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -237,7 +237,7 @@ csio_scsi_init_cmd_wr(struct csio_ioreq *req, void *addr, uint32_t size)
 						DIV_ROUND_UP(size, 16)));
 
 	wr->cookie = (uintptr_t) req;
-	wr->iqid = (uint16_t)cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
+	wr->iqid = cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
 	wr->tmo_val = (uint8_t) req->tmo;
 	wr->r3 = 0;
 	memset(&wr->r5, 0, 8);
@@ -396,7 +396,7 @@ csio_scsi_init_read_wr(struct csio_ioreq *req, void *wrp, uint32_t size)
 	wr->flowid_len16 = cpu_to_be32(FW_WR_FLOWID(rn->flowid) |
 				       FW_WR_LEN16(DIV_ROUND_UP(size, 16)));
 	wr->cookie = (uintptr_t)req;
-	wr->iqid = (uint16_t)cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
+	wr->iqid = cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
 	wr->tmo_val = (uint8_t)(req->tmo);
 	wr->use_xfer_cnt = 1;
 	wr->xfer_cnt = cpu_to_be32(scsi_bufflen(scmnd));
@@ -449,7 +449,7 @@ csio_scsi_init_write_wr(struct csio_ioreq *req, void *wrp, uint32_t size)
 	wr->flowid_len16 = cpu_to_be32(FW_WR_FLOWID(rn->flowid) |
 				       FW_WR_LEN16(DIV_ROUND_UP(size, 16)));
 	wr->cookie = (uintptr_t)req;
-	wr->iqid = (uint16_t)cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
+	wr->iqid = cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
 	wr->tmo_val = (uint8_t)(req->tmo);
 	wr->use_xfer_cnt = 1;
 	wr->xfer_cnt = cpu_to_be32(scsi_bufflen(scmnd));
@@ -680,7 +680,7 @@ csio_scsi_init_abrt_cls_wr(struct csio_ioreq *req, void *addr, uint32_t size,
 						DIV_ROUND_UP(size, 16)));
 
 	wr->cookie = (uintptr_t) req;
-	wr->iqid = (uint16_t)cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
+	wr->iqid = cpu_to_be16(csio_q_physiqid(hw, req->iq_idx));
 	wr->tmo_val = (uint8_t) req->tmo;
 	/* 0 for CHK_ALL_IO tells FW to look up t_cookie */
 	wr->sub_opcode_to_chk_all_io =
diff --git a/drivers/scsi/csiostor/t4fw_api_stor.h b/drivers/scsi/csiostor/t4fw_api_stor.h
index b96903a..1223e0d 100644
--- a/drivers/scsi/csiostor/t4fw_api_stor.h
+++ b/drivers/scsi/csiostor/t4fw_api_stor.h
@@ -221,7 +221,7 @@ struct fw_rdev_wr {
 struct fw_fcoe_els_ct_wr {
 	__be32 op_immdlen;
 	__be32 flowid_len16;
-	__be64 cookie;
+	u64    cookie;
 	__be16 iqid;
 	u8     tmo_val;
 	u8     els_ct_type;
@@ -246,7 +246,7 @@ struct fw_fcoe_els_ct_wr {
 struct fw_scsi_write_wr {
 	__be32 op_immdlen;
 	__be32 flowid_len16;
-	__be64 cookie;
+	u64    cookie;
 	__be16 iqid;
 	u8     tmo_val;
 	u8     use_xfer_cnt;
@@ -272,7 +272,7 @@ struct fw_scsi_write_wr {
 struct fw_scsi_read_wr {
 	__be32 op_immdlen;
 	__be32 flowid_len16;
-	__be64 cookie;
+	u64    cookie;
 	__be16 iqid;
 	u8     tmo_val;
 	u8     use_xfer_cnt;
@@ -298,7 +298,7 @@ struct fw_scsi_read_wr {
 struct fw_scsi_cmd_wr {
 	__be32 op_immdlen;
 	__be32 flowid_len16;
-	__be64 cookie;
+	u64    cookie;
 	__be16 iqid;
 	u8     tmo_val;
 	u8     r3;
@@ -326,12 +326,12 @@ struct fw_scsi_cmd_wr {
 struct fw_scsi_abrt_cls_wr {
 	__be32 op_immdlen;
 	__be32 flowid_len16;
-	__be64 cookie;
+	u64    cookie;
 	__be16 iqid;
 	u8     tmo_val;
 	u8     sub_opcode_to_chk_all_io;
 	u8     r3[4];
-	__be64 t_cookie;
+	u64    t_cookie;
 };
 
 #define FW_SCSI_ABRT_CLS_WR_SUB_OPCODE(x)	((x) << 2)
-- 
1.7.1

