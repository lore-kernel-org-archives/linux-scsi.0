From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Fri, 5 Dec 2003 14:27:45 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312051421160.645-100000@ida.rowland.org>
References: <1070649445.12411.347.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264301AbTLET1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 14:27:45 -0500
In-Reply-To: <1070649445.12411.347.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 5 Dec 2003, Pat LaVarre wrote:

> > Anyway, the page x08 data indicates WCE off.  So maybe Windows was just 
> > trying to turn it on
> 
> Apparently yes.  Cool, thanks for sharing.  I'm now guessing this occurs
> only when rmb is clear.
> 
> If so, then we can say msft turns write-behind etc. on when the drive is
> hot-pluggable, but turns write-behind etc. off when the disk is fully
> hot-pluggable or even only hot-pluggable while not prevented.  Not good
> policy, though too late now I suppose.

Be careful with your nomenclature.  Hot-pluggable and removable-media are 
two different things.

> That reality will encourage device folk to virtually unplug the drive
> when the disk ejects ... else disconnect mode page x08 from reality.
> 
> > There was a prior x1a = MODE-SENSE(6) for page x08.  Here is the returned 
> > data:
> > 
> > 	12 00 00 00 00 00 00 00 08 0a 00 00 00 00 00 00
> > 	00 00 00 00
> > 
> > I read this as: mode data length = 18 (inconsistent with the amount of
> > returned data, which is 19 bytes not counting the mode data length byte
> > itself),
> 
> Help I'm lost.
> 
> Did we get these plain hex bytes via Windows, rather than from a bus
> trace?  They internally contradict themselves.
> 
> Have we unwittingly involved the slightly broken Win mode sense 6/10
> translator?  This plain hex could be the result from a compliant device
> if what actually crossed the bus was an op x5A mode sense 10, and then
> Win gave us the data in unedited, even after Win had helpfully edited
> the cdb we asked to send.

The trace came from USB Snoopy.  I don't know enough about the internals 
of Windows to say whether the data have been mangled or not.

> > these plain hex bytes ... internally contradict themselves.
> 
> Digital numbers have value and length, not just value.
> 
> Yes x 08 0a 00 00 00 00 00 00 00 00 00 00 appears to be an x0C (12) byte
> mode page.
> 
> But x 12 00 00 00 00 00 00 00 appears to be an eight byte header for op
> x5A mode sense 10, which by ANSI T10 SPC definition contains the
> additional length x 12 00, which at offset zero fits a total available
> length of x14 (20), which is the number of data bytes you quote.
> 
> But we say we traced op x1A mode sense 6, not op x5A mode sense 10.
> 
> Help?

Don't ask me, I don't know.

Alan Stern


