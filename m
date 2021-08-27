Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28256C43216
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1280060FF2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhH0TGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhH0TGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 15:06:22 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3450CC0613D9;
        Fri, 27 Aug 2021 12:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hc6+PdzrnVmkCNkRHjEi79cwLRliAERVgct1KBgFYaI=; b=AGM+3D6pQGdnQDd1fVV8o+xkzx
        Ugk395FVFpk8GTUU4a3wxe9T22zXvlOxjgwH7jyB1cuptuRlJrzE1Ppmwk1Rps3mbiYaGY2fPGJCc
        /jtLgzcx825WzuOq+kHxUo9U7ra49uysnB9bFRQ+DznLH0tzqpPuM1SvEDTjg6b0x3Mmt6j/dQYoa
        Ad6gGe5p1Dw9MphESPh4fDUzmRkToas5UI9/jdNEI2OiK1WcUkhSIzCG30hIPsKCDgft9SsPzBs7S
        /W8++Qg60Tn63L+irONkdHRRtntkRpdl4eweUO49pK+o2zImO//qPIrBN1bxROLQlE8Viry8HehcJ
        KNiuZJgw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhA1-00D1L9-Fu; Fri, 27 Aug 2021 19:05:05 +0000
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
Subject: [PATCH v2 5/6] loop: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:05:03 -0700
Message-Id: <20210827190504.3103362-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827190504.3103362-1-mcgrof@kernel.org>
References: <20210827190504.3103362-1-mcgrof@kernel.org>
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
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/loop.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fa1c298a8cfb..b8b9e2349e77 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2393,10 +2393,17 @@ static int loop_add(int i)
 	disk->events		= DISK_EVENT_MEDIA_CHANGE;
 	disk->event_flags	= DISK_EVENT_FLAG_UEVENT;
 	sprintf(disk->disk_name, "loop%d", i);
-	add_disk(disk);
+
+	err = add_disk(disk);
+	if (err)
+		goto out_cleanup_disk;
+
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

