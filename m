From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
Date: Tue, 28 Feb 2012 14:25:43 -0800
Message-ID: <CABE8wwvFR2z0uuy6qyuer1XD0p2UQXS97GOHMcp3wXnot74QgQ@mail.gmail.com>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
	<alpine.LFD.2.02.1202282240340.2794@ionos>
	<CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:5211 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757208Ab2B1WZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2012 17:25:45 -0500
Received: by obbwd18 with SMTP id wd18so3107118obb.25
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2012 14:25:44 -0800 (PST)
In-Reply-To: <CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>

On Tue, Feb 28, 2012 at 2:16 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Tue, Feb 28, 2012 at 1:41 PM, Thomas Gleixner <tglx@linutronix.de>=
 wrote:
>> On Tue, 28 Feb 2012, Peter Zijlstra wrote:
>>
>>> On Mon, 2012-02-27 at 12:38 -0800, Dan Williams wrote:
>>> > An experimental hack to tease out whether we are continuing to
>>> > run the softirq handler past the point of needing scheduling.
>>> >
>>> > It allows only one trip through __do_softirq() as long as need_re=
sched()
>>> > is set which hopefully creates the back pressure needed to get ks=
oftirqd
>>> > scheduled.
>>> >
>>> > Targeted to address reports like the following that are produced
>>> > with i/o tests to a sas domain with a large number of disks (48+)=
, and
>>> > lots of debugging enabled (slub_deubg, lockdep) that makes the
>>> > block+scsi softirq path more cpu-expensive than normal.
>>> >
>>> > With this patch applied the softlockup detector seems appeased, b=
ut it
>>> > seems odd to need changes to kernel/softirq.c so maybe I have ove=
rlooked
>>> > something that needs changing at the block/scsi level?
>>> >
>>> > BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78]
>>>
>>> So you're stuck in softirq for 22s+, max_restart is 10, this gives =
that
>>> on average you spend 2.2s+ per softirq invocation, this is complete=
ly
>>> absolutely bonkers. Softirq handlers should never consume significa=
nt
>>> amount of cpu-time.
>>>
>>> Thomas, think its about time we put something like the below in?
>>
>> Absolutely. Anything which consumes more than a few microseconds in
>> the softirq handler needs to be sorted out, no matter what.
>
> Looks like everyone is guilty:
>
> [ =A0422.765336] softirq took longer than 1/4 tick: 3 NET_RX ffffffff=
813f0aa0
> ...
> [ =A0423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff8=
12519c8
> [ =A0423.985093] softirq took longer than 1/4 tick: 6 TASKLET fffffff=
f8103422e
> [ =A0423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff8=
105e2e1
> [ =A0424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff810=
a0fed
> [ =A0424.008691] softirq loop took longer than 1/2 tick need_resched:
> yes max_restart: 10
>
> As expected whenever that 1/2 tick message gets emitted the softirq
> handler is almost running in a need_resched() context.
>
> $ grep need_resched.*no log | wc -l
> 295
> $ grep need_resched.*yes log | wc -l
> 3201
>
> One of these warning messages gets printed out at a rate of 1 every
> 40ms. (468 second log w/ 11,725 of these messages).
>
> So is it a good idea to get more aggressive about scheduling ksoftrrq=
d?
>

Keep in mind this is with slub_debug and lockdep turned on, but we are
basically looking to do extended i/o runs on large topologies and want
the soft lockup detector to not generate false positives.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
