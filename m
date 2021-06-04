Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E423C47097
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ADBC61359
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFDFXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 01:23:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13458 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhFDFXu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 01:23:50 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210604052202epoutp039573d70efd4ce6cc516f91d5cbe80aa8~FSY-HfC4j1445914459epoutp03v
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 05:22:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210604052202epoutp039573d70efd4ce6cc516f91d5cbe80aa8~FSY-HfC4j1445914459epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622784122;
        bh=Z5gPkkkwNmkerIkN8A6SpUu5QE5hqC0QGYq+H7582yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ/1JyIgjnRylcNozkbDAzgG56HlkIDmH21NPy181TLl6Jd/zylj0c9jeWm2KQa7a
         FRL6vd7tUdscvW9/gsX7JTaMbTp384e08C7dYPmHNxeAQ0aHoqK9xTZ63vkABVwmqS
         eVGwg9B1pYI086SVfRZxPoAtBNhlmqt6o1toRwKw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604052200epcas1p10927392bc76b5389fff7e85b92972e35~FSY9hYDgT2530225302epcas1p1O;
        Fri,  4 Jun 2021 05:22:00 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.165]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FxB2v4CYMz4x9Q6; Fri,  4 Jun
        2021 05:21:59 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.75.09578.778B9B06; Fri,  4 Jun 2021 14:21:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210604052159epcas1p4370bee98aad882ab335dda1565db94fb~FSY70cdHZ2130721307epcas1p4Y;
        Fri,  4 Jun 2021 05:21:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210604052159epsmtrp2483687fa9bc6c0402628969aec0a5cc6~FSY7yOIyp3141131411epsmtrp2a;
        Fri,  4 Jun 2021 05:21:59 +0000 (GMT)
X-AuditID: b6c32a35-fcfff7000000256a-0a-60b9b8771f45
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.6E.08163.678B9B06; Fri,  4 Jun 2021 14:21:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210604052158epsmtip1cb265bbb9d65fd9ad6d7fa7d75c088c7~FSY7iCoi-0136401364epsmtip1T;
        Fri,  4 Jun 2021 05:21:58 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        cang@codeaurora.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        bvanassche@acm.org, damien.lemoal@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org, jaegeuk@kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com, osandov@fb.com,
        patchwork-bot@kernel.org, tj@kernel.org, tom.leiming@gmail.com,
        yi.zhang@redhat.com
Cc:     jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com, Changheun Lee <nanich.lee@samsung.com>
Subject: [PATCH v12 1/3] bio: control bio max size
Date:   Fri,  4 Jun 2021 14:03:22 +0900
Message-Id: <20210604050324.28670-2-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210604050324.28670-1-nanich.lee@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TaVBTVxTH576XvAQ71EdAucO0FtPqFGRJCMtVwQFRfIOW0tp+aGcceIVX
        goYkTQKttbZgWGSHCWAbQBAoOmihIIWAxdogg1hgimyVspbFAWQRKmXTaUig5ds59/z+5z/n
        3DlcnFfPseGGS1WMQkpL+MQOVk2jnaPj57q6YEH+1B5U3n+Lg4av1hAor6wGoMmVbgLdHEgn
        UH1HAUA58ys4WqgoZaO4hCUMqYsrCPRbRhGGxiq0OCr6owZDKWOX2OhF0iCGno8oUUPfAdRZ
        n0eg5F4dga43v8SQXqPG0JXbeTjqGWrloMbBbhYaKcnEUXvLAhtdHfVGq9ebAJpb7uWghzoN
        jnrbcwhU0bBCeNtSnV0nqc60VIzKVM9yqDrtAIe6fcOe6myLpKrKEgkqo+geoH7Jv8Whno33
        sai5u90ElVZdBqjFqj1Uwr1kjNLrS/HAnR9LPMUMHcoobBlpiCw0XBrmxT95Osg3yM1dIHQU
        HkQefFspHcF48Y+dCnT0C5cY9sW3jaIlkYanQFqp5Dsf8VTIIlWMrVimVHnxGXmoRC4UyJ2U
        dIQyUhrmFCKLOCQUCFzcDGSwRDyQNonLp72/mHrUwo4GOkESMONC0hXG9j/Ek8AOLo/UAdj+
        9xJmShYAHB1pZJuSRQA1v/ZgW5LCxBpgKtQD2HyjA/uPypuYZW9QBOkA02b6iI2CFVnFgp2J
        l40SnBwFsKslntigLEkXWNj6DN+IWeQ+2DgYx9qIzcnDcGI5lmPyewOuD6UYGTPSE/bcT8ZM
        jAVs+W7MyOMGRv1TrnEMSE6YwRzNKMskPgY1mQPAFFvCqebqzaY2cHG2gTAJkgFUxxcAU5IB
        YMmT0s1RRXBhcdFQ4Bos7GBFvbPpeS+sW8sHJudX4ezzFPYGAklzeDmeZ0Legq2xQ/iW15Mf
        6jY7UnCp7XvjinhkOoD5wyAD2Gq3zaPdNo/2f+NCgJeB3YxcGRHGKIVy4fZfrgLGI7J304HM
        mXknPcC4QA8gF+dbmf+8XxfMMw+lz3/JKGRBikgJo9QDN8O2M3GbXSEywxVKVUFCNxeRSIRc
        3T3c3UR8a/Mw3wvBPDKMVjHnGEbOKLZ0GNfMJhobC48g72Qn76wSZ92M6fBz/0zp50Pc38sP
        dIjCqhc0FXe/7kpeeN+z8VN7jw+Ga5bL17Gvsmf52OtW77X5XLqYa3H8fLx1w/4A5ooPM1mS
        8tqHZ1OK6Y9izqyJ9LE+n2BSxfhccJE2IqCSKTgQVfyPhf9pFftBesDA+Nv0U6HHekl3Z9m7
        dmFHB8Prz07P+jKaJnct6Nvd74g9ii2SLPs3NdCHT8W/ENSqHteyS1MX16f3aYXWMe+c2DV/
        ZrXld3Hbg+w6deu1l38dXGXfeSXX603/QN7xtfDamENHy//80TX625hU7pGE6bhz5IylmvP4
        onfc02+8mpccKiudBy9cyzqRZcdnKcW00B5XKOl/ARMCePHNBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWy7bCSnG7Zjp0JBke/WFqsu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBl3+14yF7x2qHh16SRrA+MOgy5G
        Tg4JAROJBZ3bGLsYuTiEBHYwSlx6OZ0NIiElcfzEW9YuRg4gW1ji8OFiiJqPjBJLH1xmAalh
        E9CR6Ht7iw0kISJwgUViQ9sbZhCHWeA1o0TX40VgVcICRhILznxkBrFZBFQlDt9rBYvzClhL
        PPvRwg6xTV7iz/0esBpOARuJa0e6mUBsIaCamQcuskPUC0qcnPkErJcZqL5562zmCYwCs5Ck
        ZiFJLWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJEZwqtLR2MO5Z9UHvECMTB+Mh
        RgkOZiUR3j1qOxKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi
        4JRqYGJyvlDzQ76bj43t5OnD79KcJqQsu1l9XWztrya//KWLJv3fsFCaz1184TvTLL2ggx1L
        +NfXFmnZaD7dUlBV0H1k0ccTPamy7aHCbgvjttVlNuion3kmm2vQ9+QrU0pWz8SlZ6tWzkzV
        zmJ+9M+5LGgiz+TSX+IfuEsDY5sbtLqfTXDe3Msffvm2xfmCDRZcLK6zXfe5zFPcHBEmJChR
        mP9YJsP//lQRIz6l6rnXb/5kT2t0nO2dO786e/r7C+nnLWb+2BX95t0io0ZL021rhZfPvTBh
        klOmauKU8/0Kh3m3LAn9YlU394TQzWBht9aue+GfjNozhIwu2Lsfm/V37SbzM5Pe8zNltXWm
        XjaRUGIpzkg01GIuKk4EAG+o8xGEAwAA
X-CMS-MailID: 20210604052159epcas1p4370bee98aad882ab335dda1565db94fb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210604052159epcas1p4370bee98aad882ab335dda1565db94fb
References: <20210604050324.28670-1-nanich.lee@samsung.com>
        <CGME20210604052159epcas1p4370bee98aad882ab335dda1565db94fb@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

bio size can grow up to 4GB after muli-page bvec has been enabled.
But sometimes large size of bio would lead to inefficient behaviors.
Control of bio max size will be helpful to improve inefficiency.

Below is a example for inefficient behaviours.
In case of large chunk direct I/O, - 32MB chunk read in user space -
all pages for 32MB would be merged to a bio structure if the pages
physical addresses are contiguous. It makes some delay to submit
until merge complete. bio max size should be limited to a proper size.

When 32MB chunk read with direct I/O option is coming from userspace,
kernel behavior is below now in do_direct_IO() loop. It's timeline.

 | bio merge for 32MB. total 8,192 pages are merged.
 | total elapsed time is over 2ms.
 |------------------ ... ----------------------->|
                                                 | 8,192 pages merged a bio.
                                                 | at this time, first bio submit is done.
                                                 | 1 bio is split to 32 read request and issue.
                                                 |--------------->
                                                  |--------------->
                                                   |--------------->
                                                              ......
                                                                   |--------------->
                                                                    |--------------->|
                          total 19ms elapsed to complete 32MB read done from device. |

If bio max size is limited with 1MB, behavior is changed below.

 | bio merge for 1MB. 256 pages are merged for each bio.
 | total 32 bio will be made.
 | total elapsed time is over 2ms. it's same.
 | but, first bio submit timing is fast. about 100us.
 |--->|--->|--->|---> ... -->|--->|--->|--->|--->|
      | 256 pages merged a bio.
      | at this time, first bio submit is done.
      | and 1 read request is issued for 1 bio.
      |--------------->
           |--------------->
                |--------------->
                                      ......
                                                 |--------------->
                                                  |--------------->|
        total 17ms elapsed to complete 32MB read done from device. |

As a result, read request issue timing is faster if bio max size is limited.
Current kernel behavior with multipage bvec, super large bio can be created.
And it lead to delay first I/O request issue.

Signed-off-by: Changheun Lee <nanich.lee@samsung.com>
---
 block/bio.c            | 17 ++++++++++++++---
 block/blk-settings.c   | 19 +++++++++++++++++++
 include/linux/bio.h    |  4 +++-
 include/linux/blkdev.h |  3 +++
 4 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 44205dfb6b60..73b673f1684e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -255,6 +255,13 @@ void bio_init(struct bio *bio, struct bio_vec *table,
 }
 EXPORT_SYMBOL(bio_init);
 
+unsigned int bio_max_bytes(struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+
+	return bdev ? bdev->bd_disk->queue->limits.max_bio_bytes : UINT_MAX;
+}
+
 /**
  * bio_reset - reinitialize a bio
  * @bio:	bio to reset
@@ -866,7 +873,7 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
 		if (page_is_mergeable(bv, page, len, off, same_page)) {
-			if (bio->bi_iter.bi_size > UINT_MAX - len) {
+			if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len) {
 				*same_page = false;
 				return false;
 			}
@@ -995,6 +1002,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
+	unsigned int bytes_left = bio_max_bytes(bio) - bio->bi_iter.bi_size;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
 	bool same_page = false;
@@ -1010,7 +1018,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);
 	pages += entries_left * (PAGE_PTRS_PER_BVEC - 1);
 
-	size = iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);
+	size = iov_iter_get_pages(iter, pages, bytes_left, nr_pages,
+				  &offset);
 	if (unlikely(size <= 0))
 		return size ? size : -EFAULT;
 
@@ -1038,6 +1047,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
+	unsigned int bytes_left = bio_max_bytes(bio) - bio->bi_iter.bi_size;
 	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
@@ -1058,7 +1068,8 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);
 	pages += entries_left * (PAGE_PTRS_PER_BVEC - 1);
 
-	size = iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);
+	size = iov_iter_get_pages(iter, pages, bytes_left, nr_pages,
+				  &offset);
 	if (unlikely(size <= 0))
 		return size ? size : -EFAULT;
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 902c40d67120..e270e31519a1 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -32,6 +32,7 @@ EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
  */
 void blk_set_default_limits(struct queue_limits *lim)
 {
+	lim->max_bio_bytes = UINT_MAX;
 	lim->max_segments = BLK_MAX_SEGMENTS;
 	lim->max_discard_segments = 1;
 	lim->max_integrity_segments = 0;
@@ -100,6 +101,24 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
+/**
+ * blk_queue_max_bio_bytes - set bio max size for queue
+ * @q: the request queue for the device
+ * @bytes : bio max bytes to be set
+ *
+ * Description:
+ *    Set proper bio max size to optimize queue operating.
+ **/
+void blk_queue_max_bio_bytes(struct request_queue *q, unsigned int bytes)
+{
+	struct queue_limits *limits = &q->limits;
+	unsigned int max_bio_bytes = round_up(bytes, PAGE_SIZE);
+
+	limits->max_bio_bytes = max_t(unsigned int, max_bio_bytes,
+				      BIO_MAX_VECS * PAGE_SIZE);
+}
+EXPORT_SYMBOL(blk_queue_max_bio_bytes);
+
 /**
  * blk_queue_max_hw_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
diff --git a/include/linux/bio.h b/include/linux/bio.h
index a0b4cfdf62a4..3959cc1a0652 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -106,6 +106,8 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
+extern unsigned int bio_max_bytes(struct bio *bio);
+
 /**
  * bio_full - check if the bio is full
  * @bio:	bio to check
@@ -119,7 +121,7 @@ static inline bool bio_full(struct bio *bio, unsigned len)
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return true;
 
-	if (bio->bi_iter.bi_size > UINT_MAX - len)
+	if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len)
 		return true;
 
 	return false;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1255823b2bc0..861888501fc0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -326,6 +326,8 @@ enum blk_bounce {
 };
 
 struct queue_limits {
+	unsigned int		max_bio_bytes;
+
 	enum blk_bounce		bounce;
 	unsigned long		seg_boundary_mask;
 	unsigned long		virt_boundary_mask;
@@ -1132,6 +1134,7 @@ extern void blk_abort_request(struct request *);
  * Access functions for manipulating queue properties
  */
 extern void blk_cleanup_queue(struct request_queue *);
+extern void blk_queue_max_bio_bytes(struct request_queue *, unsigned int);
 void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce limit);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
-- 
2.29.0

