From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Tue, 25 Jun 2013 09:57:28 -0400
Message-ID: <1372168648.18733.200.camel@gandalf.local.home>
References: <20130620201713.GV8211@linux.intel.com>
	 <20130623100920.GA19021@gmail.com>
	 <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
	 <20130624071718.GS9422@kernel.dk> <20130625001102.GA6623@home.goodmis.org>
	 <20130625030721.GA8211@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130625030721.GA8211@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-06-24 at 23:07 -0400, Matthew Wilcox wrote:
> On Mon, Jun 24, 2013 at 08:11:02PM -0400, Steven Rostedt wrote:
> > What about hooking into the idle_balance code? That happens if we are
> > about to go to idle but before the full schedule switch to the idle
> > task.
> > 
> > 
> > In __schedule(void):
> > 
> > 	if (unlikely(!rq->nr_running))
> > 		idle_balance(cpu, rq);
> 
> That may be a great place to try it from the PoV of the scheduler, but are
> you OK with me threading a struct backing_dev_info * all the way through
> the scheduler to idle_balance()?  :-)

Well, there's other ways to pass data down besides parameters. You could
attach something to the task itself.

-- Steve
