From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/10] megaraid_sas: Updates for scsi-misc
Date: Mon, 10 Oct 2011 09:07:45 -0500
Message-ID: <1318255665.3005.7.camel@dabdike.int.hansenpartnership.com>
References: <CAHtARFGh5i6M8SMqjeUnpUP=dWNdwdmDhGo+z4h4qE8r18xhWA@mail.gmail.com>
	 <4E91A813.1070003@interlog.com>
	 <1318169420.2998.6.camel@dabdike.int.hansenpartnership.com>
	 <4E9242DB.7040401@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58508 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209Ab1JJOHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2011 10:07:48 -0400
In-Reply-To: <4E9242DB.7040401@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Sun, 2011-10-09 at 20:56 -0400, Douglas Gilbert wrote:
> On 11-10-09 10:10 AM, James Bottomley wrote:
> > On Sun, 2011-10-09 at 09:56 -0400, Douglas Gilbert wrote:
> >> On 11-10-08 09:14 PM, adam radford wrote:
> >>> James/Linux-scsi,
> >>>
> >>> The following patch series for megaraid_sas brings the driver up to v6.12-rc1:
> >>>
> >>> 1. Continue booting immediately if FW in FAULT at driver load time.
> >>> 2. Increase default cmds per lun to 256.
> >>> 3. Fix mismatch in megasas_reset_fusion() mutex lock-unlock.
> >>> 4. Remove some un-necessary code.
> >>> 5. Clear state change interrupts for Fusion/Invader.
> >>> 6. Clear FUSION_IN_RESET before enabling interrupts.
> >>> 7. Add support for MegaRAID 9360/9380 12GB/s controllers.
> >>> 8. Add multiple MSI-X vector/multiple reply queue support.
> >>> 9. Add driver workaround for PERC5/1068 kdump kernel panic.
> >>> 10. Version and Changelog update.
> >>
> >> I haven't checked all SAS HBAs in Linux but of those that I
> >> have checked only one doesn't support the SMP pass-through
> >> in the bsg driver. And that HBA driver is megaraid_sas **.
> >
> > Technically the megaraid_sas isn't really a SAS HBA, it's a RAID one
> > that just happens to have SAS/SATA disk attachments.  None of the RAID
> > HBA's (including the IBM power raid) expose a BSG interface or even
> > attach properly to the in-kernel SAS interfaces.
> 
> In JBOD mode MegaRaid SAS controllers are SAS HBAs
> (marketing BS aside). Their firmware has the same
> SMP pass-through as LSI's MPT SAS Fusion controllers.
> 
> There is no reason why a MegaRaid controller user
> couldn't place a SAS-2 expander in front of an array
> of disks and make some disks available to a MegaRaid
> volume. Other array disks could be used by other
> machines and the different sets could be isolated
> from each other with SAS-2 zoning. The problem then
> would be that via a MegaRaid SAS controller a user
> could not monitor or control that zoning. Seems a
> bit wasteful to add a "real" SAS HBA just to get
> that capability.

I agree: ipr is used in precisely this way.  It even uses libata for
SATA devices but doesn't attach to the libsas transport class which
means it's dragging us for moving to the new_eh in libata.

The problem in the IPR case (and I assume the megaraid case) is that it
takes extra work to get the attachment which no-one seems willing to do.

> Many SAS HBAs (including MPT SAS Fusion controllers)
> do RAID 0 and 1 (and 10?) so they could be viewed as
> "RAID" controllers that expose a BSG interface.

fusion is more a SCSI controller with RAID wedged into a spare piece in
the firmware ... it wasn't really designed as a RAID controller.

James


