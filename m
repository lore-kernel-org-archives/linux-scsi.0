From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 7/9] lpfc: Fix interaction between fdmi_on and
 enable_SmartSAN
Date: Thu, 31 Mar 2016 14:12:33 -0700
Message-ID: <56fd92c1.BloII58DREoOrLa7%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36658 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561AbcCaVMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:37 -0400
Received: by mail-pa0-f47.google.com with SMTP id tt10so74176287pab.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:36 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id w20sm15505757pfi.31.2016.03.31.14.12.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix interaction between fdmi_on and enable_SmartSAN

Fix interaction between fdmi_on and enable_SmartSAN

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc.h       |  1 -
 drivers/scsi/lpfc/lpfc_attr.c  | 23 +++++++----------------
 drivers/scsi/lpfc/lpfc_els.c   | 16 +++++++++-------
 drivers/scsi/lpfc/lpfc_init.c  |  5 +++--
 drivers/scsi/lpfc/lpfc_vport.c |  3 ++-
 5 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index da237d9..283942a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -758,7 +758,6 @@ struct lpfc_hba {
 	uint32_t cfg_fdmi_on;
 #define LPFC_FDMI_NO_SUPPORT	0	/* FDMI not supported */
 #define LPFC_FDMI_SUPPORT	1	/* FDMI supported? */
-#define LPFC_FDMI_SMART_SAN	2	/* SmartSAN supported */
 	uint32_t cfg_enable_SmartSAN;
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index d4559a6..9528f86 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4584,15 +4584,14 @@ LPFC_ATTR_R(enable_SmartSAN, 0, 0, 1, "Enable SmartSAN functionality");
 # lpfc_fdmi_on: Controls FDMI support.
 #       0       No FDMI support (default)
 #       1       Traditional FDMI support
-#       2       Smart SAN support
-# If lpfc_enable_SmartSAN is set 1, the driver sets lpfc_fdmi_on to value 2
-# overwriting the current value.  If lpfc_enable_SmartSAN is set 0, the
-# driver uses the current value of lpfc_fdmi_on provided it has value 0 or 1.
-# A value of 2 with lpfc_enable_SmartSAN set to 0 causes the driver to
-# set lpfc_fdmi_on back to 1.
-# Value range [0,2]. Default value is 0.
+# Traditional FDMI support means the driver will assume FDMI-2 support;
+# however, if that fails, it will fallback to FDMI-1.
+# If lpfc_enable_SmartSAN is set to 1, the driver ignores lpfc_fdmi_on.
+# If lpfc_enable_SmartSAN is set 0, the driver uses the current value of
+# lpfc_fdmi_on.
+# Value range [0,1]. Default value is 0.
 */
-LPFC_ATTR_R(fdmi_on, 0, 0, 2, "Enable FDMI support");
+LPFC_ATTR_R(fdmi_on, 0, 0, 1, "Enable FDMI support");
 
 /*
 # Specifies the maximum number of ELS cmds we can have outstanding (for
@@ -5856,14 +5855,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	else
 		phba->cfg_poll = lpfc_poll;
 
-	/* Ensure fdmi_on and enable_SmartSAN don't conflict */
-	if (phba->cfg_enable_SmartSAN) {
-		phba->cfg_fdmi_on = LPFC_FDMI_SMART_SAN;
-	} else {
-		if (phba->cfg_fdmi_on == LPFC_FDMI_SMART_SAN)
-			phba->cfg_fdmi_on = LPFC_FDMI_SUPPORT;
-	}
-
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9459ac4..6cc1af4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -690,16 +690,17 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	fabric_param_changed = lpfc_check_clean_addr_bit(vport, sp);
 	if (fabric_param_changed) {
 		/* Reset FDMI attribute masks based on config parameter */
-		if (phba->cfg_fdmi_on == LPFC_FDMI_NO_SUPPORT) {
-			vport->fdmi_hba_mask = 0;
-			vport->fdmi_port_mask = 0;
-		} else {
+		if (phba->cfg_enable_SmartSAN ||
+		    (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) {
 			/* Setup appropriate attribute masks */
 			vport->fdmi_hba_mask = LPFC_FDMI2_HBA_ATTR;
-			if (phba->cfg_fdmi_on == LPFC_FDMI_SMART_SAN)
+			if (phba->cfg_enable_SmartSAN)
 				vport->fdmi_port_mask = LPFC_FDMI2_SMART_ATTR;
 			else
 				vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
+		} else {
+			vport->fdmi_hba_mask = 0;
+			vport->fdmi_port_mask = 0;
 		}
 
 	}
@@ -8005,8 +8006,9 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 		return;
 	}
 
-	if ((phba->cfg_fdmi_on > LPFC_FDMI_NO_SUPPORT) &&
-	    (vport->load_flag & FC_ALLOW_FDMI))
+	if ((phba->cfg_enable_SmartSAN ||
+	     (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) &&
+	     (vport->load_flag & FC_ALLOW_FDMI))
 		lpfc_start_fdmi(vport);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f0d0852..c922a2b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6158,11 +6158,12 @@ lpfc_create_shost(struct lpfc_hba *phba)
 	 * any initial discovery should be completed.
 	 */
 	vport->load_flag |= FC_ALLOW_FDMI;
-	if (phba->cfg_fdmi_on > LPFC_FDMI_NO_SUPPORT) {
+	if (phba->cfg_enable_SmartSAN ||
+	    (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) {
 
 		/* Setup appropriate attribute masks */
 		vport->fdmi_hba_mask = LPFC_FDMI2_HBA_ATTR;
-		if (phba->cfg_fdmi_on == LPFC_FDMI_SMART_SAN)
+		if (phba->cfg_enable_SmartSAN)
 			vport->fdmi_port_mask = LPFC_FDMI2_SMART_ATTR;
 		else
 			vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index b3f85de..9b7adca 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -395,7 +395,8 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	/* At this point we are fully registered with SCSI Layer.  */
 	vport->load_flag |= FC_ALLOW_FDMI;
-	if (phba->cfg_fdmi_on > LPFC_FDMI_NO_SUPPORT) {
+	if (phba->cfg_enable_SmartSAN ||
+	    (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) {
 		/* Setup appropriate attribute masks */
 		vport->fdmi_hba_mask = phba->pport->fdmi_hba_mask;
 		vport->fdmi_port_mask = phba->pport->fdmi_port_mask;
-- 
2.5.0

