Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF42C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243866AbhLVJTm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243856AbhLVJTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:19:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F72C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mdRxViUxa8bkSZBy6vQSuwuaEY6bZbTojzGVU2ecDTc=; b=o6Zxjvug0Hl5nCYWPByBfF24PK
        Cn9RlNccItqqoothBpynHCmkys1f9VDlg6dRwrUDNDu4JyStNfJaaB0OQ901gV5NwhDEnTsQB9PIl
        1e2SzJpCL1gdPEjp/oYJ9gB9mrnlYqQwXLWHyo08Pc7ymw/IocXG7koL0ROgdOYLr8oO1MDf17L7l
        LgUhG/0UkMIEBFr5afyWPbqBDvCtKXmknehCV2FzaHO1E73SGoLCcZKoawrWsoLz8xp1lCeVRsl/V
        fHSzU/s2nqLzBMLNg/i1Ur8yhccigAZbqqff5sRMeuOkAhI+4fVxLXEL7UO/aeYizUAYXVXLKcI5a
        3pEiaruA==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxma-003EtU-P9; Wed, 22 Dec 2021 09:19:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com, hare@kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] myrs: don't use GFP_DMA
Date:   Wed, 22 Dec 2021 10:19:35 +0100
Message-Id: <20211222091935.925624-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The myrs devices supports 64-bit addressing, so remove the spurious
GFP_DMA allocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/myrs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 6ea323e9a2e34..253ceca54a84d 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -538,13 +538,11 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 		cs->fwstat_buf = NULL;
 		goto out_free;
 	}
-	cs->ctlr_info = kzalloc(sizeof(struct myrs_ctlr_info),
-				GFP_KERNEL | GFP_DMA);
+	cs->ctlr_info = kzalloc(sizeof(struct myrs_ctlr_info), GFP_KERNEL);
 	if (!cs->ctlr_info)
 		goto out_free;
 
-	cs->event_buf = kzalloc(sizeof(struct myrs_event),
-				GFP_KERNEL | GFP_DMA);
+	cs->event_buf = kzalloc(sizeof(struct myrs_event), GFP_KERNEL);
 	if (!cs->event_buf)
 		goto out_free;
 
@@ -1805,7 +1803,7 @@ static int myrs_slave_alloc(struct scsi_device *sdev)
 
 		ldev_num = myrs_translate_ldev(cs, sdev);
 
-		ldev_info = kzalloc(sizeof(*ldev_info), GFP_KERNEL|GFP_DMA);
+		ldev_info = kzalloc(sizeof(*ldev_info), GFP_KERNEL);
 		if (!ldev_info)
 			return -ENOMEM;
 
@@ -1867,7 +1865,7 @@ static int myrs_slave_alloc(struct scsi_device *sdev)
 	} else {
 		struct myrs_pdev_info *pdev_info;
 
-		pdev_info = kzalloc(sizeof(*pdev_info), GFP_KERNEL|GFP_DMA);
+		pdev_info = kzalloc(sizeof(*pdev_info), GFP_KERNEL);
 		if (!pdev_info)
 			return -ENOMEM;
 
-- 
2.30.2

