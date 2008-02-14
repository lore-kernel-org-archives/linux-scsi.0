From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] gdth: update deprecated pci_find_device
Date: Thu, 14 Feb 2008 08:50:17 -0600
Message-ID: <1203000617.3189.8.camel@localhost.localdomain>
References: <200802140059.m1E0xrID025375@hera.kernel.org>
	 <47B3C6F5.6060809@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40603 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbYBNOuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 09:50:25 -0500
In-Reply-To: <47B3C6F5.6060809@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sergio Luis <sergio@larces.uece.br>, Andrew Morton <akpm@linux-foundation.org>


On Wed, 2008-02-13 at 23:43 -0500, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99109301d103fbf0de43fc5a580a406c12a501e0
> > Commit:     99109301d103fbf0de43fc5a580a406c12a501e0
> > Parent:     61c92814dc324b541391757062ff02fbf3b08086
> > Author:     Sergio Luis <sergio@larces.uece.br>
> > AuthorDate: Tue Feb 12 20:48:03 2008 -0300
> > Committer:  James Bottomley <James.Bottomley@HansenPartnership.com>
> > CommitDate: Wed Feb 13 09:33:10 2008 -0600
> > 
> >     [SCSI] gdth: update deprecated pci_find_device
> >     
> >     Fix compilation warning in gdth.c, which was using the deprecated
> >     pci_find_device.
> >     
> >     drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)
> >     
> >     Changing it to use pci_get_device, instead.
> >     
> >     Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> >     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/Kconfig |    2 +-
> >  drivers/scsi/gdth.c  |    7 +++++--
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index a5f0aaa..a7a0813 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -722,7 +722,7 @@ config SCSI_FD_MCS
> >  
> >  config SCSI_GDTH
> >  	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
> > -	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API && PCI_LEGACY
> > +	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
> >  	---help---
> >  	  Formerly called GDT SCSI Disk Array Controller Support.
> >  
> > diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> > index 7079fef..6d67f5c 100644
> > --- a/drivers/scsi/gdth.c
> > +++ b/drivers/scsi/gdth.c
> > @@ -642,12 +642,15 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
> >            *cnt, vendor, device));
> >  
> >      pdev = NULL;
> > -    while ((pdev = pci_find_device(vendor, device, pdev)) 
> > +    while ((pdev = pci_get_device(vendor, device, pdev))
> >             != NULL) {
> >          if (pci_enable_device(pdev))
> >              continue;
> > -        if (*cnt >= MAXHA)
> > +        if (*cnt >= MAXHA) {
> > +            pci_dev_put(pdev);
> >              return;
> > +        }
> > +
> 
> Why no pci_dev_put() in the module cleanup path?

Because the pci dev is never got ... nasty I know, but it's the way this
driver works.

the while (pci_get_device()) runs until the device returned is NULL.  At
that point, every PCI device it ever returned has been put.  The only
problem is premature exit from the while loop, which is why I made the
original author do a put along that path.

James


