From: "Alastair D'Silva" <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 7/7] lib/hexdump.c: Optionally retain byte ordering
Date: Tue, 25 Jun 2019 13:17:26 +1000
Message-ID: <20190625031726.12173-8-alastair@au1.ibm.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190625031726.12173-1-alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org
Cc: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jose Abreu <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benson Leung <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>

The behaviour of hexdump groups is to print the data out as if
it was a native-endian number.

This patch tweaks the documentation to make this clear, and also
adds the HEXDUMP_RETAIN_BYTE_ORDER flag to allow groups of
multiple bytes to be printed without affecting the ordering
of the printed bytes.

Signed-off-by: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
---
 include/linux/printk.h |  1 +
 lib/hexdump.c          | 30 ++++++++++++++++----
 lib/test_hexdump.c     | 62 ++++++++++++++++++++++++++++--------------
 3 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1d082291facf..ed1a79aa9695 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -491,6 +491,7 @@ enum {
 #define HEXDUMP_2_GRP_SPACES		BIT(5)
 #define HEXDUMP_4_GRP_SPACES		BIT(6)
 #define HEXDUMP_8_GRP_SPACES		BIT(7)
+#define HEXDUMP_RETAIN_BYTE_ORDER	BIT(8)
 
 extern int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index e09e3cf8e595..29024eccf5da 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -127,7 +127,8 @@ static void separator_parameters(u64 flags, int groupsize, int *sep_chars,
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @rowsize: number of bytes to print per line; must be a multiple of groupsize
- * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
+ * @groupsize: number of bytes to convert to a native endian number and print:
+ * 	       1, 2, 4, 8; default = 1
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  * @flags: A bitwise OR of the following flags:
@@ -138,6 +139,9 @@ static void separator_parameters(u64 flags, int groupsize, int *sep_chars,
  *	HEXDUMP_2_GRP_SPACES:		insert a ' ' after every 2 groups
  *	HEXDUMP_4_GRP_SPACES:		insert a ' ' after every 4 groups
  *	HEXDUMP_8_GRP_SPACES:		insert a ' ' after every 8 groups
+ *	HEXDUMP_RETAIN_BYTE_ORDER:	Retain the byte ordering of groups
+ *					instead of treating each group as a
+ *					native-endian number
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, converting
  * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
@@ -172,6 +176,7 @@ int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
 	int ret;
 	int sep_chars = 0;
 	char sep = 0;
+	bool big_endian = (flags & HEXDUMP_RETAIN_BYTE_ORDER) ? 1 : 0;
 
 	if (!is_power_of_2(groupsize) || groupsize > 8)
 		groupsize = 1;
@@ -203,10 +208,13 @@ int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
 		const u64 *ptr8 = buf;
 
 		for (j = 0; j < ngroups; j++) {
+			u64 val = big_endian ?
+					be64_to_cpu(get_unaligned(ptr8 + j)) :
+					get_unaligned(ptr8 + j);
 			ret = snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%16.16llx",
 				       j ? group_separator(j, flags) : "",
-				       get_unaligned(ptr8 + j));
+				       val);
 			if (ret >= linebuflen - lx)
 				goto overflow1;
 			lx += ret;
@@ -215,10 +223,14 @@ int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
 		const u32 *ptr4 = buf;
 
 		for (j = 0; j < ngroups; j++) {
+			u32 val = big_endian ?
+					be32_to_cpu(get_unaligned(ptr4 + j)) :
+					get_unaligned(ptr4 + j);
+
 			ret = snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%8.8x",
 				       j ? group_separator(j, flags) : "",
-				       get_unaligned(ptr4 + j));
+				       val);
 			if (ret >= linebuflen - lx)
 				goto overflow1;
 			lx += ret;
@@ -227,10 +239,14 @@ int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
 		const u16 *ptr2 = buf;
 
 		for (j = 0; j < ngroups; j++) {
+			u16 val = big_endian ?
+					be16_to_cpu(get_unaligned(ptr2 + j)) :
+					get_unaligned(ptr2 + j);
+
 			ret = snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%4.4x",
 				       j ? group_separator(j, flags) : "",
-				       get_unaligned(ptr2 + j));
+				       val);
 			if (ret >= linebuflen - lx)
 				goto overflow1;
 			lx += ret;
@@ -332,7 +348,8 @@ static void announce_skipped(const char *level, const char *prefix_str,
  * @prefix_type: controls whether prefix of an offset, address, or none
  *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
  * @rowsize: number of bytes to print per line; must be a multiple of groupsize
- * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
+ * @groupsize: number of bytes to convert to a native endian number and print:
+ * 	       1, 2, 4, 8; default = 1
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @ascii: include ASCII after the hex output
@@ -343,6 +360,9 @@ static void announce_skipped(const char *level, const char *prefix_str,
  *	HEXDUMP_2_GRP_LINES:		insert a '|' after every 2 groups
  *	HEXDUMP_4_GRP_LINES:		insert a '|' after every 4 groups
  *	HEXDUMP_8_GRP_LINES:		insert a '|' after every 8 groups
+ *	HEXDUMP_RETAIN_BYTE_ORDER:	Retain the byte ordering of groups
+ *					instead of treating each group as a
+ *					native-endian number
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index ad43218437f1..d2cfcb3e2d2b 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -98,14 +98,15 @@ static unsigned failed_tests __initdata;
 
 static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 					     int groupsize, char *test,
-					     size_t testlen, bool ascii)
+					     size_t testlen, u64 flags)
 {
 	char *p;
 	const char * const *result;
 	size_t l = len;
 	int gs = groupsize, rs = rowsize;
 	unsigned int i;
-	const bool is_be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
+	const bool is_be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) ||
+			(flags & HEXDUMP_RETAIN_BYTE_ORDER);
 
 	if (l > rs)
 		l = rs;
@@ -142,7 +143,7 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 		p--;
 
 	/* ASCII part */
-	if (ascii) {
+	if (flags & HEXDUMP_ASCII) {
 		do {
 			*p++ = ' ';
 		} while (p < test + rs * 2 + rs / gs + 1);
@@ -157,7 +158,7 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 #define TEST_HEXDUMP_BUF_SIZE		(64 * 3 + 2 + 64 + 1)
 
 static void __init test_hexdump(size_t len, int rowsize, int groupsize,
-				bool ascii)
+				u64 flags)
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char real[TEST_HEXDUMP_BUF_SIZE];
@@ -166,12 +167,11 @@ static void __init test_hexdump(size_t len, int rowsize, int groupsize,
 
 	memset(real, FILL_CHAR, sizeof(real));
 	hex_dump_to_buffer_ext(data_b, len, rowsize, groupsize,
-			       real, sizeof(real),
-			       ascii ? HEXDUMP_ASCII : 0);
+			real, sizeof(real), flags);
 
 	memset(test, FILL_CHAR, sizeof(test));
 	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
-				  ascii);
+				  flags);
 
 	if (memcmp(test, real, TEST_HEXDUMP_BUF_SIZE)) {
 		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
@@ -194,7 +194,7 @@ static void __init test_hexdump_set(int rowsize, bool ascii)
 
 static void __init test_hexdump_overflow(size_t buflen, size_t len,
 					 int rowsize, int groupsize,
-					 bool ascii)
+					 u64 flags)
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
@@ -206,8 +206,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 	memset(buf, FILL_CHAR, sizeof(buf));
 
 	rc = hex_dump_to_buffer_ext(data_b, len, rowsize, groupsize,
-				    buf, buflen,
-				    ascii ? HEXDUMP_ASCII : 0);
+				    buf, buflen, flags);
 
 	/*
 	 * Caller must provide the data length multiple of groupsize. The
@@ -224,12 +223,12 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 		  - 1 /* no trailing space */;
 	}
 
-	expected_len = (ascii) ? ascii_len : hex_len;
+	expected_len = (flags & HEXDUMP_ASCII) ? ascii_len : hex_len;
 
 	fill_point = min_t(int, expected_len + 1, buflen);
 	if (buflen) {
 		test_hexdump_prepare_test(len, rowsize, groupsize, test,
-					  sizeof(test), ascii);
+					  sizeof(test), flags);
 		test[fill_point - 1] = '\0';
 	}
 	memset(test + fill_point, FILL_CHAR, sizeof(test) - fill_point);
@@ -239,8 +238,8 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 	buf[sizeof(buf) - 1] = '\0';
 
 	if (!match) {
-		pr_err("rowsize: %u groupsize: %u ascii: %d Len: %zu buflen: %zu strlen: %zu\n",
-			rowsize, groupsize, ascii, len, buflen,
+		pr_err("rowsize: %u groupsize: %u flags: %llx Len: %zu buflen: %zu strlen: %zu\n",
+			rowsize, groupsize, flags, len, buflen,
 			strnlen(buf, sizeof(buf)));
 		pr_err("Result: %d '%-.*s'\n", rc, (int)buflen, buf);
 		pr_err("Expect: %d '%-.*s'\n", expected_len, (int)buflen, test);
@@ -249,7 +248,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 	}
 }
 
-static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
+static void __init test_hexdump_overflow_set(size_t buflen, u64 flags)
 {
 	unsigned int i = 0;
 	int rs = (get_random_int() % 4 + 1) * 16;
@@ -258,7 +257,7 @@ static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
 		int gs = 1 << i;
 		size_t len = get_random_int() % rs + gs;
 
-		test_hexdump_overflow(buflen, rounddown(len, gs), rs, gs, ascii);
+		test_hexdump_overflow(buflen, rounddown(len, gs), rs, gs, flags);
 	} while (i++ < 3);
 }
 
@@ -266,20 +265,43 @@ static int __init test_hexdump_init(void)
 {
 	unsigned int i;
 	int rowsize;
+	u64 flags;
 
+	flags = 0;
 	rowsize = (get_random_int() % 4 + 1) * 16;
 	for (i = 0; i < 16; i++)
-		test_hexdump_set(rowsize, false);
+		test_hexdump_set(rowsize, flags);
 
+	flags = HEXDUMP_ASCII;
 	rowsize = (get_random_int() % 4 + 1) * 16;
 	for (i = 0; i < 16; i++)
-		test_hexdump_set(rowsize, true);
+		test_hexdump_set(rowsize, flags);
 
+	flags = HEXDUMP_RETAIN_BYTE_ORDER;
+	rowsize = (get_random_int() % 2 + 1) * 16;
+	for (i = 0; i < 16; i++)
+		test_hexdump_set(rowsize, flags);
+
+	flags = HEXDUMP_ASCII | HEXDUMP_RETAIN_BYTE_ORDER;
+	rowsize = (get_random_int() % 2 + 1) * 16;
+	for (i = 0; i < 16; i++)
+		test_hexdump_set(rowsize, flags);
+
+	flags = 0;
+	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
+		test_hexdump_overflow_set(i, flags);
+
+	flags = HEXDUMP_ASCII;
+	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
+		test_hexdump_overflow_set(i, flags);
+
+	flags = HEXDUMP_RETAIN_BYTE_ORDER;
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
-		test_hexdump_overflow_set(i, false);
+		test_hexdump_overflow_set(i, flags);
 
+	flags = HEXDUMP_ASCII | HEXDUMP_RETAIN_BYTE_ORDER;
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
-		test_hexdump_overflow_set(i, true);
+		test_hexdump_overflow_set(i, flags);
 
 	if (failed_tests == 0)
 		pr_info("all %u tests passed\n", total_tests);
-- 
2.21.0
