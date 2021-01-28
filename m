Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37804C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B5064DD8
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhA1JYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:24:10 -0500
Received: from verein.lst.de ([213.95.11.211]:56624 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhA1JVv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Jan 2021 04:21:51 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D5BE468B05; Thu, 28 Jan 2021 10:21:08 +0100 (CET)
Date:   Thu, 28 Jan 2021 10:21:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: Re: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Message-ID: <20210128092107.GE1959@lst.de>
References: <20210128044733.503606-1-damien.lemoal@wdc.com> <20210128044733.503606-8-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044733.503606-8-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 28, 2021 at 01:47:32PM +0900, Damien Le Moal wrote:
> Introduce the internal function blk_queue_clear_zone_settings() to
> cleanup all limits and resources related to zoned block devices. This
> new function is called from blk_queue_set_zoned() when a disk zoned
> model is set to BLK_ZONED_NONE. This particular case can happens when a
> partition is created on a host-aware scsi disk.

Shouldn't we just do all this work when blk_queue_set_zoned is called
with a BLK_ZONED_NONE argument?  That seems like the more obvious API
to me.
