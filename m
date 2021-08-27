Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D854DC41537
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE52361008
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhH0TG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhH0TGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 15:06:23 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123AEC061796;
        Fri, 27 Aug 2021 12:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5zQ5zmFlRLt8Vc/PBo5Ci+3uvu0k1+9yu+E5gjjsKZw=; b=btHP3MX2IbvBzhBm2GOVDzBh8x
        Z4oOq6Lnc4q9cz14k/vYx35ffeQpqPcWhUZckBuf8BgKZ2w+YhLZsB4+UeoMRvCVLmIwGOvsxM0V3
        1thFHxvYG5Eq9Uqr20+toHyWwJB0+wB4picKhosR6mzE3o7PoEoVC9hjDaYr6d9HsUXVR6bb/6XEm
        TT+J5cy5F3LczsmEN73PjJkxa9oIVczN9e8mPjCYkXuabRNwwWS3RtsVv3pFw1eqJA8ZN4Qta+AD1
        nhzrWIiNn9EJjM+dw5mN7Idxpeac9h2iVwsnAgA3tdRN7gzoAy0J6qQXZHefYiH2Hg5hKDI9LryA4
        8ktHQyBg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhA1-00D1L7-DY; Fri, 27 Aug 2021 19:05:05 +0000
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
Subject: [PATCH v2 4/6] md: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:05:02 -0700
Message-Id: <20210827190504.3103362-5-mcgrof@kernel.org>
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

We just do the unwinding of what was not done before, and are
sure to unlock prior to bailing.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/md.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae8fe54ea358..5c0d3536d7c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5704,7 +5704,11 @@ static int md_alloc(dev_t dev, char *name)
 	 * through to md_open, so make sure it doesn't get too far
 	 */
 	mutex_lock(&mddev->open_mutex);
-	add_disk(disk);
+	error = add_disk(disk);
+	if (error) {
+		blk_cleanup_disk(disk);
+		goto abort_unlock;
+	}
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error) {
@@ -5718,6 +5722,7 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		pr_debug("pointless warning\n");
+ abort_unlock:
 	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
-- 
2.30.2

