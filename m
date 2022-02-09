Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680F5C43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiBII2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:28:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiBII2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:28:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1063C05CBB1;
        Wed,  9 Feb 2022 00:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JdN4fbdK7WSMBnVaS60mQB7FbW/jFBWd0pawLUyHjGA=; b=wHNaFwY83lay7D9iwJ8InWcr9u
        bbmb/7SzRoqUC/miWmB5j8pVQ+s5ZP0M+0ccnP8h34i2LNuszCHuDenLHxCQKV3Ahdy8bMwFEMIu4
        NFwTPcfq8Plez6YNfIROUwZX/EVyTahjZlfkxiWUVCIHtUar5yUTezFusFEwZsk61nqE31Qq0vqEi
        18vQUqtXweuevpFdt9jOU2TLuY0TupHsCYsIDPgR6IgiJmERIk/McfJGwOdNmQsUZZ7tx1fbZNO6j
        9pRc8TF8kfOQYXu+nXlr6+LS3dcBHtEbhVAbacmdcpIZAg++j1/aNJIjngRPQKlJCvXx5peQVqtNi
        k4RWA4DQ==;
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHiLC-00GcBy-3d; Wed, 09 Feb 2022 08:28:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, martin.petersen@oracle.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        target-devel@vger.kernel.org, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        drbd-dev@lists.linbit.com, dm-devel@redhat.com
Subject: [PATCH 3/7] rnbd: drop WRITE_SAME support
Date:   Wed,  9 Feb 2022 09:28:24 +0100
Message-Id: <20220209082828.2629273-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
code, which has switched to use REQ_OP_WRITE_ZEROES long before rnbd was
even merged.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rnbd/rnbd-clt.c   | 7 ++-----
 drivers/block/rnbd/rnbd-clt.h   | 1 -
 drivers/block/rnbd/rnbd-proto.h | 6 ------
 drivers/block/rnbd/rnbd-srv.c   | 3 +--
 4 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index c08971de369fc..dc192d2738854 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -82,7 +82,6 @@ static int rnbd_clt_set_dev_attr(struct rnbd_clt_dev *dev,
 	dev->nsectors		    = le64_to_cpu(rsp->nsectors);
 	dev->logical_block_size	    = le16_to_cpu(rsp->logical_block_size);
 	dev->physical_block_size    = le16_to_cpu(rsp->physical_block_size);
-	dev->max_write_same_sectors = le32_to_cpu(rsp->max_write_same_sectors);
 	dev->max_discard_sectors    = le32_to_cpu(rsp->max_discard_sectors);
 	dev->discard_granularity    = le32_to_cpu(rsp->discard_granularity);
 	dev->discard_alignment	    = le32_to_cpu(rsp->discard_alignment);
@@ -1359,8 +1358,6 @@ static void setup_request_queue(struct rnbd_clt_dev *dev)
 	blk_queue_logical_block_size(dev->queue, dev->logical_block_size);
 	blk_queue_physical_block_size(dev->queue, dev->physical_block_size);
 	blk_queue_max_hw_sectors(dev->queue, dev->max_hw_sectors);
-	blk_queue_max_write_same_sectors(dev->queue,
-					 dev->max_write_same_sectors);
 
 	/*
 	 * we don't support discards to "discontiguous" segments
@@ -1610,10 +1607,10 @@ struct rnbd_clt_dev *rnbd_clt_map_device(const char *sessname,
 	}
 
 	rnbd_clt_info(dev,
-		       "map_device: Device mapped as %s (nsectors: %zu, logical_block_size: %d, physical_block_size: %d, max_write_same_sectors: %d, max_discard_sectors: %d, discard_granularity: %d, discard_alignment: %d, secure_discard: %d, max_segments: %d, max_hw_sectors: %d, rotational: %d, wc: %d, fua: %d)\n",
+		       "map_device: Device mapped as %s (nsectors: %zu, logical_block_size: %d, physical_block_size: %d, max_discard_sectors: %d, discard_granularity: %d, discard_alignment: %d, secure_discard: %d, max_segments: %d, max_hw_sectors: %d, rotational: %d, wc: %d, fua: %d)\n",
 		       dev->gd->disk_name, dev->nsectors,
 		       dev->logical_block_size, dev->physical_block_size,
-		       dev->max_write_same_sectors, dev->max_discard_sectors,
+		       dev->max_discard_sectors,
 		       dev->discard_granularity, dev->discard_alignment,
 		       dev->secure_discard, dev->max_segments,
 		       dev->max_hw_sectors, dev->rotational, dev->wc, dev->fua);
diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
index 0c2cae7f39b9f..6946ba23d62e5 100644
--- a/drivers/block/rnbd/rnbd-clt.h
+++ b/drivers/block/rnbd/rnbd-clt.h
@@ -122,7 +122,6 @@ struct rnbd_clt_dev {
 	bool			wc;
 	bool			fua;
 	u32			max_hw_sectors;
-	u32			max_write_same_sectors;
 	u32			max_discard_sectors;
 	u32			discard_granularity;
 	u32			discard_alignment;
diff --git a/drivers/block/rnbd/rnbd-proto.h b/drivers/block/rnbd/rnbd-proto.h
index de5d5a8df81d7..3eb8b34bd1886 100644
--- a/drivers/block/rnbd/rnbd-proto.h
+++ b/drivers/block/rnbd/rnbd-proto.h
@@ -249,9 +249,6 @@ static inline u32 rnbd_to_bio_flags(u32 rnbd_opf)
 	case RNBD_OP_SECURE_ERASE:
 		bio_opf = REQ_OP_SECURE_ERASE;
 		break;
-	case RNBD_OP_WRITE_SAME:
-		bio_opf = REQ_OP_WRITE_SAME;
-		break;
 	default:
 		WARN(1, "Unknown RNBD type: %d (flags %d)\n",
 		     rnbd_op(rnbd_opf), rnbd_opf);
@@ -284,9 +281,6 @@ static inline u32 rq_to_rnbd_flags(struct request *rq)
 	case REQ_OP_SECURE_ERASE:
 		rnbd_opf = RNBD_OP_SECURE_ERASE;
 		break;
-	case REQ_OP_WRITE_SAME:
-		rnbd_opf = RNBD_OP_WRITE_SAME;
-		break;
 	case REQ_OP_FLUSH:
 		rnbd_opf = RNBD_OP_FLUSH;
 		break;
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 132e950685d59..0e6b5687f8321 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -548,8 +548,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 		cpu_to_le16(rnbd_dev_get_max_segs(rnbd_dev));
 	rsp->max_hw_sectors =
 		cpu_to_le32(rnbd_dev_get_max_hw_sects(rnbd_dev));
-	rsp->max_write_same_sectors =
-		cpu_to_le32(bdev_write_same(rnbd_dev->bdev));
+	rsp->max_write_same_sectors = 0;
 	rsp->max_discard_sectors =
 		cpu_to_le32(rnbd_dev_get_max_discard_sects(rnbd_dev));
 	rsp->discard_granularity =
-- 
2.30.2

