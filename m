From: Sander van Beek - Elexis <sander@elexis.nl>
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Wed, 14 Jun 2006 09:50:57 +0200
Message-ID: <7.0.1.0.0.20060614095006.041f7cf0@elexis.nl>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
 <20060609120853.GL1651@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from psmtp04.wxs.nl ([195.121.247.13]:61369 "EHLO psmtp04.wxs.nl")
	by vger.kernel.org with ESMTP id S1751108AbWFNHtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 03:49:03 -0400
Received: from ws-sander.elexis.nl (ip5457f222.direct-adsl.nl [84.87.242.34])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.07 (built Jun 24 2005))
 with ESMTP id <0J0U00MVYB1PXL@psmtp04.wxs.nl> for linux-scsi@vger.kernel.org;
 Wed, 14 Jun 2006 09:49:01 +0200 (MEST)
In-reply-to: <20060609120853.GL1651@parisc-linux.org>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
 <20060609120853.GL1651@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Hi Matthew,

Thanks for your reply.
I've tried this, but the driver still does not seem to recognize the 
card. Any other idea's?

Kind regards,
Sander


At 14:08 9-6-2006, Matthew Wilcox wrote:
>On Fri, Jun 09, 2006 at 01:20:57PM +0200, Sander van Beek - Elexis wrote:
> > I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit
> > fibre channel hba's for a pci-x bus. The qlogic site says this type
> > is a HP OEM card and it is not sold directly by qlogic.
> > I tried to get them working on a slackware 10.2 system with the
> > latest stable 2.6 kernel. However, the qla2xxx driver does not see
> > the card. My dmesg only shows this line:
> >
> > Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver
> >
> > This is how the card shows up in my /proc/pci:
> >
> >   Bus  2, device   1, function  1:
> >     Class 0c04: PCI device 1077:8000 (rev 1).
> >       IRQ 255.
> >       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].
> >
> > Can anyone supply me with some hints what could be wrong, or what I
> > should do to get them working?
>
>I'd try adding the PCI IDs to the driver and see what happened next.
>Something like:
>
>+++ drivers/scsi/qla2xxx/ql2300.c       9 Jun 2006 12:08:21 -0000
>@@ -64,6 +64,13 @@ static struct pci_device_id qla2300_pci_
>         },
>         {
>                 .vendor         = PCI_VENDOR_ID_QLOGIC,
>+               .device         = 0x8000,
>+               .subvendor      = PCI_ANY_ID,
>+               .subdevice      = PCI_ANY_ID,
>+               .driver_data    = (unsigned long)&qla_board_tbl[1],
>+       },
>+       {
>+               .vendor         = PCI_VENDOR_ID_QLOGIC,
>                 .device         = PCI_DEVICE_ID_QLOGIC_ISP6312,
>                 .subvendor      = PCI_ANY_ID,
>                 .subdevice      = PCI_ANY_ID,
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>--
>No virus found in this incoming message.
>Checked by AVG Free Edition.
>Version: 7.1.394 / Virus Database: 268.8.3/359 - Release Date: 8-6-2006

Met vriendelijke groet,
Sander van Beek

---------------------------------------

Ing. S. van Beek
Elexis
Marketing 9
6921 RE Duiven

Tel:    +31 (0)26 7110329
Mob:    +31 (0)6 28395109
Fax:    +31 (0)318 611112
Email: sander@elexis.nl
Web:    http://www.elexis.nl

