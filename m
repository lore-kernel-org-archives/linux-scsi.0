From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Mon, 6 Jan 2014 10:38:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401061025410.1282-100000@iolanthe.rowland.org>
References: <52CAC067.20601@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CAC067.20601@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 6 Jan 2014, Phillip Susi wrote:

> The issue is that the REQ_PM flagged REQUEST SENSE command issued
> during the system_resume is never dispatched.  I patched scsi_execute
> to make the request type REQ_TYPE_PM_RESUME and that got the request
> dispatched.

Note that REQ_TYPE_PM_RESUME is a fossil.  It is used for power 
management in the legacy IDE driver and nowhere else (although there is 
a single vestige of that use remaining in the block layer).  It should 
be removed -- if anybody feels like cleaning up the IDE driver.

> Looking at the code a bit more today, it looks like REQ_PM has
> blk_peek_request return the request to scsi_request_fn, but it refuses
> to dispatch it unless it is of type REQ_TYPE_PM_RESUME apparently
> because the queue is stopped.  I suppose now the question is why is it
> stopped?

Indeed.  I can't see any place where the SCSI or block layers would
stop the queue of a device when it gets runtime suspended.  Maybe some
other layer is doing this.

Alan Stern

