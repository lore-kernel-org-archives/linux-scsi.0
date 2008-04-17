From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: Query regarding modifying the DMA Mask based on the available memory in the system
Date: Fri, 18 Apr 2008 01:36:16 +0800
Message-ID: <5AE055B67BB5764693E2900C7E3699BE010CABD8@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43902 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbYDQRhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 13:37:07 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Thanks everyone. 
I will use the dma_get_required_mask() for deciding fusion's descriptor
format

-----Original Message-----
From: Andi Kleen [mailto:andi@firstfloor.org] 
Sent: Thursday, April 17, 2008 9:41 PM
To: James Bottomley
Cc: Prakash, Sathya; linux-scsi@vger.kernel.org
Subject: Re: Query regarding modifying the DMA Mask based on the
available memory in the system

James Bottomley wrote:
> On Thu, 2008-04-17 at 17:06 +0200, Andi Kleen wrote:
>> James Bottomley wrote:
>>> On Thu, 2008-04-17 at 16:44 +0200, Andi Kleen wrote:
>>>>> For drivers that can alter their descriptor types, we have this
>>>>> function:
>>>>>
>>>>> dma_get_required_mask()
>>>> Are you sure we have it? It seems to be in drivers/base/platform.c 
>>>> conditional on ARCH_HAS_DMA_GET_REQUIRED_MASK, but according to my 
>>>> grep no architecture ever sets that flag.
>>> Yes ... positive.  That's the default and correct implementation 
>>> based on the largest addressable physical memory.
>> Ok but still the whole thing is completely useless right now.
> 
> Why?  At least for aic it performs as advertised: allows the driver to

> select the most efficient descriptor format.

You were right sorry, I misread the code. Your interpretation is
correct. The interface would be correct to use for fusion, although it
should be probably extended to IOMMUs too.

-Andi

