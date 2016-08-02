From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0675/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:35:51 +0800
Message-ID: <20160802113551.27065-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, mchehab@redhat.com, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com
List-Id: linux-scsi@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/message/fusion/mptbase.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5537f8d..43a9e1a3 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -101,13 +101,13 @@ MODULE_PARM_DESC(mpt_channel_mapping, " Mapping id's to channels (default=0)");
 static int mpt_debug_level;
 static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
 module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
-		  &mpt_debug_level, 0600);
+		  &mpt_debug_level, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(mpt_debug_level,
 		 " debug level - refer to mptdebug.h - (default=0)");
 
 int mpt_fwfault_debug;
 EXPORT_SYMBOL(mpt_fwfault_debug);
-module_param(mpt_fwfault_debug, int, 0600);
+module_param(mpt_fwfault_debug, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-- 
2.9.2
