Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A48C3F2D0
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4055A22525
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aANndovj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCJQnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:43:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCJQnd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OXXKeECzBJZGnbgSnym1JWooQ4EuZcLqoWhHbzQCJSs=; b=aANndovjEH5VVxRwn1IPVR2cxn
        fW1M44BP7mzT5w5fWP5bAEnrkvLoHZAkMG0Cpxz0gBQROUTjlBNzTCdn+jFe5CP9eu6VBFm0Vwra2
        +FavCrfNSFiSvXP2oGwNtBbM1I0PJ56JHjTH0b1/LvjUuzZ+B3bj4NuzJiLXlDbfwHLrZiwEcpNnG
        WnPieNQqlrh8Fi8h3yQ1L6hQ5k+k66aszdn23oo9jAp28P757vyI7qWatrPxxgUXsBpdYHHLReUfH
        +4zCNenwvD12nMMIh6BuNfb9LjV/xe7UB4LNE6oQU1QlK7p/u6mNUX6zjFOSkB3W/R8fmDSffzXfA
        TlVFMPOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBhye-0004hZ-R3; Tue, 10 Mar 2020 16:43:32 +0000
Date:   Tue, 10 Mar 2020 09:43:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 04/11] null_blk: Support REQ_OP_ZONE_APPEND
Message-ID: <20200310164332.GC15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-5-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-5-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:46PM +0900, Johannes Thumshirn wrote:
> From: Damien Le Moal <damien.lemoal@wdc.com>
> 
> Support REQ_OP_ZONE_APPEND requests for zone mode null_blk devices.
> Use the internally tracked zone write pointer position as the write
> position.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

This needs to go after all the infrastructure was added.
