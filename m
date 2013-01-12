From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH] drivers/scsi/cxgbi: correcting the include path, so can pass
 compiling.
Date: Sat, 12 Jan 2013 20:42:29 +0800
Message-ID: <50F15A35.4000400@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:23884 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3ALMlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jan 2013 07:41:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: David Miller <davem@davemloft.net>, kxie@chelsio.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org


  correct the include path,
  or the compiler will report can not find "common.h"...

  both cxgb3/ and cxgb4/ sub directly have l2t.h (they are different).
  so it is not suitable to '-I' sub-directy, directly.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/scsi/cxgbi/Makefile        |    4 ++++
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   14 +++++++-------
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   10 +++++-----
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
index 86007e3..aff2998 100644
--- a/drivers/scsi/cxgbi/Makefile
+++ b/drivers/scsi/cxgbi/Makefile
@@ -1,2 +1,6 @@
+
+ccflags-y			:= -Idrivers/net/ethernet/chelsio
+subdir-ccflags-y		:= -Idrivers/net/ethernet/chelsio
+
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libcxgbi.o cxgb3i/
 obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libcxgbi.o cxgb4i/
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 49692a1..ca92e72 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -18,13 +18,13 @@
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
 
-#include "common.h"
-#include "t3_cpl.h"
-#include "t3cdev.h"
-#include "cxgb3_defs.h"
-#include "cxgb3_ctl_defs.h"
-#include "cxgb3_offload.h"
-#include "firmware_exports.h"
+#include "cxgb3/common.h"
+#include "cxgb3/t3_cpl.h"
+#include "cxgb3/t3cdev.h"
+#include "cxgb3/cxgb3_defs.h"
+#include "cxgb3/cxgb3_ctl_defs.h"
+#include "cxgb3/cxgb3_offload.h"
+#include "cxgb3/firmware_exports.h"
 #include "cxgb3i.h"
 
 static unsigned int dbg_level;
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f924b3c..a5795d5 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -20,11 +20,11 @@
 #include <net/dst.h>
 #include <linux/netdevice.h>
 
-#include "t4_msg.h"
-#include "cxgb4.h"
-#include "cxgb4_uld.h"
-#include "t4fw_api.h"
-#include "l2t.h"
+#include "cxgb4/t4_msg.h"
+#include "cxgb4/cxgb4.h"
+#include "cxgb4/cxgb4_uld.h"
+#include "cxgb4/t4fw_api.h"
+#include "cxgb4/l2t.h"
 #include "cxgb4i.h"
 
 static unsigned int dbg_level;
-- 
1.7.10.4
