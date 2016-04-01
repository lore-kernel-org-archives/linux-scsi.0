From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Fri, 1 Apr 2016 10:14:56 -0400
Message-ID: <20160401141456.GB24355@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <6c6623e7f92e31daf1586d266fa03e1d@suse.de>
 <20160401132219.GA24355@redhat.com>
 <cddb09e2c2af7f7ea0337cf76657c896@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbcDAOO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 10:14:58 -0400
Content-Disposition: inline
In-Reply-To: <cddb09e2c2af7f7ea0337cf76657c896@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com, hare@suse.de

On Fri, Apr 01 2016 at  9:37am -0400,
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> [ +Cc Hannes ]
> 
> On 2016-04-01 15:22, Mike Snitzer wrote:
> >On Fri, Apr 01 2016 at  4:12am -0400,
> >Johannes Thumshirn <jthumshirn@suse.de> wrote:
> >
> >>On 2016-03-31 22:04, Mike Snitzer wrote:
> >>>I developed these changes some weeks ago but have since focused on
> >>>regression and performance testing on larger NUMA systems.
> >>>
> >>>For regression testing I've been using mptest:
> >>>https://github.com/snitm/mptest
> >>>
> >>>For performance testing I've been using a null_blk device (with
> >>>various configuration permutations, e.g. pinning memory to a
> >>>particular NUMA node, and varied number of submit_queues).
> >>>
> >>>By eliminating multipath's heavy use of the m->lock spinlock in the
> >>>fast IO paths serious performance improvements are realized.
> >>
> >>Hi Mike,
> >>
> >>Are this the patches you pointed Hannes to?
> >>
> >>If yes, please add my Tested-by: Johannes Thumshirn
> >><jthumshirn@suse.de>
> >
> >No they are not.
> >
> >Hannes seems to have last pulled in my DM mpath changes that
> >(ab)used RCU.
> >I ended up dropping those changes and this patchset is the replacement.
> 
> Now that you're saying it I can remember some inspiring RCU usage in
> the patches.
> 
> >So please retest with this patchset (I know you guys have a large setup
> >that these changes are very relevant for).  If you could actually share
> >_how_ yo've tested that'd help me understand how these changes are
> >holding up.  So far all looks good for me...
> 
> The test itself is actually quite simple, we're testing with fio
> against a fiber channel array (all SSDs but I was very careful to
> only write into the cache)
> 
> Here's my fio job file:
> [mq-test]
> iodepth=128
> numjobs=40
> group_reporting
> direct=1
> ioengine=libaio
> size=3G
> filename=/dev/dm-0
> filename=/dev/dm-1
> filename=/dev/dm-2
> filename=/dev/dm-3
> filename=/dev/dm-4
> filename=/dev/dm-5
> filename=/dev/dm-6
> filename=/dev/dm-7
> name="MQ Test"
> 
> and the test runner:
> #!/bin/sh
> 
> for rw in 'randread' 'randwrite' 'read' 'write'; do
>         for bs in '4k' '8k' '16k' '32k' '64k'; do
>                 fio mq-test.fio --bs="${bs}" --rw="${rw}"
> --output="fio-${bs}-${rw}.txt"
>         done
> done
> 
> The initiator has 40 CPUs on 4 NUMA nodes (no HT) and 64GB RAM. I'm
> not sure how much in term of numbers I can share from the old
> patchset (will ask Hannes on Monday), but I'm aware I'll have to
> when I retested with your new patches and we want to compare the
> results.

OK, yes please share as much as you can.  Having shared code that seems
to perform well it'd be nice to see some results from your testbed.
It'll help build my confidence in the code actually landing upstream.

Thanks,
Mike
