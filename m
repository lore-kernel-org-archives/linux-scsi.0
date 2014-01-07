From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 7 Jan 2014 10:20:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401071015120.1296-100000@iolanthe.rowland.org>
References: <52CB6A22.2000203@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CB6A22.2000203@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 6 Jan 2014, Phillip Susi wrote:

> On 01/06/2014 10:38 AM, Alan Stern wrote:
> > Indeed.  I can't see any place where the SCSI or block layers
> > would stop the queue of a device when it gets runtime suspended.
> > Maybe some other layer is doing this.
> 
> So I've stepped through it in qemu a good bit, and found some strange
> things.  At the time that sd_resume_system is called, the host is
> still in the recovery state as a result of ata_port_resume, so this is
> why scsi_request_fn doesn't dispatch the request.  It requeues it for
> after the eh finishes, but when the eh finishes and sets the state
> back to running, scsi_request_fn calls blk_peek_request, and it
> returns NULL rather than the requeued REQUEST SENSE.  It's like the
> request is lost rather than having been requeued.

This raises two questions:

	Should the host's resume be allowed to complete while the
	host is still in error recovery?  Wouldn't it be better to
	wait until the recovery is finished?

	How does the queue end up in a stopped state?  (The stopped
	queue explains why blk_peek_request returns NULL.)

You're in a better position than I am to answer these questions.

Alan Stern

