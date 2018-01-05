From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 01/14] megaraid_sas: zero out IOC INIT and stream detection memory
Date: Fri,  5 Jan 2018 05:27:36 -0800
Message-ID: <1515158869-26693-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35014 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbeAEN3K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:10 -0500
Received: by mail-pf0-f195.google.com with SMTP id j124so2182026pfc.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:10 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Memory allocated for IOC_INIT command and stream detection array
are not zero'd before using. Use kzalloc instead of kmalloc to zero out
the memory allocated.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index cc54bdb5c712..ed106cbd4440 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5387,7 +5387,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		}
 		for (i = 0; i < MAX_LOGICAL_DRIVES_EXT; ++i) {
 			fusion->stream_detect_by_ld[i] =
-				kmalloc(sizeof(struct LD_STREAM_DETECT),
+				kzalloc(sizeof(struct LD_STREAM_DETECT),
 				GFP_KERNEL);
 			if (!fusion->stream_detect_by_ld[i]) {
 				dev_err(&instance->pdev->dev,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 65dc4fea6352..0d6d4dedad62 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1603,7 +1603,7 @@ static int megasas_alloc_ioc_init_frame(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 
-	cmd = kmalloc(sizeof(struct megasas_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(struct megasas_cmd), GFP_KERNEL);
 
 	if (!cmd) {
 		dev_err(&instance->pdev->dev, "Failed from func: %s line: %d\n",
-- 
2.14.1
