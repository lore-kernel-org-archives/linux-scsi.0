From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] iscsi iser: remove DMA restrictions
Date: Thu, 14 Feb 2008 12:21:15 -0600
Message-ID: <47B4869B.9070906@cs.wisc.edu>
References: <20080212205252.GB13643@osc.edu>	 <20080212205403.GC13643@osc.edu>	 <1202850645.3137.132.camel@localhost.localdomain>	 <47B480D9.6080206@cs.wisc.edu> <1203012634.3158.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43458 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbYBNSVc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 13:21:32 -0500
In-Reply-To: <1203012634.3158.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pete Wyckoff <pw@osc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2008-02-14 at 11:56 -0600, Mike Christie wrote:
>>> You really don't want to do this.  That signals to the block layer that
>>> we have an iommu, although it's practically the same thing as a 64 bit
>>> DMA mask ... but I'd just leave it to the DMA mask to set this up
>>> correctly.  Anything else is asking for a subtle bug to turn up years
>>> from now when something causes the mask and the limit to be mismatched.
>>>
>> I thought BLK_BOUNCE_ANY just meant "don't bounce anything" (that was 
>> from the blkdev.h comments). 
> 
> It does ... that's why it's used in the IOMMU case ... and why it's
> practically the same as a 64 bit mask.
> 
>> We used it for iscsi_tcp because the network layer can take any type
>> of page and will do the right thing for the hardware it eventually
>> gets sent to.
> 
> Right, to you it means never bounce because net wants to do it instead.
> However, I don't think that's the case for iSER, is it? ... as in, if

I will leave that to Roland and them :)

My only concern with a simple patch to use the ib interface's dma values 
would be, if there is some event that causes us to start using inteface 
ib0 then switch to ib1 (maybe like some sort of route table change if 
that is possible), then we will have to loop over all the scsi devices's 
queues and update the dma values. And if there is IO already queued then 
would we have to possible rebuild those commands if something like the 
dma_mask changed?


> I've got the pathway tracing correct, it just goes to the infiniband
> device and gets mapped there.  If there's a mask mismatch (very
> unlikely, I know) we get a very subtle and hard to trace error.
> 
