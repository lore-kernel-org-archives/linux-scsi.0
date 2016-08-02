From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0917/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:50 +0800
Message-ID: <20160802115750.11121-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935054AbcHBMfw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:35:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/osst.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 5033223..d74363e 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -91,13 +91,13 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(OSST_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_TAPE);
 
-module_param(max_dev, int, 0444);
+module_param(max_dev, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(max_dev, "Maximum number of OnStream Tape Drives to attach (4)");
 
-module_param(write_threshold_kbs, int, 0644);
+module_param(write_threshold_kbs, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(write_threshold_kbs, "Asynchronous write threshold (KB; 32)");
 
-module_param(max_sg_segs, int, 0644);
+module_param(max_sg_segs, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (9)");
 #else
 static struct osst_dev_parm {
-- 
2.9.2

