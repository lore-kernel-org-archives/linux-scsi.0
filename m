From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Mon,  5 Oct 2015 11:26:40 +0200
Message-ID: <1444037200-14684-3-git-send-email-linux@rasmusvillemoes.dk>
References: <20151004080217.GA22816@infradead.org>
 <1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
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

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/constants.c   | 25 +++++++++++++++++++++----
 drivers/scsi/sense_codes.h |  2 --
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 47aaccd5e68e..ccd34b0481cd 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -292,17 +292,31 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
 
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
@@ -364,11 +378,14 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
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
diff --git a/drivers/scsi/sense_codes.h b/drivers/scsi/sense_codes.h
index 54b3939d6309..da84d53b3379 100644
--- a/drivers/scsi/sense_codes.h
+++ b/drivers/scsi/sense_codes.h
@@ -833,5 +833,3 @@ SENSE_CODE(0x746E, "External data encryption control timeout")
 SENSE_CODE(0x746F, "External data encryption control error")
 SENSE_CODE(0x7471, "Logical unit access not authorized")
 SENSE_CODE(0x7479, "Security conflict in translated device")
-
-SENSE_CODE(0, NULL)
-- 
2.1.3
