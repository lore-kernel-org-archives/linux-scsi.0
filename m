From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 14/16] st: remove unused frp_sg_current
Date: Thu, 18 Dec 2008 14:49:49 +0900
Message-ID: <1229579391-28753-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46385 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbYLRGIw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:52 -0500
In-Reply-To: <1229579391-28753-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

frp_sg_current in struct st_buffer is always zero. We don't need it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |    2 --
 drivers/scsi/st.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 50dbe14..fe4c202 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1524,7 +1524,6 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 		else
 			STbp->do_dio = 0;  /* fall back to buffering with any error */
 		STbp->sg_segs = STbp->do_dio;
-		STbp->frp_sg_current = 0;
 		DEB(
 		     if (STbp->do_dio) {
 			STp->nbr_dio++;
@@ -3844,7 +3843,6 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 		STbuffer->buffer_size -= (PAGE_SIZE << order);
 	}
 	STbuffer->frp_segs = 0;
-	STbuffer->frp_sg_current = 0;
 	STbuffer->sg_segs = 0;
 	STbuffer->map_data.page_order = 0;
 	STbuffer->map_data.offset = 0;
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index e682f80..544dc6b 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -52,7 +52,6 @@ struct st_buffer {
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
 	unsigned short frp_segs;	/* number of buffer segments */
-	unsigned int frp_sg_current;	/* driver buffer length currently in s/g list */
 };
 
 /* The tape mode definition */
-- 
1.5.6.5

