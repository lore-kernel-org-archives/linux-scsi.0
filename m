From: <kgudipat@brocade.com>
Subject: [PATCH 2/4] bfa: sysfs model description fix.
Date: Mon, 9 Apr 2012 18:40:43 -0700
Message-ID: <1334022043-24226-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56856 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093Ab2DJBlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 21:41:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Make changes to remove unsupported model numbers from the sysfs
	  model description routine.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index d12be9d..8b6c6bf 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -759,25 +759,10 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 	else if (!strcmp(model, "Brocade-804"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Brocade 8Gbps FC HBA for HP Bladesystem C-class");
-	else if (!strcmp(model, "Brocade-902") ||
-		 !strcmp(model, "Brocade-1741"))
+	else if (!strcmp(model, "Brocade-1741"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Brocade 10Gbps CNA for Dell M-Series Blade Servers");
-	else if (strstr(model, "Brocade-1560")) {
-		if (nports == 1)
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe single port FC HBA");
-		else
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe dual port FC HBA");
-	} else if (strstr(model, "Brocade-1710")) {
-		if (nports == 1)
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 10Gbps single port CNA");
-		else
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 10Gbps dual port CNA");
-	} else if (strstr(model, "Brocade-1860")) {
+	else if (strstr(model, "Brocade-1860")) {
 		if (nports == 1 && bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 				"Brocade 10Gbps single port CNA");
-- 
1.7.3.rc1

