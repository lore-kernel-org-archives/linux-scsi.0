Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9EFC55186
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 09:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50FA22076C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 09:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MAVw0+I/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDVJhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 05:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgDVJhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 05:37:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7542C03C1A8;
        Wed, 22 Apr 2020 02:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G38QTqd03XPOTHFdtqcSzRlDM6JatBVOJOrQ7ob42Ow=; b=MAVw0+I/MkbE50pi9z8IP/6u8H
        Zqt42jz5vGkjspCyFke5X6et7WjLfrLoyp9MuQcxSytUf4BuyN/n8SAymOtRAWBeoPJKKFyKpyWl2
        6ZGdi1/8UW6T55vKFcMsQF9ygiZRP1/hOMt5yXvtcnokLgt0hGJ20zuCt/DFY8kx6nz4Ihl7hV41y
        6152jruxoJnBvfjG8cwOqT7bTrSl1T0QEkoNsJHjYRlcPOPUVcsQG3RNiSAX2FMfGKbI52GNhg8TU
        p9jx9Zgts1vMcy+G4v9UZ6rKlVMFLs2qrP/hu19ihTBFL9UairBjBvUzfk7ykaytxi+VUcySsEMfI
        +bEmxnog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRBow-0000kB-An; Wed, 22 Apr 2020 09:37:30 +0000
Date:   Wed, 22 Apr 2020 02:37:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v10 05/12] block: blk-crypto-fallback for Inline
 Encryption
Message-ID: <20200422093730.GC12290@infradead.org>
References: <20200408035654.247908-1-satyat@google.com>
 <20200408035654.247908-6-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408035654.247908-6-satyat@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> diff --git a/Documentation/block/index.rst b/Documentation/block/index.rst
> index 3fa7a52fafa46..026addfc69bc9 100644
> --- a/Documentation/block/index.rst
> +++ b/Documentation/block/index.rst
> @@ -14,6 +14,7 @@ Block
>     cmdline-partition
>     data-integrity
>     deadline-iosched
> +   inline-encryption
>     ioprio
>     kyber-iosched
>     null_blk

> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index 7546363dc584e..18e1a4d64bd33 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -3,6 +3,10 @@
>   * Copyright 2019 Google LLC
>   */
>  
> +/*
> + * Refer to Documentation/block/inline-encryption.rst for detailed explanation.
> + */
> +

These hunks should be in other patches.
