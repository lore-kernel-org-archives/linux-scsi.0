From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 7 Jan 2014 10:56:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401071054250.1296-100000@iolanthe.rowland.org>
References: <52CC1FF2.1020301@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55020 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751640AbaAGP4p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 10:56:45 -0500
In-Reply-To: <52CC1FF2.1020301@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 7 Jan 2014, Phillip Susi wrote:

> On 1/7/2014 10:20 AM, Alan Stern wrote:
> > This raises two questions:
> > 
> > Should the host's resume be allowed to complete while the host is
> > still in error recovery?  Wouldn't it be better to wait until the
> > recovery is finished?
> 
> Ahh, right, my other patch changed the ata_port stuff to schedule the
> eh, and return  from resume, so that IT doesn't block the system
> resume path for a long period of time while IT tries to spin up the
> disk.  Both the libata and sd layers were spinning up the disk.
> 
> Still, the sd request should just wait in the queue until after the
> recovery completes shouldn't it?

Yes.

> > How does the queue end up in a stopped state?  (The stopped queue
> > explains why blk_peek_request returns NULL.)
> 
> I was guessing that was the cause from reading the code, after
> stepping through it with gdb and qemu, it turned out it was in
> SHOST_RECOVERY rather that stopped.  I suppose it may be stopped as
> well, so I guess I'll have to go do another debug session and make
> sure, but I think that was a red herring.
> 
> The flow seems to simply be:
> 
> host is in recovery
> sd_resume queues REQUEST SENSE
> scsi_request_fn notices host is in recovery and requeus REQUEST SENSE
> recovery completes
> REQUEST SENSE seems to be lost...

If the earlier patch did fix the problem, then the REQUEST SENSE req
was in the queue but wasn't being returned by blk_peek_request because
the queue was stopped.

Alan Stern

