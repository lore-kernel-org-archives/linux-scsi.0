From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SG_DXFER_TO_FROM_DEV does not copy user buffer to driver
 buffer in 	linux 2.6.28 and later?
Date: Tue, 30 Jun 2009 15:45:04 +0900
Message-ID: <20090630154455Q.fujita.tomonori@lab.ntt.co.jp>
References: <42a6d9690906281750i65c5c3ccy6bfac5e1055bae77@mail.gmail.com>
	<4A48A860.5010803@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36884 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZF3GpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 02:45:11 -0400
In-Reply-To: <4A48A860.5010803@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: sxzzsf@gmail.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, 29 Jun 2009 13:41:20 +0200
Douglas Gilbert <dgilbert@interlog.com> wrote:

> The semantics of SG_DXFER_TO_FROM_DEV were:
>    - copy user space buffer to kernel (LLD) buffer
>    - do SCSI command which is assumed to be of the DATA_IN
>      (data from device) variety. This would overwrite
>      some or all of the kernel buffer
>    - copy kernel (LLD) buffer back to the user space.
> 
> The idea was to detect short reads by filling the original
> user space buffer with some marker bytes ("0xec" it would
> seem in this report). The "resid" value is a better way
> of detecting short reads but that was only added this century
> and requires co-operation from the LLD.
> 
> There were major plumbing changes in the sg driver around
> lk 2.6.28 and it looks like the above nuance was lost.
> Perhaps the block layer does support the above "double
> shuffle".

Sorry, I overlooked SG_DXFER_TO_FROM_DEV.

Does this patch work?


diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8201387..8df3b6a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1658,6 +1658,10 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->nr_entries = req_schp->k_use_sg;
 		md->offset = 0;
 		md->null_mapped = hp->dxferp ? 0 : 1;
+		if (dxfer_dir == SG_DXFER_TO_FROM_DEV)
+			md->from_user = 1;
+		else
+			md->from_user = 0;
 	}
 
 	if (iov_count) {
diff --git a/fs/bio.c b/fs/bio.c
index 24c9140..e467dd8 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -705,14 +705,13 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
 }
 
 static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct sg_iovec *iov, int iov_count, int uncopy,
-			  int do_free_page)
+			  struct sg_iovec *iov, int iov_count,
+			  int to_user, int from_user, int do_free_page)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
 	int iov_idx = 0;
 	unsigned int iov_off = 0;
-	int read = bio_data_dir(bio) == READ;
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *bv_addr = page_address(bvec->bv_page);
@@ -727,13 +726,14 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 			iov_addr = iov[iov_idx].iov_base + iov_off;
 
 			if (!ret) {
-				if (!read && !uncopy)
-					ret = copy_from_user(bv_addr, iov_addr,
-							     bytes);
-				if (read && uncopy)
+				if (to_user)
 					ret = copy_to_user(iov_addr, bv_addr,
 							   bytes);
 
+				if (from_user)
+					ret = copy_from_user(bv_addr, iov_addr,
+							     bytes);
+
 				if (ret)
 					ret = -EFAULT;
 			}
@@ -770,7 +770,8 @@ int bio_uncopy_user(struct bio *bio)
 
 	if (!bio_flagged(bio, BIO_NULL_MAPPED))
 		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, 1, bmd->is_our_pages);
+				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+				     0, bmd->is_our_pages);
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
@@ -875,8 +876,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	/*
 	 * success
 	 */
-	if (!write_to_vm && (!map_data || !map_data->null_mapped)) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
+	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
+	    (map_data && map_data->from_user)) {
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8963d91..36c5ff8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -730,6 +730,7 @@ struct rq_map_data {
 	int nr_entries;
 	unsigned long offset;
 	int null_mapped;
+	int from_user;
 };
 
 struct req_iterator {
