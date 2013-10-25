From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [3.12-rc] sg_open: leaving the kernel with locks still held!
Date: Fri, 25 Oct 2013 08:20:05 +0100
Message-ID: <1382685605.2559.48.camel@dabdike.quadriga.com>
References: <20131022205608.GA6616@hostway.ca>
	 <52671B3E.6070804@interlog.com>
	 <1382514295.2081.32.camel@dabdike.quadriga.com>
	 <5267D8E7.9000806@interlog.com> <20131025003713.GA5152@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131025003713.GA5152@hostway.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Vaughan Cao <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-10-24 at 17:37 -0700, Simon Kirby wrote:
> On Wed, Oct 23, 2013 at 10:10:47AM -0400, Douglas Gilbert wrote:
> 
> > On 13-10-23 03:44 AM, James Bottomley wrote:
> > >On Tue, 2013-10-22 at 20:41 -0400, Douglas Gilbert wrote:
> > >>On 13-10-22 04:56 PM, Simon Kirby wrote:
> > >>>Hello!
> > >>>
> > >>>While trying to figure out why the request queue to sda (ext4) was
> > >>>clogging up on one of our btrfs backup boxes, I noticed a megarc process
> > >>>in D state, so enabled locking debugging, and got this (on 3.12-rc6):
> > >>>
> > >>>[  205.372823] ================================================
> > >>>[  205.372901] [ BUG: lock held when returning to user space! ]
> > >>>[  205.372979] 3.12.0-rc6-hw-debug-pagealloc+ #67 Not tainted
> > >>>[  205.373055] ------------------------------------------------
> > >>>[  205.373132] megarc.bin/5283 is leaving the kernel with locks still held!
> > >>>[  205.373212] 1 lock held by megarc.bin/5283:
> > >>>[  205.373285]  #0:  (&sdp->o_sem){.+.+..}, at: [<ffffffff8161e650>] sg_open+0x3a0/0x4d0
> > >>>
> > >>>Vaughan, it seems you touched this area last in 15b06f9a02406e, and git
> > >>>tag --contains says this went in for 3.12-rc. We didn't see this on 3.11,
> > >>>though I haven't tried with lockdep.
> > >>>
> > >>>This is caused by some of our internal RAID monitoring scripts that run
> > >>>"megarc.bin -dispCfg -a0" (even though that controller isn't present on
> > >>>this server -- a PowerEdge 2950 w/Perc 5).
> > >>>
> > >>>strace output of the program execution that causes the above message is
> > >>>here: http://0x.ca/sim/ref/3.12-rc6/megarc_strace.txt
> > >>
> > >>This has been reported. That patch will be reverted or,
> > >>if there is enough time, a fix will (or at least should)
> > >>go in before the release of lk 3.12 .
> > >
> > >I think you've got about a week to prove you can fix it (before 3.12
> > >goes final).  I'll send my current set of fixes to Linus without doing
> > >anything about sg.
> > 
> > "prove" is a big ask, especially coming from a
> > mathematician. I consider it more hacking (in the
> > golf sense) on my part to tweak well-meaning patches
> > to the sg driver that cause collateral damage. Further,
> > I suspect Vaughan's patch was an attempt to fix
> > damage left be a previous sg_open() hacker.
> > 
> > I have asked Simon Kirby to apply the patch:
> >   http://marc.info/?l=linux-scsi&m=138237283432010&w=2
> > and report if it fixes his problems. Further I have
> > written three test programs to test O_EXCL handling on
> > SCSI devices, two of which are in the examples directory
> > of sg3_utils version 1.37 . The latest one (single
> > exclusive writer, multiple readers) can be found in
> > the News section of:
> >    http://sg.danny.cz/sg/
> > These tests don't check all possibilities (e.g. random
> > signals, ml error processing and detached devices) but
> > they are better than nothing. And, as a side issue, they
> > break bsg (cause it ignores O_EXCL) and break the block
> > layer (e.g. /dev/sdb) so perhaps it should be reverted :-)
> 
> Well, this patch works for me in that I see no more lockdep warnings or
> unintended consequences when running the same "megarc.bin -dispCfg -a0"
> command.

OK, I thought about this some more and I just don't see the problem as
being so urgent that we do a fixup patch on the eve of the merge window.
Lets just do the revert and then, Doug, do your patch from the revert
and I'll put it in in the merge window.

James
