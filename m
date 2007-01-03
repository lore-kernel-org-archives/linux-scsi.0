From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] convert sg dio to use the block layer functions
Date: Wed, 03 Jan 2007 11:31:27 -0600
Message-ID: <459BE86F.1030000@cs.wisc.edu>
References: <20070103171742C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080106020706050601050504"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33034 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXACRcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Jan 2007 12:32:01 -0500
In-Reply-To: <20070103171742C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, hch@infradead.org

This is a multi-part message in MIME format.
--------------080106020706050601050504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

FUJITA Tomonori wrote:
> This patch makes sg dio use the block layer functions
> (blk_rq_map_user, blk_execute_rq_nowait, etc). It's an updated version
> of the following patch:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116527334121826&w=2
> 
> This doesn't break any existing features. While it converts sg dio to
> use the block layer functions, sg mmap and indirect io still use
> scsi_execute_async.
> 
> This is against the Linus' tree (uses the latest block layer API)
> since the scsi-misc is a bit out-of-data.
> 
> On a side note, Mike has been working on converting sg mmap and
> indirectio to the block layer functions.
> 

Yeah, so here is my work in progress patch. The patch does not work. I
messed up on some places where sg was abusing structures like where it
did something like this:

hp->flags = input_size; /* structure abuse ... */

I am still trying to figure out how to do the reserve buffer nicely and
at the same time implemenent the same behavior that sg had before. My
reserve buffer API sucks and so I am still working on it. My hack in
blk_rq_map_user to support all the different behavior of sg also sucks
and I am still working on that. So all in all the patch sucks and I am
still working on it :)

--------------080106020706050601050504
Content-Type: text/x-patch;
 name="convert-sg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="convert-sg.patch"

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index e07c079..c76374f 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -614,6 +614,165 @@ #endif
 
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
+static void free_reserve_buf(struct request_queue *q)
+{
+	struct blk_reserve_buf *buf = q->reserve_buf;
+	struct scatterlist *sg;
+	int i;
+
+	for (i = 0; i < buf->sg_count; i++) {
+		sg = &buf->sg[i];
+
+		if (sg->page)
+			__free_pages(sg->page, get_order(sg->length));
+	}
+
+	kfree(buf->sg);
+	kfree(buf);
+	q->reserve_buf = NULL;
+}
+
+/**
+ * blk_queue_free_reserve_buf - free reserve buffer
+ * @q: the request queue for the device
+ *
+ * It is the responsibility of the caller to make sure it is
+ * no longer processing requests that may be using the reserved
+ * buffer.
+ **/
+int blk_queue_free_reserve_buf(request_queue_t *q)
+{
+	if (!q->reserve_buf)
+		return -EINVAL;
+
+	if (test_and_set_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags))
+		return -EBUSY;
+
+	free_reserve_buf(q);
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_queue_free_reserve_buf);
+
+/**
+ * blk_queue_alloc_reserve_buf - allocate a buffer for pass through
+ * @q: the request queue for the device
+ * @buf_size: size of reserve buffer to allocate
+ *
+ * This is very simple for now. It is copied from sg.c because it is only
+ * meant to support what sg had supported.
+ **/
+int blk_queue_alloc_reserve_buf(request_queue_t *q, unsigned buf_size)
+{
+	struct blk_reserve_buf *buf;
+	struct page *p;
+	struct scatterlist *sg;
+	int order, i, remainder, allocated;
+
+	if (test_and_set_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags))
+		return -EBUSY;
+
+	printk(KERN_ERR "blk_queue_alloc_reserve_buf %u\n", buf_size);
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		goto clear_use;
+	q->reserve_buf = buf;
+	buf->buf_size = buf_size;
+	buf->sg_count = min(q->max_phys_segments, q->max_hw_segments);
+
+	buf->sg = kzalloc(buf->sg_count * sizeof(struct scatterlist),
+			  GFP_KERNEL);
+	if (!buf->sg)
+		goto free_buf;
+
+	for (i = 0, remainder = buf_size;
+	    (remainder > 0) && (i < buf->sg_count);
+	    ++i, remainder -= allocated) {
+		sg = &buf->sg[i];
+
+		allocated = remainder;
+		if (remainder > q->max_segment_size)
+			allocated = q->max_segment_size;
+
+		printk(KERN_ERR "try to allocate %d rem %d\n", allocated, remainder);
+
+		order = get_order(allocated);
+		p = alloc_pages(q->bounce_gfp | GFP_KERNEL, order);
+		/* divide by 2, until PAGE_SIZE */
+		while (!p && order) {
+			--order;
+			allocated >>= 1;
+			p = alloc_pages(q->bounce_gfp | GFP_KERNEL, order);
+		}
+
+		if (!p)
+			goto free_buf;
+
+		printk(KERN_ERR "got %d\n", allocated);
+
+
+		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+			memset(page_address(p), 0, allocated);
+
+		sg->page = p;
+		sg->length = allocated;
+	}
+
+	if (remainder > 0)
+		goto free_buf;
+
+	printk(KERN_ERR "used %d\n", i);
+
+	buf->sg_count = i;
+	return 0;
+
+free_buf:
+	free_reserve_buf(q);
+clear_use:
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(blk_queue_alloc_reserve_buf);
+
+/**
+ * blk_get_reserve_page - get page from the reserve buffer
+ * @q: the request queue for the device
+ *
+ * This assumes that caller is serializing access to the buffer.
+ **/
+struct page *blk_get_reserve_page(request_queue_t *q)
+{
+	struct blk_reserve_buf *buf = q->reserve_buf;
+	struct scatterlist *sg;
+	struct page *p;
+
+	if (!buf || buf->sg_index >= buf->sg_count) {
+		BUG();
+		return NULL;
+	}
+
+	printk(KERN_ERR "blk_get_reserve_page sgi %d pi %d\n",
+			buf->sg_index, buf->page_index);
+
+
+	sg = &buf->sg[buf->sg_index];
+	p = &sg->page[buf->page_index++];
+	if (buf->page_index << PAGE_SHIFT >= sg->length) {
+		buf->sg_index++;
+		buf->page_index = 0;
+	}
+
+
+	printk(KERN_ERR "blk_get_reserve_page sgi %d pi %d done\n",
+			buf->sg_index, buf->page_index);
+
+
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(blk_get_reserve_page);
+
 /**
  * blk_queue_max_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
@@ -2314,7 +2473,7 @@ void blk_insert_request(request_queue_t 
 
 EXPORT_SYMBOL(blk_insert_request);
 
-static int __blk_rq_unmap_user(struct bio *bio)
+static int __blk_rq_unmap_user(struct bio *bio, char __user **ubuf)
 {
 	int ret = 0;
 
@@ -2322,14 +2481,15 @@ static int __blk_rq_unmap_user(struct bi
 		if (bio_flagged(bio, BIO_USER_MAPPED))
 			bio_unmap_user(bio);
 		else
-			ret = bio_uncopy_user(bio);
+			ret = bio_uncopy_user(bio, ubuf);
 	}
 
 	return ret;
 }
 
 static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
-			     void __user *ubuf, unsigned int len)
+			     void __user *ubuf, unsigned int len,
+			     int copy_data, int use_reserve)
 {
 	unsigned long uaddr;
 	struct bio *bio, *orig_bio;
@@ -2342,10 +2502,11 @@ static int __blk_rq_map_user(request_que
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
+	if (!(uaddr & queue_dma_alignment(q)) &&
+	    !(len & queue_dma_alignment(q)) && !copy_data)
 		bio = bio_map_user(q, NULL, uaddr, len, reading);
 	else
-		bio = bio_copy_user(q, uaddr, len, reading);
+		bio = bio_copy_user(q, uaddr, len, reading, use_reserve);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
@@ -2376,7 +2537,7 @@ static int __blk_rq_map_user(request_que
 unmap_bio:
 	/* if it was boucned we must call the end io function */
 	bio_endio(bio, bio->bi_size, 0);
-	__blk_rq_unmap_user(orig_bio);
+	__blk_rq_unmap_user(orig_bio, NULL);
 	bio_put(bio);
 	return ret;
 }
@@ -2387,6 +2548,8 @@ unmap_bio:
  * @rq:		request structure to fill
  * @ubuf:	the user buffer
  * @len:	length of user data
+ * @copy_data	copy the data instead of trying to map it
+ * @use_reserve	use the reserve buffer for copying data
  *
  * Description:
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
@@ -2402,7 +2565,7 @@ unmap_bio:
  *    unmapping.
  */
 int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
-		    unsigned long len)
+		    unsigned long len, int copy_data, int use_reserve)
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
@@ -2413,6 +2576,19 @@ int blk_rq_map_user(request_queue_t *q, 
 	if (!len || !ubuf)
 		return -EINVAL;
 
+	if (use_reserve) {
+		if (!(rq->bio && test_bit(BIO_USE_RESERVE,
+					   &rq->bio->bi_flags)) ||
+		    test_and_set_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags))
+			return -EBUSY;
+
+		if (!q->reserve_buf ||
+		    q->reserve_buf->buf_size < rq->data_len + len) {
+			clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+			return -EINVAL;
+		}
+	}
+
 	while (bytes_read != len) {
 		unsigned long map_len, end, start;
 
@@ -2429,7 +2605,8 @@ int blk_rq_map_user(request_queue_t *q, 
 		if (end - start > BIO_MAX_PAGES)
 			map_len -= PAGE_SIZE;
 
-		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
+		ret = __blk_rq_map_user(q, rq, ubuf, map_len, copy_data,
+					use_reserve);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
@@ -2441,7 +2618,8 @@ int blk_rq_map_user(request_queue_t *q, 
 	rq->buffer = rq->data = NULL;
 	return 0;
 unmap_rq:
-	blk_rq_unmap_user(bio);
+	blk_rq_unmap_user(q, bio, NULL);
+	clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
 	return ret;
 }
 
@@ -2498,24 +2676,29 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
  * blk_rq_unmap_user - unmap a request with user data
+ * @q:		       request queue for device
  * @bio:	       start of bio list
+ * @buf:	       buffer to copy data back to if needed
  *
  * Description:
  *    Unmap a rq previously mapped by blk_rq_map_user(). The caller must
  *    supply the original rq->bio from the blk_rq_map_user() return, since
  *    the io completion may have changed rq->bio.
  */
-int blk_rq_unmap_user(struct bio *bio)
+int blk_rq_unmap_user(request_queue_t *q, struct bio *bio, char __user *ubuf)
 {
 	struct bio *mapped_bio;
-	int ret = 0, ret2;
+	int ret = 0, ret2, used_reserve = 0;
 
 	while (bio) {
 		mapped_bio = bio;
 		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
 			mapped_bio = bio->bi_private;
 
-		ret2 = __blk_rq_unmap_user(mapped_bio);
+		if (test_bit(BIO_USE_RESERVE, &mapped_bio->bi_flags))
+			used_reserve = 1;
+
+		ret2 = __blk_rq_unmap_user(mapped_bio, &ubuf);
 		if (ret2 && !ret)
 			ret = ret2;
 
@@ -2524,6 +2707,11 @@ int blk_rq_unmap_user(struct bio *bio)
 		bio_put(mapped_bio);
 	}
 
+	if (used_reserve) {
+		q->reserve_buf->sg_index = 0;
+		q->reserve_buf->page_index = 0;
+		clear_bit(QUEUE_FLAG_RESERVE_USED, &q->queue_flags);
+	}
 	return ret;
 }
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2528a0c..1865c2c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -297,7 +297,8 @@ static int sg_io(struct file *file, requ
 					  hdr->dxfer_len);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len,
+				      0, 0);
 
 	if (ret)
 		goto out;
@@ -333,7 +334,7 @@ static int sg_io(struct file *file, requ
 			hdr->sb_len_wr = len;
 	}
 
-	if (blk_rq_unmap_user(bio))
+	if (blk_rq_unmap_user(q, bio, hdr->dxferp))
 		ret = -EFAULT;
 
 	/* may not have succeeded, but output values written to control
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 66d028d..163a75d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2112,7 +2112,7 @@ static int cdrom_read_cdda_bpc(struct cd
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		ret = blk_rq_map_user(q, rq, ubuf, len);
+		ret = blk_rq_map_user(q, rq, ubuf, len, 0, 0);
 		if (ret)
 			break;
 
@@ -2139,7 +2139,7 @@ static int cdrom_read_cdda_bpc(struct cd
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio))
+		if (blk_rq_unmap_user(q, bio, ubuf))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 81e3bc7..7a88466 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -94,9 +94,6 @@ int sg_big_buff = SG_DEF_RESERVED_SIZE;
 static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
-static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
-
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
@@ -115,11 +112,7 @@ static struct class_interface sg_interfa
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
 	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
-	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
 	unsigned bufflen;	/* Size of (aggregate) data buffer */
-	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
-	struct scatterlist *buffer;/* scatter list */
-	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
 	unsigned char cmd_opcode; /* first byte of command */
 } Sg_scatter_hold;
 
@@ -133,6 +126,8 @@ typedef struct sg_request {	/* SG_MAX_QU
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
 	unsigned char sense_b[SCSI_SENSE_BUFFERSIZE];
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
+	struct request *request;
+	struct bio *bio;	/* ptr to bio for later unmapping */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
@@ -146,7 +141,6 @@ typedef struct sg_fd {		/* holds the sta
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	unsigned save_scat_len;	/* original length of trunc. scat. element */
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
@@ -173,38 +167,24 @@ typedef struct sg_device { /* holds the 
 
 static int sg_fasync(int fd, struct file *filp, int mode);
 /* tasklet or soft irq callback */
-static void sg_cmd_done(void *data, char *sense, int result, int resid);
+static void sg_cmd_done(struct request *rq, int uptodate);
 static int sg_start_req(Sg_request * srp);
 static void sg_finish_rem_req(Sg_request * srp);
-static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
-static int sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp,
-			 int tablesize);
 static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
 			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd * sfp, const char __user *buf, size_t count,
 			    int blocking, int read_only, Sg_request ** o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
-static int sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-		      int wr_xf, int *countp, unsigned char __user **up);
-static int sg_write_xfer(Sg_request * srp);
 static int sg_read_xfer(Sg_request * srp);
-static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
-static void sg_remove_scat(Sg_scatter_hold * schp);
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
-static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
-static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static struct page *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
-static void sg_page_free(struct page *page, int size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
 static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static int sg_allow_access(unsigned char opcode, char dev_type);
-static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
 static Sg_device *sg_get_dev(int dev);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
@@ -464,7 +444,8 @@ sg_read(struct file *filp, char __user *
 		if (count > old_hdr->reply_len)
 			count = old_hdr->reply_len;
 		if (count > SZ_SG_HEADER) {
-			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
+			if (blk_rq_unmap_user(sdp->device->request_queue,
+					      srp->bio, buf)) {
 				retval = -EFAULT;
 				goto free_old_hdr;
 			}
@@ -506,10 +487,6 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	}
 	if (hp->masked_status || hp->host_status || hp->driver_status)
 		hp->info |= SG_INFO_CHECK;
-	if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
-		err = -EFAULT;
-		goto err_out;
-	}
 	err = sg_read_xfer(srp);
       err_out:
 	sg_finish_rem_req(srp);
@@ -629,6 +606,7 @@ sg_new_write(Sg_fd * sfp, const char __u
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
+	struct request_queue *q;
 
 	if (count < SZ_SG_IO_HDR)
 		return -EINVAL;
@@ -650,6 +628,11 @@ sg_new_write(Sg_fd * sfp, const char __u
 		return -ENOSYS;
 	}
 	if (hp->flags & SG_FLAG_MMAP_IO) {
+		q = sfp->parentdp->device->request_queue;
+
+		if (!q->reserve_buf)
+			return -ENOMEM;
+
 		if (hp->dxfer_len > sfp->reserve.bufflen) {
 			sg_remove_request(sfp, srp);
 			return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
@@ -658,7 +641,10 @@ sg_new_write(Sg_fd * sfp, const char __u
 			sg_remove_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
-		if (sg_res_in_use(sfp)) {
+
+		/* TODO: this will be moved when the mmap code is moved */
+		if (test_and_set_bit(QUEUE_FLAG_RESERVE_USED,
+				     &q->queue_flags)) {
 			sg_remove_request(sfp, srp);
 			return -EBUSY;	/* reserve buffer already being used */
 		}
@@ -694,9 +680,11 @@ static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
 {
-	int k, data_dir;
+	int k;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
+	struct request_queue *q = sdp->device->request_queue;
+	struct request *rq;
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
 	hp->status = 0;
@@ -709,51 +697,48 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
 
+	/*
+	 * TODO: ask on linux-scsi. We used to use atomic for allocations
+	 * but we can sleep so maybe we really just wanted NOIO in case
+	 * this was used for some sort of failover.
+	 */
+	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV,
+			     GFP_NOIO);
+	if (!rq) {
+		SCSI_LOG_TIMEOUT(1,
+			printk("sg_write: Could not allocate request\n"));
+		return -ENOMEM;
+	}
+	srp->request = rq;
+
 	if ((k = sg_start_req(srp))) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if ((k = sg_write_xfer(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: write_xfer, bad address\n"));
-		sg_finish_rem_req(srp);
-		return k;
-	}
+	srp->bio = rq->bio;
+
 	if (sdp->detached) {
 		sg_finish_rem_req(srp);
 		return -ENODEV;
 	}
 
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_TO_FROM_DEV:
-	case SG_DXFER_FROM_DEV:
-		data_dir = DMA_FROM_DEVICE;
-		break;
-	case SG_DXFER_TO_DEV:
-		data_dir = DMA_TO_DEVICE;
-		break;
-	case SG_DXFER_UNKNOWN:
-		data_dir = DMA_BIDIRECTIONAL;
-		break;
-	default:
-		data_dir = DMA_NONE;
-		break;
-	}
-	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
-	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
-				hp->dxfer_len, srp->data.k_use_sg, timeout,
-				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
-				GFP_ATOMIC)) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: scsi_execute_async failed\n"));
-		/*
-		 * most likely out of mem, but could also be a bad map
-		 */
-		sg_finish_rem_req(srp);
-		return -ENOMEM;
-	} else
-		return 0;
+	memset(srp->sense_b, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense = srp->sense_b;
+	rq->sense_len = 0;
+	rq->cmd_len = hp->cmd_len;
+	memcpy(rq->cmd, cmnd, rq->cmd_len);
+	rq->timeout = timeout;
+	rq->retries = SG_DEFAULT_RETRIES;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_QUIET;
+	rq->end_io_data = srp;
+
+	hp->duration = jiffies_to_msecs(jiffies);
+	blk_execute_rq_nowait(q, NULL, rq, 1, sg_cmd_done);
+	return 0;
 }
 
 static int
@@ -842,14 +827,13 @@ sg_ioctl(struct inode *inode, struct fil
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		if (val) {
+		/*
+		 * we allocated pages with q->bounce_pfn so we do not need
+		 * to force this
+		 */
+		if (val)
 			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
-				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(&sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
+		else {
 			if (sdp->detached)
 				return -ENODEV;
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
@@ -918,13 +902,16 @@ sg_ioctl(struct inode *inode, struct fil
                 if (val < 0)
                         return -EINVAL;
 		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
+			if (sfp->mmap_called)
 				return -EBUSY;
-			sg_remove_scat(&sfp->reserve);
+			result = blk_queue_free_reserve_buf(sfp->parentdp->device->request_queue);
+			if (result)
+				return result;
 			sg_build_reserve(sfp, val);
 		}
 		return 0;
 	case SG_GET_RESERVED_SIZE:
+
 		val = (int) sfp->reserve.bufflen;
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
@@ -1142,6 +1129,8 @@ sg_fasync(int fd, struct file *filp, int
 	return (retval < 0) ? retval : 0;
 }
 
+#if 0
+
 static struct page *
 sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
 {
@@ -1158,8 +1147,8 @@ sg_vma_nopage(struct vm_area_struct *vma
 	offset = addr - vma->vm_start;
 	if (offset >= rsv_schp->bufflen)
 		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
-				   offset, rsv_schp->k_use_sg));
+	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu\n",
+				   offset));
 	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
 	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
@@ -1219,13 +1208,14 @@ sg_mmap(struct file *filp, struct vm_are
 	vma->vm_ops = &sg_mmap_vm_ops;
 	return 0;
 }
+#endif
 
 /* This function is a "bottom half" handler that is called by the
- * mid level when a command is completed (or has failed). */
+ * block layer when a command is completed (or has failed). */
 static void
-sg_cmd_done(void *data, char *sense, int result, int resid)
+sg_cmd_done(struct request *rq, int uptodate)
 {
-	Sg_request *srp = data;
+	Sg_request *srp = rq->end_io_data;
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
 	unsigned long iflags;
@@ -1233,6 +1223,7 @@ sg_cmd_done(void *data, char *sense, int
 
 	if (NULL == srp) {
 		printk(KERN_ERR "sg_cmd_done: NULL request\n");
+		__blk_put_request(rq->q, rq);
 		return;
 	}
 	sfp = srp->parentfp;
@@ -1240,34 +1231,33 @@ sg_cmd_done(void *data, char *sense, int
 		sdp = sfp->parentdp;
 	if ((NULL == sdp) || sdp->detached) {
 		printk(KERN_INFO "sg_cmd_done: device detached\n");
+		__blk_put_request(rq->q, rq);
 		return;
 	}
 
-
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, result));
-	srp->header.resid = resid;
+		sdp->disk->disk_name, srp->header.pack_id, rq->errors));
+	srp->header.resid = rq->data_len;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
 				(ms - srp->header.duration) : 0;
-	if (0 != result) {
+	if (0 != rq->errors) {
 		struct scsi_sense_hdr sshdr;
 
-		memcpy(srp->sense_b, sense, sizeof (srp->sense_b));
-		srp->header.status = 0xff & result;
-		srp->header.masked_status = status_byte(result);
-		srp->header.msg_status = msg_byte(result);
-		srp->header.host_status = host_byte(result);
-		srp->header.driver_status = driver_byte(result);
+		srp->header.status = 0xff & rq->errors;
+		srp->header.masked_status = status_byte(rq->errors);
+		srp->header.msg_status = msg_byte(rq->errors);
+		srp->header.host_status = host_byte(rq->errors);
+		srp->header.driver_status = driver_byte(rq->errors);
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
+			__scsi_print_sense("sg_cmd_done", srp->sense_b,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
-		if (driver_byte(result) != 0
-		    && scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)
+		if (driver_byte(rq->errors) != 0
+		    && scsi_normalize_sense(rq->sense, rq->sense_len, &sshdr)
 		    && !scsi_sense_is_deferred(&sshdr)
 		    && sshdr.sense_key == UNIT_ATTENTION
 		    && sdp->device->removable) {
@@ -1276,6 +1266,9 @@ sg_cmd_done(void *data, char *sense, int
 			sdp->device->changed = 1;
 		}
 	}
+
+	srp->request = NULL;
+	__blk_put_request(rq->q, rq);
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
 	if (sfp->closed) {	/* whoops this fd already released, cleanup */
@@ -1317,7 +1310,7 @@ #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
 	.open = sg_open,
-	.mmap = sg_mmap,
+//	.mmap = sg_mmap,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };
@@ -1540,7 +1533,6 @@ sg_remove(struct class_device *cl_dev, s
 		msleep(10);	/* dirty detach so delay device destruction */
 }
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
 module_param_named(def_reserved_size, def_reserved_size, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
@@ -1551,8 +1543,6 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
 
-MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element "
-                "size (default: max(SG_SCATTER_SZ, PAGE_SIZE))");
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
@@ -1561,10 +1551,6 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
-		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
 	else
@@ -1612,600 +1598,124 @@ #endif				/* CONFIG_SCSI_PROC_FS */
 static int
 sg_start_req(Sg_request * srp)
 {
-	int res;
-	Sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	struct request *rq = srp->request;
+	int ret, i, use_reserve;
+	struct sg_iovec iov;
+	struct sg_iovec __user *u_iov;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
+
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
-	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
-	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
-		res = sg_build_direct(srp, sfp, dxfer_len);
-		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
-			return res;
-	}
-	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
-		sg_link_reserve(sfp, srp, dxfer_len);
-	else {
-		res = sg_build_indirect(req_schp, sfp, dxfer_len);
-		if (res) {
-			sg_remove_scat(req_schp);
-			return res;
-		}
+	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count)) {	
+		ret = blk_rq_map_user(rq->q, rq, hp->dxferp, dxfer_len, 0, 0);
+		if (!ret)
+			return 0;
 	}
-	return 0;
-}
-
-static void
-sg_finish_rem_req(Sg_request * srp)
-{
-	Sg_fd *sfp = srp->parentfp;
-	Sg_scatter_hold *req_schp = &srp->data;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
-	if (srp->res_used)
-		sg_unlink_reserve(sfp, srp);
-	else
-		sg_remove_scat(req_schp);
-	sg_remove_request(sfp, srp);
-}
-
-static int
-sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
-{
-	int sg_bufflen = tablesize * sizeof(struct scatterlist);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
-
-	/*
-	 * TODO: test without low_dma, we should not need it since
-	 * the block layer will bounce the buffer for us
-	 *
-	 * XXX(hch): we shouldn't need GFP_DMA for the actual S/G list.
-	 */
-	if (sfp->low_dma)
-		 gfp_flags |= GFP_DMA;
-	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
-	if (!schp->buffer)
-		return -ENOMEM;
-	schp->sglist_len = sg_bufflen;
-	return tablesize;	/* number of scat_gath elements allocated */
-}
-
-#ifdef SG_ALLOW_DIO_CODE
-/* vvvvvvvv  following code borrowed from st driver's direct IO vvvvvvvvv */
-	/* TODO: hopefully we can use the generic block layer code */
-
-/* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
-   - mapping of all pages not successful
-   (i.e., either completely successful or fails)
-*/
-static int 
-st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
-	          unsigned long uaddr, size_t count, int rw)
-{
-	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
-	int res, i, j;
-	struct page **pages;
-
-	/* User attempted Overflow! */
-	if ((uaddr + count) < uaddr)
-		return -EINVAL;
-
-	/* Too big */
-        if (nr_pages > max_pages)
-		return -ENOMEM;
-
-	/* Hmm? */
-	if (count == 0)
-		return 0;
-
-	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_ATOMIC)) == NULL)
-		return -ENOMEM;
 
-        /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
-        /* rw==READ means read from drive, write into memory area */
-	res = get_user_pages(
-		current,
-		current->mm,
-		uaddr,
-		nr_pages,
-		rw == READ,
-		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
-
-	/* Errors and no page mapped should return here */
-	if (res < nr_pages)
-		goto out_unmap;
-
-        for (i=0; i < nr_pages; i++) {
-                /* FIXME: flush superflous for rw==READ,
-                 * probably wrong function for rw==WRITE
-                 */
-		flush_dcache_page(pages[i]);
-		/* ?? Is locking needed? I don't think so */
-		/* if (TestSetPageLocked(pages[i]))
-		   goto out_unlock; */
-        }
+	use_reserve = 1;
+	if (dxfer_len > srp->parentfp->reserve.bufflen)
+		use_reserve = 0;
 
-	sgl[0].page = pages[0];
-	sgl[0].offset = uaddr & ~PAGE_MASK;
-	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
-		for (i=1; i < nr_pages ; i++) {
-			sgl[i].page = pages[i]; 
-			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
-			count -= PAGE_SIZE;
+	if (!hp->iovec_count) {
+retry_single:
+		ret = blk_rq_map_user(rq->q, rq, hp->dxferp, dxfer_len, 1,
+				      use_reserve);
+		if (ret == -EBUSY && use_reserve == 1) {
+			use_reserve = 0;
+			goto retry_single;
 		}
-	}
-	else {
-		sgl[0].length = count;
-	}
-
-	kfree(pages);
-	return nr_pages;
-
- out_unmap:
-	if (res > 0) {
-		for (j=0; j < res; j++)
-			page_cache_release(pages[j]);
-		res = 0;
-	}
-	kfree(pages);
-	return res;
-}
+		if (use_reserve)
+			srp->res_used = 1;
 
-
-/* And unmap them... */
-static int 
-st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
-		    int dirtied)
-{
-	int i;
-
-	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
-
-		if (dirtied)
-			SetPageDirty(page);
-		/* unlock_page(page); */
-		/* FIXME: cache flush missing for rw==READ
-		 * FIXME: call the correct reference counting function
-		 */
-		page_cache_release(page);
-	}
-
-	return 0;
-}
-
-/* ^^^^^^^^  above code borrowed from st driver's direct IO ^^^^^^^^^ */
-#endif
-
-
-/* Returns: -ve -> error, 0 -> done, 1 -> try indirect */
-static int
-sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len)
-{
-#ifdef SG_ALLOW_DIO_CODE
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int mx_sc_elems, res;
-	struct scsi_device *sdev = sfp->parentdp->device;
-
-	if (((unsigned long)hp->dxferp &
-			queue_dma_alignment(sdev->request_queue)) != 0)
-		return 1;
-
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-        if (mx_sc_elems <= 0) {
-                return 1;
-        }
-	res = st_map_user_pages(schp->buffer, mx_sc_elems,
-				(unsigned long)hp->dxferp, dxfer_len, 
-				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0);
-	if (res <= 0) {
-		sg_remove_scat(schp);
-		return 1;
+		return ret;
 	}
-	schp->k_use_sg = res;
-	schp->dio_in_use = 1;
-	hp->info |= SG_INFO_DIRECT_IO;
-	return 0;
-#else
-	return 1;
-#endif
-}
-
-static int
-sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
-{
-	struct scatterlist *sg;
-	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int blk_size = buff_size;
-	struct page *p = NULL;
-
-	if ((blk_size < 0) || (!sfp))
-		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
-
-	/* N.B. ret_sz carried into this block ... */
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-	if (mx_sc_elems < 0)
-		return mx_sc_elems;	/* most likely -ENOMEM */
-
-	num = scatter_elem_sz;
-	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
-			scatter_elem_sz = PAGE_SIZE;
-			scatter_elem_sz_prev = PAGE_SIZE;
-		} else
-			scatter_elem_sz_prev = num;
-	}
-	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
-	     (rem_sz > 0) && (k < mx_sc_elems);
-	     ++k, rem_sz -= ret_sz, ++sg) {
-		
-		num = (rem_sz > scatter_elem_sz_prev) ?
-		      scatter_elem_sz_prev : rem_sz;
-		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
-		if (!p)
-			return -ENOMEM;
 
-		if (num == scatter_elem_sz_prev) {
-			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
-				scatter_elem_sz = ret_sz;
-				scatter_elem_sz_prev = ret_sz;
-			}
+	u_iov = hp->dxferp;
+	for (ret = 0, i = 0; i < hp->iovec_count; i++, u_iov++) {
+		if (copy_from_user(&iov, u_iov, sizeof(iov))) {
+			ret = -EFAULT;
+			goto unmap;
 		}
-		sg->page = p;
-		sg->length = (ret_sz > num) ? num : ret_sz;
-
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
-				 "ret_sz=%d\n", k, num, ret_sz));
-	}		/* end of for loop */
-
-	schp->k_use_sg = k;
-	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
-			 "rem_sz=%d\n", k, rem_sz));
-
-	schp->bufflen = blk_size;
-	if (rem_sz > 0)	/* must have failed */
-		return -ENOMEM;
 
-	return 0;
-}
-
-static int
-sg_write_xfer(Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
-	int iovec_count = (int) hp->iovec_count;
-	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
-	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
+		if (!iov.iov_len || !iov.iov_base) {
+			ret = -EINVAL;
+			goto unmap;
+		}
 
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
-	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
+retry_iov:
+		ret = blk_rq_map_user(rq->q, rq, iov.iov_base, iov.iov_len, 1,
+				      use_reserve);
+		if (ret == -EBUSY && use_reserve == 1) {
+			use_reserve = 0;
+			goto retry_iov;
+		} else
+			goto unmap;
 	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
-		return 0;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_write_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
-
-	ksglen = sg->length;
-	p = page_address(sg->page);
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
-		if (res)
-			return res;
-
-		for (; p; ++sg, ksglen = sg->length,
-		     p = page_address(sg->page)) {
-			if (usglen <= 0)
-				break;
-			if (ksglen > usglen) {
-				if (usglen >= num_xfer) {
-					if (__copy_from_user(p, up, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_from_user(p, up, usglen))
-					return -EFAULT;
-				p += usglen;
-				ksglen -= usglen;
-				break;
-			} else {
-				if (ksglen >= num_xfer) {
-					if (__copy_from_user(p, up, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_from_user(p, up, ksglen))
-					return -EFAULT;
-				up += ksglen;
-				usglen -= ksglen;
-			}
-			++k;
-			if (k >= schp->k_use_sg)
-				return 0;
-		}
-	}
+	if (use_reserve)
+		srp->res_used = 1;
 
 	return 0;
-}
-
-static int
-sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-	   int wr_xf, int *countp, unsigned char __user **up)
-{
-	int num_xfer = (int) hp->dxfer_len;
-	unsigned char __user *p = hp->dxferp;
-	int count;
 
-	if (0 == sg_num) {
-		if (wr_xf && ('\0' == hp->interface_id))
-			count = (int) hp->flags;	/* holds "old" input_size */
-		else
-			count = num_xfer;
-	} else {
-		sg_iovec_t iovec;
-		if (__copy_from_user(&iovec, p + ind*SZ_SG_IOVEC, SZ_SG_IOVEC))
-			return -EFAULT;
-		p = iovec.iov_base;
-		count = (int) iovec.iov_len;
-	}
-	if (!access_ok(wr_xf ? VERIFY_READ : VERIFY_WRITE, p, count))
-		return -EFAULT;
-	if (up)
-		*up = p;
-	if (countp)
-		*countp = count;
-	return 0;
+unmap:
+	blk_rq_unmap_user(rq->q, rq->bio, NULL);
+	return ret;
 }
 
 static void
-sg_remove_scat(Sg_scatter_hold * schp)
+sg_finish_rem_req(Sg_request * srp)
 {
-	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
-	if (schp->buffer && (schp->sglist_len > 0)) {
-		struct scatterlist *sg = schp->buffer;
+	Sg_fd *sfp = srp->parentfp;
 
-		if (schp->dio_in_use) {
-#ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sg, schp->k_use_sg, TRUE);
-#endif
-		} else {
-			int k;
-
-			for (k = 0; (k < schp->k_use_sg) && sg->page;
-			     ++k, ++sg) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg->page, sg->length));
-				sg_page_free(sg->page, sg->length);
-			}
-		}
-		kfree(schp->buffer);
-	}
-	memset(schp, 0, sizeof (*schp));
+	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req\n"));
+	if (srp->bio)
+		blk_rq_unmap_user(sfp->parentdp->device->request_queue,
+				 srp->bio, NULL);
+	srp->bio = NULL;
+	sg_remove_request(sfp, srp);
 }
 
 static int
 sg_read_xfer(Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
-	int iovec_count = (int) hp->iovec_count;
-	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
 	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
 
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_FROM_DEV == dxfer_dir)
-	    || (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = hp->dxfer_len;
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
-	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
+	if ((new_interface
 	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
 		return 0;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
-
-	p = page_address(sg->page);
-	ksglen = sg->length;
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
-		if (res)
-			return res;
-
-		for (; p; ++sg, ksglen = sg->length,
-		     p = page_address(sg->page)) {
-			if (usglen <= 0)
-				break;
-			if (ksglen > usglen) {
-				if (usglen >= num_xfer) {
-					if (__copy_to_user(up, p, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_to_user(up, p, usglen))
-					return -EFAULT;
-				p += usglen;
-				ksglen -= usglen;
-				break;
-			} else {
-				if (ksglen >= num_xfer) {
-					if (__copy_to_user(up, p, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_to_user(up, p, ksglen))
-					return -EFAULT;
-				up += ksglen;
-				usglen -= ksglen;
-			}
-			++k;
-			if (k >= schp->k_use_sg)
-				return 0;
-		}
-	}
-
-	return 0;
-}
-
-static int
-sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
-{
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int k, num;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
-				   num_read_xfer));
-	if ((!outp) || (num_read_xfer <= 0))
-		return 0;
-
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, ++sg) {
-		num = sg->length;
-		if (num > num_read_xfer) {
-			if (__copy_to_user(outp, page_address(sg->page),
-					   num_read_xfer))
-				return -EFAULT;
-			break;
-		} else {
-			if (__copy_to_user(outp, page_address(sg->page),
-					   num))
-				return -EFAULT;
-			num_read_xfer -= num;
-			if (num_read_xfer <= 0)
-				break;
-			outp += num;
-		}
-	}
-
-	return 0;
+	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer\n"));
+	return blk_rq_unmap_user(srp->parentfp->parentdp->device->request_queue,
+				 srp->bio, NULL);
 }
 
 static void
 sg_build_reserve(Sg_fd * sfp, int req_size)
 {
 	Sg_scatter_hold *schp = &sfp->reserve;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+	int ret;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_build_reserve: req_size=%d\n", req_size));
 	do {
 		if (req_size < PAGE_SIZE)
 			req_size = PAGE_SIZE;
-		if (0 == sg_build_indirect(schp, sfp, req_size))
+		ret = blk_queue_alloc_reserve_buf(q, req_size);
+		if (0 == ret) {
+			schp->k_use_sg = q->reserve_buf->sg_count;
+			schp->bufflen = req_size;
 			return;
+		} else if (ret == -EBUSY)
+			ssleep(1);
 		else
-			sg_remove_scat(schp);
-		req_size >>= 1;	/* divide by 2 */
-	} while (req_size > (PAGE_SIZE / 2));
-}
-
-static void
-sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
-{
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
-	struct scatterlist *sg = rsv_schp->buffer;
-	int k, num, rem;
-
-	srp->res_used = 1;
-	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
-	rem = size;
-
-	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
-		num = sg->length;
-		if (rem <= num) {
-			sfp->save_scat_len = num;
-			sg->length = rem;
-			req_schp->k_use_sg = k + 1;
-			req_schp->sglist_len = rsv_schp->sglist_len;
-			req_schp->buffer = rsv_schp->buffer;
-
-			req_schp->bufflen = size;
-			req_schp->b_malloc_len = rsv_schp->b_malloc_len;
-			break;
-		} else
-			rem -= num;
-	}
-
-	if (k >= rsv_schp->k_use_sg)
-		SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
-}
-
-static void
-sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
-{
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
-				   (int) req_schp->k_use_sg));
-	if ((rsv_schp->k_use_sg > 0) && (req_schp->k_use_sg > 0)) {
-		struct scatterlist *sg = rsv_schp->buffer;
-
-		if (sfp->save_scat_len > 0)
-			(sg + (req_schp->k_use_sg - 1))->length =
-			    (unsigned) sfp->save_scat_len;
-		else
-			SCSI_LOG_TIMEOUT(1, printk ("sg_unlink_reserve: BAD save_scat_len\n"));
-	}
-	req_schp->k_use_sg = 0;
-	req_schp->bufflen = 0;
-	req_schp->buffer = NULL;
-	req_schp->sglist_len = 0;
-	sfp->save_scat_len = 0;
-	srp->res_used = 0;
+                	req_size >>= 1; /* divide by 2 */
+        } while (req_size > (PAGE_SIZE / 2));
 }
 
 static Sg_request *
@@ -2370,8 +1880,8 @@ sg_add_sfp(Sg_device * sdp, int dev)
 		sg_big_buff = def_reserved_size;
 
 	sg_build_reserve(sfp, sg_big_buff);
-	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
-			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
+	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d\n",
+			   sfp->reserve.bufflen));
 	return sfp;
 }
 
@@ -2395,9 +1905,9 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
 	}
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6, 
-			printk("__sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
-			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
-		sg_remove_scat(&sfp->reserve);
+			printk("__sg_remove_sfp:    bufflen=%d\n",
+			(int) sfp->reserve.bufflen));
+			blk_queue_free_reserve_buf(sdp->device->request_queue);
 	}
 	sfp->parentdp = NULL;
 	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
@@ -2451,67 +1961,6 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
 	return res;
 }
 
-static int
-sg_res_in_use(Sg_fd * sfp)
-{
-	const Sg_request *srp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp = sfp->headrp; srp; srp = srp->nextrp)
-		if (srp->res_used)
-			break;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return srp ? 1 : 0;
-}
-
-/* The size fetched (value output via retSzp) set when non-NULL return */
-static struct page *
-sg_page_malloc(int rqSz, int lowDma, int *retSzp)
-{
-	struct page *resp = NULL;
-	gfp_t page_mask;
-	int order, a_size;
-	int resSz;
-
-	if ((rqSz <= 0) || (NULL == retSzp))
-		return resp;
-
-	if (lowDma)
-		page_mask = GFP_ATOMIC | GFP_DMA | __GFP_COMP | __GFP_NOWARN;
-	else
-		page_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
-
-	for (order = 0, a_size = PAGE_SIZE; a_size < rqSz;
-	     order++, a_size <<= 1) ;
-	resSz = a_size;		/* rounded up if necessary */
-	resp = alloc_pages(page_mask, order);
-	while ((!resp) && order) {
-		--order;
-		a_size >>= 1;	/* divide by 2, until PAGE_SIZE */
-		resp =  alloc_pages(page_mask, order);	/* try half */
-		resSz = a_size;
-	}
-	if (resp) {
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			memset(page_address(resp), 0, resSz);
-		*retSzp = resSz;
-	}
-	return resp;
-}
-
-static void
-sg_page_free(struct page *page, int size)
-{
-	int order, a_size;
-
-	if (!page)
-		return;
-	for (order = 0, a_size = PAGE_SIZE; a_size < size;
-	     order++, a_size <<= 1) ;
-	__free_pages(page, order);
-}
-
 #ifndef MAINTENANCE_IN_CMD
 #define MAINTENANCE_IN_CMD 0xa3
 #endif
diff --git a/fs/bio.c b/fs/bio.c
index 7618bcb..21a6602 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -453,7 +453,6 @@ int bio_add_page(struct bio *bio, struct
 
 struct bio_map_data {
 	struct bio_vec *iovecs;
-	void __user *userptr;
 };
 
 static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio)
@@ -483,30 +482,47 @@ static struct bio_map_data *bio_alloc_ma
 	return NULL;
 }
 
+static void free_bio_copy_page(struct bio *bio, struct page *p)
+{
+	if (!test_bit(BIO_USE_RESERVE, &bio->bi_flags))	
+		__free_page(p);
+}
+
 /**
  *	bio_uncopy_user	-	finish previously mapped bio
  *	@bio: bio being terminated
+ *	@buf: buffer to copy data back to
  *
  *	Free pages allocated from bio_copy_user() and write back data
  *	to user space in case of a read.
  */
-int bio_uncopy_user(struct bio *bio)
+int bio_uncopy_user(struct bio *bio, char __user **ubuf)
 {
 	struct bio_map_data *bmd = bio->bi_private;
 	const int read = bio_data_dir(bio) == READ;
+	char __user *dest_buf = NULL;
 	struct bio_vec *bvec;
 	int i, ret = 0;
+	unsigned int bytes_copied = 0;
+
+	if (ubuf)
+		dest_buf = *ubuf;
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *addr = page_address(bvec->bv_page);
 		unsigned int len = bmd->iovecs[i].bv_len;
 
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
+		if (read && !ret && dest_buf &&
+		    copy_to_user(dest_buf, addr, len))
 			ret = -EFAULT;
 
-		__free_page(bvec->bv_page);
-		bmd->userptr += len;
+		free_bio_copy_page(bio, bvec->bv_page);
+		dest_buf += len;
+		bytes_copied += len;
 	}
+	if (ubuf)
+		*ubuf = *ubuf + bytes_copied;
+
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
@@ -518,13 +534,14 @@ int bio_uncopy_user(struct bio *bio)
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@use_reserve: allocate page from the q's reserve buffer
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
 struct bio *bio_copy_user(request_queue_t *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm)
+			  unsigned int len, int write_to_vm, int use_reserve)
 {
 	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = uaddr >> PAGE_SHIFT;
@@ -538,14 +555,14 @@ struct bio *bio_copy_user(request_queue_
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
-	bmd->userptr = (void __user *) uaddr;
-
 	ret = -ENOMEM;
 	bio = bio_alloc(GFP_KERNEL, end - start);
 	if (!bio)
 		goto out_bmd;
 
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
+	if (use_reserve)
+		__set_bit(BIO_USE_RESERVE, &bio->bi_flags);
 
 	ret = 0;
 	while (len) {
@@ -554,7 +571,10 @@ struct bio *bio_copy_user(request_queue_
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
+		if (use_reserve)
+			page = blk_get_reserve_page(q);
+		else
+			page = alloc_page(q->bounce_gfp | GFP_KERNEL);
 		if (!page) {
 			ret = -ENOMEM;
 			break;
@@ -592,7 +612,7 @@ struct bio *bio_copy_user(request_queue_
 	return bio;
 cleanup:
 	bio_for_each_segment(bvec, bio, i)
-		__free_page(bvec->bv_page);
+		free_bio_copy_page(bio, bvec->bv_page);
 
 	bio_put(bio);
 out_bmd:
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 08daf32..f20d7fc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -125,6 +125,7 @@ #define BIO_CLONED	4	/* doesn't own data
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_USE_RESERVE 8	/* bio is using q's reserve buffer */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
@@ -310,8 +311,8 @@ extern struct bio *bio_map_kern(struct r
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-extern int bio_uncopy_user(struct bio *);
+extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int, int);
+extern int bio_uncopy_user(struct bio *, char __user **);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 36a6eac..e01a42d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -357,6 +357,14 @@ struct blk_queue_tag {
 	atomic_t refcnt;		/* map can be shared */
 };
 
+struct blk_reserve_buf {
+	struct scatterlist *sg;		/* sg to hold pages */
+	unsigned buf_size;		/* size of reserve buffer */
+	int sg_count;			/* number of sg entries in use */
+	int page_index;			/* index of page in current sg */
+	int sg_index;			/* index pf sg in list */
+};
+
 struct request_queue
 {
 	/*
@@ -452,6 +460,7 @@ struct request_queue
 	/*
 	 * sg stuff
 	 */
+	struct blk_reserve_buf *reserve_buf;
 	unsigned int		sg_timeout;
 	unsigned int		sg_reserved_size;
 	int			node;
@@ -479,6 +488,7 @@ #define QUEUE_FLAG_DEAD		5	/* queue bein
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_RESERVE_USED 9	/* sg reserve buffer in use */
 
 enum {
 	/*
@@ -523,6 +533,8 @@ enum {
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
+#define blk_queue_reserve_in_use(q) \
+	test_bit(QUEUE_FLAG_RESERVE_USED, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
@@ -671,11 +683,14 @@ extern void blk_sync_queue(struct reques
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
-extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
-extern int blk_rq_unmap_user(struct bio *);
+extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long, int, int);
+extern int blk_rq_unmap_user(request_queue_t *, struct bio *, char __user *);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *,
 			       struct sg_iovec *, int, unsigned int);
+extern int blk_queue_free_reserve_buf(request_queue_t *q);
+extern int blk_queue_alloc_reserve_buf(request_queue_t *q, unsigned buf_size);
+extern struct page *blk_get_reserve_page(request_queue_t *q);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(request_queue_t *, struct gendisk *,

--------------080106020706050601050504--
