From: "Alastair D'Silva" <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler bytes
Date: Wed, 10 Apr 2019 13:17:18 +1000
Message-ID: <20190410031720.11067-3-alastair@au1.ibm.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190410031720.11067-1-alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org
Cc: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jose Abreu <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benson Leung <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Petr
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>

Some buffers may only be partially filled with useful data, while the rest
is padded (typically with 0x00 or 0xff).

This patch introduces flags which allow lines of padding bytes to be
suppressed, making the output easier to interpret: HEXDUMP_SUPPRESS_0X00,
HEXDUMP_SUPPRESS_0XFF

The first and last lines are not suppressed by default, so the function
always outputs something. This behaviour can be further controlled with
the HEXDUMP_SUPPRESS_FIRST & HEXDUMP_SUPPRESS_LAST flags.

An inline wrapper function is provided for backwards compatibility with
existing code, which maintains the original behaviour.

Signed-off-by: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
---
 include/linux/printk.h | 38 ++++++++++++++++++----
 lib/hexdump.c          | 72 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 89 insertions(+), 21 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index d7c77ed1a4cb..c014e5573665 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -479,13 +479,26 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
+
+#define HEXDUMP_ASCII		(1 << 0)
+#define HEXDUMP_SUPPRESS_0X00	(1 << 1)
+#define HEXDUMP_SUPPRESS_0XFF	(1 << 2)
+#define HEXDUMP_SUPPRESS_FIRST	(1 << 3)
+#define HEXDUMP_SUPPRESS_LAST	(1 << 4)
+
+#define HEXDUMP_QUIET		(HEXDUMP_SUPPRESS_0X00 | \
+				HEXDUMP_SUPPRESS_0XFF | \
+				HEXDUMP_SUPPRESS_FIRST | \
+				HEXDUMP_SUPPRESS_LAST)
+
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
 			      bool ascii);
+
 #ifdef CONFIG_PRINTK
-extern void print_hex_dump(const char *level, const char *prefix_str,
-			   int prefix_type, int rowsize, int groupsize,
-			   const void *buf, size_t len, bool ascii);
+extern void print_hex_dump_ext(const char *level, const char *prefix_str,
+			       int prefix_type, int rowsize, int groupsize,
+			       const void *buf, size_t len, u64 flags);
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
 	dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
@@ -494,18 +507,29 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 				 const void *buf, size_t len);
 #endif /* defined(CONFIG_DYNAMIC_DEBUG) */
 #else
-static inline void print_hex_dump(const char *level, const char *prefix_str,
-				  int prefix_type, int rowsize, int groupsize,
-				  const void *buf, size_t len, bool ascii)
+static inline void print_hex_dump_ext(const char *level, const char *prefix_str,
+				      int prefix_type, int rowsize,
+				      int groupsize, const void *buf,
+				      size_t len, u64 flags)
 {
 }
 static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 					const void *buf, size_t len)
 {
 }
-
 #endif
 
+static __always_inline void print_hex_dump(const char *level,
+					   const char *prefix_str,
+					   int prefix_type, int rowsize,
+					   int groupsize, const void *buf,
+					   size_t len, bool ascii)
+{
+	print_hex_dump_ext(level, prefix_str, prefix_type, rowsize, groupsize,
+			buf, len, ascii ? HEXDUMP_ASCII : 0);
+}
+
+
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 			     groupsize, buf, len, ascii)	\
diff --git a/lib/hexdump.c b/lib/hexdump.c
index b8a164814744..2f3bafb55a44 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -209,8 +209,21 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
 #ifdef CONFIG_PRINTK
+
+static bool buf_is_all(const u8 *buf, size_t len, u8 val)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (buf[i] != val)
+			return false;
+	}
+
+	return true;
+}
+
 /**
- * print_hex_dump - print a text hex dump to syslog for a binary blob of data
+ * print_hex_dump_ext: dump a binary blob of data to syslog in hexadecimal
  * @level: kernel log level (e.g. KERN_DEBUG)
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
@@ -221,42 +234,73 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @ascii: include ASCII after the hex output
+ * @flags: A bitwise OR of the following flags:
+ *	HEXDUMP_ASCII:		include ASCII after the hex output
+ *	HEXDUMP_SUPPRESS_0X00:	suppress lines that are all 0x00
+ *				(other than first or last)
+ *	HEXDUMP_SUPPRESS_0XFF:	suppress lines that are all 0xff
+ *				(other than first or last)
+ *	HEXDUMP_SUPPRESS_FIRST:	allows the first line to be suppressed
+ *	HEXDUMP_SUPPRESS_LAST:	allows the last line to be suppressed
+ *				If the first and last line may be suppressed,
+ *				an empty buffer will not produce any output
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
  * leading prefix.
  *
- * print_hex_dump() works on one "line" of output at a time, i.e.,
+ * print_hex_dump_ext() works on one "line" of output at a time, i.e.,
  * 16, 32 or 64 bytes of input data converted to hex + ASCII output.
- * print_hex_dump() iterates over the entire input @buf, breaking it into
+ * print_hex_dump_ext() iterates over the entire input @buf, breaking it into
  * "line size" chunks to format and print.
  *
  * E.g.:
- *   print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
- *		    16, 1, frame->data, frame->len, true);
+ *   print_hex_dump_ext(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
+ *		    16, 1, frame->data, frame->len, HEXDUMP_ASCII);
  *
  * Example output using %DUMP_PREFIX_OFFSET and 1-byte mode:
  * 0009ab42: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
  * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
  * ffffffff88089af0: 73727170 77767574 7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
  */
-void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
-		    int rowsize, int groupsize,
-		    const void *buf, size_t len, bool ascii)
+void print_hex_dump_ext(const char *level, const char *prefix_str,
+			int prefix_type, int rowsize, int groupsize,
+			const void *buf, size_t len, u64 flags)
 {
 	const u8 *ptr = buf;
-	int i, linelen, remaining = len;
+	int i, remaining = len;
 	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
+	bool first_line = true;
 
 	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
 		rowsize = 16;
 
 	for (i = 0; i < len; i += rowsize) {
-		linelen = min(remaining, rowsize);
+		bool skip = false;
+		int linelen = min(remaining, rowsize);
+
 		remaining -= rowsize;
 
+		if (flags & HEXDUMP_SUPPRESS_0X00)
+			skip = buf_is_all(ptr + i, linelen, 0x00);
+
+		if (!skip && (flags & HEXDUMP_SUPPRESS_0XFF))
+			skip = buf_is_all(ptr + i, linelen, 0xff);
+
+		if (first_line && !(flags & HEXDUMP_SUPPRESS_FIRST))
+			skip = false;
+
+		if (remaining <= 0 && !(flags & HEXDUMP_SUPPRESS_LAST))
+			skip = false;
+
+		if (skip)
+			continue;
+
+		first_line = false;
+
 		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				   linebuf, sizeof(linebuf), ascii);
+				   linebuf, sizeof(linebuf),
+				   flags & HEXDUMP_ASCII);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
@@ -272,7 +316,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 		}
 	}
 }
-EXPORT_SYMBOL(print_hex_dump);
+EXPORT_SYMBOL(print_hex_dump_ext);
 
 #if !defined(CONFIG_DYNAMIC_DEBUG)
 /**
@@ -290,8 +334,8 @@ EXPORT_SYMBOL(print_hex_dump);
 void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			  const void *buf, size_t len)
 {
-	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
-		       buf, len, true);
+	print_hex_dump_ext(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
+		       buf, len, HEXDUMP_ASCII);
 }
 EXPORT_SYMBOL(print_hex_dump_bytes);
 #endif /* !defined(CONFIG_DYNAMIC_DEBUG) */
-- 
2.20.1
