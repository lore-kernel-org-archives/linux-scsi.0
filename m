From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0914/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:36 +0800
Message-ID: <20160802115736.10899-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6323 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934977AbcHBMgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:36:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, heiko.carstens@de.ibm.com, dwmw2@infradead.org, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1753e42..ed89d8c 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -69,7 +69,7 @@ module_param(sync_targets, int, 0);
 MODULE_PARM_DESC(sync_targets, "Bitmask of targets allowed to set synchronous");
 module_param(resel_targets, int, 0);
 MODULE_PARM_DESC(resel_targets, "Bitmask of targets allowed to set disconnect");
-module_param(debug_targets, int, 0644);
+module_param(debug_targets, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug_targets, "Bitmask of debugged targets");
 module_param(init_reset_delay, int, 0);
 MODULE_PARM_DESC(init_reset_delay, "Initial bus reset delay (0=no reset)");
-- 
2.9.2

