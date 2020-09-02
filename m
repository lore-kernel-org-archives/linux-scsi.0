Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CAAC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 14:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D84C12078E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 14:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j+QL9jE7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgIBOYY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgIBONl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 10:13:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7F5C061238;
        Wed,  2 Sep 2020 07:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pHiqycenC5upRX3UETZr2TphPJ65ZgHAjyHjztQKjqU=; b=j+QL9jE789kltyP3d8MfmeGjUp
        vIQPRvKSlM+AF3f4mem9cz69BSox1nMdOkuF3LVW0FOdpmMTB6pu5AMY4qZY0fl77mu+9vvqNrFoK
        3dRV3qDFzfVCMYnw1Usfx6/OH+mpoEwo3n2IsQjcdqA+0LAB6pGWHUiagsCD8P508GeMfdkDoMGfD
        Z0uWoOb9pmDm7VE8zfI98JlnjAwUNsmmVq9T/H1wgSYBwI+qLkI72+N6yrZLplnlwo0UTa3pQN9nt
        s8tRuSanSwYNDQU0vTaZ/6wfQ2Bi+lmIgHVm11xVopjWa6mix+3h3vKuq+cWl+rW3cIiDofpv+KRk
        wv00lcKQ==;
Received: from [2001:4bb8:184:af1:6a63:7fdb:a80e:3b0b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDTVF-0005gb-1H; Wed, 02 Sep 2020 14:12:45 +0000
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
Subject: [PATCH 18/19] sr: simplify sr_block_revalidate_disk
Date:   Wed,  2 Sep 2020 16:12:17 +0200
Message-Id: <20200902141218.212614-19-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902141218.212614-1-hch@lst.de>
References: <20200902141218.212614-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both callers have a valid CD struture available, so rely on that instead
of getting another reference.  Also move the function to avoid a forward
declaration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 34be94b62523fa..2b43c0f97442d4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -86,7 +86,6 @@ static int sr_remove(struct device *);
 static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
 static int sr_done(struct scsi_cmnd *);
 static int sr_runtime_suspend(struct device *dev);
-static int sr_block_revalidate_disk(struct gendisk *disk);
 
 static const struct dev_pm_ops sr_pm_ops = {
 	.runtime_suspend	= sr_runtime_suspend,
@@ -518,6 +517,17 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	return ret;
 }
 
+static void sr_revalidate_disk(struct scsi_cd *cd)
+{
+	struct scsi_sense_hdr sshdr;
+
+	/* if the unit is not ready, nothing more to do */
+	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
+		return;
+	sr_cd_check(&cd->cdi);
+	get_sectorsize(cd);
+}
+
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
 {
 	struct scsi_cd *cd;
@@ -531,7 +541,7 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 	sdev = cd->device;
 	scsi_autopm_get_device(sdev);
 	if (bdev_check_media_change(bdev))
-		sr_block_revalidate_disk(bdev->bd_disk);
+		sr_revalidate_disk(cd);
 
 	mutex_lock(&cd->lock);
 	ret = cdrom_open(&cd->cdi, bdev, mode);
@@ -660,26 +670,6 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 	return ret;
 }
 
-static int sr_block_revalidate_disk(struct gendisk *disk)
-{
-	struct scsi_sense_hdr sshdr;
-	struct scsi_cd *cd;
-
-	cd = scsi_cd_get(disk);
-	if (!cd)
-		return -ENXIO;
-
-	/* if the unit is not ready, nothing more to do */
-	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
-		goto out;
-
-	sr_cd_check(&cd->cdi);
-	get_sectorsize(cd);
-out:
-	scsi_cd_put(cd);
-	return 0;
-}
-
 static const struct block_device_operations sr_bdops =
 {
 	.owner		= THIS_MODULE,
@@ -803,7 +793,7 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
-	sr_block_revalidate_disk(disk);
+	sr_revalidate_disk(cd);
 	device_add_disk(&sdev->sdev_gendev, disk, NULL);
 
 	sdev_printk(KERN_DEBUG, sdev,
-- 
2.28.0

