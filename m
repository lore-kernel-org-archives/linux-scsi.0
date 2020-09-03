Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0776C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EAF207EA
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SgDwCvCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgICFmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 01:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgICFlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 01:41:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C07AC061247;
        Wed,  2 Sep 2020 22:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=s8HG+OT+zVZj1jlfaUP4te9YgvmBvwjID4JpAmGK/9I=; b=SgDwCvCGmU8dQ4w1tb9WIoCAyB
        9gQjPkgyNg6bOj1P1lmFu5bW8WYyGOVWZapXh8d7AIUMGwQVGbDUICc3bsDnhD6AwYhEELAhaRB4j
        LaknkiI3mauYg6otb1zGs2vOXGq1FyIOfPm4NuXLCNtu3YK7A6FCkTM1L7hMtz0nnLlMaKwyl0iv9
        /2I035vDB7gwXBgOpZTil4BdoKT0CWNWZKpQeUEVP0/ojxWN+iG8jcV1XNwJRUOjUr5poVEyXvGCw
        Deu0cvknLyzczN9AJbYdlaYAVUS1SLkF0SvqhoNxBh6aJOFMIYPPqOBLm9J4lEoPYwEX8iQzuvVtf
        6Qw+JtNQ==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDhzg-0007OS-OT; Thu, 03 Sep 2020 05:41:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 3/9] md: compare bd_disk instead of bd_contains
Date:   Thu,  3 Sep 2020 07:40:58 +0200
Message-Id: <20200903054104.228829-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To check for partitions of the same disk bd_contains works as well, but
bd_disk is way more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9562ef598ae1f4..3f33562d10d6f5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2322,8 +2322,7 @@ static int match_mddev_units(struct mddev *mddev1, struct mddev *mddev2)
 			    test_bit(Journal, &rdev2->flags) ||
 			    rdev2->raid_disk == -1)
 				continue;
-			if (rdev->bdev->bd_contains ==
-			    rdev2->bdev->bd_contains) {
+			if (rdev->bdev->bd_disk == rdev2->bdev->bd_disk) {
 				rcu_read_unlock();
 				return 1;
 			}
@@ -5944,8 +5943,8 @@ int md_run(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			rdev_for_each(rdev2, mddev) {
 				if (rdev < rdev2 &&
-				    rdev->bdev->bd_contains ==
-				    rdev2->bdev->bd_contains) {
+				    rdev->bdev->bd_disk ==
+				    rdev2->bdev->bd_disk) {
 					pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
 						mdname(mddev),
 						bdevname(rdev->bdev,b),
-- 
2.28.0

