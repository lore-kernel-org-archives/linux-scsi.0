Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A49C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243561AbhLVJCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243554AbhLVJCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:02:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2152C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1OPQmtTm5fzH9cg1OlhVhFoxfqWykJh4xN/MnRU6Go4=; b=NVPeIqwxJc/YRckBT13CfPQnEq
        4+gENcrsnOpMXEpJ7Iw7ESmljTb1mVkb07VV9b3AJfq1F6a19qOwnkPuRODOF4kfYThrbAew0iI6X
        RqEjNy8WgtYGDl+uRoiVZhP/dpDDoY2HCPpJNttDDhE0k252Z7XrMSDfuW8dsXlpRqo5h4fX9PIkS
        71G1+Pz48WOnjuixBaWEEpU7WHlHB6ffanBYeFVyipmgPF0TYVDKcMzj9ft/U4XIC7TbRLqEOd8UO
        HVhl/wFYPW5OVCRVwea9laTqHXa6JNotw0sxR7Oxs+IGvKOAIviybOubbpLZdtU+1kRzY697sW4ux
        UqQ6bLcw==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxVX-003E2W-Vb; Wed, 22 Dec 2021 09:02:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, bhe@redhat.com
Subject: [PATCH] sr: don't use GFP_DMA in get_capabilities
Date:   Wed, 22 Dec 2021 10:01:59 +0100
Message-Id: <20211222090159.916428-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The allocated buffer is used as a command payload, for which the block
layer and/or DMA API do the proper bounce buffering if needed.

Reported-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 14c122839c409..f925b1f1f9ada 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -855,7 +855,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
 		return;
-- 
2.30.2

