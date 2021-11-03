Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A78EC43217
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016ED60E05
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhKCQI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:08:27 -0400
Received: from verein.lst.de ([213.95.11.211]:60032 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhKCQI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 12:08:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 67DF268AA6; Wed,  3 Nov 2021 17:05:47 +0100 (CET)
Date:   Wed, 3 Nov 2021 17:05:47 +0100
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
Subject: Re: [PATCH v2 04/13] nvdimm/blk: avoid calling del_gendisk() on
 early failures
Message-ID: <20211103160547.GD31562@lst.de>
References: <20211103122157.1215783-1-mcgrof@kernel.org> <20211103122157.1215783-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103122157.1215783-5-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:21:48AM -0700, Luis Chamberlain wrote:
> If nd_integrity_init() fails we'd get del_gendisk() called,
> but that's not correct as we should only call that if we're
> done with device_add_disk(). Fix this by providing unwinding
> prior to the devm call being registered and moving the devm
> registration to the very end.
> 
> This should fix calling del_gendisk() if nd_integrity_init()
> fails. I only spotted this issue through code inspection. It
> does not fix any real world bug.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Should this grow a Fixes tag for the commit adding the problem?
