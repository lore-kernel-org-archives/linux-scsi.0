From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Mon, 5 Jan 2015 15:07:56 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501051452440.1101-100000@iolanthe.rowland.org>
References: <20150105171940.GC30028@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48089 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754173AbbAEUH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 15:07:57 -0500
In-Reply-To: <20150105171940.GC30028@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Kenneth R. Crudup" <kenny@panix.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, 5 Jan 2015, Christoph Hellwig wrote:

> On Tue, Dec 30, 2014 at 08:36:34AM -0800, Kenneth R. Crudup wrote:
> > OP here. FWIW, this is what I get when running that command on the SCSI
> > generic device that corresponds to the USB-3 (non-UAS) disk[1] that had the
> > issue:
> 
> So it looks like this one actually provides sane values, but we don't
> we never even look at EVPD pages for usb devices due to the wrong SCSI
> level?

According to James Bottomley, it doesn't matter much what the EVPD
pages say.  The limitation is imposed by the USB _bridge_, whereas the
EVPD data indicates what the _drive_ is capable of.  So we can't rely
on that data anyway.  (Although if the EVPD data indicates a limit 
smaller than the bridge can handle, then we'd need to pay attention to 
it.)

The patch I posted sets a general limit of 32 MB for USB drives that 
don't have a quirk flag for a smaller limit.

Kenneth, have you tried that patch?  Does it fix your problem?

Alan Stern

