Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F524C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52387206F6
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gaESHMa6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgC0RWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:22:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgC0RWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bx3J+ePBrBiu12FDh5XyAFRuAp+ZbxUWdIEiXJLbg6I=; b=gaESHMa62pwDj2ZmMctS9kX6Xh
        LnzqKsoh7UP0kNhyzoqi4iS5PsF+3rFreqmmgTJqETvzKP5aVNOODwXOhw84hbGi9lBjnUIP1wbDJ
        0ho4Mcr2qQvRDQtmrgQ0twO5UdjYdMhBJqXOjFsuEffiz3bDNcbo+XgB+prbaQDhVNAVydPtHcilO
        QWMFT2hByhPT3nymJuOfXKnREb6YhO3dAal8tAFCZBG3LS1u77PdyjKj1jvMtacVIWXOa74PF8/us
        recYaY77qF3vEF1mnzd9cTNxLUErtyOw3GR+iha3HFKIFoUyItx4lHowhRxW18NG38aNuqkGOqZjL
        lWaGsPkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHsgX-0005Xq-98; Fri, 27 Mar 2020 17:22:21 +0000
Date:   Fri, 27 Mar 2020 10:22:21 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 09/10] block: export bio_release_pages and
 bio_iov_iter_get_pages
Message-ID: <20200327172221.GA21273@infradead.org>
References: <20200327165012.34443-1-johannes.thumshirn@wdc.com>
 <20200327165012.34443-10-johannes.thumshirn@wdc.com>
 <20200327170716.GA11524@infradead.org>
 <SN4PR0401MB35981511B1C7A22E055F80F29BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35981511B1C7A22E055F80F29BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 27, 2020 at 05:13:55PM +0000, Johannes Thumshirn wrote:
> On 27/03/2020 18:07, Christoph Hellwig wrote:
> > On Sat, Mar 28, 2020 at 01:50:11AM +0900, Johannes Thumshirn wrote:
> >> +EXPORT_SYMBOL(bio_release_pages);
> >>   
> >>   static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
> >>   {
> >> @@ -1111,6 +1112,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
> >>   		bio_set_flag(bio, BIO_NO_PAGE_REF);
> >>   	return bio->bi_vcnt ? 0 : ret;
> >>   }
> >> +EXPORT_SYMBOL(bio_iov_iter_get_pages);
> > 
> > EXPORT_SYMBOL_GPL, please.
> > 
> 
> Sure, only for bio_iov_iter_get_pages or bio_release_pages as well?
> 
> I couldn't find a clear pattern in block/bio.c, it's _GPL 7 times vs 28 
> times without _GPL.

Both.  All the new internal stuff should be _GPL.
