Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B2AC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 22:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C39A20842
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 22:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfHLWpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 18:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfHLWpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 18:45:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6827693C8;
        Mon, 12 Aug 2019 22:45:48 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D893D7A417;
        Mon, 12 Aug 2019 22:45:39 +0000 (UTC)
Date:   Tue, 13 Aug 2019 06:45:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Minwoo Im <minwoo.im.dev@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Busch <keith.busch@intel.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V2 0/5] blk-mq: improvement on handling IO during CPU
 hotplug
Message-ID: <20190812224531.GC17645@ming.t460p>
References: <20190812134312.16732-1-ming.lei@redhat.com>
 <20190812134608.GA16803@ming.t460p>
 <658b0e7f-72f6-3673-d35e-4d8078069258@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <658b0e7f-72f6-3673-d35e-4d8078069258@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 12 Aug 2019 22:45:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 12, 2019 at 05:21:44PM +0100, John Garry wrote:
> On 12/08/2019 14:46, Ming Lei wrote:
> > Hi John,
> > 
> > On Mon, Aug 12, 2019 at 09:43:07PM +0800, Ming Lei wrote:
> > > Hi,
> > > 
> > > Thomas mentioned:
> > >     "
> > >      That was the constraint of managed interrupts from the very beginning:
> > > 
> > >       The driver/subsystem has to quiesce the interrupt line and the associated
> > >       queue _before_ it gets shutdown in CPU unplug and not fiddle with it
> > >       until it's restarted by the core when the CPU is plugged in again.
> > >     "
> > > 
> > > But no drivers or blk-mq do that before one hctx becomes dead(all
> > > CPUs for one hctx are offline), and even it is worse, blk-mq stills tries
> > > to run hw queue after hctx is dead, see blk_mq_hctx_notify_dead().
> > > 
> > > This patchset tries to address the issue by two stages:
> > > 
> > > 1) add one new cpuhp state of CPUHP_AP_BLK_MQ_ONLINE
> > > 
> > > - mark the hctx as internal stopped, and drain all in-flight requests
> > > if the hctx is going to be dead.
> > > 
> > > 2) re-submit IO in the state of CPUHP_BLK_MQ_DEAD after the hctx becomes dead
> > > 
> > > - steal bios from the request, and resubmit them via generic_make_request(),
> > > then these IO will be mapped to other live hctx for dispatch
> > > 
> > > Please comment & review, thanks!
> > > 
> > > V2:
> > > 	- patch4 & patch 5 in V1 have been merged to block tree, so remove
> > > 	  them
> > > 	- address comments from John Garry and Minwoo
> > > 
> > > 
> > > Ming Lei (5):
> > >   blk-mq: add new state of BLK_MQ_S_INTERNAL_STOPPED
> > >   blk-mq: add blk-mq flag of BLK_MQ_F_NO_MANAGED_IRQ
> > >   blk-mq: stop to handle IO before hctx's all CPUs become offline
> > >   blk-mq: re-submit IO in case that hctx is dead
> > >   blk-mq: handle requests dispatched from IO scheduler in case that hctx
> > >     is dead
> > > 
> > >  block/blk-mq-debugfs.c     |   2 +
> > >  block/blk-mq-tag.c         |   2 +-
> > >  block/blk-mq-tag.h         |   2 +
> > >  block/blk-mq.c             | 143 +++++++++++++++++++++++++++++++++----
> > >  block/blk-mq.h             |   3 +-
> > >  drivers/block/loop.c       |   2 +-
> > >  drivers/md/dm-rq.c         |   2 +-
> > >  include/linux/blk-mq.h     |   5 ++
> > >  include/linux/cpuhotplug.h |   1 +
> > >  9 files changed, 146 insertions(+), 16 deletions(-)
> > > 
> > > Cc: Bart Van Assche <bvanassche@acm.org>
> > > Cc: Hannes Reinecke <hare@suse.com>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Keith Busch <keith.busch@intel.com>
> > > --
> > > 2.20.1
> > > 
> > 
> > Sorry for forgetting to Cc you.
> 
> Already subscribed :)
> 
> I don't mean to hijack this thread, but JFYI we're getting around to test
> https://github.com/ming1/linux/commits/v5.2-rc-host-tags-V2 - unfortunately
> we're still seeing a performance regression. I can't see where it's coming
> from. We're double-checking the test though.

host-tag patchset is only for several particular drivers which use
private reply queue as completion queue.

This patchset is for handling generic blk-mq CPU hotplug issue, and
the several particular scsi drivers(hisi_sas_v3, hpsa, megaraid_sas and
mp3sas) won't be covered so far.

I'd suggest to move on for generic blk-mq devices first given now blk-mq
is the only request IO path now.

There are at least two choices for us to handle drivers/devices with
private completion queue:

1) host-tags
- performance issue shouldn't be hard to solve, given it is same with
with single tags in theory, and just corner cases is there.

What I am not glad with this approach is that blk-mq-tag code becomes mess.

2) private callback
- we could define private callback to drain each completion queue in
  driver simply.
- problem is that the four drivers have to duplicate the same job


Thanks,
Ming
