From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [PATCH] LLDD dynamic scan aids
Date: Mon, 29 Nov 2004 12:28:30 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570562CD9D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64901 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261421AbUK2R3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 12:29:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, 'Christoph Hellwig' <hch@infradead.org>
Cc: "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, "'James.Smart@Emulex.Com'" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Mark Haverkamp' <markh@osdl.org>

This thread seems to have died suddenly :-(

Are there any more suggestions?

Thanks
-Atul 

> -----Original Message-----
> From: Mukker, Atul [mailto:Atulm@lsil.com] 
> Sent: Friday, November 19, 2004 4:07 PM
> To: 'Patrick Mansfield'; 'Christoph Hellwig'
> Cc: 'Salyzyn, Mark'; 'James.Smart@Emulex.Com'; 
> 'linux-scsi@vger.kernel.org'; 'Mark Haverkamp'
> Subject: RE: [PATCH] LLDD dynamic scan aids
> 
> Since it is widely accepted that bringing new devices online, 
> have an ability to dynamically mark them offline, report 
> changes in size etc, are crucial for high performance 
> computing solutions, it can only be good if the most of the 
> situations are enumerated. After which the possible and 
> optimized solutions are laid out.
> 
> The following conditions are the minimum IMO
> 
> 1.	Few new devices are added (for example some new raid volumes are
> created by configuration program)
> 
> 	a.	If the LLDD 'knows' the bus, target, and lun, 
> it may call
> scsi_add_device() for each of new entries
> 	b.	Do a scsi_scan_host_selected(shost, chan, id,
> SCAN_WILD_CARD, 0) or scsi_scan_host_selected(shost, chan, 
> SCAN_WILD_CARD, SCAN_WILD_CARD, 0) as appropriate
> 	c.	Applications use proc/sysfs to update
> 
> 
> 2.	Few devices are deleted
> 
> 	a.	LLDD call scsi_remove_device() for each of the deleted
> volume.
> 	b.	???
> 	c.	Applications use proc/sysfs to update
> 
> 
> 3.	Many new devices are added (for example new configuration is
> created)
> 
> 	a.	If the LLDD 'knows' the bus, target, and lun, 
> it may call
> scsi_add_device() for each of new entries
> 	b.	Do a scsi_scan_host_selected(shost, SCAN_WILD_CARD,
> SCAN_WILD_CARD, SCAN_WILD_CARD, 0)
> 	c.	Applications use proc/sysfs to update
> 
> 
> 4.	Many devices are removed(for example configuration is cleared)
> 
> 	a.	LLDD call scsi_remove_device() for each of the deleted
> volume.
> 	b.	Do a scsi_scan_host_selected(shost, SCAN_WILD_CARD,
> SCAN_WILD_CARD, SCAN_WILD_CARD, 1)???
> 	c.	Applications use proc/sysfs to update
> 
> 
> 5.	Sizes of the existing volumes changed.
> 
> 	a.	scsi_rescan_device()
> 	b.	???
> 	c.	???
> 
> 
> Best Regards
> -Atul Mukker
> Architect, Drivers and BIOS
> LSI Logic Corporation
> 
> > -----Original Message-----
> > From: Patrick Mansfield [mailto:patmans@us.ibm.com]
> > Sent: Thursday, November 18, 2004 10:48 AM
> > To: Christoph Hellwig
> > Cc: Salyzyn, Mark; James.Smart@Emulex.Com; 
> linux-scsi@vger.kernel.org; 
> > Mark Haverkamp
> > Subject: Re: [PATCH] LLDD dynamic scan aids
> > 
> > On Thu, Nov 18, 2004 at 02:36:44PM +0000, Christoph Hellwig wrote:
> > > On Thu, Nov 18, 2004 at 09:32:09AM -0500, Salyzyn, Mark wrote:
> > > > But scsi_rescan_device and scsi_scan_host_selected both target 
> > > > specific ids though? As long as we stay away from the
> > wildcards for
> > > > scsi_scan_host_selected, or am I mistaken?
> > > 
> > > scsi_rescan_device should be exported.  For the target scan
> > something
> > > like the second hunk of James' patch looks good to me.
> > 
> > Why not export scsi_scan_host_selected (and SCAN_WILD_CARD)? 
> > If a driver used it wrong then change the driver.
> > 
> > Suppose a driver wants to scan a given channel. (Would one 
> ever want 
> > to scan for a particular a LUN? I can't think of a reason).
> > 
> > If the driver wants to rescan the host (it knows it it has already 
> > called any scsi scan functions), it would call:
> > 
> > 	scsi_scan_host_selected(shost, SCAN_WILD_CARD,
> > 		SCAN_WILD_CARD, SCAN_WILD_CARD, 1);
> > 
> > And new target scan:
> > 
> > 	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 0);
> > 
> > Target rescan:
> > 
> > 	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 1);
> > 
> > Instead of any shost->rescan logic.
> > 
> > -- Patrick Mansfield
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" 
> > in the body of a message to majordomo@vger.kernel.org More 
> majordomo 
> > info at http://vger.kernel.org/majordomo-info.html
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
