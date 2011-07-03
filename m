From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sun, 3 Jul 2011 12:06:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107031201200.28411-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1107031121440.28411-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1107031121440.28411-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 3 Jul 2011, Alan Stern wrote:

> > Your explanation completely contradicts what James wrote earlier.
> 
> Yes, it does.  I'm claiming that James was on a wrong track or looking
> in the wrong direction.

To amplify: James wrote:

> Right, that wouldn't work.  The sdev in question comes from
> request_queue->queuedata.  That only goes to null when the last
> reference to the sdev has been released.  So the root cause is something
> in sd holding a reference to sdev without actually getting an additional
> refcount.

The third sentence is clearly wrong, because queuedata is set to NULL
when sdev is removed from visibility, not when the last reference to it
has been released, i.e., in __scsi_remove_device() rather than
scsi_device_dev_release_usercontext().

Maybe this means the assignment to queuedata should be moved.  I don't 
know; unlike James, I'm not an expert on the details of the SCSI stack.

Alan Stern
