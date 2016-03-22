From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v3 3/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Tue, 22 Mar 2016 20:32:05 +0100
Message-ID: <1458675126-19265-4-git-send-email-linux@rasmusvillemoes.dk>
References: <20160322075405.GA20141@infradead.org>
 <1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 64 bit, struct error_info has 6 bytes of padding, which amounts to
over 4k of wasted space in the additional[] array. We could easily get
rid of that by instead using separate arrays for the codes and the
pointers. However, we can do even better than that and save an
additional 6 bytes per entry: In the table, just store the sizeof()
the corresponding string literal. The cumulative sum of these is then
the appropriate offset into additional_text, which is built from the
concatenation (with '\0's inbetween) of the strings.

$ scripts/bloat-o-meter /tmp/vmlinux vmlinux
add/remove: 0/0 grow/shrink: 1/1 up/down: 24/-8488 (-8464)
function                                     old     new   delta
scsi_extd_sense_format                       136     160     +24
additional                                 11312    2824   -8488

The Kconfig help text used to say that CONFIG_SCSI_CONSTANTS=y costs
around 75 KB, but that was a little exaggerated. The actual number was
closer to 44K, and 36K with this patch.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/Kconfig     |  4 ++--
 drivers/scsi/constants.c | 26 +++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e80768f8e579..47611bda633f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -202,12 +202,12 @@ config SCSI_ENCLOSURE
 	  certain enclosure conditions to be reported and is not required.
 
 config SCSI_CONSTANTS
-	bool "Verbose SCSI error reporting (kernel size +=75K)"
+	bool "Verbose SCSI error reporting (kernel size += 36K)"
 	depends on SCSI
 	help
 	  The error messages regarding your SCSI hardware will be easier to
 	  understand if you say Y here; it will enlarge your kernel by about
-	  75 KB. If in doubt, say Y.
+	  36 KB. If in doubt, say Y.
 
 config SCSI_LOGGING
 	bool "SCSI logging facility"
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 6e813eec4f8d..83458f7a2824 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -292,17 +292,30 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
 
 struct error_info {
 	unsigned short code12;	/* 0x0302 looks better than 0x03,0x02 */
-	const char * text;
+	unsigned short size;
 };
 
+/*
+ * There are 700+ entries in this table. To save space, we don't store
+ * (code, pointer) pairs, which would make sizeof(struct
+ * error_info)==16 on 64 bits. Rather, the second element just stores
+ * the size (including \0) of the corresponding string, and we use the
+ * sum of these to get the appropriate offset into additional_text
+ * defined below. This approach saves 12 bytes per entry.
+ */
 static const struct error_info additional[] =
 {
-#define SENSE_CODE(c, s) {c, s},
+#define SENSE_CODE(c, s) {c, sizeof(s)},
 #include "sense_codes.h"
 #undef SENSE_CODE
-	{0, NULL}
 };
 
+static const char *additional_text =
+#define SENSE_CODE(c, s) s "\0"
+#include "sense_codes.h"
+#undef SENSE_CODE
+	;
+
 struct error_info2 {
 	unsigned char code1, code2_min, code2_max;
 	const char * str;
@@ -364,11 +377,14 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 {
 	int i;
 	unsigned short code = ((asc << 8) | ascq);
+	unsigned offset = 0;
 
 	*fmt = NULL;
-	for (i = 0; additional[i].text; i++)
+	for (i = 0; i < ARRAY_SIZE(additional); i++) {
 		if (additional[i].code12 == code)
-			return additional[i].text;
+			return additional_text + offset;
+		offset += additional[i].size;
+	}
 	for (i = 0; additional2[i].fmt; i++) {
 		if (additional2[i].code1 == asc &&
 		    ascq >= additional2[i].code2_min &&
-- 
2.1.4
