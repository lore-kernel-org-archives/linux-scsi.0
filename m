From: Jens Axboe <axboe@kernel.dk>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Mon, 24 Jun 2013 09:15:45 +0200
Message-ID: <20130624071544.GR9422@kernel.dk>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130623100920.GA19021@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 23 2013, Ingo Molnar wrote:
> I'm wondering why this makes such a performance difference.

They key ingredient here is simply not going to sleep, only to get an
IRQ and get woken up very shortly again. NAPI and similar approaches
work great for high IOPS cases, where you maintain a certain depth of
IO. For lower queue depth or sync IO (like Willy is running here),
nothing beats the pure app driven poll from a latency perspective. I've
seen plenty of systems where the power management is also so aggressive,
that you manage to enter lower C states very quickly and that then of
course makes things even worse. Intelligent polling would make that less
of a problem.

Willy, I think the general design is fine, hooking in via the bdi is the
only way to get back to the right place from where you need to sleep.
Some thoughts:

- This should be hooked in via blk-iopoll, both of them should call into
  the same driver hook for polling completions.

- It needs to be more intelligent in when you want to poll and when you
  want regular irq driven IO.

- With the former note, the app either needs to opt in (and hence
  willingly sacrifice CPU cycles of its scheduling slice) or it needs to
  be nicer in when it gives up and goes back to irq driven IO.

-- 
Jens Axboe
