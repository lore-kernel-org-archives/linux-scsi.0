Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A12C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242887AbiAXNLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:11:12 -0500
Received: from verein.lst.de ([213.95.11.211]:55730 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242754AbiAXNLM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:11:12 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C370368BEB; Mon, 24 Jan 2022 14:11:08 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:11:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 08/13] block: export __blk_mq_unfreeze_queue
Message-ID: <20220124131108.GG27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-9-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-9-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:49PM +0800, Ming Lei wrote:
> blk_mq_unfreeze_queue() is used by scsi when releasing disk, so not
> necessary to unfreeze into percpu mode, then the following
> blk_cleanup_queue doesn't need to freeze queue from percpu mode, and
> the implied RCU grace period may be avoided.
> 
> Meantime move clearing QUEUE_FLAG_INIT_DONE into this API, so that
> when one disk is added, ->q_usage_counter can be switched to percpu
> mode again.

Independ of the use case (which I'll need to review in the next patches),
exporting lowlevel-helpers like this just seems like a bad idea.

If we have a use case add a wrapper that sets the force_atomic flag
and document and export that, please.
