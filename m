From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] [SCSI] osd: fix signed char versus %02x issue
Date: Tue,  8 Dec 2015 15:25:16 +0100
Message-ID: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If char is signed and one of these bytes happen to have a value
outside the ascii range, the corresponding output will consist of
"ffffff" followed by the two hex chars that were actually
intended. One way to fix it would be to change the casts to (u8*) aka
(unsigned char*), but it is much simpler (and generates smaller code)
to use the %ph extension which was created for such short hexdumps.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/osd/osd_initiator.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0cccd6033feb..d8a2b5185f56 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -170,10 +170,7 @@ static int _osd_get_print_system_info(struct osd_dev *od,
 
 	/* FIXME: Where are the time utilities */
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("CLOCK                  [0x%02x%02x%02x%02x%02x%02x]\n",
-		((char *)pFirst)[0], ((char *)pFirst)[1],
-		((char *)pFirst)[2], ((char *)pFirst)[3],
-		((char *)pFirst)[4], ((char *)pFirst)[5]);
+	OSD_INFO("CLOCK                  [0x%6phN]\n", pFirst);
 
 	if (a < nelem) { /* IBM-OSD-SIM bug, Might not have it */
 		unsigned len = get_attrs[a].len;
-- 
2.6.1
