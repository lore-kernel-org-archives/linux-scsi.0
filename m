Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997FEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B7061A21
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbhCXSN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:13:27 -0400
Received: from verein.lst.de ([213.95.11.211]:38199 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237432AbhCXSNL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 14:13:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DE2FE68B05; Wed, 24 Mar 2021 19:13:07 +0100 (CET)
Date:   Wed, 24 Mar 2021 19:13:07 +0100
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
Message-ID: <20210324181307.GA15902@lst.de>
References: <20210318063923.302738-1-hch@lst.de> <20210318063923.302738-8-hch@lst.de> <20210318112950.GL3420@casper.infradead.org> <20210318125340.GA21262@lst.de> <YFt5kPs30x4kPu77@t480-pf1aa2c2.linux.ibm.com> <20210324174458.GA13589@lst.de> <YFt/7BdzecUmdySU@t480-pf1aa2c2.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFt/7BdzecUmdySU@t480-pf1aa2c2.linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 24, 2021 at 07:07:40PM +0100, Benjamin Block wrote:
> But map_request() -> multipath_clone_and_map() -> dm_dispatch_clone_request() 
> doesn't call blk_mq_submit_bio() for requests that have been queued in a
> request based mpath device. The requests gets cloned and then dispatched
> on the lower queue. Or am I missing something?

Indeed.  I keep forgetting about the fact that dm-mpath bypassed
the normal submit_bio_noacct path.
