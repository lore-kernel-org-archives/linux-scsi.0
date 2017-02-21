From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 09/10] mpt3sas: always use first reserved smid for ioctl
 passthrough
Date: Tue, 21 Feb 2017 15:45:49 +0100
Message-ID: <4ba18a25-eee5-aa57-4492-e4386aae675b@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
 <1487680029-3701-10-git-send-email-hare@suse.de>
 <20170221141801.GB27251@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44941 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752540AbdBUOpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 09:45:52 -0500
In-Reply-To: <20170221141801.GB27251@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 02/21/2017 03:18 PM, Christoph Hellwig wrote:
> On Tue, Feb 21, 2017 at 01:27:08PM +0100, Hannes Reinecke wrote:
>> ioctl passthrough commands require a SCSIIO smid, but cannot
>> easily integrate with the block layer. But the driver already
>> has reserved some SCSIIO smids and we're only ever allowing
>> one ioctl command at a time we can use the first reserved smid
>> for ioctl commands.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 11 ++++++++---
>>  drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 10 ++--------
>>  2 files changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 3f9148c..0875e58 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -2432,7 +2432,9 @@ struct scsiio_tracker *
>>  		ioc->scsi_lookup[i].cb_idx = 0xFF;
>>  		ioc->scsi_lookup[i].scmd = NULL;
>>  		ioc->scsi_lookup[i].direct_io = 0;
>> -		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
>> +		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
>> +			list_add(&ioc->scsi_lookup[i].tracker_list,
>> +				 &ioc->free_list);
>>  		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
>>  
>>  		_base_recovery_check(ioc);
>> @@ -5174,8 +5176,11 @@ struct scsiio_tracker *
>>  		ioc->scsi_lookup[i].smid = smid;
>>  		ioc->scsi_lookup[i].scmd = NULL;
>>  		ioc->scsi_lookup[i].direct_io = 0;
>> -		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
>> -		    &ioc->free_list);
>> +		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
>> +			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
>> +				      &ioc->free_list);
>> +		else
>> +			INIT_LIST_HEAD(&ioc->lookup[i].tracker_list);
> 
> Why the INIT_LIST_HEAD?  We never do a list_empty check on tracker_list,
> so it's rather pointless.
> 
Okay.

>> +		smid = ioc->scsiio_depth - ioc->host->reserved_cmds;
> 
> ioc->host->reserved_cmds is never set at this point.  But given that only
> the smids < ioc->scsiio_depth are used it's doing the right thing
> if you just remove the "- ioc->host->reserved_cmds" entirely.
> 
Not quite; then it'll clash with the hi-priority smids which are
allocated after that.
But I can be using ioc->scsio_depth - INTERNAL_SCSIIO_CMDS_COUNT here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
