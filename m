Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD32C433FB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1F861953
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhC3QSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhC3QRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DE1C061574;
        Tue, 30 Mar 2021 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+reQJeg6whXi08pUiCxa5dO6MTFH0xSj1CTmZbcqtZs=; b=wN/OeuRbuPoyb1bReLzsiI0Kn8
        +Rk1bkhPqr1tvBBxCuHGZyvgQjOLg9wx4/vOMBVSxEwey9EFdHqEzA9Ossy7nKEtr4tOyWnWNdpQJ
        d4wRVB0nmpq0/ZotU2DU80uD9mzKcrapF/uGRflWCopw6XkO7uPglGf0u/V7GA9PddrOgXlY1Ur+Z
        abtnjbAYuNJQqsgj2CU+UW9Lt7Ks4BCCPeKSJ01CI/1KSZoc4wlVqcI5P3I/fmU1fBkfsM5cPnv5w
        idZVURH5S+CA7uiaZKsHVzPjNPXZOEp4cu2dRBQJZD5U+ZgshrP73SWes7AKeDQ+mtxE9IqlzmAAH
        TZCh0zXw==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3l-008aKB-Vx; Tue, 30 Mar 2021 16:17:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 04/15] md: split mddev_find
Date:   Tue, 30 Mar 2021 18:17:16 +0200
Message-Id: <20210330161727.2297292-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split mddev_find into a simple mddev_find that just finds an existing
mddev by the unit number, and a more complicated mddev_find that deals
with find or allocating a mddev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f329d5b3c931d4..8e60bcc9c1d10c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -767,6 +767,22 @@ static dev_t mddev_alloc_unit(void)
 }
 
 static struct mddev *mddev_find(dev_t unit)
+{
+	struct mddev *mddev;
+
+	if (MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1 << MdpMinorShift) - 1);
+
+	spin_lock(&all_mddevs_lock);
+	mddev = mddev_find_locked(unit);
+	if (mddev)
+		mddev_get(mddev);
+	spin_unlock(&all_mddevs_lock);
+
+	return mddev;
+}
+
+static struct mddev *mddev_find_or_alloc(dev_t unit)
 {
 	struct mddev *mddev, *new = NULL;
 
@@ -5657,7 +5673,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find(dev);
+	struct mddev *mddev = mddev_find_or_alloc(dev);
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
@@ -6537,11 +6553,9 @@ static void autorun_devices(int part)
 
 		md_probe(dev);
 		mddev = mddev_find(dev);
-		if (!mddev || !mddev->gendisk) {
-			if (mddev)
-				mddev_put(mddev);
+		if (!mddev)
 			break;
-		}
+
 		if (mddev_lock(mddev))
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
-- 
2.30.1

