From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0082/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:39:14 +0800
Message-ID: <20160802103914.19225-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63608 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbcHBLSr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 07:18:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com, len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org, hpa@zytor.com, x86@kernel.org
Cc: iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/block/cciss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 63c2064..05dc1bd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -67,7 +67,7 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
 MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 static int cciss_tape_cmds = 6;
-module_param(cciss_tape_cmds, int, 0644);
+module_param(cciss_tape_cmds, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cciss_tape_cmds,
 	"number of commands to allocate for tape devices (default: 6)");
 static int cciss_simple_mode;
-- 
2.9.2

