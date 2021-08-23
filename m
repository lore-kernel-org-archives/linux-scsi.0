Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5C1C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55165613A6
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhHWUbG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhHWUaz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 16:30:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D136C06175F;
        Mon, 23 Aug 2021 13:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FypvegGWnnERKpPFbzVBwYTOoDfKrjdj29vUEVZP6fM=; b=dXL5wz6Yf1z+ahQ9qQ4ttU+dvq
        DjGgq+pvaxdWUTKvohT9ASHu6tku5/rYy1EnPNgldrCFk3yD39TJVlfJquyRKLsHqIiJzFCCf9zEE
        pm5SGGJ9nDC2hZkbGVkLPM0JZ5eJrWMVm0fcjDrep10c3KefYRbJqoDJd5BS8uFm7nWFDfvwLHsBx
        pApfvgyB8P7yC2UUhuaOTb6nFwji1X7GiFAftJNsz19Qf0MbHX8jkKZOz8dZaYQnUc8PigRGJ7gFg
        MUNL9wHLjR9wr4OQpbU8crnqSh1l8kz9FMqTtRNZ1OYfFbNkqVgxJN2qG6FevH6gC9dTORyE+o81W
        fr2CZAQw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIGZa-000ZjO-4g; Mon, 23 Aug 2021 20:29:34 +0000
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
Subject: [PATCH 03/10] scsi/sr: use blk_cleanup_disk() instead of put_disk()
Date:   Mon, 23 Aug 2021 13:29:23 -0700
Message-Id: <20210823202930.137278-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210823202930.137278-1-mcgrof@kernel.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The single put_disk() is useful if you know you're not doing
a cleanup after add_disk(), but since we want to add support
for that, just use the normal form of blk_cleanup_disk() to
cleanup the queue and put the disk.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a0df27db4d61..dc78ad96e6f9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -792,7 +792,7 @@ static int sr_probe(struct device *dev)
 	clear_bit(minor, sr_index_bits);
 	spin_unlock(&sr_index_lock);
 fail_put:
-	put_disk(disk);
+	blk_cleanup_disk(disk);
 	mutex_destroy(&cd->lock);
 fail_free:
 	kfree(cd);
-- 
2.30.2

