From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] megaraid_sas: do not crash on invalid completion
Date: Fri, 11 Nov 2016 16:07:39 +0100
Message-ID: <8ed4eddb-1102-4a69-907c-c9d1d8e32ece@suse.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
 <1478857492-4581-4-git-send-email-hare@suse.de>
 <5f5b5d4c3503fabc4344b8eddfc30129@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753972AbcKKPHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 10:07:42 -0500
In-Reply-To: <5f5b5d4c3503fabc4344b8eddfc30129@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 11/11/2016 12:51 PM, Sumit Saxena wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>> Sent: Friday, November 11, 2016 3:15 PM
>> To: Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
>> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>> Subject: [PATCH 3/5] megaraid_sas: do not crash on invalid completion
>>
>> Avoid a kernel oops when receiving an invalid command completion.
> scmd_local set to NULL(for cases MPI2_FUNCTION_SCSI_IO_REQUEST and
> MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST) will be serious bug(either in driver
> or firmware) which should be debugged
> and driver should not really continue beyond that. This indicates that
> driver internal frames are corrupted. If needed, whenever driver detects
> it, it can mark the adapter as dead(stopping further activities).
> If OS is installed behind megasas controller then after declaring adapter
> dead, system reboot will be required. Kernel panic may give here more
> information whenever this condition hits so we kept it like this.
> If you are facing this issue, please share the details. I will work on
> this.
>

I have come across this problem when developing scsi-mq support. Due to 
the missing mmio barrier when writing to the inbound queue port the I/O 
submission became confused, resulting in already completed frames on the 
completion queue.
While I do agree this is a pretty serious problem, the driver should 
_not_ crash; after all, it just received a completion for an unknown 
command. No reason to take the kernel down.
I'd be in favour of resetting the HBA and taking it offline if required, 
but we really should not crash here.

Incidentally, we _will_ take the HBA offline even now, as these invalid 
command completions causes a scsi timeout for the original command, and 
as the HBA couldn't send completions for them the driver would 
eventually offline the card. So it worked as expected from my POV.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
