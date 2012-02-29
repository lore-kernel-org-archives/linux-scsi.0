From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
Date: Wed, 29 Feb 2012 11:49:39 -0800
Message-ID: <CABE8wwvhZTB8AONcdCyoE+i3rNKUHFwDSiwVWcLOU=zeKz_Nbg@mail.gmail.com>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
	<alpine.LFD.2.02.1202282240340.2794@ionos>
	<CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
	<1330507023.11248.113.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab2B2Ttl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 14:49:41 -0500
Received: by obbwd18 with SMTP id wd18so4225600obb.25
        for <linux-scsi@vger.kernel.org>; Wed, 29 Feb 2012 11:49:39 -0800 (PST)
In-Reply-To: <1330507023.11248.113.camel@twins>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>

On Wed, Feb 29, 2012 at 1:17 AM, Peter Zijlstra <a.p.zijlstra@chello.nl=
> wrote:
> On Tue, 2012-02-28 at 14:16 -0800, Dan Williams wrote:
>> Looks like everyone is guilty:
>>
>> [ =A0422.765336] softirq took longer than 1/4 tick: 3 NET_RX fffffff=
f813f0aa0
>> ...
>> [ =A0423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff=
812519c8
>> [ =A0423.985093] softirq took longer than 1/4 tick: 6 TASKLET ffffff=
ff8103422e
>> [ =A0423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff=
8105e2e1
>> [ =A0424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff81=
0a0fed
>> [ =A0424.008691] softirq loop took longer than 1/2 tick need_resched=
:
>
> /me kicks himself for not printing the actual duration.. :-)
>
>> As expected whenever that 1/2 tick message gets emitted the softirq
>> handler is almost running in a need_resched() context.
>
> Yeah.. that's quite expected.
>
>> So is it a good idea to get more aggressive about scheduling ksoftrr=
qd?
>
> Nah, moving away from softirq more like. I'll put moving the
> load-balancer into a kthread on the todo list. And it looks like
> everybody else should move to kthreads too.

I seem to recall this running into resistance (but maybe things have
changed in the last few years)?

https://lkml.org/lkml/2007/6/29/155
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
