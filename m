Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E94C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F64461A01
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhCXRpU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:45:20 -0400
Received: from verein.lst.de ([213.95.11.211]:38081 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhCXRpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 13:45:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 37BCB68B05; Wed, 24 Mar 2021 18:44:59 +0100 (CET)
Date:   Wed, 24 Mar 2021 18:44:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 7/8] block: refactor the bounce buffering code
Message-ID: <20210324174458.GA13589@lst.de>
References: <20210318063923.302738-1-hch@lst.de> <20210318063923.302738-8-hch@lst.de> <20210318112950.GL3420@casper.infradead.org> <20210318125340.GA21262@lst.de> <YFt5kPs30x4kPu77@t480-pf1aa2c2.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFt5kPs30x4kPu77@t480-pf1aa2c2.linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 24, 2021 at 06:40:32PM +0100, Benjamin Block wrote:
> Is blk_queue_bounce() called again when mpath submits the request to the
> lower device? I thought when I looked at this code some time ago
> bouncing would only be checked the first time a request is created
> (dm-mpath), and then not again, so when we don't check for whether
> bouncing is necessary in mpath, we still might screw the LLD - hence why
> we might inherit this via the limits.

Every call to blk_mq_submit_bio also calls blk_queue_bounce, and
blk_queue_bounce then checks if it needs to do anything based on the
bounce limit and max_pfn, and if needed proceeds to check every bvec.

So for extremely unlikely case thay someone is running multipath over one
of the few remaining drivers that need block layering bounce buffering
this inheritance just leads to (harmless) extra work.
