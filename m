Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2582CC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E9E26103A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhHWUbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbhHWUay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 16:30:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F270FC061575;
        Mon, 23 Aug 2021 13:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PfrtPFCUd+vz1Tgg1hQkj8zJ7tYmGxUAcqUzPySlWYA=; b=yD4BOzsjmHnK5qg88RUylmmo4x
        LuD3Z1YAXTY3+2DEjNWJP8B8YDsBytZ5Ws7NCdyXH6+IszaNyI7RcYTgogrS1cStxeAm/VJNjQznF
        VNszelhZ8qUPHoYETHBXKOmV5TuUwNk6uZ5D9IsTnfKwo/d/rSMOb1805A8RyTFYRI9Im0zm4RzsM
        s9seiCCpfZI4ntuSYeM/w875HulOk2W/qDUW4yeGjFTVCPEOyXRPN8n2zBUoArUD5lfU3Ur41llbM
        6j0unwzhFa84ekYFn58NNKW1yh7Re9B4iQQEfF8V1LfkgZOMWAxgpkMaBgejMHJmuttbRdBR+3Myq
        w3rQB8FA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIGZa-000ZjK-02; Mon, 23 Aug 2021 20:29:34 +0000
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
Subject: [PATCH 01/10] scsi/sd: use blk_cleanup_queue() insted of put_disk()
Date:   Mon, 23 Aug 2021 13:29:21 -0700
Message-Id: <20210823202930.137278-2-mcgrof@kernel.org>
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
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 610ebba0d66e..7d5217905374 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3508,7 +3508,7 @@ static int sd_probe(struct device *dev)
  out_free_index:
 	ida_free(&sd_index_ida, index);
  out_put:
-	put_disk(gd);
+	blk_cleanup_disk(gd);
  out_free:
 	sd_zbc_release_disk(sdkp);
 	kfree(sdkp);
-- 
2.30.2

