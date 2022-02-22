Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1242C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiBVOFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiBVOFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:05:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6A815F0AD;
        Tue, 22 Feb 2022 06:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bS7ZjGau1mrmDnGlWq1K3rQ3xYky9N8d7X8w0dBKMrM=; b=R3Sblgn5+C5/cyKmHNNA6EqBM4
        KcBFxKxMWPWdsi2uZ/ujuSjtPYo/U3WgpIFhft9UWTWipqzL4sAOWDL+xm0sUZNLhHOsdkCjGKVJb
        +BH4eLBRWMJ2dFa+FA8bwxEGs19XVXlIEYNvsm5NHfqn5rXMTeDs/pdToxqIwl0qnv53lnmal3/o0
        Kb+Q3MDtF4TmT5SbafV6jStRAVBG/b5sBIHeaIDd6WMnlASd1ZSHGiD4IAlJoSoJVuS6ASOoR3+Ro
        wPJTEtlCWuoURNH4mZV6eWVLFEMy6iMk98tcliLtSKGWmfuLAXnSxGtFERAYJnuKMMLHSRB56r6mv
        haMW3dEg==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVma-009nOv-9B; Tue, 22 Feb 2022 14:04:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 1/8] bsg: don't include scsi_request.h in bsg-lib.h
Date:   Tue, 22 Feb 2022 15:04:36 +0100
Message-Id: <20220222140443.589882-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222140443.589882-1-hch@lst.de>
References: <20220222140443.589882-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need for any of the information from scsi_request.h in
bsg-lib.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bsg-lib.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 6b211323a489c..9e97ced2896df 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -10,7 +10,6 @@
 #define _BLK_BSG_
 
 #include <linux/blkdev.h>
-#include <scsi/scsi_request.h>
 
 struct bsg_job;
 struct request;
-- 
2.30.2

