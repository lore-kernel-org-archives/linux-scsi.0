From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fusion problems with 2.6.5rc1 on AMD x86-64 IV
Date: 17 Mar 2004 11:34:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079541289.2135.2.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB1E2@exa-atlanta.se.lsil.com>
	<20040317165355.37c846f0.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:15493
	"EHLO redscar") by vger.kernel.org with ESMTP id S261872AbUCQQey
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 11:34:54 -0500
In-Reply-To: <20040317165355.37c846f0.ak@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> The problem seems to be the broke consistent dma mask.
> 
> I currently just mask it with 0xffffffff in pci_alloc_consistent
> and why that workaround it works.

Well, I don't understand this.

The place it's setup is in pci/probe.c:

--- 1.60/drivers/pci/probe.c    Wed Feb 18 17:41:09 2004
+++ 1.61/drivers/pci/probe.c    Sun Mar 14 14:17:06 2004
@@ -570,7 +570,6 @@
        /* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
           set this higher, assuming the system even supports it.  */
        dev->dma_mask = 0xffffffff;
-       dev->consistent_dma_mask = 0xffffffff;
        if (pci_setup_device(dev) < 0) {
                kfree(dev);
                return NULL;
@@ -582,6 +581,7 @@
        pci_name_device(dev);
 
        dev->dev.dma_mask = &dev->dma_mask;
+       dev->dev.coherent_dma_mask = 0xffffffffull;
 
        return dev;

The only reason I can see having a screw up is if some untoward
manipulation is going on in pci_setup_device().  This shouldn't be
because the pci->dev isn't initialised until after that (which is why
the coherent_dma_mask initialisation had to be moved further back).

You can verify this by moving the device_initialize() and the
coherent_dma_mask assignment above pci_setup_device.

James


