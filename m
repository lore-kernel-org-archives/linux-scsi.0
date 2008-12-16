From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Wed, 17 Dec 2008 02:56:22 +0900
Message-ID: <20081217025655O.fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812152138090.6315@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38719 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLPR4k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 12:56:40 -0500
In-Reply-To: <alpine.LNX.2.00.0812152138090.6315@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 16 Dec 2008 00:24:27 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Thu, 11 Dec 2008, FUJITA Tomonori wrote:
> 
> > This patchset is the second half of the patchset to remove
> > scsi_execute_async in st driver. IOW, this converts st driver to use
> > the block layer functions.
> > 
> > st driver uses scsi_execute_async for two purposes, performing sort
> > management SCSI commands internally and data transfer between user and
> > kernel space (st_read and st_write). The former was converted and this
> > converts the latter.
> > 
> I have looked at this patch set and run some tests. The patches make 
> st_do_scsi() do everything it used to do before your patch sets. So, I 
> could not resist making a patch that obsoletes st_scsi_kern_execute() from 
> your first patch set :-) The patch is at the end of this message.

I have to admit that I thought about the same thing. :)

I prefer symmetric APIs (e.g. st_do_scsi always needs st_request or
st_allocate/release_request are used in st_do_scsi) but yeah, I agree
that your patch makes st look much prettier.


> The simple tests pass without problems. Unfortunately, the same does not 
> apply to tests with bigger blocks. I wrote some data to tape and read it 
> with dd. Whenever the block size exceeded 1 MB, I got data corruption just 
> after the 1 MB limit.

Ah, really sorry about that.


> This reminds me of something from the "old days". IIRC, one bio can map 
> 256 pages. With 4 kB page this makes 1 MB. st had to use chained bios to 
> go beyond 1 MB block size. Does the new method do this?

Yes, you are right. The new method (the block layer API) support the
partial mapping but I put a bug in the path.

Can you replace the first and second patches in the patchset with the
following patch (that is, scsi-misc and this patch + #3-13 patches in
the patchset)?

Thanks,


diff --git a/block/blk-map.c b/block/blk-map.c
index 0f4b4b8..01bd7ca 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -42,7 +42,7 @@ static int __blk_rq_unmap_user(struct bio *bio)
 
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     struct rq_map_data *map_data, void __user *ubuf,
-			     unsigned int len, int null_mapped, gfp_t gfp_mask)
+			     unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long uaddr;
 	struct bio *bio, *orig_bio;
@@ -63,7 +63,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (null_mapped)
+	if (map_data && map_data->null_mapped)
 		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
 
 	orig_bio = bio;
@@ -114,17 +114,15 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
-	int ret, null_mapped = 0;
+	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (!ubuf) {
-		if (!map_data || rq_data_dir(rq) != READ)
-			return -EINVAL;
-		null_mapped = 1;
-	}
+
+	if (!ubuf && (!map_data || !map_data->null_mapped))
+		return -EINVAL;
 
 	while (bytes_read != len) {
 		unsigned long map_len, end, start;
@@ -143,13 +141,16 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 			map_len -= PAGE_SIZE;
 
 		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
-					null_mapped, gfp_mask);
+					gfp_mask);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
 			bio = rq->bio;
 		bytes_read += ret;
 		ubuf += ret;
+
+		if (map_data)
+			map_data->offset += ret;
 	}
 
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5103855..820a228 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1669,6 +1669,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->pages = req_schp->pages;
 		md->page_order = req_schp->page_order;
 		md->nr_entries = req_schp->k_use_sg;
+		md->null_mapped = hp->dxferp ? 0 : 1;
 	}
 
 	if (iov_count)
diff --git a/fs/bio.c b/fs/bio.c
index 77a55bc..ca1813b 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -635,6 +635,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	int i, ret;
 	int nr_pages = 0;
 	unsigned int len = 0;
+	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK: 0;
 
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr;
@@ -661,24 +662,29 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	ret = 0;
-	i = 0;
+
+	if (map_data) {
+		nr_pages = 1 << map_data->page_order;
+		i = map_data->offset / PAGE_SIZE;
+	}
 	while (len) {
-		unsigned int bytes;
+		unsigned int bytes = PAGE_SIZE;
 
-		if (map_data)
-			bytes = 1U << (PAGE_SHIFT + map_data->page_order);
-		else
-			bytes = PAGE_SIZE;
+		bytes -= offset;
 
 		if (bytes > len)
 			bytes = len;
 
 		if (map_data) {
-			if (i == map_data->nr_entries) {
+			if (i == map_data->nr_entries * nr_pages) {
 				ret = -ENOMEM;
 				break;
 			}
-			page = map_data->pages[i++];
+
+			page = map_data->pages[i / nr_pages];
+			page += (i % nr_pages);
+
+			i++;
 		} else
 			page = alloc_page(q->bounce_gfp | gfp_mask);
 		if (!page) {
@@ -686,10 +692,11 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 			break;
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
+		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
 			break;
 
 		len -= bytes;
+		offset = 0;
 	}
 
 	if (ret)
@@ -698,7 +705,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	/*
 	 * success
 	 */
-	if (!write_to_vm) {
+	if (!write_to_vm && (!map_data || !map_data->null_mapped)) {
 		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
 		if (ret)
 			goto cleanup;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a135256..f11c3d0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -680,6 +680,8 @@ struct rq_map_data {
 	struct page **pages;
 	int page_order;
 	int nr_entries;
+	unsigned long offset;
+	int null_mapped;
 };
 
 struct req_iterator {
