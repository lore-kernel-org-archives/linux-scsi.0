From: Andrew Morton <akpm@osdl.org>
Subject: i450nx-scanning-fix.patch
Date: Mon, 29 Dec 2003 03:02:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229030235.315d5502.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:55974 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262747AbTL2LCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 06:02:32 -0500
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org


I have had this in -mm for some time.  It works on my 450nx-based 4-way. 
Was planning on merging it.  Speak now or forever hold your pieces.



From: Matthew Wilcox <willy@debian.org>

[moved from linux-scsi to linux-pci since this really isn't scsi-related]

On Sun, Nov 09, 2003 at 11:51:36AM -0500, Doug Ledford wrote:
> I can tell you what's going on here.  This is a 450NX based
> motherboard.  The 450NX chipset from Intel was the first chipset to have
> peer PCI busses.  For backwards compatibility, some machine makers
> hacked their PCI BIOS to have a fake bridge device on PCI bus 0 that
> points to the same bus number as the peer bus.  This way if the OS
> didn't know about the peer bus registers it would still find the devices
> by scanning behind the bridge.

Ah, thanks Doug.  That saved me a few hours of debugging and
head-scratching ;-)

> In this case we are scanning behind this
> fake bridge and then also scanning based upon the peer bus registers in
> the chipset, and as a result we are finding the device twice.  In order
> to fix this problem you need to change the peer bus quirk code for the
> 450NX chipset to scan the list of bus 0 devices looking for a bridge
> that has the same config as the peer bus registers and if so delete the
> bridge from the list.  That will avoid double scanning and will avoid
> having the PCI code try and configure sub busses via a fake bridge when
> it should do all configurations via the 450NX peer bus registers.

I agree.  I considered some other possibilities like having
pci_scan_bridge() check for duplicate busses and return if it detects
them, but that would leave some pcipci bridges in the list that really
don't exist.

Here's a patch that compiles ... comments?




 arch/i386/pci/fixup.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff -puN arch/i386/pci/fixup.c~i450nx-scanning-fix arch/i386/pci/fixup.c
--- 25/arch/i386/pci/fixup.c~i450nx-scanning-fix	2003-11-09 16:58:55.000000000 -0800
+++ 25-akpm/arch/i386/pci/fixup.c	2003-11-09 16:58:55.000000000 -0800
@@ -6,27 +6,52 @@
 #include <linux/init.h>
 #include "pci.h"
 
+static void __devinit i450nx_scan_bus(struct pci_bus *parent, u8 busnr)
+{
+	struct list_head *tmp;
+
+	pci_scan_bus(busnr, &pci_root_ops, NULL);
+
+	list_for_each(tmp, &parent->children) {
+		u8 childnr;
+		struct pci_dev *dev = pci_dev_b(tmp);
+
+		if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
+			continue;
+		pci_read_config_byte(dev, PCI_PRIMARY_BUS, &childnr);
+		if (childnr != busnr)
+			continue;
+
+		printk(KERN_WARNING "PCI: Removing fake PCI bridge %s\n",
+				pci_name(dev));
+		pci_remove_bus_device(dev);
+		break;
+	}
+}
 
 static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 {
 	/*
 	 * i450NX -- Find and scan all secondary buses on all PXB's.
+	 * Some manufacturers added fake PCI-PCI bridges that also point
+	 * to the peer busses.  Look for them and delete them.
 	 */
 	int pxb, reg;
 	u8 busno, suba, subb;
 
-	printk(KERN_WARNING "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
+	printk(KERN_NOTICE "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
 	reg = 0xd0;
-	for(pxb=0; pxb<2; pxb++) {
+	for (pxb = 0; pxb < 2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(busno, &pci_root_ops, NULL);	/* Bus A */
+			i450nx_scan_bus(d->bus, busno);		/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(suba+1, &pci_root_ops, NULL);	/* Bus B */
+			i450nx_scan_bus(d->bus, suba+1);	/* Bus B */
 	}
+
 	pcibios_last_bus = -1;
 }
 

_

