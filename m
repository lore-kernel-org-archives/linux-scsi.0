From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
Date: Tue, 28 Feb 2012 14:16:56 -0800
Message-ID: <CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
	<alpine.LFD.2.02.1202282240340.2794@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965942Ab2B1WQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2012 17:16:57 -0500
Received: by obbwd18 with SMTP id wd18so3098666obb.25
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2012 14:16:56 -0800 (PST)
In-Reply-To: <alpine.LFD.2.02.1202282240340.2794@ionos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>

On Tue, Feb 28, 2012 at 1:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 28 Feb 2012, Peter Zijlstra wrote:
>
>> On Mon, 2012-02-27 at 12:38 -0800, Dan Williams wrote:
>> > An experimental hack to tease out whether we are continuing to
>> > run the softirq handler past the point of needing scheduling.
>> >
>> > It allows only one trip through __do_softirq() as long as need_resched()
>> > is set which hopefully creates the back pressure needed to get ksoftirqd
>> > scheduled.
>> >
>> > Targeted to address reports like the following that are produced
>> > with i/o tests to a sas domain with a large number of disks (48+), and
>> > lots of debugging enabled (slub_deubg, lockdep) that makes the
>> > block+scsi softirq path more cpu-expensive than normal.
>> >
>> > With this patch applied the softlockup detector seems appeased, but it
>> > seems odd to need changes to kernel/softirq.c so maybe I have overlooked
>> > something that needs changing at the block/scsi level?
>> >
>> > BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78]
>>
>> So you're stuck in softirq for 22s+, max_restart is 10, this gives that
>> on average you spend 2.2s+ per softirq invocation, this is completely
>> absolutely bonkers. Softirq handlers should never consume significant
>> amount of cpu-time.
>>
>> Thomas, think its about time we put something like the below in?
>
> Absolutely. Anything which consumes more than a few microseconds in
> the softirq handler needs to be sorted out, no matter what.

Looks like everyone is guilty:

[  422.765336] softirq took longer than 1/4 tick: 3 NET_RX ffffffff813f0aa0
...
[  423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff812519c8
[  423.985093] softirq took longer than 1/4 tick: 6 TASKLET ffffffff8103422e
[  423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff8105e2e1
[  424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff810a0fed
[  424.008691] softirq loop took longer than 1/2 tick need_resched:
yes max_restart: 10

As expected whenever that 1/2 tick message gets emitted the softirq
handler is almost running in a need_resched() context.

$ grep need_resched.*no log | wc -l
295
$ grep need_resched.*yes log | wc -l
3201

One of these warning messages gets printed out at a rate of 1 every
40ms. (468 second log w/ 11,725 of these messages).

So is it a good idea to get more aggressive about scheduling ksoftrrqd?

--
Dan
