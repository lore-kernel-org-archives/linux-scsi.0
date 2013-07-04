From: Shaohua Li <shli@kernel.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Thu, 4 Jul 2013 09:13:01 +0800
Message-ID: <20130704011301.GA16906@kernel.org>
References: <20130620201713.GV8211@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130620201713.GV8211@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 20, 2013 at 04:17:13PM -0400, Matthew Wilcox wrote:
> 
> A paper at FAST2012
> (http://static.usenix.org/events/fast12/tech/full_papers/Yang.pdf) pointed
> out the performance overhead of taking interrupts for low-latency block
> I/Os.  The solution the author investigated was to spin waiting for each
> I/O to complete.  This is inefficient as Linux submits many I/Os which
> are not latency-sensitive, and even when we do submit latency-sensitive
> I/Os (eg swap-in), we frequently submit several I/Os before waiting.
> 
> This RFC takes a different approach, only spinning when we would
> otherwise sleep.  To implement this, I add an 'io_poll' function pointer
> to backing_dev_info.  I include a sample implementation for the NVMe
> driver.  Next, I add an io_wait() function which will call io_poll()
> if it is set.  It falls back to calling io_schedule() if anything goes
> wrong with io_poll() or the task exceeds its timeslice.  Finally, all
> that is left is to judiciously replace calls to io_schedule() with
> calls to io_wait().  I think I've covered the main contenders with
> sleep_on_page(), sleep_on_buffer() and the DIO path.
> 
> I've measured the performance benefits of this with a Chatham NVMe
> prototype device and a simple
> # dd if=/dev/nvme0n1 of=/dev/null iflag=direct bs=512 count=1000000
> The latency of each I/O reduces by about 2.5us (from around 8.0us to
> around 5.5us).  This matches up quite well with the performance numbers
> shown in the FAST2012 paper (which used a similar device).

Hi Matthew,
I'm wondering where the 2.5us latency cut comes from. I did a simple test. In
my xeon 3.4G CPU, one cpu can do about 2M/s context switch of applications.
Assuming switching to idle is faster, so switching to idle and back should take
less than 1us. Does the 2.5us latency cut mostly come from deep idle state
latency? if so, maybe set a lower pm_qos value or have a better idle governer
to prevent cpu entering deep idle state can help too.

Thanks,
Shaohua
