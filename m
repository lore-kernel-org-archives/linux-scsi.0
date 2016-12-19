From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v2 07/11] lpfc: Fix Xlane dynamic LUN set for LUN
 priority.
Date: Mon, 19 Dec 2016 15:07:26 -0800
Message-ID: <5858682e.XbXvVCw6F0Td7N4b%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp02.broadcom.com ([192.19.219.146]:42871 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756064AbcLSXH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 18:07:29 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id E591D260002
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 15:07:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix Xlane dynamic LUN set for LUN priority. Dynamic changing of the
priority was not getting reflected on the LUN.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 23 +++++++++++++++--------
 drivers/scsi/lpfc/lpfc_crtn.h |  7 ++++---
 drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++++------
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f3250ad..c30fafe 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2224,7 +2224,8 @@ lpfc_oas_vpt_store(struct device *dev, struct device_attribute *attr,
 	else
 		phba->cfg_oas_flags &= ~OAS_FIND_ANY_VPORT;
 	phba->cfg_oas_flags &= ~OAS_LUN_VALID;
-	phba->cfg_oas_priority = phba->cfg_XLanePriority;
+	if (phba->cfg_oas_priority == 0)
+		phba->cfg_oas_priority = phba->cfg_XLanePriority;
 	phba->sli4_hba.oas_next_lun = FIND_FIRST_OAS_LUN;
 	return count;
 }
@@ -2350,7 +2351,7 @@ lpfc_oas_lun_state_set(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
 			rc = -ENOMEM;
 	} else {
 		lpfc_disable_oas_lun(phba, (struct lpfc_name *)vpt_wwpn,
-				     (struct lpfc_name *)tgt_wwpn, lun);
+				     (struct lpfc_name *)tgt_wwpn, lun, pri);
 	}
 	return rc;
 
@@ -2374,7 +2375,8 @@ lpfc_oas_lun_state_set(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
  */
 static uint64_t
 lpfc_oas_lun_get_next(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
-		      uint8_t tgt_wwpn[], uint32_t *lun_status)
+		      uint8_t tgt_wwpn[], uint32_t *lun_status,
+		      uint32_t *lun_pri)
 {
 	uint64_t found_lun;
 
@@ -2387,7 +2389,7 @@ lpfc_oas_lun_get_next(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
 				   &phba->sli4_hba.oas_next_lun,
 				   (struct lpfc_name *)vpt_wwpn,
 				   (struct lpfc_name *)tgt_wwpn,
-				   &found_lun, lun_status))
+				   &found_lun, lun_status, lun_pri))
 		return found_lun;
 	else
 		return NOT_OAS_ENABLED_LUN;
@@ -2459,7 +2461,8 @@ lpfc_oas_lun_show(struct device *dev, struct device_attribute *attr,
 
 	oas_lun = lpfc_oas_lun_get_next(phba, phba->cfg_oas_vpt_wwpn,
 					phba->cfg_oas_tgt_wwpn,
-					&phba->cfg_oas_lun_status);
+					&phba->cfg_oas_lun_status,
+					&phba->cfg_oas_priority);
 	if (oas_lun != NOT_OAS_ENABLED_LUN)
 		phba->cfg_oas_flags |= OAS_LUN_VALID;
 
@@ -2490,6 +2493,7 @@ lpfc_oas_lun_store(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	uint64_t scsi_lun;
+	uint32_t pri;
 	ssize_t rc;
 
 	if (!phba->cfg_fof)
@@ -2507,17 +2511,20 @@ lpfc_oas_lun_store(struct device *dev, struct device_attribute *attr,
 	if (sscanf(buf, "0x%llx", &scsi_lun) != 1)
 		return -EINVAL;
 
+	pri = phba->cfg_oas_priority;
+	if (pri == 0)
+		pri = phba->cfg_XLanePriority;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"3372 Try to set vport 0x%llx target 0x%llx lun:0x%llx "
 			"priority 0x%x with oas state %d\n",
 			wwn_to_u64(phba->cfg_oas_vpt_wwpn),
 			wwn_to_u64(phba->cfg_oas_tgt_wwpn), scsi_lun,
-			phba->cfg_oas_priority, phba->cfg_oas_lun_state);
+			pri, phba->cfg_oas_lun_state);
 
 	rc = lpfc_oas_lun_state_change(phba, phba->cfg_oas_vpt_wwpn,
 				       phba->cfg_oas_tgt_wwpn, scsi_lun,
-				       phba->cfg_oas_lun_state,
-				       phba->cfg_oas_priority);
+				       phba->cfg_oas_lun_state, pri);
 	if (rc)
 		return rc;
 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 15d2bfd..309643a 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -480,7 +480,7 @@ void lpfc_sli4_offline_eratt(struct lpfc_hba *);
 struct lpfc_device_data *lpfc_create_device_data(struct lpfc_hba *,
 						struct lpfc_name *,
 						struct lpfc_name *,
-						uint64_t, bool);
+						uint64_t, uint32_t,  bool);
 void lpfc_delete_device_data(struct lpfc_hba *, struct lpfc_device_data*);
 struct lpfc_device_data *__lpfc_get_device_data(struct lpfc_hba *,
 					struct list_head *list,
@@ -489,9 +489,10 @@ struct lpfc_device_data *__lpfc_get_device_data(struct lpfc_hba *,
 bool lpfc_enable_oas_lun(struct lpfc_hba *, struct lpfc_name *,
 			 struct lpfc_name *, uint64_t, uint8_t);
 bool lpfc_disable_oas_lun(struct lpfc_hba *, struct lpfc_name *,
-			  struct lpfc_name *, uint64_t);
+			  struct lpfc_name *, uint64_t, uint8_t);
 bool lpfc_find_next_oas_lun(struct lpfc_hba *, struct lpfc_name *,
 			    struct lpfc_name *, uint64_t *, struct lpfc_name *,
-			    struct lpfc_name *, uint64_t *, uint32_t *);
+			    struct lpfc_name *, uint64_t *,
+			    uint32_t *, uint32_t *);
 int lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox);
 void lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ad350d9..19d349f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5452,7 +5452,9 @@ lpfc_slave_alloc(struct scsi_device *sdev)
 			device_data = lpfc_create_device_data(phba,
 							&vport->fc_portname,
 							&target_wwpn,
-							sdev->lun, true);
+							sdev->lun,
+							phba->cfg_XLanePriority,
+							true);
 			if (!device_data)
 				return -ENOMEM;
 			spin_lock_irqsave(&phba->devicelock, flags);
@@ -5587,7 +5589,7 @@ lpfc_slave_destroy(struct scsi_device *sdev)
 struct lpfc_device_data*
 lpfc_create_device_data(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 			struct lpfc_name *target_wwpn, uint64_t lun,
-			bool atomic_create)
+			uint32_t pri, bool atomic_create)
 {
 
 	struct lpfc_device_data *lun_info;
@@ -5614,7 +5616,7 @@ lpfc_create_device_data(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 	       sizeof(struct lpfc_name));
 	lun_info->device_id.lun = lun;
 	lun_info->oas_enabled = false;
-	lun_info->priority = phba->cfg_XLanePriority;
+	lun_info->priority = pri;
 	lun_info->available = false;
 	return lun_info;
 }
@@ -5716,7 +5718,8 @@ lpfc_find_next_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 		       struct lpfc_name *found_vport_wwpn,
 		       struct lpfc_name *found_target_wwpn,
 		       uint64_t *found_lun,
-		       uint32_t *found_lun_status)
+		       uint32_t *found_lun_status,
+		       uint32_t *found_lun_pri)
 {
 
 	unsigned long flags;
@@ -5763,6 +5766,7 @@ lpfc_find_next_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 						OAS_LUN_STATUS_EXISTS;
 				else
 					*found_lun_status = 0;
+				*found_lun_pri = lun_info->priority;
 				if (phba->cfg_oas_flags & OAS_FIND_ANY_VPORT)
 					memset(vport_wwpn, 0x0,
 					       sizeof(struct lpfc_name));
@@ -5824,13 +5828,14 @@ lpfc_enable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 	if (lun_info) {
 		if (!lun_info->oas_enabled)
 			lun_info->oas_enabled = true;
+		lun_info->priority = pri;
 		spin_unlock_irqrestore(&phba->devicelock, flags);
 		return true;
 	}
 
 	/* Create an lun info structure and add to list of luns */
 	lun_info = lpfc_create_device_data(phba, vport_wwpn, target_wwpn, lun,
-					   false);
+					   pri, false);
 	if (lun_info) {
 		lun_info->oas_enabled = true;
 		lun_info->priority = pri;
@@ -5864,7 +5869,7 @@ lpfc_enable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
  **/
 bool
 lpfc_disable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
-		     struct lpfc_name *target_wwpn, uint64_t lun)
+		     struct lpfc_name *target_wwpn, uint64_t lun, uint8_t pri)
 {
 
 	struct lpfc_device_data *lun_info;
@@ -5882,6 +5887,7 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 					  target_wwpn, lun);
 	if (lun_info) {
 		lun_info->oas_enabled = false;
+		lun_info->priority = pri;
 		if (!lun_info->available)
 			lpfc_delete_device_data(phba, lun_info);
 		spin_unlock_irqrestore(&phba->devicelock, flags);
-- 
2.5.0


