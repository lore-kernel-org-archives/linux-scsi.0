From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 13/13] st: remove unused frp_sg_current
Date: Thu, 11 Dec 2008 23:07:50 +0900
Message-ID: <1229004470-25718-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43902 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbYLKOLA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:11:00 -0500
In-Reply-To: <1229004470-25718-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

frp_sg_current in struct st_buffer is always zero. We don't need it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |    2 --
 drivers/scsi/st.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ddfacc8..ffb709c 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1523,7 +1523,6 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 		else
 			STbp->do_dio = 0;  /* fall back to buffering with any error */
 		STbp->sg_segs = STbp->do_dio;
-		STbp->frp_sg_current = 0;
 		DEB(
 		     if (STbp->do_dio) {
 			STp->nbr_dio++;
@@ -3842,7 +3841,6 @@ static void normalize_buffer(struct st_buffer * STbuffer)
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

