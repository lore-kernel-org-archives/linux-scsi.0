From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 89511] USB-storage mount error
Date: Fri, 5 Jun 2015 10:54:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1506051036360.2043-100000@iolanthe.rowland.org>
References: <bug-89511-1728-xp33cMoHb4@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41535 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751578AbbFEOyP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2015 10:54:15 -0400
In-Reply-To: <bug-89511-1728-xp33cMoHb4@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

For those new to this bug report, the interesting part starts here:

	https://bugzilla.kernel.org/show_bug.cgi?id=89511#c19

In short, these are USB drive adapters that doesn't support the
SYNCHRONIZE CACHE command but claim to be write-back.  (In at least 
one case, it initially claims to be write-through but then changes to 
write-back following a reset, or something like that.)

On Thu, 4 Jun 2015 bugzilla-daemon@bugzilla.kernel.org wrote:

> --- Comment #50 from Markus Rathgeb <maggu2810@gmail.com> ---
> I ran in the same trouble with an old USB case for 2.5'' IDE hard discs.
> 
> The drive cache_type is set to "write back" if it plugged in.
> The drive is working using if I set the cache type to "temporary write
> through".
> 
> So, I think this is the exact same problem discussed here.
> 
> At the moment I tested the workaround using v3.18.2 (gentoo-sources).
> Without the workaround the problem also exists using the Kernel v4.0.4 (used
> gentoo-sources, but I think that should not be related to the problem at all).
> 
> Is there anything I / we can do, to solve this problem at all in the kernel
> space (e.g. if SYNCHRONIZE CACHE command is not working, fallback to write
> through)?

This is up to the SCSI developers.

The real question is what should happen when a drive really does have a
write cache but doesn't recognize the SYNCHRONIZE CACHE command.  I
don't know what the kernel can do in this case -- maybe just log a
one-time error message and turn off sdkp->WCE?

Alan Stern

