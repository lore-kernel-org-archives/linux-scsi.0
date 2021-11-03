Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544D3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306D961101
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhKCRDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:03:31 -0400
Received: from verein.lst.de ([213.95.11.211]:60350 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhKCRDb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 13:03:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 051C068AA6; Wed,  3 Nov 2021 18:00:50 +0100 (CET)
Date:   Wed, 3 Nov 2021 18:00:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        penguin-kernel@i-love.sakura.ne.jp, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, richard@nod.at, miquel.raynal@bootlin.com,
        vigneshr@ti.com, efremov@linux.com, song@kernel.org,
        martin.petersen@oracle.com, hare@suse.de, jack@suse.cz,
        ming.lei@redhat.com, tj@kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/13] block: make __register_blkdev() return an
 error
Message-ID: <20211103170049.GA4108@lst.de>
References: <20211103122157.1215783-1-mcgrof@kernel.org> <20211103122157.1215783-13-mcgrof@kernel.org> <20211103160933.GK31562@lst.de> <YYK8hY/giSBFN8YJ@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYK8hY/giSBFN8YJ@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 09:44:53AM -0700, Luis Chamberlain wrote:
> Here's the thing, prober call a form of add_disk(), and so do we want
> to always ignore the errors on probe? If so we should document why that
> is sane then. I think this approach is a bit more sane though.

I suspect the right thing is to just kill of ->probe.

The only thing it supports is pre-devtmpfs, pre-udev semantics that
want to magically create disks when their pre-created device node
is accesses.  But if we don't remove it, yes I think not reporting
the error is best.  Just clean up whatever local resources were set
up in the ->probe method and let the open fail without the need of
passing on the actual error.
