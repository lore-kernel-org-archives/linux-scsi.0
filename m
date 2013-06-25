From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Tue, 25 Jun 2013 09:07:29 +0200
Message-ID: <51C941B1.6000305@acm.org>
References: <20130620201713.GV8211@linux.intel.com> <20130623100920.GA19021@gmail.com> <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com> <20130624080750.GA21768@gmail.com> <20130625031809.GB8211@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130625031809.GB8211@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On 06/25/13 05:18, Matthew Wilcox wrote:
> On Mon, Jun 24, 2013 at 10:07:51AM +0200, Ingo Molnar wrote:
>> I'm wondering, how will this scheme work if the IO completion latency is a
>> lot more than the 5 usecs in the testcase? What if it takes 20 usecs or
>> 100 usecs or more?
>
> There's clearly a threshold at which it stops making sense, and our
> current NAND-based SSDs are almost certainly on the wrong side of that
> threshold!  I can't wait for one of the "post-NAND" technologies to make
> it to market in some form that makes it economical to use in an SSD.
>
> The problem is that some of the people who are looking at those
> technologies are crazy.  They want to "bypass the kernel" and "do user
> space I/O" because "the kernel is too slow".  This patch is part of an
> effort to show them how crazy they are.  And even if it doesn't convince
> them, at least users who refuse to rewrite their applications to take
> advantage of magical userspace I/O libraries will see real performance
> benefits.

Recently I attended an interesting talk about this subject in which it 
was proposed not only to bypass the kernel for access to high-IOPS 
devices but also to allow byte-addressability for block devices. The 
slides that accompanied that talk can be found here (includes a 
performance comparison with the traditional block driver API):

Bernard Metzler, On Suitability of High-Performance Networking API for 
Storage, OFA Int'l Developer Workshop, April 24, 2013 
(http://www.openfabrics.org/ofa-documents/presentations/doc_download/559-on-suitability-of-high-performance-networking-api-for-storage.html).

This approach leaves the choice of whether to use polling or an 
interrupt-based completion notification to the user of the new API, 
something the Linux InfiniBand RDMA verbs API already allows today.

Bart.
