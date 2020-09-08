Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFD0C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF8FD207DE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:09:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L+kf2iFi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgIHUJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730233AbgIHPSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 11:18:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8944DC0A3BE5;
        Tue,  8 Sep 2020 07:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=k8onoG5ZAmqes0/YNPEm1fOxgUYZcqpa4wYL4dv7ed8=; b=L+kf2iFiaq49eBGYyU51W5owUQ
        gznhXleN5LnzS5k+M1FO5nbyL+/uk1lqQWpKwa5gDYbKIRZDkl/vub3sLE0ce+Nhysxkgd3sFXN7g
        o/z+ogUkDz6CICdPX256IbKvTsH9w7xnqLPU4NzrpHMhlIvezag+/LPyAEEcgSslAEsSJwh4x/MOt
        lrIOcMy4tZCmEZV2xOF/I8SoQOokjzzwP2upeUD4XG8smoOVaQhKU651EBFT39IK/9Qeh0pc5LOqD
        Ry6wkJQzMxd9fif10gJXTAH4yXBAWkZIAg3Vj5bfs8X5F8OIn06OTqQd7bfZRKJEpXXzVFVjZl2CN
        7TMbdHhA==;
Received: from [2001:4bb8:184:af1:3dc3:9c83:fc6c:e0f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf0k-0002wu-1Y; Tue, 08 Sep 2020 14:54:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Denis Efremov <efremov@linux.com>, Tim Waugh <tim@cyberelk.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/19] swim: use bdev_check_media_change
Date:   Tue,  8 Sep 2020 16:53:33 +0200
Message-Id: <20200908145347.2992670-6-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908145347.2992670-1-hch@lst.de>
References: <20200908145347.2992670-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to use bdev_check_media_change instead of check_disk_change and
call floppy_revalidate manually.  Given that floppy_revalidate only
deals with media change events, the extra call into ->revalidate_disk
from bdev_disk_changed is not required either, so stop wiring up the
method.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/block/swim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index dd34504382e533..d4565c555b289f 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -217,6 +217,8 @@ extern int swim_read_sector_header(struct swim __iomem *base,
 extern int swim_read_sector_data(struct swim __iomem *base,
 				 unsigned char *data);
 
+static int floppy_revalidate(struct gendisk *disk);
+
 static DEFINE_MUTEX(swim_mutex);
 static inline void set_swim_mode(struct swim __iomem *base, int enable)
 {
@@ -638,7 +640,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		return 0;
 
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		check_disk_change(bdev);
+		if (bdev_check_media_change(bdev))
+			floppy_revalidate(bdev->bd_disk);
 		if ((mode & FMODE_WRITE) && fs->write_protected) {
 			err = -EROFS;
 			goto out;
@@ -760,7 +763,6 @@ static const struct block_device_operations floppy_fops = {
 	.ioctl		 = floppy_ioctl,
 	.getgeo		 = floppy_getgeo,
 	.check_events	 = floppy_check_events,
-	.revalidate_disk = floppy_revalidate,
 };
 
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
-- 
2.28.0

