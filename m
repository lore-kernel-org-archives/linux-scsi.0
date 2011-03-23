From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 12:12:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1103231146460.2211-100000@iolanthe.rowland.org>
References: <1300893408.15899.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48071 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933157Ab1CWQMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 12:12:39 -0400
In-Reply-To: <1300893408.15899.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: ltuikov@yahoo.com, Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 23 Mar 2011, James Bottomley wrote:

> > > Without this fix, some USB mass-storage devices crash when
> > > they
> > > receive a MODE SENSE command with page code 0x3F asking for
> > > only 4
> > > bytes of data.
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > > Reported-and-tested-by: Richard Senior <richard@r-senior.demon.co.uk>
> > > CC: Luben Tuikov <ltuikov@yahoo.com>
> > > CC: <stable@kernel.org>
> > 
> > Acked-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> I put the original patch in on the understanding from both of you that
> the chances of finding a USB device which crashed with the change was
> very small.

I should have checked the patch against the context of the existing 
code more carefully.  :-(

> Given that several have been found and we're on the eve of the merge
> window closure, I'll just revert the original, and you two can work on
> getting a bullet proof version for the next merge window.

Reverting the original patch for now is fine with me.  As for the next
merge window, let me submit a more bullet-proof version of the second
patch.

It's possible that some wierd USB device will report that more than 192
bytes of mode-sense data is available and then fail when the host asks
for the reported amount.  You'd think no device could be that stupid,
but I have seen an example of a device doing exactly this (except that
it was for INQUIRY data rather than MODE SENSE data -- which is perhaps
even worse!).

Alan Stern

