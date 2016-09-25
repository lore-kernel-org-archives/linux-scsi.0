From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] lpfc: mark symbols static where possible
Date: Sun, 25 Sep 2016 13:44:55 +0800
Message-ID: <1474782295-25644-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@avagotech.com, dick.kennedy@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get a few warnings when building kernel with W=1:
drivers/scsi/lpfc/lpfc_sli.c:5693:1: warning: no previous prototype for 'lpfc_set_features' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:8972:1: warning: no previous prototype for 'lpfc_sli_calc_ring' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4621:1: warning: no previous prototype for 'lpfc_rdp_res_link_service' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4633:1: warning: no previous prototype for 'lpfc_rdp_res_sfp_desc' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4698:1: warning: no previous prototype for 'lpfc_rdp_res_link_error' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4727:1: warning: no previous prototype for 'lpfc_rdp_res_bbc_desc' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4752:1: warning: no previous prototype for 'lpfc_rdp_res_oed_temp_desc' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4780:1: warning: no previous prototype for 'lpfc_rdp_res_oed_voltage_desc' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4809:1: warning: no previous prototype for 'lpfc_rdp_res_oed_txbias_desc' [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_els.c:4838:1: warning: no previous prototype for 'lpfc_rdp_res_oed_txpower_desc' [-Wmissing-prototypes]
....

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
so this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/lpfc/lpfc_ct.c   | 82 +++++++++++++++++++++----------------------
 drivers/scsi/lpfc/lpfc_els.c  | 34 +++++++++---------
 drivers/scsi/lpfc/lpfc_mbox.c |  4 +--
 drivers/scsi/lpfc/lpfc_sli.c  |  4 +--
 4 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 63e48d4..4ac03b1 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1535,7 +1535,7 @@ lpfc_fdmi_num_disc_check(struct lpfc_vport *vport)
 }
 
 /* Routines for all individual HBA attributes */
-int
+static int
 lpfc_fdmi_hba_attr_wwnn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 {
 	struct lpfc_fdmi_attr_entry *ae;
@@ -1551,7 +1551,7 @@ lpfc_fdmi_hba_attr_wwnn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	ad->AttrType = cpu_to_be16(RHBA_NODENAME);
 	return size;
 }
-int
+static int
 lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 				struct lpfc_fdmi_attr_def *ad)
 {
@@ -1573,7 +1573,7 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_sn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 {
 	struct lpfc_hba *phba = vport->phba;
@@ -1594,7 +1594,7 @@ lpfc_fdmi_hba_attr_sn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_model(struct lpfc_vport *vport,
 			 struct lpfc_fdmi_attr_def *ad)
 {
@@ -1615,7 +1615,7 @@ lpfc_fdmi_hba_attr_model(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_description(struct lpfc_vport *vport,
 			       struct lpfc_fdmi_attr_def *ad)
 {
@@ -1637,7 +1637,7 @@ lpfc_fdmi_hba_attr_description(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_hdw_ver(struct lpfc_vport *vport,
 			   struct lpfc_fdmi_attr_def *ad)
 {
@@ -1669,7 +1669,7 @@ lpfc_fdmi_hba_attr_hdw_ver(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_drvr_ver(struct lpfc_vport *vport,
 			    struct lpfc_fdmi_attr_def *ad)
 {
@@ -1690,7 +1690,7 @@ lpfc_fdmi_hba_attr_drvr_ver(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_rom_ver(struct lpfc_vport *vport,
 			   struct lpfc_fdmi_attr_def *ad)
 {
@@ -1715,7 +1715,7 @@ lpfc_fdmi_hba_attr_rom_ver(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_fmw_ver(struct lpfc_vport *vport,
 			   struct lpfc_fdmi_attr_def *ad)
 {
@@ -1736,7 +1736,7 @@ lpfc_fdmi_hba_attr_fmw_ver(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_os_ver(struct lpfc_vport *vport,
 			  struct lpfc_fdmi_attr_def *ad)
 {
@@ -1759,7 +1759,7 @@ lpfc_fdmi_hba_attr_os_ver(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_ct_len(struct lpfc_vport *vport,
 			  struct lpfc_fdmi_attr_def *ad)
 {
@@ -1775,7 +1775,7 @@ lpfc_fdmi_hba_attr_ct_len(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_symbolic_name(struct lpfc_vport *vport,
 				 struct lpfc_fdmi_attr_def *ad)
 {
@@ -1794,7 +1794,7 @@ lpfc_fdmi_hba_attr_symbolic_name(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_vendor_info(struct lpfc_vport *vport,
 			       struct lpfc_fdmi_attr_def *ad)
 {
@@ -1811,7 +1811,7 @@ lpfc_fdmi_hba_attr_vendor_info(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_num_ports(struct lpfc_vport *vport,
 			     struct lpfc_fdmi_attr_def *ad)
 {
@@ -1828,7 +1828,7 @@ lpfc_fdmi_hba_attr_num_ports(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_fabric_wwnn(struct lpfc_vport *vport,
 			       struct lpfc_fdmi_attr_def *ad)
 {
@@ -1846,7 +1846,7 @@ lpfc_fdmi_hba_attr_fabric_wwnn(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_bios_ver(struct lpfc_vport *vport,
 			    struct lpfc_fdmi_attr_def *ad)
 {
@@ -1867,7 +1867,7 @@ lpfc_fdmi_hba_attr_bios_ver(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_bios_state(struct lpfc_vport *vport,
 			      struct lpfc_fdmi_attr_def *ad)
 {
@@ -1884,7 +1884,7 @@ lpfc_fdmi_hba_attr_bios_state(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_hba_attr_vendor_id(struct lpfc_vport *vport,
 			     struct lpfc_fdmi_attr_def *ad)
 {
@@ -1906,7 +1906,7 @@ lpfc_fdmi_hba_attr_vendor_id(struct lpfc_vport *vport,
 }
 
 /* Routines for all individual PORT attributes */
-int
+static int
 lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 			    struct lpfc_fdmi_attr_def *ad)
 {
@@ -1925,7 +1925,7 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 				  struct lpfc_fdmi_attr_def *ad)
 {
@@ -1975,7 +1975,7 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 			  struct lpfc_fdmi_attr_def *ad)
 {
@@ -2039,7 +2039,7 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_max_frame(struct lpfc_vport *vport,
 			      struct lpfc_fdmi_attr_def *ad)
 {
@@ -2059,7 +2059,7 @@ lpfc_fdmi_port_attr_max_frame(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_os_devname(struct lpfc_vport *vport,
 			       struct lpfc_fdmi_attr_def *ad)
 {
@@ -2081,7 +2081,7 @@ lpfc_fdmi_port_attr_os_devname(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 			      struct lpfc_fdmi_attr_def *ad)
 {
@@ -2102,7 +2102,7 @@ lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_wwnn(struct lpfc_vport *vport,
 			 struct lpfc_fdmi_attr_def *ad)
 {
@@ -2120,7 +2120,7 @@ lpfc_fdmi_port_attr_wwnn(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_wwpn(struct lpfc_vport *vport,
 			 struct lpfc_fdmi_attr_def *ad)
 {
@@ -2138,7 +2138,7 @@ lpfc_fdmi_port_attr_wwpn(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_symbolic_name(struct lpfc_vport *vport,
 				  struct lpfc_fdmi_attr_def *ad)
 {
@@ -2156,7 +2156,7 @@ lpfc_fdmi_port_attr_symbolic_name(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_port_type(struct lpfc_vport *vport,
 			      struct lpfc_fdmi_attr_def *ad)
 {
@@ -2175,7 +2175,7 @@ lpfc_fdmi_port_attr_port_type(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_class(struct lpfc_vport *vport,
 			  struct lpfc_fdmi_attr_def *ad)
 {
@@ -2190,7 +2190,7 @@ lpfc_fdmi_port_attr_class(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_fabric_wwpn(struct lpfc_vport *vport,
 				struct lpfc_fdmi_attr_def *ad)
 {
@@ -2208,7 +2208,7 @@ lpfc_fdmi_port_attr_fabric_wwpn(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 				   struct lpfc_fdmi_attr_def *ad)
 {
@@ -2227,7 +2227,7 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_port_state(struct lpfc_vport *vport,
 			       struct lpfc_fdmi_attr_def *ad)
 {
@@ -2243,7 +2243,7 @@ lpfc_fdmi_port_attr_port_state(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_num_disc(struct lpfc_vport *vport,
 			     struct lpfc_fdmi_attr_def *ad)
 {
@@ -2259,7 +2259,7 @@ lpfc_fdmi_port_attr_num_disc(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_port_attr_nportid(struct lpfc_vport *vport,
 			    struct lpfc_fdmi_attr_def *ad)
 {
@@ -2274,7 +2274,7 @@ lpfc_fdmi_port_attr_nportid(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_service(struct lpfc_vport *vport,
 			     struct lpfc_fdmi_attr_def *ad)
 {
@@ -2295,7 +2295,7 @@ lpfc_fdmi_smart_attr_service(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_guid(struct lpfc_vport *vport,
 			  struct lpfc_fdmi_attr_def *ad)
 {
@@ -2316,7 +2316,7 @@ lpfc_fdmi_smart_attr_guid(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_version(struct lpfc_vport *vport,
 			     struct lpfc_fdmi_attr_def *ad)
 {
@@ -2337,7 +2337,7 @@ lpfc_fdmi_smart_attr_version(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_model(struct lpfc_vport *vport,
 			   struct lpfc_fdmi_attr_def *ad)
 {
@@ -2358,7 +2358,7 @@ lpfc_fdmi_smart_attr_model(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_port_info(struct lpfc_vport *vport,
 			       struct lpfc_fdmi_attr_def *ad)
 {
@@ -2378,7 +2378,7 @@ lpfc_fdmi_smart_attr_port_info(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_qos(struct lpfc_vport *vport,
 			 struct lpfc_fdmi_attr_def *ad)
 {
@@ -2393,7 +2393,7 @@ lpfc_fdmi_smart_attr_qos(struct lpfc_vport *vport,
 	return size;
 }
 
-int
+static int
 lpfc_fdmi_smart_attr_security(struct lpfc_vport *vport,
 			      struct lpfc_fdmi_attr_def *ad)
 {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c0af32f..b7d54bf 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4617,7 +4617,7 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 	return sentplogi;
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_link_service(struct fc_rdp_link_service_desc *desc,
 		uint32_t word0)
 {
@@ -4629,7 +4629,7 @@ lpfc_rdp_res_link_service(struct fc_rdp_link_service_desc *desc,
 	return sizeof(struct fc_rdp_link_service_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_sfp_desc(struct fc_rdp_sfp_desc *desc,
 		uint8_t *page_a0, uint8_t *page_a2)
 {
@@ -4694,7 +4694,7 @@ lpfc_rdp_res_sfp_desc(struct fc_rdp_sfp_desc *desc,
 	return sizeof(struct fc_rdp_sfp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_link_error(struct fc_rdp_link_error_status_desc *desc,
 		READ_LNK_VAR *stat)
 {
@@ -4723,7 +4723,7 @@ lpfc_rdp_res_link_error(struct fc_rdp_link_error_status_desc *desc,
 	return sizeof(struct fc_rdp_link_error_status_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
 		      struct lpfc_vport *vport)
 {
@@ -4748,7 +4748,7 @@ lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
 	return sizeof(struct fc_rdp_bbc_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_oed_temp_desc(struct lpfc_hba *phba,
 			   struct fc_rdp_oed_sfp_desc *desc, uint8_t *page_a2)
 {
@@ -4776,7 +4776,7 @@ lpfc_rdp_res_oed_temp_desc(struct lpfc_hba *phba,
 	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_oed_voltage_desc(struct lpfc_hba *phba,
 			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
@@ -4805,7 +4805,7 @@ lpfc_rdp_res_oed_voltage_desc(struct lpfc_hba *phba,
 	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_oed_txbias_desc(struct lpfc_hba *phba,
 			     struct fc_rdp_oed_sfp_desc *desc,
 			     uint8_t *page_a2)
@@ -4834,7 +4834,7 @@ lpfc_rdp_res_oed_txbias_desc(struct lpfc_hba *phba,
 	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_oed_txpower_desc(struct lpfc_hba *phba,
 			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
@@ -4864,7 +4864,7 @@ lpfc_rdp_res_oed_txpower_desc(struct lpfc_hba *phba,
 }
 
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_oed_rxpower_desc(struct lpfc_hba *phba,
 			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
@@ -4893,7 +4893,7 @@ lpfc_rdp_res_oed_rxpower_desc(struct lpfc_hba *phba,
 	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_opd_desc(struct fc_rdp_opd_sfp_desc *desc,
 		      uint8_t *page_a0, struct lpfc_vport *vport)
 {
@@ -4907,7 +4907,7 @@ lpfc_rdp_res_opd_desc(struct fc_rdp_opd_sfp_desc *desc,
 	return sizeof(struct fc_rdp_opd_sfp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_fec_desc(struct fc_fec_rdp_desc *desc, READ_LNK_VAR *stat)
 {
 	if (bf_get(lpfc_read_link_stat_gec2, stat) == 0)
@@ -4924,7 +4924,7 @@ lpfc_rdp_res_fec_desc(struct fc_fec_rdp_desc *desc, READ_LNK_VAR *stat)
 	return sizeof(struct fc_fec_rdp_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 {
 	uint16_t rdp_cap = 0;
@@ -4986,7 +4986,7 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 	return sizeof(struct fc_rdp_port_speed_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
 		struct lpfc_hba *phba)
 {
@@ -5003,7 +5003,7 @@ lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
 	return sizeof(struct fc_rdp_port_name_desc);
 }
 
-uint32_t
+static uint32_t
 lpfc_rdp_res_attach_port_names(struct fc_rdp_port_name_desc *desc,
 		struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
@@ -5027,7 +5027,7 @@ lpfc_rdp_res_attach_port_names(struct fc_rdp_port_name_desc *desc,
 	return sizeof(struct fc_rdp_port_name_desc);
 }
 
-void
+static void
 lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 		int status)
 {
@@ -5165,7 +5165,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	kfree(rdp_context);
 }
 
-int
+static int
 lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 {
 	LPFC_MBOXQ_t *mbox = NULL;
@@ -7995,7 +7995,7 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	}
 }
 
-void
+static void
 lpfc_start_fdmi(struct lpfc_vport *vport)
 {
 	struct lpfc_hba *phba = vport->phba;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 12dbe99..b234c50 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2260,7 +2260,7 @@ lpfc_sli4_dump_cfg_rg23(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 	return 0;
 }
 
-void
+static void
 lpfc_mbx_cmpl_rdp_link_stat(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	MAILBOX_t *mb;
@@ -2281,7 +2281,7 @@ lpfc_mbx_cmpl_rdp_link_stat(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	rdp_context->cmpl(phba, rdp_context, rc);
 }
 
-void
+static void
 lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) mbox->context1;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7080ce2..c532605 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5689,7 +5689,7 @@ lpfc_sli4_dealloc_extent(struct lpfc_hba *phba, uint16_t type)
 	return rc;
 }
 
-void
+static void
 lpfc_set_features(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
 		  uint32_t feature)
 {
@@ -8968,7 +8968,7 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  * Since ABORTS must go on the same WQ of the command they are
  * aborting, we use command's fcp_wqidx.
  */
-int
+static int
 lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb)
 {
-- 
2.7.4
