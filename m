Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D781C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF5B21919
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:17:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F820K3wr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgICIRO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgICIBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 04:01:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EB5C061247;
        Thu,  3 Sep 2020 01:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=XgwYo2Sg7gfnERWvC79K4ap0+DYU34E3F9ajl/LvCHY=; b=F820K3wrYlVe1pAOZnsOECbEYY
        zVNZAQYiFPWwZ7O0vPXhKMaVEIfNpF0zFgmV6+2r+Hg4/4ARN45yTUKNM9sI68M0bXkMFzxMmkBy/
        FMY+34FwLLkLmdstN37e4NFpsystC8kAfQeOivaOdutbLi0VMa9EIXAuJ9TgVcMDjSqTlGFwzR3IX
        fC9NvGxc2bG4sKkwo2B48rHoroBjeLPVz7IZ1lLq9nsTckShMQnnY2GYgLuDhtfBKUUJ06MFDBSd2
        64fZXbhKJZc7vNeDbMRjiFLWUuWlPHoUJJsi5SAtGtb1UMc8pLdM/C8ZtCKmRl1IIChh/4inRVqUp
        yDMbVSxw==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkBQ-0006aB-7k; Thu, 03 Sep 2020 08:01:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 03/19] block: cleanup del_gendisk a bit
Date:   Thu,  3 Sep 2020 10:01:03 +0200
Message-Id: <20200903080119.441674-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903080119.441674-1-hch@lst.de>
References: <20200903080119.441674-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge three hidden gendisk checks into one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 44f69f4b2c5aa6..ec9b64207d9c2e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -948,6 +948,9 @@ void del_gendisk(struct gendisk *disk)
 
 	might_sleep();
 
+	if (WARN_ON_ONCE(!disk->queue))
+		return;
+
 	blk_integrity_del(disk);
 	disk_del_events(disk);
 
@@ -970,20 +973,18 @@ void del_gendisk(struct gendisk *disk)
 	disk->flags &= ~GENHD_FL_UP;
 	up_write(&disk->lookup_sem);
 
-	if (!(disk->flags & GENHD_FL_HIDDEN))
+	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
-	if (disk->queue) {
+
 		/*
 		 * Unregister bdi before releasing device numbers (as they can
 		 * get reused and we'd get clashes in sysfs).
 		 */
-		if (!(disk->flags & GENHD_FL_HIDDEN))
-			bdi_unregister(disk->queue->backing_dev_info);
-		blk_unregister_queue(disk);
-	} else {
-		WARN_ON(1);
+		bdi_unregister(disk->queue->backing_dev_info);
 	}
 
+	blk_unregister_queue(disk);
+	
 	if (!(disk->flags & GENHD_FL_HIDDEN))
 		blk_unregister_region(disk_devt(disk), disk->minors);
 	/*
-- 
2.28.0

