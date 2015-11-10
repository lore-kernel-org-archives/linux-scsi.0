From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 3/3] scsi: mptxsas: offload IRQ execution
Date: Tue, 10 Nov 2015 00:59:54 -0500
Message-ID: <564187DA.6090508@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-4-git-send-email-okaya@codeaurora.org>
 <5640481C.9000505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5640481C.9000505@suse.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-arm-msm@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, linux-arm-kernel@lists.infradead.org
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
>

Can you go into the detail about which part of the _base_interrupt 
function needs to be executed in ISR context and which part can be 
queued up to worker thread?

I'm not familiar with the hardware or the code. That's why, I moved the 
entire ISR into the thread context.



> Cheers,
>
> Hannes
>

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
