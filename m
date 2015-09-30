From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: RFC: reduce CONFIG_SCSI_CONSTANTS impact by 4k
Date: Wed, 30 Sep 2015 19:30:34 +0200
Message-ID: <87h9mbg6h1.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

struct error_info has 6 bytes of padding on x86_64 (and I assume also
other 64 bit platforms). This currently amounts to about 4k of wasted
space (and presumably a third of that on 32 bit).

We can avoid that by keeping the codes and the strings in separate
arrays. Keeping those in sync should be easy enough if we use the
standard trick of including a table twice.

Patch 2/2 would be something like below; 1/2 is a 1600 line purely
mechanical thing which I won't spam the lists with unless someone else
thinks this is a good idea.

What do you think?

Subject: [PATCH 2/2] scsi: split additional[] array in two

struct error_info has 6 bytes of padding (on 64 bit platforms), which
amounts to over 4K of wasted space in the additional[]
array. Splitting it in two avoids that waste. A BUILD_BUG_ON and the
fact that the two arrays are generated from the same include file
should keep these two arrays in sync.

$ scripts/bloat-o-meter /tmp/vmlinux vmlinux
add/remove: 2/1 grow/shrink: 1/0 up/down: 7073/-11312 (-4239)

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/constants.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 14d5069ca3ff..03f28cdcbc31 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -290,19 +290,19 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
 	return true;
 }
 
-struct error_info {
-	unsigned short code12;	/* 0x0302 looks better than 0x03,0x02 */
-	const char * text;
+static unsigned short additional_code12[] = {
+#define SENSE_CODE(c, s) c
+#include "sense_codes.h"
+#undef SENSE_CODE
 };
 
-
-static const struct error_info additional[] =
-{
-#define SENSE_CODE(c, s) {c, s}
+static const char *additional_text[] = {
+#define SENSE_CODE(c, s) s
 #include "sense_codes.h"
 #undef SENSE_CODE
 };
 
+
 struct error_info2 {
 	unsigned char code1, code2_min, code2_max;
 	const char * str;
@@ -364,11 +364,12 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 {
 	int i;
 	unsigned short code = ((asc << 8) | ascq);
+	BUILD_BUG_ON(ARRAY_SIZE(additional_code12) != ARRAY_SIZE(additional_text));
 
 	*fmt = NULL;
-	for (i = 0; additional[i].text; i++)
-		if (additional[i].code12 == code)
-			return additional[i].text;
+	for (i = 0; additional_text[i]; i++)
+		if (additional_code12[i] == code)
+			return additional_text[i];
 	for (i = 0; additional2[i].fmt; i++) {
 		if (additional2[i].code1 == asc &&
 		    ascq >= additional2[i].code2_min &&
