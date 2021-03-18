Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E887C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 12:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E915764F04
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 12:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCRMyI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:54:08 -0400
Received: from verein.lst.de ([213.95.11.211]:41560 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhCRMxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 08:53:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6C6F868C65; Thu, 18 Mar 2021 13:53:41 +0100 (CET)
Date:   Thu, 18 Mar 2021 13:53:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 7/8] block: refactor the bounce buffering code
Message-ID: <20210318125340.GA21262@lst.de>
References: <20210318063923.302738-1-hch@lst.de> <20210318063923.302738-8-hch@lst.de> <20210318112950.GL3420@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318112950.GL3420@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 18, 2021 at 11:29:50AM +0000, Matthew Wilcox wrote:
> On Thu, Mar 18, 2021 at 07:39:22AM +0100, Christoph Hellwig wrote:
> > @@ -536,7 +518,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
> >  					b->max_write_zeroes_sectors);
> >  	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
> >  					b->max_zone_append_sectors);
> > -	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
> > +	t->bounce = min_not_zero(t->bounce, b->bounce);
> 
> I see how min_not_zero() made sense when it was a pfn.  Does it still
> make sense now it's an enum?  I would have thought it'd now be 'max()',
> given the definitions later on.

Actually, blk_stack_limits should not look at ->bounce_pfn / ->bounce
at all.  blk_queue_bounce is only called my blk_mq_submit_bio, and
the only stacked blk-mq driver (dm-mpath) does not need bouncing.

I'll add a patch to fix this up to the front of the series.
