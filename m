From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup
 detector
Date: Sat, 3 Mar 2012 00:39:02 -0800
Message-ID: <20120303083902.GC8270@linux.vnet.ibm.com>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
 <1330422535.11248.78.camel@twins>
 <alpine.LFD.2.02.1202282240340.2794@ionos>
 <CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
 <1330507023.11248.113.camel@twins>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:46622 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2CCIjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Mar 2012 03:39:06 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Sat, 3 Mar 2012 01:39:06 -0700
Content-Disposition: inline
In-Reply-To: <1330507023.11248.113.camel@twins>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>

On Wed, Feb 29, 2012 at 10:17:03AM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-28 at 14:16 -0800, Dan Williams wrote:
> > Looks like everyone is guilty:
> > 
> > [  422.765336] softirq took longer than 1/4 tick: 3 NET_RX ffffffff813f0aa0
> > ...
> > [  423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff812519c8
> > [  423.985093] softirq took longer than 1/4 tick: 6 TASKLET ffffffff8103422e
> > [  423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff8105e2e1
> > [  424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff810a0fed
> > [  424.008691] softirq loop took longer than 1/2 tick need_resched:
> 
> /me kicks himself for not printing the actual duration.. :-)
> 
> > As expected whenever that 1/2 tick message gets emitted the softirq
> > handler is almost running in a need_resched() context.
> 
> Yeah.. that's quite expected.
> 
> > So is it a good idea to get more aggressive about scheduling ksoftrrqd? 
> 
> Nah, moving away from softirq more like. I'll put moving the
> load-balancer into a kthread on the todo list. And it looks like
> everybody else should move to kthreads too.

Last year when I tried that, things got a bit ugly.  I guess I don't need
the kthreads to be realtime unless CONFIG_RCU_BOOST=y, maybe that will
help.  Also IIRC Steven Rostedt made some real-time changes that might
help as well for my case, which would have a per-CPU RT kthread.

							Thanx, Paul

