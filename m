Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BF0C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 06:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbiBWGnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 01:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbiBWGnA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 01:43:00 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC146D870;
        Tue, 22 Feb 2022 22:42:30 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A272A68B05; Wed, 23 Feb 2022 07:42:26 +0100 (CET)
Date:   Wed, 23 Feb 2022 07:42:26 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/12] blk-mq: do not include passthrough requests in
 I/O accounting
Message-ID: <20220223064226.GA31307@lst.de>
References: <20220222141450.591193-1-hch@lst.de> <20220222141450.591193-2-hch@lst.de> <YhWXFMhdms1QO1dL@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhWXFMhdms1QO1dL@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 23, 2022 at 10:08:20AM +0800, Ming Lei wrote:
> > -	return (rq->rq_flags & RQF_IO_STAT) && rq->q->disk;
> > +	return (rq->rq_flags & RQF_IO_STAT) && !blk_rq_is_passthrough(rq);
> 
> I guess this way may cause regression for workloads with lots of userspace IO
> from user viewpoint?

I'd say it fixes it as the accounting right now is completely bogus.
