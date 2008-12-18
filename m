From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 16/16] st: retry enlarge_buffer allocation
Date: Thu, 18 Dec 2008 14:49:51 +0900
Message-ID: <1229579391-28753-17-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-16-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46386 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYLRGIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:53 -0500
In-Reply-To: <1229579391-28753-16-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org

From: Kai Makisara <Kai.Makisara@kolumbus.fi>

Make enlarge_buffer() retry allocation if the previously chosen page
order was too small. Really limit the page order to 6. Return error if
the maximum order is not large enough for the request.

Signed-off-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ddf2630..c6f19ee 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3695,6 +3695,8 @@ static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
 
 
 /* Try to allocate enough space in the tape buffer */
+#define ST_MAX_ORDER 6
+
 static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dma)
 {
 	int segs, nbr, max_segs, b_size, order, got;
@@ -3723,9 +3725,16 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order = 0;
-		     order <= 6 && b_size < new_size; order++, b_size *= 2)
+		     order < ST_MAX_ORDER && b_size < new_size;
+		     order++, b_size *= 2)
 			;  /* empty */
 	}
+	if (max_segs * (PAGE_SIZE << order) < new_size) {
+		if (order == ST_MAX_ORDER)
+			return 0;
+		normalize_buffer(STbuffer);
+		return enlarge_buffer(STbuffer, new_size, need_dma);
+	}
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
 	     segs < max_segs && got < new_size;) {
-- 
1.5.6.5

