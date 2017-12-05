From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Tue, 5 Dec 2017 08:20:46 +0800
Message-ID: <20171205002040.GA8365@ming.t460p>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
 <20171204224200.GA6888@ming.t460p>
 <1512427697.2795.14.camel@wdc.com>
 <20171204230151.GD6888@ming.t460p>
 <1512430346.2795.34.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLEAVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 19:21:03 -0500
Content-Disposition: inline
In-Reply-To: <1512430346.2795.34.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

On Mon, Dec 04, 2017 at 11:32:27PM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 07:01 +0800, Ming Lei wrote:
> > On Mon, Dec 04, 2017 at 10:48:18PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-12-05 at 06:42 +0800, Ming Lei wrote:
> > > > On Mon, Dec 04, 2017 at 09:30:32AM -0800, Bart Van Assche wrote:
> > > > > * A systematic lockup for SCSI queues with queue depth 1. The
> > > > >   following test reproduces that bug systematically:
> > > > >   - Change the SRP initiator such that SCSI target queue depth is
> > > > >     limited to 1.
> > > > >   - Run the following command:
> > > > >       srp-test/run_tests -f xfs -d -e none -r 60 -t 01
> > > > >   See also "[PATCH 4/7] blk-mq: Avoid that request processing
> > > > >   stalls when sharing tags"
> > > > >   (https://marc.info/?l=linux-block&m=151208695316857). Note:
> > > > >   reverting commit 0df21c86bdbf also fixes a sporadic SCSI request
> > > > >   queue lockup while inserting a blk_mq_sched_mark_restart_hctx()
> > > > >   before all blk_mq_dispatch_rq_list() calls only fixes the
> > > > >   systematic lockup for queue depth 1.
> > > > 
> > > > You are the only reproducer [ ... ]
> > > 
> > > That's not correct. I'm pretty sure if you try to reproduce this that
> > > you will see the same hang I ran into. Does this mean that you have not
> > > yet tried to reproduce the hang I reported?
> > 
> > Do you mean every kernel developer has to own one SRP/IB hardware?
> 
> When I have the time I will make it possible to run this test on any system
> equipped with at least one Ethernet port. But the fact that the test I
> mentioned requires IB hardware should not prevent you from running this test
> since you have run this test software before.
> 
> > I don't have your hardware to reproduce that,
> 
> That's not true. Your employer definitely owns IB hardware. E.g. the
> following message shows that you have run the srp-test yourself on IB hardware
> only four weeks ago:
> 
> https://www.spinics.net/lists/linux-block/msg19511.html

The hardware belongs to Laurence, at that time I can borrow from him, and
now I am not sure if it is available.

> 
> > Otherwise, there should have be such similar reports from others, not from
> > only you.
> 
> That's not correct either. How long was it ago that kernel v4.15-rc1 was
> released? One week? How many SRP users do you think have tried to trigger a
> queue full condition with that kernel version?

OK, we can wait for further reporters to provide kernel log if you
don't want.

> 
> > More importantly I don't understand why you can't share the kernel
> > log/debugfs log when IO hang happens?
> > 
> > Without any kernel log, how can we confirm that it is a valid report?
> 
> It's really unfortunate that you are focussing on denying that the bug I
> reported exists instead of trying to fix the bugs introduced by commit

If you look at bug reports in kenrel mail list, you will see most of
reports includes some kind of log, that is a common practice to report
issue with log attached. It can save us much time for talking in mails.

> b347689ffbca. BTW, I have more than enough experience to decide myself what
> a valid report is and what not. I can easily send you several MB of kernel

As I mentioned, only dmesg with hang trace and debugfs log should be enough,
both can't be so big, right?

> logs. The reason I have not yet done this is because I'm 99.9% sure that
> these won't help to root cause the reported issue. But I can tell you what

That is your opinion, most of times, I can find some clue from debugfs
about hang issue, then I can try to add trace just in some possible
places for narrowing down the issue.

> I learned from analyzing the information under /sys/kernel/debug/block:
> every time a hang occurred I noticed that no requests were "busy", that two
> requests occurred in rq_lists and one request occurred in a hctx dispatch

Then what do other attributes show? Like queue/hctx state?

The following script can get all this info easily:

	http://people.redhat.com/minlei/tests/tools/dump-blk-info

Also it is a bit odd to see request in hctx->dispatch now, and it can only
happen now when scsi_target_queue_ready() returns false, so I guess you apply
some change on target->can_queue(such as setting it as 1 in srp/ib code
manually)?

Please reply, if yes, I will try to see if I can reproduce it with this
kind of change on scsi_debug.

> list. This is enough to conclude that a queue run was missing. And I think

In this case, seems it isn't related with both commit b347689ff and 0df21c86bdbf,
since both don't change RESTART for hctx->dispatch, and shouldn't affect
run queue.

> that the patch at the start of this e-mail thread not only shows that the
> root cause is in the block layer but also that this bug was introduced by
> commit b347689ffbca.
> 
> > > > You said that your patch fixes 'commit b347689ffbca ("blk-mq-sched:
> > > > improve dispatching from sw queue")', but you don't mention any issue
> > > > about that commit.
> > > 
> > > That's not correct either. From the commit message "A systematic lockup
> > > for SCSI queues with queue depth 1."
> > 
> > I mean you mentioned your patch can fix 'commit b347689ffbca
> > ("blk-mq-sched: improve dispatching from sw queue")', but you never
> > point where the commit b347689ffbca is wrong, how your patch fixes
> > the mistake of that commit.
> 
> You should know that it is not required to perform a root cause analysis
> before posting a revert. Having performed a bisect is sufficient.

I don't think your issue can't be fixed before releasing V4.15 if enough
log are provided, and reverting can cause performance regression for all
SCSI_MQ users.

Also more importantly you may revert a wrong commit, because sometimes
some commits may make some issue happen easily, not the direct reason
of the issue.

> 
> BTW, it seems like you forgot that last Friday I explained to you that there
> is an obvious bug in commit b347689ffbca, namely that a blk_mq_sched_mark_restart_hctx()
> call is missing in blk_mq_sched_dispatch_requests() before the blk_mq_do_dispatch_ctx()
> call. See also https://marc.info/?l=linux-block&m=151215794224401.

No, I have explained to you that your change isn't necessary, see:

 https://marc.info/?l=linux-block&m=151217500929341&w=2

-- 
Ming
