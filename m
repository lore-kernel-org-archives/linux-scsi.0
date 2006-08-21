From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 11:35:46 -0600
Message-ID: <20060821173546.GA24068@parisc-linux.org>
References: <20060821161417.GB4340@parisc-linux.org> <Pine.LNX.4.44L0.0608211248490.8319-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:8085 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1422732AbWHURfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 13:35:47 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0608211248490.8319-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 21, 2006 at 12:52:18PM -0400, Alan Stern wrote:
> On Mon, 21 Aug 2006, Matthew Wilcox wrote:
> 
> > On Mon, Aug 21, 2006 at 12:03:21PM -0400, Alan Stern wrote:
> > > This patch (as766) sanitizes the Vendor, Product, and Revision strings
> > > contained in an INQUIRY result, by setting all non-graphic or
> > > non-ASCII characters to ' '.  Since the standard disallows such
> > > characters, this will affect only non-compliant devices.
> > 
> > I thiink you attached the wrong patch; it doesn't match the description
> > at all.
> 
> No; it does match the description.  But you have to read it carefully, 
> because the majority of the patch implements optimizations made possible 
> by the small piece that does the actual sanitizing.

The description should have said that.  I don't know what you're trying
to accomplish with pulling the length byte out of the inquiry data, for
example.

In any case, you didn't address my point that a NUL byte is probably
meant to terminate the string, not merely be treated equivalently to
a space.  Of course, we can do anything here, the device is out of spec,
but in terms of trying to ascertain the intention of the drug-crazed
hobo^W^W^W^W engineer who wrote the firmware, I think your interpretation
is less likely.
