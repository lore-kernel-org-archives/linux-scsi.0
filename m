From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] fix sd open/remove race
Date: Fri, 9 Apr 2004 11:55:47 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404091141180.1000-100000@ida.rowland.org>
References: <1081524905.2203.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10244 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261421AbUDIPzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 11:55:47 -0400
In-Reply-To: <1081524905.2203.52.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 9 Apr 2004, James Bottomley wrote:

> On Fri, 2004-04-09 at 10:24, Alan Stern wrote:
> > You're right.  However, you still want calls to sd_open to start failing
> > as soon as the disconnection notice is received.  Since the
> > disk-unavailable state can't be indicated by clearing disk->private_data,
> > it has to be indicated in some other way.  How to do it is up to you, but
> > whatever way you choose, the indicator should be cleared in sd_remove (and
> > that change must be synchronized by acquiring the new semaphore).
> 
> That's what the original bug2400 thread was all about.  I think opening
> with an already degraded device (one that will EIO to everything) is
> just as good as refusing the open.  That's why the only race is the
> reference race.  It's better to refuse the open, but the effects of
> either are the same.

Okay, yes, that will work either way.

> > Ah, yes.  However there's no reason to hold the semaphore _every_ time you 
> > do a scsi_disk_put.  And once you use something else as an indicator, 
> > there won't be any need to clear disk->private_data.
> 
> Actually, there is a (very obscure) three thread SMP race that this
> prevents.  Thread 1 -> sd_remove; Thread 2 -> sd_close (for last close)
> and Thread 3 -> sd_open
> 
> Thread 2 might end up doing the last put and if it were not protected it
> would still race with sd_open.

Hmm.  That wouldn't matter if you cleared the indicator in sd_remove.  
Then the race would only be sd_remove against sd_open.  Also, you do have
to admit, your way of doing it is more obscure.  You should at least add
comments explaining this 3-way race and the fact that the semaphore is
already acquired during scsi_disk_release.

Alan Stern

