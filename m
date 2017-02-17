From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 08/11] mpt3sas: always use smid 1 for ioctl passthrough
Date: Fri, 17 Feb 2017 09:52:39 +0100
Message-ID: <10ad4384-46bc-17c5-a4b6-0989239162d0@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
 <1487319790-97340-9-git-send-email-hare@suse.de>
 <20170217084559.GC18443@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36961 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932090AbdBQIwm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:52:42 -0500
In-Reply-To: <20170217084559.GC18443@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/17/2017 09:45 AM, Christoph Hellwig wrote:
> On Fri, Feb 17, 2017 at 09:23:07AM +0100, Hannes Reinecke wrote:
>> ioctl passthrough commands require a SCSIIO smid, but cannot
>> easily integrate with the block layer. But as we're only ever
>> allowing one ioctl command at a time we can reserve smid 1
>> for ioctl commands.
> 
> I like the idea, but I don't think the implementation is correct.
> More below.
> 
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -2355,13 +2355,20 @@ struct scsiio_tracker *
>>  		return 0;
>>  	}
>>  
>> -	request = list_entry(ioc->free_list.next,
>> -	    struct scsiio_tracker, tracker_list);
>> -	request->scmd = scmd;
>> +	if (!scmd) {
>> +		/* ioctl command, always use the first slot */
>> +		request = ioc->lookup[0];
>> +		request->scmd = NULL;
>> +	} else {
>> +		request = list_entry(ioc->free_list.next,
>> +				     struct scsiio_tracker, tracker_list);
>> +		request->scmd = scmd;
>> +	}
>>  	request->cb_idx = cb_idx;
>>  	smid = request->smid;
>>  	request->msix_io = _base_get_msix_index(ioc);
>> -	list_del(&request->tracker_list);
>> +	if (scmd)
>> +		list_del(&request->tracker_list);
>>  	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
>>  	return smid;
> 
> The freelist check just before the patch context and the locking
> don't make much sense here.  I'd say just use a separate helper for the
> ioctl smid, ala:
> 
> u16
> mpt3sas_base_init_smid_pt(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
> {
> 	struct scsiio_tracker *request = ioc->lookup[0];
> 
> 	request->cb_idx = cb_idx;
> 	request->msix_io = _base_get_msix_index(ioc);
> 	return request->smid;
> }
> 
> or given how trivial this is just open-code it in the caller.
> 
> 
In principle, yes.
However, most of that is obsoleted when switching over to using reserved
commands in patch 11/11; then we properly register 'reserved' commands
with the block layer and this whole issue goes away.

>>  		ioc->scsi_lookup[i].cb_idx = 0xFF;
>>  		ioc->scsi_lookup[i].scmd = NULL;
>>  		ioc->scsi_lookup[i].direct_io = 0;
>> -		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
>> +		if (i > 0)
>> +			list_add(&ioc->scsi_lookup[i].tracker_list,
>> +				 &ioc->free_list);
> 
> Here we special case only request 0 as not added to the list.
> 
>> @@ -5165,14 +5174,17 @@ struct scsiio_tracker *
>>  	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
>>  	INIT_LIST_HEAD(&ioc->free_list);
>>  	smid = 1;
>> -	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
>> +	for (i = 1; i < ioc->scsiio_depth; i++, smid++) {
>>  		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
>>  		ioc->scsi_lookup[i].cb_idx = 0xFF;
>>  		ioc->scsi_lookup[i].smid = smid;
>>  		ioc->scsi_lookup[i].scmd = NULL;
>>  		ioc->scsi_lookup[i].direct_io = 0;
>> -		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
>> -		    &ioc->free_list);
>> +		if (i == 1)
>> +			INIT_LIST_HEAD(&ioc->lookup[i].tracker_list);
>> +		else
>> +			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
>> +				      &ioc->free_list);
> 
> And here we don't even iterate over smid 0, and then special case smid 1.
> 
> And note that the code in both loops is otherwise duplicated to start
> with and could realy use a little helper to initialize the scsiio_tracker
> structure.
> 
Again, most of that code will be obsoleted with patch 09/11, which
switches over to scsi-mq.
This whole code is just a band-aid until the driver is switched over to
scsi-mq, where we have correct allocation for reserved commands.
I just couldn't be bothered to implement reserved commands for legacy
sq, seeing that it'll be obsoleted at some point in the future anyway.

> Last but not least can_queue is initialized as:
> 
>         ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
> 
> which doesn't take this new stolen smid into account.
> 
Thing is, the internal commands are _never_ used anywhere, so
'can_queue' is actually still correct :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
