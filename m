From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv2 11/11] mpt3sas: register reserved commands
Date: Fri, 17 Feb 2017 14:18:42 +0100
Message-ID: <27251371-a96e-11c9-a1ce-cfb2b53f5454@suse.com>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
 <1487319790-97340-12-git-send-email-hare@suse.de>
 <20170217123859.GB23739@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:33317 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933787AbdBQNSq (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 17 Feb 2017 08:18:46 -0500
In-Reply-To: <20170217123859.GB23739@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org

On 02/17/2017 01:38 PM, Christoph Hellwig wrote:
> On Fri, Feb 17, 2017 at 09:23:10AM +0100, Hannes Reinecke wrote:
>> The mpt3sas driver requires a reserved command space to handle
>> SCSI passthrough commands.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index e9470a3..97189ad 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -2360,6 +2360,8 @@ struct scsiio_tracker *
>>  	} else {
>>  		u32 unique_tag = blk_mq_unique_tag(scmd->request);
>>  		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
>> +
>> +		WARN_ON(tag < ioc->shost->reserved_cmds);
>>  		request = scsi_cmd_priv(scmd);
>>  		smid = tag + 1;
>>  	}
>> @@ -3521,7 +3523,8 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>>  	/* set the scsi host can_queue depth
>>  	 * with some internal commands that could be outstanding
>>  	 */
>> -	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
>> +	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
>> +	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;
> 
> You're never allocating a reserved request.  Just remove the number of
> reserved cmds from can_queue and you can use them on your own.
> 
> So I don't think you'll actually need to use reserved request here,
> but instead you should set up can_queue properly earlier in the series.
> 
Well, once I'm switching over to embedded commands I'll have to
integrate with SCSI midlayer to actually _allocate_ the tracker
structure for me.
At the same time the midlayer should _not_ use that structure for normal
I/O; which sounds suspiciously like reserved commands to me ...
Oh well; guess I'll have to do it, then.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
