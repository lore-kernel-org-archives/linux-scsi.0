Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF5CC11F69
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 06:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793C7610A6
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 06:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhGLGNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 02:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhGLGNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 02:13:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2D4C0613DD;
        Sun, 11 Jul 2021 23:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Myd7IJLJ7heKIz9ETwtcIPphP9GrAs74dKTdw1IlNW0=; b=ukgk67ijHtXQ1PEUlh1WacXdWU
        WIqEtHEGUD4+e78xBwdDdQ96GHwcDGXZGoKN8p+7q86hvOtOOiHxN3MeKXKst5nZXsCnxOVvoazU/
        fNRH1LsQFSwgNKmo91nxV6rf73Waco4u5Myk8CuiZco/7k1OMWymTvPMp1oMiDjk5nJyguuWl35YK
        rTTUQpsDR7CM63pp+JJ59UkU3ymC77BYcTToSPZH4iLbjPc0fsChh2t5T1TgFYBYOeUpvRSe5SMmR
        Ka/ub8pu+YKXByg5EvKWWlN6GCKOSxnucifSmIQvNhpzSBmXCGvkAumMRr3sCOtBMbh7xWYBGstF+
        GEZRpeTg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2p8O-00GwC0-7C; Mon, 12 Jul 2021 06:09:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc:     Russell King <linux@armlinux.org.uk>, Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Geoff Levand <geoff@infradead.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Shi <alexs@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/6] mmc: JZ4740: remove the flush_kernel_dcache_page call in jz4740_mmc_read_data
Date:   Mon, 12 Jul 2021 08:09:23 +0200
Message-Id: <20210712060928.4161649-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712060928.4161649-1-hch@lst.de>
References: <20210712060928.4161649-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

MIPS now implements flush_kernel_dcache_page (as an alias to
flush_dcache_page).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/host/jz4740_mmc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 0db17bcc9c16..aa2240c83510 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -578,10 +578,6 @@ static bool jz4740_mmc_read_data(struct jz4740_mmc_host *host,
 			}
 		}
 		data->bytes_xfered += miter->length;
-
-		/* This can go away once MIPS implements
-		 * flush_kernel_dcache_page */
-		flush_dcache_page(miter->page);
 	}
 	sg_miter_stop(miter);
 
-- 
2.30.2

