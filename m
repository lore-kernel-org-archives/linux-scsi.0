From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH V2 3/3] scsi: mptxsas: offload IRQ execution
Date: Wed, 16 Mar 2016 11:31:06 -0400
Message-ID: <56E97C3A.6030307@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-4-git-send-email-okaya@codeaurora.org>
 <5640481C.9000505@suse.de> <564187DA.6090508@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42124 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935092AbcCPPbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2016 11:31:13 -0400
In-Reply-To: <564187DA.6090508@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, timur@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org

On 11/10/2015 12:59 AM, Sinan Kaya wrote:
> 
> On 11/9/2015 2:15 AM, Hannes Reinecke wrote:
>> On 11/09/2015 02:57 AM, Sinan Kaya wrote:
>>> The mpt2sas and mpt3sas drivers are spinning forever in
>>> their IRQ handlers if there are a lot of jobs queued up
>>> by the PCIe card. This handler is causing spikes for
>>> the rest of the system and sluggish behavior.
>>>
>>> Marking all MSI interrupts as non-shared and moving the
>>> MSI interrupts to thread context. This relexes the rest
>>> of the system execution.
>>>
>> NACK.
>>
>> If there is a scalability issue when handling interrupts
>> it should be fixed in the driver directly.
>>
>> Looking at the driver is should be possible to implement
>> a worker thread handling the reply descriptor, and having the
>> interrupt only to fetch the reply descriptor.
>>
> 
> Can you go into the detail about which part of the _base_interrupt
> function needs to be executed in ISR context and which part can be
> queued up to worker thread?
> 
> I'm not familiar with the hardware or the code. That's why, I moved the
> entire ISR into the thread context.

Hannes or others, any suggestions?

Thanks,
Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
