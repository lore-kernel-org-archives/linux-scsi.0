From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be separated by lines '|'
Date: Wed, 10 Apr 2019 13:17:20 +1000
Message-ID: <20190410031720.11067-5-alastair@au1.ibm.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410031720.11067-1-alastair@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: alastair@d-silva.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Petr
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

With the wider display format, it can become hard to identify how many
bytes into the line you are looking at.

The patch adds new flags to hex_dump_to_buffer() and print_hex_dump() to
print vertical lines to separate every N groups of bytes.

eg.
buf:00000000: 454d414e 43415053|4e495f45 00584544  NAMESPAC|E_INDEX.
buf:00000010: 00000000 00000002|00000000 00000000  ........|........

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 include/linux/printk.h |  3 +++
 lib/hexdump.c          | 50 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 82975853c400..d9e407e59059 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -485,6 +485,9 @@ enum {
 #define HEXDUMP_SUPPRESS_0XFF	(1 << 2)
 #define HEXDUMP_SUPPRESS_FIRST	(1 << 3)
 #define HEXDUMP_SUPPRESS_LAST	(1 << 4)
+#define HEXDUMP_2_GRP_LINES	(1 << 5)
+#define HEXDUMP_4_GRP_LINES	(1 << 6)
+#define HEXDUMP_8_GRP_LINES	(1 << 7)
 
 #define HEXDUMP_QUIET		(HEXDUMP_SUPPRESS_0X00 | \
 				HEXDUMP_SUPPRESS_0XFF | \
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 79db784577e7..d42f34b93b2c 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -76,6 +76,20 @@ char *bin2hex(char *dst, const void *src, size_t count)
 }
 EXPORT_SYMBOL(bin2hex);
 
+static const char *group_separator(int group, u64 flags)
+{
+	if ((flags & HEXDUMP_8_GRP_LINES) && ((group - 1) % 8))
+		return "|";
+
+	if ((flags & HEXDUMP_4_GRP_LINES) && ((group - 1) % 4))
+		return "|";
+
+	if ((flags & HEXDUMP_2_GRP_LINES) && ((group - 1) % 2))
+		return "|";
+
+	return " ";
+}
+
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
@@ -86,6 +100,9 @@ EXPORT_SYMBOL(bin2hex);
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  * @flags: A bitwise OR of the following flags:
  *	HEXDUMP_ASCII:		include ASCII after the hex output
+ *	HEXDUMP_2_GRP_LINES:	insert a '|' after every 2 groups
+ *	HEXDUMP_4_GRP_LINES:	insert a '|' after every 4 groups
+ *	HEXDUMP_8_GRP_LINES:	insert a '|' after every 8 groups
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
  * 16, 32 or 64 bytes of input data converted to hex + ASCII output.
@@ -116,6 +133,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 	int j, lx = 0;
 	int ascii_column;
 	int ret;
+	int line_chars = 0;
 
 	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
 		rowsize = 16;
@@ -141,7 +159,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 
 		for (j = 0; j < ngroups; j++) {
 			ret = snprintf(linebuf + lx, linebuflen - lx,
-				       "%s%16.16llx", j ? " " : "",
+				       "%s%16.16llx",
+				       j ? group_separator(j, flags) : "",
 				       get_unaligned(ptr8 + j));
 			if (ret >= linebuflen - lx)
 				goto overflow1;
@@ -152,7 +171,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 
 		for (j = 0; j < ngroups; j++) {
 			ret = snprintf(linebuf + lx, linebuflen - lx,
-				       "%s%8.8x", j ? " " : "",
+				       "%s%8.8x",
+				       j ? group_separator(j, flags) : "",
 				       get_unaligned(ptr4 + j));
 			if (ret >= linebuflen - lx)
 				goto overflow1;
@@ -163,7 +183,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 
 		for (j = 0; j < ngroups; j++) {
 			ret = snprintf(linebuf + lx, linebuflen - lx,
-				       "%s%4.4x", j ? " " : "",
+				       "%s%4.4x",
+				       j ? group_separator(j, flags) : "",
 				       get_unaligned(ptr2 + j));
 			if (ret >= linebuflen - lx)
 				goto overflow1;
@@ -193,11 +214,26 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 			goto overflow2;
 		linebuf[lx++] = ' ';
 	}
+
+	if (flags & HEXDUMP_2_GRP_LINES)
+		line_chars = groupsize * 2;
+	if (flags & HEXDUMP_4_GRP_LINES)
+		line_chars = groupsize * 4;
+	if (flags & HEXDUMP_8_GRP_LINES)
+		line_chars = groupsize * 8;
+
 	for (j = 0; j < len; j++) {
 		if (linebuflen < lx + 2)
 			goto overflow2;
 		ch = ptr[j];
 		linebuf[lx++] = (isascii(ch) && isprint(ch)) ? ch : '.';
+
+		if (line_chars && ((j + 1) < len) &&
+				((j + 1) % line_chars == 0)) {
+			if (linebuflen < lx + 2)
+				goto overflow2;
+			linebuf[lx++] = '|';
+		}
 	}
 nil:
 	linebuf[lx] = '\0';
@@ -205,7 +241,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 overflow2:
 	linebuf[lx++] = '\0';
 overflow1:
-	return (flags & HEXDUMP_ASCII) ? ascii_column + len :
+	return (flags & HEXDUMP_ASCII) ? ascii_column + len +
+					(len - 1) / line_chars :
 					 (groupsize * 2 + 1) * ngroups - 1;
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
@@ -246,6 +283,9 @@ static bool buf_is_all(const u8 *buf, size_t len, u8 val)
  *	HEXDUMP_SUPPRESS_LAST:	allows the last line to be suppressed
  *				If the first and last line may be suppressed,
  *				an empty buffer will not produce any output
+ *	HEXDUMP_2_GRP_LINES:	insert a '|' after every 2 groups
+ *	HEXDUMP_4_GRP_LINES:	insert a '|' after every 4 groups
+ *	HEXDUMP_8_GRP_LINES:	insert a '|' after every 8 groups
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
@@ -271,7 +311,7 @@ void print_hex_dump_ext(const char *level, const char *prefix_str,
 {
 	const u8 *ptr = buf;
 	int i, remaining = len;
-	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
+	unsigned char linebuf[64 * 3 + 2 + 64 + 31 + 1];
 	bool first_line = true;
 
 	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
-- 
2.20.1
