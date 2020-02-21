Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250F4C35657
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 17:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CE7208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 17:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZtZ/zzjY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgBURWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 12:22:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgBURWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 12:22:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+9zPArLElNepmFofDfBeZ2fYd9Ky2C/8KNsJoicGJSs=; b=ZtZ/zzjY4QZauehBMVxj/JluwD
        ttlA/fYN6KD+QSaa+9jUB3VqWsDBsferiztcwCniVqNoF2ha+FpTKL5OYooAz/UWnxnMRkL0Tr61M
        ECpP1oIkN5m1Oiwa0fCw1H+aEEkmHuM6wTaT0XPFWOkOBHon+CU+NwflwkJUepw0ySejq4gZrgV7T
        bB9uMG4ytHCrq1FyXdhLV+ZVej6lXAfjQKiBYznpFK8uxQ/uEETJtLs6dyXIg2gD/RdjLdYYwl2kt
        21LcQdDeGezUMi1eSmieYK2Ue79KohVX8CVofhlg+syNjZEj1wpcEXKw8Sr6/nRFek9UH7v2vCqmA
        11AtBGCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5C0i-00067Z-QR; Fri, 21 Feb 2020 17:22:44 +0000
Date:   Fri, 21 Feb 2020 09:22:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v7 6/9] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200221172244.GC438@infradead.org>
References: <20200221115050.238976-1-satyat@google.com>
 <20200221115050.238976-7-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221115050.238976-7-satyat@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2020 at 03:50:47AM -0800, Satya Tangirala wrote:
> Wire up ufshcd.c with the UFS Crypto API, the block layer inline
> encryption additions and the keyslot manager.
> 
> Also, introduce UFSHCD_QUIRK_BROKEN_CRYPTO that certain UFS drivers
> that don't yet support inline encryption need to use - taken from
> patches by John Stultz <john.stultz@linaro.org>
> (https://android-review.googlesource.com/c/kernel/common/+/1162224/5)
> (https://android-review.googlesource.com/c/kernel/common/+/1162225/5)
> (https://android-review.googlesource.com/c/kernel/common/+/1164506/1)

Between all these quirks, with what upstream SOC does this feature
actually work?
