From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in sd.c
Date: Thu, 19 Feb 2004 10:00:01 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402190957210.629-100000@ida.rowland.org>
References: <20040204171401.GA1687@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4868 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267305AbUBSPAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 10:00:03 -0500
In-Reply-To: <20040204171401.GA1687@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 4 Feb 2004, Mike Anderson wrote:

> Just a quick look. We are racing scsi_disk_release with sd_open. The
> return code check in scsi_disk_get from the call to kobject_get is
> worthless. The kobject_get will take do a inc even if we may already be
> in release. This will cause a oops as we will fail the scsi_device_get
> call in scsi_disk_get which will cause a call to kobject_put on a struct
> that will most likely be free'd. 
> 
> Maybe I am still reading the block layer locking wrong, but I do not see a
> method to close the race with blkdev_open. I will look at this some more
> and see if I can get a clue what I am missing.

Did you ever find anything in the block layer to prevent the race between 
open and release?

If there's nothing there, does this mean that protection needs to be added 
to the sd and sr drivers?  What about sg, which doesn't use the blocking 
layer?  This race is generic; every device driver needs to deal with it 
somehow.

Alan Stern

