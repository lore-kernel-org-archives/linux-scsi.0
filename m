From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 10/10] mpt3sas: lockless command submission for scsi-mq
Date: Tue, 21 Feb 2017 15:58:08 +0100
Message-ID: <77d6469d-1e96-3136-2753-2dcf1aed989c@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
 <1487680029-3701-11-git-send-email-hare@suse.de>
 <20170221143437.GC27251@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753092AbdBUO6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 09:58:11 -0500
In-Reply-To: <20170221143437.GC27251@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 02/21/2017 03:34 PM, Christoph Hellwig wrote:
> On Tue, Feb 21, 2017 at 01:27:09PM +0100, Hannes Reinecke wrote:
>> Enable lockless command submission for scsi-mq by moving the
>> command structure into the payload for struct request.
> 
> No dependency on scsi-mq, so the changelog could use a little update.
> 
>> @@ -2345,26 +2354,22 @@ struct scsiio_tracker *
>>  mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
>>  	struct scsi_cmnd *scmd)
>>  {
>> +	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
>> +	unsigned int tag;
>>  	u16 smid;
>>  
>> +	if (ioc->shost->use_blk_mq) {
>> +		u32 unique_tag = blk_mq_unique_tag(scmd->request);
>> +
>> +		tag = blk_mq_unique_tag_to_tag(unique_tag);
>> +	} else
>> +		tag = scmd->request->tag;
> 
> All that unique_tag stuff is only required for SCSI LLDDs that
> set nr_hw_queues > 1, which isn't the ase with this patch.
> 
Abstraction.
I would not presume anything about SCSI-MQ/block-mq here; calling
blk_mq_unique_tag() insulates me against any changes blk-mq might be
doing for the tag allocation or management.

>>   * @ioc: per adapter object
>> @@ -2423,23 +2444,21 @@ struct scsiio_tracker *
>>  	unsigned long flags;
>>  	int i;
>>  
>>  	if (smid < ioc->hi_priority_smid) {
>> +		struct scsiio_tracker *st;
>>  
>> +		st = mpt3sas_get_st_from_smid(ioc, smid);
>> +		if (WARN_ON(!st)) {
>> +			_base_recovery_check(ioc);
>> +			return;
>> +		}
>> +		mpt3sas_base_clear_st(ioc, st);
>>  		_base_recovery_check(ioc);
>>  		return;
> 
> This looks fine, but it would be good if could derive the scsiio_tracker
> structure from the scsi_cmnd in as many as possible places, most notably
> all the fast path calls and then just clal mpt3sas_base_clear_st directly.
> 
Okay, will be revisiting that.

>> +	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
> 
> Why?  You're never calling the block layer to allocate a reserved
> request.
> 
The idea was to have a stub command for any ioctl passthrough commands,
so they'll show up when traversing the list of active commands (hence it
always uses 'scsiio_depth' and not 'can_queue').
But it might be that we're not setting the scsiio_tracker for ioctl
passthrough commands; will be checking.

>> +	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;
> 
> Just assign ioc->shost->can_queue to ioc->scsiio_depth -
> INTERNAL_SCSIIO_CMDS_COUNT directly.
> 
Okay.

>> +	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
>> +		struct scsiio_tracker *st;
>>  
>> +		st = mpt3sas_get_st_from_smid(ioc, smid);
>> +		if (st->cb_idx != 0xFF)
>> +			ioc->pending_io_count++;
>> +	}
> 
> How is this different from ioc->host->host_busy (except for maybe
> the ioctl smid).
> 
This is just a plain conversion from the existing code; but yes, one
could be using host_busy here.

>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>> index 23e0ef1..bcc6a51 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>> @@ -563,11 +563,10 @@ enum block_state {
>>  	Mpi2SCSITaskManagementRequest_t *tm_request)
>>  {
>>  	u8 found = 0;
>> -	u16 i;
>> +	u16 smid;
>>  	u16 handle;
>>  	struct scsi_cmnd *scmd;
>>  	struct MPT3SAS_DEVICE *priv_data;
>> -	unsigned long flags;
>>  	Mpi2SCSITaskManagementReply_t *tm_reply;
>>  	u32 sz;
>>  	u32 lun;
>> @@ -583,11 +582,11 @@ enum block_state {
>>  	lun = scsilun_to_int((struct scsi_lun *)tm_request->LUN);
>>  
>>  	handle = le16_to_cpu(tm_request->DevHandle);
>> -	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
>> -	for (i = ioc->scsiio_depth; i && !found; i--) {
>> -		scmd = ioc->scsi_lookup[i - 1].scmd;
>> -		if (scmd == NULL || scmd->device == NULL ||
>> -		    scmd->device->hostdata == NULL)
>> +	for (smid = ioc->scsiio_depth; smid && !found; smid--) {
>> +		struct scsiio_tracker *st;
>> +
>> +		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>> +		if (!scmd)
>>  			continue;
>>  		if (lun != scmd->device->lun)
>>  			continue;
>> @@ -596,10 +595,10 @@ enum block_state {
>>  			continue;
>>  		if (priv_data->sas_target->handle != handle)
>>  			continue;
>> -		tm_request->TaskMID = cpu_to_le16(ioc->scsi_lookup[i - 1].smid);
>> +		st = scsi_cmd_priv(scmd);
>> +		tm_request->TaskMID = cpu_to_le16(st->smid);
>>  		found = 1;
>>  	}
>> -	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> 
> This looks like you're keeping the existing behavior, but can someone
> please explain why we need to find a random used smid here?  Whatever
> requests is using the smid could be completed at any point in time,
> so this whole loop looks rather bogus both in the old and new version.
> a
> 
And so it is.
The whole concept of ABORT TASK ioctl is patently bogus; the caller has
_no_ idea about the tag to abort, so it just fetches the first busy command.

I surely think that this should go, but I have no idea what any
management tools might be doing, so I've kept existing behaviour.

>> +		if (ioc->shost->use_blk_mq)
>> +			smid = 1;
>> +		else
>> +			smid = ioc->scsiio_depth - ioc->shost->reserved_cmds;
> 
> Huh?  Explanation, please.
> 
When enabling reserved tags with blk-mq the reserved tag range is at the
start of the tagspace; for legacy sq there is no reserved range, but
'can_queue' is reduced by the number of reserved commands, effectively
locating the reserved tag range at the end of the tag space.

>> @@ -1146,22 +1101,21 @@ struct _sas_node *
>>  _scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
>>  	int channel)
>>  {
>> +	u8 found = 0;
>> +	u16 smid;
>>  
>> +	for (smid = 1; smid  <= ioc->scsiio_depth; smid++) {
>> +		struct scsi_cmnd *scmd;
>> +
>> +		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>> +		if (!scmd)
>> +			continue;
>> +		if (scmd->device->id == id &&
>> +		    scmd->device->channel == channel) {
>>  			found = 1;
>> +			break;
>>  		}
>>  	}
>>  	return found;
>>  }
> 
> This looks ok, but I'd really like to understand what the hell
> the original code is trying to do here.
> 
Figuring out if there are still pending commands on the given target.

>>  
>> @@ -1180,23 +1134,22 @@ struct _sas_node *
>>  _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
>>  	unsigned int lun, int channel)
>>  {
>> +	u8 found = 0;
>> +	u16 smid;
>>  
>> +	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
>> +		struct scsi_cmnd *scmd;
>> +
>> +		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>> +		if (!scmd)
>> +			continue;
>> +		if (scmd->device->id == id &&
>> +		    scmd->device->channel == channel &&
>> +		    scmd->device->lun == lun) {
>>  			found = 1;
>> +			break;
>>  		}
>>  	}
>>  	return found;
>>  }
> 
> .. and here
> 
Figuring out if there are pending commands on that LUN.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
