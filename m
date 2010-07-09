From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 18/24] bfa: update to support BOFM
Date: Thu, 8 Jul 2010 19:59:24 -0700
Message-ID: <1278644364-2812-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36462 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740Ab0GIC7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:59:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Update bfa driver API and data structure to support BOFM (IBM BladeCenter
Open Fabric Manager).

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c                      |   44 ++++++++++-------------
 drivers/scsi/bfa/include/bfa.h                  |    2 +
 drivers/scsi/bfa/include/bfi/bfi_ioc.h          |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |   16 +++++++-
 4 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index c4922fb..8e78f20 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -84,6 +84,7 @@ static void     bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
 static void     bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_recover(struct bfa_ioc_s *ioc);
+static void	bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
 
@@ -429,6 +430,7 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 	switch (event) {
 	case IOC_E_FWRSP_GETATTR:
 		bfa_ioc_timer_stop(ioc);
+		bfa_ioc_check_attr_wwns(ioc);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_op);
 		break;
 
@@ -977,8 +979,13 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	/**
 	 * If IOC function is disabled and firmware version is same,
 	 * just re-enable IOC.
+	 *
+	 * If option rom, IOC must not be in operational state. With
+	 * convergence, IOC will be in operational state when 2nd driver
+	 * is loaded.
 	 */
-	if (ioc_fwstate == BFI_IOC_DISABLED || ioc_fwstate == BFI_IOC_OP) {
+	if (ioc_fwstate == BFI_IOC_DISABLED ||
+		(!bfa_ioc_is_optrom(ioc) && ioc_fwstate == BFI_IOC_OP)) {
 		bfa_trc(ioc, ioc_fwstate);
 
 		/**
@@ -1281,6 +1288,7 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
 		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_INITING);
 	}
 
+	bfa_ioc_msgflush(ioc);
 	bfa_ioc_download_fw(ioc, boot_type, boot_param);
 
 	/**
@@ -1788,28 +1796,17 @@ void
 bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 {
 	struct bfi_ioc_attr_s   *ioc_attr;
-	u8              nports;
-	u8              max_speed;
 
 	bfa_assert(model);
 	bfa_os_memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
 
 	ioc_attr = ioc->attr;
 
-	nports = bfa_ioc_get_nports(ioc);
-	max_speed = bfa_ioc_speed_sup(ioc);
-
 	/**
 	 * model name
 	 */
-	if (max_speed == 10) {
-		strcpy(model, "BR-10?0");
-		model[5] = '0' + nports;
-	} else {
-		strcpy(model, "Brocade-??5");
-		model[8] = '0' + max_speed;
-		model[9] = '0' + nports;
-	}
+	snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u",
+			BFA_MFG_NAME, ioc_attr->card_type);
 }
 
 enum bfa_ioc_state
@@ -2048,19 +2045,16 @@ bfa_ioc_recover(struct bfa_ioc_s *ioc)
 	bfa_fsm_send_event(ioc, IOC_E_HBFAIL);
 }
 
-#else
-
-void
-bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
-{
-}
-
 static void
-bfa_ioc_recover(struct bfa_ioc_s *ioc)
+bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc)
 {
-	bfa_assert(0);
+	if (bfa_ioc_get_type(ioc) == BFA_IOC_TYPE_LL)
+		return;
+
+	if (ioc->attr->nwwn == 0)
+		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_INVALID_NWWN);
+	if (ioc->attr->pwwn == 0)
+		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_INVALID_PWWN);
 }
 
 #endif
-
-
diff --git a/drivers/scsi/bfa/include/bfa.h b/drivers/scsi/bfa/include/bfa.h
index 9519a6d..d52b32f 100644
--- a/drivers/scsi/bfa/include/bfa.h
+++ b/drivers/scsi/bfa/include/bfa.h
@@ -126,6 +126,8 @@ struct bfa_sge_s {
 	bfa_ioc_get_type(&(__bfa)->ioc)
 #define bfa_get_mac(__bfa)  \
 	bfa_ioc_get_mac(&(__bfa)->ioc)
+#define bfa_get_mfg_mac(__bfa)  \
+	bfa_ioc_get_mfg_mac(&(__bfa)->ioc)
 #define bfa_get_fw_clock_res(__bfa)    \
 	((__bfa)->iocfc.cfgrsp->fwcfg.fw_tick_res)
 
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ioc.h b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
index 7c5e6d5..450ded6 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ioc.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
@@ -50,7 +50,7 @@ struct bfi_ioc_getattr_req_s {
 struct bfi_ioc_attr_s {
 	wwn_t           mfg_pwwn;       /* Mfg port wwn */
 	wwn_t           mfg_nwwn;       /* Mfg node wwn */
-	mac_t		mfg_mac;
+	mac_t		mfg_mac;	/* Mfg mac      */
 	u16		rsvd_a;
 	wwn_t           pwwn;
 	wwn_t           nwwn;
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index c8bc60a..6eb4e62 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -256,8 +256,20 @@ enum bfa_status {
 			       * configuration */
 	BFA_STATUS_DEVID_MISSING = 155, /* Boot image is not for the adapter(s)
 					 * installed */
-        BFA_STATUS_BAD_FWCFG = 156, /* Bad firmware configuration */
-	BFA_STATUS_MAX_VAL		/*  Unknown error code */
+	BFA_STATUS_BAD_FWCFG = 156, /* Bad firmware configuration */
+	BFA_STATUS_CREATE_FILE = 157, /* Failed to create temporary file */
+	BFA_STATUS_INVALID_VENDOR = 158, /* Invalid switch vendor */
+	BFA_STATUS_SFP_NOT_READY = 159, /* SFP info is not ready. Retry */
+	BFA_STATUS_NO_TOPOLOGY_FOR_CNA = 160, /* Topology command not
+					       * applicable to CNA */
+	BFA_STATUS_BOOT_CODE_UPDATED = 161, /* reboot -- -r is needed after
+					     * boot code updated */
+	BFA_STATUS_BOOT_VERSION = 162, /* Boot code version not compatible with
+					* the driver installed */
+	BFA_STATUS_CARDTYPE_MISSING = 163, /* Boot image is not for the
+					    * adapter(s) installed */
+	BFA_STATUS_INVALID_CARDTYPE = 164, /* Invalid card type provided */
+	BFA_STATUS_MAX_VAL              /* Unknown error code */
 };
 #define bfa_status_t enum bfa_status
 
-- 
1.6.5.2

