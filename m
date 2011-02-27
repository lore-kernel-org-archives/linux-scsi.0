From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_host_template.queuecommand() instances
Date: Sun, 27 Feb 2011 15:21:02 -0700
Message-ID: <20110227222102.GH13726@parisc-linux.org>
References: <304254.22314.qm@web161906.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51627 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1B0WVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2011 17:21:03 -0500
Content-Disposition: inline
In-Reply-To: <304254.22314.qm@web161906.mail.bf1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 27, 2011 at 11:22:06AM -0800, john smith wrote:
> I understand that inside LDD's scsi_host_template.queuecommand(), the card->spinlock can be used to protect shared data between concurrent instances of queuecommand and bottom-half/tasklets IO completion code.
> For SMP system with PCIE/MSIX enabled interrupts, there can be multiple instances of completion tasklets.
> The questions I have are:
>  
> - can there be multiple instances of queuecommand as well?

Yes, queuecommand can be called on multiple CPUs simultaneously.
That's only been true since 2.6.37, though.

> - if so, I would assume they are IO commands issued for different targets (controlled by LDD), correct?

Not correct, they could easily be for the same LUN.

> Also, if true, these multiple instances must be running on different kernel threads spwaned by the SCSI mid layer, or block layer?

Linux doesn't use threads like this ... what usually happens is a
user thread makes a syscall (eg write() or read()) or faults on an
mmaped region.  The thread switches into kernel mode, and winds its way
through the file system, into the page cache, then the block layer, down
to the scsi layer, and invokes queuecommand.  Once queuecommand finishes,
the thread returns to the page cache to wait for the I/O to complete.

> Links to detailed and uptodate Block layer description would be appreciated (the ones I found are either old and superficial),

It's a lot of effort to keep these things up to date, and generally those
making the changes don't have the interest in updating documentation.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
