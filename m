From: Ingo Molnar <mingo@kernel.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Mon, 24 Jun 2013 10:18:38 +0200
Message-ID: <20130624081838.GB21768@gmail.com>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <20130624071544.GR9422@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130624071544.GR9422@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org


* Jens Axboe <axboe@kernel.dk> wrote:

> - With the former note, the app either needs to opt in (and hence
>   willingly sacrifice CPU cycles of its scheduling slice) or it needs to 
>   be nicer in when it gives up and goes back to irq driven IO.

The scheduler could look at sleep latency averages of the task in question 
- we measure that already in most cases.

If the 'average sleep latency' is below a certain threshold, the 
scheduler, if it sees that the CPU is about to go idle, could delay doing 
the context switch and do "light idle-polling", for say twice the length 
of the expected sleep latency - assuming the CPU is otherwise idle - 
before it really schedules away the task and the CPU goes idle.

This would still require an IRQ and a wakeup to be taken, but would avoid 
the context switch.

Yet I have an ungood feeling about depending on actual latency values so 
explicitly. There will have to be a cutoff value, and if a workload is 
just below or just above that threshold then behavior will change 
markedly. Such schemes rarely worked out nicely in the past. [Might still 
be worth trying it.]

Couldn't the block device driver itself estimate the expected latency of 
IO completion and simply poll if that's expected to be very short [such as 
there's only a single outstanding IO to a RAM backed device]? IO drivers 
doing some polling and waiting in the microseconds range isnt overly 
controversial. I'd even do that if the CPU is busy otherwise: the task 
should see a proportional slowdown as load increases, with no change in IO 
queueing behavior.

Thanks,

	Ingo
