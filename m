From: "Ely, Paul" <Paul.Ely@Emulex.Com>
Subject: RE: suspending I/Os to a device
Date: Fri, 23 Jul 2004 09:26:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28025AB7A1@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3250 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S267576AbUGWN0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2004 09:26:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Nathan Bryant' <nbryant@optonline.net>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Nathan,

This proposal is specific to those scsi lld's that
manage storage devices that have to gracefully deal
with devices temporarily disappearing and reappearing -
such as Fibre Channel device drivers - but could have 
other applications such as iSCSI lld's or 

This proposal is not intended to deal with PCI 
power management.  Additionally, the existing
scsi_device_quiesce and resume functions and
device state are insufficient for this feature because 
for device suspend, the scsi lld does not want the midlayer
to have special's access to the scsi lld and in
particular retries.

HTH,

Paul

> -----Original Message-----
> From: Nathan Bryant [mailto:nbryant@optonline.net]
> Sent: Friday, July 23, 2004 12:36 AM
> To: Ely, Paul
> Cc: 'Christoph Hellwig'; Smart, James; 'James Bottomley'; Linux SCSI
> Reflector
> Subject: Re: suspending I/Os to a device
> 
> 
> Ely, Paul wrote:
> 
> >All,
> >
> >
> >The following patch provides an implementation of
> >the proposal contained in this mail thread.  The
> >patch does not provide a complete solution such
> >as:
> >	nodevice tmo handling by the scsi midlayer
> >	scsi_device structure member for nodevice tmo
> >	handling of SDEV_SUSPEND state by midlayer
> >
> >Subsequent patches to address remaining implementation.
> >
> I'm a little late to the party. Is this intended to 
> facilitate the PCI 
> power management (queue quiesce) issues that were discussed 
> this week? 
> Will it be sufficient to "just call" these from pcidev->suspend(), 
> pcidev->resume()?
> 
> Duh, like thanks and stuff. I think.
> Nathan
> 
