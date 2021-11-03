Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3544C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A07604DC
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhKCXHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhKCXH2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48F1C061714;
        Wed,  3 Nov 2021 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bSdQkdtzeMIsv/fiegTTyrgOoGG2IbE1031f9dG1m7k=; b=SOMEVrTyVfZBBL9EopTS4zMZEQ
        M7N4DqJjNNjkJKn2kClSOYCU1q5RxhTrJdi0zV+36Tf29klTtn6mzy3LHIu83kiogodhSo9zQ/5jp
        23h0hji/c6S9kRD950LhKEGB3yX87lFGdsit4J0PldpJYfJKidjB3S+EW+h2M10Fll2pvqqD+hf5G
        ZAGeL8KrHU4MuRD7Gt71ZfrwSl11ewfdWkQoHBxgMYgKsgbUj1A2apPIUlYwSnJ+0NSjfDpG4HRJd
        FXAfh8uEofnple1tcwfI1G+yG5Ki9pKGfQ3f7kB4Fjcd0nu4ma+taNS4to0gZPg2QzbjtqsiBJYaX
        tGCVkabg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seX-Mg; Wed, 03 Nov 2021 23:04:38 +0000
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
Subject: [PATCH v5 07/14] z2ram: add error handling support for add_disk()
Date:   Wed,  3 Nov 2021 16:04:30 -0700
Message-Id: <20211103230437.1639990-8-mcgrof@kernel.org>
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
error handling. Only the disk is cleaned up inside
z2ram_register_disk() as the caller deals with the rest.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/z2ram.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 4eef218108c6..ccc52c935faf 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -318,6 +318,7 @@ static const struct blk_mq_ops z2_mq_ops = {
 static int z2ram_register_disk(int minor)
 {
 	struct gendisk *disk;
+	int err;
 
 	disk = blk_mq_alloc_disk(&tag_set, NULL);
 	if (IS_ERR(disk))
@@ -333,8 +334,10 @@ static int z2ram_register_disk(int minor)
 		sprintf(disk->disk_name, "z2ram");
 
 	z2ram_gendisk[minor] = disk;
-	add_disk(disk);
-	return 0;
+	err = add_disk(disk);
+	if (err)
+		blk_cleanup_disk(disk);
+	return err;
 }
 
 static int __init z2_init(void)
-- 
2.33.0

