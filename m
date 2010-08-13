From: Sage Weil <sage@newdream.net>
Subject: [PATCH 3/8] ceph-rbd: messenger and osdc changes for rbd
Date: Fri, 13 Aug 2010 10:40:35 -0700
Message-ID: <1281721240-26130-4-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:46696 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761918Ab0HMRlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2010 13:41:45 -0400
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net, Sage Weil <sage@newdream.net>

From: Yehuda Sadeh <yehuda@hq.newdream.net>

The messenger can send/receive data in bio.  This was added
so that we wouldn't need to copy the data from the rados
block device.

We can now have trailing variable sized data for osd
ops. Also osd ops encoding is more modular.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/messenger.c  |  219 +++++++++++++++++++++++++++++++++++++-------
 fs/ceph/messenger.h  |    4 +
 fs/ceph/osd_client.c |  249 +++++++++++++++++++++++++++++++++++++++-----------
 fs/ceph/osd_client.h |   61 ++++++++++---
 fs/ceph/pagelist.c   |    2 +-
 fs/ceph/pagelist.h   |    2 +-
 6 files changed, 436 insertions(+), 101 deletions(-)

diff --git a/fs/ceph/messenger.c b/fs/ceph/messenger.c
index 2502d76..17a09b3 100644
--- a/fs/ceph/messenger.c
+++ b/fs/ceph/messenger.c
@@ -9,6 +9,8 @@
 #include <linux/slab.h>
 #include <linux/socket.h>
 #include <linux/string.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
 #include <net/tcp.h>
 
 #include "super.h"
@@ -529,8 +531,11 @@ static void prepare_write_message(struct ceph_connection *con)
 	if (le32_to_cpu(m->hdr.data_len) > 0) {
 		/* initialize page iterator */
 		con->out_msg_pos.page = 0;
-		con->out_msg_pos.page_pos =
-			le16_to_cpu(m->hdr.data_off) & ~PAGE_MASK;
+		if (m->pages)
+			con->out_msg_pos.page_pos =
+				le16_to_cpu(m->hdr.data_off) & ~PAGE_MASK;
+		else
+			con->out_msg_pos.page_pos = 0;
 		con->out_msg_pos.data_pos = 0;
 		con->out_msg_pos.did_page_crc = 0;
 		con->out_more = 1;  /* data + footer will follow */
@@ -712,6 +717,31 @@ out:
 	return ret;  /* done! */
 }
 
+#ifdef CONFIG_BLOCK
+static void init_bio_iter(struct bio *bio, struct bio **iter, int *seg)
+{
+	if (!bio) {
+		*iter = NULL;
+		*seg = 0;
+		return;
+	}
+	*iter = bio;
+	*seg = bio->bi_idx;
+}
+
+static void iter_bio_next(struct bio **bio_iter, int *seg)
+{
+	if (*bio_iter == NULL)
+		return;
+
+	BUG_ON(*seg >= (*bio_iter)->bi_vcnt);
+
+	(*seg)++;
+	if (*seg == (*bio_iter)->bi_vcnt)
+		init_bio_iter((*bio_iter)->bi_next, bio_iter, seg);
+}
+#endif
+
 /*
  * Write as much message data payload as we can.  If we finish, queue
  * up the footer.
@@ -726,21 +756,46 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 	size_t len;
 	int crc = con->msgr->nocrc;
 	int ret;
+	int total_max_write;
+	int in_trail = 0;
+	size_t trail_len = (msg->trail ? msg->trail->length : 0);
 
 	dout("write_partial_msg_pages %p msg %p page %d/%d offset %d\n",
 	     con, con->out_msg, con->out_msg_pos.page, con->out_msg->nr_pages,
 	     con->out_msg_pos.page_pos);
 
-	while (con->out_msg_pos.page < con->out_msg->nr_pages) {
+#ifdef CONFIG_BLOCK
+	if (msg->bio && !msg->bio_iter)
+		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bio_seg);
+#endif
+
+	while (data_len > con->out_msg_pos.data_pos) {
 		struct page *page = NULL;
 		void *kaddr = NULL;
+		int max_write = PAGE_SIZE;
+		int page_shift = 0;
+
+		total_max_write = data_len - trail_len -
+			con->out_msg_pos.data_pos;
 
 		/*
 		 * if we are calculating the data crc (the default), we need
 		 * to map the page.  if our pages[] has been revoked, use the
 		 * zero page.
 		 */
-		if (msg->pages) {
+
+		/* have we reached the trail part of the data? */
+		if (con->out_msg_pos.data_pos >= data_len - trail_len) {
+			in_trail = 1;
+
+			total_max_write = data_len - con->out_msg_pos.data_pos;
+
+			page = list_first_entry(&msg->trail->head,
+						struct page, lru);
+			if (crc)
+				kaddr = kmap(page);
+			max_write = PAGE_SIZE;
+		} else if (msg->pages) {
 			page = msg->pages[con->out_msg_pos.page];
 			if (crc)
 				kaddr = kmap(page);
@@ -749,13 +804,25 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 						struct page, lru);
 			if (crc)
 				kaddr = kmap(page);
+#ifdef CONFIG_BLOCK
+		} else if (msg->bio) {
+			struct bio_vec *bv;
+
+			bv = bio_iovec_idx(msg->bio_iter, msg->bio_seg);
+			page = bv->bv_page;
+			page_shift = bv->bv_offset;
+			if (crc)
+				kaddr = kmap(page) + page_shift;
+			max_write = bv->bv_len;
+#endif
 		} else {
 			page = con->msgr->zero_page;
 			if (crc)
 				kaddr = page_address(con->msgr->zero_page);
 		}
-		len = min((int)(PAGE_SIZE - con->out_msg_pos.page_pos),
-			  (int)(data_len - con->out_msg_pos.data_pos));
+		len = min_t(int, max_write - con->out_msg_pos.page_pos,
+			    total_max_write);
+
 		if (crc && !con->out_msg_pos.did_page_crc) {
 			void *base = kaddr + con->out_msg_pos.page_pos;
 			u32 tmpcrc = le32_to_cpu(con->out_msg->footer.data_crc);
@@ -765,13 +832,14 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 				cpu_to_le32(crc32c(tmpcrc, base, len));
 			con->out_msg_pos.did_page_crc = 1;
 		}
-
 		ret = kernel_sendpage(con->sock, page,
-				      con->out_msg_pos.page_pos, len,
+				      con->out_msg_pos.page_pos + page_shift,
+				      len,
 				      MSG_DONTWAIT | MSG_NOSIGNAL |
 				      MSG_MORE);
 
-		if (crc && (msg->pages || msg->pagelist))
+		if (crc &&
+		    (msg->pages || msg->pagelist || msg->bio || in_trail))
 			kunmap(page);
 
 		if (ret <= 0)
@@ -783,9 +851,16 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 			con->out_msg_pos.page_pos = 0;
 			con->out_msg_pos.page++;
 			con->out_msg_pos.did_page_crc = 0;
-			if (msg->pagelist)
+			if (in_trail)
+				list_move_tail(&page->lru,
+					       &msg->trail->head);
+			else if (msg->pagelist)
 				list_move_tail(&page->lru,
 					       &msg->pagelist->head);
+#ifdef CONFIG_BLOCK
+			else if (msg->bio)
+				iter_bio_next(&msg->bio_iter, &msg->bio_seg);
+#endif
 		}
 	}
 
@@ -1305,8 +1380,7 @@ static int read_partial_message_section(struct ceph_connection *con,
 					struct kvec *section,
 					unsigned int sec_len, u32 *crc)
 {
-	int left;
-	int ret;
+	int ret, left;
 
 	BUG_ON(!section);
 
@@ -1329,13 +1403,83 @@ static int read_partial_message_section(struct ceph_connection *con,
 static struct ceph_msg *ceph_alloc_msg(struct ceph_connection *con,
 				struct ceph_msg_header *hdr,
 				int *skip);
+
+
+static int read_partial_message_pages(struct ceph_connection *con,
+				      struct page **pages,
+				      unsigned data_len, int datacrc)
+{
+	void *p;
+	int ret;
+	int left;
+
+	left = min((int)(data_len - con->in_msg_pos.data_pos),
+		   (int)(PAGE_SIZE - con->in_msg_pos.page_pos));
+	/* (page) data */
+	BUG_ON(pages == NULL);
+	p = kmap(pages[con->in_msg_pos.page]);
+	ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
+			       left);
+	if (ret > 0 && datacrc)
+		con->in_data_crc =
+			crc32c(con->in_data_crc,
+				  p + con->in_msg_pos.page_pos, ret);
+	kunmap(pages[con->in_msg_pos.page]);
+	if (ret <= 0)
+		return ret;
+	con->in_msg_pos.data_pos += ret;
+	con->in_msg_pos.page_pos += ret;
+	if (con->in_msg_pos.page_pos == PAGE_SIZE) {
+		con->in_msg_pos.page_pos = 0;
+		con->in_msg_pos.page++;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_BLOCK
+static int read_partial_message_bio(struct ceph_connection *con,
+				    struct bio **bio_iter, int *bio_seg,
+				    unsigned data_len, int datacrc)
+{
+	struct bio_vec *bv = bio_iovec_idx(*bio_iter, *bio_seg);
+	void *p;
+	int ret, left;
+
+	if (IS_ERR(bv))
+		return PTR_ERR(bv);
+
+	left = min((int)(data_len - con->in_msg_pos.data_pos),
+		   (int)(bv->bv_len - con->in_msg_pos.page_pos));
+
+	p = kmap(bv->bv_page) + bv->bv_offset;
+
+	ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
+			       left);
+	if (ret > 0 && datacrc)
+		con->in_data_crc =
+			crc32c(con->in_data_crc,
+				  p + con->in_msg_pos.page_pos, ret);
+	kunmap(bv->bv_page);
+	if (ret <= 0)
+		return ret;
+	con->in_msg_pos.data_pos += ret;
+	con->in_msg_pos.page_pos += ret;
+	if (con->in_msg_pos.page_pos == bv->bv_len) {
+		con->in_msg_pos.page_pos = 0;
+		iter_bio_next(bio_iter, bio_seg);
+	}
+
+	return ret;
+}
+#endif
+
 /*
  * read (part of) a message.
  */
 static int read_partial_message(struct ceph_connection *con)
 {
 	struct ceph_msg *m = con->in_msg;
-	void *p;
 	int ret;
 	int to, left;
 	unsigned front_len, middle_len, data_len, data_off;
@@ -1422,7 +1566,10 @@ static int read_partial_message(struct ceph_connection *con)
 			m->middle->vec.iov_len = 0;
 
 		con->in_msg_pos.page = 0;
-		con->in_msg_pos.page_pos = data_off & ~PAGE_MASK;
+		if (m->pages)
+			con->in_msg_pos.page_pos = data_off & ~PAGE_MASK;
+		else
+			con->in_msg_pos.page_pos = 0;
 		con->in_msg_pos.data_pos = 0;
 	}
 
@@ -1440,27 +1587,29 @@ static int read_partial_message(struct ceph_connection *con)
 		if (ret <= 0)
 			return ret;
 	}
+#ifdef CONFIG_BLOCK
+	if (m->bio && !m->bio_iter)
+		init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
+#endif
 
 	/* (page) data */
 	while (con->in_msg_pos.data_pos < data_len) {
-		left = min((int)(data_len - con->in_msg_pos.data_pos),
-			   (int)(PAGE_SIZE - con->in_msg_pos.page_pos));
-		BUG_ON(m->pages == NULL);
-		p = kmap(m->pages[con->in_msg_pos.page]);
-		ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
-				       left);
-		if (ret > 0 && datacrc)
-			con->in_data_crc =
-				crc32c(con->in_data_crc,
-					  p + con->in_msg_pos.page_pos, ret);
-		kunmap(m->pages[con->in_msg_pos.page]);
-		if (ret <= 0)
-			return ret;
-		con->in_msg_pos.data_pos += ret;
-		con->in_msg_pos.page_pos += ret;
-		if (con->in_msg_pos.page_pos == PAGE_SIZE) {
-			con->in_msg_pos.page_pos = 0;
-			con->in_msg_pos.page++;
+		if (m->pages) {
+			ret = read_partial_message_pages(con, m->pages,
+						 data_len, datacrc);
+			if (ret <= 0)
+				return ret;
+#ifdef CONFIG_BLOCK
+		} else if (m->bio) {
+
+			ret = read_partial_message_bio(con,
+						 &m->bio_iter, &m->bio_seg,
+						 data_len, datacrc);
+			if (ret <= 0)
+				return ret;
+#endif
+		} else {
+			BUG_ON(1);
 		}
 	}
 
@@ -2136,6 +2285,10 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags)
 	m->nr_pages = 0;
 	m->pages = NULL;
 	m->pagelist = NULL;
+	m->bio = NULL;
+	m->bio_iter = NULL;
+	m->bio_seg = 0;
+	m->trail = NULL;
 
 	dout("ceph_msg_new %p front %d\n", m, front_len);
 	return m;
@@ -2250,6 +2403,8 @@ void ceph_msg_last_put(struct kref *kref)
 		m->pagelist = NULL;
 	}
 
+	m->trail = NULL;
+
 	if (m->pool)
 		ceph_msgpool_put(m->pool, m);
 	else
diff --git a/fs/ceph/messenger.h b/fs/ceph/messenger.h
index 76fbc95..5a79450 100644
--- a/fs/ceph/messenger.h
+++ b/fs/ceph/messenger.h
@@ -82,6 +82,10 @@ struct ceph_msg {
 	struct ceph_pagelist *pagelist; /* instead of pages */
 	struct list_head list_head;
 	struct kref kref;
+	struct bio  *bio;		/* instead of pages/pagelist */
+	struct bio  *bio_iter;		/* bio iterator */
+	int bio_seg;			/* current bio segment */
+	struct ceph_pagelist *trail;	/* the trailing part of the data */
 	bool front_is_vmalloc;
 	bool more_to_follow;
 	bool needs_out_seq;
diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index ce7f7e0..8b1d0a6 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -6,12 +6,16 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#ifdef CONFIG_BLOCK
+#include <linux/bio.h>
+#endif
 
 #include "super.h"
 #include "osd_client.h"
 #include "messenger.h"
 #include "decode.h"
 #include "auth.h"
+#include "pagelist.h"
 
 #define OSD_OP_FRONT_LEN	4096
 #define OSD_OPREPLY_FRONT_LEN	512
@@ -22,29 +26,50 @@ static int __kick_requests(struct ceph_osd_client *osdc,
 
 static void kick_requests(struct ceph_osd_client *osdc, struct ceph_osd *osd);
 
+static int op_needs_trail(int op)
+{
+	switch (op) {
+	case CEPH_OSD_OP_GETXATTR:
+	case CEPH_OSD_OP_SETXATTR:
+	case CEPH_OSD_OP_CMPXATTR:
+	case CEPH_OSD_OP_CALL:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static int op_has_extent(int op)
+{
+	return (op == CEPH_OSD_OP_READ ||
+		op == CEPH_OSD_OP_WRITE);
+}
+
 void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
 			u64 snapid,
-			u64 off, u64 len, u64 *bno,
-			struct ceph_osd_request *req)
+			u64 off, u64 *plen, u64 *bno,
+			struct ceph_osd_request *req,
+			struct ceph_osd_req_op *op)
 {
 	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
-	struct ceph_osd_op *op = (void *)(reqhead + 1);
-	u64 orig_len = len;
+	u64 orig_len = *plen;
 	u64 objoff, objlen;    /* extent in object */
 
 	reqhead->snapid = cpu_to_le64(snapid);
 
 	/* object extent? */
-	ceph_calc_file_object_mapping(layout, off, &len, bno,
+	ceph_calc_file_object_mapping(layout, off, plen, bno,
 				      &objoff, &objlen);
-	if (len < orig_len)
+	if (*plen < orig_len)
 		dout(" skipping last %llu, final file extent %llu~%llu\n",
-		     orig_len - len, off, len);
+		     orig_len - *plen, off, *plen);
 
-	op->extent.offset = cpu_to_le64(objoff);
-	op->extent.length = cpu_to_le64(objlen);
-	req->r_num_pages = calc_pages_for(off, len);
+	if (op_has_extent(op->op)) {
+		op->extent.offset = objoff;
+		op->extent.length = objlen;
+	}
+	req->r_num_pages = calc_pages_for(off, *plen);
 
 	dout("calc_layout bno=%llx %llu~%llu (%d pages)\n",
 	     *bno, objoff, objlen, req->r_num_pages);
@@ -80,11 +105,13 @@ static void calc_layout(struct ceph_osd_client *osdc,
 			struct ceph_vino vino,
 			struct ceph_file_layout *layout,
 			u64 off, u64 *plen,
-			struct ceph_osd_request *req)
+			struct ceph_osd_request *req,
+			struct ceph_osd_req_op *op)
 {
 	u64 bno;
 
-	ceph_calc_raw_layout(osdc, layout, vino.snap, off, *plen, &bno, req);
+	ceph_calc_raw_layout(osdc, layout, vino.snap, off,
+			     plen, &bno, req, op);
 
 	sprintf(req->r_oid, "%llx.%08llx", vino.ino, bno);
 	req->r_oid_len = strlen(req->r_oid);
@@ -113,35 +140,64 @@ void ceph_osdc_release_request(struct kref *kref)
 	if (req->r_own_pages)
 		ceph_release_page_vector(req->r_pages,
 					 req->r_num_pages);
+#ifdef CONFIG_BLOCK
+	if (req->r_bio)
+		bio_put(req->r_bio);
+#endif
 	ceph_put_snap_context(req->r_snapc);
+	if (req->r_trail) {
+		ceph_pagelist_release(req->r_trail);
+		kfree(req->r_trail);
+	}
 	if (req->r_mempool)
 		mempool_free(req, req->r_osdc->req_mempool);
 	else
 		kfree(req);
 }
 
+static int op_needs_trail(int op)
+{
+	switch (op) {
+	case CEPH_OSD_OP_GETXATTR:
+	case CEPH_OSD_OP_SETXATTR:
+	case CEPH_OSD_OP_CMPXATTR:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static int get_num_ops(struct ceph_osd_req_op *ops, int *needs_trail)
+{
+	int i = 0;
+
+	if (needs_trail)
+		*needs_trail = 0;
+	while (ops[i].op) {
+		if (needs_trail && op_needs_trail(ops[i].op))
+			*needs_trail = 1;
+		i++;
+	}
+
+	return i;
+}
+
 struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       int flags,
 					       struct ceph_snap_context *snapc,
-					       int do_sync,
+					       struct ceph_osd_req_op *ops,
 					       bool use_mempool,
 					       gfp_t gfp_flags,
-					       struct page **pages)
+					       struct page **pages,
+					       struct bio *bio)
 {
 	struct ceph_osd_request *req;
 	struct ceph_msg *msg;
-	int num_op = 1 + do_sync;
-	size_t msg_size = sizeof(struct ceph_osd_request_head) +
-			  num_op*sizeof(struct ceph_osd_op);
+	int needs_trail;
+	int num_op = get_num_ops(ops, &needs_trail);
+	size_t msg_size = sizeof(struct ceph_osd_request_head);
 
-	if (use_mempool) {
-		req = mempool_alloc(osdc->req_mempool, gfp_flags);
-		memset(req, 0, sizeof(*req));
-	} else {
-		req = kzalloc(sizeof(*req), gfp_flags);
-	}
-	if (!req)
-		return NULL;
+	msg_size += num_op*sizeof(struct ceph_osd_op);
 
 	if (use_mempool) {
 		req = mempool_alloc(osdc->req_mempool, gfp_flags);
@@ -154,6 +210,7 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 
 	req->r_osdc = osdc;
 	req->r_mempool = use_mempool;
+
 	kref_init(&req->r_kref);
 	init_completion(&req->r_completion);
 	init_completion(&req->r_safe_completion);
@@ -174,6 +231,15 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 	}
 	req->r_reply = msg;
 
+	/* allocate space for the trailing data */
+	if (needs_trail) {
+		req->r_trail = kmalloc(sizeof(struct ceph_pagelist), gfp_flags);
+		if (!req->r_trail) {
+			ceph_osdc_put_request(req);
+			return NULL;
+		}
+		ceph_pagelist_init(req->r_trail);
+	}
 	/* create request message; allow space for oid */
 	msg_size += 40;
 	if (snapc)
@@ -186,38 +252,87 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 		ceph_osdc_put_request(req);
 		return NULL;
 	}
+
 	msg->hdr.type = cpu_to_le16(CEPH_MSG_OSD_OP);
 	memset(msg->front.iov_base, 0, msg->front.iov_len);
 
 	req->r_request = msg;
 	req->r_pages = pages;
+#ifdef CONFIG_BLOCK
+	if (bio) {
+		req->r_bio = bio;
+		bio_get(req->r_bio);
+	}
+#endif
 
 	return req;
 }
 
+static void osd_req_encode_op(struct ceph_osd_request *req,
+			      struct ceph_osd_op *dst,
+			      struct ceph_osd_req_op *src)
+{
+	dst->op = cpu_to_le16(src->op);
+
+	switch (dst->op) {
+	case CEPH_OSD_OP_READ:
+	case CEPH_OSD_OP_WRITE:
+		dst->extent.offset =
+			cpu_to_le64(src->extent.offset);
+		dst->extent.length =
+			cpu_to_le64(src->extent.length);
+		dst->extent.truncate_size =
+			cpu_to_le64(src->extent.truncate_size);
+		dst->extent.truncate_seq =
+			cpu_to_le32(src->extent.truncate_seq);
+		break;
+
+	case CEPH_OSD_OP_GETXATTR:
+	case CEPH_OSD_OP_SETXATTR:
+	case CEPH_OSD_OP_CMPXATTR:
+		BUG_ON(!req->r_trail);
+
+		dst->xattr.name_len = cpu_to_le32(src->xattr.name_len);
+		dst->xattr.value_len = cpu_to_le32(src->xattr.value_len);
+		dst->xattr.cmp_op = src->xattr.cmp_op;
+		dst->xattr.cmp_mode = src->xattr.cmp_mode;
+		ceph_pagelist_append(req->r_trail, src->xattr.name,
+				     src->xattr.name_len);
+		ceph_pagelist_append(req->r_trail, src->xattr.val,
+				     src->xattr.value_len);
+		break;
+	case CEPH_OSD_OP_STARTSYNC:
+		break;
+	default:
+		pr_err("unrecognized osd opcode %d\n", dst->op);
+		WARN_ON(1);
+		break;
+	}
+	dst->payload_len = cpu_to_le32(src->payload_len);
+}
+
 /*
  * build new request AND message
  *
  */
 void ceph_osdc_build_request(struct ceph_osd_request *req,
-			    u64 off, u64 *plen,
-			    int opcode,
-			    struct ceph_snap_context *snapc,
-			    int do_sync,
-			    u32 truncate_seq,
-			    u64 truncate_size,
-			    struct timespec *mtime,
-			    const char *oid,
-			    int oid_len)
+			     u64 off, u64 *plen,
+			     struct ceph_osd_req_op *src_ops,
+			     struct ceph_snap_context *snapc,
+			     struct timespec *mtime,
+			     const char *oid,
+			     int oid_len)
 {
 	struct ceph_msg *msg = req->r_request;
 	struct ceph_osd_request_head *head;
+	struct ceph_osd_req_op *src_op;
 	struct ceph_osd_op *op;
 	void *p;
-	int num_op = 1 + do_sync;
+	int num_op = get_num_ops(src_ops, NULL);
 	size_t msg_size = sizeof(*head) + num_op*sizeof(*op);
-	int i;
 	int flags = req->r_flags;
+	u64 data_len = 0;
+	int i;
 
 	head = msg->front.iov_base;
 	op = (void *)(head + 1);
@@ -230,25 +345,23 @@ void ceph_osdc_build_request(struct ceph_osd_request *req,
 	if (flags & CEPH_OSD_FLAG_WRITE)
 		ceph_encode_timespec(&head->mtime, mtime);
 	head->num_ops = cpu_to_le16(num_op);
-	op->op = cpu_to_le16(opcode);
 
-	if (flags & CEPH_OSD_FLAG_WRITE) {
-		req->r_request->hdr.data_off = cpu_to_le16(off);
-		req->r_request->hdr.data_len = cpu_to_le32(*plen);
-		op->payload_len = cpu_to_le32(*plen);
-	}
-	op->extent.truncate_size = cpu_to_le64(truncate_size);
-	op->extent.truncate_seq = cpu_to_le32(truncate_seq);
 
 	/* fill in oid */
 	head->object_len = cpu_to_le32(oid_len);
 	memcpy(p, oid, oid_len);
 	p += oid_len;
 
-	if (do_sync) {
+	src_op = src_ops;
+	while (src_op->op) {
+		osd_req_encode_op(req, op, src_op);
+		src_op++;
 		op++;
-		op->op = cpu_to_le16(CEPH_OSD_OP_STARTSYNC);
 	}
+
+	if (req->r_trail)
+		data_len += req->r_trail->length;
+
 	if (snapc) {
 		head->snap_seq = cpu_to_le64(snapc->seq);
 		head->num_snaps = cpu_to_le32(snapc->num_snaps);
@@ -258,6 +371,14 @@ void ceph_osdc_build_request(struct ceph_osd_request *req,
 		}
 	}
 
+	if (flags & CEPH_OSD_FLAG_WRITE) {
+		req->r_request->hdr.data_off = cpu_to_le16(off);
+		req->r_request->hdr.data_len = cpu_to_le32(*plen + data_len);
+	} else if (data_len) {
+		req->r_request->hdr.data_off = 0;
+		req->r_request->hdr.data_len = cpu_to_le32(data_len);
+	}
+
 	BUG_ON(p > msg->front.iov_base + msg->front.iov_len);
 	msg_size = p - msg->front.iov_base;
 	msg->front.iov_len = msg_size;
@@ -288,21 +409,34 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 					       struct timespec *mtime,
 					       bool use_mempool, int num_reply)
 {
-	struct ceph_osd_request *req =
-		ceph_osdc_alloc_request(osdc, flags,
-					 snapc, do_sync,
+	struct ceph_osd_req_op ops[3];
+	struct ceph_osd_request *req;
+
+	ops[0].op = opcode;
+	ops[0].extent.truncate_seq = truncate_seq;
+	ops[0].extent.truncate_size = truncate_size;
+	ops[0].payload_len = 0;
+
+	if (do_sync) {
+		ops[1].op = CEPH_OSD_OP_STARTSYNC;
+		ops[1].payload_len = 0;
+		ops[2].op = 0;
+	} else
+		ops[1].op = 0;
+
+	req = ceph_osdc_alloc_request(osdc, flags,
+					 snapc, ops,
 					 use_mempool,
-					 GFP_NOFS, NULL);
+					 GFP_NOFS, NULL, NULL);
 	if (IS_ERR(req))
 		return req;
 
 	/* calculate max write size */
-	calc_layout(osdc, vino, layout, off, plen, req);
+	calc_layout(osdc, vino, layout, off, plen, req, ops);
 	req->r_file_layout = *layout;  /* keep a copy */
 
-	ceph_osdc_build_request(req, off, plen, opcode,
-				snapc, do_sync,
-				truncate_seq, truncate_size,
+	ceph_osdc_build_request(req, off, plen, ops,
+				snapc,
 				mtime,
 				req->r_oid, req->r_oid_len);
 
@@ -1177,6 +1311,10 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 
 	req->r_request->pages = req->r_pages;
 	req->r_request->nr_pages = req->r_num_pages;
+#ifdef CONFIG_BLOCK
+	req->r_request->bio = req->r_bio;
+#endif
+	req->r_request->trail = req->r_trail;
 
 	register_request(osdc, req);
 
@@ -1493,6 +1631,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 		}
 		m->pages = req->r_pages;
 		m->nr_pages = req->r_num_pages;
+#ifdef CONFIG_BLOCK
+		m->bio = req->r_bio;
+#endif
 	}
 	*skip = 0;
 	req->r_con_filling_msg = ceph_con_get(con);
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index b687c2e..d583d1b 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -15,6 +15,7 @@ struct ceph_snap_context;
 struct ceph_osd_request;
 struct ceph_osd_client;
 struct ceph_authorizer;
+struct ceph_pagelist;
 
 /*
  * completion callback for async writepages
@@ -80,6 +81,11 @@ struct ceph_osd_request {
 	struct page     **r_pages;            /* pages for data payload */
 	int               r_pages_from_pool;
 	int               r_own_pages;        /* if true, i own page list */
+#ifdef CONFIG_BLOCK
+	struct bio       *r_bio;	      /* instead of pages */
+#endif
+
+	struct ceph_pagelist *r_trail;	      /* trailing part of the data */
 };
 
 struct ceph_osd_client {
@@ -110,6 +116,36 @@ struct ceph_osd_client {
 	struct ceph_msgpool	msgpool_op_reply;
 };
 
+struct ceph_osd_req_op {
+	u16 op;           /* CEPH_OSD_OP_* */
+	u32 flags;        /* CEPH_OSD_FLAG_* */
+	union {
+		struct {
+			u64 offset, length;
+			u64 truncate_size;
+			u32 truncate_seq;
+		} extent;
+		struct {
+			const char *name;
+			u32 name_len;
+			const char  *val;
+			u32 value_len;
+			__u8 cmp_op;       /* CEPH_OSD_CMPXATTR_OP_* */
+			__u8 cmp_mode;     /* CEPH_OSD_CMPXATTR_MODE_* */
+		} xattr;
+		struct {
+			__u8 class_len;
+			__u8 method_len;
+			__u8 argc;
+			u32 indata_len;
+		} cls;
+		struct {
+			u64 cookie, count;
+		} pgls;
+	};
+	u32 payload_len;
+};
+
 extern int ceph_osdc_init(struct ceph_osd_client *osdc,
 			  struct ceph_client *client);
 extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
@@ -122,27 +158,26 @@ extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 extern void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
 			u64 snapid,
-			u64 off, u64 len, u64 *bno,
-			struct ceph_osd_request *req);
+			u64 off, u64 *plen, u64 *bno,
+			struct ceph_osd_request *req,
+			struct ceph_osd_req_op *op);
 
 extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       int flags,
 					       struct ceph_snap_context *snapc,
-					       int do_sync,
+					       struct ceph_osd_req_op *ops,
 					       bool use_mempool,
 					       gfp_t gfp_flags,
-					       struct page **pages);
+					       struct page **pages,
+					       struct bio *bio);
 
 extern void ceph_osdc_build_request(struct ceph_osd_request *req,
-			    u64 off, u64 *plen,
-			    int opcode,
-			    struct ceph_snap_context *snapc,
-			    int do_sync,
-			    u32 truncate_seq,
-			    u64 truncate_size,
-			    struct timespec *mtime,
-			    const char *oid,
-			    int oid_len);
+				    u64 off, u64 *plen,
+				    struct ceph_osd_req_op *src_ops,
+				    struct ceph_snap_context *snapc,
+				    struct timespec *mtime,
+				    const char *oid,
+				    int oid_len);
 
 extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      struct ceph_file_layout *layout,
diff --git a/fs/ceph/pagelist.c b/fs/ceph/pagelist.c
index b6859f4..8170365 100644
--- a/fs/ceph/pagelist.c
+++ b/fs/ceph/pagelist.c
@@ -31,7 +31,7 @@ static int ceph_pagelist_addpage(struct ceph_pagelist *pl)
 	return 0;
 }
 
-int ceph_pagelist_append(struct ceph_pagelist *pl, void *buf, size_t len)
+int ceph_pagelist_append(struct ceph_pagelist *pl, const void *buf, size_t len)
 {
 	while (pl->room < len) {
 		size_t bit = pl->room;
diff --git a/fs/ceph/pagelist.h b/fs/ceph/pagelist.h
index e8a4187..cc9327a 100644
--- a/fs/ceph/pagelist.h
+++ b/fs/ceph/pagelist.h
@@ -19,7 +19,7 @@ static inline void ceph_pagelist_init(struct ceph_pagelist *pl)
 }
 extern int ceph_pagelist_release(struct ceph_pagelist *pl);
 
-extern int ceph_pagelist_append(struct ceph_pagelist *pl, void *d, size_t l);
+extern int ceph_pagelist_append(struct ceph_pagelist *pl, const void *d, size_t l);
 
 static inline int ceph_pagelist_encode_64(struct ceph_pagelist *pl, u64 v)
 {
-- 
1.7.0

