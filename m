From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC 0/16] gdth combined patchset & call for testers
Date: Sun, 30 Sep 2007 18:53:00 -0400
Message-ID: <470028CC.1010507@garzik.org>
References: <46FFFC8C.6080804@panasas.com> <47001029.80709@garzik.org> <20070930213618.GF13343@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35281 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbXI3Wx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 18:53:29 -0400
In-Reply-To: <20070930213618.GF13343@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> The big problem with the pci_driver conversion is that lack of device
> ids in the driver.  A few years ago I sent Achim a mail to ask if there's
> a definitive list of used PCI ids, but didn't get an answer - maybe
> the mail bounced.  If we can't get this list we'd have to add something
> like 500 PCI ids from the ranges currently probed, which seems rather
> odd.  gdth.h has various PCI_DEVICE_ID_ defines, maybe those are the
> supported ones?

Well, gdth.c is the only user of PCI_VENDOR_ID_VORTEX (ditto for vendor 
id 0x1119).  Thus, gdth_search_pci() has all the info you need.

Put all the specific entries first in the PCI table.  Then for the loop 
entries, use (PCI_VENDOR_ID_VORTEX,PCI_ANY_ID) for the final entry and 
disambiguate in the code itself.

If/when we get more specific information, it is then trivial to plug in.

Until such time, we are no worse off than we are now.

	Jeff


