Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C6EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 12:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E39610A8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 12:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhKJNBr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 08:01:47 -0500
Received: from verein.lst.de ([213.95.11.211]:54404 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhKJNBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 08:01:46 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2872768AA6; Wed, 10 Nov 2021 13:58:57 +0100 (CET)
Date:   Wed, 10 Nov 2021 13:58:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: sorting out the freeze / quiesce mess
Message-ID: <20211110125856.GA25614@lst.de>
References: <20211110091407.GA8396@lst.de> <YYuQ9mhHtDNDVFQ3@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYuQ9mhHtDNDVFQ3@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2021 at 05:29:26PM +0800, Ming Lei wrote:
> On Wed, Nov 10, 2021 at 10:14:07AM +0100, Christoph Hellwig wrote:
> > Hi Jens and Ming,
> > 
> > I've been looking into properly supporting queue freezing for bio based
> > drivers (that is only release q_usage_counter on bio completion for them).
> > And the deeper I look into the code the more I'm confused by us having
> > the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
> > is a good reason to do a quiesce separately from a freeze?
> 
> freeze can make sure that all requests are done, quiesce can make sure that
> dispatch critical area(covered by hctx lock/unlock) is done.

Yeah, but why do we need to still call quiesce after we just did a
freeze, which is about half of the users?
