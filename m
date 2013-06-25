From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Mon, 24 Jun 2013 23:18:09 -0400
Message-ID: <20130625031809.GB8211@linux.intel.com>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
 <20130624080750.GA21768@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130624080750.GA21768@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 24, 2013 at 10:07:51AM +0200, Ingo Molnar wrote:
> I'm wondering, how will this scheme work if the IO completion latency is a 
> lot more than the 5 usecs in the testcase? What if it takes 20 usecs or 
> 100 usecs or more?

There's clearly a threshold at which it stops making sense, and our
current NAND-based SSDs are almost certainly on the wrong side of that
threshold!  I can't wait for one of the "post-NAND" technologies to make
it to market in some form that makes it economical to use in an SSD.

The problem is that some of the people who are looking at those
technologies are crazy.  They want to "bypass the kernel" and "do user
space I/O" because "the kernel is too slow".  This patch is part of an
effort to show them how crazy they are.  And even if it doesn't convince
them, at least users who refuse to rewrite their applications to take
advantage of magical userspace I/O libraries will see real performance
benefits.
