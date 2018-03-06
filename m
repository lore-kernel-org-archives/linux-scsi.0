From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 5/8] scsi: hisi_sas: increase timer expire of internal
 abort task
Date: Tue, 6 Mar 2018 12:30:06 +0000
Message-ID: <c2a60f8b-8332-df6f-6bfd-147817208dee@huawei.com>
References: <1520261330-204596-1-git-send-email-john.garry@huawei.com>
 <1520261330-204596-6-git-send-email-john.garry@huawei.com>
 <3983d075-af2e-5c69-2708-51db8a6b79cb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3983d075-af2e-5c69-2708-51db8a6b79cb@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 06/03/2018 11:23, Hannes Reinecke wrote:
> On 03/05/2018 03:48 PM, John Garry wrote:
>> From: Xiaofei Tan <tanxiaofei@huawei.com>
>>
>> The current 110ms expiry time is not long enough for the internal
>> abort task.
>>
>> The reason is that the internal abort task could be blocked in HW
>> if the HW is retrying to set up link. The internal abort task will
>> be executed only when the retry process finished.
>>
> Hmm. That sounds weird.
> I would have expected that a link retrain will force a device reset,
> after which no tasks should be active on the target.
> Consequently the succeeding abort task will be a no-op.
> Care to clarify?
>

Hi Hannes,

It sounds like you're talking about TMF task abort, right? This patch is 
related to controller internal abort function.

Our HW supports internal abort, where any pending queued commands in the 
controller can be aborted, so they will not be executed. When a disk is 
removed or a nexus reset are times when we issue such a command.

Thanks very much,
John

> Cheers,
>
> Hannes
>
