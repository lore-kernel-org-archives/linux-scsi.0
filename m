From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI dynamic power management
Date: Mon, 19 Nov 2007 14:48:56 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711191446440.3129-100000@iolanthe.rowland.org>
References: <20071119191849.GF12494@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42416 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750820AbXKSTs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 14:48:57 -0500
In-Reply-To: <20071119191849.GF12494@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 19 Nov 2007, Matthew Wilcox wrote:

> On Mon, Nov 19, 2007 at 02:16:12PM -0500, Alan Stern wrote:
> > Regarding this thread's original question, the best idea I've come up
> > with so far is to store an extra flag in the scsi_device structure
> > indicating that a suspend or resume transition is underway.  When the
> > flag is set, commands with REQ_PREEMPT would be accepted.  If the
> > device is "suspended" and the flag is clear, then commands would be
> > delayed or killed in the prep function regardless of REQ_PREEMPT.  This 
> > scheme could potentially let unwanted commands go through, but I 
> > haven't been able to think of anything more suitable.
> 
> You could allow only START_STOP and TUR to go through?

That's a pretty good idea...

There will be other problems to sort out.  For example, if someone is 
using a SCSI cdrom drive to play an audio CD, it will appear to the 
system that the drive is idle because no commands will flow.  But that 
sort of thing can be handled later.

Alan Stern

