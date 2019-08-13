Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F775C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5175C20578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ENau1h9+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfHMH0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DDlZ3PlciDMCdlnMfWl/lPT/65XlqwrZdQcrkjYE7pY=; b=ENau1h9+/xZPiyVhDRTz936mIW
        F4ubT6zq2xUnvwj6ao9b4h862D1WIWmIpUuZVglhRF8J8186jUz9gKKmLQt1eysTPjE7zG0m2HX4n
        6cp+8td6oj40IsuTtPQeKfH/RT0FD31w/Yg4q3PQ/8yqFRuTgnZKKFyz3on14ZgZbPQGVRsvJzjsy
        Qun68ZbBVJMQ/q4Nt9w1/jPWXlR7w/4VT7VPFZf862LEh0SxNZrlmIOJuCst/jNwtJ3lI/MHn4BmI
        0e5jZt07ig9TcJxlvqWO9egh7R1CJrSSz1plSJRMfGQIYrGTcWFIBSwvqSC3iAf+/Zh7QoO/wFJCo
        /6XnPidg==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCR-0006td-Jp; Tue, 13 Aug 2019 07:26:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/28] ia64: remove the unused sn_coherency_id symbol
Date:   Tue, 13 Aug 2019 09:25:08 +0200
Message-Id: <20190813072514.23299-23-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sn_coherency_id symbol isn't used anywhere, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/uv/kernel/setup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/ia64/uv/kernel/setup.c b/arch/ia64/uv/kernel/setup.c
index 6ac4bd314d92..b081f5138f5c 100644
--- a/arch/ia64/uv/kernel/setup.c
+++ b/arch/ia64/uv/kernel/setup.c
@@ -16,9 +16,6 @@
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
 
-long sn_coherency_id;
-EXPORT_SYMBOL_GPL(sn_coherency_id);
-
 struct redir_addr {
 	unsigned long redirect;
 	unsigned long alias;
-- 
2.20.1

