From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Fri, 9 Jun 2006 06:08:53 -0600
Message-ID: <20060609120853.GL1651@parisc-linux.org>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:29662 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S965243AbWFIMIy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 08:08:54 -0400
Content-Disposition: inline
In-Reply-To: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sander van Beek - Elexis <sander@elexis.nl>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 09, 2006 at 01:20:57PM +0200, Sander van Beek - Elexis wrote:
> I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit 
> fibre channel hba's for a pci-x bus. The qlogic site says this type 
> is a HP OEM card and it is not sold directly by qlogic.
> I tried to get them working on a slackware 10.2 system with the 
> latest stable 2.6 kernel. However, the qla2xxx driver does not see 
> the card. My dmesg only shows this line:
> 
> Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver
> 
> This is how the card shows up in my /proc/pci:
> 
>   Bus  2, device   1, function  1:
>     Class 0c04: PCI device 1077:8000 (rev 1).
>       IRQ 255.
>       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].
> 
> Can anyone supply me with some hints what could be wrong, or what I 
> should do to get them working?

I'd try adding the PCI IDs to the driver and see what happened next.
Something like:

+++ drivers/scsi/qla2xxx/ql2300.c       9 Jun 2006 12:08:21 -0000
@@ -64,6 +64,13 @@ static struct pci_device_id qla2300_pci_
        },
        {
                .vendor         = PCI_VENDOR_ID_QLOGIC,
+               .device         = 0x8000,
+               .subvendor      = PCI_ANY_ID,
+               .subdevice      = PCI_ANY_ID,
+               .driver_data    = (unsigned long)&qla_board_tbl[1],
+       },
+       {
+               .vendor         = PCI_VENDOR_ID_QLOGIC,
                .device         = PCI_DEVICE_ID_QLOGIC_ISP6312,
                .subvendor      = PCI_ANY_ID,
                .subdevice      = PCI_ANY_ID,

