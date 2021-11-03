Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2234C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8573610EA
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhKCQu1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhKCQuZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:50:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7253EC061714;
        Wed,  3 Nov 2021 09:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hV7KkgJZ14g4wckgwNG3q8BYOpdY7x/4GvqTXBysJh4=; b=Q7w1tBQ6/QvnKvtoj5RuPlTlKZ
        yJRr2L6cHWAzSzQIDNxLEKooXyVsYiXAqGC295PdzcYs5v11TaDGMVKPEyXDD7areqO6pUe7zamlJ
        m7whBeJ6G7nrenE//9wEZlNT9lmDRD/o72zJ+wl3+uJ68B7eauPfnzGmC2s2RbVaqQlSYD3cUiXz4
        9oleueywbA4YbsYf/B74fcBGbBWDoHn7oEuyhWIq4sLDat/4i97IcWP25urDWqq4GlmIk26NzPkHe
        kJbK5N1CxyFQgVje/zDgQfwe/YNI4NTYZCUFFVPvaa65S+8LcM0nlbZl3G8vT3JoaNFmpJFlVVEuL
        yZxdMasg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJQE-005pCH-7O; Wed, 03 Nov 2021 16:47:34 +0000
Date:   Wed, 3 Nov 2021 09:47:34 -0700
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
Subject: Re: [PATCH v2 04/13] nvdimm/blk: avoid calling del_gendisk() on
 early failures
Message-ID: <YYK9JtysvnF+xctB@bombadil.infradead.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
 <20211103122157.1215783-5-mcgrof@kernel.org>
 <20211103160547.GD31562@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103160547.GD31562@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:05:47PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 05:21:48AM -0700, Luis Chamberlain wrote:
> > If nd_integrity_init() fails we'd get del_gendisk() called,
> > but that's not correct as we should only call that if we're
> > done with device_add_disk(). Fix this by providing unwinding
> > prior to the devm call being registered and moving the devm
> > registration to the very end.
> > 
> > This should fix calling del_gendisk() if nd_integrity_init()
> > fails. I only spotted this issue through code inspection. It
> > does not fix any real world bug.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Should this grow a Fixes tag for the commit adding the problem?

Given this driver is going to be removed, do we care? The only
reason I re-added the patch was Dan could not remove the driver
on time.

  Luis
