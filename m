Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F40FC43214
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B3860FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhH0TGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhH0TGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 15:06:24 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A5FC061757;
        Fri, 27 Aug 2021 12:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vjDH1jMfJBrZv4rfw/hLobkpUNKwZF7oRRD315NfMik=; b=UDpH5nMZgW9+w1jqkAOyg/yykO
        b/eQOyxSjD/FSHNDKdHeqsqWQOpYPAl2Iv6eXeGvoqKvUOIgzlWNOLds/Xy4C5s+45Jps7Dou3QhW
        nFbid6hD4iB7/hhkXH8WuBz8zN2YYTRTT6VD2074+UjhTecWpY74m6EEUm59vU7DLkvkIehNY56Tg
        HWSM4TNMIdtPiOLovMVPSUG+1vlEHWymw+H94k5Gd871cf9CNO19EcNNhOsWogeBHcGFxEDTsSAir
        HULNmNKF8+Mv11Q04qzjOXRg/RHI+fARzJplvvCAAUSJYj8zI5TsYx8wTMpIla2dh3e6/+V5+Spay
        Z3/aB1NQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhA1-00D1L3-8t; Fri, 27 Aug 2021 19:05:05 +0000
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
Subject: [PATCH v2 2/6] scsi/sr: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:05:00 -0700
Message-Id: <20210827190504.3103362-3-mcgrof@kernel.org>
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
 drivers/scsi/sr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 2942a4ec9bdd..72fd21844367 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -779,7 +779,10 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	sr_revalidate_disk(cd);
-	device_add_disk(&sdev->sdev_gendev, disk, NULL);
+
+	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
+	if (error)
+		goto fail_minor;
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
-- 
2.30.2

