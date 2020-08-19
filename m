Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE99C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 07:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BB912054F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 07:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jpOJD02y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgHSG4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 02:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgHSG4V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2020 02:56:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219E5C061342;
        Tue, 18 Aug 2020 23:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wWR7H3WZih9ZGlGO6OHg+MKLXPw0ngda85sKeqyd2Cw=; b=jpOJD02yiZZvWWit1o1weNaitA
        s+mC0xFEIxHdbmZxSuzv05dSkkmY3FK7EbdTpK9QpDLb0Ceqz6l3lQupgrpZuZDgApdny95si0/Rp
        bG4tkK6rP/6JwhYOUJT75htP/Q/gMqWOzdGofFco0K5sALTwUxauCijB+xP3Kcf9yEeh/sEpxQ/kX
        woIRuODRQAv2/adxC0mmIDYPTFtaYjX9N/IW+1s7SFpO4zs2DaqMtizNQdMSvfDbTyk2YhG5bNEly
        ZjwNnhqjEz2y/fnO7Bi5EbWzbuOS+Z3ef8M3gl9vPYrctO6a1rFf7y/8NiaGbJXM/DWJ17xvyusol
        pD8t2u8A==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I0u-0008Kz-1W; Wed, 19 Aug 2020 06:56:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 02/28] drm/exynos: stop setting DMA_ATTR_NON_CONSISTENT
Date:   Wed, 19 Aug 2020 08:55:29 +0200
Message-Id: <20200819065555.1802761-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DMA_ATTR_NON_CONSISTENT is a no-op except on PARISC and some mips
configs, so don't set it in this ARM specific driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/exynos/exynos_drm_gem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
index efa476858db54b..07073222b8f691 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -42,8 +42,6 @@ static int exynos_drm_alloc_buf(struct exynos_drm_gem *exynos_gem, bool kvmap)
 	if (exynos_gem->flags & EXYNOS_BO_WC ||
 			!(exynos_gem->flags & EXYNOS_BO_CACHABLE))
 		attr |= DMA_ATTR_WRITE_COMBINE;
-	else
-		attr |= DMA_ATTR_NON_CONSISTENT;
 
 	/* FBDev emulation requires kernel mapping */
 	if (!kvmap)
-- 
2.28.0

