From: Christoph Hellwig <hch@lst.de>
Subject: gdth pci ids
Date: Sun, 11 Sep 2005 17:00:18 +0200
Message-ID: <20050911150018.GA13784@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27798 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932418AbVIKPAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Sep 2005 11:00:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: linux-scsi@vger.kernel.org

GDTH still isn't converted to proper pci probing APIs, which means it's
not hot-pluggable and installers need to do more work than nessecary.

There are various PCI IDs listen in the driver, but also an odd loop:

for (device = PCI_DEVICE_ID_VORTEX_GDT6x17RP;
     device <= PCI_DEVICE_ID_VORTEX_GDTMAXRP; ++device)
	gdth_search_dev(pcistr, &cnt, PCI_VENDOR_ID_VORTEX, device);

PCI_DEVICE_ID_VORTEX_GDT6x17RP has a numeric value of 0x100 and
PCI_DEVICE_ID_VORTEX_GDTMAXRP has a numeric value of 0x2ff.  There's
PCI ID defines for various number in that space, but by far not all.
Would an ID table that just lists the IDs with symbolic names in gdth.h
find all adapters or do we need to add more of them?
