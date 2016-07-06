From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 16/21] lpfc: Remove global lpfc_sli_mode attribute in leiu of per-hba lpfc_sli_mode
Date: Wed, 06 Jul 2016 12:36:09 -0700
Message-ID: <577d5da9.H82rs/17pk56kO0d%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36174 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbcGFTgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:16 -0400
Received: by mail-wm0-f49.google.com with SMTP id f126so185565216wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:14 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id u145sm5578491wmu.4.2016.07.06.12.36.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Remove global lpfc_sli_mode attribute in leiu of per-hba lpfc_sli_mode

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 12 ++++++------
 drivers/scsi/lpfc/lpfc_crtn.h |  1 -
 drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++++------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 82d7b11..4d9f1b1 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -755,6 +755,7 @@ struct lpfc_hba {
 	uint32_t cfg_suppress_link_up;
 	uint32_t cfg_rrq_xri_bitmap_sz;
 	uint32_t cfg_delay_discovery;
+	uint32_t cfg_sli_mode;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
 #define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
 #define LPFC_DELAY_INIT_LINK_INDEFINITELY 2	/* wait, manual intervention */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f5abcea..07d8033 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2837,12 +2837,11 @@ MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
 static DEVICE_ATTR(lpfc_poll, S_IRUGO | S_IWUSR,
 		   lpfc_poll_show, lpfc_poll_store);
 
-int  lpfc_sli_mode = 0;
-module_param(lpfc_sli_mode, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_sli_mode, "SLI mode selector:"
-		 " 0 - auto (SLI-3 if supported),"
-		 " 2 - select SLI-2 even on SLI-3 capable HBAs,"
-		 " 3 - select SLI-3");
+LPFC_ATTR(sli_mode, 0, 0, 3,
+	"SLI mode selector:"
+	" 0 - auto (SLI-3 if supported),"
+	" 2 - select SLI-2 even on SLI-3 capable HBAs,"
+	" 3 - select SLI-3");
 
 LPFC_ATTR_R(enable_npiv, 1, 0, 1,
 	"Enable NPIV functionality");
@@ -5936,6 +5935,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	lpfc_delay_discovery_init(phba, lpfc_delay_discovery);
+	lpfc_sli_mode_init(phba, lpfc_sli_mode);
 	phba->cfg_enable_dss = 1;
 	lpfc_enable_mds_diags_init(phba, lpfc_enable_mds_diags);
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 9f075db..3a5a02e 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -359,7 +359,6 @@ extern struct scsi_host_template lpfc_template_s3;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
-extern int lpfc_sli_mode;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 53ed6c5..c8fd0a3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4665,13 +4665,13 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 	int  mode = 3, i;
 	int longs;
 
-	switch (lpfc_sli_mode) {
+	switch (phba->cfg_sli_mode) {
 	case 2:
 		if (phba->cfg_enable_npiv) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
-				"1824 NPIV enabled: Override lpfc_sli_mode "
+				"1824 NPIV enabled: Override sli_mode "
 				"parameter (%d) to auto (0).\n",
-				lpfc_sli_mode);
+				phba->cfg_sli_mode);
 			break;
 		}
 		mode = 2;
@@ -4681,8 +4681,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
-				"1819 Unrecognized lpfc_sli_mode "
-				"parameter: %d.\n", lpfc_sli_mode);
+				"1819 Unrecognized sli_mode parameter: %d.\n",
+				phba->cfg_sli_mode);
 
 		break;
 	}
@@ -4690,7 +4690,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 
 	rc = lpfc_sli_config_port(phba, mode);
 
-	if (rc && lpfc_sli_mode == 3)
+	if (rc && phba->cfg_sli_mode == 3)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
 				"1820 Unable to select SLI-3.  "
 				"Not supported by adapter.\n");
-- 
2.5.0

