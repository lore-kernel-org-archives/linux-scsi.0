From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] qla2xxx: don't include <generated/utsrelease.h>
Date: Wed, 21 Jun 2017 13:40:05 +0200
Message-ID: <20170621114005.29800-1-johannes@sipsolutions.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42586 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbdFULkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 07:40:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to use the static UTS_RELEASE string, since
utsname()->release contains the same.

This avoids rebuilding this file for every change of the
release string.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7443e4efa3ae..9195e00261f6 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
@@ -1870,9 +1869,9 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 		char *page)
 {
 	return sprintf(page,
-	    "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on %s/%s on "
-	    UTS_RELEASE"\n", QLA2XXX_VERSION, utsname()->sysname,
-	    utsname()->machine);
+	    "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on %s/%s on %s\n",
+	    QLA2XXX_VERSION, utsname()->sysname,
+	    utsname()->machine, utsname()->release);
 }
 
 CONFIGFS_ATTR_RO(tcm_qla2xxx_wwn_, version);
@@ -1976,9 +1975,9 @@ static int tcm_qla2xxx_register_configfs(void)
 {
 	int ret;
 
-	pr_debug("TCM QLOGIC QLA2XXX fabric module %s on %s/%s on "
-	    UTS_RELEASE"\n", QLA2XXX_VERSION, utsname()->sysname,
-	    utsname()->machine);
+	pr_debug("TCM QLOGIC QLA2XXX fabric module %s on %s/%s on %s\n",
+	    QLA2XXX_VERSION, utsname()->sysname,
+	    utsname()->machine, utsname()->release);
 
 	ret = target_register_template(&tcm_qla2xxx_ops);
 	if (ret)
-- 
2.11.0
