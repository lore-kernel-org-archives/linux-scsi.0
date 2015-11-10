From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 12:05:20 -0800
Message-ID: <1447185920.2187.53.camel@HansenPartnership.com>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
	 <5349261.sTnZTFhKWB@wuerfel> <56421610.50005@codeaurora.org>
	 <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
	 <1447180034.2187.20.camel@HansenPartnership.com>
	 <56424200.9080406@codeaurora.org>
	 <1447184611.2187.45.camel@HansenPartnership.com>
	 <56424BF4.2040207@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39444 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbbKJUFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 15:05:22 -0500
In-Reply-To: <56424BF4.2040207@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>

On Tue, 2015-11-10 at 14:56 -0500, Sinan Kaya wrote:
> 
> On 11/10/2015 2:43 PM, James Bottomley wrote:
> > The Issue, as stated by LSI is
> >
> >          Initially set the consistent DMA mask to 32 bit and then change
> >          it
> >          to 64 bit mask after allocating RDPQ pools by calling the
> >          function
> >          _base_change_consistent_dma_mask. This is to ensure that all the
> >          upper 32 bits of RDPQ entries's base address to be same.
> >
> 
> Need somebody from mpt to confirm that this behavior is still valid for 
> the recent cards besides altix.

OK, you don't seem to be understanding the problem: the Altix isn't a
LSI card, it was a SGI platform.  It was the platform where we first
discovered the issue that a lot of storage cards didn't work because it
by default had no memory below 4GB.  The reason coherent masks were
introduced was initially so the Altix could manufacture and manage a
region of memory in the lower 4GB region and we would guarantee to make
allocations from it so the storage cards would then work on that
platform.

I thought the Altix was a historical relic because after they
disappeared, there was no other platform with this issue ...  until you
came along.

James


