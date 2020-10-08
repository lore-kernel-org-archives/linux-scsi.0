Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0DDC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2442F2222D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X1Qfg+Gg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgJHUGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729998AbgJHUGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 16:06:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339FCC0613D3
        for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2020 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NbsVIy/lA7WcuYGoYiCNU9DZoK8QQWB2aMh0hU4RAnQ=; b=X1Qfg+GgduJwAj/QOW1LOn+zYK
        fXJOCc049B7uWkT7jiwe3FzicmMi+SsKaaqGUF+bHysKG9h6X64Nj4wk72oDpG6fuMKD1qt0Y6J5Y
        ORHF6XpTZvcF7DY8pu1t6Bx1mVobnKEqJp0S+5FvDWuj/5RB/DEm+FeOt+RNJNFC871jFTL3ZnIzX
        lDRoaPehVbauOCS79YpALPhY8ZjHsCbNDGyB2GoqKD7KSJf3/hnbzWykYOOonZKJf50aTtmoUEO72
        N0zD0ekxNgzDQnQDwF6U3PQNTFWAB7OUpOG7MfSZUTzZDGGlH/fomTeqs5g4U23h/9aYqFLu8Fk+f
        ihj67NQg==;
Received: from [2001:4bb8:184:92a2:cbfa:206d:64ea:205c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQcB4-0001SE-KJ; Thu, 08 Oct 2020 20:06:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Qian Cai <cai@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 2/2] scsi: set sc_data_direction to DMA_NONE for no-transfer commands
Date:   Thu,  8 Oct 2020 22:06:11 +0200
Message-Id: <20201008200611.1818099-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008200611.1818099-1-hch@lst.de>
References: <20201008200611.1818099-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No having the special DMA_NONE logic makes libata rather unhappy.

Fixes: 40b93836a136 ("scsi: core: Use rq_dma_dir in scsi_setup_cmnd()")
Reported-by: Qian Cai <cai@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b0fccda9af2ee..1a2e9bab42efab 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1545,7 +1545,10 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
-	cmd->sc_data_direction = rq_dma_dir(req);
+	if (blk_rq_bytes(req))
+		cmd->sc_data_direction = rq_dma_dir(req);
+	else
+		cmd->sc_data_direction = DMA_NONE;
 
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
-- 
2.28.0

