Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE50C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 15:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E3A20793
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 15:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406414AbgLKO6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:58:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20794 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406394AbgLKO6K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:58:10 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201211145723epoutp04f7944d777714739dcf5b19eb11ea8d66~PsWXrnmrB2877828778epoutp043
        for <linux-scsi@vger.kernel.org>; Fri, 11 Dec 2020 14:57:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201211145723epoutp04f7944d777714739dcf5b19eb11ea8d66~PsWXrnmrB2877828778epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607698643;
        bh=Fh3+/Nufb2bgGDNOCFM6kIQfIimGgvTS9Nra97zMH/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFPngbFcuhvcwnfxo+PJLasXifSu5PUaZQwQqEuMJUaJ1SLu99R99Aw//RFStUDf5
         Y8aYLlwtESjhBMYj8hSvh4cz6ayHx4viYuBxHK49x9eY5vjrqhHAmPDrt2LtI1M9NP
         gpuWjQIHwdYYHw4BfWayHawrAGxMDKj60HH0+jM4=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20201211145722epcas5p1cd39a6f6c02b3a9893bd0b687ea67a9b~PsWW7_8Si1802018020epcas5p1m;
        Fri, 11 Dec 2020 14:57:22 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.E3.15682.2D883DF5; Fri, 11 Dec 2020 23:57:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d~PrdSJ8rng2146621466epcas5p2D;
        Fri, 11 Dec 2020 13:52:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201211135200epsmtrp17dbb4d7af6de44b30c8fefe5f74aaec7~PrdSI3X693246832468epsmtrp1h;
        Fri, 11 Dec 2020 13:52:00 +0000 (GMT)
X-AuditID: b6c32a49-8d5ff70000013d42-90-5fd388d2d89f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.71.08745.08973DF5; Fri, 11 Dec 2020 22:52:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201211135156epsmtip291d80e72677c32143d3574f83db91b37~PrdO6uDKK2794227942epsmtip2E;
        Fri, 11 Dec 2020 13:51:56 +0000 (GMT)
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
Subject: [RFC PATCH v3 1/2] block: add simple copy support
Date:   Fri, 11 Dec 2020 19:21:38 +0530
Message-Id: <20201211135139.49232-2-selvakuma.s1@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211135139.49232-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTXfdSx+V4g5XnxC1W3+1ns5j24Sez
        RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
        lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
        uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
        4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBl90y8wF9xbxVgxey5rA+PkbsYuRk4OCQETidcr
        T7F3MXJxCAnsZpQ4d3onG4TziVFi6uLFLBDOZ0aJfR8PscK0dJ8+xgxiCwnsYpTo/VwBV/S6
        vR+siE1AV+Lakk0sILaIgJLE3/VNYJOYBW4yS1z69YkdJCEsYCVx5PFbsEksAqoS81ubwRp4
        BWwl1j/cwQyxTV5i5qXvYPWcAnYSfVvuMEPUCEqcnPkErJ4ZqKZ562xmkAUSAvM5JR53X2GB
        aHaROHT7HhOELSzx6vgWdghbSuJlfxuUXS7xrHMaVE0Do0Tf+3II217i4p6/QHEOoAWaEut3
        6UOEZSWmnlrHBLGXT6L39xOoVl6JHfOegJVLCKhJnNpuBhGWkfhweBcbhO0h8eNzOzSsJzJK
        nO88zj6BUWEWkndmIXlnFsLmBYzMqxglUwuKc9NTi00LDPNSy/WKE3OLS/PS9ZLzczcxghOq
        lucOxrsPPugdYmTiYDzEKMHBrCTC+7v+crwQb0piZVVqUX58UWlOavEhRmkOFiVxXqUfZ+KE
        BNITS1KzU1MLUotgskwcnFINTJOiNu9dYBUacEGFdVnZ6ossTgysmV97tJY09J5vVeI9sEJ9
        majKVmavKxfOXVS71NWwXYIpb5f2yT32HpUzDY9ZyjzNSX1y1puh9Masy2t9ecNWKbsEC+/0
        svxkZCM2KVzUN8VCb8b/6hOVC2/9UL2ZZ2x64mzjmxlhPh8sf1Z/YAv6aqHMfemwSLBC/591
        zpJ3PWZz1riGO6runl9685lFon9BpqGD3gY/L95zvvyG/Z0iv66W88bIsZYf5k9ZEb3C9bpF
        heccrUniG7dO3e39UGOBVMAxp7W5L79JTcj8tdzHuWN96tPPKzb3ilWorPNtmVv/4Y3fruhb
        gi9nrm07yRj9hblzi/nj6BIVJZbijERDLeai4kQAHtsaZhcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSvG5D5eV4g/vP+S1W3+1ns5j24Sez
        RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
        lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
        uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
        4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBl90y8wF9xbxVgxey5rA+PkbsYuRk4OCQETie7T
        x5i7GLk4hAR2MEq8W/eVBSIhI7H2bicbhC0ssfLfc3aIoo+MEheuvmAHSbAJ6EpcW7IJrEFE
        QEni7/omFpAiZoHPzBLzd7WBJYQFrCSOPH7LDGKzCKhKzG9tBovzCthKrH+4gxlig7zEzEvf
        wYZyCthJ9G25AxYXAqq5f7KfFaJeUOLkzCdAvRxAC9Ql1s8TAgkzA7U2b53NPIFRcBaSqlkI
        VbOQVC1gZF7FKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc41paOxj3rPqgd4iRiYPx
        EKMEB7OSCK8sy6V4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZ
        ODilGphWVwd7fF+27XdKrlffg6498zvX78s6u21NZFSQ1Kp9WZV7erep9IQ/rrv/dHtxWmtQ
        z4sTsfsLdJxOPr/v56c+ZVnCMrtY+941mdlHjVxXHr46pf+mrIdrjKrZkV12U8MEsh+l3LZ8
        pPhlceeiR2JVtWoHLr/YUJApHPRzUZWnWOJqD6k3n+vX3tg1hWNR2VQG49ZrfVn8d5LbLvuf
        6CwyKpnpLBe2YrarraDf8eVyexjmX5vXKVdWYdS25rheOJMGu9fsXysmZ9n0rFRimL/DROL1
        8ftVOy+yVKQyXZGSmK0lt+jO9wz/LRPneZx22s756v26//6LXGU4+D1iH/1acU94n0fcmc1N
        L8R6mLqUWIozEg21mIuKEwGK39fwYAMAAA==
X-CMS-MailID: 20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
        <CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add new BLKCOPY ioctl that offloads copying of multiple sources
to a destination to the device. Accept copy_ranges that contains
destination, no of sources and pointer to the array of source
ranges. Each range_entry contains start and length of source
ranges (in bytes).

Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
bio with control information as payload and submit to the device.
REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
to zoned device.

If the device doesn't support copy or copy offload is disabled, then
copy is emulated by reading and writing each source ranges one by one.

Introduce queue limits for simple copy and other helper functions.
Add device limits as sysfs entries.
	- copy_offload
	- max_copy_sectors
	- max_copy_ranges_sectors
	- max_copy_nr_ranges

copy_offload(= 0) is disabled by default.
max_copy_sectors = 0 indicates the device doesn't support copy.

simple copy is not supported for stacked devices.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier González <javier.gonz@samsung.com>
---
 block/blk-core.c          |  94 ++++++++++++++++++--
 block/blk-lib.c           | 182 ++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |   2 +
 block/blk-settings.c      |  10 +++
 block/blk-sysfs.c         |  50 +++++++++++
 block/blk-zoned.c         |   1 +
 block/bounce.c            |   1 +
 block/ioctl.c             |  43 +++++++++
 include/linux/bio.h       |   1 +
 include/linux/blk_types.h |  15 ++++
 include/linux/blkdev.h    |  16 ++++
 include/uapi/linux/fs.h   |  13 +++
 12 files changed, 420 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2db8bda43b6e..07d64514e77b 100644
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
+	struct hd_struct *p = NULL;
+	struct request_queue *q = bio->bi_disk->queue;
+	struct blk_copy_payload *payload;
+	int i, maxsector, start_sect = 0, ret = -EIO;
+	unsigned short nr_range;
+
+	rcu_read_lock();
+
+	if (bio->bi_partno) {
+		p = __disk_get_part(bio->bi_disk, bio->bi_partno);
+		if (unlikely(!p))
+			goto out;
+		if (unlikely(bio_check_ro(bio, p)))
+			goto out;
+		maxsector = part_nr_sects_read(p);
+		start_sect = p->start_sect;
+	} else {
+		if (unlikely(bio_check_ro(bio, &bio->bi_disk->part0)))
+			goto out;
+		maxsector =  get_capacity(bio->bi_disk);
+	}
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
+		payload->range[i].src += start_sect;
+	}
+
+	if (p)
+		bio->bi_partno = 0;
+	ret = 0;
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 /*
  * Remap block n of partition p to block n+start(p) of the disk.
  */
@@ -825,14 +895,16 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 	if (should_fail_bio(bio))
 		goto end_io;
 
-	if (bio->bi_partno) {
-		if (unlikely(blk_partition_remap(bio)))
-			goto end_io;
-	} else {
-		if (unlikely(bio_check_ro(bio, &bio->bi_disk->part0)))
-			goto end_io;
-		if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
-			goto end_io;
+	if (likely(!op_is_copy(bio->bi_opf))) {
+		if (bio->bi_partno) {
+			if (unlikely(blk_partition_remap(bio)))
+				goto end_io;
+		} else {
+			if (unlikely(bio_check_ro(bio, &bio->bi_disk->part0)))
+				goto end_io;
+			if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
+				goto end_io;
+		}
 	}
 
 	/*
@@ -856,6 +928,12 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
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
index e90614fd8d6a..47e50e957e75 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -150,6 +150,188 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
+		gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio *bio;
+	void *buf = NULL;
+	int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
+
+	nr_srcs = payload->copy_range;
+	max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;
+	cur_dest = payload->dest;
+	buf = kvmalloc(max_range_len, GFP_ATOMIC);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_srcs; i++) {
+		bio = bio_alloc(gfp_mask, 1);
+		bio->bi_iter.bi_sector = payload->range[i].src;
+		bio->bi_opf = REQ_OP_READ;
+		bio_set_dev(bio, bdev);
+
+		cur_size = payload->range[i].len << SECTOR_SHIFT;
+		ret = bio_add_page(bio, virt_to_page(buf), cur_size,
+						   offset_in_page(payload));
+		if (ret != cur_size) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = submit_bio_wait(bio);
+		bio_put(bio);
+		if (ret)
+			goto out;
+
+		bio = bio_alloc(gfp_mask, 1);
+		bio_set_dev(bio, bdev);
+		bio->bi_opf = REQ_OP_WRITE;
+		bio->bi_iter.bi_sector = cur_dest;
+		ret = bio_add_page(bio, virt_to_page(buf), cur_size,
+						   offset_in_page(payload));
+		if (ret != cur_size) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = submit_bio_wait(bio);
+		bio_put(bio);
+		if (ret)
+			goto out;
+
+		cur_dest += payload->range[i].len;
+	}
+out:
+	kvfree(buf);
+	return ret;
+}
+
+int __blkdev_issue_copy(struct block_device *bdev, sector_t dest,
+		sector_t nr_srcs, struct range_entry *rlist, gfp_t gfp_mask,
+		int flags, struct bio **biop)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio *bio;
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
+	if (!blk_queue_copy(q))
+		return -EOPNOTSUPP;
+
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if (dest & bs_mask)
+		return -EINVAL;
+
+	total_size = struct_size(payload, range, nr_srcs);
+	payload = kmalloc(total_size, GFP_ATOMIC | __GFP_NOWARN);
+	if (!payload)
+		return -ENOMEM;
+
+	payload->dest = dest;
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
+		if (len > q->limits.max_copy_range_sectors) {
+			ret = -EINVAL;
+			goto err;
+		}
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
+	if (q->limits.copy_offload) {
+		bio = bio_alloc(gfp_mask, 1);
+		bio->bi_iter.bi_sector = dest;
+		bio->bi_opf = REQ_OP_COPY | REQ_NOMERGE;
+		bio_set_dev(bio, bdev);
+
+		ret = bio_add_page(bio, virt_to_page(payload), total_size,
+						   offset_in_page(payload));
+		if (ret != total_size) {
+			ret = -ENOMEM;
+			bio_put(bio);
+			goto err;
+		}
+
+		*biop = bio;
+		return 0;
+	}
+
+	ret = blk_copy_emulate(bdev, payload, gfp_mask);
+err:
+	kfree(payload);
+	return ret;
+}
+EXPORT_SYMBOL(__blkdev_issue_copy);
+
+/**
+ * blkdev_issue_copy - queue a copy
+ * @bdev:       blockdev to issue copy for
+ * @dest:	dest sector
+ * @nr_srcs:	number of source ranges to copy
+ * @rlist:	list of range entries
+ * @gfp_mask:   memory allocation flags (for bio_alloc)
+ * @flags:      BLKDEV_COPY_* flags to control behaviour	//TODO
+ *
+ * Description:
+ *    Issue a copy request for dest sector with source in rlist
+ */
+int blkdev_issue_copy(struct block_device *bdev, sector_t dest,
+		int nr_srcs, struct range_entry *rlist,
+		gfp_t gfp_mask, unsigned long flags)
+{
+	struct bio *bio = NULL;
+	int ret;
+
+	ret = __blkdev_issue_copy(bdev, dest, nr_srcs, rlist, gfp_mask, flags,
+			&bio);
+	if (!ret && bio) {
+		ret = submit_bio_wait(bio);
+
+		kfree(page_address(bio_first_bvec_all(bio)->bv_page) +
+				bio_first_bvec_all(bio)->bv_offset);
+		bio_put(bio);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_copy);
+
 /**
  * __blkdev_issue_write_same - generate number of bios with same page
  * @bdev:	target blockdev
diff --git a/block/blk-merge.c b/block/blk-merge.c
index bcf5e4580603..a16e7598d6ad 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -301,6 +301,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 	struct bio *split = NULL;
 
 	switch (bio_op(*bio)) {
+	case REQ_OP_COPY:
+			break;
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 		split = blk_bio_discard_split(q, *bio, &q->bio_split, nr_segs);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9741d1d83e98..9980e681b8b5 100644
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
 
@@ -549,6 +553,12 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
 	t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
 
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
index 6817a673e5ce..6e5fef3cc615 100644
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
index 162a6eee8999..7fbdc52decb3 100644
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
index 6b785181344f..a4a507d85e56 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -142,6 +142,47 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 				    GFP_KERNEL, flags);
 }
 
+static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
+		unsigned long arg, unsigned long flags)
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
+	dest = crange.dest >> SECTOR_SHIFT;
+
+	rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
+			GFP_ATOMIC | __GFP_NOWARN);
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
+	ret = blkdev_issue_copy(bdev, dest, crange.nr_range,
+			rlist, GFP_KERNEL, flags);
+out:
+	kfree(rlist);
+	return ret;
+}
+
 static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		unsigned long arg)
 {
@@ -467,6 +508,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 	case BLKSECDISCARD:
 		return blk_ioctl_discard(bdev, mode, arg,
 				BLKDEV_DISCARD_SECURE);
+	case BLKCOPY:
+		return blk_ioctl_copy(bdev, mode, arg, 0);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
 	case BLKREPORTZONE:
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ecf67108f091..7e40a37f0ee5 100644
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
index d9b69bbde5cc..4ecb9c16702d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -360,6 +360,8 @@ enum req_opf {
 	REQ_OP_ZONE_RESET	= 15,
 	/* reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	= 17,
+	/* copy ranges within device */
+	REQ_OP_COPY		= 19,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
@@ -486,6 +488,11 @@ static inline bool op_is_discard(unsigned int op)
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
@@ -545,4 +552,12 @@ struct blk_rq_stat {
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
index 05b346a68c2e..5b656b00850b 100644
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
@@ -1059,6 +1065,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
 
+	if (unlikely(op == REQ_OP_COPY))
+		return q->limits.max_copy_sectors;
+
 	if (unlikely(op == REQ_OP_WRITE_SAME))
 		return q->limits.max_write_same_sectors;
 
@@ -1330,6 +1339,13 @@ extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, int flags,
 		struct bio **biop);
 
+extern int __blkdev_issue_copy(struct block_device *bdev, sector_t dest,
+		sector_t nr_srcs, struct range_entry *rlist, gfp_t gfp_mask,
+		int flags, struct bio **biop);
+extern int blkdev_issue_copy(struct block_device *bdev, sector_t dest,
+		int nr_srcs, struct range_entry *rlist,
+		gfp_t gfp_mask, unsigned long flags);
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

