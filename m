From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 21/37] iscsi-target: use native hex2bin for chap_string_to_hex
Date: Fri, 14 Oct 2011 00:41:53 +0000
Message-ID: <1318552929-13341-22-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33452 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab1JNAow (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:44:52 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This patch converts chap_string_to_hex() to use hex2bin() instead of
the internal chap_asciihex_to_binaryhex().

(nab: Fix up minor compile breakage)

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_auth.c |   34 ++---------------------------
 1 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 11fd743..907d663 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -18,6 +18,7 @@
  * GNU General Public License for more details.
  ******************************************************************************/
 
+#include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -27,40 +28,11 @@
 #include "iscsi_target_nego.h"
 #include "iscsi_target_auth.h"
 
-static unsigned char chap_asciihex_to_binaryhex(unsigned char val[2])
-{
-	unsigned char result = 0;
-	/*
-	 * MSB
-	 */
-	if ((val[0] >= 'a') && (val[0] <= 'f'))
-		result = ((val[0] - 'a' + 10) & 0xf) << 4;
-	else
-		if ((val[0] >= 'A') && (val[0] <= 'F'))
-			result = ((val[0] - 'A' + 10) & 0xf) << 4;
-		else /* digit */
-			result = ((val[0] - '0') & 0xf) << 4;
-	/*
-	 * LSB
-	 */
-	if ((val[1] >= 'a') && (val[1] <= 'f'))
-		result |= ((val[1] - 'a' + 10) & 0xf);
-	else
-		if ((val[1] >= 'A') && (val[1] <= 'F'))
-			result |= ((val[1] - 'A' + 10) & 0xf);
-		else /* digit */
-			result |= ((val[1] - '0') & 0xf);
-
-	return result;
-}
-
 static int chap_string_to_hex(unsigned char *dst, unsigned char *src, int len)
 {
-	int i, j = 0;
+	int j = DIV_ROUND_UP(len, 2);
 
-	for (i = 0; i < len; i += 2) {
-		dst[j++] = (unsigned char) chap_asciihex_to_binaryhex(&src[i]);
-	}
+	hex2bin(dst, src, len);
 
 	dst[j] = '\0';
 	return j;
-- 
1.5.6.5

