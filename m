Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C07C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2932260C3F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhH3V1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 17:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhH3V1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 17:27:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F56EC061575;
        Mon, 30 Aug 2021 14:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WTt6co9aMh6mvScZ9iBbQqfH9JL07+Ub8ZGagy/NNLs=; b=tVJduLKsKuzH6DQbYj5Uo9JQTW
        1IRZjUFKNLWOQDiawF2+M6Vi9c5O0TqaaBFQKZgj+cQOofOx7xs+y2GKxC0lEBSisNHDWu3M0PjD+
        6qcVN0JPMFVL2ogRublpXfSUA2tFX9EpieNV81/en+Gu1C7+9JDFFTgYk9vFfNECLrCLdEVxDGZ09
        qpMpaVofwlm+OZOST6G6Ll3Z8YVt/2bvttAVM9rGAZTChiSK3Jq5vHD/jNtKenK6zm/jqjbTh2Jnt
        Z1KqpW0OuRach3IKoiazRwkoj44g3yH0hS5r86rRlqUS+Fi1LuMarsFYab6q9v9siMjLJoH7wsXsj
        96YR6Xrw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKomk-000ciH-RM; Mon, 30 Aug 2021 21:25:42 +0000
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
Subject: [PATCH v3 6/8] dm: add add_disk() error handling
Date:   Mon, 30 Aug 2021 14:25:36 -0700
Message-Id: <20210830212538.148729-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830212538.148729-1-mcgrof@kernel.org>
References: <20210830212538.148729-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

There are two calls to dm_setup_md_queue() which can fail then,
one on dm_early_create() and we can easily see that the error path
there calls dm_destroy in the error path. The other use case is on
the ioctl table_load case. If that fails userspace needs to call
the DM_DEV_REMOVE_CMD to cleanup the state - similar to any other
failure.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7981b7287628..4e6b9d6ac508 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2077,7 +2077,9 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	add_disk(md->disk);
+	r = add_disk(md->disk);
+	if (r)
+		return r;
 
 	r = dm_sysfs_init(md);
 	if (r) {
-- 
2.30.2

