From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Tue, 30 Dec 2014 11:45:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1412301132130.32416-100000@netrider.rowland.org>
References: <1419956728.2164.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1419956728.2164.3.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Kenneth R. Crudup" <kenny@panix.com>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 30 Dec 2014, James Bottomley wrote:

> > All right.  How does this patch look?
> 
> OK, I suppose.  The transfer limits are a little on the low side, but
> for usb-storage (i.e. non-UAS) performance devices, they should be OK.

If you're referring to the 32-KB and 64-KB limits, we know from 
experience that some devices really do need them.  If you're referring 
to the 32-MB limit...  Well, that's what this whole thread is about, 
right?

That limit could be restricted to apply only when a device is not 
connected over a SuperSpeed USB-3 link.  But knowing the low quality of 
commodity USB hardware, I suspect it wouldn't work well.

> For TYPE_TAPE, you still have no guarantee that the bridge won't screw
> up ... and if the argument is that tapes are always connected to
> sensible bridges, why aren't SATA devices?

True, we have no guarantee.  But tape drives do have special 
requirements because of the way they write blocks and gaps; this code 
was added by someone with a tape drive who did need the large limit.

I guess there are a lot more bridges in the low-budget consumer world 
targeted to disk drives than to tape drives.  That could explain a lot.

> There's also a spelling mistake below.

I'll fix it in the final patch submission.  Thanks.

Alan Stern

PS: What's the current situation of my "SCSI: fix regression in 
scsi_send_eh_cmnd()" patch:

	http://marc.info/?l=linux-scsi&m=141658469207765&w=2

submitted on November 21?  Since it was a bug-fix, I rather expected it 
to get merged before 3.18 was released.  Since it didn't, I certainly 
hope it will get in before 3.19.

