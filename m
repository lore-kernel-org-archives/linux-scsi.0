From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 04:52:03 +0000
Message-ID: <20050104045203.GA26051@parcelfarce.linux.theplanet.co.uk>
References: <1104788704.5506.67.camel@mulgrave> <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk> <1104792580.5506.69.camel@mulgrave> <20050103225401.GZ26051@parcelfarce.linux.theplanet.co.uk> <1104796418.5506.81.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30339 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262041AbVADEwE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 23:52:04 -0500
Content-Disposition: inline
In-Reply-To: <1104796418.5506.81.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 03, 2005 at 05:53:38PM -0600, James Bottomley wrote:
> On Mon, 2005-01-03 at 22:54 +0000, Al Viro wrote:
> > ... and dma_handle *is* dma_addr_t and gets used in exact same driver to
> > store the results of the same function (grep for pci_map_page in there).
> 
> Fine.  But I usually observe the rule of tamper minimally ... drivers
> have a nasty habit of sticking to you if you do more than that.
> 
> Indeed, now I look at the cleaned up patch, the think will leak DMA
> mappings if sense_paddr is zero (which is quite possible, since zero is
> a valid bus physical address).  However, I'm declaring this too minimal
> to bother with ... unless you want to fix it?

After looking at the source some more...  NAK.  Turns out that there was
a reason to avoid reuse of ->dma_handle here.  What happens is that we might
map *two* things in gdth_fill_raw_command() - scp->sense_data and
possibly scp->request_buffer.  So yes, there is a reason for not reusing
->dma_handle - it's used for the latter.

So ->dma_handle is not a solution.  However, "shove it into ->Buffer
and ->host_scribble" is not a solution either, AFAICS.
	a) the problem you've found with code that unmaps stuff.  Probably
should be handled by looking at ->SCp.Status instead of ->SCp.Buffer and
setting a bit in .Status in the same place where we are currently setting
.Buffer.
	b) AFAICS, driver blindly assumes that pci_map_page() and friends
never fail.  Probably should be checked in gdth_fill_..._cmd() so we could
bail out before we feed fsck knows what to the hardware...
	c) this "shove dma_address_t into two pointers" is, indeed, fscking
ugly and brittle (note e.g. the bug with checking lower 32 bits first and
then adding upper 32 from ->host_scribble only if they were not all 0).
What do other drivers do when they want more than one mapping?

Comments?
