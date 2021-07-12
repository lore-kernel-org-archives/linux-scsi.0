Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2907FC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 15:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D77A61221
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 15:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhGLPxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhGLPxK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 11:53:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6DAC0613DD;
        Mon, 12 Jul 2021 08:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=bOhjFz7uGsGcQZZ8QK6W3MRBAREVYViBKiRmdl8xXwA=; b=ZjD+Fa++0ZHEvs1h7NEiJrDanX
        m13JcoVlE1TERMvtNuxMg52F6u+wN3kQNzx1RWyYweExjFn6dhBI0RlDWxa7Hy7w1K4VfA9JhNBKC
        /noDEWqUXr4sfVmhh06u1oizxrkZJFb7qioEylRvnZqDk56LnrhGSRu9GINXXOrIJsu32A2+movGr
        a+zIQYvK1NeThS+qwrvRoVPQS6ZWYjXT6lRsposAK5L46hsqd/FLTkdUxTPAAL51qVU59x59XSSla
        pjFsqZuYGNcVnq38BSEeMLCrOHvZEsbwQEdJz8phWBpfhLjC3b3yUzad7tzz/FhCKceLpEoQZEl4V
        VY8K3nPA==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2yC2-000BAg-5q; Mon, 12 Jul 2021 15:50:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] sd: don't mess with SD_MINORS for CONFIG_DEBUG_BLOCK_EXT_DEVT
Date:   Mon, 12 Jul 2021 17:50:01 +0200
Message-Id: <20210712155001.125632-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No need to give up the original sd minor even with this option,
and if we did we'd also need to fix the number of minors for
this configuration to actually work.

Fixes: 7c3f828b522b0 ("block: refactor device number setup in __device_add_disk")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/scsi/sd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6d2d63629a90..b8d55af763f9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -98,11 +98,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
-#if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
-#else
-#define SD_MINORS	0
-#endif
 
 static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
-- 
2.30.2

