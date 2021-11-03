Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8022DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A41611C1
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhKCXHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhKCXHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DABBC061203;
        Wed,  3 Nov 2021 16:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PVnqRR193BwJ4M+vx93QvRkriFPDEmeOtcXKAIUa5wk=; b=sdF+I17joo9hobYC/3+76elYa+
        N4Ca2+CuZ5EXJMTlZjZkAkcGXZyafnteMj/Jcyr+MsALQ8mFIUpoXNC1yE0O4lxi1DdkGSSXn4Eew
        Gm+FSgjYCpvd5Zmyb+dPujhUO6Sndf/3Hw4IEhtnZJ9Ckr4UZ+G8h6XB/D8KYqlFfsvvjiUO5dZSn
        ZH4P/l1MqVRvthD2NL1MqAxWY9lwFkhC8eiwNsuaKA9GLcRmYrunLQaIZ2eRMCbPzNos8MXB/5hVL
        PRtDl25Sds6Xnuvi6yqKEe9tdOTCAZVp/K+xR3JOyO9SKsZLHLJDAh55QUXovrwDQQamoBRQHji2+
        YMvFnWuA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seZ-Ne; Wed, 03 Nov 2021 23:04:38 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/14] block/sunvdc: add error handling support for add_disk()
Date:   Wed,  3 Nov 2021 16:04:31 -0700
Message-Id: <20211103230437.1639990-9-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

We re-use the same free tag call, so we also add a label for
that as well.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/sunvdc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 4d4bb810c2ae..6f45a53f7cbf 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -826,8 +826,8 @@ static int probe_disk(struct vdc_port *port)
 	if (IS_ERR(g)) {
 		printk(KERN_ERR PFX "%s: Could not allocate gendisk.\n",
 		       port->vio.name);
-		blk_mq_free_tag_set(&port->tag_set);
-		return PTR_ERR(g);
+		err = PTR_ERR(g);
+		goto out_free_tag;
 	}
 
 	port->disk = g;
@@ -879,9 +879,17 @@ static int probe_disk(struct vdc_port *port)
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
 	       port->vio.ver.major, port->vio.ver.minor);
 
-	device_add_disk(&port->vio.vdev->dev, g, NULL);
+	err = device_add_disk(&port->vio.vdev->dev, g, NULL);
+	if (err)
+		goto out_cleanup_disk;
 
 	return 0;
+
+out_cleanup_disk:
+	blk_cleanup_disk(g);
+out_free_tag:
+	blk_mq_free_tag_set(&port->tag_set);
+	return err;
 }
 
 static struct ldc_channel_config vdc_ldc_cfg = {
-- 
2.33.0

