Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901F6C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71DBC60FD7
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhJYHKV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:10:21 -0400
Received: from verein.lst.de ([213.95.11.211]:55815 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhJYHKU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 03:10:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 02C2D68B05; Mon, 25 Oct 2021 09:07:56 +0200 (CEST)
Date:   Mon, 25 Oct 2021 09:07:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: please revert the UFS HPB support
Message-ID: <20211025070755.GA7742@lst.de>
References: <571fc7393fb043e3c34bca57402bd098a56ea8ac.camel@HansenPartnership.com> <20211021144210.GA28195@lst.de> <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk> <20211021151520.GA31407@lst.de> <20211021151728.GA31600@lst.de> <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org> <CGME20211023154316epcas2p208f95cf1e4a87a4b61d2daf1a2b3c725@epcms2p3> <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 25, 2021 at 02:16:54PM +0900, Daejun Park wrote:
> > before the kernel is due to go final.  Can the problems identified by
> > Christoph be fixed within that timeframe?
> 
> I'm checking to see if I can replace blk_execute_rq_nowait with
> blk_insert_cloned_request in the HPB code.

blk_insert_cloned_request is part of the problem.  You can't just fan
out one request into two on the same queue.

FYI, 5.15 is supposed to be released end of this week (unless an -rc8)
happens.  I don't think we can sit this out, we need to revert (or at
least disable) the code now.
