Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8C8C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1305320724
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A3a84hy7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgJ2PSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgJ2PSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:18:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8D8C0613CF;
        Thu, 29 Oct 2020 08:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=j1+pYW0vuZp0inoHXso4VuwwFtAmIdoeU+xGyyUccYU=; b=A3a84hy74xHm/L0yw/7Tw6JPOM
        rEjUBAmbC+WjOBf8MI7QFdiCZBXz9oD4v0AfPRIAoBa1qKXcgPFrRrDao1KiImWKwYrCruPe/scOD
        c8GgkXg6W4V+8HCDkq9ZrHD4Snh1zpUuuP4All0wxqCizBiZO7WVLfQV9GaPeTnwkCMPoPoOYV1c2
        GG+jJ+Z3P56/Pw1bREfsQdJQggDW4ktYUgh7chL+nmJHNUqy/d7d229Ko4Q2gT7DS1ZZk6AW2XdmA
        rA85TDnJRjMoUS4jeCui5AzWfbJXTS/R09K9lgnW3IZUgjDGE4AXUuSVINHHy8KoOvQIHIM06IBly
        dy4JZ8Aw==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9hH-0006bt-9P; Thu, 29 Oct 2020 15:18:40 +0000
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
Subject: [PATCH 08/18] sd: use __register_blkdev to avoid a modprobe for an unregistered dev_t
Date:   Thu, 29 Oct 2020 15:58:31 +0100
Message-Id: <20201029145841.144173-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch from using blk_register_region to the probe callback passed to
__register_blkdev to disable the request_module call for an unclaimed
dev_t in the SD majors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 656bcf4940d6d1..106a9cda0eb7ed 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -630,13 +630,11 @@ static struct scsi_driver sd_template = {
 };
 
 /*
- * Dummy kobj_map->probe function.
- * The default ->probe function will call modprobe, which is
- * pointless as this module is already loaded.
+ * Don't request a new module, as that could deadlock in multipath
+ * environment.
  */
-static struct kobject *sd_default_probe(dev_t devt, int *partno, void *data)
+static void sd_default_probe(dev_t devt)
 {
-	return NULL;
 }
 
 /*
@@ -3528,9 +3526,6 @@ static int sd_remove(struct device *dev)
 
 	free_opal_dev(sdkp->opal_dev);
 
-	blk_register_region(devt, SD_MINORS, NULL,
-			    sd_default_probe, NULL, NULL);
-
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
 	put_device(&sdkp->dev);
@@ -3720,11 +3715,9 @@ static int __init init_sd(void)
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
 
 	for (i = 0; i < SD_MAJORS; i++) {
-		if (register_blkdev(sd_major(i), "sd") != 0)
+		if (__register_blkdev(sd_major(i), "sd", sd_default_probe))
 			continue;
 		majors++;
-		blk_register_region(sd_major(i), SD_MINORS, NULL,
-				    sd_default_probe, NULL, NULL);
 	}
 
 	if (!majors)
@@ -3797,10 +3790,8 @@ static void __exit exit_sd(void)
 
 	class_unregister(&sd_disk_class);
 
-	for (i = 0; i < SD_MAJORS; i++) {
-		blk_unregister_region(sd_major(i), SD_MINORS);
+	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
-	}
 }
 
 module_init(init_sd);
-- 
2.28.0

