Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862E6C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6495A610A2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhI0WCN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbhI0WCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 18:02:07 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928FAC061765;
        Mon, 27 Sep 2021 15:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eOGl5IZyZNnFXmP+I7kKDBQKd7BBidBOUcZv+xPQqWI=; b=lliCu+eKd3V1P+/sYJ0yd2PCrh
        9ELPfdPTivFsxLYVUQdamOKpTZQ5EjeWqzTGXImkFZuCCORPUD+0L7y3MbC4152PxLGq8Q1x3nR/y
        WbH9zYoGLr25pTRIqdL8Iu252s6oS8y94K/V+SoZG/YWmCX6lWaIFAVta7RgjUzwN4eZpHHbAljny
        jv2QEBGFzrDs1l7laCe38Z7KLC4Fkl4R9S9hCiIPX6RUKp9M4N4rKNplc99ZW22MSmEaB6Zf+XayC
        yn1e0cU462V4kxPmlszoM+JuCqTn1LzCOZ63BKAAsE7Uby00tY6XZZ6oGKLaoejvN+6vYqRkn+h/6
        FCYNbmoQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyfM-004SV3-Vt; Mon, 27 Sep 2021 22:00:05 +0000
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
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 5/6] loop: add error handling support for add_disk()
Date:   Mon, 27 Sep 2021 14:59:57 -0700
Message-Id: <20210927215958.1062466-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927215958.1062466-1-mcgrof@kernel.org>
References: <20210927215958.1062466-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/loop.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7bf4686af774..00ee365ed5e0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2394,13 +2394,19 @@ static int loop_add(int i)
 	disk->event_flags	= DISK_EVENT_FLAG_UEVENT;
 	sprintf(disk->disk_name, "loop%d", i);
 	/* Make this loop device reachable from pathname. */
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_cleanup_disk;
+
 	/* Show this loop device. */
 	mutex_lock(&loop_ctl_mutex);
 	lo->idr_visible = true;
 	mutex_unlock(&loop_ctl_mutex);
+
 	return i;
 
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
 out_cleanup_tags:
 	blk_mq_free_tag_set(&lo->tag_set);
 out_free_idr:
-- 
2.30.2

