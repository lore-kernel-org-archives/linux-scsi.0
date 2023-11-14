Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E88BC4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbjKNVmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbjKNVmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:42:12 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4463D7;
        Tue, 14 Nov 2023 13:42:08 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cc3c51f830so47310765ad.1;
        Tue, 14 Nov 2023 13:42:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699998128; x=1700602928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6w66p4gv/rDnaWT3ygCld4b9+5G3J9eiGgIq2FACulg=;
        b=BZNP6N1hW5WQwG0RTgzuurDdKESKmJ6hyJ5swZf/N6ybobw3P220hSCxzc1T9/Ky4e
         amDIYDRfROiIOvRt+mKRPLW13QDapQP4IbvciDir4uMGbpJsLRXfjdhDG4/ublHR0yM3
         GH/+kpwXDHEz/v841W3Gznf5CSjNBHwEjsIiJd1j89cI99gVEn7O9qYmMJrJpr9F5WWI
         QkQEIhu+e/lVeawhKfopE6rsKToULXNo09vSbm/WRupBNvpaOw1w7QUUZ54rErjRNDev
         I0PB4mcUzHGKCqGzgzELQ44B2GWve6b0uSPGOxBumbd5RLUuIomrqIaxMzxDEttI7kI6
         I7Vg==
X-Gm-Message-State: AOJu0YwS2cz+xHExtFV/RHQ1q2w9xPuX7Bo2EQu0Ck8IO07KwVqry4Mg
        wpRfWdtNnfPEDUbTTTgtjt4=
X-Google-Smtp-Source: AGHT+IHT04JrKUYfZLA+6RTg+Tmk/QpNQsn65FZDrv23Pi4jfWO7TSloPWvKMBxmM0ZJxk/Rgk8/cg==
X-Received: by 2002:a17:902:e5cc:b0:1cc:3c2d:1289 with SMTP id u12-20020a170902e5cc00b001cc3c2d1289mr3623724plf.3.1699998128316;
        Tue, 14 Nov 2023 13:42:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902d4d000b001c3267ae317sm6133926plg.165.2023.11.14.13.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:42:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Daejun Park <daejun7.park@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v4 04/15] fs: Restore write hint support
Date:   Tue, 14 Nov 2023 13:40:59 -0800
Message-ID: <20231114214132.1486867-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114214132.1486867-1-bvanassche@acm.org>
References: <20231114214132.1486867-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Initialize the bio lifetime to the data lifetime information that is
available in struct inode. This patch reverts a small subset of commit
c75e707fe1aa ("block: remove the per-bio/request write hint").

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/fops.c           | 3 +++
 fs/iomap/buffered-io.c | 2 ++
 fs/iomap/direct-io.c   | 1 +
 fs/mpage.c             | 1 +
 4 files changed, 7 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 0abaac705daf..059c098c7a58 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -74,6 +74,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	bio.bi_lifetime	= iocb->ki_filp->f_inode->i_write_hint;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -206,6 +207,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
+		bio->bi_lifetime = iocb->ki_filp->f_inode->i_write_hint;
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
@@ -323,6 +325,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio->bi_end_io = blkdev_bio_end_io_async;
 	bio->bi_ioprio = iocb->ki_ioprio;
+	bio->bi_lifetime = iocb->ki_filp->f_inode->i_write_hint;
 
 	if (iov_iter_is_bvec(iter)) {
 		/*
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index f72df2babe56..0a430d85dec4 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1677,6 +1677,7 @@ iomap_alloc_ioend(struct inode *inode, struct iomap_writepage_ctx *wpc,
 			       REQ_OP_WRITE | wbc_to_write_flags(wbc),
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = sector;
+	bio->bi_lifetime = inode->i_write_hint;
 	wbc_init_bio(wbc, bio);
 
 	ioend = container_of(bio, struct iomap_ioend, io_inline_bio);
@@ -1707,6 +1708,7 @@ iomap_chain_bio(struct bio *prev)
 	new = bio_alloc(prev->bi_bdev, BIO_MAX_VECS, prev->bi_opf, GFP_NOFS);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
+	new->bi_lifetime = prev->bi_lifetime;
 
 	bio_chain(prev, new);
 	bio_get(prev);		/* for iomap_finish_ioend */
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bcd3f8cf5ea4..df095b9700a7 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -381,6 +381,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 					  GFP_KERNEL);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_ioprio = dio->iocb->ki_ioprio;
+		bio->bi_lifetime = dio->iocb->ki_filp->f_inode->i_write_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = iomap_dio_bio_end_io;
 
diff --git a/fs/mpage.c b/fs/mpage.c
index ffb064ed9d04..0eea809a6d46 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -611,6 +611,7 @@ static int __mpage_writepage(struct folio *folio, struct writeback_control *wbc,
 				GFP_NOFS);
 		bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 		wbc_init_bio(wbc, bio);
+		bio->bi_lifetime = inode->i_write_hint;
 	}
 
 	/*
