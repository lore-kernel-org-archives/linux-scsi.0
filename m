From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 07/13] st: convert dio path to use st_scsi_execute
Date: Thu, 11 Dec 2008 23:07:44 +0900
Message-ID: <1229004470-25718-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43885 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYLKOK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:56 -0500
In-Reply-To: <1229004470-25718-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This patch converts the dio path (mmap) to use st_scsi_execute. IOW,
it removes scsi_execute_async in the non dio path.

scsi_execute_async has gone! This also remove unused st_sleep_done.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   69 ++++++++++++++--------------------------------------
 drivers/scsi/st.h |    1 +
 2 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index d3e2a29..80b1c25 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -191,9 +191,9 @@ static int from_buffer(struct st_buffer *, char __user *, int);
 static void move_buffer_data(struct st_buffer *, int);
 static void buf_to_sg(struct st_buffer *, unsigned int);
 
-static int sgl_map_user_pages(struct scatterlist *, const unsigned int, 
+static int sgl_map_user_pages(struct st_buffer *, const unsigned int,
 			      unsigned long, size_t, int);
-static int sgl_unmap_user_pages(struct scatterlist *, const unsigned int, int);
+static int sgl_unmap_user_pages(struct st_buffer *, const unsigned int, int);
 
 static int st_probe(struct device *);
 static int st_remove(struct device *);
@@ -435,22 +435,6 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	return (-EIO);
 }
 
-
-/* Wakeup from interrupt */
-static void st_sleep_done(void *data, char *sense, int result, int resid)
-{
-	struct st_request *SRpnt = data;
-	struct scsi_tape *STp = SRpnt->stp;
-
-	memcpy(SRpnt->sense, sense, SCSI_SENSE_BUFFERSIZE);
-	(STp->buffer)->cmdstat.midlevel_result = SRpnt->result = result;
-	(STp->buffer)->cmdstat.residual = resid;
-	DEB( STp->write_pending = 0; )
-
-	if (SRpnt->waiting)
-		complete(SRpnt->waiting);
-}
-
 static struct st_request *st_allocate_request(struct scsi_tape *stp)
 {
 	struct st_request *streq;
@@ -566,7 +550,10 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	init_completion(waiting);
 	SRpnt->waiting = waiting;
 
-	if (!STp->buffer->do_dio) {
+	if (STp->buffer->do_dio) {
+		mdata->nr_entries = STp->buffer->sg_segs;
+		mdata->pages = STp->buffer->mapped_pages;
+	} else {
 		buf_to_sg(STp->buffer, bytes);
 
 		mdata->nr_entries =
@@ -579,15 +566,7 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	STp->buffer->cmdstat.have_sense = 0;
 	STp->buffer->syscall_result = 0;
 
-	if (STp->buffer->do_dio)
-		ret = scsi_execute_async(STp->device, cmd, COMMAND_SIZE(cmd[0]),
-					 direction, &((STp->buffer)->sg[0]), bytes,
-					 (STp->buffer)->sg_segs, timeout, retries,
-					 SRpnt, st_sleep_done, GFP_KERNEL);
-	else
-		ret = st_scsi_execute(SRpnt, cmd, direction, NULL, bytes,
-				      timeout, retries);
-
+	ret = st_scsi_execute(SRpnt, cmd, direction, NULL, bytes, timeout, retries);
 	if (ret) {
 		/* could not allocate the buffer or request was too large */
 		(STp->buffer)->syscall_result = (-EBUSY);
@@ -1539,8 +1518,8 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 
 	if (i && ((unsigned long)buf & queue_dma_alignment(
 					STp->device->request_queue)) == 0) {
-		i = sgl_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
-				      (unsigned long)buf, count, (is_read ? READ : WRITE));
+		i = sgl_map_user_pages(STbp, STbp->use_sg, (unsigned long)buf,
+				       count, (is_read ? READ : WRITE));
 		if (i > 0) {
 			STbp->do_dio = i;
 			STbp->buffer_bytes = 0;   /* can be used as transfer counter */
@@ -1594,7 +1573,7 @@ static void release_buffering(struct scsi_tape *STp, int is_read)
 
 	STbp = STp->buffer;
 	if (STbp->do_dio) {
-		sgl_unmap_user_pages(&(STbp->sg[0]), STbp->do_dio, is_read);
+		sgl_unmap_user_pages(STbp, STbp->do_dio, is_read);
 		STbp->do_dio = 0;
 		STbp->sg_segs = 0;
 	}
@@ -4646,7 +4625,7 @@ out:
 }
 
 /* The following functions may be useful for a larger audience. */
-static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
+static int sgl_map_user_pages(struct st_buffer *STbp, const unsigned int max_pages,
 			      unsigned long uaddr, size_t count, int rw)
 {
 	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -4654,6 +4633,7 @@ static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pa
 	const int nr_pages = end - start;
 	int res, i, j;
 	struct page **pages;
+	struct rq_map_data *mdata = &STbp->map_data;
 
 	/* User attempted Overflow! */
 	if ((uaddr + count) < uaddr)
@@ -4695,24 +4675,11 @@ static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pa
 		flush_dcache_page(pages[i]);
         }
 
-	/* Populate the scatter/gather list */
-	sg_set_page(&sgl[0], pages[0], 0, uaddr & ~PAGE_MASK);
-	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
-		for (i=1; i < nr_pages ; i++) {
-			sg_set_page(&sgl[i], pages[i],
-				    count < PAGE_SIZE ? count : PAGE_SIZE, 0);;
-			count -= PAGE_SIZE;
-		}
-	}
-	else {
-		sgl[0].length = count;
-	}
+	mdata->offset = uaddr & ~PAGE_MASK;
+	mdata->page_order = 0;
+	STbp->mapped_pages = pages;
 
-	kfree(pages);
 	return nr_pages;
-
  out_unmap:
 	if (res > 0) {
 		for (j=0; j < res; j++)
@@ -4725,13 +4692,13 @@ static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pa
 
 
 /* And unmap them... */
-static int sgl_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
+static int sgl_unmap_user_pages(struct st_buffer *STbp, const unsigned int nr_pages,
 				int dirtied)
 {
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		struct page *page = sg_page(&sgl[i]);
+		struct page *page = STbp->mapped_pages[i];
 
 		if (dirtied)
 			SetPageDirty(page);
@@ -4740,6 +4707,8 @@ static int sgl_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_p
 		 */
 		page_cache_release(page);
 	}
+	kfree(STbp->mapped_pages);
+	STbp->mapped_pages = NULL;
 
 	return 0;
 }
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 77302fa..d80926f 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -46,6 +46,7 @@ struct st_buffer {
 	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
 	struct page **reserved_pages;
+	struct page **mapped_pages;
 	struct rq_map_data map_data;
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
-- 
1.5.6.5

