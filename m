From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] string_get_size(): don't hang on zero; no decimals on exact
Date: Tue, 14 Oct 2008 11:34:21 -0700
Message-ID: <1224009261-31247-2-git-send-email-hpa@zytor.com>
References: <48F4DF3E.2050903@zytor.com>
 <1224009261-31247-1-git-send-email-hpa@zytor.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:37617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYJNSeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 14:34:24 -0400
In-Reply-To: <1224009261-31247-1-git-send-email-hpa@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hpa@zytor.com

We would hang forever when passing a zero to string_get_size().
Furthermore, string_get_size() would produce decimals on a value small
enough to be exact.  Finally, a few formatting issues are inconsistent
with standard SI style guidelines.

- If the value is less than the divisor, skip the entire rounding
  step.  This prints out all small values including zero as integers,
  without decimals.
- Add a space between the value and the symbol for the unit,
  consistent with standard SI practice.
- Lower case k in kB since we are talking about powers of 10.
- Finally, change "int" to "unsigned int" in one place to shut up a
  gcc warning when compiling the code out-of-kernel for testing.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 lib/string_helpers.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 8347925..ab431d4 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -23,7 +23,7 @@
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	const char *units_10[] = { "B", "KB", "MB", "GB", "TB", "PB",
+	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
 				   "EB", "ZB", "YB", NULL};
 	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
 				 "EiB", "ZiB", "YiB", NULL };
@@ -31,7 +31,7 @@ int string_get_size(u64 size, const enum string_size_units units,
 		[STRING_UNITS_10] =  units_10,
 		[STRING_UNITS_2] = units_2,
 	};
-	const int divisor[] = {
+	const unsigned int divisor[] = {
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
@@ -40,23 +40,27 @@ int string_get_size(u64 size, const enum string_size_units units,
 	char tmp[8];
 
 	tmp[0] = '\0';
+	i = 0;
+	if (size >= divisor[units]) {
+		while (size >= divisor[units] && units_str[units][i]) {
+			remainder = do_div(size, divisor[units]);
+			i++;
+		}
 
-	for (i = 0; size > divisor[units] && units_str[units][i]; i++)
-		remainder = do_div(size, divisor[units]);
+		sf_cap = size;
+		for (j = 0; sf_cap*10 < 1000; j++)
+			sf_cap *= 10;
 
-	sf_cap = size;
-	for (j = 0; sf_cap*10 < 1000; j++)
-		sf_cap *= 10;
-
-	if (j) {
-		remainder *= 1000;
-		do_div(remainder, divisor[units]);
-		snprintf(tmp, sizeof(tmp), ".%03lld",
-			 (unsigned long long)remainder);
-		tmp[j+1] = '\0';
+		if (j) {
+			remainder *= 1000;
+			do_div(remainder, divisor[units]);
+			snprintf(tmp, sizeof(tmp), ".%03lld",
+				 (unsigned long long)remainder);
+			tmp[j+1] = '\0';
+		}
 	}
 
-	snprintf(buf, len, "%lld%s%s", (unsigned long long)size,
+	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
 		 tmp, units_str[units][i]);
 
 	return 0;
-- 
1.6.0.2

