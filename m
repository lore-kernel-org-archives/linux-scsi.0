From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/9] qla2xxx: Re-factor isp_operations to static structures.
Date: Thu, 19 Jul 2007 15:06:00 -0700
Message-ID: <11848827642053-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27113 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763594AbXGSWHF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:07:05 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

In preparation for new ISP types.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |   23 ++--
 drivers/scsi/qla2xxx/qla_def.h    |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c     |   33 +++--
 drivers/scsi/qla2xxx/qla_init.c   |   54 ++++----
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c    |   10 +-
 drivers/scsi/qla2xxx/qla_os.c     |  300 +++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_sup.c    |   12 +-
 9 files changed, 244 insertions(+), 196 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e406eae..362353d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -98,7 +98,7 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 
 	/* Read NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->nvram_base,
+	ha->isp_ops->read_nvram(ha, (uint8_t *)buf, ha->nvram_base,
 	    ha->nvram_size);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -143,7 +143,7 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops.write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
+	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
@@ -252,7 +252,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		}
 
 		memset(ha->optrom_buffer, 0, ha->optrom_size);
-		ha->isp_ops.read_optrom(ha, ha->optrom_buffer, 0,
+		ha->isp_ops->read_optrom(ha, ha->optrom_buffer, 0,
 		    ha->optrom_size);
 		break;
 	case 2:
@@ -275,7 +275,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		if (ha->optrom_state != QLA_SWRITING)
 			break;
 
-		ha->isp_ops.write_optrom(ha, ha->optrom_buffer, 0,
+		ha->isp_ops->write_optrom(ha, ha->optrom_buffer, 0,
 		    ha->optrom_size);
 		break;
 	}
@@ -305,7 +305,8 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 
 	/* Read NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->vpd_base, ha->vpd_size);
+	ha->isp_ops->read_nvram(ha, (uint8_t *)buf, ha->vpd_base,
+	    ha->vpd_size);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return ha->vpd_size;
@@ -325,7 +326,7 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops.write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
+	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return count;
@@ -437,7 +438,7 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *ha)
 	}
 
 	if (ha->beacon_blink_led == 1)
-		ha->isp_ops.beacon_off(ha);
+		ha->isp_ops->beacon_off(ha);
 }
 
 /* Scsi_Host attributes. */
@@ -455,7 +456,7 @@ qla2x00_fw_version_show(struct class_device *cdev, char *buf)
 	char fw_str[30];
 
 	return snprintf(buf, PAGE_SIZE, "%s\n",
-	    ha->isp_ops.fw_version_str(ha, fw_str));
+	    ha->isp_ops->fw_version_str(ha, fw_str));
 }
 
 static ssize_t
@@ -507,7 +508,7 @@ qla2x00_pci_info_show(struct class_device *cdev, char *buf)
 	char pci_info[30];
 
 	return snprintf(buf, PAGE_SIZE, "%s\n",
-	    ha->isp_ops.pci_info_str(ha, pci_info));
+	    ha->isp_ops->pci_info_str(ha, pci_info));
 }
 
 static ssize_t
@@ -652,9 +653,9 @@ qla2x00_beacon_store(struct class_device *cdev, const char *buf,
 		return -EINVAL;
 
 	if (val)
-		rval = ha->isp_ops.beacon_on(ha);
+		rval = ha->isp_ops->beacon_on(ha);
 	else
-		rval = ha->isp_ops.beacon_off(ha);
+		rval = ha->isp_ops->beacon_off(ha);
 
 	if (rval != QLA_SUCCESS)
 		count = 0;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f98eb63..27a2396 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2286,7 +2286,7 @@ typedef struct scsi_qla_host {
 	uint16_t        rsp_ring_index;     /* Current index. */
 	uint16_t	response_q_length;
 
-	struct isp_operations isp_ops;
+	struct isp_operations *isp_ops;
 
 	/* Outstandings ISP commands. */
 	srb_t		*outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 301279a..e393c84 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -180,7 +180,8 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
 
 	/* Issue GA_NXT */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GA_NXT_REQ_SIZE, GA_NXT_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GA_NXT_REQ_SIZE,
+	    GA_NXT_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GA_NXT_CMD,
@@ -266,7 +267,8 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
 
 	/* Issue GID_PT */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GID_PT_REQ_SIZE, GID_PT_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GID_PT_REQ_SIZE,
+	    GID_PT_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GID_PT_CMD,
@@ -338,7 +340,7 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GPN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GPN_ID_REQ_SIZE,
 		    GPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -399,7 +401,7 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GNN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GNN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GNN_ID_REQ_SIZE,
 		    GNN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -473,7 +475,8 @@ qla2x00_rft_id(scsi_qla_host_t *ha)
 
 	/* Issue RFT_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, RFT_ID_REQ_SIZE, RFT_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, RFT_ID_REQ_SIZE,
+	    RFT_ID_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFT_ID_CMD,
@@ -528,7 +531,8 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
 
 	/* Issue RFF_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, RFF_ID_REQ_SIZE, RFF_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, RFF_ID_REQ_SIZE,
+	    RFF_ID_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFF_ID_CMD,
@@ -582,7 +586,8 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 
 	/* Issue RNN_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, RNN_ID_REQ_SIZE, RNN_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, RNN_ID_REQ_SIZE,
+	    RNN_ID_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RNN_ID_CMD,
@@ -645,7 +650,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	/* Issue RSNN_NN */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, 0, RSNN_NN_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, 0, RSNN_NN_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RSNN_NN_CMD,
@@ -1102,7 +1107,7 @@ qla2x00_mgmt_svr_login(scsi_qla_host_t *ha)
 	if (ha->flags.management_server_logged_in)
 		return ret;
 
-	ha->isp_ops.fabric_login(ha, ha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
+	ha->isp_ops->fabric_login(ha, ha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
 	    mb, BIT_1);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
 		DEBUG2_13(printk("%s(%ld): Failed MANAGEMENT_SERVER login: "
@@ -1253,7 +1258,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	/* Issue RHBA */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops.prep_ms_fdmi_iocb(ha, 0, RHBA_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(ha, 0, RHBA_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RHBA_CMD,
@@ -1373,7 +1378,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	/* Firmware version */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
-	ha->isp_ops.fw_version_str(ha, eiter->a.fw_version);
+	ha->isp_ops->fw_version_str(ha, eiter->a.fw_version);
 	alen = strlen(eiter->a.fw_version);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
@@ -1439,7 +1444,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *ha)
 
 	/* Issue RPA */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops.prep_ms_fdmi_iocb(ha, DHBA_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(ha, DHBA_REQ_SIZE,
 	    DHBA_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -1497,7 +1502,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	/* Issue RPA */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops.prep_ms_fdmi_iocb(ha, 0, RPA_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(ha, 0, RPA_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RPA_CMD,
@@ -1697,7 +1702,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		memset(list[i].fabric_port_name, 0, WWN_SIZE);
 
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GFPN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GFPN_ID_REQ_SIZE,
 		    GFPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dbf64bb..401a879 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -79,20 +79,20 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
-	rval = ha->isp_ops.pci_config(ha);
+	rval = ha->isp_ops->pci_config(ha);
 	if (rval) {
 		DEBUG2(printk("scsi(%ld): Unable to configure PCI space.\n",
 		    ha->host_no));
 		return (rval);
 	}
 
-	ha->isp_ops.reset_chip(ha);
+	ha->isp_ops->reset_chip(ha);
 
-	ha->isp_ops.get_flash_version(ha, ha->request_ring);
+	ha->isp_ops->get_flash_version(ha, ha->request_ring);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 
-	ha->isp_ops.nvram_config(ha);
+	ha->isp_ops->nvram_config(ha);
 
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
@@ -108,7 +108,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
 	if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
-		rval = ha->isp_ops.chip_diag(ha);
+		rval = ha->isp_ops->chip_diag(ha);
 		if (rval)
 			return (rval);
 		rval = qla2x00_setup_chip(ha);
@@ -351,7 +351,7 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
 	uint32_t	cnt;
 	uint16_t	cmd;
 
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -551,7 +551,7 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 void
 qla24xx_reset_chip(scsi_qla_host_t *ha)
 {
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 
 	/* Perform RISC reset. */
 	qla24xx_reset_risc(ha);
@@ -879,7 +879,7 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 	uint32_t srisc_address = 0;
 
 	/* Load firmware sequences */
-	rval = ha->isp_ops.load_risc(ha, &srisc_address);
+	rval = ha->isp_ops->load_risc(ha, &srisc_address);
 	if (rval == QLA_SUCCESS) {
 		DEBUG(printk("scsi(%ld): Verifying Checksum of loaded RISC "
 		    "code.\n", ha->host_no));
@@ -1130,12 +1130,12 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	/* Initialize response queue entries */
 	qla2x00_init_response_q_entries(ha);
 
-	ha->isp_ops.config_rings(ha);
+	ha->isp_ops->config_rings(ha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Update any ISP specific firmware options before initialization. */
-	ha->isp_ops.update_fw_options(ha);
+	ha->isp_ops->update_fw_options(ha);
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 
@@ -1459,7 +1459,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 			ha->nvram_base = 0x80;
 
 	/* Get NVRAM data and calculate checksum. */
-	ha->isp_ops.read_nvram(ha, ptr, ha->nvram_base, ha->nvram_size);
+	ha->isp_ops->read_nvram(ha, ptr, ha->nvram_base, ha->nvram_size);
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size; cnt++)
 		chksum += *ptr++;
 
@@ -2298,7 +2298,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 			loop_id = NPH_SNS;
 		else
 			loop_id = SIMPLE_NAME_SERVER;
-		ha->isp_ops.fabric_login(ha, loop_id, 0xff, 0xff,
+		ha->isp_ops->fabric_login(ha, loop_id, 0xff, 0xff,
 		    0xfc, mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2(qla_printk(KERN_INFO, ha,
@@ -2355,7 +2355,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 				    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
-					ha->isp_ops.fabric_logout(ha,
+					ha->isp_ops->fabric_logout(ha,
 					    fcport->loop_id,
 					    fcport->d_id.b.domain,
 					    fcport->d_id.b.area,
@@ -2664,7 +2664,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 			    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
-				ha->isp_ops.fabric_logout(ha, fcport->loop_id,
+				ha->isp_ops->fabric_logout(ha, fcport->loop_id,
 				    fcport->d_id.b.domain, fcport->d_id.b.area,
 				    fcport->d_id.b.al_pa);
 				fcport->loop_id = FC_NO_LOOP_ID;
@@ -2919,7 +2919,7 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 			opts |= BIT_1;
 		rval = qla2x00_get_port_database(ha, fcport, opts);
 		if (rval != QLA_SUCCESS) {
-			ha->isp_ops.fabric_logout(ha, fcport->loop_id,
+			ha->isp_ops->fabric_logout(ha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
 			qla2x00_mark_device_lost(ha, fcport, 1, 0);
@@ -2964,7 +2964,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa));
 
 		/* Login fcport on switch. */
-		ha->isp_ops.fabric_login(ha, fcport->loop_id,
+		ha->isp_ops->fabric_login(ha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb, BIT_0);
 		if (mb[0] == MBS_PORT_ID_USED) {
@@ -3032,7 +3032,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 			 * dead.
 			 */
 			*next_loopid = fcport->loop_id;
-			ha->isp_ops.fabric_logout(ha, fcport->loop_id,
+			ha->isp_ops->fabric_logout(ha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
 			qla2x00_mark_device_lost(ha, fcport, 1, 0);
@@ -3050,7 +3050,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 			    fcport->d_id.b.al_pa, fcport->loop_id, jiffies));
 
 			*next_loopid = fcport->loop_id;
-			ha->isp_ops.fabric_logout(ha, fcport->loop_id,
+			ha->isp_ops->fabric_logout(ha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
 			fcport->loop_id = FC_NO_LOOP_ID;
@@ -3206,7 +3206,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 		qla_printk(KERN_INFO, ha,
 		    "Performing ISP error recovery - ha= %p.\n", ha);
-		ha->isp_ops.reset_chip(ha);
+		ha->isp_ops->reset_chip(ha);
 
 		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
@@ -3232,9 +3232,9 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		ha->isp_ops.get_flash_version(ha, ha->request_ring);
+		ha->isp_ops->get_flash_version(ha, ha->request_ring);
 
-		ha->isp_ops.nvram_config(ha);
+		ha->isp_ops->nvram_config(ha);
 
 		if (!qla2x00_restart_isp(ha)) {
 			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
@@ -3249,7 +3249,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 			ha->flags.online = 1;
 
-			ha->isp_ops.enable_intrs(ha);
+			ha->isp_ops->enable_intrs(ha);
 
 			ha->isp_abort_cnt = 0;
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
@@ -3274,7 +3274,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 					 * The next call disables the board
 					 * completely.
 					 */
-					ha->isp_ops.reset_adapter(ha);
+					ha->isp_ops->reset_adapter(ha);
 					ha->flags.online = 0;
 					clear_bit(ISP_ABORT_RETRY,
 					    &ha->dpc_flags);
@@ -3331,7 +3331,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
 		ha->flags.online = 0;
-		if (!(status = ha->isp_ops.chip_diag(ha))) {
+		if (!(status = ha->isp_ops->chip_diag(ha))) {
 			if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 				status = qla2x00_setup_chip(ha);
 				goto done;
@@ -3423,7 +3423,7 @@ qla2x00_reset_adapter(scsi_qla_host_t *ha)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	ha->flags.online = 0;
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
@@ -3440,7 +3440,7 @@ qla24xx_reset_adapter(scsi_qla_host_t *ha)
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	ha->flags.online = 0;
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
@@ -3498,7 +3498,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 
 	/* Get NVRAM data and calculate checksum. */
 	dptr = (uint32_t *)nv;
-	ha->isp_ops.read_nvram(ha, (uint8_t *)dptr, ha->nvram_base,
+	ha->isp_ops->read_nvram(ha, (uint8_t *)dptr, ha->nvram_base,
 	    ha->nvram_size);
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 91706db..8e3b044 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -104,7 +104,7 @@ static __inline__ void qla2x00_poll(scsi_qla_host_t *);
 static inline void
 qla2x00_poll(scsi_qla_host_t *ha)
 {
-	ha->isp_ops.intr_handler(0, ha);
+	ha->isp_ops->intr_handler(0, ha);
 }
 
 static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 49208c6..3a5e78c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -326,7 +326,7 @@ qla2x00_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 
 	/* Calculate the number of request entries needed. */
-	req_cnt = ha->isp_ops.calc_req_entries(tot_dsds);
+	req_cnt = ha->isp_ops->calc_req_entries(tot_dsds);
 	if (ha->req_q_cnt < (req_cnt + 2)) {
 		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
 		if (ha->req_ring_index < cnt)
@@ -364,7 +364,7 @@ qla2x00_start_scsi(srb_t *sp)
 	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
 
 	/* Build IOCB segments */
-	ha->isp_ops.build_iocbs(sp, cmd_pkt, tot_dsds);
+	ha->isp_ops->build_iocbs(sp, cmd_pkt, tot_dsds);
 
 	/* Set total data segment count. */
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4a50b93..259710b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -143,7 +143,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
 
-			ha->isp_ops.fw_dump(ha, 1);
+			ha->isp_ops->fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
 		} else if ((stat & HSR_RISC_INT) == 0)
@@ -334,7 +334,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
 
-		ha->isp_ops.fw_dump(ha, 1);
+		ha->isp_ops->fw_dump(ha, 1);
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
@@ -1502,7 +1502,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
-			ha->isp_ops.fw_dump(ha, 1);
+			ha->isp_ops->fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
@@ -1636,7 +1636,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
-			ha->isp_ops.fw_dump(ha, 1);
+			ha->isp_ops->fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
@@ -1791,7 +1791,7 @@ skip_msix:
 	}
 skip_msi:
 
-	ret = request_irq(ha->pdev->irq, ha->isp_ops.intr_handler,
+	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
 	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
 	if (!ret) {
 		ha->flags.inta_enabled = 1;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d19fd79..e870e7c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -681,7 +681,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		DEBUG3(qla2x00_print_scsi_cmd(cmd));
 
 		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		if (ha->isp_ops.abort_command(ha, sp)) {
+		if (ha->isp_ops->abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
 		} else {
@@ -813,7 +813,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 #if defined(LOGOUT_AFTER_DEVICE_RESET)
 		if (ret == SUCCESS) {
 			if (fcport->flags & FC_FABRIC_DEVICE) {
-				ha->isp_ops.fabric_logout(ha, fcport->loop_id);
+				ha->isp_ops->fabric_logout(ha, fcport->loop_id);
 				qla2x00_mark_device_lost(ha, fcport, 0, 0);
 			}
 		}
@@ -1105,7 +1105,7 @@ static int
 qla2x00_device_reset(scsi_qla_host_t *ha, fc_port_t *reset_fcport)
 {
 	/* Abort Target command will clear Reservation */
-	return ha->isp_ops.abort_target(reset_fcport);
+	return ha->isp_ops->abort_target(reset_fcport);
 }
 
 static int
@@ -1184,8 +1184,8 @@ qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
 		    !pci_set_consistent_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
 			/* Ok, a 64bit DMA mask is applicable. */
 			ha->flags.enable_64bit_addressing = 1;
-			ha->isp_ops.calc_req_entries = qla2x00_calc_iocbs_64;
-			ha->isp_ops.build_iocbs = qla2x00_build_scsi_iocbs_64;
+			ha->isp_ops->calc_req_entries = qla2x00_calc_iocbs_64;
+			ha->isp_ops->build_iocbs = qla2x00_build_scsi_iocbs_64;
 			return;
 		}
 	}
@@ -1194,6 +1194,160 @@ qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
 	pci_set_consistent_dma_mask(ha->pdev, DMA_32BIT_MASK);
 }
 
+static void
+qla2x00_enable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 1;
+	/* enable risc and host interrupts */
+	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
+	RD_REG_WORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+}
+
+static void
+qla2x00_disable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 0;
+	/* disable risc and host interrupts */
+	WRT_REG_WORD(&reg->ictrl, 0);
+	RD_REG_WORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static void
+qla24xx_enable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 1;
+	WRT_REG_DWORD(&reg->ictrl, ICRX_EN_RISC_INT);
+	RD_REG_DWORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static void
+qla24xx_disable_intrs(scsi_qla_host_t *ha)
+{
+	unsigned long flags = 0;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->interrupts_on = 0;
+	WRT_REG_DWORD(&reg->ictrl, 0);
+	RD_REG_DWORD(&reg->ictrl);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static struct isp_operations qla2100_isp_ops = {
+	.pci_config		= qla2100_pci_config,
+	.reset_chip		= qla2x00_reset_chip,
+	.chip_diag		= qla2x00_chip_diag,
+	.config_rings		= qla2x00_config_rings,
+	.reset_adapter		= qla2x00_reset_adapter,
+	.nvram_config		= qla2x00_nvram_config,
+	.update_fw_options	= qla2x00_update_fw_options,
+	.load_risc		= qla2x00_load_risc,
+	.pci_info_str		= qla2x00_pci_info_str,
+	.fw_version_str		= qla2x00_fw_version_str,
+	.intr_handler		= qla2100_intr_handler,
+	.enable_intrs		= qla2x00_enable_intrs,
+	.disable_intrs		= qla2x00_disable_intrs,
+	.abort_command		= qla2x00_abort_command,
+	.abort_target		= qla2x00_abort_target,
+	.fabric_login		= qla2x00_login_fabric,
+	.fabric_logout		= qla2x00_fabric_logout,
+	.calc_req_entries	= qla2x00_calc_iocbs_32,
+	.build_iocbs		= qla2x00_build_scsi_iocbs_32,
+	.prep_ms_iocb		= qla2x00_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla2x00_prep_ms_fdmi_iocb,
+	.read_nvram		= qla2x00_read_nvram_data,
+	.write_nvram		= qla2x00_write_nvram_data,
+	.fw_dump		= qla2100_fw_dump,
+	.beacon_on		= NULL,
+	.beacon_off		= NULL,
+	.beacon_blink		= NULL,
+	.read_optrom		= qla2x00_read_optrom_data,
+	.write_optrom		= qla2x00_write_optrom_data,
+	.get_flash_version	= qla2x00_get_flash_version,
+};
+
+static struct isp_operations qla2300_isp_ops = {
+	.pci_config		= qla2300_pci_config,
+	.reset_chip		= qla2x00_reset_chip,
+	.chip_diag		= qla2x00_chip_diag,
+	.config_rings		= qla2x00_config_rings,
+	.reset_adapter		= qla2x00_reset_adapter,
+	.nvram_config		= qla2x00_nvram_config,
+	.update_fw_options	= qla2x00_update_fw_options,
+	.load_risc		= qla2x00_load_risc,
+	.pci_info_str		= qla2x00_pci_info_str,
+	.fw_version_str		= qla2x00_fw_version_str,
+	.intr_handler		= qla2300_intr_handler,
+	.enable_intrs		= qla2x00_enable_intrs,
+	.disable_intrs		= qla2x00_disable_intrs,
+	.abort_command		= qla2x00_abort_command,
+	.abort_target		= qla2x00_abort_target,
+	.fabric_login		= qla2x00_login_fabric,
+	.fabric_logout		= qla2x00_fabric_logout,
+	.calc_req_entries	= qla2x00_calc_iocbs_32,
+	.build_iocbs		= qla2x00_build_scsi_iocbs_32,
+	.prep_ms_iocb		= qla2x00_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla2x00_prep_ms_fdmi_iocb,
+	.read_nvram		= qla2x00_read_nvram_data,
+	.write_nvram		= qla2x00_write_nvram_data,
+	.fw_dump		= qla2300_fw_dump,
+	.beacon_on		= qla2x00_beacon_on,
+	.beacon_off		= qla2x00_beacon_off,
+	.beacon_blink		= qla2x00_beacon_blink,
+	.read_optrom		= qla2x00_read_optrom_data,
+	.write_optrom		= qla2x00_write_optrom_data,
+	.get_flash_version	= qla2x00_get_flash_version,
+};
+
+static struct isp_operations qla24xx_isp_ops = {
+	.pci_config		= qla24xx_pci_config,
+	.reset_chip		= qla24xx_reset_chip,
+	.chip_diag		= qla24xx_chip_diag,
+	.config_rings		= qla24xx_config_rings,
+	.reset_adapter		= qla24xx_reset_adapter,
+	.nvram_config		= qla24xx_nvram_config,
+	.update_fw_options	= qla24xx_update_fw_options,
+	.load_risc		= qla24xx_load_risc,
+	.pci_info_str		= qla24xx_pci_info_str,
+	.fw_version_str		= qla24xx_fw_version_str,
+	.intr_handler		= qla24xx_intr_handler,
+	.enable_intrs		= qla24xx_enable_intrs,
+	.disable_intrs		= qla24xx_disable_intrs,
+	.abort_command		= qla24xx_abort_command,
+	.abort_target		= qla24xx_abort_target,
+	.fabric_login		= qla24xx_login_fabric,
+	.fabric_logout		= qla24xx_fabric_logout,
+	.calc_req_entries	= NULL,
+	.build_iocbs		= NULL,
+	.prep_ms_iocb		= qla24xx_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla24xx_prep_ms_fdmi_iocb,
+	.read_nvram		= qla24xx_read_nvram_data,
+	.write_nvram		= qla24xx_write_nvram_data,
+	.fw_dump		= qla24xx_fw_dump,
+	.beacon_on		= qla24xx_beacon_on,
+	.beacon_off		= qla24xx_beacon_off,
+	.beacon_blink		= qla24xx_beacon_blink,
+	.read_optrom		= qla24xx_read_optrom_data,
+	.write_optrom		= qla24xx_write_optrom_data,
+	.get_flash_version	= qla24xx_get_flash_version,
+};
+
 static inline void
 qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 {
@@ -1329,61 +1483,6 @@ iospace_error_exit:
 }
 
 static void
-qla2x00_enable_intrs(scsi_qla_host_t *ha)
-{
-	unsigned long flags = 0;
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->interrupts_on = 1;
-	/* enable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
-	RD_REG_WORD(&reg->ictrl);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-}
-
-static void
-qla2x00_disable_intrs(scsi_qla_host_t *ha)
-{
-	unsigned long flags = 0;
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->interrupts_on = 0;
-	/* disable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, 0);
-	RD_REG_WORD(&reg->ictrl);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-static void
-qla24xx_enable_intrs(scsi_qla_host_t *ha)
-{
-	unsigned long flags = 0;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->interrupts_on = 1;
-	WRT_REG_DWORD(&reg->ictrl, ICRX_EN_RISC_INT);
-	RD_REG_DWORD(&reg->ictrl);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-static void
-qla24xx_disable_intrs(scsi_qla_host_t *ha)
-{
-	unsigned long flags = 0;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->interrupts_on = 0;
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-static void
 qla2xxx_scan_start(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
@@ -1472,33 +1571,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->max_q_depth = ql2xmaxqdepth;
 
 	/* Assign ISP specific operations. */
-	ha->isp_ops.pci_config		= qla2100_pci_config;
-	ha->isp_ops.reset_chip		= qla2x00_reset_chip;
-	ha->isp_ops.chip_diag		= qla2x00_chip_diag;
-	ha->isp_ops.config_rings	= qla2x00_config_rings;
-	ha->isp_ops.reset_adapter	= qla2x00_reset_adapter;
-	ha->isp_ops.nvram_config	= qla2x00_nvram_config;
-	ha->isp_ops.update_fw_options	= qla2x00_update_fw_options;
-	ha->isp_ops.load_risc		= qla2x00_load_risc;
-	ha->isp_ops.pci_info_str	= qla2x00_pci_info_str;
-	ha->isp_ops.fw_version_str	= qla2x00_fw_version_str;
-	ha->isp_ops.intr_handler	= qla2100_intr_handler;
-	ha->isp_ops.enable_intrs	= qla2x00_enable_intrs;
-	ha->isp_ops.disable_intrs	= qla2x00_disable_intrs;
-	ha->isp_ops.abort_command	= qla2x00_abort_command;
-	ha->isp_ops.abort_target	= qla2x00_abort_target;
-	ha->isp_ops.fabric_login	= qla2x00_login_fabric;
-	ha->isp_ops.fabric_logout	= qla2x00_fabric_logout;
-	ha->isp_ops.calc_req_entries	= qla2x00_calc_iocbs_32;
-	ha->isp_ops.build_iocbs		= qla2x00_build_scsi_iocbs_32;
-	ha->isp_ops.prep_ms_iocb	= qla2x00_prep_ms_iocb;
-	ha->isp_ops.prep_ms_fdmi_iocb	= qla2x00_prep_ms_fdmi_iocb;
-	ha->isp_ops.read_nvram		= qla2x00_read_nvram_data;
-	ha->isp_ops.write_nvram		= qla2x00_write_nvram_data;
-	ha->isp_ops.fw_dump		= qla2100_fw_dump;
-	ha->isp_ops.read_optrom		= qla2x00_read_optrom_data;
-	ha->isp_ops.write_optrom	= qla2x00_write_optrom_data;
-	ha->isp_ops.get_flash_version	= qla2x00_get_flash_version;
 	if (IS_QLA2100(ha)) {
 		host->max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
@@ -1507,6 +1579,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 		host->sg_tablesize = 32;
 		ha->gid_list_info_size = 4;
+		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA2200(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1514,21 +1587,17 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
+		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA23XX(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
-		ha->isp_ops.pci_config = qla2300_pci_config;
-		ha->isp_ops.intr_handler = qla2300_intr_handler;
-		ha->isp_ops.fw_dump = qla2300_fw_dump;
-		ha->isp_ops.beacon_on = qla2x00_beacon_on;
-		ha->isp_ops.beacon_off = qla2x00_beacon_off;
-		ha->isp_ops.beacon_blink = qla2x00_beacon_blink;
 		ha->gid_list_info_size = 6;
 		if (IS_QLA2322(ha) || IS_QLA6322(ha))
 			ha->optrom_size = OPTROM_SIZE_2322;
+		ha->isp_ops = &qla2300_isp_ops;
 	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1537,36 +1606,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
-		ha->isp_ops.pci_config = qla24xx_pci_config;
-		ha->isp_ops.reset_chip = qla24xx_reset_chip;
-		ha->isp_ops.chip_diag = qla24xx_chip_diag;
-		ha->isp_ops.config_rings = qla24xx_config_rings;
-		ha->isp_ops.reset_adapter = qla24xx_reset_adapter;
-		ha->isp_ops.nvram_config = qla24xx_nvram_config;
-		ha->isp_ops.update_fw_options = qla24xx_update_fw_options;
-		ha->isp_ops.load_risc = qla24xx_load_risc;
-		ha->isp_ops.pci_info_str = qla24xx_pci_info_str;
-		ha->isp_ops.fw_version_str = qla24xx_fw_version_str;
-		ha->isp_ops.intr_handler = qla24xx_intr_handler;
-		ha->isp_ops.enable_intrs = qla24xx_enable_intrs;
-		ha->isp_ops.disable_intrs = qla24xx_disable_intrs;
-		ha->isp_ops.abort_command = qla24xx_abort_command;
-		ha->isp_ops.abort_target = qla24xx_abort_target;
-		ha->isp_ops.fabric_login = qla24xx_login_fabric;
-		ha->isp_ops.fabric_logout = qla24xx_fabric_logout;
-		ha->isp_ops.prep_ms_iocb = qla24xx_prep_ms_iocb;
-		ha->isp_ops.prep_ms_fdmi_iocb = qla24xx_prep_ms_fdmi_iocb;
-		ha->isp_ops.read_nvram = qla24xx_read_nvram_data;
-		ha->isp_ops.write_nvram = qla24xx_write_nvram_data;
-		ha->isp_ops.fw_dump = qla24xx_fw_dump;
-		ha->isp_ops.read_optrom	= qla24xx_read_optrom_data;
-		ha->isp_ops.write_optrom = qla24xx_write_optrom_data;
-		ha->isp_ops.beacon_on = qla24xx_beacon_on;
-		ha->isp_ops.beacon_off = qla24xx_beacon_off;
-		ha->isp_ops.beacon_blink = qla24xx_beacon_blink;
-		ha->isp_ops.get_flash_version = qla24xx_get_flash_version;
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_24XX;
+		ha->isp_ops = &qla24xx_isp_ops;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -1634,7 +1676,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    ha->host_no, ha));
 
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	reg = ha->iobase;
@@ -1660,7 +1702,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ha->isp_ops.enable_intrs(ha);
+	ha->isp_ops->enable_intrs(ha);
 
 	pci_set_drvdata(pdev, ha);
 
@@ -1685,9 +1727,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
 	    qla2x00_version_str, ha->model_number,
 	    ha->model_desc ? ha->model_desc: "", pdev->device,
-	    ha->isp_ops.pci_info_str(ha, pci_info), pci_name(pdev),
+	    ha->isp_ops->pci_info_str(ha, pci_info), pci_name(pdev),
 	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
-	    ha->isp_ops.fw_version_str(ha, fw_str));
+	    ha->isp_ops->fw_version_str(ha, fw_str));
 
 	return 0;
 
@@ -1753,7 +1795,7 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
-		ha->isp_ops.disable_intrs(ha);
+		ha->isp_ops->disable_intrs(ha);
 
 	qla2x00_mem_free(ha);
 
@@ -2311,7 +2353,7 @@ qla2x00_do_dpc(void *data)
 					if (fcport->flags & FCF_FABRIC_DEVICE) {
 						if (fcport->flags &
 						    FCF_TAPE_PRESENT)
-							ha->isp_ops.fabric_logout(
+							ha->isp_ops->fabric_logout(
 							    ha, fcport->loop_id,
 							    fcport->d_id.b.domain,
 							    fcport->d_id.b.area,
@@ -2391,10 +2433,10 @@ qla2x00_do_dpc(void *data)
 		}
 
 		if (!ha->interrupts_on)
-			ha->isp_ops.enable_intrs(ha);
+			ha->isp_ops->enable_intrs(ha);
 
 		if (test_and_clear_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags))
-			ha->isp_ops.beacon_blink(ha);
+			ha->isp_ops->beacon_blink(ha);
 
 		qla2x00_do_dpc_all_vps(ha);
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 206bda0..aafd604 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -919,7 +919,7 @@ qla2x00_beacon_off(struct scsi_qla_host *ha)
 	else
 		ha->beacon_color_state = QLA_LED_GRN_ON;
 
-	ha->isp_ops.beacon_blink(ha);	/* This turns green LED off */
+	ha->isp_ops->beacon_blink(ha);	/* This turns green LED off */
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
 	ha->fw_options[1] &= ~FO1_DISABLE_GPIO6_7;
@@ -1031,7 +1031,7 @@ qla24xx_beacon_off(struct scsi_qla_host *ha)
 	ha->beacon_blink_led = 0;
 	ha->beacon_color_state = QLA_LED_ALL_ON;
 
-	ha->isp_ops.beacon_blink(ha);	/* Will flip to all off. */
+	ha->isp_ops->beacon_blink(ha);	/* Will flip to all off. */
 
 	/* Give control back to firmware. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1419,7 +1419,7 @@ qla2x00_suspend_hba(struct scsi_qla_host *ha)
 
 	/* Suspend HBA. */
 	scsi_block_requests(ha->host);
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Pause RISC. */
@@ -1705,7 +1705,7 @@ qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 {
 	/* Suspend HBA. */
 	scsi_block_requests(ha->host);
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with read. */
@@ -1713,7 +1713,7 @@ qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	ha->isp_ops.enable_intrs(ha);
+	ha->isp_ops->enable_intrs(ha);
 	scsi_unblock_requests(ha->host);
 
 	return buf;
@@ -1727,7 +1727,7 @@ qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 
 	/* Suspend HBA. */
 	scsi_block_requests(ha->host);
-	ha->isp_ops.disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with write. */
-- 
1.5.3.rc2.4.g726f9

