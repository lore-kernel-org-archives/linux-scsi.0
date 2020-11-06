Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E9CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 19:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18FFD20B80
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 19:04:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tH8UdTWn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgKFTEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 14:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgKFTER (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 14:04:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228BCC0613D2;
        Fri,  6 Nov 2020 11:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=msAxRVgou3+s48HjnTxbv/pHmvKh+OTllxGOwTa9PDs=; b=tH8UdTWnkIuPETR5ERZJsxXqO9
        RuvncvGLMp3eecYVL5xbljvoepHQIy9LJuMEB0q+0oEeVpE399lmWu6TR7di2UcX2jvpnbzMAgO+T
        lVDmVMLdl2vdcru/zg5P/TlhhczznEvHfAs7dYsm2yxmv3ZUvGZmRnMrTXcu7NYlNoXgOCzkHUicc
        AGwDOPnsGK9wvtFNI87/4PdBzDhhP3bDY7qTssXyAvbxU4+VHn4Hlisg3BkNqrDEoze0VUh2Ufbsg
        sLEPDubY8OG8SNMA5E0TVDhcZDYddMUr3C9Qfc/tX9zYtsMYh7soL6M1ihPRkp1F9FRPk6C6a4b5z
        IcLgD9AQ==;
Received: from [2001:4bb8:184:9a8d:9e34:f7f4:e59e:ad6f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kb71j-0000vL-Sx; Fri, 06 Nov 2020 19:04:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 06/24] block: add a return value to set_capacity_and_notify
Date:   Fri,  6 Nov 2020 20:03:18 +0100
Message-Id: <20201106190337.1973127-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106190337.1973127-1-hch@lst.de>
References: <20201106190337.1973127-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return if the function ended up sending an uevent or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 7 +++++--
 include/linux/genhd.h | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index d8d9d6c1c916e1..8c350fecfe8bfe 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -47,9 +47,9 @@ static void disk_release_events(struct gendisk *disk);
 
 /*
  * Set disk capacity and notify if the size is not currently zero and will not
- * be set to zero.
+ * be set to zero.  Returns true if a uevent was sent, otherwise false.
  */
-void set_capacity_and_notify(struct gendisk *disk, sector_t size)
+bool set_capacity_and_notify(struct gendisk *disk, sector_t size)
 {
 	sector_t capacity = get_capacity(disk);
 
@@ -60,7 +60,10 @@ void set_capacity_and_notify(struct gendisk *disk, sector_t size)
 		char *envp[] = { "RESIZE=1", NULL };
 
 		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
+		return true;
 	}
+
+	return false;
 }
 EXPORT_SYMBOL_GPL(set_capacity_and_notify);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 596f31b5a3e133..4b22bfd9336e1a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -315,7 +315,7 @@ static inline int get_disk_ro(struct gendisk *disk)
 extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
-void set_capacity_and_notify(struct gendisk *disk, sector_t size);
+bool set_capacity_and_notify(struct gendisk *disk, sector_t size);
 
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk) __latent_entropy;
-- 
2.28.0

