From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 11:02:11 -0500
Message-ID: <1209657731.3067.19.camel@localhost.localdomain>
References: <4819C9DB.60104@panasas.com>
	 <1209651854.3067.8.camel@localhost.localdomain>
	 <4819DA39.70505@panasas.com>
	 <1209655360.3067.14.camel@localhost.localdomain>
	 <4819E371.2040403@panasas.com>
	 <1209656838.3067.16.camel@localhost.localdomain>
	 <4819E8C7.3040808@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46541 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759410AbYEAQCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 12:02:15 -0400
In-Reply-To: <4819E8C7.3040808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

On Thu, 2008-05-01 at 18:59 +0300, Boaz Harrosh wrote:
> On Thu, May 01 2008 at 18:47 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Thu, 2008-05-01 at 18:36 +0300, Boaz Harrosh wrote:
> >> On Thu, May 01 2008 at 18:22 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>> On Thu, 2008-05-01 at 17:56 +0300, Boaz Harrosh wrote:
> >>>> The call to pci_map_page() on an ISA case will it not bounce the
> >>>> buffer?
> >>> Only if the system isn't a PCI_DMA_BUS_IS_PHYS one.
> >>>
> >>> That means basically either has an iommu/gart or has some silly swiotlb
> >>> to emulate one.
> >>>
> >>> That means for standard x86 isa systems the answer is no: the buffer has
> >>> to be allocated within the isa region because pci_map is simply a
> >>> virt_to_phys.
> >>>
> >>> James
> >>>
> >> OK Thanks, so the second patch then. That will solve it.
> > 
> > Um, your second patch is only changing isd200; it's hard to see how that
> > can fix a gdth problem ...
> > 
> > James
> > 
> > 
> 
> Sorry I meant the second version of the patch that uses scsi_get_command()
> 
> http://marc.info/?l=linux-scsi&m=120965483126936&w=2

No ... it still needs to use scsi_allocate_command() and pass the gfp
flags for DMA if necessary.

James


