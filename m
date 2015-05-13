From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] mpt2sas: Fall back to 64 bit coherent mask if 64 bit
 DMA / 32 bit coherent mask not supported
Date: Wed, 13 May 2015 16:37:44 -0500
Message-ID: <5553C428.5090806@linux.vnet.ibm.com>
References: <555279A8.6060906@linux.vnet.ibm.com> <2214146.EzgWBA6g23@wuerfel> <5553505D.50102@linux.vnet.ibm.com> <10045033.4fV0qQU90u@wuerfel> <55535BDF.6020502@linux.vnet.ibm.com> <CAK=zhgoXx4HJfpTuNAP0tAPnsU8BLmM7X3qGsFCzJfHOx55YCQ@mail.gmail.com> <1431550613.20218.88.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:58722 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965463AbbEMVhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 17:37:48 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 13 May 2015 15:37:47 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id BEF143E40044
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 15:37:45 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4DLbKG543384900
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 14:37:20 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4DLbiS5029666
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 15:37:45 -0600
In-Reply-To: <1431550613.20218.88.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org, Daniel Kreling <kreling@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/13/2015 03:56 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2015-05-13 at 22:14 +0530, Sreekanth Reddy wrote:
>> Hi Brain,
>>
>> We had a restriction from the firmware that the upper 32 bits of the
>> RDPQ pool entries must be same. So to limit this restriction we
>> initially set the consistent DMA mask to 32 and then after allocating
>> the RDPQ pools we changed the consistent DMA mask to 64 before
>> allocating remaining pools.
> 
> Brian, maybe we should just bite that bullet and implement that hybrid
> DMA ops I mentioned. I'll see if I can spare some time today to look
> at it. It would work as long as we never remove the legacy window using
> the DDW APIs (removing the legacy window is broken anyway for other
> reasons I think we discussed already).
> 
> As long as we have both the legacy window and the DDW available (or the
> legacy and bypass on "nv"), we can then route individual DMAs according
> to the corresponding applicable mask.
> 
> I'll try to come up with a patch but I'll need you to test it.

Sure. I can help with that.

Thanks,

Brian

> 
> Cheers,
> Ben.
> 
>> Regards,
>> Sreekanth
>>
>> On Wed, May 13, 2015 at 7:42 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
>>> On 05/13/2015 08:31 AM, Arnd Bergmann wrote:
>>>> On Wednesday 13 May 2015 08:23:41 Brian King wrote:
>>>>> On 05/13/2015 03:10 AM, Arnd Bergmann wrote:
>>>>>> On Tuesday 12 May 2015 18:24:43 Brian King wrote:
>>>>>>>
>>>>>>> Commit 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c broke 64 bit DMA for mpt2sas on Power.
>>>>>>> That commit changed the sequence for setting up the DMA and coherent DMA masks so
>>>>>>> that during initialization the driver requests a 64 bit DMA mask and a 32 bit consistent
>>>>>>> DMA mask, then later requests a 64 bit consistent DMA mask. The Power architecture does
>>>>>>> not currently support this, which results in always falling back to a 32 bit DMA window,
>>>>>>> which has a negative impact on performance. Tweak this algorithm slightly so that
>>>>>>> if requesting a 32 bit consistent mask fails after we've successfully set a 64 bit
>>>>>>> DMA mask, just try to get a 64 bit consistent mask. This should preserve existing
>>>>>>> behavior on platforms that support mixed mask setting and restore previous functionality
>>>>>>> to those that do not.
>>>>>>>
>>>>>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>>>>>
>>>>>> I believe the way the API is designed, it should guarantee that after dma_set_mask()
>>>>>> succeeds for a device, dma_set_coherent_mask() with the same mask will also succeed.
>>>>>>
>>>>>> Could you just call dma_set_mask_and_coherent() here to avoid that complex logic?
>>>>>
>>>>> I don't think that would work. The mpt2sas driver wants to set the dma mask to 64bits
>>>>> but set the coherent mask to 32 bits, then my change is to set the coherent mask to
>>>>> 64bits if setting it to 32bit fails. I'm not seeing how using dma_set_mask_and_coherent
>>>>> would simplify anything here.
>>>>
>>>> My question was more about why the driver would ask for a 32-bit coherent
>>>> mask to start with. Is this a limitation in the mpt2sas device that can
>>>> only have descriptors at low addresses, or is it trying to work around some
>>>> bug in a particular host system?
>>>
>>> I'll need help from Sreekanth in answering that. All that is in the git commit log is:
>>>
>>>     2. Initially set the consistent DMA mask to 32 bit and then change it to 64 bit mask
>>>     after allocating RDPQ pools by calling the function _base_change_consistent_dma_mask.
>>>     This is to ensure that all the upper 32 bits of RDPQ entries's base address to be same.
>>>
>>> So, I'm not sure my patch won't break something with mpt2sas... This commit also changed
>>> how the RDPO pools are allocated, so its possible this won't work. However, I did load
>>> it on Power box and I'm not seeing any major problems so far. I am seeing the following message
>>> get logged on a regular basis, not sure if its related to this change or not:
>>>
>>> mpt2sas3: log_info(0x31120303): originator(IOP), code(0x03), sub_code(0x3112)
>>>
>>> -Brian
>>>
>>>
>>> --
>>> Brian King
>>> Power Linux I/O
>>> IBM Linux Technology Center
>>>
>>>
> 
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


