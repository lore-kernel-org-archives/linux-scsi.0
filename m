From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ipr boot failure caused by MSI (2.6.30-rc1+)
Date: Thu, 21 May 2009 14:51:55 -0500
Message-ID: <1242935515.3007.10.camel@localhost.localdomain>
References: <1242926159.3007.5.camel@localhost.localdomain>
	 <4A15A1B2.8060609@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60441 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004AbZEUTvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 May 2009 15:51:55 -0400
In-Reply-To: <4A15A1B2.8060609@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Wayne Boyer <wayneb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>

On Thu, 2009-05-21 at 13:47 -0500, Brian King wrote:
> cc'ing linuxppc-dev...
> 
> -Brian
> 
> 
> James Bottomley wrote:
> > Kernels after 2.6.30-rc1 stopped booting on my powerstation.  The ipr
> > just times out and refuses to probe devices.  If I let it drop into the
> > initramfs system, this is what the interrupts shows:
> > 
> > (initramfs) cat /proc/interrupts 
> >            CPU0       CPU1       CPU2       CPU3       
> >  16:         20         10         13         11   MPIC      Level     pata_amd
> >  20:          0          0          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
> >  21:          0          0          0          0  MPIC-U3MSI Edge      ipr
> >  68:         37         37         48         37   MPIC      Edge      serial
> > 251:         10         71         69         72   MPIC      Edge      ipi call function
> > 252:       1555       1779       1372       1155   MPIC      Edge      ipi reschedule
> > 253:          0          0          0          0   MPIC      Edge      ipi call function single
> > 254:          0          0          0          0   MPIC      Edge      ipi debugger
> > BAD:        416
> > 
> > So you see the IPR is the only device not receiving them.
> > 
> > I can fix the boot hang by reverting
> > 
> > commit 5a9ef25b14d39b8413364df12cb8d9bb7a673a32
> > Author: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> > Date:   Fri Jan 23 09:17:35 2009 -0800
> > 
> >     [SCSI] ipr: add MSI support
> > 
> > The system in question is:
> > 
> > SYSTEM INFORMATION
> >  Processor  = PowerPC,970MP @ 2500 MHz
> >  I/O Bridge = U4 (4.4)
> >  SMP Size   = 4 (#0 #1 #2 #3)
> >  Boot-Date  = 2009-04-21 17:13:36
> >  Memory     = 2 GB of RAM @ 666 MHz
> >  Board Type = Bimini (7047191/0000000/1)
> >  MFG Date   = 1608
> >  Part No.   = 10N8748     
> >  FRU No.    = 10N7182     
> >  FRU Serial = YL30W8106038
> >  UUID       = 00000000000000000000000000000000
> >  Flashside  = 1 (temporary)
> >  Version    = HEAD
> >  Build Date = 12-04-2008 16:13

OK, so as an update, I booted to the initrd and inserted the network
modules, which are also MSI enabled and this is what I get:

(initramfs) cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
 16:         14         11         11         18   MPIC      Level     pata_amd
 20:          0          0          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
 21:          0          0          0          0  MPIC-U3MSI Edge      ipr
 22:          1          0          1          0  MPIC-U3MSI Edge      eth0
 23:          0          2          1          0  MPIC-U3MSI Edge      eth1
 68:        193        166        113        177   MPIC      Edge      serial
251:         16         65         71         70   MPIC      Edge      ipi call function
252:       1574       1804       1346       1289   MPIC      Edge      ipi reschedule
253:          0          0          0          0   MPIC      Edge      ipi call function single
254:          0          0          0          0   MPIC      Edge      ipi debugger
BAD:       1866

So clearly the MSI interrupts to the network cards are working and it
looks like just a local problem with the ipr rather than a platform
problem with MSI.

James


