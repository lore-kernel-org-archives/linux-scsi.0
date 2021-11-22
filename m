Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74DFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 09:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhKVJDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:03:44 -0500
Received: from verein.lst.de ([213.95.11.211]:57054 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhKVJDn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 04:03:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BF4BD68AA6; Mon, 22 Nov 2021 10:00:31 +0100 (CET)
Date:   Mon, 22 Nov 2021 10:00:31 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/5] blk-mq: rename hctx_lock & hctx_unlock
Message-ID: <20211122090031.GA28870@lst.de>
References: <20211119021849.2259254-1-ming.lei@redhat.com> <20211119021849.2259254-3-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119021849.2259254-3-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2021 at 10:18:46AM +0800, Ming Lei wrote:
> +static inline void queue_unlock(struct request_queue *q, bool blocking,
> +		int srcu_idx)

I don't think this is a good name, as it can be easily confused with
q->queue_lock.

> +	__releases(q->srcu)
>  {
> -	if (!(hctx->flags & BLK_MQ_F_BLOCKING))
> +	if (!blocking)
>  		rcu_read_unlock();
>  	else
> -		srcu_read_unlock(hctx->queue->srcu, srcu_idx);
> +		srcu_read_unlock(q->srcu, srcu_idx);
>  }

I think you want to make BLK_MQ_F_BLOCKING accessible from the
request_queue instead of passing the extra argument as well.
