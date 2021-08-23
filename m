Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A72EC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6668B613D5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhHWUbM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbhHWUa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 16:30:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6B4C061575;
        Mon, 23 Aug 2021 13:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZwxyFXcOiGq8qChS2d1Notj23dWo1Us0XnbUDLeBwX8=; b=gwLOjM3XIyBov1gksucnFV6ooL
        M14P6xtIFkqJWDvnJ+/ICsQQuOeHg3bNCCgwD6eLd1QGFRv9hRZPIwrwVVrc4GRJ2n6pYIZ5XmSrw
        rcx7adfg7jhXfbkhk5O7HByT/5+LX1pVl9RViZEXYV9+8xJ3lT8eOaknnO+IUd6QKllMR3/xq5hgf
        N/goUQWSvkvYz8acad20DJCfe0uNYcHhGoEl2FNlkDkG744ujAzQBIJJRxGvJnJbLar1t7aga4T7o
        AhjcvHCAtsXTrVTXcoPwJ/DRxC2CyMVvuuTQ1zXJ5xHiLfHnsJzmkEfKV0hbmwsmiMIBYmw4pns41
        bG+HsJfw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIGZa-000ZjY-Cl; Mon, 23 Aug 2021 20:29:34 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 08/10] dm: add add_disk() error handling
Date:   Mon, 23 Aug 2021 13:29:28 -0700
Message-Id: <20210823202930.137278-9-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210823202930.137278-1-mcgrof@kernel.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7981b7287628..cd26fde4ab56 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2077,15 +2077,21 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	add_disk(md->disk);
+	r = add_disk(md->disk);
+	if (r)
+		goto out_cleanup_disk;
 
 	r = dm_sysfs_init(md);
-	if (r) {
-		del_gendisk(md->disk);
-		return r;
-	}
+	if (r)
+		goto out_del_gendisk;
 	md->type = type;
 	return 0;
+
+out_cleanup_disk:
+	blk_cleanup_disk(md->disk);
+out_del_gendisk:
+	del_gendisk(md->disk);
+	return r;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)
-- 
2.30.2

