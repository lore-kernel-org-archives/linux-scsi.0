From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH NCR5380 updates
Date: Wed, 19 Nov 2003 22:24:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069280662.7498.13.camel@dhcp23.swansea.linux.org.uk>
References: <20031118102649.GA1442@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from crosslink-village-512-1.bc.nu ([81.2.110.254]:12445 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S264144AbTKSW2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 17:28:10 -0500
In-Reply-To: <20031118102649.GA1442@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Maw, 2003-11-18 at 10:26, Christoph Hellwig wrote:
>   - use schedule_delayed_work() instead of the global timer for the
>     coroutines

Definitely good

>   - use dev_id field in the isr instead of searching the global list
>     of hosts (g_NCR5380 had to be updated to pass in that one for
>     this change)

Makes sense

>   - use spinlocks even in the non-interrupt driven case, with SMP
>     and PREEMPT that's needed these days

Make sure they don't disable interrupts. If you take an IRQ disabling
spinlock you might as well go home because those code paths can take
ages to run). Without locking its actually best to ignore the IRQ on any
SMP box and poll because of the chip design. Think of the coroutine as a
thread running on the host CPU pretending to be most of the scsi
controller..

The locks are guarding the interrupt handler paths against the command
issue path (which is single threaded via run_main) so I strongly
disagree with your belief that it needs changing. The chip is also quite
happy to wait ages for the host machine to do something, its 'hi-tech'
technology from the era of 4Mhz processors being quick.

Your changes as proposed would make NCR5380 unusable.


