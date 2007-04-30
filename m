From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: fails to initialize after a  kexec operation
Date: Mon, 30 Apr 2007 10:11:03 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF018FDB38@otce2k301.adaptec.com>
References: <20070430095334.GA17186@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:37890 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXD3OMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 10:12:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070430095334.GA17186@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kexec Mailing List <kexec@lists.infradead.org>, Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

Foreign arrays are arrays configured on another adapter then moved over
to the current host adapter. I do not know why this may be the case in
your situation, but it had the smell of behaving like a foreign array
and thus my suggestion. We use commit=1 for all situations where the
importation of an array is not considered an error and there is no BIOS
to intervene prior to driver load. Typically we advise to set this flag
in embedded systems, or in non-Intel based architectures. Normally on
Intel based systems you get a query from the card's BIOS as you boot
that queries the user (to answer yes) to accept the array configuration
should it be detected as foreign.

I see some problems with declaring aacraid.commit=1 for kdump, you are
changing the storage system conditions and the fact you have a foreign
array may have been the cause of the primary kernel's failure. You are
rubbing out a factor in the system's failure? I would also hate to store
a kernel dump over an array one does not know the status or origin of.

If there is a clean shutdown, and there are no outstanding commands from
the OS (including the ioctl, so make sure the management software
commands are shut down), I do not see a reason to reset the adapter.

I agree, the irqpoll is troublesome! Could something else in the kexec
kernel be catching the interrupts and dropping them on the floor? Are
there any other devices sharing that same interrupt line that may be
holding the interrupt asserted? /proc/irq/*, /proc/interrupts? By
routing, I did not make it clear, but there is more than just the PCI
hardware in control of the path of an Interrupt from the controller
hardware to the interrupt service routine ... this may not be a pure
issue with PCI configuration being corrupted.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com] 
> Sent: Monday, April 30, 2007 5:54 AM
> To: Salyzyn, Mark
> Cc: James Bottomley; Kexec Mailing List; Judith Lebzelter; 
> linux-scsi@vger.kernel.org; Darrick J. Wong
> Subject: Re: [PATCH] aacraid: fails to initialize after a 
> kexec operation
> 
> 
> On Tue, Apr 24, 2007 at 09:21:35AM -0400, Salyzyn, Mark wrote:
> > The system BIOS sets up the card's PCI configuration and 
> there is code
> > in the kernel that is capable of picking up some of the BIOS'
> > information from the BIOS Data Space (not sure if it is actively
> > collected in your configuration, you need a kernel flag to pick this
> > up). On kexec this BIOS Data Space information is missing (?) and if
> > there was any reconfiguration of the PCI space going on (I 
> think only
> > the Linux BIOS project does this), kexec will inherit it. This issue
> > strikes me as a corrupted PCI configuration inherited in 
> the kexec case,
> > such corrupted PCI configurations could be a motherboard 
> specific issue
> > and can be related to the BIOS' initial setup for the 
> initial kernel. At
> > least that is my thought process in questioning the 
> motherboard BIOS or
> > hardware.
> > 
> > Another possibility is that after you have patched over the 
> interrupt
> > routing issues (a PCI configuration problem), the card has a foreign
> > array, and the reset and reconfiguration is taking arrays 
> offline. Add
> > 'aacraid.commit=1' to force the foreign arrays to be accepted by the
> > card.
> > 
> 
> Hi Mark,
> 
> So aacraid.commit=1 and irqpoll combination has done the trick. I can
> kexec/kdump into second kernel. I am using an IBM x366 series machine.
> There is one array and three disks behind it.
> 
> Now few queries.
> 
> - What is the concept of foreign arrays? 
> - Should we pass aacraid.commit=1 all the time or this is only for
>   some special cases? What's the point in resetting an adapter if it
>   does not online the array it is managing?
> - For kexec, it calls the device shutdown routine 
> (aac_shutdown) in this
>   case. If this is the case for normal kexec (not kdump) 
> adapter should
>   not be reset?
> - Still needs to be found out why PCI configuration is 
> getting corrupted
>   and why irq routing is not proper and irqpoll is required.
>  
> Thanks
> Vivek
> 
