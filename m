From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] Add sg io mmap helper
Date: Sun, 04 Mar 2007 12:31:22 -0600
Message-ID: <11730330881574-git-send-email-michaelc@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <11730330852430-git-send-email-michaelc@cs.wisc.edu> <11730330851234-git-send-email-michaelc@cs.wisc.edu> <11730330861995-git-send-email-michaelc@cs.wisc.edu> <11730330872229-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXCDSbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 13:31:38 -0500
In-Reply-To: <11730330872229-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

sg.c supports mmap, so this patch just move the code
to the block layer for others to share and converts it
to the bio reserved buffer.

The helpers are:
- blk_rq_mmap - does some checks to makre sure the reserved buf is
large enough.
- blk_rq_vma_nopage - traverses the reserved buffer and does get_page()

To setup and teardown the request and bio reserved buffer mappings for
the sg mmap operation you call blk_rq_setup_buffer() and
blk_rq_destroy_buffer().
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c      |   68 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    4 +++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 4d6c2bd..35b66ed 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2431,6 +2431,74 @@ unmap_rq:
 EXPORT_SYMBOL(blk_rq_setup_buffer);
 
 /**
+ * blk_rq_mmap - alloc and setup buffers for REQ_BLOCK_PC mmap
+ * @rbuf:	reserve buffer
+ * @vma:	vm struct
+ *
+ * Description:
+ *    A the caller must also call blk_rq_setup_buffer on the request and
+ *    blk_rq_destroy_buffer() must be issued at the end of io.
+ *    It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_destroy_buffer() for
+ *    proper unmapping.
+ *
+ *    The block layer mmap functions implement the old sg.c behavior
+ *    where they can be only one sg mmap command outstanding.
+ */
+int blk_rq_mmap(struct bio_reserve_buf *rbuf, struct vm_area_struct *vma)
+{
+	unsigned long len;
+
+	if (vma->vm_pgoff)
+		return -EINVAL; /* want no offset */
+
+	if (!rbuf)
+		return -ENOMEM;
+
+	len = vma->vm_end - vma->vm_start;
+	if (len > rbuf->buf_size)
+		return -ENOMEM;
+
+	vma->vm_flags |= VM_RESERVED;
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_mmap);
+
+struct page *blk_rq_vma_nopage(struct bio_reserve_buf *rbuf,
+			       struct vm_area_struct *vma, unsigned long addr,
+			       int *type)
+{
+	struct page *pg = NOPAGE_SIGBUS;
+	unsigned long offset, bytes = 0, sg_offset;
+	struct scatterlist *sg;
+	int i;
+
+	if (!rbuf)
+		return pg;
+
+	offset = addr - vma->vm_start;
+	if (offset >= rbuf->buf_size)
+		return pg;
+
+	for (i = 0; i < rbuf->sg_count; i++) {
+		sg = &rbuf->sg[i];
+
+		bytes += sg->length;
+		if (bytes > offset) {
+			sg_offset = sg->length - (bytes - offset);
+			pg = &sg->page[sg_offset >> PAGE_SHIFT];
+			get_page(pg);
+			break;
+		}
+	}
+
+	if (type)
+		*type = VM_FAULT_MINOR;
+	return pg;
+}
+EXPORT_SYMBOL(blk_rq_vma_nopage);
+
+/**
  * blk_rq_map_user - map user data to a request.
  * @q:		request queue where request should be inserted
  * @rq:		request structure to fill
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 755f0b4..04c1b09 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -670,6 +670,10 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
+extern struct page *blk_rq_vma_nopage(struct bio_reserve_buf *,
+				      struct vm_area_struct *, unsigned long,
+				      int *);
+extern int blk_rq_mmap(struct bio_reserve_buf *, struct vm_area_struct *);
 extern int blk_rq_init_transfer(request_queue_t *, struct request *, void __user *, unsigned long);
 extern int blk_rq_map_user(request_queue_t *, struct request *,
 			   void __user *, unsigned long);
-- 
1.4.1.1

