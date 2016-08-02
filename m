From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0910/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:15 +0800
Message-ID: <20160802115715.10633-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, QLogic-Storage-Upstream@qlogic.com, heiko.carstens@de.ibm.com, dwmw2@infradead.org, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com
List-Id: linux-scsi@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/ch.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index dad959f..b6979d1 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -45,39 +45,39 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_MEDIUM_CHANGER);
 
 static DEFINE_MUTEX(ch_mutex);
 static int init = 1;
-module_param(init, int, 0444);
+module_param(init, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(init, \
     "initialize element status on driver load (default: on)");
 
 static int timeout_move = 300;
-module_param(timeout_move, int, 0644);
+module_param(timeout_move, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(timeout_move,"timeout for move commands "
 		 "(default: 300 seconds)");
 
 static int timeout_init = 3600;
-module_param(timeout_init, int, 0644);
+module_param(timeout_init, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(timeout_init,"timeout for INITIALIZE ELEMENT STATUS "
 		 "(default: 3600 seconds)");
 
 static int verbose = 1;
-module_param(verbose, int, 0644);
+module_param(verbose, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(verbose,"be verbose (default: on)");
 
 static int debug = 0;
-module_param(debug, int, 0644);
+module_param(debug, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug,"enable/disable debug messages, also prints more "
 		 "detailed sense codes on scsi errors (default: off)");
 
 static int dt_id[CH_DT_MAX] = { [ 0 ... (CH_DT_MAX-1) ] = -1 };
 static int dt_lun[CH_DT_MAX];
-module_param_array(dt_id,  int, NULL, 0444);
-module_param_array(dt_lun, int, NULL, 0444);
+module_param_array(dt_id,  int, NULL, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_array(dt_lun, int, NULL, S_IRUSR | S_IRGRP | S_IROTH);
 
 /* tell the driver about vendor-specific slots */
 static int vendor_firsts[CH_TYPES-4];
 static int vendor_counts[CH_TYPES-4];
-module_param_array(vendor_firsts, int, NULL, 0444);
-module_param_array(vendor_counts, int, NULL, 0444);
+module_param_array(vendor_firsts, int, NULL, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_array(vendor_counts, int, NULL, S_IRUSR | S_IRGRP | S_IROTH);
 
 static const char * vendor_labels[CH_TYPES-4] = {
 	"v0", "v1", "v2", "v3"
-- 
2.9.2
