Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3696BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 21:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiEWVTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiEWVTo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 17:19:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24788E1BF
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 14:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=f6JNB3csHl0xWiWOtnzfyqxno8xe9NWa+fXmz3QEL9o=; b=u1vErJUQiuQj/ilgFSagIOVkl+
        O1I+3rijKa9EgJAgLUPDIxl8/3c1grfu+gVQSTxqTXg4oWf3NVN4gG4fnGZ6UcYgnzdgHv0N6oV3u
        f9Jc8JbUFwmIOz0wgFD9gNmx1qF9fbKQsOLOxvmyOrbm5auFug9RtY44PTi8A+wKf3QoNH2O324I2
        8pjchNvaa/727m8xsOxGasVMasjtpFMpO0DpK3etYX7kvhSdzMuzlvNZjnOZdYBD2phD7Q0XCHZbG
        bW0+cAmIf1AI91sDaAmxM8sHMIHoh4BR8WN4pI9+m5sLDhRUcBX8NFP3VO10vAJUMf+OE5+AcvCAT
        ys0Z77xw==;
Received: from [2001:4bb8:19a:6dab:5f72:16bd:9d04:6b8a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nt3Zw-002Uxa-7M; Mon, 23 May 2022 08:38:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     haowenchao@huawei.com, linux-scsi@vger.kernel.org
Subject: [PATCH] sd: don't call blk_cleanup_disk in sd_probe
Date:   Mon, 23 May 2022 10:38:13 +0200
Message-Id: <20220523083813.227935-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In SCSI the midlayer has ownership of the request_queue, so on probe
failure we must only put the gendisk, but leave the request_queue alone.

Fixes: 03252259e18e ("scsi: sd: Clean up gendisk if device_add_disk() failed")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9694e2cfaf9a6..986de990cf0f7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3473,7 +3473,7 @@ static int sd_probe(struct device *dev)
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
 		put_device(&sdkp->disk_dev);
-		blk_cleanup_disk(gd);
+		put_disk(gd);
 		goto out;
 	}
 
-- 
2.30.2

