From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Mon, 10 Mar 2008 10:50:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803101044200.3700-100000@iolanthe.rowland.org>
References: <47D5462B.7080305@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58896 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751232AbYCJOuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 10:50:15 -0400
In-Reply-To: <47D5462B.7080305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Mar 2008, Boaz Harrosh wrote:

> > No need, the problem you're thinking of in sd has been fixed.  The
> > problem was that sd did not check the value of error_sector to make
> > sure it was within the range of sectors accessed by the command.  I'm
> > not sure if an equivalent fix has been applied to sr, however.
> 
> I certainly remember a very nice patch sent following the one to sd.
> That revamps the all sr error handling path, including above problem. 
> I'm not sure it was submitted upstream though.

I don't think it was.  The MEDIUM_ERROR case in sr_done() is still a 
mess.  That function doesn't even use the new sense-buffer accessor 
routines.  Something else to add to your TODO list?


> OK, I see what you are saying: In case of bad behaving device, that we do
> not know about. The residue can be an indication of an actual error that should
> not be ignored. Sound's reasonable. In my opinion only a ULD like sd/sr could
> really know such things for sure. (Given the knowledge of command submitted)
> So a fix should go there. Both your patch and Jame's, touch code that does not
> have enough information to be sure.

At the moment sd and sr are the only ULDs which support block access
FS commands, so it doesn't make much difference.

However I disagree that only a ULD could know for sure whether a 
positive residue in a FS command indicates an error.  IMO, a residue in 
any FS command should always be taken seriously.

Alan Stern

