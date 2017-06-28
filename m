From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/47] megaraid: pass in NULL scb for host reset
Date: Wed, 28 Jun 2017 17:30:02 +0200
Message-ID: <ce2005d3-420c-3920-dadc-b9d1d36c8ecc@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-14-git-send-email-hare@suse.de>
 <f5b7e09b259b22452afe1da669712af6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41727 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751492AbdF1PaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 11:30:05 -0400
In-Reply-To: <f5b7e09b259b22452afe1da669712af6@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 06/28/2017 03:41 PM, Sumit Saxena wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>> Sent: Wednesday, June 28, 2017 2:03 PM
>> To: Christoph Hellwig
>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
> Hannes
>> Reinecke; Hannes Reinecke
>> Subject: [PATCH 13/47] megaraid: pass in NULL scb for host reset
>>
>> When calling a host reset we shouldn't rely on the command triggering the
>> reset, so allow megaraid_abort_and_reset() to be called with a NULL scb.
>> And drop the pointless 'bus_reset' and 'target_reset' handlers, which
> just call
>> the same function as host_reset.
> 
> If this patch address any functional issue, then we should consider this.
> If it's code optimization, can we ignore this as this is being very old
> driver
> and no more maintained by Broadcom/LSI ?
>
Sadly, ignoring is not an option.
I'm planning to update the calling convention for SCSI EH, to resolve
the long-standing problem with sg_reset ioctls.
sg_reset ioctl will allocate an out-of-band SCSI command, which does no
longer work with the new command allocation scheme in multiqueue.
So it's not possible to just 'ignore' it, as then SCSI EH will cease to
function with that driver.

Sorry.

>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>> drivers/scsi/megaraid.c | 42 ++++++++++++++++--------------------------
>> 1 file changed, 16 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
>> 3c63c29..7e504d3 100644
>> --- a/drivers/scsi/megaraid.c
>> +++ b/drivers/scsi/megaraid.c
>> @@ -1909,7 +1909,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
>>
>> 	spin_lock_irq(&adapter->lock);
>>
>> -	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
>> +	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
> 
> If cmd=NULL is passed, it will crash inside function
> megaraid_abort_and_reset() while dereferencing "cmd" pointer.
> Below is the code of function  megaraid_abort_and_reset() where it will
> crash-
> 
> static int
> megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
> {
> 	struct list_head	*pos, *next;
> 	scb_t			*scb;
> 
> 	dev_warn(&adapter->dev->dev, "%s cmd=%x <c=%d t=%d l=%d>\n",
> 	     (aor == SCB_ABORT)? "ABORTING":"RESET",
> 	     cmd->cmnd[0],
> cmd->device->channel,>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>it should crash
> here
> 	     cmd->device->id, (u32)cmd->device->lun);
> 
> Please correct if I am missing something here.Ah, correct. Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
