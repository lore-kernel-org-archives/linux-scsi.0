From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
Date: Tue, 28 Feb 2012 08:48:38 -0800
Message-ID: <CABE8wwtv2YDCYkk5C5waZCkdG3+9pMbwsKvuce0q-Kj=pnduwg@mail.gmail.com>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330422535.11248.78.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 28, 2012 at 1:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78]
>
> So you're stuck in softirq for 22s+, max_restart is 10, this gives that
> on average you spend 2.2s+ per softirq invocation, this is completely
> absolutely bonkers. Softirq handlers should never consume significant
> amount of cpu-time.

I'm not sure whether this was just one __do_softirq() invocation, or
multiple.  I'll see if I can instrument this, but the suspicion is
that max_restart can't help when softirq is constantly re-triggered.
I'll also add the below patch to see if any single invocation is
violating these expectations.

--
Dan
