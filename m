From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH] scsi: megaraid_sas: fix error handle in megasas_probe_one
Date: Tue, 8 Aug 2017 01:26:57 +0800
Message-ID: <20170807172650.GA33146@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:24763 "EHLO
        BJEXCAS003.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752057AbdHGRmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:42:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

megasas_mgmt_info.max_index has increased by 1 before megasas_io_attach,
if megasas_io_attach return error, then goto fail_io_attach,
megasas_mgmt_info.instance has a wrong index here. So first reduce max_index
and then set that instance to NULL.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b5b9ba7..91eeec9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6226,8 +6226,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 fail_start_aen:
 fail_io_attach:
 	megasas_mgmt_info.count--;
-	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 	megasas_mgmt_info.max_index--;
+	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
-- 
2.9.4
