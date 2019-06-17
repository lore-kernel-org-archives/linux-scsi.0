From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH v3 1/7] lib/hexdump.c: Fix selftests
Date: Mon, 17 Jun 2019 12:04:24 +1000
Message-ID: <20190617020430.8708-2-alastair@au1.ibm.com>
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

The overflow tests did not account for the situation where no
overflow occurs and len < rowsize.

This patch renames the cryptic variables and accounts for the
above case.

The selftests now pass.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 lib/test_hexdump.c | 47 ++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index 5144899d3c6b..d78ddd62ffd0 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -163,45 +163,52 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
-	int rs = rowsize, gs = groupsize;
-	int ae, he, e, f, r;
-	bool a;
+	int ascii_len, hex_len, expected_len, fill_point, ngroups, rc;
+	bool match;
 
 	total_tests++;
 
 	memset(buf, FILL_CHAR, sizeof(buf));
 
-	r = hex_dump_to_buffer(data_b, len, rs, gs, buf, buflen, ascii);
+	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen, ascii);
 
 	/*
 	 * Caller must provide the data length multiple of groupsize. The
 	 * calculations below are made with that assumption in mind.
 	 */
-	ae = rs * 2 /* hex */ + rs / gs /* spaces */ + 1 /* space */ + len /* ascii */;
-	he = (gs * 2 /* hex */ + 1 /* space */) * len / gs - 1 /* no trailing space */;
+	ngroups = rowsize / groupsize;
+	hex_len = (groupsize * 2 /* hex */ + 1 /* spaces */) * ngroups
+		  - 1 /* no trailing space */;
+	ascii_len = hex_len + 2 /* space */ + len /* ascii */;
+
+	if (len < rowsize) {
+		ngroups = len / groupsize;
+		hex_len = (groupsize * 2 /* hex */ + 1 /* spaces */) * ngroups
+		  - 1 /* no trailing space */;
+	}
 
-	if (ascii)
-		e = ae;
-	else
-		e = he;
+	expected_len = (ascii) ? ascii_len : hex_len;
 
-	f = min_t(int, e + 1, buflen);
+	fill_point = min_t(int, expected_len + 1, buflen);
 	if (buflen) {
-		test_hexdump_prepare_test(len, rs, gs, test, sizeof(test), ascii);
-		test[f - 1] = '\0';
+		test_hexdump_prepare_test(len, rowsize, groupsize, test,
+					  sizeof(test), ascii);
+		test[fill_point - 1] = '\0';
 	}
-	memset(test + f, FILL_CHAR, sizeof(test) - f);
+	memset(test + fill_point, FILL_CHAR, sizeof(test) - fill_point);
 
-	a = r == e && !memcmp(test, buf, TEST_HEXDUMP_BUF_SIZE);
+	match = rc == expected_len && !memcmp(test, buf, TEST_HEXDUMP_BUF_SIZE);
 
 	buf[sizeof(buf) - 1] = '\0';
 
-	if (!a) {
-		pr_err("Len: %zu buflen: %zu strlen: %zu\n",
-			len, buflen, strnlen(buf, sizeof(buf)));
-		pr_err("Result: %d '%s'\n", r, buf);
-		pr_err("Expect: %d '%s'\n", e, test);
+	if (!match) {
+		pr_err("rowsize: %u groupsize: %u ascii: %d Len: %zu buflen: %zu strlen: %zu\n",
+			rowsize, groupsize, ascii, len, buflen,
+			strnlen(buf, sizeof(buf)));
+		pr_err("Result: %d '%-.*s'\n", rc, (int)buflen, buf);
+		pr_err("Expect: %d '%-.*s'\n", expected_len, (int)buflen, test);
 		failed_tests++;
+
 	}
 }
 
-- 
2.21.0
