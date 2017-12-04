From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Tue, 5 Dec 2017 07:01:52 +0800
Message-ID: <20171204230151.GD6888@ming.t460p>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
 <20171204224200.GA6888@ming.t460p>
 <1512427697.2795.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512427697.2795.14.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 04, 2017 at 10:48:18PM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 06:42 +0800, Ming Lei wrote:
> > On Mon, Dec 04, 2017 at 09:30:32AM -0800, Bart Van Assche wrote:
> > > * A systematic lockup for SCSI queues with queue depth 1. The
> > >   following test reproduces that bug systematically:
> > >   - Change the SRP initiator such that SCSI target queue depth is
> > >     limited to 1.
> > >   - Run the following command:
> > >       srp-test/run_tests -f xfs -d -e none -r 60 -t 01
> > >   See also "[PATCH 4/7] blk-mq: Avoid that request processing
> > >   stalls when sharing tags"
> > >   (https://marc.info/?l=linux-block&m=151208695316857). Note:
> > >   reverting commit 0df21c86bdbf also fixes a sporadic SCSI request
> > >   queue lockup while inserting a blk_mq_sched_mark_restart_hctx()
> > >   before all blk_mq_dispatch_rq_list() calls only fixes the
> > >   systematic lockup for queue depth 1.
> > 
> > You are the only reproducer [ ... ]
> 
> That's not correct. I'm pretty sure if you try to reproduce this that
> you will see the same hang I ran into. Does this mean that you have not
> yet tried to reproduce the hang I reported?

Do you mean every kernel developer has to own one SRP/IB hardware?
I don't have your hardware to reproduce that, and I don't think most
of guys have that. Otherwise, there should have be such similar reports
from others, not from only you.

More importantly I don't understand why you can't share the kernel
log/debugfs log when IO hang happens?

Without any kernel log, how can we confirm that it is a valid report?

> 
> > You said that your patch fixes 'commit b347689ffbca ("blk-mq-sched:
> > improve dispatching from sw queue")', but you don't mention any issue
> > about that commit.
> 
> That's not correct either. From the commit message "A systematic lockup
> for SCSI queues with queue depth 1."

I mean you mentioned your patch can fix 'commit b347689ffbca
("blk-mq-sched: improve dispatching from sw queue")', but you never
point where the commit b347689ffbca is wrong, how your patch fixes
the mistake of that commit.

> 
> > > I think the above means that it is too risky to try to fix all bugs
> > > introduced by commit 0df21c86bdbf before kernel v4.15 is released.
> > > Hence revert that commit.
> > 
> > What is the risk?
> 
> That more bugs were introduced by commit 0df21c86bdbf than the ones that
> have been discovered so far.

If you don't provide any log, I have to ignore your report simply.
So there is only one real issue which can be addressed easily by
the following patch:

https://marc.info/?l=linux-scsi&m=151223234607157&w=2

-- 
Ming
