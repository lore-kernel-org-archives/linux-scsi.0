Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE06EC43331
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F5F22241
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbhADKst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:48:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28723 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbhADKst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 05:48:49 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210104104805epoutp016d0eaaa1d434fe5a28f269f1ae325034~XAbjcVrbe2276822768epoutp01R
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:48:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210104104805epoutp016d0eaaa1d434fe5a28f269f1ae325034~XAbjcVrbe2276822768epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609757285;
        bh=PPSClpv1Inus0/GKv+it1uliGWLWNWW9wL06sUwpM2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiq7xcjMuYEGWOg3Vz/fDVPMHWa1gLTqykdfa7Wl4lS+VYPcXh02ZFjWs/CUw1mOm
         15cXi/lpeaXaSBGF8VORX7O5jidFmOYOYyfOxYnZNSl+gfQStozvjziaIUw7uWFbxU
         uobvoDp+WgWiA93IBAq2krVi15e8oPFDqGeEIaYg=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210104104804epcas5p1797005d1d4563f74e565f65a708d3b4c~XAbixXzMB2070620706epcas5p1B;
        Mon,  4 Jan 2021 10:48:04 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.EB.15682.462F2FF5; Mon,  4 Jan 2021 19:48:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49~XAW9rwd611643816438epcas5p43;
        Mon,  4 Jan 2021 10:42:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210104104249epsmtrp16448b254bd414e4929d2e7f1f2e25406~XAW9qpW7R1883718837epsmtrp1u;
        Mon,  4 Jan 2021 10:42:49 +0000 (GMT)
X-AuditID: b6c32a49-8d5ff70000013d42-01-5ff2f264abe2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.49.13470.921F2FF5; Mon,  4 Jan 2021 19:42:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210104104246epsmtip137d6dfe517af1c170f3a4abb46bd8681~XAW6jBBw21626316263epsmtip1J;
        Mon,  4 Jan 2021 10:42:46 +0000 (GMT)
From:   SelvaKumar S <selvakuma.s1@samsung.com>
To:     linux-nvme@lists.infradead.org
Cc:     kbusch@kernel.org, axboe@kernel.dk, damien.lemoal@wdc.com,
        Johannes.Thumshirn@wdc.com, hch@lst.de, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, mpatocka@redhat.com, hare@suse.de,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com, SelvaKumar S <selvakuma.s1@samsung.com>
Subject: [RFC PATCH v4 2/3] block: add simple copy support
Date:   Mon,  4 Jan 2021 16:11:58 +0530
Message-Id: <20210104104159.74236-3-selvakuma.s1@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104104159.74236-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUxTVxzNfe/x+mAre6vILh8TqRsRxqfAdmecjkTdExfjXKJRYV3XvoCz
        1KblWxOaMQHLVgQ3ooVMgqAZLmJpQaywkEIliM20gFikUCPsQ7eVFSlT+Zjtw8z/zv2dc+45
        v5tL4YJSMpQ6JM9llXKxTEgGEB290TFxUrdblNjeEYIuOqpIVDvzBEfHyz0Y6v67zg91NdZg
        6MeLFgw9GJ/loUXNBIYsy3+RqMZ8B6DusXfQkKmeRGfPT/NQ5WgniS70L2GoumIEQx3PzuJo
        +LtGHF165CKQ0zXKQ4/+HSBRmX4OfBjMDA3vZK7qHDzmlwk9wQxZ85i2lhMkY2gqYa7Z1STz
        z/QYwbh+HiEZrbEFMIbBo8xs2xqmvKcS280/ELBJysoO5bPKhM2fB2QvmAcIhdYACj0NFj81
        0NYADfCnIJ0C1cNfYxoQQAnoawBecT0kvISAdgPY0PMxR3gA7F666ffCUW/r8+OIbgBvlt1d
        OcwCaHE7fHaSjoN3mtp8OIgWwsXWrwivCKftOLQ9dfO8xCp6Ixz39PuKEPTb0Hy59nkRiuLT
        H8BpTzSXFgHP2OZ9cn96M6y5PeFrwadfhwNnpnz34881pe11uPd+SJ/zh/PHJwnOvBVqDXqc
        w6vgw34jj8Oh8I+qshVcAH894c31YjWAWlcBh7fA212Lvj44HQ1bTQnc+E34/Y1LGJcbCL99
        NrVi5cPOH6Z8ckhHwRtX3uXG4XCm10RyYwb+Xn2Me6pqAO3WBXASrNW9tI3upW10/wc3ALwF
        hLAKVU4Wq0pVJMnZgniVOEeVJ8+KlxzJaQO+fxqzoxM4nDPxZoBRwAwghQuD+IW3ZkQCvlRc
        VMwqj4iUeTJWZQZhFCF8g9+Z6BQJ6CxxLnuYZRWs8gWLUf6hamxtIRGrvfVp8jb7uHp7pH7T
        6i3H9i6MvJcizFju2x+bFlsr07zf9Il2Qn9Q7sgPNLYml8Vm3l84vy7RnNAMectRyxv6ijKC
        v6xKk1aEpFaWvBVJb9uHi6ke/Keoeps9KT4kfGz9UandFhixS7Ike+XU6XT94IViSbpWEhak
        Hj/VPMdKFaNPM4aytx4+Hd6e8JEz/7MG7ZPc7cVrTJmSyLnLqQpjxXXjjg7dvUZrkcbkMKok
        v937Zunc9XIxddcScbBwcNefiZGTzfV2vsgTtzq0RChLp3r3fGHLCl6/J5lMmU/avcHgfHW/
        mKy7nyHqGZ3MLLeGPbY+6HqsKn0trW+jkFBli5NicKVK/B8zKowAFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Rf0yMcRzH932e5557ujmersZXfnZSLuvS2Hxnfs0fPDcLs2Z+zHLy7DJd
        d+4pio2wqGuVO0Q/1t1OQjfJpZBIx6GTpLpKupCKreiSflglrmb677336/XZ+48PhYuqCR/q
        YHQMq4mWR4lJAVH6VDw/SNL3I3yZK3UpMjvTSZTh+oWjxHODGHr0PZuHyk16DN002zD0ubWf
        j8a0bRiyjX8jkd7aCNCjlqWoviyHRIb8Tj5KabpPousvfmNIl+TAUOmIAUcNF004KuzuJdDH
        3iY+6h6uItHZOwNg/UymvmEz8yDLyWfetN0hmPrXsYylIJlkivNOMg/fJZBMX2cLwfQ+dpBM
        2t0CwBS/Os70W+Yz556kYNuEuwWrD7BRB4+wmuC1+wSRo9YqQp1WDOIGjTZeAkjTAy3woCC9
        AubUPeNpgYAS0Q8BHLAP8CfBXHjLmUxOZi948/cX/qTUB2Dd6HvcDUg6CDbmWQh39qbFcOz2
        acIt4XQ/Dg1lZyeAF70Ktg6+mJgj6MXQWpSBaQFFCek1sHNQMjmwAGbWDU0Me9Brof5tG8+t
        iP4qpkQvdy2kPWFVZgfhrnE6AN7OFblr/O/lmZJs/DzwzJpiZf23sqZYRoAXgNmsmlMqlFyI
        OiSaPSrl5EouNlohjVApLWDi4YGS++BegUtqBRgFrABSuNhbGFfrChcJD8jjj7EaVbgmNorl
        rGAORYhnCWu1VeEiWiGPYQ+xrJrV/KMY5eGTgBn1bOq8SF6ZxT/JT3xhuaHw8M+7AVtk604V
        qjf6trdUD+VpHHbjyIxrP/N3yPSgff2u5p5xz0XHYhKnq9SGE+2nimpWsqG5zSayY4MiPlAQ
        9KTSdnpY3yhjcz58lbYaF6r3Dpfn9izG4kpUrnLFDN3lp5LllbrgpL7RCPuyndvXjCG/9HvN
        IobfJHQeveJ0pF/b5tjqPw+GNYVdveVzaU7RHpXM1xqTbL9RGTri0eDggrv2aPLfVJhncV2p
        S2zyitX7p5XGbx9/6enPSCMI+6tPRR2i5iHJXFOJIMA3mWyr2FCaKq2Zae72znueoquuYczP
        yR6lY+umrtGQb7VigouUhwTiGk7+B2Yy85BfAwAA
X-CMS-MailID: 20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
        <CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add new BLKCOPY ioctl that offloads copying of one or more sources
ranges to a destination in the device. Accepts copy_ranges that contains
destination, no of sources and pointer to the array of source
ranges. Each range_entry contains start and length of source
ranges (in bytes).

Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
bio with control information as payload and submit to the device.
REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
to zoned device.

If the device doesn't support copy or copy offload is disabled, then
copy is emulated by allocating memory of total copy size. The source
ranges are read into memory by chaining bio for each source ranges and
submitting them async and the last bio waits for completion. After data
is read, it is written to the destination.

bio_map_kern() is used to allocate bio and add pages of copy buffer to
bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
bio and over written, invalidate_kernel_vmap_range() for read is called
in the caller.

Introduce queue limits for simple copy and other helper functions.
Add device limits as sysfs entries.
	- copy_offload
	- max_copy_sectors
	- max_copy_ranges_sectors
	- max_copy_nr_ranges

copy_offload(= 0) is disabled by default.
max_copy_sectors = 0 indicates the device doesn't support native copy.

Native copy offload is not supported for stacked devices and is done via
copy emulation.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier González <javier.gonz@samsung.com>
---
 block/blk-core.c          |  94 ++++++++++++++--
 block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |   2 +
 block/blk-settings.c      |  10 ++
 block/blk-sysfs.c         |  50 +++++++++
 block/blk-zoned.c         |   1 +
 block/bounce.c            |   1 +
 block/ioctl.c             |  43 ++++++++
 include/linux/bio.h       |   1 +
 include/linux/blk_types.h |  15 +++
 include/linux/blkdev.h    |  13 +++
 include/uapi/linux/fs.h   |  13 +++
 12 files changed, 458 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 96e5fcd7f071..4a5cd3f53cd2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,6 +719,17 @@ static noinline int should_fail_bio(struct bio *bio)
 }
 ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
 
+static inline int bio_check_copy_eod(struct bio *bio, sector_t start,
+		sector_t nr_sectors, sector_t maxsector)
+{
+	if (nr_sectors && maxsector &&
+	    (nr_sectors > maxsector || start > maxsector - nr_sectors)) {
+		handle_bad_sector(bio, maxsector);
+		return -EIO;
+	}
+	return 0;
+}
+
 /*
  * Check whether this bio extends beyond the end of the device or partition.
  * This may well happen - the kernel calls bread() without checking the size of
@@ -737,6 +748,65 @@ static inline int bio_check_eod(struct bio *bio, sector_t maxsector)
 	return 0;
 }
 
+/*
+ * Check for copy limits and remap source ranges if needed.
+ */
+static int blk_check_copy(struct bio *bio)
+{
+	struct block_device *p = NULL;
+	struct request_queue *q = bio->bi_disk->queue;
+	struct blk_copy_payload *payload;
+	int i, maxsector, start_sect = 0, ret = -EIO;
+	unsigned short nr_range;
+
+	rcu_read_lock();
+
+	p = __disk_get_part(bio->bi_disk, bio->bi_partno);
+	if (unlikely(!p))
+		goto out;
+	if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
+		goto out;
+	if (unlikely(bio_check_ro(bio, p)))
+		goto out;
+
+	maxsector =  bdev_nr_sectors(p);
+	start_sect = p->bd_start_sect;
+
+	payload = bio_data(bio);
+	nr_range = payload->copy_range;
+
+	/* cannot handle copy crossing nr_ranges limit */
+	if (payload->copy_range > q->limits.max_copy_nr_ranges)
+		goto out;
+
+	/* cannot handle copy more than copy limits */
+	if (payload->copy_size > q->limits.max_copy_sectors)
+		goto out;
+
+	/* check if copy length crosses eod */
+	if (unlikely(bio_check_copy_eod(bio, bio->bi_iter.bi_sector,
+					payload->copy_size, maxsector)))
+		goto out;
+	bio->bi_iter.bi_sector += start_sect;
+
+	for (i = 0; i < nr_range; i++) {
+		if (unlikely(bio_check_copy_eod(bio, payload->range[i].src,
+					payload->range[i].len, maxsector)))
+			goto out;
+
+		/* single source range length limit */
+		if (payload->range[i].src > q->limits.max_copy_range_sectors)
+			goto out;
+		payload->range[i].src += start_sect;
+	}
+
+	bio->bi_partno = 0;
+	ret = 0;
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 /*
  * Remap block n of partition p to block n+start(p) of the disk.
  */
@@ -826,14 +896,16 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 	if (should_fail_bio(bio))
 		goto end_io;
 
-	if (bio->bi_partno) {
-		if (unlikely(blk_partition_remap(bio)))
-			goto end_io;
-	} else {
-		if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))
-			goto end_io;
-		if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
-			goto end_io;
+	if (likely(!op_is_copy(bio->bi_opf))) {
+		if (bio->bi_partno) {
+			if (unlikely(blk_partition_remap(bio)))
+				goto end_io;
+		} else {
+			if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))
+				goto end_io;
+			if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
+				goto end_io;
+		}
 	}
 
 	/*
@@ -857,6 +929,12 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 		if (!blk_queue_discard(q))
 			goto not_supported;
 		break;
+	case REQ_OP_COPY:
+		if (!blk_queue_copy(q))
+			goto not_supported;
+		if (unlikely(blk_check_copy(bio)))
+			goto end_io;
+		break;
 	case REQ_OP_SECURE_ERASE:
 		if (!blk_queue_secure_erase(q))
 			goto not_supported;
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 752f9c722062..4c0f12e2ed7c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -150,6 +150,229 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+int blk_copy_offload(struct block_device *bdev, struct blk_copy_payload *payload,
+		sector_t dest, gfp_t gfp_mask)
+{
+	struct bio *bio;
+	int ret, total_size;
+
+	bio = bio_alloc(gfp_mask, 1);
+	bio->bi_iter.bi_sector = dest;
+	bio->bi_opf = REQ_OP_COPY | REQ_NOMERGE;
+	bio_set_dev(bio, bdev);
+
+	total_size = struct_size(payload, range, payload->copy_range);
+	ret = bio_add_page(bio, virt_to_page(payload), total_size,
+					   offset_in_page(payload));
+	if (ret != total_size) {
+		ret = -ENOMEM;
+		bio_put(bio);
+		goto err;
+	}
+
+	ret = submit_bio_wait(bio);
+err:
+	bio_put(bio);
+	return ret;
+
+}
+
+int blk_read_to_buf(struct block_device *bdev, struct blk_copy_payload *payload,
+		gfp_t gfp_mask, void **buf_p)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio *bio, *parent = NULL;
+	void *buf = NULL;
+	bool is_vmalloc;
+	int i, nr_srcs, copy_len, ret, cur_size, t_len = 0;
+
+	nr_srcs = payload->copy_range;
+	copy_len = payload->copy_size << SECTOR_SHIFT;
+
+	buf = kvmalloc(copy_len, gfp_mask);
+	if (!buf)
+		return -ENOMEM;
+	is_vmalloc = is_vmalloc_addr(buf);
+
+	for (i = 0; i < nr_srcs; i++) {
+		cur_size = payload->range[i].len << SECTOR_SHIFT;
+
+		bio = bio_map_kern(q, buf + t_len, cur_size, gfp_mask);
+		if (IS_ERR(bio)) {
+			ret = PTR_ERR(bio);
+			goto out;
+		}
+
+		bio->bi_iter.bi_sector = payload->range[i].src;
+		bio->bi_opf = REQ_OP_READ;
+		bio_set_dev(bio, bdev);
+		bio->bi_end_io = NULL;
+		bio->bi_private = NULL;
+
+		if (parent) {
+			bio_chain(parent, bio);
+			submit_bio(parent);
+		}
+
+		parent = bio;
+		t_len += cur_size;
+	}
+
+	ret = submit_bio_wait(bio);
+	bio_put(bio);
+	if (is_vmalloc)
+		invalidate_kernel_vmap_range(buf, copy_len);
+	if (ret)
+		goto out;
+
+	*buf_p = buf;
+	return 0;
+out:
+	kvfree(buf);
+	return ret;
+}
+
+int blk_write_from_buf(struct block_device *bdev, void *buf, sector_t dest,
+		int copy_len, gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio *bio;
+	int ret;
+
+	bio = bio_map_kern(q, buf, copy_len, gfp_mask);
+	if (IS_ERR(bio)) {
+		ret = PTR_ERR(bio);
+		goto out;
+	}
+	bio_set_dev(bio, bdev);
+	bio->bi_opf = REQ_OP_WRITE;
+	bio->bi_iter.bi_sector = dest;
+
+	bio->bi_end_io = NULL;
+	ret = submit_bio_wait(bio);
+	bio_put(bio);
+out:
+	return ret;
+}
+
+int blk_prepare_payload(struct block_device *bdev, int nr_srcs, struct range_entry *rlist,
+		gfp_t gfp_mask, struct blk_copy_payload **payload_p)
+{
+
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct blk_copy_payload *payload;
+	sector_t bs_mask;
+	sector_t src_sects, len = 0, total_len = 0;
+	int i, ret, total_size;
+
+	if (!q)
+		return -ENXIO;
+
+	if (!nr_srcs)
+		return -EINVAL;
+
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+
+	total_size = struct_size(payload, range, nr_srcs);
+	payload = kmalloc(total_size, gfp_mask);
+	if (!payload)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_srcs; i++) {
+		/*  copy payload provided are in bytes */
+		src_sects = rlist[i].src;
+		if (src_sects & bs_mask) {
+			ret =  -EINVAL;
+			goto err;
+		}
+		src_sects = src_sects >> SECTOR_SHIFT;
+
+		if (len & bs_mask) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		len = rlist[i].len >> SECTOR_SHIFT;
+
+		total_len += len;
+
+		WARN_ON_ONCE((src_sects << 9) > UINT_MAX);
+
+		payload->range[i].src = src_sects;
+		payload->range[i].len = len;
+	}
+
+	/* storing # of source ranges */
+	payload->copy_range = i;
+	/* storing copy len so far */
+	payload->copy_size = total_len;
+
+	*payload_p = payload;
+	return 0;
+err:
+	kfree(payload);
+	return ret;
+}
+
+/**
+ * blkdev_issue_copy - queue a copy
+ * @bdev:       source block device
+ * @nr_srcs:	number of source ranges to copy
+ * @rlist:	array of source ranges (in bytes)
+ * @dest_bdev:	destination block device
+ * @dest:	destination (in bytes)
+ * @gfp_mask:   memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *	Copy array of source ranges from source block device to
+ *	destination block devcie.
+ */
+
+
+int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
+		struct range_entry *src_rlist, struct block_device *dest_bdev,
+		sector_t dest, gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct blk_copy_payload *payload;
+	sector_t bs_mask, dest_sect;
+	void *buf = NULL;
+	int ret;
+
+	ret = blk_prepare_payload(bdev, nr_srcs, src_rlist, gfp_mask, &payload);
+	if (ret)
+		return ret;
+
+	bs_mask = (bdev_logical_block_size(dest_bdev) >> 9) - 1;
+	if (dest & bs_mask) {
+		return -EINVAL;
+		goto out;
+	}
+	dest_sect = dest >> SECTOR_SHIFT;
+
+	if (bdev == dest_bdev && q->limits.copy_offload) {
+		ret = blk_copy_offload(bdev, payload, dest_sect, gfp_mask);
+		if (ret)
+			goto out;
+	} else {
+		ret = blk_read_to_buf(bdev, payload, gfp_mask, &buf);
+		if (ret)
+			goto out;
+		ret = blk_write_from_buf(dest_bdev, buf, dest_sect,
+				payload->copy_size << SECTOR_SHIFT, gfp_mask);
+	}
+
+	if (buf)
+		kvfree(buf);
+out:
+	kvfree(payload);
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_copy);
+
 /**
  * __blkdev_issue_write_same - generate number of bios with same page
  * @bdev:	target blockdev
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 808768f6b174..4e04f24e13c1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -309,6 +309,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 	struct bio *split = NULL;
 
 	switch (bio_op(*bio)) {
+	case REQ_OP_COPY:
+			break;
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 		split = blk_bio_discard_split(q, *bio, &q->bio_split, nr_segs);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 43990b1d148b..93c15ba45a69 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -60,6 +60,10 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
+	lim->copy_offload = 0;
+	lim->max_copy_sectors = 0;
+	lim->max_copy_nr_ranges = 0;
+	lim->max_copy_range_sectors = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -565,6 +569,12 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	if (b->chunk_sectors)
 		t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
 
+	/* simple copy not supported in stacked devices */
+	t->copy_offload = 0;
+	t->max_copy_sectors = 0;
+	t->max_copy_range_sectors = 0;
+	t->max_copy_nr_ranges = 0;
+
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
 		t->physical_block_size = t->logical_block_size;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b513f1683af0..51b35a8311d9 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -166,6 +166,47 @@ static ssize_t queue_discard_granularity_show(struct request_queue *q, char *pag
 	return queue_var_show(q->limits.discard_granularity, page);
 }
 
+static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.copy_offload, page);
+}
+
+static ssize_t queue_copy_offload_store(struct request_queue *q,
+				       const char *page, size_t count)
+{
+	unsigned long copy_offload;
+	ssize_t ret = queue_var_store(&copy_offload, page, count);
+
+	if (ret < 0)
+		return ret;
+
+	if (copy_offload < 0 || copy_offload > 1)
+		return -EINVAL;
+
+	if (q->limits.max_copy_sectors == 0 && copy_offload == 1)
+		return -EINVAL;
+
+	q->limits.copy_offload = copy_offload;
+	return ret;
+}
+
+static ssize_t queue_max_copy_sectors_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.max_copy_sectors, page);
+}
+
+static ssize_t queue_max_copy_range_sectors_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(q->limits.max_copy_range_sectors, page);
+}
+
+static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(q->limits.max_copy_nr_ranges, page);
+}
+
 static ssize_t queue_discard_max_hw_show(struct request_queue *q, char *page)
 {
 
@@ -591,6 +632,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
 QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
 QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
 
+QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
+QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");
+QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors");
+QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");
+
 QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
 QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
 QUEUE_RW_ENTRY(queue_poll, "io_poll");
@@ -636,6 +682,10 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_copy_offload_entry.attr,
+	&queue_max_copy_sectors_entry.attr,
+	&queue_max_copy_range_sectors_entry.attr,
+	&queue_max_copy_nr_ranges_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7a68b6e4300c..02069178d51e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -75,6 +75,7 @@ bool blk_req_needs_zone_write_lock(struct request *rq)
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_WRITE:
+	case REQ_OP_COPY:
 		return blk_rq_zone_is_seq(rq);
 	default:
 		return false;
diff --git a/block/bounce.c b/block/bounce.c
index d3f51acd6e3b..5e052afe8691 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -254,6 +254,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
 	switch (bio_op(bio)) {
+	case REQ_OP_COPY:
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
diff --git a/block/ioctl.c b/block/ioctl.c
index d61d652078f4..d50b6abe2883 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -133,6 +133,47 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 				    GFP_KERNEL, flags);
 }
 
+static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
+		unsigned long arg)
+{
+	struct copy_range crange;
+	struct range_entry *rlist;
+	struct request_queue *q = bdev_get_queue(bdev);
+	sector_t dest;
+	int ret;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (!blk_queue_copy(q))
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
+		return -EFAULT;
+
+	if (crange.dest & ((1 << SECTOR_SHIFT) - 1))
+		return -EFAULT;
+	dest = crange.dest;
+
+	rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
+			GFP_KERNEL);
+
+	if (!rlist)
+		return -ENOMEM;
+
+	if (copy_from_user(rlist, (void __user *)crange.range_list,
+				sizeof(*rlist) * crange.nr_range)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, dest,
+			GFP_KERNEL);
+out:
+	kfree(rlist);
+	return ret;
+}
+
 static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		unsigned long arg)
 {
@@ -458,6 +499,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 	case BLKSECDISCARD:
 		return blk_ioctl_discard(bdev, mode, arg,
 				BLKDEV_DISCARD_SECURE);
+	case BLKCOPY:
+		return blk_ioctl_copy(bdev, mode, arg);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
 	case BLKREPORTZONE:
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1edda614f7ce..164313bdfb35 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -71,6 +71,7 @@ static inline bool bio_has_data(struct bio *bio)
 static inline bool bio_no_advance_iter(const struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
+	       bio_op(bio) == REQ_OP_COPY ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
 	       bio_op(bio) == REQ_OP_WRITE_SAME ||
 	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 866f74261b3b..d4d11e9ff814 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -380,6 +380,8 @@ enum req_opf {
 	REQ_OP_ZONE_RESET	= 15,
 	/* reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	= 17,
+	/* copy ranges within device */
+	REQ_OP_COPY		= 19,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
@@ -506,6 +508,11 @@ static inline bool op_is_discard(unsigned int op)
 	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
 }
 
+static inline bool op_is_copy(unsigned int op)
+{
+	return (op & REQ_OP_MASK) == REQ_OP_COPY;
+}
+
 /*
  * Check if a bio or request operation is a zone management operation, with
  * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
@@ -565,4 +572,12 @@ struct blk_rq_stat {
 	u64 batch;
 };
 
+struct blk_copy_payload {
+	sector_t	dest;
+	int		copy_range;
+	int		copy_size;
+	int		err;
+	struct	range_entry	range[];
+};
+
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 81f9e7bec16c..4c7e861e57e4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -340,10 +340,14 @@ struct queue_limits {
 	unsigned int		max_zone_append_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
+	unsigned int		copy_offload;
+	unsigned int		max_copy_sectors;
 
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
+	unsigned short		max_copy_range_sectors;
+	unsigned short		max_copy_nr_ranges;
 
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
@@ -625,6 +629,7 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
+#define QUEUE_FLAG_COPY		30	/* supports copy */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP) |		\
@@ -647,6 +652,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
+#define blk_queue_copy(q)	test_bit(QUEUE_FLAG_COPY, &(q)->queue_flags)
 #define blk_queue_zone_resetall(q)	\
 	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
 #define blk_queue_secure_erase(q) \
@@ -1061,6 +1067,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
 
+	if (unlikely(op == REQ_OP_COPY))
+		return q->limits.max_copy_sectors;
+
 	if (unlikely(op == REQ_OP_WRITE_SAME))
 		return q->limits.max_write_same_sectors;
 
@@ -1335,6 +1344,10 @@ extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, int flags,
 		struct bio **biop);
 
+extern int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
+		struct range_entry *src_rlist, struct block_device *dest_bdev,
+		sector_t dest, gfp_t gfp_mask);
+
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index f44eb0a04afd..5cadb176317a 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -64,6 +64,18 @@ struct fstrim_range {
 	__u64 minlen;
 };
 
+struct range_entry {
+	__u64 src;
+	__u64 len;
+};
+
+struct copy_range {
+	__u64 dest;
+	__u64 nr_range;
+	__u64 range_list;
+	__u64 rsvd;
+};
+
 /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
 #define FILE_DEDUPE_RANGE_SAME		0
 #define FILE_DEDUPE_RANGE_DIFFERS	1
@@ -184,6 +196,7 @@ struct fsxattr {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+#define BLKCOPY _IOWR(0x12, 128, struct copy_range)
 /*
  * A jump here: 130-131 are reserved for zoned block devices
  * (see uapi/linux/blkzoned.h)
-- 
2.25.1

