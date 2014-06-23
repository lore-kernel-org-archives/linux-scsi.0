From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Mon, 23 Jun 2014 15:38:52 +0200
Message-ID: <20140623133852.GD24389@soda.linbit>
References: <53A28B21.7070500@profihost.ag>
 <yq1ionwjn15.fsf@sermon.lab.mkp.net>
 <20140620155321.GA24389@soda.linbit>
 <yq1wqcbil0c.fsf@sermon.lab.mkp.net>
 <20140620182956.GB24389@soda.linbit>
 <53A5C566.4050904@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53A5C566.4050904@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 21, 2014 at 07:48:22PM +0200, Stefan Priebe wrote:
> Hi Lars,
> Am 20.06.2014 20:29, schrieb Lars Ellenberg:
> >On Fri, Jun 20, 2014 at 12:49:39PM -0400, Martin K. Petersen wrote:
> >>>>>>>"Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:
> >>
> >>Lars,
> >>
> >>Lars> Any bio allocated that will be passed down with REQ_DISCARD has to
> >>Lars> be allocated with nr_iovecs = 1 (at least), even though it must
> >>Lars> not contain any bio_vec payload.
> >>
> >>True. Although the correct answer is: Any discard request must be issued
> >>by blkdev_issue_discard(). That's the interface.
> >>
> >>The hacks we do to carry the information inside the bio constitute an
> >>internal interface that is subject to change (it is just about to,
> >>actually).
> >>
> >>Lars> Though DRBD in 3.10 is not supposed to accept discard requests.
> >>Lars> So I'm not sure how it manages to pass them down?
> 
> your're absolutely right - a collegue installed drbd 8.4.4 as a
> module. I didn't knew that. Sorry.

That is (again) incorrect/incomplete.

Your original post:
> while using vanilla 3.10.44 with drbd on top of a md raid1.
...
> CPU: 0 PID: 636 Comm: md124_raid1 Tainted: G O 3.10.41+76-ph #1
> Modules linked in: ... drbd ...

So it's not vanilla, its not 3.10.44, and its not 3.10.41 either,
and its not even a "clean" external module.

But its "something" based on 3.10.41,
where you added your own patches or "backports",
and now complain to the upstream maintainers that it explodes,
and don't bother to tell them that it is modified code.

> So your attached patch will fix it?

No.
For the out-of-tree module it is fixed.
You just need to upgrade.

This is for the 3.16-rc1 and later in-tree DRBD,
where this fix apparently slipt through when preparing the pull request.

It has not even been in a released mainline kernel yet.

But thanks anyways for reporting it,
it may have ended up unnoticed in 3.16.

	Lars

