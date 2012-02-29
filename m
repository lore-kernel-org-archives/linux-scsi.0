From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup
 detector
Date: Wed, 29 Feb 2012 10:17:03 +0100
Message-ID: <1330507023.11248.113.camel@twins>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	 <1330422535.11248.78.camel@twins>
	 <alpine.LFD.2.02.1202282240340.2794@ionos>
	 <CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-02-28 at 14:16 -0800, Dan Williams wrote:
> Looks like everyone is guilty:
> 
> [  422.765336] softirq took longer than 1/4 tick: 3 NET_RX ffffffff813f0aa0
> ...
> [  423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff812519c8
> [  423.985093] softirq took longer than 1/4 tick: 6 TASKLET ffffffff8103422e
> [  423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff8105e2e1
> [  424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff810a0fed
> [  424.008691] softirq loop took longer than 1/2 tick need_resched:

/me kicks himself for not printing the actual duration.. :-)

> As expected whenever that 1/2 tick message gets emitted the softirq
> handler is almost running in a need_resched() context.

Yeah.. that's quite expected.

> So is it a good idea to get more aggressive about scheduling ksoftrrqd? 

Nah, moving away from softirq more like. I'll put moving the
load-balancer into a kthread on the todo list. And it looks like
everybody else should move to kthreads too.
