Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406FAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF846115B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhKCMZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhKCMYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 08:24:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8035BC06120A;
        Wed,  3 Nov 2021 05:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BViMo+Zb6g6L+/cspFNqXWo3whvvPf+EbrWuMOkqMY0=; b=txcMnnI3MTqtmRxLC8GvZp3Sdl
        4qu+lgSwgtrZ3N6EnH/Y7L3UyALyfEtemUQri9OT8tCLVZM4h99rswuPChJ2EbjIf3cwyhEdL17mo
        tPq9Z6H524vRrsocxb6W4TcZle64A3Jo9v6ZgCrM9K8Vh0djpjDU65E7XzaKS8v98oJIggmERrQ9v
        osD4IlczA09dSdhOzNPZq1+UjuBQDc1AZTd1KaB6uCzXYrycMNPje7tbVMM/cDIFPK38++UiNCKr6
        tXHOWx5oYa9WCiISLutCMUShGvPvNpASe08E5vrZKO67AEiWYUMlpXsdpR5O8gzCl7JRDzlm6z/36
        K5yBJr4w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miFHC-0056IQ-Dp; Wed, 03 Nov 2021 12:21:58 +0000
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
Subject: [PATCH v2 09/13] block/sunvdc: add error handling support for add_disk()
Date:   Wed,  3 Nov 2021 05:21:53 -0700
Message-Id: <20211103122157.1215783-10-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103122157.1215783-1-mcgrof@kernel.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
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

