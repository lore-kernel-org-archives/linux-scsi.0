Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A20C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiBVOPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiBVOPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:15:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEC8160414;
        Tue, 22 Feb 2022 06:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/yrARgfIhefLqCIjYXiNSDhJWLcvmZMEYSZx+ORhKc0=; b=W6S4E9SpiOdNzqisaySEILbUl1
        L829kdATw5XJLT9NIRbweWg+/bb5ynoW+E2hyF49t/JVBFNL8SDSQXyoTkgAtBNA+oxDqbtjd4vjT
        kYOC0Q0fMLpSQAtCyvbCPtuiOOVGm3qgRZyV+NjlwDJUKL92mHLjiWNrFZaOTG8OTpX+1Ntt8BFNF
        7zqR8UHKGym7ZWb5hgcc6mmuVov3RGgGabFgExkjk1oC1S30PtC6WpUfD1ENTlTgZQKoovQw/xDUK
        YGkhcJ1xBN1FGBBX5catZd8+rcOjByuxiSEYBFJ5YZdDjzgURZOYEFjUK+d58Rf1+3vSF8daK8SE3
        cDnr3MiA==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwY-009qH2-25; Tue, 22 Feb 2022 14:15:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 05/12] sd: remove the extra sdev_gendev reference
Date:   Tue, 22 Feb 2022 15:14:43 +0100
Message-Id: <20220222141450.591193-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

device_add already takes a reference on the parent, not need to take an
extra one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4eaa5deafc3dc..041c21c9483f6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3503,7 +3503,7 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = get_device(dev);
+	sdkp->dev.parent = dev;
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
@@ -3615,7 +3615,6 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
 	ida_free(&sd_index_ida, sdkp->index);
-	put_device(&sdkp->device->sdev_gendev);
 	sd_zbc_release_disk(sdkp);
 	kfree(sdkp);
 }
-- 
2.30.2

