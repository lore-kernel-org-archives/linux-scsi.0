Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12625C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB91C20578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RqTV6Fbw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfHMH0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMH0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/PPuYMxkVUft77b6HLHZw8ZIuydXzLf99UQy5MaHMpQ=; b=RqTV6FbwBVFzGerjKdguLhYuSd
        Kt/6E7APyKfAf1vh9f+VnH2TXLP/Ju28rGvmSChMatpcVIYvmG8TVvS+Rog/kRR+mth5jzVMcrDTu
        ULy89D2vIjZ4xrUFYLIdI+Hbdjj4mOnn0t7iStckOQ+j3S7xC/zrHW4UuJfdnK7Xb5xYWGDjU9rel
        0ASa1mFM8sh4dCXQDcAQ+mGPsafHArwJMyt0wSKSyRpZuCAdza475Ur9tMQO/xuq0kRCN3/uQpxgI
        nuVlkEt38SS7m7LZrFl68mN5RxDZv8erKCOobIzTrOsPYYjRSlrVel3XWQ5sOFLCBFKpPxZr7Ndt2
        URa2gzgw==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBr-0006G8-0B; Tue, 13 Aug 2019 07:25:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/28] qla2xxx: remove SGI SN2 support
Date:   Tue, 13 Aug 2019 09:24:58 +0200
Message-Id: <20190813072514.23299-13-hch@lst.de>
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

The SGI SN2 support is about to be removed, so drop the bits specific to
it from this driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index da83034d4759..d4c3baec9172 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4575,20 +4575,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		rval = 1;
 	}
 
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
-	/*
-	 * The SN2 does not provide BIOS emulation which means you can't change
-	 * potentially bogus BIOS settings. Force the use of default settings
-	 * for link rate and frame size.  Hope that the rest of the settings
-	 * are valid.
-	 */
-	if (ia64_platform_is("sn2")) {
-		nv->frame_payload_size = 2048;
-		if (IS_QLA23XX(ha))
-			nv->special_options[1] = BIT_7;
-	}
-#endif
-
 	/* Reset Initialization control block */
 	memset(icb, 0, ha->init_cb_size);
 
-- 
2.20.1

