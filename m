From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] fix sd open/remove race
Date: Fri, 9 Apr 2004 11:24:35 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404091116020.1000-100000@ida.rowland.org>
References: <1081520891.2202.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6404 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261396AbUDIPYf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 11:24:35 -0400
In-Reply-To: <1081520891.2202.44.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 9 Apr 2004, James Bottomley wrote:

> Heh, the additional semicolon I'll remove.

I'm glad somethings in life aren't controversial! :-)

> However, the rest of your patch is wrong.
> 
> The reason is that what you're trying to synchronise is the naming
> lookup (the gendisk open).  You have to allow currently open devices to
> continue to operate.  NULL'ing out the disk->private_data before
> del_gendisk would mean it was null for sd_release, so every attempt to
> close the device after removal would oops.  That's why the NULL must be
> done in the reference release routine, not in the disconnection
> indication routine.  The race you're trying to prevent is the 0->1
> reference after disconnection.

You're right.  However, you still want calls to sd_open to start failing
as soon as the disconnection notice is received.  Since the
disk-unavailable state can't be indicated by clearing disk->private_data,
it has to be indicated in some other way.  How to do it is up to you, but
whatever way you choose, the indicator should be cleared in sd_remove (and
that change must be synchronized by acquiring the new semaphore).

> The original patch, By the way, did hold the sd_ref_sem around the NULL
> of disk->private_data because the scsi_disk_release is triggered from
> kobject_put on last put (and thus is under the semaphore).

Ah, yes.  However there's no reason to hold the semaphore _every_ time you 
do a scsi_disk_put.  And once you use something else as an indicator, 
there won't be any need to clear disk->private_data.

Alan Stern

