From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
	Adaptec SCSI controller
Date: Fri, 21 Sep 2007 10:37:46 -0500
Message-ID: <1190389066.3333.18.camel@localhost.localdomain>
References: <1183207551.14436.15.camel@linux.site>
	 <1190300889.31372.4.camel@linux.site>
	 <1190335307.3360.66.camel@localhost.localdomain>
	 <1190305223.1588.7.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37773 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751924AbXIUPhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Sep 2007 11:37:52 -0400
In-Reply-To: <1190305223.1588.7.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Anil K. Ravindranath" <anil_ravindranath@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

please don't drop linux-scsi ... just because no-one else has asked the
question doesn't mean they're not interested in the answer.  Having the
answer in the list means that search tools can find it.

On Thu, 2007-09-20 at 09:20 -0700, Anil K. Ravindranath wrote: 
> Oh I see. I looked into the scsi_host_alloc(), now I see this.Thanks. By
> setting a dma_boundary to 4G, does it mean the kernel(in block) is
> ensuring that a DMA segment will not cross this 4G boundary. I mean a
> DMA segment will not be split at 4G boundary.

Yes, that's exactly what it means.  Primarily, as I said, because PCI
bridges can't necessarily span non-DAC to DAC in a single DMA transfer.

James


> With regards,
>   Anil
> 
> 
> On Thu, 2007-09-20 at 19:41 -0500, James Bottomley wrote:
> > On Thu, 2007-09-20 at 08:08 -0700, Anil K. Ravindranath wrote:
> > > Hi,
> > > 
> > > We have not heard any comments or inputs on this patch. 
> > > 
> > > With regards,
> > >   Anil
> > > 
> > > On Sat, 2007-06-30 at 05:45 -0700, Anil K. Ravindranath wrote:
> > > > Subject: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
> > > > Adaptec SCSI controller
> > > > 
> > > > Contribution:
> > > > 
> > > > Anil Ravindranath <anil_ravindranath@adaptec.com>
> > > > 
> > > > Issue:
> > > > 
> > > > Data Bursts that cross from 32- to 64-Bit address space have incorrect
> > > > address for 29320LPE. This leads to potential data corruption.
> > 
> > Where do you think you see this happening?  The block layer has a
> > dma_boundary parameter (basically a mask which it refuses to allow dma
> > to cross).  By default this is set to 4GB (because a lot of PCI cards
> > have difficulty going from non-DAC to DAC).  The aic79xx driver does
> > nothing to alter this, so you shouldn't be seeing any DMA segments
> > crossing the 4GB boundary.
> > 
> > James
> > 
> > 

