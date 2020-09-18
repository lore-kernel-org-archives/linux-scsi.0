Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97432C43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5481E235FA
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgIRDsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:48:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13251 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbgIRDsR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 23:48:17 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 944CB9C8843B0671D0EC;
        Fri, 18 Sep 2020 11:48:15 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 11:48:06 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <achim_leubner@adaptec.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <yanaijie@huawei.com>,
        <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH v2] scsi: gdth: make option_setup() static
Date:   Fri, 18 Sep 2020 11:49:20 +0800
Message-ID: <20200918034920.3199926-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

And move the two functions around the '__setup' macro which uses them to
avoid a 'unused-function' warning.

This addresses the following sparse warning:

drivers/scsi/gdth.c:3229:12: warning: symbol 'option_setup' was not
declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 v2: move option_setup() and internal_setup() down to where it is used.

 drivers/scsi/gdth.c | 151 ++++++++++++++++++++++----------------------
 1 file changed, 76 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index dc0e17729acf..5d801388680b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3168,81 +3168,6 @@ static inline void gdth_timer_init(void)
 }
 #endif
 
-static void __init internal_setup(char *str,int *ints)
-{
-    int i;
-    char *cur_str, *argv;
-
-    TRACE2(("internal_setup() str %s ints[0] %d\n", 
-            str ? str:"NULL", ints ? ints[0]:0));
-
-    /* analyse string */
-    argv = str;
-    while (argv && (cur_str = strchr(argv, ':'))) {
-        int val = 0, c = *++cur_str;
-        
-        if (c == 'n' || c == 'N')
-            val = 0;
-        else if (c == 'y' || c == 'Y')
-            val = 1;
-        else
-            val = (int)simple_strtoul(cur_str, NULL, 0);
-
-        if (!strncmp(argv, "disable:", 8))
-            disable = val;
-        else if (!strncmp(argv, "reserve_mode:", 13))
-            reserve_mode = val;
-        else if (!strncmp(argv, "reverse_scan:", 13))
-            reverse_scan = val;
-        else if (!strncmp(argv, "hdr_channel:", 12))
-            hdr_channel = val;
-        else if (!strncmp(argv, "max_ids:", 8))
-            max_ids = val;
-        else if (!strncmp(argv, "rescan:", 7))
-            rescan = val;
-        else if (!strncmp(argv, "shared_access:", 14))
-            shared_access = val;
-        else if (!strncmp(argv, "reserve_list:", 13)) {
-            reserve_list[0] = val;
-            for (i = 1; i < MAX_RES_ARGS; i++) {
-                cur_str = strchr(cur_str, ',');
-                if (!cur_str)
-                    break;
-                if (!isdigit((int)*++cur_str)) {
-                    --cur_str;          
-                    break;
-                }
-                reserve_list[i] = 
-                    (int)simple_strtoul(cur_str, NULL, 0);
-            }
-            if (!cur_str)
-                break;
-            argv = ++cur_str;
-            continue;
-        }
-
-        if ((argv = strchr(argv, ',')))
-            ++argv;
-    }
-}
-
-int __init option_setup(char *str)
-{
-    int ints[MAXHA];
-    char *cur = str;
-    int i = 1;
-
-    TRACE2(("option_setup() str %s\n", str ? str:"NULL")); 
-
-    while (cur && isdigit(*cur) && i < MAXHA) {
-        ints[i++] = simple_strtoul(cur, NULL, 0);
-        if ((cur = strchr(cur, ',')) != NULL) cur++;
-    }
-
-    ints[0] = i - 1;
-    internal_setup(cur, ints);
-    return 1;
-}
 
 static const char *gdth_ctr_name(gdth_ha_str *ha)
 {
@@ -4317,5 +4242,81 @@ module_init(gdth_init);
 module_exit(gdth_exit);
 
 #ifndef MODULE
+static void __init internal_setup(char *str,int *ints)
+{
+    int i;
+    char *cur_str, *argv;
+
+    TRACE2(("internal_setup() str %s ints[0] %d\n",
+            str ? str:"NULL", ints ? ints[0]:0));
+
+    /* analyse string */
+    argv = str;
+    while (argv && (cur_str = strchr(argv, ':'))) {
+        int val = 0, c = *++cur_str;
+
+        if (c == 'n' || c == 'N')
+            val = 0;
+        else if (c == 'y' || c == 'Y')
+            val = 1;
+        else
+            val = (int)simple_strtoul(cur_str, NULL, 0);
+
+        if (!strncmp(argv, "disable:", 8))
+            disable = val;
+        else if (!strncmp(argv, "reserve_mode:", 13))
+            reserve_mode = val;
+        else if (!strncmp(argv, "reverse_scan:", 13))
+            reverse_scan = val;
+        else if (!strncmp(argv, "hdr_channel:", 12))
+            hdr_channel = val;
+        else if (!strncmp(argv, "max_ids:", 8))
+            max_ids = val;
+        else if (!strncmp(argv, "rescan:", 7))
+            rescan = val;
+        else if (!strncmp(argv, "shared_access:", 14))
+            shared_access = val;
+        else if (!strncmp(argv, "reserve_list:", 13)) {
+            reserve_list[0] = val;
+            for (i = 1; i < MAX_RES_ARGS; i++) {
+                cur_str = strchr(cur_str, ',');
+                if (!cur_str)
+                    break;
+                if (!isdigit((int)*++cur_str)) {
+                    --cur_str;
+                    break;
+                }
+                reserve_list[i] =
+                    (int)simple_strtoul(cur_str, NULL, 0);
+            }
+            if (!cur_str)
+                break;
+            argv = ++cur_str;
+            continue;
+        }
+
+        if ((argv = strchr(argv, ',')))
+            ++argv;
+    }
+}
+
+static int __init option_setup(char *str)
+{
+    int ints[MAXHA];
+    char *cur = str;
+    int i = 1;
+
+    TRACE2(("option_setup() str %s\n", str ? str:"NULL"));
+
+    while (cur && isdigit(*cur) && i < MAXHA) {
+        ints[i++] = simple_strtoul(cur, NULL, 0);
+        if ((cur = strchr(cur, ',')) != NULL) cur++;
+    }
+
+    ints[0] = i - 1;
+    internal_setup(cur, ints);
+    return 1;
+}
+
 __setup("gdth=", option_setup);
 #endif
-- 
2.25.4

