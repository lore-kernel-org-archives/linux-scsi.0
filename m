From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 3/3] scsi: mptxsas: offload IRQ execution
Date: Mon, 9 Nov 2015 09:01:02 -0500
Message-ID: <5640A71E.7070502@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-4-git-send-email-okaya@codeaurora.org>
 <5640481C.9000505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <5640481C.9000505@suse.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 11/9/2015 2:15 AM, Hannes Reinecke wrote:
> On 11/09/2015 02:57 AM, Sinan Kaya wrote:
>> The mpt2sas and mpt3sas drivers are spinning forever in
>> their IRQ handlers if there are a lot of jobs queued up
>> by the PCIe card. This handler is causing spikes for
>> the rest of the system and sluggish behavior.
>>
>> Marking all MSI interrupts as non-shared and moving the
>> MSI interrupts to thread context. This relexes the rest
>> of the system execution.
>>
> NACK.
>
> If there is a scalability issue when handling interrupts
> it should be fixed in the driver directly.
>
> Looking at the driver is should be possible to implement
> a worker thread handling the reply descriptor, and having the
> interrupt only to fetch the reply descriptor.

I'll take a look.

>
> Cheers,
>
> Hannes
>

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
