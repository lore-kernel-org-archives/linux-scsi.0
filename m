Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1C9C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiAXNWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:22:25 -0500
Received: from verein.lst.de ([213.95.11.211]:55797 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbiAXNWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:22:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1D85868BEB; Mon, 24 Jan 2022 14:22:22 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:22:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 11/13] block: move blk_exit_queue into disk_release
Message-ID: <20220124132221.GJ27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-12-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-12-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:52PM +0800, Ming Lei wrote:
>  3 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index d51b0aa2e4e4..72ae9955cf27 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3101,6 +3101,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  	struct blk_mq_tags *drv_tags;
>  	struct page *page;
>  
> +	if (list_empty(&tags->page_list))
> +		return;

Please split this out and document why it is needed.

> +/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
> +static void blk_exit_queue(struct request_queue *q)
> +{
> +	/*
> +	 * Since the I/O scheduler exit code may access cgroup information,
> +	 * perform I/O scheduler exit before disassociating from the block
> +	 * cgroup controller.
> +	 */
> +	if (q->elevator) {
> +		ioc_clear_queue(q);
> +
> +		mutex_lock(&q->sysfs_lock);
> +		blk_mq_sched_free_rqs(q);
> +		elevator_exit(q);
> +		mutex_unlock(&q->sysfs_lock);
> +	}
> +}

Given that this all deals with the I/O scheduler the naming seems
wrong.  It almost seems like we'd want to move ioc_clear_queue and
blk_mq_sched_free_rqs into elevator_exit to have somewhat sensible
helpers.  That would add extra locking of q->sysfs_lock for
ioc_clear_queue, but given that elevator_switch_mq already does
that, this seems harmless.

