From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 07:39:03 -0600 (CST)
Message-ID: <20071207133904.346FDDBA2@gherkin.frus.com>
References: <20071207022646.373c92f5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:49411 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXLGNjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 08:39:08 -0500
In-Reply-To: <20071207022646.373c92f5.akpm@linux-foundation.org>
 "from Andrew Morton at Dec 7, 2007 02:26:46 am"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Tracy <rct@frus.com>, mingo@elte.hu, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com

Andrew Morton wrote:
> On Thu, 6 Dec 2007 23:07:08 -0600 (CST) rct@frus.com (Bob Tracy) wrote:
> > Andrew Morton wrote:
> > > commit 6f37ac793d6ba7b35d338f791974166f67fdd9ba
> > > Merge: 2f1f53b... d90bf5a...
> > > Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> > > Date:   Wed Nov 14 18:51:48 2007 -0800
> > > 
> > >     Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/n
> > >     
> > >     * 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6:
> > >       (omitted for brevity)
> > > 
> > > I'm struggling to see how any of those could have broken block device
> > > mounting on alpha.  Are you sure you bisected right?
> > 
> > Based on what's in that commit, it *does* appear something went wrong
> > with bisection.  If the implicated commit is the next one in time
> > sequence relative to
> > 
> > # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> > 
> > then the test of whether I bisected correctly is as simple as applying
> > the commit and seeing if things break, because I'm running on the
> > kernel corresponding to 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right
> > now.  Let me give that a try and I'll report back.  Worst case, I'll
> > have to start over and write off the past four days...
> 
> Gad.  I trust the second time will be faster.
> 
> git-bisect _is_ very error prone.  I find one of the problems is that each
> step is so far apart in time that you forget what you were doing.  Did I
> remember to test that iteration?  Did I install the right kernel?  etc.
> 
> > Sorry about this...
> 
> Not appropriate ;)   Thanks for helping out.

Thanks for the kind words...  The above-mentioned test verified that the
bisection was/is correct: 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 works,
and 6f37ac793d6ba7b35d338f791974166f67fdd9ba doesn't.  Now I've got to
figure out why.

"git diff 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 6f37ac793d6ba7b35d338f791974166f67fdd9ba"
produced a relatively short patch (18,437 bytes).  The list of involved
files:

diff --git a/drivers/char/random.c b/drivers/char/random.c
diff --git a/drivers/isdn/sc/card.h b/drivers/isdn/sc/card.h
diff --git a/drivers/isdn/sc/packet.c b/drivers/isdn/sc/packet.c
diff --git a/drivers/isdn/sc/shmem.c b/drivers/isdn/sc/shmem.c
diff --git a/drivers/net/arm/ep93xx_eth.c b/drivers/net/arm/ep93xx_eth.c
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
diff --git a/drivers/net/fs_enet/Kconfig b/drivers/net/fs_enet/Kconfig
diff --git a/drivers/net/fs_enet/Makefile b/drivers/net/fs_enet/Makefile
diff --git a/drivers/net/netx-eth.c b/drivers/net/netx-eth.c
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
diff --git a/include/net/sock.h b/include/net/sock.h
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
diff --git a/net/core/dev.c b/net/core/dev.c
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c

Current state of the source tree is the 6f37ac... version, so I'll start
backing out the above diffs in related groups and continue until I've got
a working kernel.  For lack of an obvious target, I'll start with the
seemingly innocuous change to sysctl_check.c.  I'll report back when I've
got something.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
