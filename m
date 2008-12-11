From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 04/13] st: add struct rq_map_data support
Date: Thu, 11 Dec 2008 23:07:41 +0900
Message-ID: <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49114 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbYLKOK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:56 -0500
In-Reply-To: <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This adds struct rq_map_data and the array of pointers to store
fragment buffers to struct st_buffer.

This patch doesn't remove st_buf_fragment but the latter patch does.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   11 +++++++++++
 drivers/scsi/st.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a63b504..ce47495 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3723,6 +3723,12 @@ static struct st_buffer *
 	tb->buffer_size = got;
 	sg_init_table(tb->sg, max_sg);
 
+	tb->reserved_pages = kzalloc(max_sg * sizeof(struct page *), priority);
+	if (!tb->reserved_pages) {
+		kfree(tb);
+		return NULL;
+	}
+
 	return tb;
 }
 
@@ -3771,9 +3777,11 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		STbuffer->buffer_size = got;
 		if (STbuffer->cleared)
 			memset(page_address(STbuffer->frp[segs].page), 0, b_size);
+		STbuffer->reserved_pages[segs] = STbuffer->frp[segs].page;
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->frp[0].page);
+	STbuffer->map_data.page_order = order;
 
 	return 1;
 }
@@ -3803,6 +3811,8 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
 	STbuffer->sg_segs = 0;
+	STbuffer->map_data.page_order = 0;
+	STbuffer->map_data.offset = 0;
 }
 
 
@@ -4282,6 +4292,7 @@ static void scsi_tape_release(struct kref *kref)
 	if (tpnt->buffer) {
 		tpnt->buffer->orig_frp_segs = 0;
 		normalize_buffer(tpnt->buffer);
+		kfree(tpnt->buffer->reserved_pages);
 		kfree(tpnt->buffer);
 	}
 
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index b92712f..74748ab 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -44,6 +44,8 @@ struct st_buffer {
 	int syscall_result;
 	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
+	struct page **reserved_pages;
+	struct rq_map_data map_data;
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
-- 
1.5.6.5

