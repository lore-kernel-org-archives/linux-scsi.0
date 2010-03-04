From: <kgudipat@brocade.com>
Subject: [PATCH 28/32] bfa: FCS and include file changes.
Date: Wed, 3 Mar 2010 17:47:51 -0800
Message-ID: <1267667271-28791-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:33989 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0CDBsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:48:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- MS module did not invoke fdmi offline in all cases,
	  call fdmi offline when ms module receives a port offline,
	  so that fdmi offline is from one place in the ms module.

	- Make changes to handle 10G speed in the conversion routine.

	- Replaced the usage of bfa_adapter_attr_s struct with specific API's.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/fabric.c                       |    8 ++---
 drivers/scsi/bfa/fcbuild.h                      |    6 ++++
 drivers/scsi/bfa/fdmi.c                         |   32 ++++++----------------
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |    5 +--
 drivers/scsi/bfa/ms.c                           |    5 +---
 5 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index b4e05ad..8166e97 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -562,17 +562,15 @@ void
 bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_port_cfg_s *port_cfg = &fabric->bport.port_cfg;
-	struct bfa_adapter_attr_s adapter_attr;
+	char            model[BFA_ADAPTER_MODEL_NAME_LEN] = {0};
 	struct bfa_fcs_driver_info_s *driver_info = &fabric->fcs->driver_info;
 
-	bfa_os_memset((void *)&adapter_attr, 0,
-		      sizeof(struct bfa_adapter_attr_s));
-	bfa_ioc_get_adapter_attr(&fabric->fcs->bfa->ioc, &adapter_attr);
+	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
 	/*
 	 * Model name/number
 	 */
-	strncpy((char *)&port_cfg->sym_name, adapter_attr.model,
+	strncpy((char *)&port_cfg->sym_name, model,
 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
diff --git a/drivers/scsi/bfa/fcbuild.h b/drivers/scsi/bfa/fcbuild.h
index 8fa7f27..97d3ea1 100644
--- a/drivers/scsi/bfa/fcbuild.h
+++ b/drivers/scsi/bfa/fcbuild.h
@@ -72,6 +72,9 @@ fc_rpsc_operspeed_to_bfa_speed(enum fc_rpsc_op_speed_s speed)
 	case RPSC_OP_SPEED_8G:
 		return BFA_PPORT_SPEED_8GBPS;
 
+	case RPSC_OP_SPEED_10G :
+		return BFA_PPORT_SPEED_10GBPS;
+
 	default:
 		return BFA_PPORT_SPEED_UNKNOWN;
 	}
@@ -97,6 +100,9 @@ fc_bfa_speed_to_rpsc_operspeed(enum bfa_pport_speed op_speed)
 	case BFA_PPORT_SPEED_8GBPS:
 		return RPSC_OP_SPEED_8G;
 
+	case BFA_PPORT_SPEED_10GBPS:
+		return RPSC_OP_SPEED_10G;
+
 	default:
 		return RPSC_OP_SPEED_NOT_EST;
 	}
diff --git a/drivers/scsi/bfa/fdmi.c b/drivers/scsi/bfa/fdmi.c
index 2c9e713..808158e 100644
--- a/drivers/scsi/bfa/fdmi.c
+++ b/drivers/scsi/bfa/fdmi.c
@@ -1114,36 +1114,22 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct bfa_fcs_driver_info_s *driver_info = &port->fcs->driver_info;
-	struct bfa_adapter_attr_s adapter_attr;
 
 	bfa_os_memset(hba_attr, 0, sizeof(struct bfa_fcs_fdmi_hba_attr_s));
-	bfa_os_memset(&adapter_attr, 0, sizeof(struct bfa_adapter_attr_s));
 
-	bfa_ioc_get_adapter_attr(&port->fcs->bfa->ioc, &adapter_attr);
-
-	strncpy(hba_attr->manufacturer, adapter_attr.manufacturer,
-		sizeof(adapter_attr.manufacturer));
-
-	strncpy(hba_attr->serial_num, adapter_attr.serial_num,
-		sizeof(adapter_attr.serial_num));
-
-	strncpy(hba_attr->model, adapter_attr.model, sizeof(hba_attr->model));
-
-	strncpy(hba_attr->model_desc, adapter_attr.model_descr,
-		sizeof(hba_attr->model_desc));
-
-	strncpy(hba_attr->hw_version, adapter_attr.hw_ver,
-		sizeof(hba_attr->hw_version));
+	bfa_ioc_get_adapter_manufacturer(&port->fcs->bfa->ioc,
+		hba_attr->manufacturer);
+	bfa_ioc_get_adapter_serial_num(&port->fcs->bfa->ioc, hba_attr->serial_num);
+	bfa_ioc_get_adapter_model(&port->fcs->bfa->ioc, hba_attr->model);
+	bfa_ioc_get_adapter_model(&port->fcs->bfa->ioc, hba_attr->model_desc);
+	bfa_ioc_get_pci_chip_rev(&port->fcs->bfa->ioc, hba_attr->hw_version);
+	bfa_ioc_get_adapter_optrom_ver(&port->fcs->bfa->ioc,
+		hba_attr->option_rom_ver);
+	bfa_ioc_get_adapter_fw_ver(&port->fcs->bfa->ioc, hba_attr->fw_version);
 
 	strncpy(hba_attr->driver_version, (char *)driver_info->version,
 		sizeof(hba_attr->driver_version));
 
-	strncpy(hba_attr->option_rom_ver, adapter_attr.optrom_ver,
-		sizeof(hba_attr->option_rom_ver));
-
-	strncpy(hba_attr->fw_version, adapter_attr.fw_ver,
-		sizeof(hba_attr->fw_version));
-
 	strncpy(hba_attr->os_name, driver_info->host_os_name,
 		sizeof(hba_attr->os_name));
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index d8a74eb..4374494 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -213,7 +213,7 @@ enum bfa_status {
 					     * loaded */
 	BFA_STATUS_CARD_TYPE_MISMATCH = 131, /*  Card type mismatch */
 	BFA_STATUS_BAD_ASICBLK = 132, /*  Bad ASIC block */
-	BFA_STATUS_NO_DRIVER = 133, /*  Storage/Ethernet driver not loaded */
+	BFA_STATUS_NO_DRIVER = 133, /*  Brocade adapter/driver not installed or loaded */
 	BFA_STATUS_INVALID_MAC = 134, /*  Invalid mac address */
 	BFA_STATUS_IM_NO_VLAN = 135, /*  No VLANs configured on the adapter */
 	BFA_STATUS_IM_ETH_LB_FAILED = 136, /*  Ethernet loopback test failed */
@@ -228,8 +228,7 @@ enum bfa_status {
 	BFA_STATUS_IM_GET_INETCFG_FAILED = 142, /*  Acquiring Network Subsytem
 						 * handle Failed. Please try
 						 * after some time */
-	BFA_STATUS_IM_NOT_BOUND = 143, /*  Brocade 10G Ethernet Service is not
-					* Enabled on this port */
+	BFA_STATUS_IM_NOT_BOUND = 143, /*  IM driver is not active */
 	BFA_STATUS_INSUFFICIENT_PERMS = 144, /*  User doesn't have sufficient
 					      * permissions to execute the BCU
 					      * application */
diff --git a/drivers/scsi/bfa/ms.c b/drivers/scsi/bfa/ms.c
index e6db5fd..5e8c8de 100644
--- a/drivers/scsi/bfa/ms.c
+++ b/drivers/scsi/bfa/ms.c
@@ -230,10 +230,6 @@ bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
 	switch (event) {
 	case MSSM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
-		/*
-		 * now invoke MS related sub-modules
-		 */
-		bfa_fcs_port_fdmi_offline(ms);
 		break;
 
 	case MSSM_EVENT_PORT_FABRIC_RSCN:
@@ -735,6 +731,7 @@ bfa_fcs_port_ms_offline(struct bfa_fcs_port_s *port)
 
 	ms->port = port;
 	bfa_sm_send_event(ms, MSSM_EVENT_PORT_OFFLINE);
+	bfa_fcs_port_fdmi_offline(ms);
 }
 
 void
-- 
1.6.5.3

