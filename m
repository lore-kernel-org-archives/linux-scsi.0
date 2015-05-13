From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] mpt2sas: Fall back to 64 bit coherent mask if 64 bit
 DMA / 32 bit coherent mask not supported
Date: Wed, 13 May 2015 08:23:41 -0500
Message-ID: <5553505D.50102@linux.vnet.ibm.com>
References: <555279A8.6060906@linux.vnet.ibm.com> <1431468627.20218.64.camel@kernel.crashing.org> <55528BBB.3000809@linux.vnet.ibm.com> <2214146.EzgWBA6g23@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:40864 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344AbbEMNXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 09:23:49 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 13 May 2015 09:23:48 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 764C938C804A
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 09:23:45 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4DDNjX643647224
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 13:23:45 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4DDNh0r028297
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 09:23:45 -0400
In-Reply-To: <2214146.EzgWBA6g23@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Daniel Kreling <kreling@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

On 05/13/2015 03:10 AM, Arnd Bergmann wrote:
> On Tuesday 12 May 2015 18:24:43 Brian King wrote:
>>
>> Commit 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c broke 64 bit DMA for mpt2sas on Power.
>> That commit changed the sequence for setting up the DMA and coherent DMA masks so
>> that during initialization the driver requests a 64 bit DMA mask and a 32 bit consistent
>> DMA mask, then later requests a 64 bit consistent DMA mask. The Power architecture does
>> not currently support this, which results in always falling back to a 32 bit DMA window,
>> which has a negative impact on performance. Tweak this algorithm slightly so that
>> if requesting a 32 bit consistent mask fails after we've successfully set a 64 bit
>> DMA mask, just try to get a 64 bit consistent mask. This should preserve existing
>> behavior on platforms that support mixed mask setting and restore previous functionality
>> to those that do not.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> 
> I believe the way the API is designed, it should guarantee that after dma_set_mask()
> succeeds for a device, dma_set_coherent_mask() with the same mask will also succeed.
> 
> Could you just call dma_set_mask_and_coherent() here to avoid that complex logic?

I don't think that would work. The mpt2sas driver wants to set the dma mask to 64bits
but set the coherent mask to 32 bits, then my change is to set the coherent mask to
64bits if setting it to 32bit fails. I'm not seeing how using dma_set_mask_and_coherent
would simplify anything here.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


