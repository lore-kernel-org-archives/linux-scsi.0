Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C1AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 07:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC8C160E08
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 07:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhJZHOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 03:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbhJZHOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 03:14:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00EAC061228;
        Tue, 26 Oct 2021 00:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eueqFLDfXyu67XUBkfh7IIASRRtwQp7VAgjQX0ljQbA=; b=ykdqigtWZ4RlroI8oTLwEzEdV/
        XJEhzF4hEzX1jFrRBgLBNWQN/QJ5pD80KuyCFd+xTDHnDl31g7WvyS+1/8HbFmwHuYtmmXovNO/ss
        1EcSrvyimXfYxfbdHOuMsKBCZOjjJlrOZvWUlhx77MeOZZMQjpRWgGDLC8WtJ6gcjkGO2T+sWFKTa
        wXmwj8x0OIc21bMF41qUKHn7W5qxOjGOnDGzEjqt2z9u8uJlWYQFtsDQrikyCZGt5ylDSToMuZBMQ
        k45Y0UILHt+mkOAlVaAjH8wZga/RE0WvQ2v+nHLwb85adpurw00KIexxkYrAi0z3gpp4H9GV6xMtf
        /mAssfVw==;
Received: from [2001:4bb8:199:7b1d:2c1c:1676:fb5a:c05f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfGcx-000pkw-2e; Tue, 26 Oct 2021 07:12:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH] scsi: ufs: mark HPB support as BROKEN
Date:   Tue, 26 Oct 2021 09:12:04 +0200
Message-Id: <20211026071204.1709318-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The HPB support added this merge window is fundanetally flawed as it
uses blk_insert_cloned_request to insert a cloned request onto the same
queue as the one that the original request came from, leading to all
kinds of issues in blk-mq accounting (in addition to this API being
a special case for dm-mpath that should not see other users).

Mark is as BROKEN as the non-intrusive alternative to a last minute
large scale revert.

Fixes: f02bc9754a68 ("scsi: ufs: ufshpb: Introduce Host Performance Buffer
feature")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 432df76e6318a..7835d9082aae4 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -186,7 +186,7 @@ config SCSI_UFS_CRYPTO
 
 config SCSI_UFS_HPB
 	bool "Support UFS Host Performance Booster"
-	depends on SCSI_UFSHCD
+	depends on SCSI_UFSHCD && BROKEN
 	help
 	  The UFS HPB feature improves random read performance. It caches
 	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
-- 
2.30.2

