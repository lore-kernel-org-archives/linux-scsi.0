Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F221C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25AC360F58
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhKCQMO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:12:14 -0400
Received: from verein.lst.de ([213.95.11.211]:60145 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhKCQMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 12:12:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7825F68AA6; Wed,  3 Nov 2021 17:09:33 +0100 (CET)
Date:   Wed, 3 Nov 2021 17:09:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/13] block: make __register_blkdev() return an
 error
Message-ID: <20211103160933.GK31562@lst.de>
References: <20211103122157.1215783-1-mcgrof@kernel.org> <20211103122157.1215783-13-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103122157.1215783-13-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:21:56AM -0700, Luis Chamberlain wrote:
> This makes __register_blkdev() return an error, and also changes the
> probe() call to return an error as well.
> 
> We expand documentation for the probe call to ensure that if the block
> device already exists we don't return on error on that condition. We do
> this as otherwise we loose ability to handle concurrent requests if the
> block device already existed.

I'm still not really sold on this - if the probe fails no bdev will
be registered and the lookup will fail.  What is the benefit of
propagating the exact error here?
