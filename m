Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37AAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbiCDQEs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbiCDQEo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:04:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0721AEEF1;
        Fri,  4 Mar 2022 08:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6wg+w8GZ192W5QuwW4UhV87GAqIxYCRr5YjV0LSfqZk=; b=vdhHkqJnWCwwT1gxPj6zal3iGL
        BVJPB0leZs8ya8z+lKlGA/tF0fp7BV/NWPkgx1vl3BaI2W3ZkxL6NgOCd1h+HG1Rdm6273gYRNH+3
        PbSAFBbhRcK01Sl0aMG5dpIFSByS9+U3BE/KengRPnE34uDCYqHlzQmYrD/iQODyIgyPC17OYV/5d
        Q/h8jIgf1WPfMBnYqYQOe3ASwzb+JOAMLaQh1UMy5WoqRR/OnsoKEuo9RNRUJifrJ8aPbOwLxgVy9
        rcDnyodcpIjrgFx27RG6Jok4vwsRV+h27TghJiZNK1JQJe7xXS5S/a/NZcwgzZj6rhExwd3vKk+YS
        BcV2zueg==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAPI-00Au1G-LZ; Fri, 04 Mar 2022 16:03:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 06/14] sd: delay calling free_opal_dev
Date:   Fri,  4 Mar 2022 17:03:23 +0100
Message-Id: <20220304160331.399757-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304160331.399757-1-hch@lst.de>
References: <20220304160331.399757-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call free_opal_dev from scsi_disk_release as the opal_dev field is access
from the ioctl handler, which isn't synchronized vs sd_release and thus
can be accesses during or after sd_release was called.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7bfebf5b2832d..346b8d62de7d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3632,8 +3632,6 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
-	free_opal_dev(sdkp->opal_dev);
-
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
 	put_device(&sdkp->disk_dev);
@@ -3675,6 +3673,7 @@ static void scsi_disk_release(struct device *dev)
 
 	sd_zbc_release_disk(sdkp);
 	put_device(&sdkp->device->sdev_gendev);
+	free_opal_dev(sdkp->opal_dev);
 
 	kfree(sdkp);
 }
-- 
2.30.2

