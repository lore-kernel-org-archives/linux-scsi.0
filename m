From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/21] lpfc: Add support for reporting option_rom_version on
 newer adapters
Date: Fri, 3 Apr 2015 17:11:46 -0400
Message-ID: <1428095506.6933.36.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:1277 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbDCVMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 17:12:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support for reporting option_rom_version on newer adapters

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 2f9b968..374aa03 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -406,8 +406,13 @@ lpfc_option_rom_version_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
+	char fwrev[FW_REV_STR_SIZE];
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return snprintf(buf, PAGE_SIZE, "%s\n", phba->OptionROMVersion);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", phba->OptionROMVersion);
+	lpfc_decode_firmware_rev(phba, fwrev, 1);
+	return snprintf(buf, PAGE_SIZE, "%s\n", fwrev);
 }
 
 /**
-- 
1.7.11.7




