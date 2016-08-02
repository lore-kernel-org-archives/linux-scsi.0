From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0915/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:40 +0800
Message-ID: <20160802115740.10965-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935076AbcHBMgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:36:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 751f13e..d9cc7c2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -122,7 +122,7 @@ _scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
 	return 0;
 }
 module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
-	param_get_int, &mpt3sas_fwfault_debug, 0644);
+	param_get_int, &mpt3sas_fwfault_debug, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 /**
  *  mpt3sas_remove_dead_ioc_func - kthread context to remove dead ioc
-- 
2.9.2

