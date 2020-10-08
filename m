Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E64EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE6322228
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EehjOOnt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgJHUGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729940AbgJHUGP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 16:06:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B2AC0613D2
        for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2020 13:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aIYbT+5uuPkBpmKGh0AlIc6bfsly9deAlwxhyHd3cEo=; b=EehjOOntCcoDiSwuC/K2eoBHJO
        vDJ8xSdZ57dMSL1F2YgRJDlBr23XwpaGOCbmI28OEh7yTo4M+7fkeSItNh733dmQRuSWuQd/fOxfl
        HiWJgox+N+iz7s4kVNj90q6Ryi7Sbm50/liqYOP/hyDB5xMjeTqHblSR3AKB6rW/IP1tkSQ+IGob9
        gnn3LHqdEO8cdyhOBC9ynqN2ejjJD9KZFhzTxZk0dekYzzQD2teVS6URUA6NWLGySV+E3Miebh1KQ
        zicDbPbMp/KokqP0xDblXCazWyLpcXlweJxKWe7rWV4XFL4FgPZA+OT/EIVjlXGgMoKgqOdsjONR4
        QH+Dm1tw==;
Received: from [2001:4bb8:184:92a2:cbfa:206d:64ea:205c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQcB3-0001Rf-GM; Thu, 08 Oct 2020 20:06:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Qian Cai <cai@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 1/2] sr: initialize ->cmd_len
Date:   Thu,  8 Oct 2020 22:06:10 +0200
Message-Id: <20201008200611.1818099-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008200611.1818099-1-hch@lst.de>
References: <20201008200611.1818099-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ensure the command length is properly set.  Previously the command code
tried to find this out using the command opcode.

Fixes: 2ceda20f0a99 ("scsi: core: Move command size detection out of the fast path")
Reported-by: Qian Cai <cai@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index b74dfd8dc1165e..c20b4391837898 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -503,6 +503,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
+	SCpnt->cmd_len = 10;
 
 	/*
 	 * This indicates that the command is ready from our end to be queued.
-- 
2.28.0

