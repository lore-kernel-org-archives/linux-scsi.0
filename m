From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 13/16] gdth: Make one abuse of scsi_cmnd less obvious
Date: Mon, 01 Oct 2007 10:23:37 -0400
Message-ID: <470102E9.7030304@garzik.org>
References: <46FFFC8C.6080804@panasas.com> <47000367.6090402@panasas.com> <20070930212813.GD13343@infradead.org> <20070930232135.GF12049@parisc-linux.org> <4700FC8D.1050209@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39616 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXJAOYl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2007 10:24:41 -0400
In-Reply-To: <4700FC8D.1050209@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> - Christoph or Jeff will work on the finish up of the BUS hotplug API.
>   I have looked at code examples elsewhere in the kernel, and Jeff's
>   master plan sounds very good. But I would hope not to do it myself 
>   as it will take me much longer.
>   Jeff it sounds like you have it clearer in your head?


TBH I won't have time to look at it, though I will be quite happy to 
answer as many questions as you can come up with :)

In the on-going effort to kill deprecated pci_find_device (of which this 
gdth effort is part of), I converted several ISDN drivers to use the new 
ISA, PNP, and PCI APIs:

      Branch 'isdn-pci' of
      git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

You can look at those patches for examples.

Really, you should pat yourself on the back, you have already done 96% 
of the gdth work required to get us there.  :)

Once you understand the key concepts of the new hotplug-style APIs, the 
code changes themselves are easy.  They are...

* reference HBA information via per-instance pointers stored in 
scsi_host->hostdata.  Global variables relating to per-HBA information 
are to be avoided.

* in the API's ->probe() hook,
	* detect a single card/device
	* allocate and init a single scsi_host and gdth_ha_str

* destroy a single gdth_ha_str in the API's ->remove() hook
	* shut down a single card/device
	* destroy one scsi_host and gdth_ha_str

In practice, this tends to mean converting code like

	while ((pdev = pci_find_device(...)) != NULL) {
		alloc, init one PCI device
	}

to

	static int gdth_init_one (struct pci_dev *pdev,
				const struct pci_device_id *ent) {
		alloc, init one PCI devoce
	}

because, as you can see, the loop has been moved to generic code.  Also, 
it should be self-evident that this new API allows devices to be 
attached (hotplugged) long after the module initialization completes, 
and other gdth devices are running.

	Jeff



