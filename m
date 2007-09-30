From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 0/16] gdth combined patchset & call for testers
Date: Sun, 30 Sep 2007 22:36:18 +0100
Message-ID: <20070930213618.GF13343@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <47001029.80709@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXI3Vg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 17:36:27 -0400
Content-Disposition: inline
In-Reply-To: <47001029.80709@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30, 2007 at 05:07:53PM -0400, Jeff Garzik wrote:
> The driver needs to be converted to the "new" hotplug APIs.
> 
> The main pre-reqs are accomplished by your patches: the driver is using 
> the modern scsi hotplug API, and uses pointers for the adapter struct 
> rather than indices.
> 
> The final pre-req -- if your patches do not do this already -- is to 
> completely eliminate any global driver arrays, and make sure all 
> structures are allocated on a per-HBA basis.
> 
> Once this is done, conversion to ISA/EISA/PCI hotplug API is pretty 
> straightforward.  Each of those three bus APIs are the same: 
> per-instance probe and remove functions, and (for PCI and sometimes 
> EISA) an id table.  This is the reason why the ISA/EISA/PCI codes were 
> split out into separate functions, to prepare for this conversion.

I think we're nicely prepared for that conversion, we'll only need to
add proper locking for the list of instance.

The big problem with the pci_driver conversion is that lack of device
ids in the driver.  A few years ago I sent Achim a mail to ask if there's
a definitive list of used PCI ids, but didn't get an answer - maybe
the mail bounced.  If we can't get this list we'd have to add something
like 500 PCI ids from the ranges currently probed, which seems rather
odd.  gdth.h has various PCI_DEVICE_ID_ defines, maybe those are the
supported ones?

For eisa we'll probably have the same issue.
