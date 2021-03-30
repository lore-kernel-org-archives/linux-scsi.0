Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DB8C433EC
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C5061964
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhC3QSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhC3QRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C03C061574;
        Tue, 30 Mar 2021 09:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7VnkmWzc+fjUHXMMHZ6Aby8A0rly6t0JPloSOyJDcn0=; b=zA5Du0hza22UJzSs/EdTMQzeX7
        dTuDEGOEZzZpFtfapit8LQsnm68Q/c0VLfY8LEqOQUoewycvtzwjcIcwfe3Zx7kh686jr0Xrt4nRA
        snWt5xgXkwUA+5z92u5IjjGZzlrs04wTYPe3jyuFryVKmKu43+2n4SHh1NIec9QVM+tINMlqRkNHA
        8AsZ0ohUV2+oYBWvbgWjFbg1aw//5VV+BC00x0fktI7HwNWixsACIt+MZuyY22jS3fHwzr+xifSqt
        JeofK2ODX3jHScppMcKok7sxIKvvVjlxF5e3FJn4xdgvACT6yRO2BZ4D480b0Prg++ArmbLW91nxx
        Wd+feb+Q==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3j-008aK1-3y; Tue, 30 Mar 2021 16:17:39 +0000
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
Subject: [PATCH 03/15] md: factor out a mddev_alloc_unit helper from mddev_find
Date:   Tue, 30 Mar 2021 18:17:15 +0200
Message-Id: <20210330161727.2297292-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split out a self contained helper to find a free minor for the md
"unit" number.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9556724fdb0848..f329d5b3c931d4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -745,6 +745,27 @@ static struct mddev *mddev_find_locked(dev_t unit)
 	return NULL;
 }
 
+/* find an unused unit number */
+static dev_t mddev_alloc_unit(void)
+{
+	static int next_minor = 512;
+	int start = next_minor;
+	bool is_free = 0;
+	dev_t dev = 0;
+
+	while (!is_free) {
+		dev = MKDEV(MD_MAJOR, next_minor);
+		next_minor++;
+		if (next_minor > MINORMASK)
+			next_minor = 0;
+		if (next_minor == start)
+			return 0;		/* Oh dear, all in use. */
+		is_free = !mddev_find_locked(dev);
+	}
+
+	return dev;
+}
+
 static struct mddev *mddev_find(dev_t unit)
 {
 	struct mddev *mddev, *new = NULL;
@@ -771,27 +792,13 @@ static struct mddev *mddev_find(dev_t unit)
 			return new;
 		}
 	} else if (new) {
-		/* find an unused unit number */
-		static int next_minor = 512;
-		int start = next_minor;
-		int is_free = 0;
-		int dev = 0;
-		while (!is_free) {
-			dev = MKDEV(MD_MAJOR, next_minor);
-			next_minor++;
-			if (next_minor > MINORMASK)
-				next_minor = 0;
-			if (next_minor == start) {
-				/* Oh dear, all in use. */
-				spin_unlock(&all_mddevs_lock);
-				kfree(new);
-				return NULL;
-			}
-
-			is_free = !mddev_find_locked(dev);
+		new->unit = mddev_alloc_unit();
+		if (!new->unit) {
+			spin_unlock(&all_mddevs_lock);
+			kfree(new);
+			return NULL;
 		}
-		new->unit = dev;
-		new->md_minor = MINOR(dev);
+		new->md_minor = MINOR(new->unit);
 		new->hold_active = UNTIL_STOP;
 		list_add(&new->all_mddevs, &all_mddevs);
 		spin_unlock(&all_mddevs_lock);
-- 
2.30.1

