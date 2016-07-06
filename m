From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 12/21] lpfc: Add support for XLane LUN priority
Date: Wed, 06 Jul 2016 12:36:05 -0700
Message-ID: <577d5da5.ZeUwNJhNxrqTmzvD%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35058 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbcGFTgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:11 -0400
Received: by mail-wm0-f41.google.com with SMTP id z126so123512474wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:10 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id p191sm4156939wme.7.2016.07.06.12.36.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for XLane LUN priority

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 89 +++++++++++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_crtn.h |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c |  9 ++++-
 drivers/scsi/lpfc/lpfc_scsi.h |  1 +
 drivers/scsi/lpfc/lpfc_sli.c  | 21 +++++++---
 drivers/scsi/lpfc/lpfc_sli.h  |  1 +
 7 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 69da16d..40e069c 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -743,6 +743,7 @@ struct lpfc_hba {
 #define OAS_FIND_ANY_VPORT	0x01
 #define OAS_FIND_ANY_TARGET	0x02
 #define OAS_LUN_VALID	0x04
+	uint32_t cfg_oas_priority;
 	uint32_t cfg_XLanePriority;
 	uint32_t cfg_enable_bg;
 	uint32_t cfg_hostmem_hgp;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cde7da6..a75404a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2401,6 +2401,69 @@ static DEVICE_ATTR(lpfc_xlane_tgt, S_IRUGO | S_IWUSR,
 		   lpfc_oas_tgt_show, lpfc_oas_tgt_store);
 
 /**
+ * lpfc_oas_priority_show - Return wwpn of target whose luns maybe enabled for
+ *		      Optimized Access Storage (OAS) operations.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: buffer for passing information.
+ *
+ * Returns:
+ * value of count
+ **/
+static ssize_t
+lpfc_oas_priority_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_priority);
+}
+
+/**
+ * lpfc_oas_priority_store - Store wwpn of target whose luns maybe enabled for
+ *		      Optimized Access Storage (OAS) operations.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: buffer for passing information.
+ * @count: Size of the data buffer.
+ *
+ * Returns:
+ * -EINVAL count is invalid, invalid wwpn byte invalid
+ * -EPERM oas is not supported by hba
+ * value of count on success
+ **/
+static ssize_t
+lpfc_oas_priority_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	unsigned int cnt = count;
+	unsigned long val;
+	int ret;
+
+	if (!phba->cfg_fof)
+		return -EPERM;
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret || (val > 0x7f))
+		return -EINVAL;
+
+	if (val)
+		phba->cfg_oas_priority = (uint8_t)val;
+	else
+		phba->cfg_oas_priority = phba->cfg_XLanePriority;
+	return count;
+}
+static DEVICE_ATTR(lpfc_xlane_priority, S_IRUGO | S_IWUSR,
+		   lpfc_oas_priority_show, lpfc_oas_priority_store);
+
+/**
  * lpfc_oas_vpt_show - Return wwpn of vport whose targets maybe enabled
  *		      for Optimized Access Storage (OAS) operations.
  * @dev: class device that is converted into a Scsi_host.
@@ -2462,6 +2525,7 @@ lpfc_oas_vpt_store(struct device *dev, struct device_attribute *attr,
 	else
 		phba->cfg_oas_flags &= ~OAS_FIND_ANY_VPORT;
 	phba->cfg_oas_flags &= ~OAS_LUN_VALID;
+	phba->cfg_oas_priority = phba->cfg_XLanePriority;
 	phba->sli4_hba.oas_next_lun = FIND_FIRST_OAS_LUN;
 	return count;
 }
@@ -2524,7 +2588,6 @@ lpfc_oas_lun_state_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	phba->cfg_oas_lun_state = val;
-
 	return strlen(buf);
 }
 static DEVICE_ATTR(lpfc_xlane_lun_state, S_IRUGO | S_IWUSR,
@@ -2572,7 +2635,8 @@ static DEVICE_ATTR(lpfc_xlane_lun_status, S_IRUGO,
  */
 static size_t
 lpfc_oas_lun_state_set(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
-		       uint8_t tgt_wwpn[], uint64_t lun, uint32_t oas_state)
+		       uint8_t tgt_wwpn[], uint64_t lun,
+		       uint32_t oas_state, uint8_t pri)
 {
 
 	int rc = 0;
@@ -2582,7 +2646,8 @@ lpfc_oas_lun_state_set(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
 
 	if (oas_state) {
 		if (!lpfc_enable_oas_lun(phba, (struct lpfc_name *)vpt_wwpn,
-					 (struct lpfc_name *)tgt_wwpn, lun))
+					 (struct lpfc_name *)tgt_wwpn,
+					 lun, pri))
 			rc = -ENOMEM;
 	} else {
 		lpfc_disable_oas_lun(phba, (struct lpfc_name *)vpt_wwpn,
@@ -2648,13 +2713,13 @@ lpfc_oas_lun_get_next(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
 static ssize_t
 lpfc_oas_lun_state_change(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
 			  uint8_t tgt_wwpn[], uint64_t lun,
-			  uint32_t oas_state)
+			  uint32_t oas_state, uint8_t pri)
 {
 
 	int rc;
 
 	rc = lpfc_oas_lun_state_set(phba, vpt_wwpn, tgt_wwpn, lun,
-					oas_state);
+				    oas_state, pri);
 	return rc;
 }
 
@@ -2744,16 +2809,16 @@ lpfc_oas_lun_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"3372 Try to set vport 0x%llx target 0x%llx lun:%lld "
-			"with oas set to %d\n",
+			"3372 Try to set vport 0x%llx target 0x%llx lun:0x%llx "
+			"priority 0x%x with oas state %d\n",
 			wwn_to_u64(phba->cfg_oas_vpt_wwpn),
 			wwn_to_u64(phba->cfg_oas_tgt_wwpn), scsi_lun,
-			phba->cfg_oas_lun_state);
+			phba->cfg_oas_priority, phba->cfg_oas_lun_state);
 
 	rc = lpfc_oas_lun_state_change(phba, phba->cfg_oas_vpt_wwpn,
-					   phba->cfg_oas_tgt_wwpn, scsi_lun,
-					   phba->cfg_oas_lun_state);
-
+				       phba->cfg_oas_tgt_wwpn, scsi_lun,
+				       phba->cfg_oas_lun_state,
+				       phba->cfg_oas_priority);
 	if (rc)
 		return rc;
 
@@ -4865,6 +4930,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_xlane_vpt,
 	&dev_attr_lpfc_xlane_lun_state,
 	&dev_attr_lpfc_xlane_lun_status,
+	&dev_attr_lpfc_xlane_priority,
 	&dev_attr_lpfc_sg_seg_cnt,
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
@@ -5858,6 +5924,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	phba->cfg_oas_lun_state = 0;
 	phba->cfg_oas_lun_status = 0;
 	phba->cfg_oas_flags = 0;
+	phba->cfg_oas_priority = 0;
 	lpfc_enable_bg_init(phba, lpfc_enable_bg);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		phba->cfg_poll = 0;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 4e55b35..bc0e2f1 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -492,7 +492,7 @@ struct lpfc_device_data *__lpfc_get_device_data(struct lpfc_hba *,
 					struct lpfc_name *,
 					struct lpfc_name *, uint64_t);
 bool lpfc_enable_oas_lun(struct lpfc_hba *, struct lpfc_name *,
-			 struct lpfc_name *, uint64_t);
+			 struct lpfc_name *, uint64_t, uint8_t);
 bool lpfc_disable_oas_lun(struct lpfc_hba *, struct lpfc_name *,
 			  struct lpfc_name *, uint64_t);
 bool lpfc_find_next_oas_lun(struct lpfc_hba *, struct lpfc_name *,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 12b8e82..3f33fd6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3335,8 +3335,11 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	 * OAS, set the oas iocb related flags.
 	 */
 	if ((phba->cfg_fof) && ((struct lpfc_device_data *)
-		scsi_cmnd->device->hostdata)->oas_enabled)
+		scsi_cmnd->device->hostdata)->oas_enabled) {
 		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
+		lpfc_cmd->cur_iocbq.priority = ((struct lpfc_device_data *)
+			scsi_cmnd->device->hostdata)->priority;
+	}
 	return 0;
 }
 
@@ -5607,6 +5610,7 @@ lpfc_create_device_data(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 	       sizeof(struct lpfc_name));
 	lun_info->device_id.lun = lun;
 	lun_info->oas_enabled = false;
+	lun_info->priority = phba->cfg_XLanePriority;
 	lun_info->available = false;
 	return lun_info;
 }
@@ -5798,7 +5802,7 @@ lpfc_find_next_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
  **/
 bool
 lpfc_enable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
-		    struct lpfc_name *target_wwpn, uint64_t lun)
+		    struct lpfc_name *target_wwpn, uint64_t lun, uint8_t pri)
 {
 
 	struct lpfc_device_data *lun_info;
@@ -5825,6 +5829,7 @@ lpfc_enable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 					   false);
 	if (lun_info) {
 		lun_info->oas_enabled = true;
+		lun_info->priority = pri;
 		lun_info->available = false;
 		list_add_tail(&lun_info->listentry, &phba->luns);
 		spin_unlock_irqrestore(&phba->devicelock, flags);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 18b9260..46c090b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -51,6 +51,7 @@ struct lpfc_device_data {
 	struct list_head listentry;
 	struct lpfc_rport_data *rport_data;
 	struct lpfc_device_id device_id;
+	uint8_t priority;
 	bool oas_enabled;
 	bool available;
 };
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b1ddbaa..53ed6c5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8441,8 +8441,11 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 1);
 		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_iwrite.wqe_com, 1);
-			if (phba->cfg_XLanePriority) {
-				bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
+			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
+			if (iocbq->priority) {
+				bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
+				       (iocbq->priority << 1));
+			} else {
 				bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
 				       (phba->cfg_XLanePriority << 1));
 			}
@@ -8497,8 +8500,11 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
 		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_iread.wqe_com, 1);
-			if (phba->cfg_XLanePriority) {
-				bf_set(wqe_ccpe, &wqe->fcp_iread.wqe_com, 1);
+			bf_set(wqe_ccpe, &wqe->fcp_iread.wqe_com, 1);
+			if (iocbq->priority) {
+				bf_set(wqe_ccp, &wqe->fcp_iread.wqe_com,
+				       (iocbq->priority << 1));
+			} else {
 				bf_set(wqe_ccp, &wqe->fcp_iread.wqe_com,
 				       (phba->cfg_XLanePriority << 1));
 			}
@@ -8552,8 +8558,11 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       iocbq->iocb.ulpFCP2Rcvy);
 		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_icmd.wqe_com, 1);
-			if (phba->cfg_XLanePriority) {
-				bf_set(wqe_ccpe, &wqe->fcp_icmd.wqe_com, 1);
+			bf_set(wqe_ccpe, &wqe->fcp_icmd.wqe_com, 1);
+			if (iocbq->priority) {
+				bf_set(wqe_ccp, &wqe->fcp_icmd.wqe_com,
+				       (iocbq->priority << 1));
+			} else {
 				bf_set(wqe_ccp, &wqe->fcp_icmd.wqe_com,
 				       (phba->cfg_XLanePriority << 1));
 			}
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 7fe99ff..b33dbd3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -57,6 +57,7 @@ struct lpfc_iocbq {
 	struct lpfc_cq_event cq_event;
 
 	IOCB_t iocb;		/* IOCB cmd */
+	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint32_t iocb_flag;
 #define LPFC_IO_LIBDFC		1	/* libdfc iocb */
-- 
2.5.0

