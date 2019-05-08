From: "Alastair D'Silva" <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 6/7] lib/hexdump.c: Allow multiple groups to be separated by spaces
Date: Wed,  8 May 2019 17:01:46 +1000
Message-ID: <20190508070148.23130-7-alastair@au1.ibm.com>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190508070148.23130-1-alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org
Cc: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jose Abreu <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benson Leung <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>

Similar to the previous patch, this patch separates groups by 2 spaces for
the hex fields, and 1 space for the ASCII field.

eg.
buf:00000000: 454d414e 43415053  4e495f45 00584544  NAMESPAC E_INDEX.
buf:00000010: 00000000 00000002  00000000 00000000  ........ ........

Signed-off-by: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
---
 include/linux/printk.h |  3 ++
 lib/hexdump.c          | 65 +++++++++++++++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index dc693aec394c..5231a14e4593 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -485,6 +485,9 @@ enum {
 #define HEXDUMP_2_GRP_LINES		(1 << 2)
 #define HEXDUMP_4_GRP_LINES		(1 << 3)
 #define HEXDUMP_8_GRP_LINES		(1 << 4)
+#define HEXDUMP_2_GRP_SPACES		(1 << 5)
+#define HEXDUMP_4_GRP_SPACES		(1 << 6)
+#define HEXDUMP_8_GRP_SPACES		(1 << 7)
 
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 6f4d1176c332..febd614406d1 100644
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
