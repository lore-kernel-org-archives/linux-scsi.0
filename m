From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 17/23] be2iscsi: Fix MSIx creation for SKH-R adapter
Date: Sat, 28 Sep 2013 15:35:54 -0700
Message-ID: <1380407761-2949-17-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53055 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3I1Wgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:46 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq14so4214508pab.40
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:45 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 The MSIx to be created for SKH-R adapter should be based on
 eq_count returned by get_fw_config.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   45 +++++++++++++++++++++++++--------------
 drivers/scsi/be2iscsi/be_main.h |    3 ++-
 drivers/scsi/be2iscsi/be_mgmt.c |   11 ++++++++++
 3 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index de948d3..ddacd2c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3758,8 +3758,19 @@ static void find_num_cpus(struct beiscsi_hba *phba)
 				  BEISCSI_MAX_NUM_CPUS : num_cpus;
 		break;
 	case BE_GEN4:
-		phba->num_cpus = (num_cpus > OC_SKH_MAX_NUM_CPUS) ?
-				  OC_SKH_MAX_NUM_CPUS : num_cpus;
+		/*
+		 * If eqid_count == 1 fall back to
+		 * INTX mechanism
+		 **/
+		if (phba->fw_config.eqid_count == 1) {
+			enable_msix = 0;
+			phba->num_cpus = 1;
+			return;
+		}
+
+		phba->num_cpus =
+			(num_cpus > (phba->fw_config.eqid_count - 1)) ?
+			(phba->fw_config.eqid_count - 1) : num_cpus;
 		break;
 	default:
 		phba->num_cpus = 1;
@@ -5275,20 +5286,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		phba->generation = 0;
 	}
 
-	if (enable_msix)
-		find_num_cpus(phba);
-	else
-		phba->num_cpus = 1;
-
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : num_cpus = %d\n",
-		    phba->num_cpus);
-
-	if (enable_msix) {
-		beiscsi_msix_enable(phba);
-		if (!phba->msix_enabled)
-			phba->num_cpus = 1;
-	}
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
@@ -5320,6 +5317,22 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 			    "BM_%d : Error getting fw config\n");
 		goto free_port;
 	}
+
+	if (enable_msix)
+		find_num_cpus(phba);
+	else
+		phba->num_cpus = 1;
+
+	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+		    "BM_%d : num_cpus = %d\n",
+		    phba->num_cpus);
+
+	if (enable_msix) {
+		beiscsi_msix_enable(phba);
+		if (!phba->msix_enabled)
+			phba->num_cpus = 1;
+	}
+
 	phba->shost->max_id = phba->params.cxns_per_ctrl;
 	beiscsi_get_params(phba);
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 3fa1e81..88291b0 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -65,7 +65,6 @@
 
 #define MAX_CPUS		64
 #define BEISCSI_MAX_NUM_CPUS	7
-#define OC_SKH_MAX_NUM_CPUS	31
 
 #define BEISCSI_VER_STRLEN 32
 
@@ -377,6 +376,8 @@ struct beiscsi_hba {
 		 * for cid to cri conversion
 		 */
 		unsigned int phys_port;
+		unsigned int eqid_count;
+		unsigned int cqid_count;
 		unsigned int iscsi_cid_start[BEISCSI_ULP_COUNT];
 #define BEISCSI_GET_CID_COUNT(phba, ulp_num) \
 		(phba->fw_config.iscsi_cid_count[ulp_num])
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 7b0b13f..befeace 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -311,6 +311,17 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 		struct be_fw_cfg *pfw_cfg;
 		pfw_cfg = req;
 
+		if (!is_chip_be2_be3r(phba)) {
+			phba->fw_config.eqid_count = pfw_cfg->eqid_count;
+			phba->fw_config.cqid_count = pfw_cfg->cqid_count;
+
+			beiscsi_log(phba, KERN_INFO,
+				    BEISCSI_LOG_INIT,
+				    "BG_%d : EQ_Count : %d CQ_Count : %d\n",
+				    phba->fw_config.eqid_count,
+				    phba->fw_config.cqid_count);
+		}
+
 		for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
 			if (pfw_cfg->ulp[ulp_num].ulp_mode &
 			    BEISCSI_ULP_ISCSI_INI_MODE)
-- 
1.7.10.4

