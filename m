From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC 0/16] gdth combined patchset & call for testers
Date: Sun, 30 Sep 2007 17:07:53 -0400
Message-ID: <47001029.80709@garzik.org>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47631 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXI3VIB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 17:08:01 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> [11/16] gdth: switch to modern scsi host registration - Christoph
>   Christoph what is missing from here is the remove of the deprecated 
>   pci_find_device() call. Can I Just use pci_get_device() of the same signature
>   or do I need to call some other pci_ members after that?


The driver needs to be converted to the "new" hotplug APIs.

The main pre-reqs are accomplished by your patches: the driver is using 
the modern scsi hotplug API, and uses pointers for the adapter struct 
rather than indices.

The final pre-req -- if your patches do not do this already -- is to 
completely eliminate any global driver arrays, and make sure all 
structures are allocated on a per-HBA basis.

Once this is done, conversion to ISA/EISA/PCI hotplug API is pretty 
straightforward.  Each of those three bus APIs are the same: 
per-instance probe and remove functions, and (for PCI and sometimes 
EISA) an id table.  This is the reason why the ISA/EISA/PCI codes were 
split out into separate functions, to prepare for this conversion.

	Jeff


