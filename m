Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514F5C18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2220F24649
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VPCLoa/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCJQod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:44:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgCJQod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xRVkrQuoW34GS7kLs2uHCxCkD3bfa6Lz/qQf3C64KTI=; b=VPCLoa/JM6M1g3gyHXrGi1lvXn
        atModGTFAC4zT9AWFQGXBqtG7II6KisH4NHVJqhCwv6YSqS+IrzitfikQqYeM3qjttsd5TMLQAxga
        uM2D23V3mCgmraaVPxJmBzVWgjSaYmGffGrquhZneUx1NvtGZzBnKajhh/NJEys4xuKATFmShKREE
        bcgG43cQrxOsf2rwDJb7qhQrq4VG15tT9f8cp3ctxWoQi9cj3TclRrmjULeo03Bn7z2258E836hYI
        P9i3uoIWWSyzc9tW9XkfkyZYdgfUFe4RPGF2B8uZlJEKwMByhxQCkqsUZY9J2nch59siet0LUuIL9
        S1j8v80g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBhza-0005F0-85; Tue, 10 Mar 2020 16:44:30 +0000
Date:   Tue, 10 Mar 2020 09:44:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/11] block: factor out requeue handling from dispatch
 code
Message-ID: <20200310164430.GE15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-8-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-8-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:49PM +0900, Johannes Thumshirn wrote:
> Factor out the requeue handling from the dispatch code, this will make
> subsequent addition of different requeueing schemes easier.

This should go first in the series, as it is useful even without the
rest of the series.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
