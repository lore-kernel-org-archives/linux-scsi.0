Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A140BC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 07:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 847E161244
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 07:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhEXHg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 03:36:58 -0400
Received: from verein.lst.de ([213.95.11.211]:53557 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232266AbhEXHg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 03:36:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 95AB767373; Mon, 24 May 2021 09:35:27 +0200 (CEST)
Date:   Mon, 24 May 2021 09:35:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        axboe@kernel.dk, mb@lightnvm.io, martin.petersen@oracle.com,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        johannes.thumshirn@wdc.com, ming.lei@redhat.com, osandov@fb.com,
        jefflexu@linux.alibaba.com, hch@lst.de
Subject: Re: [RFC PATCH 0/8] block: fix bio_add_XXX_page() return type
Message-ID: <20210524073527.GA24302@lst.de>
References: <20210520062255.4908-1-chaitanya.kulkarni@wdc.com> <YKeZ5dtxt3gsImsd@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKeZ5dtxt3gsImsd@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 21, 2021 at 12:30:45PM +0100, Matthew Wilcox wrote:
> On Wed, May 19, 2021 at 11:22:47PM -0700, Chaitanya Kulkarni wrote:
> > The helper functions bio_add_XXX_page() returns the length which is
> > unsigned int but the return type of those functions is defined
> > as int instead of unsigned int.
> 
> I've been thinking about this for a few weeks as part of the folio
> patches:
> 
> https://lore.kernel.org/linux-fsdevel/20210505150628.111735-72-willy@infradead.org/
> 
>  - len and off are measured in bytes
>  - neither are permitted to be negative
>  - for efficiency we only permit them to be up to 4GB
> 
> I therefore believe the correct type for these parameters to be size_t,
> and we should range-check them if they're too large.  they should
> actually always fit within the page that they're associated with, but
> people do allocate non-compound pages and i'm not trying to break that
> today.
> 
> using size_t makes it clear that these are byte counts, not (eg) sector
> counts.  i do think it's good to make the return value unsigned so we
> don't have people expecting a negative errno on failure.

I think the right type is bool.  We always return either 0 or the full
length we tried to add.  Instead of optimizing for a partial add (which
only makes sense for bio_add_hw_page anyway), I'd rather make the
interface as simple as possible.
