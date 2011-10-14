From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 17/37] target: simplify target_parse_naa_6h_vendor_specific()
Date: Fri, 14 Oct 2011 00:41:49 +0000
Message-ID: <1318552929-13341-18-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This patch adds a minor simplfication in target_parse_naa_6h_vendor_specific()
to remove direct isxdigit() + ctype.h usage.

(nab: Fix next assignment breakage in for loop)

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index f04d4ef..0d02391 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/ctype.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 
@@ -156,11 +155,12 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 }
 
 static void
-target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_off)
+target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf)
 {
 	unsigned char *p = &dev->se_sub_dev->t10_wwn.unit_serial[0];
-	unsigned char *buf = buf_off;
-	int cnt = 0, next = 1;
+	int cnt;
+	bool next = true;
+
 	/*
 	 * Generate up to 36 bits of VENDOR SPECIFIC IDENTIFIER starting on
 	 * byte 3 bit 3-0 for NAA IEEE Registered Extended DESIGNATOR field
@@ -169,19 +169,18 @@ target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_of
 	 * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
 	 * per device uniqeness.
 	 */
-	while (*p != '\0') {
-		if (cnt >= 13)
-			break;
-		if (!isxdigit(*p)) {
-			p++;
+	for (cnt = 0; *p && cnt < 13; p++) {
+		int val = hex_to_bin(*p);
+
+		if (val < 0)
 			continue;
-		}
-		if (next != 0) {
-			buf[cnt++] |= hex_to_bin(*p++);
-			next = 0;
+
+		if (next) {
+			next = false;
+			buf[cnt++] |= val;
 		} else {
-			buf[cnt] = hex_to_bin(*p++) << 4;
-			next = 1;
+			next = true;
+			buf[cnt] = val << 4;
 		}
 	}
 }
-- 
1.5.6.5
