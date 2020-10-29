Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EB1C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F42207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dVtVbVES"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgJ2PD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgJ2PDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:03:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF6AC0613D2;
        Thu, 29 Oct 2020 08:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4rHB9G5No3o31/gkWnrX7b9t+exlEtyB0cyyq3jRbfk=; b=dVtVbVES0FQfTKM8HBIoujCzki
        3eZO+8iOE/zc/vP5TzodgVMe6Jq+okUCt7Pt+L6+IiMqGghtnT85+tQY+zFpAi3zSHu1+TAz+8s7V
        Gb3CF0rgw3fMu3GxPIwOKEFfBdciUHc9W3hSpm+Jw5yt0ExNK8hAmPDiQNk7qeIlFOFIiOj8OjC4S
        aVzrvj9SI70TUFtqq57iH8+NosGQCnmtXtc5y9KHPq4LsWCsKw1U7uvo45sDo5L9IamkZAQhgpJHg
        qAP51Bs5Dbna7PyEPSvQB0v5ZKZwplbcXluKKAdXhZgPWEYKSIaOyOoJdi/TXB9kArwZR85zBkbem
        Qt9Fy+FA==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9SF-0005Sd-FK; Thu, 29 Oct 2020 15:03:09 +0000
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
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/18] block: cleanup del_gendisk a bit
Date:   Thu, 29 Oct 2020 15:58:24 +0100
Message-Id: <20201029145841.144173-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge three hidden gendisk checks into one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/genhd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 0a273211fec283..3ed591970ea640 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -892,6 +892,9 @@ void del_gendisk(struct gendisk *disk)
 
 	might_sleep();
 
+	if (WARN_ON_ONCE(!disk->queue))
+		return;
+
 	blk_integrity_del(disk);
 	disk_del_events(disk);
 
@@ -914,20 +917,18 @@ void del_gendisk(struct gendisk *disk)
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

