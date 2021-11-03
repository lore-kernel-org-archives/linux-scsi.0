Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6A5C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3489E61108
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhKCRGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhKCRGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:06:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EEBC061714;
        Wed,  3 Nov 2021 10:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u8Z/qqIhbDRh0Z9lXwnrC3LA7dcBQsND+N8bG1R6OJY=; b=y4OqgbyNItZScy80WmoDdm0cDF
        Hur9oxkdvGoWlTSYEZhGzRfh8TUCRw2KlvesxH1ijn4vJrQysX66/7ncAQIRjEB3PPA08Q3jVLAyL
        Vl2aYcsKvgiWt8J98lSUZ3hTC89wTmKEYw+YStjFwNCckDUlpOHTD3HRUgxb5Q0ybem/+K57J6QD9
        jnz+lUXFm854hfwfO/X2yNEUkW2b/ul9t4CY2/cfytY6un/2jKt9BKcQfhRym+LGnKfkznUroDC3d
        fTDyUjO5c+Qi3Ro58kWOo4rL/LxsnyKe5Ype/4xV2WIxGWE3qf+w4BOh6O5Gk9HpMF4x93iMXn1wu
        oaos+0RQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJfy-005tqu-Dd; Wed, 03 Nov 2021 17:03:50 +0000
Date:   Wed, 3 Nov 2021 10:03:50 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/13] block: make __register_blkdev() return an error
Message-ID: <YYLA9g0cYBsEFZkm@bombadil.infradead.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
 <20211103122157.1215783-13-mcgrof@kernel.org>
 <20211103160933.GK31562@lst.de>
 <YYK8hY/giSBFN8YJ@bombadil.infradead.org>
 <20211103170049.GA4108@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103170049.GA4108@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 06:00:49PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 09:44:53AM -0700, Luis Chamberlain wrote:
> > Here's the thing, prober call a form of add_disk(), and so do we want
> > to always ignore the errors on probe? If so we should document why that
> > is sane then. I think this approach is a bit more sane though.
> 
> I suspect the right thing is to just kill of ->probe.
> 
> The only thing it supports is pre-devtmpfs, pre-udev semantics that
> want to magically create disks when their pre-created device node
> is accesses.

That sounds like a possible userspace impact? And so not for v5.16 for
sure.

> But if we don't remove it, yes I think not reporting
> the error is best.  Just clean up whatever local resources were set
> up in the ->probe method and let the open fail without the need of
> passing on the actual error.

Alright, I'll do that and send a final v3 for the last 2 patches.

  Luis
