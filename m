From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH v2] scsi: megaraid_sas: fix allocate instance->pd_info twice
Date: Tue, 8 Aug 2017 13:15:55 +0800
Message-ID: <20170808051549.GA11601@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.didichuxing.com ([111.202.154.82]:28335 "EHLO
        BJEXCAS004.didichuxing.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750770AbdHHFbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 01:31:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

fix allocate instance->pd_info twice which was introduced by 96188a89cc6d.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 71c4746..a0f057c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6096,14 +6096,12 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		instance->pd_info = pci_alloc_consistent(pdev,
 			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
 
-		instance->pd_info = pci_alloc_consistent(pdev,
-			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
-		instance->tgt_prop = pci_alloc_consistent(pdev,
-			sizeof(struct MR_TARGET_PROPERTIES), &instance->tgt_prop_h);
-
 		if (!instance->pd_info)
 			dev_err(&instance->pdev->dev, "Failed to alloc mem for pd_info\n");
 
+		instance->tgt_prop = pci_alloc_consistent(pdev,
+			sizeof(struct MR_TARGET_PROPERTIES), &instance->tgt_prop_h);
+
 		if (!instance->tgt_prop)
 			dev_err(&instance->pdev->dev, "Failed to alloc mem for tgt_prop\n");
 
-- 
2.9.4
