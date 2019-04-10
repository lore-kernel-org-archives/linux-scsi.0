From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date: Wed, 10 Apr 2019 13:17:17 +1000
Message-ID: <20190410031720.11067-2-alastair@au1.ibm.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ath10k-bounces+gldad-ath10k=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190410031720.11067-1-alastair@au1.ibm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/ath10k>,
 <mailto:ath10k-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/ath10k/>
List-Post: <mailto:ath10k@lists.infradead.org>
List-Help: <mailto:ath10k-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/ath10k>,
 <mailto:ath10k-request@lists.infradead.org?subject=subscribe>
Sender: "ath10k" <ath10k-bounces@lists.infradead.org>
Errors-To: ath10k-bounces+gldad-ath10k=m.gmane.org@lists.infradead.org
To: alastair@d-silva.org
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Benson Leung <bleung@chromium.org>, Kalle Valo <kvalo@codeaurora.org>, Karsten Keil <isdn@linux-pingi.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-wireless@vger.kernel
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

With modern high resolution screens, we can display more data, which makes
life a bit easier when debugging.

Allow 64 bytes to be dumped per line.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 lib/hexdump.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 81b70ed37209..b8a164814744 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -80,14 +80,14 @@ EXPORT_SYMBOL(bin2hex);
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
- * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @rowsize: number of bytes to print per line; must be 16, 32 or 64
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  * @ascii: include ASCII after the hex output
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
- * 16 or 32 bytes of input data converted to hex + ASCII output.
+ * 16, 32 or 64 bytes of input data converted to hex + ASCII output.
  *
  * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
  * to a hex + ASCII dump at the supplied memory location.
@@ -116,7 +116,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 	int ascii_column;
 	int ret;
 
-	if (rowsize != 16 && rowsize != 32)
+	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
 		rowsize = 16;
 
 	if (len > rowsize)		/* limit to one line at a time */
@@ -216,7 +216,7 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
  *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
- * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @rowsize: number of bytes to print per line; must be 16, 32 or 64
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
@@ -227,7 +227,7 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * leading prefix.
  *
  * print_hex_dump() works on one "line" of output at a time, i.e.,
- * 16 or 32 bytes of input data converted to hex + ASCII output.
+ * 16, 32 or 64 bytes of input data converted to hex + ASCII output.
  * print_hex_dump() iterates over the entire input @buf, breaking it into
  * "line size" chunks to format and print.
  *
@@ -246,9 +246,9 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 {
 	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
-	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
+	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
 
-	if (rowsize != 16 && rowsize != 32)
+	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
 		rowsize = 16;
 
 	for (i = 0; i < len; i += rowsize) {
-- 
2.20.1
