From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 22/37] tcm_fc: remove custom hex_to_bin in ft_parse_wwn
Date: Fri, 14 Oct 2011 00:41:54 +0000
Message-ID: <1318552929-13341-23-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This patch converts ft_parse_wwn() to use hex_to_bin() instead of custom
conversion code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_conf.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index b30eace..3c9d19a 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -31,6 +31,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/configfs.h>
+#include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
@@ -70,10 +71,10 @@ static ssize_t ft_parse_wwn(const char *name, u64 *wwn, int strict)
 {
 	const char *cp;
 	char c;
-	u32 nibble;
 	u32 byte = 0;
 	u32 pos = 0;
 	u32 err;
+	int val;
 
 	*wwn = 0;
 	for (cp = name; cp < &name[FT_NAMELEN - 1]; cp++) {
@@ -94,13 +95,10 @@ static ssize_t ft_parse_wwn(const char *name, u64 *wwn, int strict)
 			return cp - name;
 		}
 		err = 3;
-		if (isdigit(c))
-			nibble = c - '0';
-		else if (isxdigit(c) && (islower(c) || !strict))
-			nibble = tolower(c) - 'a' + 10;
-		else
+		val = hex_to_bin(c);
+		if (val < 0)
 			goto fail;
-		*wwn = (*wwn << 4) | nibble;
+		*wwn = (*wwn << 4) | val;
 	}
 	err = 4;
 fail:
-- 
1.5.6.5
