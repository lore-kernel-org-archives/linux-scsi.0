Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70252C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A8F760F25
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhH0TGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhH0TGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 15:06:19 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF468C0613CF;
        Fri, 27 Aug 2021 12:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+F5KOCzrXZghph/UppvQA2s1yRYbitmFgtgTDMNdZxo=; b=hdN3JaT+AqcwLsMn/aaHu7lvCV
        WPBXcM/Bc55Jl2bdP4zzl1i4OkwfgYt9QwkJ34Pba94cSPfCrXNdfGQqms73HQZ5MzJy2T6L8WRzL
        yGgamUknYLP9Yh623OkoBvx0GPtuUBuvsnqLK6/Jy+NDw6kfK5ngmbAIqv2L2mxDW22ybKkoh0NWt
        iTZLRbGQ8aQ2lP0Ktu7ioEUWq+Jsp94KnyLLak9pKQGugpm+fxfzA9OvNwmX+oUucTgIsK5CgWU/T
        rKq3whJCDsNpCuDw1jnrJJ2RCr+fDFx2tLFpqxW5qzOzNUcjWo+cPgoU9rAJAWWztHoU+YteGk2nt
        J/H7NqXw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhA1-00D1L1-6a; Fri, 27 Aug 2021 19:05:05 +0000
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
Subject: [PATCH v2 1/6] scsi/sd: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:04:59 -0700
Message-Id: <20210827190504.3103362-2-mcgrof@kernel.org>
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
 drivers/scsi/sd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 610ebba0d66e..8c1273fff23e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3487,7 +3487,11 @@ static int sd_probe(struct device *dev)
 		pm_runtime_set_autosuspend_delay(dev,
 			sdp->host->hostt->rpm_autosuspend_delay);
 	}
-	device_add_disk(dev, gd, NULL);
+
+	error = device_add_disk(dev, gd, NULL);
+	if (error)
+		goto out_free_index;
+
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
 
-- 
2.30.2

