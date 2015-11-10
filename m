From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 12:35:35 -0800
Message-ID: <1447187735.2187.58.camel@HansenPartnership.com>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
	 <5349261.sTnZTFhKWB@wuerfel> <56421610.50005@codeaurora.org>
	 <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
	 <1447180034.2187.20.camel@HansenPartnership.com>
	 <56424200.9080406@codeaurora.org>
	 <1447184611.2187.45.camel@HansenPartnership.com>
	 <56424BF4.2040207@codeaurora.org>
	 <1447185920.2187.53.camel@HansenPartnership.com>
	 <564252DA.5000004@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39604 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbbKJUfm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 15:35:42 -0500
In-Reply-To: <564252DA.5000004@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>

On Tue, 2015-11-10 at 15:26 -0500, Sinan Kaya wrote:
> 
> On 11/10/2015 3:05 PM, James Bottomley wrote:
> > OK, you don't seem to be understanding the problem: the Altix isn't a
> > LSI card, it was a SGI platform.
> 
> Got it.
> 
> > It was the platform where we first
> > discovered the issue that a lot of storage cards didn't work because it
> > by default had no memory below 4GB.  The reason coherent masks were
> > introduced was initially so the Altix could manufacture and manage a
> > region of memory in the lower 4GB region and we would guarantee to make
> > allocations from it so the storage cards would then work on that
> > platform.
> 
> I can't fix the issue if the card cannot do 64 bit DMA when IOMMU is not 
> there. I need IOMMU enabled all the time for this card.

That depends on the limitations of your platform.  The Altix only used
an iommu to manufacture the coherent memory for the descriptors, but the
card itself mostly operated in bypass mode (using 64 bit physical
addresses rather than iommu remapped ones), so all accesses except for
the few firmware descriptor ones didn't use an iommu.  Apparently this
was for performance reasons.

So, to recap, the card itself *can* do 64 bit DMA.  The limitation is
that the RDPQ descriptors need to be all in the same region of 4G memory
and the way the driver ensures this is to set the 64 bit coherent mask
after using the 32 bit one to allocate the RDPQ pools.

James


