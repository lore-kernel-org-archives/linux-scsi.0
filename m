From: <kgudipat@brocade.com>
Subject: [PATCH 17/23] bfa: Replace bfa_get_attr() with specific APIs
Date: Fri, 5 Mar 2010 19:37:57 -0800
Message-ID: <1267846677-23147-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:18091 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab0CFDiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:38:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- bfa_ioc_attr_s is a big structure and some times could cause
	  stack overflow if defined locally, so add specific APIs that
	  are needed to replace the use of ioc_attr local var.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c         |   33 ++------
 drivers/scsi/bfa/bfa_fcs_lport.c      |   26 +-----
 drivers/scsi/bfa/bfa_ioc.c            |  155 ++++++++++++++++++++-------------
 drivers/scsi/bfa/bfa_ioc.h            |   10 ++
 drivers/scsi/bfa/bfa_lps.c            |    6 +-
 drivers/scsi/bfa/bfad.c               |    4 +-
 drivers/scsi/bfa/bfad_attr.c          |   62 +++++--------
 drivers/scsi/bfa/bfad_drv.h           |   13 +++
 drivers/scsi/bfa/bfad_im.c            |   29 +++----
 drivers/scsi/bfa/fabric.c             |   10 +--
 drivers/scsi/bfa/fcpim.c              |   15 +---
 drivers/scsi/bfa/include/bfa.h        |   20 ++++
 drivers/scsi/bfa/include/cs/bfa_log.h |    2 +-
 drivers/scsi/bfa/rport.c              |    7 +-
 drivers/scsi/bfa/vport.c              |   18 +----
 15 files changed, 195 insertions(+), 215 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index a48413c..0da6120 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -145,35 +145,12 @@ bfa_fcport_aen_post(struct bfa_fcport_s *fcport, enum bfa_port_aen_event event)
 	struct bfa_log_mod_s *logmod = fcport->bfa->logm;
 	wwn_t           pwwn = fcport->pwwn;
 	char            pwwn_ptr[BFA_STRING_32];
-	struct bfa_ioc_attr_s ioc_attr;
 
 	memset(&aen_data, 0, sizeof(aen_data));
 	wwn2str(pwwn_ptr, pwwn);
-	switch (event) {
-	case BFA_PORT_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_PORT_ONLINE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_PORT_OFFLINE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_ENABLE:
-		bfa_log(logmod, BFA_AEN_PORT_ENABLE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_DISABLE:
-		bfa_log(logmod, BFA_AEN_PORT_DISABLE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_PORT_DISCONNECT, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_QOS_NEG:
-		bfa_log(logmod, BFA_AEN_PORT_QOS_NEG, pwwn_ptr);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, event), pwwn_ptr);
 
-	bfa_ioc_get_attr(&fcport->bfa->ioc, &ioc_attr);
-	aen_data.port.ioc_type = ioc_attr.ioc_type;
+	aen_data.port.ioc_type = bfa_get_type(fcport->bfa);
 	aen_data.port.pwwn = pwwn;
 }
 
@@ -2043,11 +2020,15 @@ void
 bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	enum bfa_ioc_type_e ioc_type = bfa_get_type(bfa);
 
 	bfa_trc(bfa, on_off);
 	bfa_trc(bfa, fcport->cfg.qos_enabled);
 
-	fcport->cfg.qos_enabled = on_off;
+	bfa_trc(bfa, ioc_type);
+
+	if (ioc_type == BFA_IOC_TYPE_FC)
+		fcport->cfg.qos_enabled = on_off;
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 4a51aac..7c1251c 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -263,30 +263,8 @@ bfa_fcs_port_aen_post(struct bfa_fcs_port_s *port,
 
 	bfa_assert(role <= BFA_PORT_ROLE_FCP_MAX);
 
-	switch (event) {
-	case BFA_LPORT_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_LPORT_ONLINE, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_LPORT_OFFLINE, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_NEW:
-		bfa_log(logmod, BFA_AEN_LPORT_NEW, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_DELETE:
-		bfa_log(logmod, BFA_AEN_LPORT_DELETE, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_LPORT_DISCONNECT, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, event), lpwwn_ptr,
+		role_str[role/2]);
 
 	aen_data.lport.vf_id = port->fabric->vf_id;
 	aen_data.lport.roles = role;
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 4d9a47c..e038bc9 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1679,46 +1679,28 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 			 struct bfa_adapter_attr_s *ad_attr)
 {
 	struct bfi_ioc_attr_s *ioc_attr;
-	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
 
 	ioc_attr = ioc->attr;
-	bfa_os_memcpy((void *)&ad_attr->serial_num,
-		      (void *)ioc_attr->brcd_serialnum,
-		      BFA_ADAPTER_SERIAL_NUM_LEN);
-
-	bfa_os_memcpy(&ad_attr->fw_ver, ioc_attr->fw_version, BFA_VERSION_LEN);
-	bfa_os_memcpy(&ad_attr->optrom_ver, ioc_attr->optrom_version,
-		      BFA_VERSION_LEN);
-	bfa_os_memcpy(&ad_attr->manufacturer, BFA_MFG_NAME,
-		      BFA_ADAPTER_MFG_NAME_LEN);
+
+	bfa_ioc_get_adapter_serial_num(ioc, ad_attr->serial_num);
+	bfa_ioc_get_adapter_fw_ver(ioc, ad_attr->fw_ver);
+	bfa_ioc_get_adapter_optrom_ver(ioc, ad_attr->optrom_ver);
+	bfa_ioc_get_adapter_manufacturer(ioc, ad_attr->manufacturer);
 	bfa_os_memcpy(&ad_attr->vpd, &ioc_attr->vpd,
 		      sizeof(struct bfa_mfg_vpd_s));
 
-	ad_attr->nports = BFI_ADAPTER_GETP(NPORTS, ioc_attr->adapter_prop);
-	ad_attr->max_speed = BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
+	ad_attr->nports = bfa_ioc_get_nports(ioc);
+	ad_attr->max_speed = bfa_ioc_speed_sup(ioc);
 
-	/**
-	 * model name
-	 */
-	if (BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop) == 10) {
-		strcpy(model, "BR-10?0");
-		model[5] = '0' + ad_attr->nports;
-	} else {
-		strcpy(model, "Brocade-??5");
-		model[8] =
-			'0' + BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
-		model[9] = '0' + ad_attr->nports;
-	}
+	bfa_ioc_get_adapter_model(ioc, ad_attr->model);
+	/* For now, model descr uses same model string */
+	bfa_ioc_get_adapter_model(ioc, ad_attr->model_descr);
 
 	if (BFI_ADAPTER_IS_SPECIAL(ioc_attr->adapter_prop))
 		ad_attr->prototype = 1;
 	else
 		ad_attr->prototype = 0;
 
-	bfa_os_memcpy(&ad_attr->model, model, BFA_ADAPTER_MODEL_NAME_LEN);
-	bfa_os_memcpy(&ad_attr->model_descr, &ad_attr->model,
-		      BFA_ADAPTER_MODEL_NAME_LEN);
-
 	ad_attr->pwwn = bfa_ioc_get_pwwn(ioc);
 	ad_attr->mac = bfa_ioc_get_mac(ioc);
 
@@ -1726,12 +1708,8 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	ad_attr->pcie_lanes = ioc_attr->pcie_lanes;
 	ad_attr->pcie_lanes_orig = ioc_attr->pcie_lanes_orig;
 	ad_attr->asic_rev = ioc_attr->asic_rev;
-	ad_attr->hw_ver[0] = 'R';
-	ad_attr->hw_ver[1] = 'e';
-	ad_attr->hw_ver[2] = 'v';
-	ad_attr->hw_ver[3] = '-';
-	ad_attr->hw_ver[4] = ioc_attr->asic_rev;
-	ad_attr->hw_ver[5] = '\0';
+
+	bfa_ioc_get_pci_chip_rev(ioc, ad_attr->hw_ver);
 
 	ad_attr->cna_capable = ioc->cna;
 }
@@ -1752,11 +1730,91 @@ bfa_ioc_get_type(struct bfa_ioc_s *ioc)
 }
 
 void
+bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
+{
+	bfa_os_memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
+	bfa_os_memcpy((void *)serial_num,
+			(void *)ioc->attr->brcd_serialnum,
+			BFA_ADAPTER_SERIAL_NUM_LEN);
+}
+
+void
+bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver)
+{
+	bfa_os_memset((void *)fw_ver, 0, BFA_VERSION_LEN);
+	bfa_os_memcpy(fw_ver, ioc->attr->fw_version, BFA_VERSION_LEN);
+}
+
+void
+bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev)
+{
+	bfa_assert(chip_rev);
+
+	bfa_os_memset((void *)chip_rev, 0, BFA_IOC_CHIP_REV_LEN);
+
+	chip_rev[0] = 'R';
+	chip_rev[1] = 'e';
+	chip_rev[2] = 'v';
+	chip_rev[3] = '-';
+	chip_rev[4] = ioc->attr->asic_rev;
+	chip_rev[5] = '\0';
+}
+
+void
+bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver)
+{
+	bfa_os_memset((void *)optrom_ver, 0, BFA_VERSION_LEN);
+	bfa_os_memcpy(optrom_ver, ioc->attr->optrom_version,
+		BFA_VERSION_LEN);
+}
+
+void
+bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)
+{
+	bfa_os_memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
+	bfa_os_memcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+}
+
+void
+bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
+{
+	struct bfi_ioc_attr_s   *ioc_attr;
+	u8              nports;
+	u8              max_speed;
+
+	bfa_assert(model);
+	bfa_os_memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
+
+	ioc_attr = ioc->attr;
+
+	nports = bfa_ioc_get_nports(ioc);
+	max_speed = bfa_ioc_speed_sup(ioc);
+
+	/**
+	 * model name
+	 */
+	if (max_speed == 10) {
+		strcpy(model, "BR-10?0");
+		model[5] = '0' + nports;
+	} else {
+		strcpy(model, "Brocade-??5");
+		model[8] = '0' + max_speed;
+		model[9] = '0' + nports;
+	}
+}
+
+enum bfa_ioc_state
+bfa_ioc_get_state(struct bfa_ioc_s *ioc)
+{
+	return bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+}
+
+void
 bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 {
 	bfa_os_memset((void *)ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
 
-	ioc_attr->state = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+	ioc_attr->state = bfa_ioc_get_state(ioc);
 	ioc_attr->port_id = ioc->port_id;
 
 	ioc_attr->ioc_type = bfa_ioc_get_type(ioc);
@@ -1765,12 +1823,7 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 
 	ioc_attr->pci_attr.device_id = ioc->pcidev.device_id;
 	ioc_attr->pci_attr.pcifn = ioc->pcidev.pci_func;
-	ioc_attr->pci_attr.chip_rev[0] = 'R';
-	ioc_attr->pci_attr.chip_rev[1] = 'e';
-	ioc_attr->pci_attr.chip_rev[2] = 'v';
-	ioc_attr->pci_attr.chip_rev[3] = '-';
-	ioc_attr->pci_attr.chip_rev[4] = ioc_attr->adapter_attr.asic_rev;
-	ioc_attr->pci_attr.chip_rev[5] = '\0';
+	bfa_ioc_get_pci_chip_rev(ioc, ioc_attr->pci_attr.chip_rev);
 }
 
 /**
@@ -1877,25 +1930,7 @@ bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 	s32         inst_num = 0;
 	enum bfa_ioc_type_e ioc_type;
 
-	switch (event) {
-	case BFA_IOC_AEN_HBGOOD:
-		bfa_log(logmod, BFA_AEN_IOC_HBGOOD, inst_num);
-		break;
-	case BFA_IOC_AEN_HBFAIL:
-		bfa_log(logmod, BFA_AEN_IOC_HBFAIL, inst_num);
-		break;
-	case BFA_IOC_AEN_ENABLE:
-		bfa_log(logmod, BFA_AEN_IOC_ENABLE, inst_num);
-		break;
-	case BFA_IOC_AEN_DISABLE:
-		bfa_log(logmod, BFA_AEN_IOC_DISABLE, inst_num);
-		break;
-	case BFA_IOC_AEN_FWMISMATCH:
-		bfa_log(logmod, BFA_AEN_IOC_FWMISMATCH, inst_num);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, event), inst_num);
 
 	memset(&aen_data.ioc.pwwn, 0, sizeof(aen_data.ioc.pwwn));
 	memset(&aen_data.ioc.mac, 0, sizeof(aen_data.ioc.mac));
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 4b73efa..d080440 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -263,6 +263,16 @@ bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc);
 void bfa_ioc_cfg_complete(struct bfa_ioc_s *ioc);
+enum bfa_ioc_type_e bfa_ioc_get_type(struct bfa_ioc_s *ioc);
+void bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num);
+void bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver);
+void bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver);
+void bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model);
+void bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc,
+	char *manufacturer);
+void bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev);
+enum bfa_ioc_state bfa_ioc_get_state(struct bfa_ioc_s *ioc);
+
 void bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr);
 void bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 		struct bfa_adapter_attr_s *ad_attr);
diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index d2d48a6..ad06f61 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -631,11 +631,7 @@ bfa_lps_cvl_event(struct bfa_lps_s *lps)
 u32
 bfa_lps_get_max_vport(struct bfa_s *bfa)
 {
-	struct bfa_ioc_attr_s ioc_attr;
-
-	bfa_get_attr(bfa, &ioc_attr);
-
-	if (ioc_attr.pci_attr.device_id == BFA_PCI_DEVICE_ID_CT)
+	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT)
 		return BFA_LPS_MAX_VPORTS_SUPP_CT;
 	else
 		return BFA_LPS_MAX_VPORTS_SUPP_CB;
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index a8a529d..6bff08e 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -978,7 +978,6 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
 	struct bfad_s  *bfad;
 	int             error = -ENODEV, retval;
-	char            buf[16];
 
 	/*
 	 * For single port cards - only claim function 0
@@ -1009,8 +1008,7 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 	bfa_trc(bfad, bfad_inst);
 
 	bfad->logmod = &bfad->log_data;
-	sprintf(buf, "%d", bfad_inst);
-	bfa_log_init(bfad->logmod, buf, bfa_os_printf);
+	bfa_log_init(bfad->logmod, (char *)pci_name(pdev), bfa_os_printf);
 
 	bfad_drv_log_level_set(bfad);
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index a691133..dd5cb20 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -424,12 +424,10 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			ioc_attr.adapter_attr.serial_num);
+	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
+	return snprintf(buf, PAGE_SIZE, "%s\n", serial_num);
 }
 
 static ssize_t
@@ -440,11 +438,10 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc_attr.adapter_attr.model);
+	bfa_get_adapter_model(&bfad->bfa, model);
+	return snprintf(buf, PAGE_SIZE, "%s\n", model);
 }
 
 static ssize_t
@@ -455,12 +452,10 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	char model_descr[BFA_ADAPTER_MODEL_DESCR_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			ioc_attr.adapter_attr.model_descr);
+	bfa_get_adapter_model(&bfad->bfa, model_descr);
+	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
 }
 
 static ssize_t
@@ -485,14 +480,13 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
-
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char fw_ver[BFA_VERSION_LEN];
 
+	bfa_get_adapter_model(&bfad->bfa, model);
+	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
 	return snprintf(buf, PAGE_SIZE, "Brocade %s FV%s DV%s\n",
-			ioc_attr.adapter_attr.model,
-			ioc_attr.adapter_attr.fw_ver, BFAD_DRIVER_VERSION);
+		model, fw_ver, BFAD_DRIVER_VERSION);
 }
 
 static ssize_t
@@ -503,11 +497,10 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	char hw_ver[BFA_VERSION_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc_attr.adapter_attr.hw_ver);
+	bfa_get_pci_chip_rev(&bfad->bfa, hw_ver);
+	return snprintf(buf, PAGE_SIZE, "%s\n", hw_ver);
 }
 
 static ssize_t
@@ -525,12 +518,10 @@ bfad_im_optionrom_version_show(struct device *dev,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	char optrom_ver[BFA_VERSION_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			ioc_attr.adapter_attr.optrom_ver);
+	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
+	return snprintf(buf, PAGE_SIZE, "%s\n", optrom_ver);
 }
 
 static ssize_t
@@ -541,11 +532,10 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
+	char fw_ver[BFA_VERSION_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc_attr.adapter_attr.fw_ver);
+	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
+	return snprintf(buf, PAGE_SIZE, "%s\n", fw_ver);
 }
 
 static ssize_t
@@ -556,11 +546,9 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_ioc_attr_s  ioc_attr;
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc_attr.adapter_attr.nports);
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+		bfa_get_nports(&bfad->bfa));
 }
 
 static ssize_t
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 94f4d84..8617a1a 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -139,6 +139,18 @@ struct bfad_cfg_param_s {
 	u32        binding_method;
 };
 
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
+};
+
 /*
  * BFAD (PCI function) data structure
  */
@@ -182,6 +194,7 @@ struct bfad_s {
 	struct bfa_plog_s      plog_buf;
 	int             ref_count;
 	bfa_boolean_t	ipfc_enabled;
+	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
 
 	struct kobject *bfa_kobj;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 23390b4..cee3d89 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -167,17 +167,15 @@ bfad_im_info(struct Scsi_Host *shost)
 	static char     bfa_buf[256];
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfa_ioc_attr_s  ioc_attr;
 	struct bfad_s         *bfad = im_port->bfad;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
-	memset(&ioc_attr, 0, sizeof(ioc_attr));
-	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	bfa_get_adapter_model(&bfad->bfa, model);
 
 	memset(bfa_buf, 0, sizeof(bfa_buf));
 	snprintf(bfa_buf, sizeof(bfa_buf),
-		 "Brocade FC/FCOE Adapter, " "model: %s hwpath: %s driver: %s",
-		 ioc_attr.adapter_attr.model, bfad->pci_name,
-		 BFAD_DRIVER_VERSION);
+		"Brocade FC/FCOE Adapter, " "model: %s hwpath: %s driver: %s",
+		model, bfad->pci_name, BFAD_DRIVER_VERSION);
 	return bfa_buf;
 }
 
@@ -931,10 +929,9 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
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
@@ -954,20 +951,18 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
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
-	bfa_fcport_get_attr(&bfad->bfa, &attr.pattr);
-	fc_host_maxframe_size(host) = attr.pattr.pport_cfg.maxfrsize;
+	bfa_fcport_get_attr(&bfad->bfa, &pattr);
+	fc_host_maxframe_size(host) = pattr.pport_cfg.maxfrsize;
 }
 
 static void
diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index e1a4b31..b4e05ad 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -1235,14 +1235,8 @@ bfa_fcs_fabric_aen_post(struct bfa_fcs_port_s *port,
 	wwn2str(pwwn_ptr, pwwn);
 	wwn2str(fwwn_ptr, fwwn);
 
-	switch (event) {
-	case BFA_PORT_AEN_FABRIC_NAME_CHANGE:
-		bfa_log(logmod, BFA_AEN_PORT_FABRIC_NAME_CHANGE, pwwn_ptr,
-			fwwn_ptr);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, event),
+		pwwn_ptr, fwwn_ptr);
 
 	aen_data.port.pwwn = pwwn;
 	aen_data.port.fwwn = fwwn;
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 71d23d1..ef50ec2 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -385,19 +385,8 @@ bfa_fcs_itnim_aen_post(struct bfa_fcs_itnim_s *itnim,
 	wwn2str(lpwwn_ptr, lpwwn);
 	wwn2str(rpwwn_ptr, rpwwn);
 
-	switch (event) {
-	case BFA_ITNIM_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_ITNIM_ONLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
-	case BFA_ITNIM_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_ITNIM_OFFLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
-	case BFA_ITNIM_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_ITNIM_DISCONNECT, rpwwn_ptr, lpwwn_ptr);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, event),
+		rpwwn_ptr, lpwwn_ptr);
 
 	aen_data.itnim.vf_id = rport->port->fabric->vf_id;
 	aen_data.itnim.ppwwn =
diff --git a/drivers/scsi/bfa/include/bfa.h b/drivers/scsi/bfa/include/bfa.h
index 17654ca..1f5966c 100644
--- a/drivers/scsi/bfa/include/bfa.h
+++ b/drivers/scsi/bfa/include/bfa.h
@@ -106,6 +106,26 @@ struct bfa_sge_s {
 	bfa_ioc_fetch_stats(&(__bfa)->ioc, __ioc_stats)
 #define bfa_ioc_clear_stats(__bfa)	\
 	bfa_ioc_clr_stats(&(__bfa)->ioc)
+#define bfa_get_nports(__bfa)   \
+	bfa_ioc_get_nports(&(__bfa)->ioc)
+#define bfa_get_adapter_manufacturer(__bfa, __manufacturer) \
+	bfa_ioc_get_adapter_manufacturer(&(__bfa)->ioc, __manufacturer)
+#define bfa_get_adapter_model(__bfa, __model)   \
+	bfa_ioc_get_adapter_model(&(__bfa)->ioc, __model)
+#define bfa_get_adapter_serial_num(__bfa, __serial_num) \
+	bfa_ioc_get_adapter_serial_num(&(__bfa)->ioc, __serial_num)
+#define bfa_get_adapter_fw_ver(__bfa, __fw_ver) \
+	bfa_ioc_get_adapter_fw_ver(&(__bfa)->ioc, __fw_ver)
+#define bfa_get_adapter_optrom_ver(__bfa, __optrom_ver) \
+	bfa_ioc_get_adapter_optrom_ver(&(__bfa)->ioc, __optrom_ver)
+#define bfa_get_pci_chip_rev(__bfa, __chip_rev) \
+	bfa_ioc_get_pci_chip_rev(&(__bfa)->ioc, __chip_rev)
+#define bfa_get_ioc_state(__bfa)    \
+	bfa_ioc_get_state(&(__bfa)->ioc)
+#define bfa_get_type(__bfa) \
+	bfa_ioc_get_type(&(__bfa)->ioc)
+#define bfa_get_mac(__bfa)  \
+	bfa_ioc_get_mac(&(__bfa)->ioc)
 
 /*
  * bfa API functions
diff --git a/drivers/scsi/bfa/include/cs/bfa_log.h b/drivers/scsi/bfa/include/cs/bfa_log.h
index 761cbe2..bc334e0 100644
--- a/drivers/scsi/bfa/include/cs/bfa_log.h
+++ b/drivers/scsi/bfa/include/cs/bfa_log.h
@@ -157,7 +157,7 @@ typedef void (*bfa_log_cb_t)(struct bfa_log_mod_s *log_mod, u32 msg_id,
 
 
 struct bfa_log_mod_s {
-	char		instance_info[16];	/*  instance info */
+	char		instance_info[BFA_STRING_32];	/*  instance info */
 	int		log_level[BFA_LOG_MODULE_ID_MAX + 1];
 						/*  log level for modules */
 	bfa_log_cb_t	cbfn; 			/*  callback function */
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 8c5969c..8e73dd9 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -2039,13 +2039,10 @@ bfa_fcs_rport_aen_post(struct bfa_fcs_rport_s *rport,
 
 	switch (event) {
 	case BFA_RPORT_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_RPORT_ONLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
 	case BFA_RPORT_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_RPORT_OFFLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
 	case BFA_RPORT_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_RPORT_DISCONNECT, rpwwn_ptr, lpwwn_ptr);
+		bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, event),
+			rpwwn_ptr, lpwwn_ptr);
 		break;
 	case BFA_RPORT_AEN_QOS_PRIO:
 		aen_data.rport.priv.qos = data->priv.qos;
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index c5e534e..27cd619 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -447,22 +447,8 @@ bfa_fcs_vport_aen_post(bfa_fcs_lport_t *port, enum bfa_lport_aen_event event)
 
 	bfa_assert(role <= BFA_PORT_ROLE_FCP_MAX);
 
-	switch (event) {
-	case BFA_LPORT_AEN_NPIV_DUP_WWN:
-		bfa_log(logmod, BFA_AEN_LPORT_NPIV_DUP_WWN, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_NPIV_FABRIC_MAX:
-		bfa_log(logmod, BFA_AEN_LPORT_NPIV_FABRIC_MAX, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	case BFA_LPORT_AEN_NPIV_UNKNOWN:
-		bfa_log(logmod, BFA_AEN_LPORT_NPIV_UNKNOWN, lpwwn_ptr,
-			role_str[role / 2]);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, event), lpwwn_ptr,
+			role_str[role/2]);
 
 	aen_data.lport.vf_id = port->fabric->vf_id;
 	aen_data.lport.roles = role;
-- 
1.6.5.3

