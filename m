From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 02:26:46 -0800
Message-ID: <20071207022646.373c92f5.akpm@linux-foundation.org>
References: <20071206163305.c3587675.akpm@linux-foundation.org>
	<20071207050709.110D2DBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbXLGK1a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 05:27:30 -0500
In-Reply-To: <20071207050709.110D2DBA2@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@frus.com>
Cc: mingo@elte.hu, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com

On Thu, 6 Dec 2007 23:07:08 -0600 (CST) rct@frus.com (Bob Tracy) wrote:

> Andrew Morton wrote:
> > commit 6f37ac793d6ba7b35d338f791974166f67fdd9ba
> > Merge: 2f1f53b... d90bf5a...
> > Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> > Date:   Wed Nov 14 18:51:48 2007 -0800
> > 
> >     Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/n
> >     
> >     * 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6:
> >       [NET]: rt_check_expire() can take a long time, add a cond_resched()
> >       [ISDN] sc: Really, really fix warning
> >       [ISDN] sc: Fix sndpkt to have the correct number of arguments
> >       [TCP] FRTO: Clear frto_highmark only after process_frto that uses it
> >       [NET]: Remove notifier block from chain when register_netdevice_notifier f
> >       [FS_ENET]: Fix module build.
> >       [TCP]: Make sure write_queue_from does not begin with NULL ptr
> >       [TCP]: Fix size calculation in sk_stream_alloc_pskb
> >       [S2IO]: Fixed memory leak when MSI-X vector allocation fails
> >       [BONDING]: Fix resource use after free
> >       [SYSCTL]: Fix warning for token-ring from sysctl checker
> >       [NET] random : secure_tcp_sequence_number should not assume CONFIG_KTIME_S
> >       [IWLWIFI]: Not correctly dealing with hotunplug.
> >       [TCP] FRTO: Plug potential LOST-bit leak
> >       [TCP] FRTO: Limit snd_cwnd if TCP was application limited
> >       [E1000]: Fix schedule while atomic when called from mii-tool.
> >       [NETX]: Fix build failure added by 2.6.24 statistics cleanup.
> >       [EP93xx_ETH]: Build fix after 2.6.24 NAPI changes.
> >       [PKT_SCHED]: Check subqueue status before calling hard_start_xmit
> > 
> > I'm struggling to see how any of those could have broken block device
> > mounting on alpha.  Are you sure you bisected right?
> 
> Based on what's in that commit, it *does* appear something went wrong
> with bisection.  If the implicated commit is the next one in time
> sequence relative to
> 
> # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> 
> then the test of whether I bisected correctly is as simple as applying
> the commit and seeing if things break, because I'm running on the
> kernel corresponding to 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right
> now.  Let me give that a try and I'll report back.  Worst case, I'll
> have to start over and write off the past four days...

Gad.  I trust the second time will be faster.

git-bisect _is_ very error prone.  I find one of the problems is that each
step is so far apart in time that you forget what you were doing.  Did I
remember to test that iteration?  Did I install the right kernel?  etc.

> Sorry about this...

Not appropriate ;)   Thanks for helping out.
