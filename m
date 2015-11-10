From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 14:56:36 -0500
Message-ID: <56424BF4.2040207@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <5349261.sTnZTFhKWB@wuerfel> <56421610.50005@codeaurora.org>
 <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
 <1447180034.2187.20.camel@HansenPartnership.com>
 <56424200.9080406@codeaurora.org>
 <1447184611.2187.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447184611.2187.45.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org



On 11/10/2015 2:43 PM, James Bottomley wrote:
> The Issue, as stated by LSI is
>
>          Initially set the consistent DMA mask to 32 bit and then change
>          it
>          to 64 bit mask after allocating RDPQ pools by calling the
>          function
>          _base_change_consistent_dma_mask. This is to ensure that all the
>          upper 32 bits of RDPQ entries's base address to be same.
>

Need somebody from mpt to confirm that this behavior is still valid for 
the recent cards besides altix.

> If you set a 64 bit coherent mask before this point, you're benefiting
> from being lucky that all the upper 32 bits of the allocations are the
> same ... we can't code a driver to rely on luck.  Particularly not when
> the failure mode looks like it would be silent and deadly.

Of course nobody wants unreliable code.

I'm wondering if I was just lucky during my testing or the 92xx and 93xx 
hardware supports full 64 bit range. I don't have any insight into what 
the endpoint does or what it is capable of.

>
>> >Another comment here from you.
>> >https://lkml.org/lkml/2015/4/2/28
>> >
>> >"Well, it was originally a hack for altix, because they had no regions
>> >below 4GB and had to specifically manufacture them.  As you know, in
>> >Linux, if Intel doesn't need it, no-one cares and the implementation
>> >bitrots."
>> >
>> >Maybe, it is time to fix the code for more recent (even decent) hardware?
> What do you mean "fix the code"?  The code isn't broken, it's
> parametrising issues with particular hardware.  There's no software work
> around (except allocating memory with the correct characteristics).

Need confirmation. I'm questioning if we are stuck with this behavior 
because of altix or something else. If the latter case, the code could 
have used PCI ID to do something special for it.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
