From: Juerg Billeter <juerg@paldo.org>
Subject: Re: [PATCH] Hotplug support for BusLogic scsi controller
Date: Fri, 08 Apr 2005 19:36:58 +0200
Message-ID: <1112981819.8880.43.camel@juerg-p4.bitron.ch>
References: <1112977377.8880.24.camel@juerg-p4.bitron.ch>
	 <20050408164658.GB8669@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from paldo.org ([213.202.245.43]:30111 "EHLO buildd1.paldo.org")
	by vger.kernel.org with ESMTP id S262892AbVDHRhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2005 13:37:05 -0400
In-Reply-To: <20050408164658.GB8669@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: lnz@dandelion.com, linux-scsi@vger.kernel.org

On Fre, 2005-04-08 at 17:46 +0100, Matthew Wilcox wrote:
> On Fri, Apr 08, 2005 at 06:22:57PM +0200, Juerg Billeter wrote:
> > This patch adds hotplug support to the driver for BusLogic scsi
> > controllers. It's required to boot from a BusLogic controller when using
> > modular kernels with hotplug-based initramfs.
> 
> It's a start, I suppose.  It's not really hotplug support though; for that
> you'd need to implement the whole pci_driver infrastructure.  It'd be
> worth someone doing (and the BusLogic cards are currently unmaintained,
> I believe), so if you want to do that, we'd be only too happy to review
> your patches.

Sorry, but I'm not really into kernel hacking - as you may have guessed,
so I'd probably need too much time to convert the BusLogic driver to a
new-style driver. But as my small patch at least makes the coldplug-part
of hotplug work, I thought it'd make sense to merge it upstream as it
may help other users. Maybe I'll learn to write drivers someday...

BTW: If the BusLogic driver is unmaintained, the MAINTAINERS file should
probably be updated.

> 
> BTW, you may want to use the PCI_DEVICE() macro to make the lines shorter.
> 

Done, updated patch follows.

--
Signed-off-by: Juerg Billeter <juerg@paldo.org>

diff -puNr linux-2.6.11.orig/drivers/scsi/BusLogic.c linux-2.6.11/drivers/scsi/BusLogic.c
--- linux-2.6.11.orig/drivers/scsi/BusLogic.c	2005-03-02 08:38:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/BusLogic.c	2005-04-08 19:03:02.514619743 +0200
@@ -79,6 +79,15 @@ static int BusLogic_DriverOptionsCount;
 static struct BusLogic_DriverOptions BusLogic_DriverOptions[BusLogic_MaxHostAdapters];
 
 
+static struct pci_device_id buslogic_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT) },
+	{ }			/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, buslogic_pci_tbl);
+
+
 /*
   BusLogic can be assigned a string by insmod.
 */


