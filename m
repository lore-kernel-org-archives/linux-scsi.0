From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: I have modified the megaraid driver v2.00.5 from kernel 2.6 t
	o 2 .4.22-prex-ac1
Date: Thu, 24 Jul 2003 14:05:24 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307240505.OAA07771@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:42885 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S270488AbTGXEvA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 00:51:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: atulm@lsil.com, Matt Domsch <Matt_Domsch@Dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Hello Matthew,

     thanks for the reply!

Haruo> I have modified the megaraid driver  v2.00.5 from kernel 2.6 
Haruo> to 2.4.22-pre3-ac1 or 2.4.22-pre6-ac1.
 
Matthew> You mean you backported the 2.6 driver to 2.4?  If so, it seems the
Matthew> driver is in better state in 2.4 than 2.6 as many of these changes
Matthew> are outright wrong.

Yes, I  backported the 2.6 driver to 2.4.
Thank you for pointing out the affair of compile string literals.
I will correct a mistake. 

Matthew> PCI subsystem vendor IDs should use the defined constants in
Matthew> include/linux/pci_ids.h

I think that your opinion is right. My patch is wrong. 
I will correct a code. It will become the code of the driver of 2.6.

Matthew> if we want linux to be PCI200X compliant (a dubious point of view
since
Matthew> it means we'd have to stop supporting hundreds of hardware devices
designed
Matthew> before this became mandatory), this should be done in the PCI
subsystem,
Matthew> not in individual drivers.

Please explain in detail to a slight degree.
Although it corresponds to PCI2001 by 2.6, 
is it having stopped corresponding with my patch?

Matthew> some of the other code around here needs cleaning up too; for
example
Matthew> you should be using pci_name() rather than printing the slot/func
yourself.

Cleaning up of a code is not considered yet. 
I think it priority to make it operate by 2.4.

Matthew> btw, any plans to convert this driver to be hotplug capable?
 
I do not understand.

> 
> > @@ -1799,12 +1809,15 @@
> >  		}
> >  		set_irq_state(adapter, byte);
> >  
> > +		nstatus = 0xFF;
> >  		while((nstatus = (volatile u8)adapter->mbox->numstatus)
> >  				== 0xFF)

Matthew> this initialisation is not necessary; the assignment in the while
loop
Matthew> occurs before the test. (other occurrences of the same problem
deleted).

Thank you for a careful check.

Thanks again.
Regards
--
Haruo
