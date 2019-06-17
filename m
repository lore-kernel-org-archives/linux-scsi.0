From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH v3 3/7] lib/hexdump.c: Optionally suppress lines of repeated
 bytes
Date: Mon, 17 Jun 2019 12:04:26 +1000
Message-ID: <20190617020430.8708-4-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190617020430.8708-1-alastair@au1.ibm.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: alastair@d-silva.org
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Benson Leung <bleung@chromium.org>, Kalle Valo <kvalo@codeaurora.org>, Karsten Keil <isdn@linux-pingi.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxf>
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

Some buffers may only be partially filled with useful data, while the rest
is padded (typically with 0x00 or 0xff).

This patch introduces a flag to allow the supression of lines of repeated
bytes, which are replaced with '** Skipped %u bytes of value 0x%x **'

An inline wrapper function is provided for backwards compatibility with
existing code, which maintains the original behaviour.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 include/linux/printk.h | 25 +++++++++---
 lib/hexdump.c          | 91 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 99 insertions(+), 17 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index cefd374c47b1..d7754799cfe0 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -481,13 +481,18 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
+
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
 			      bool ascii);
+
+#define HEXDUMP_ASCII			BIT(0)
+#define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
+
 #ifdef CONFIG_PRINTK
-extern void print_hex_dump(const char *level, const char *prefix_str,
+extern void print_hex_dump_ext(const char *level, const char *prefix_str,
 			   int prefix_type, int rowsize, int groupsize,
-			   const void *buf, size_t len, bool ascii);
+			   const void *buf, size_t len, u32 flags);
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
 	dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
@@ -496,18 +501,28 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 				 const void *buf, size_t len);
 #endif /* defined(CONFIG_DYNAMIC_DEBUG) */
 #else
-static inline void print_hex_dump(const char *level, const char *prefix_str,
+static inline void print_hex_dump_ext(const char *level, const char *prefix_str,
 				  int prefix_type, int rowsize, int groupsize,
-				  const void *buf, size_t len, bool ascii)
+				  const void *buf, size_t len, u32 flags)
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
index 3943507bc0e9..b781f888884e 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -212,8 +212,44 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
 #ifdef CONFIG_PRINTK
+
+/**
+ * buf_is_all - Check if a buffer contains only a single byte value
+ * @buf: pointer to the buffer
+ * @len: the size of the buffer in bytes
+ * @val: outputs the value if if the bytes are identical
+ */
+static bool buf_is_all(const u8 *buf, size_t len, u8 *val_out)
+{
+	size_t i;
+	u8 val;
+
+	if (len <= 1)
+		return false;
+
+	val = buf[0];
+
+	for (i = 1; i < len; i++) {
+		if (buf[i] != val)
+			return false;
+	}
+
+	*val_out = val;
+	return true;
+}
+
+static void announce_skipped(const char *level, const char *prefix_str,
+				   u8 val, size_t count)
+{
+	if (count == 0)
+		return;
+
+	printk("%s%s ** Skipped %lu bytes of value 0x%x **\n",
+	       level, prefix_str, count, val);
+}
+
 /**
- * print_hex_dump - print a text hex dump to syslog for a binary blob of data
+ * print_hex_dump_ext - dump a binary blob of data to syslog in hexadecimal
  * @level: kernel log level (e.g. KERN_DEBUG)
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
@@ -224,6 +260,10 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @ascii: include ASCII after the hex output
+ * @flags: A bitwise OR of the following flags:
+ *	HEXDUMP_ASCII:			include ASCII after the hex output
+ *	HEXDUMP_SUPPRESS_REPEATED:	suppress repeated lines of identical
+ *					bytes
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
@@ -234,22 +274,25 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * (optionally) ASCII output.
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
+			const void *buf, size_t len, u32 flags)
 {
 	const u8 *ptr = buf;
-	int i, linelen, remaining = len;
+	int i, remaining = len;
 	unsigned char *linebuf;
 	unsigned int linebuf_len;
+	u8 skipped_val = 0;
+	size_t skipped = 0;
+
 
 	if (rowsize % groupsize)
 		rowsize -= rowsize % groupsize;
@@ -266,11 +309,35 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 	}
 
 	for (i = 0; i < len; i += rowsize) {
-		linelen = min(remaining, rowsize);
+		int linelen = min(remaining, rowsize);
 		remaining -= rowsize;
 
+		if (flags & HEXDUMP_SUPPRESS_REPEATED) {
+			u8 new_val;
+
+			if (buf_is_all(ptr + i, linelen, &new_val)) {
+				if (new_val == skipped_val) {
+					skipped += linelen;
+					continue;
+				} else {
+					announce_skipped(level, prefix_str,
+							 skipped_val, skipped);
+					skipped_val = new_val;
+					skipped = linelen;
+					continue;
+				}
+			}
+		}
+
+		if (skipped) {
+			announce_skipped(level, prefix_str, skipped_val,
+					 skipped);
+			skipped = 0;
+		}
+
 		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				   linebuf, linebuf_len, ascii);
+				   linebuf, linebuf_len,
+				   flags & HEXDUMP_ASCII);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
@@ -288,7 +355,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 
 	kfree(linebuf);
 }
-EXPORT_SYMBOL(print_hex_dump);
+EXPORT_SYMBOL(print_hex_dump_ext);
 
 #if !defined(CONFIG_DYNAMIC_DEBUG)
 /**
@@ -306,8 +373,8 @@ EXPORT_SYMBOL(print_hex_dump);
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
2.21.0
