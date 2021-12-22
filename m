Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CA9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhLVJU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhLVJU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:20:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028E4C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YhW3CiM5hGu6rvMpd/n/Ng5bkpSrpUn4y8tGOenwl5o=; b=HiNFdp0L/KafXMAtL1QhHcvlQs
        GAqger9C2FFEi0o3McnCncZTNF8+76F9RdRh9SIjO7X78xz4Il90X5Z9Z24d/XGEH7P2+tPsRQJwp
        gZB6dxToIrfcI5GWiRegLWyTBrNgWlovAhbGZigJUHkImPVrFq7yP4F37qUxjKzFCF2YCdJFZ68+Z
        8YUcQsNkLEORMSvFLD2bKqoA+tCJZh4q1ySScSAabSuaptcAqU8yEBcxPCdNIBW2ySSdEKmHtgP7y
        DbUaZldoKGOnQs+iEGt68bhxA/fZgJxO4HIZ7ywGacW2aRMdNAIeXreRDhLykWEJlq1/woYTG6W3o
        AfUtjG5A==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxnl-003Ewt-SU; Wed, 22 Dec 2021 09:20:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com, kartilak@cisco.com, sebaddel@cisco.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] snic: don't use GFP_DMA in snic_queue_report_tgt_req
Date:   Wed, 22 Dec 2021 10:20:48 +0100
Message-Id: <20211222092048.925829-1-hch@lst.de>
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
 drivers/scsi/snic/snic_disc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index e9ccfb97773f1..27e98df83b31f 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -100,7 +100,7 @@ snic_queue_report_tgt_req(struct snic *snic)
 	SNIC_BUG_ON(ntgts == 0);
 	buf_len = ntgts * sizeof(struct snic_tgt_id) + SNIC_SG_DESC_ALIGN;
 
-	buf = kzalloc(buf_len, GFP_KERNEL|GFP_DMA);
+	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf) {
 		snic_req_free(snic, rqi);
 		SNIC_HOST_ERR(snic->shost, "Resp Buf Alloc Failed.\n");
-- 
2.30.2

