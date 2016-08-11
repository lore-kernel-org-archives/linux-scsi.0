From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 07/14] lpfc: Code cleanup for lpfc_aer_support parameter
Date: Thu, 11 Aug 2016 11:35:54 -0700
Message-ID: <57acc58a.jPfQwceLUxXOHCXu%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36488 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcHKSf5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:57 -0400
Received: by mail-qt0-f169.google.com with SMTP id 52so2102751qtq.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:57 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id 1sm931508qkj.42.2016.08.11.11.35.55
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_aer_support parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 43 +++----------------------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 22a66c7..ae76aaa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3779,6 +3779,9 @@ static DEVICE_ATTR(lpfc_link_speed, S_IRUGO | S_IWUSR,
 #       1  = aer supported and enabled (default)
 # Value range is [0,1]. Default value is 1.
 */
+LPFC_ATTR(aer_support, 1, 0, 1,
+	"Enable PCIe device AER support");
+lpfc_param_show(aer_support)
 
 /**
  * lpfc_aer_support_store - Set the adapter for aer support
@@ -3861,46 +3864,6 @@ lpfc_aer_support_store(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
-static int lpfc_aer_support = 1;
-module_param(lpfc_aer_support, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_aer_support, "Enable PCIe device AER support");
-lpfc_param_show(aer_support)
-
-/**
- * lpfc_aer_support_init - Set the initial adapters aer support flag
- * @phba: lpfc_hba pointer.
- * @val: enable aer or disable aer flag.
- *
- * Description:
- * If val is in a valid range [0,1], then set the adapter's initial
- * cfg_aer_support field. It will be up to the driver's probe_one
- * routine to determine whether the device's AER support can be set
- * or not.
- *
- * Notes:
- * If the value is not in range log a kernel error message, and
- * choose the default value of setting AER support and return.
- *
- * Returns:
- * zero if val saved.
- * -EINVAL val out of range
- **/
-static int
-lpfc_aer_support_init(struct lpfc_hba *phba, int val)
-{
-	if (val == 0 || val == 1) {
-		phba->cfg_aer_support = val;
-		return 0;
-	}
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"2712 lpfc_aer_support attribute value %d out "
-			"of range, allowed values are 0|1, setting it "
-			"to default value of 1\n", val);
-	/* By default, try to enable AER on a device */
-	phba->cfg_aer_support = 1;
-	return -EINVAL;
-}
-
 static DEVICE_ATTR(lpfc_aer_support, S_IRUGO | S_IWUSR,
 		   lpfc_aer_support_show, lpfc_aer_support_store);
 
-- 
2.5.0

