Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FB7C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4EAF2137B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vHlbvsKx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgIHUHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730177AbgIHPTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 11:19:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D30DC0A3BEE;
        Tue,  8 Sep 2020 07:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=G29JkSXO5mbjv1FoDpuAl//FXROAUm+3biOsauwhg0s=; b=vHlbvsKxwv08eqpmwor/rS181u
        pd6OA/e5ygfhGkp0yWDJtY6SOc0uxzQrsYBb7B/GyBogtpahlEe1wZyshJTc+l2/qb8LpJkMczBaa
        2BYlSu0JKMKOkz932zO2kPeMys9d1Euva1Bg2RiXaS6D1X/KKlY7DYmulVzLwq7SuTqI0bFWQ5yRz
        9G9a7Ing/LxxOL5huRbqHUbpVNHIB3qU37xrAgf4zvFaufvYbS8OilLBXz9fctloFDbzz2eiRNamR
        BLu/np9dSOF9/rDyTaDdKv/VNTdwB1vIer09rQhs1/MEZ27xXbSQ6RP+NrYfGNPhUm4Te92A6goxH
        7Kirw/mQ==;
Received: from [2001:4bb8:184:af1:3dc3:9c83:fc6c:e0f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf0x-0002y5-Gx; Tue, 08 Sep 2020 14:54:33 +0000
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
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 09/19] xsysace: simplify media change handling
Date:   Tue,  8 Sep 2020 16:53:37 +0200
Message-Id: <20200908145347.2992670-10-hch@lst.de>
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

Pass a struct ace_device to ace_revalidate_disk, move the media changed
check into the one caller that needs it, and give the routine a better
name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/xsysace.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index eefe542f2d9fff..8d581c7536fb51 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -888,26 +888,20 @@ static unsigned int ace_check_events(struct gendisk *gd, unsigned int clearing)
 	return ace->media_change ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int ace_revalidate_disk(struct gendisk *gd)
+static void ace_media_changed(struct ace_device *ace)
 {
-	struct ace_device *ace = gd->private_data;
 	unsigned long flags;
 
-	dev_dbg(ace->dev, "ace_revalidate_disk()\n");
-
-	if (ace->media_change) {
-		dev_dbg(ace->dev, "requesting cf id and scheduling tasklet\n");
+	dev_dbg(ace->dev, "requesting cf id and scheduling tasklet\n");
 
-		spin_lock_irqsave(&ace->lock, flags);
-		ace->id_req_count++;
-		spin_unlock_irqrestore(&ace->lock, flags);
+	spin_lock_irqsave(&ace->lock, flags);
+	ace->id_req_count++;
+	spin_unlock_irqrestore(&ace->lock, flags);
 
-		tasklet_schedule(&ace->fsm_tasklet);
-		wait_for_completion(&ace->id_completion);
-	}
+	tasklet_schedule(&ace->fsm_tasklet);
+	wait_for_completion(&ace->id_completion);
 
 	dev_dbg(ace->dev, "revalidate complete\n");
-	return ace->id_result;
 }
 
 static int ace_open(struct block_device *bdev, fmode_t mode)
@@ -922,8 +916,8 @@ static int ace_open(struct block_device *bdev, fmode_t mode)
 	ace->users++;
 	spin_unlock_irqrestore(&ace->lock, flags);
 
-	if (bdev_check_media_change(bdev))
-		ace_revalidate_disk(bdev->bd_disk);
+	if (bdev_check_media_change(bdev) && ace->media_change)
+		ace_media_changed(ace);
 	mutex_unlock(&xsysace_mutex);
 
 	return 0;
@@ -1080,7 +1074,7 @@ static int ace_setup(struct ace_device *ace)
 		(unsigned long long) ace->physaddr, ace->baseaddr, ace->irq);
 
 	ace->media_change = 1;
-	ace_revalidate_disk(ace->gd);
+	ace_media_changed(ace);
 
 	/* Make the sysace device 'live' */
 	add_disk(ace->gd);
-- 
2.28.0

