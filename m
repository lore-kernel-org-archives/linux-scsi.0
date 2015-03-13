From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/7] blk-mq: fix use of incorrect goto label in
 blk_mq_init_queue error path
Date: Thu, 12 Mar 2015 23:29:23 -0400
Message-ID: <20150313032923.GA7312@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
 <1426132602-34331-2-git-send-email-snitzer@redhat.com>
 <CACVXFVN7zpb3+wcOdsa5yyrRJ-EDw7EcMNJOao45UgRZO3rpcQ@mail.gmail.com>
 <20150312135147.GA3444@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbbCMD33 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2015 23:29:29 -0400
Content-Disposition: inline
In-Reply-To: <20150312135147.GA3444@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, dm-devel@redhat.com

On Thu, Mar 12 2015 at  9:51am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Mar 12 2015 at  3:48am -0400,
> Ming Lei <tom.leiming@gmail.com> wrote:
> 
> > On Thu, Mar 12, 2015 at 11:56 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > > If percpu_ref_init() fails the 'err_hctxs' label should be used instead
> > > of 'err_map'.
> > >
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > ---
> > >  block/blk-mq.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > > index 4f4bea2..459840c 100644
> > > --- a/block/blk-mq.c
> > > +++ b/block/blk-mq.c
> > > @@ -1938,7 +1938,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
> > >          */
> > >         if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
> > >                             PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
> > > -               goto err_map;
> > > +               goto err_hctxs;
> > 
> > If it is changed to 'goto err_hctxs', percpu_ref_init() need to
> > move before blk_alloc_queue_node(), otherwise just 'goto err_hw'
> > is enough, but the former is better.
> 
> Yes, you're correct.  Patch 2 happened to eliminate this problem.  But
> I'll get it fixed up and post v2.

Actually, percpu_ref_init clearly cannot go before blk_alloc_queue_node
since percpu_ref_init deferences q.  (buildbot just emailed complaining
about crashes with my v2 patch).  I didn't test this 1/7 patch in
isolation but should have -- when 2/7 is applied the problem goes away.

v3 of these first 2 patches will be inbound shortly.
