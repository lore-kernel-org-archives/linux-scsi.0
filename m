From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 11/17 v2] lpfc: Code cleanup for lpfc_sriov_nr_virtfn
 parameter
Date: Wed, 12 Oct 2016 13:14:14 -0700
Message-ID: <57fe9996.g4agFuTA3waG5eON%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:59066 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755906AbcJLUOm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:42 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id 4ADF2120997
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_sriov_nr_virtfn parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 35 +++--------------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3051e66..1b6090c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4007,39 +4007,10 @@ lpfc_sriov_nr_virtfn_store(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
-static int lpfc_sriov_nr_virtfn = LPFC_DEF_VFN_PER_PFN;
-module_param(lpfc_sriov_nr_virtfn, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(lpfc_sriov_nr_virtfn, "Enable PCIe device SR-IOV virtual fn");
-lpfc_param_show(sriov_nr_virtfn)
+LPFC_ATTR(sriov_nr_virtfn, LPFC_DEF_VFN_PER_PFN, 0, LPFC_MAX_VFN_PER_PFN,
+	"Enable PCIe device SR-IOV virtual fn");
 
-/**
- * lpfc_sriov_nr_virtfn_init - Set the initial sr-iov virtual function enable
- * @phba: lpfc_hba pointer.
- * @val: link speed value.
- *
- * Description:
- * If val is in a valid range [0,255], then set the adapter's initial
- * cfg_sriov_nr_virtfn field. If it's greater than the maximum, the maximum
- * number shall be used instead. It will be up to the driver's probe_one
- * routine to determine whether the device's SR-IOV is supported or not.
- *
- * Returns:
- * zero if val saved.
- * -EINVAL val out of range
- **/
-static int
-lpfc_sriov_nr_virtfn_init(struct lpfc_hba *phba, int val)
-{
-	if (val >= 0 && val <= LPFC_MAX_VFN_PER_PFN) {
-		phba->cfg_sriov_nr_virtfn = val;
-		return 0;
-	}
-
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3017 Enabling %d virtual functions is not "
-			"allowed.\n", val);
-	return -EINVAL;
-}
+lpfc_param_show(sriov_nr_virtfn)
 static DEVICE_ATTR(lpfc_sriov_nr_virtfn, S_IRUGO | S_IWUSR,
 		   lpfc_sriov_nr_virtfn_show, lpfc_sriov_nr_virtfn_store);
 
-- 
2.5.0


