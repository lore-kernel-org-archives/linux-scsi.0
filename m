Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43200C3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 267EB22CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfIDJCQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfIDJCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 05:02:15 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39A5630603AD;
        Wed,  4 Sep 2019 09:02:15 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D9FB5D9E2;
        Wed,  4 Sep 2019 09:02:08 +0000 (UTC)
Date:   Wed, 4 Sep 2019 17:02:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 1/7] block: Cleanup elevator_init_mq() use
Message-ID: <20190904090202.GD7578@ming.t460p>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
 <20190904084247.23338-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904084247.23338-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 04 Sep 2019 09:02:15 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2019 at 05:42:41PM +0900, Damien Le Moal wrote:
> Instead of checking a queue tag_set BLK_MQ_F_NO_SCHED flag before
> calling elevator_init_mq() to make sure that the queue supports IO
> scheduling, use the elevator.c function elv_support_iosched() in
> elevator_init_mq(). This does not introduce any functional change but
> ensure that elevator_init_mq() does the right thing based on the queue
> settings.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c   |  8 +++-----
>  block/elevator.c | 23 +++++++++++++----------
>  2 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b622029b19ea..13923630e00a 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2904,11 +2904,9 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>  	blk_mq_add_queue_tag_set(set, q);
>  	blk_mq_map_swqueue(q);
>  
> -	if (!(set->flags & BLK_MQ_F_NO_SCHED)) {
> -		ret = elevator_init_mq(q);
> -		if (ret)
> -			goto err_tag_set;
> -	}
> +	ret = elevator_init_mq(q);
> +	if (ret)
> +		goto err_tag_set;
>  
>  	return q;
>  
> diff --git a/block/elevator.c b/block/elevator.c
> index 86100de88883..4721834815bb 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -619,16 +619,26 @@ int elevator_switch_mq(struct request_queue *q,
>  	return ret;
>  }
>  
> +static inline bool elv_support_iosched(struct request_queue *q)
> +{
> +	if (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
> +		return false;
> +	return true;
> +}
> +
>  /*
> - * For blk-mq devices, we default to using mq-deadline, if available, for single
> - * queue devices.  If deadline isn't available OR we have multiple queues,
> - * default to "none".
> + * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
> + * if available, for single queue devices. If deadline isn't available OR we
> + * have multiple queues, default to "none".
>   */
>  int elevator_init_mq(struct request_queue *q)
>  {
>  	struct elevator_type *e;
>  	int err = 0;
>  
> +	if (!elv_support_iosched(q))
> +		return 0;
> +
>  	if (q->nr_hw_queues != 1)
>  		return 0;
>  
> @@ -706,13 +716,6 @@ static int __elevator_change(struct request_queue *q, const char *name)
>  	return elevator_switch(q, e);
>  }
>  
> -static inline bool elv_support_iosched(struct request_queue *q)
> -{
> -	if (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
> -		return false;
> -	return true;
> -}
> -
>  ssize_t elv_iosched_store(struct request_queue *q, const char *name,
>  			  size_t count)
>  {
> -- 
> 2.21.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming
