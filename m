From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH v3 6/7] lib/hexdump.c: Allow multiple groups to be separated by spaces
Date: Mon, 17 Jun 2019 12:04:29 +1000
Message-ID: <20190617020430.8708-7-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190617020430.8708-1-alastair@au1.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: alastair@d-silva.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

Similar to the previous patch, this patch separates groups by 2 spaces for
the hex fields, and 1 space for the ASCII field.

eg.
buf:00000000: 454d414e 43415053  4e495f45 00584544  NAMESPAC E_INDEX.
buf:00000010: 00000000 00000002  00000000 00000000  ........ ........

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 include/linux/printk.h |  3 ++
 lib/hexdump.c          | 65 +++++++++++++++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index c6b748f66a82..04416e788802 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -487,6 +487,9 @@ enum {
 #define HEXDUMP_2_GRP_LINES		BIT(2)
 #define HEXDUMP_4_GRP_LINES		BIT(3)
 #define HEXDUMP_8_GRP_LINES		BIT(4)
+#define HEXDUMP_2_GRP_SPACES		BIT(5)
+#define HEXDUMP_4_GRP_SPACES		BIT(6)
+#define HEXDUMP_8_GRP_SPACES		BIT(7)
 
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 4da7d24826fb..dc85ef0dbb0a 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -91,9 +91,37 @@ static const char *group_separator(int group, u64 flags)
 	if ((flags & HEXDUMP_2_GRP_LINES) && !((group) % 2))
 		return "|";
 
+	if ((flags & HEXDUMP_8_GRP_SPACES) && !((group) % 8))
+		return "  ";
+
+	if ((flags & HEXDUMP_4_GRP_SPACES) && !((group) % 4))
+		return "  ";
+
+	if ((flags & HEXDUMP_2_GRP_SPACES) && !((group) % 2))
+		return "  ";
+
 	return " ";
 }
 
+static void separator_parameters(u64 flags, int groupsize, int *sep_chars,
+				 char *sep)
+{
+	if (flags & (HEXDUMP_2_GRP_LINES | HEXDUMP_2_GRP_SPACES))
+		*sep_chars = groupsize * 2;
+	if (flags & (HEXDUMP_4_GRP_LINES | HEXDUMP_4_GRP_SPACES))
+		*sep_chars = groupsize * 4;
+	if (flags & (HEXDUMP_8_GRP_LINES | HEXDUMP_8_GRP_SPACES))
+		*sep_chars = groupsize * 8;
+
+	if (flags & (HEXDUMP_2_GRP_LINES | HEXDUMP_4_GRP_LINES |
+					   HEXDUMP_8_GRP_LINES))
+		*sep = '|';
+
+	if (flags & (HEXDUMP_2_GRP_SPACES | HEXDUMP_4_GRP_SPACES |
+					   HEXDUMP_8_GRP_SPACES))
+		*sep = ' ';
+}
+
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
@@ -107,6 +135,9 @@ static const char *group_separator(int group, u64 flags)
  *	HEXDUMP_2_GRP_LINES:		insert a '|' after every 2 groups
  *	HEXDUMP_4_GRP_LINES:		insert a '|' after every 4 groups
  *	HEXDUMP_8_GRP_LINES:		insert a '|' after every 8 groups
+ *	HEXDUMP_2_GRP_SPACES:		insert a ' ' after every 2 groups
+ *	HEXDUMP_4_GRP_SPACES:		insert a ' ' after every 4 groups
+ *	HEXDUMP_8_GRP_SPACES:		insert a ' ' after every 8 groups
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, converting
  * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
@@ -138,7 +169,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 	int j, lx = 0;
 	int ascii_column;
 	int ret;
-	int line_chars = 0;
+	int sep_chars = 0;
+	char sep = 0;
 
 	if (!is_power_of_2(groupsize) || groupsize > 8)
 		groupsize = 1;
@@ -152,8 +184,14 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		len = rowsize;
 
 	ngroups = len / groupsize;
+
 	ascii_column = rowsize * 2 + rowsize / groupsize + 1;
 
+	// space separators use 2 spaces in the hex output
+	separator_parameters(flags, groupsize, &sep_chars, &sep);
+	if (sep == ' ')
+		ascii_column += rowsize / sep_chars;
+
 	if (!linebuflen)
 		goto overflow1;
 
@@ -221,24 +259,17 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		linebuf[lx++] = ' ';
 	}
 
-	if (flags & HEXDUMP_2_GRP_LINES)
-		line_chars = groupsize * 2;
-	if (flags & HEXDUMP_4_GRP_LINES)
-		line_chars = groupsize * 4;
-	if (flags & HEXDUMP_8_GRP_LINES)
-		line_chars = groupsize * 8;
-
 	for (j = 0; j < len; j++) {
 		if (linebuflen < lx + 2)
 			goto overflow2;
 		ch = ptr[j];
 		linebuf[lx++] = (isascii(ch) && isprint(ch)) ? ch : '.';
 
-		if (line_chars && ((j + 1) < len) &&
-				((j + 1) % line_chars == 0)) {
+		if (sep_chars && ((j + 1) < len) &&
+				((j + 1) % sep_chars == 0)) {
 			if (linebuflen < lx + 2)
 				goto overflow2;
-			linebuf[lx++] = '|';
+			linebuf[lx++] = sep;
 		}
 	}
 nil:
@@ -247,9 +278,11 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 overflow2:
 	linebuf[lx++] = '\0';
 overflow1:
-	return (flags & HEXDUMP_ASCII) ? ascii_column + len +
-					(len - 1) / line_chars :
-					 (groupsize * 2 + 1) * ngroups - 1;
+	if (flags & HEXDUMP_ASCII)
+		return ascii_column + len + (len - 1) / sep_chars;
+
+	return groupsize * 2 * ngroups +
+		((sep == ' ') ? 2 : 1) * (ngroups - 1);
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
@@ -343,9 +376,9 @@ void print_hex_dump_ext(const char *level, const char *prefix_str,
 
 	/* Worst case line length:
 	 * 2 hex chars + space per byte in, 2 spaces, 1 char per byte in,
-	 * 1 char per N groups, NULL
+	 * 2 char per N groups, NULL
 	 */
-	linebuf_len = rowsize * 3 + 2 + rowsize + rowsize / groupsize + 1;
+	linebuf_len = rowsize * 3 + 2 + rowsize + 2 * rowsize / groupsize + 1;
 	linebuf = kzalloc(linebuf_len, GFP_KERNEL);
 	if (!linebuf) {
 		printk("%s%shexdump: Could not alloc %u bytes for buffer\n",
-- 
2.21.0
