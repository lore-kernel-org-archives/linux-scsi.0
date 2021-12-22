Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A3EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbhLVJQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhLVJQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:16:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6095C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+sGWUnCFBrD9bHgUzKO1bOsFuJwLaMB6HwehOVJCOKI=; b=RSb/Gnckib8E94A2Kl9SUiy6p9
        STsmUsctLASbqZxAzkNuA3QQdgJd7Nw4L3nmxpPGSFCcB1QBfo+bx20IwbhLqjuNASvVugtpu6sJB
        w8AkAgWMwDtZLgMLp5OZ1aaaHeKysQxerJHnlL2vGIxNjM/YrzFz2KFhKvdNbT3cWFS38TP2ZsjuI
        c8bVykvhNEQBcEFe2eEXq6cL3IorGzPbDZ2aDEDQlesK+SLPUXbeKr68T9MbVDQ/xIF8G+2cQ3BeS
        tu/mR6kcq6vEhtqJg00TOx91a81M4pSfFxtCWXzTHqAeQS1MvcQVJZlZ35j0OO6IshWjoQ0Gjx1By
        +sZ2kXpQ==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxjb-003ElD-Ne; Wed, 22 Dec 2021 09:16:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] initio: don't use GFP_DMA in initio_probe_one
Date:   Wed, 22 Dec 2021 10:16:30 +0100
Message-Id: <20211222091630.922788-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver doesn't express DMA addressing limitation under 32-bits
anywhere else, so remove the spurious GFP_DMA allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/initio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9cdee38f5ba33..5f96ac47d7fd1 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2847,7 +2847,8 @@ static int initio_probe_one(struct pci_dev *pdev,
 
 	for (; num_scb >= MAX_TARGETS + 3; num_scb--) {
 		i = num_scb * sizeof(struct scsi_ctrl_blk);
-		if ((scb = kzalloc(i, GFP_DMA)) != NULL)
+		scb = kzalloc(i, GFP_KERNEL);
+		if (scb)
 			break;
 	}
 
-- 
2.30.2

