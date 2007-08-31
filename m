From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: Re: [PATCH] aic94xx: clean up PCI ID table per modern practice
Date: Fri, 31 Aug 2007 16:44:22 -0700
Message-ID: <1188603862.6036.2.camel@linux.site>
References: <1188583189.6353.4.camel@linux.site>
	 <46D85AD8.6000306@garzik.org> <1188594862.5812.5.camel@linux.site>
	 <46D88ECE.1040107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:52193 "HELO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750754AbXHaXal (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 19:30:41 -0400
In-Reply-To: <46D88ECE.1040107@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-08-31 at 17:57 -0400, Jeff Garzik wrote:
> Gilbert Wu wrote:
> >   
> > On Fri, 2007-08-31 at 14:15 -0400, Jeff Garzik wrote:
> >> Gilbert Wu wrote:
> >>> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
> >>> driver to add new PCI ID for HBA ASC58300.
> >>>
> >>> Contribution:
> >>>    Gilbert Wu <gilbert_wu@adaptec.com>
> >>>
> >>>
> >>> Patch: apply to aic94xx-sas-2.6.git development tree
> >>>
> >>> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
> >>>
> >>> Change Log:
> >>>
> >>> 1. Add new HBA PCI ID for ASC58300 which has eight port SAS and
> >>>    SATA PCI-X 133MHz low profile host bus adapter with two mini SAS
> >>>         4x external connectors. 
> >>>
> >>>
> >>>
> >>> diff -urN old/drivers/scsi/aic94xx/aic94xx_hwi.h
> >>> new/drivers/scsi/aic94xx/aic94xx_hwi.h
> >>> --- old/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-08-30 16:34:21.000000000 -0700
> >>> +++ new/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-08-30 16:34:02.000000000 -0700
> >>> @@ -45,6 +45,7 @@
> >>>   */
> >>>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
> >>>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
> >>> +#define PCI_DEVICE_ID_ADAPTEC2_RAZOR16 0x416
> >>>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
> >>>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
> >>>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
> >>> diff -urN old/drivers/scsi/aic94xx/aic94xx_init.c new/drivers/scsi/aic94xx/aic94xx_init.c
> >>> --- old/drivers/scsi/aic94xx/aic94xx_init.c	2007-08-30 16:34:18.000000000 -0700
> >>> +++ new/drivers/scsi/aic94xx/aic94xx_init.c	2007-08-30 16:33:59.000000000 -0700
> >>> @@ -835,6 +835,8 @@
> >>>  	 0, 0, 1},
> >>>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR12),
> >>>  	 0, 0, 1},
> >>> +	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR16),
> >>> +	 0, 0, 1},
> >>>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
> >>>  	 0, 0, 1},
> >>>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),
> >> ACK, but, really we need to delete all of PCI_DEVICE_ID_ADAPTEC2_* and 
> >> replace them with the numeric (hex) constants, since they are only used 
> >> in a single location.
> >>
> >> The PCI device table in aic94xx_init should really look like...  (see 
> >> attached)
> >>
> >> Much shorter, more maintainable, doesn't require patching the 
> >> heavily-patched include/linux/pci_ids.h for single-use constants.
> >>
> >> 	Jeff
> >>
> >>
> >>
> > 
> > Hi Jeff,
> > 
> >    I don't think we will add new PCI id for aic94xx in the future. Even
> > the ASC58300 is introduced two years ago. We should move those ID into
> > include/linux/pci_ids.h. We can change it next time.
> 
> This is standard kernel driver policy for many drivers.  There's no need 
> for the constants to exist at all, since they are only used in one 
> place, and add no value at all over the numeric constants.
> 
> This is self-evident because the constants themselves are named based on 
> the numeric values:
> 	..._RAZOR12	== 0x412
> 	..._RAZOR16	== 0x416
> 	etc.
> 
> Regards,
> 
> 	Jeff
> 
> 
> 

I understand it now.

Thanks!
Gilbert
