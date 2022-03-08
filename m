Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC95CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343561AbiCHFxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242260AbiCHFxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169472B261;
        Mon,  7 Mar 2022 21:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ey4iYGQo/5eUoycN3wqBUIHIMNTI6TKepd9z/u4kEp4=; b=3p+4hiAqO05ZHr/jAr1ZaPqMPa
        s26SoDDmkgnRCJLAu36MwfXd4fh2HlZpSv4/TwOCNiLg+8XtlXVEEy73UJLeE1ko1ODegSh14Otwr
        8lEqvNw8yxx9j8XV/lxAxXKoudDrmH0FjknvkSPxns3gPV1It9z1NEJwPx58Hu+Q8YTbR1SUjcmUV
        VIoHRgmrvqdmko1Te8+vrsDeTowDeTMN7hWguS6LgcUzgpB27+/jNPwgfQIbU8zVAi9Vfjg+jPb1Y
        otdninwaokpPLVyZrw9dc3lDsY+GjowA/L8Ou+32mT0ka/YDfh30Rgq3uJt1l1xwBpnO3ZZrJInlC
        QdRNja6w==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSld-002ino-CS; Tue, 08 Mar 2022 05:52:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 06/14] sd: delay calling free_opal_dev
Date:   Tue,  8 Mar 2022 06:51:52 +0100
Message-Id: <20220308055200.735835-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308055200.735835-1-hch@lst.de>
References: <20220308055200.735835-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call free_opal_dev from scsi_disk_release as the opal_dev field is accessed
from the ioctl handler, which isn't synchronized vs sd_release and thus
can be accessed during or after sd_release was called.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

