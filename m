Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F62C4345C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5C961964
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhC3QSP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhC3QRv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A04CC061762;
        Tue, 30 Mar 2021 09:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2cGt9xT944F9z97CftgWxJIJ2NbgYHlJKGjrwdV7j/4=; b=EoFPFG7j4+JD/o23ZlBdavhIhl
        h1IElVK5cadV2jfQnre4Ey+P/82f+6weVFspmAplX3Vh1aGetjcbhiJDQj2pM122oZ3Rhfy6KOCix
        FRboh8qGwpkfqKiaGYR5xGAeGcN3ukNHNj0LwhuZ42eDcfHs/WIrqFnE+TuCTKzusU14lxZCxAoSL
        x44XFclxLIPFhNRN2scry2/nAzlGoZ9lZDORKU0MwRWKJBp88Fs9RkgIhnsNU1CtoD1IWnel+ekZF
        gBi0tU6/9tUNxwppPl+axGWXyW2746qKyC/AA/rYAzuvPYxCpVTtrCXUOs/dEutnXYcNeUkfvr+p/
        s95WUcjg==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3r-008aKb-Lw; Tue, 30 Mar 2021 16:17:48 +0000
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
Subject: [PATCH 06/15] md: do not return existing mddevs from mddev_find_or_alloc
Date:   Tue, 30 Mar 2021 18:17:18 +0200
Message-Id: <20210330161727.2297292-7-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of returning an existing mddev, just for it to be discarded
later directly return -EEXIST.  Rename the function to mddev_alloc now
that it doesn't find an existing mddev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ea9c92c113619b..e614c40ca58974 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -782,26 +782,24 @@ static struct mddev *mddev_find(dev_t unit)
 	return mddev;
 }
 
-static struct mddev *mddev_find_or_alloc(dev_t unit)
+static struct mddev *mddev_alloc(dev_t unit)
 {
-	struct mddev *mddev = NULL, *new;
+	struct mddev *new;
+	int error;
 
 	if (unit && MAJOR(unit) != MD_MAJOR)
 		unit &= ~((1 << MdpMinorShift) - 1);
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	mddev_init(new);
 
 	spin_lock(&all_mddevs_lock);
 	if (unit) {
-		mddev = mddev_find_locked(unit);
-		if (mddev) {
-			mddev_get(mddev);
+		error = -EEXIST;
+		if (mddev_find_locked(unit))
 			goto out_free_new;
-		}
-
 		new->unit = unit;
 		if (MAJOR(unit) == MD_MAJOR)
 			new->md_minor = MINOR(unit);
@@ -809,6 +807,7 @@ static struct mddev *mddev_find_or_alloc(dev_t unit)
 			new->md_minor = MINOR(unit) >> MdpMinorShift;
 		new->hold_active = UNTIL_IOCTL;
 	} else {
+		error = -ENODEV;
 		new->unit = mddev_alloc_unit();
 		if (!new->unit)
 			goto out_free_new;
@@ -822,7 +821,7 @@ static struct mddev *mddev_find_or_alloc(dev_t unit)
 out_free_new:
 	spin_unlock(&all_mddevs_lock);
 	kfree(new);
-	return mddev;
+	return ERR_PTR(error);
 }
 
 static struct attribute_group md_redundancy_group;
@@ -5661,29 +5660,29 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find_or_alloc(dev);
+	struct mddev *mddev;
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
 	int unit;
-	int error;
+	int error ;
 
-	if (!mddev)
-		return -ENODEV;
-
-	partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
-	shift = partitioned ? MdpMinorShift : 0;
-	unit = MINOR(mddev->unit) >> shift;
-
-	/* wait for any previous instance of this device to be
-	 * completely removed (mddev_delayed_delete).
+	/*
+	 * Wait for any previous instance of this device to be completely
+	 * removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
 
 	mutex_lock(&disks_mutex);
-	error = -EEXIST;
-	if (mddev->gendisk)
-		goto abort;
+	mddev = mddev_alloc(dev);
+	if (IS_ERR(mddev)) {
+		mutex_unlock(&disks_mutex);
+		return PTR_ERR(mddev);
+	}
+
+	partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
+	shift = partitioned ? MdpMinorShift : 0;
+	unit = MINOR(mddev->unit) >> shift;
 
 	if (name && !dev) {
 		/* Need to ensure that 'name' is not a duplicate.
@@ -5695,6 +5694,7 @@ static int md_alloc(dev_t dev, char *name)
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
+				error = -EEXIST;
 				goto abort;
 			}
 		spin_unlock(&all_mddevs_lock);
-- 
2.30.1

