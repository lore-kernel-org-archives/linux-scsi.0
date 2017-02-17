From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 07/11] mpt3sas: check command status before attempting
 abort
Date: Fri, 17 Feb 2017 09:39:16 +0100
Message-ID: <2a53ebf7-c5b2-2169-d3c4-09691a6cca8f@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
 <1487319790-97340-8-git-send-email-hare@suse.de>
 <20170217083557.GB18443@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756070AbdBQIjT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:39:19 -0500
In-Reply-To: <20170217083557.GB18443@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/17/2017 09:35 AM, Christoph Hellwig wrote:
> On Fri, Feb 17, 2017 at 09:23:06AM +0100, Hannes Reinecke wrote:
>> When attempting a command abort we should check the command status
>> prior to sending the abort; the command might've been completed
>> already.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index a88f2ac..989cdc8 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -2261,6 +2261,12 @@ struct _sas_node *
>>  		return (!rc) ? SUCCESS : FAILED;
>>  	}
>>  
>> +	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
>> +		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
>> +		if (scsi_lookup->cb_idx == 0xFF)
>> +			return SUCCESS;
>> +	}
> 
> Not really new in this patch, but I'm worried that we don't check for
> a NULL return here.  Are we 100% sure no invalid smid can be passed in?
> 
The check for that is being added in path 09/11; should've moved it to here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
