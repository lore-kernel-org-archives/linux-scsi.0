Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3740C3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB60218AF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390633AbfISOYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:24:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389082AbfISOYC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 10:24:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 039B63018ECE;
        Thu, 19 Sep 2019 14:24:02 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26F5260933;
        Thu, 19 Sep 2019 14:23:52 +0000 (UTC)
Date:   Thu, 19 Sep 2019 22:23:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH 2/2] blk-mq: always call into the scheduler in
 blk_mq_make_request()
Message-ID: <20190919142344.GB11207@ming.t460p>
References: <20190919094547.67194-1-hare@suse.de>
 <20190919094547.67194-3-hare@suse.de>
 <BYAPR04MB5816F1F98D8F408D23C1AF47E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5816F1F98D8F408D23C1AF47E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 19 Sep 2019 14:24:02 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 19, 2019 at 10:21:54AM +0000, Damien Le Moal wrote:
> On 2019/09/19 11:45, Hannes Reinecke wrote:
> > From: Hannes Reinecke <hare@suse.com>
> > 
> > A scheduler might be attached even for devices exposing more than
> > one hardware queue, so the check for the number of hardware queue
> > is pointless and should be removed.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > ---
> >  block/blk-mq.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 44ff3c1442a4..faab542e4836 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -1931,7 +1931,6 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
> >  
> >  static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
> >  {
> > -	const int is_sync = op_is_sync(bio->bi_opf);
> >  	const int is_flush_fua = op_is_flush(bio->bi_opf);
> >  	struct blk_mq_alloc_data data = { .flags = 0};
> >  	struct request *rq;
> > @@ -1977,7 +1976,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
> >  		/* bypass scheduler for flush rq */
> >  		blk_insert_flush(rq);
> >  		blk_mq_run_hw_queue(data.hctx, true);
> > -	} else if (plug && (q->nr_hw_queues == 1 || q->mq_ops->commit_rqs)) {
> > +	} else if (plug && q->mq_ops->commit_rqs) {
> >  		/*
> >  		 * Use plugging if we have a ->commit_rqs() hook as well, as
> >  		 * we know the driver uses bd->last in a smart fashion.
> > @@ -2020,9 +2019,6 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
> >  			blk_mq_try_issue_directly(data.hctx, same_queue_rq,
> >  					&cookie);
> >  		}
> > -	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&
> > -			!data.hctx->dispatch_busy)) {
> > -		blk_mq_try_issue_directly(data.hctx, rq, &cookie);
> 
> It may be worth mentioning that blk_mq_sched_insert_request() will do a direct
> insert of the request using __blk_mq_insert_request(). But that insert is
> slightly different from what blk_mq_try_issue_directly() does with
> __blk_mq_issue_directly() as the request in that case is passed along to the
> device using queue->mq_ops->queue_rq() while __blk_mq_insert_request() will put
> the request in ctx->rq_lists[type].
> 
> This removes the optimized case !q->elevator && !data.hctx->dispatch_busy, but I
> am not sure of the actual performance impact yet. We may want to patch
> blk_mq_sched_insert_request() to handle that case.

The optimization did improve IOPS of single queue SCSI SSD a lot, see 

commit 6ce3dd6eec114930cf2035a8bcb1e80477ed79a8
Author: Ming Lei <ming.lei@redhat.com>
Date:   Tue Jul 10 09:03:31 2018 +0800

    blk-mq: issue directly if hw queue isn't busy in case of 'none'

    In case of 'none' io scheduler, when hw queue isn't busy, it isn't
    necessary to enqueue request to sw queue and dequeue it from
    sw queue because request may be submitted to hw queue asap without
    extra cost, meantime there shouldn't be much request in sw queue,
    and we don't need to worry about effect on IO merge.

    There are still some single hw queue SCSI HBAs(HPSA, megaraid_sas, ...)
    which may connect high performance devices, so 'none' is often required
    for obtaining good performance.

    This patch improves IOPS and decreases CPU unilization on megaraid_sas,
    per Kashyap's test.


Thanks,
Ming
