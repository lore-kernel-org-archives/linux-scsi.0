Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2642DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 09:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F09E4611AD
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 09:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhKJJQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:16:57 -0500
Received: from verein.lst.de ([213.95.11.211]:53580 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhKJJQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 04:16:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 966DD68AA6; Wed, 10 Nov 2021 10:14:07 +0100 (CET)
Date:   Wed, 10 Nov 2021 10:14:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: sorting out the freeze / quiesce mess
Message-ID: <20211110091407.GA8396@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens and Ming,

I've been looking into properly supporting queue freezing for bio based
drivers (that is only release q_usage_counter on bio completion for them).
And the deeper I look into the code the more I'm confused by us having
the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
is a good reason to do a quiesce separately from a freeze?
