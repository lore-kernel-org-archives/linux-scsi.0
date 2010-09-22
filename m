From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] tcm/pscsi: Add proper BIDI-COMMAND passthrough to
 SCSI MidLayer
Date: Wed, 22 Sep 2010 14:08:23 +0200
Message-ID: <4C99F1B7.4000806@panasas.com>
References: <1285135732-8350-1-git-send-email-nab@linux-iscsi.org>	 <4C99E4BC.5010301@panasas.com> <1285155525.1849.55.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285155525.1849.55.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 09/22/2010 01:38 PM, Nicholas A. Bellinger wrote:
> On Wed, 2010-09-22 at 13:13 +0200, Boaz Harrosh wrote:
>>
>> OK, I'm begining to suspect task->task_size is the size of what?
>> See below (below)
> 
> Btw task->task_size is to set to (task->task_sectors * block_size) in
> target_core_transport.c:transport_generic_get_cdb_count()
> 

Maybe you are confused by these XOR functions. But there is no
task->task_sectors, only for these TYPE_DISK pesky writes/reads

For general SCSI from tapes, scanners, printers to OSD There is
in_transfer_length and out_transfer_length. For READ_XXX/WRITE_XXX
these happen to be task->task_sectors.

<snip>

>>>  	return task->task_sg_num;
>>
>> OK Now I'm sure!
>> You have completely missed the fact that bidi entails two sg_list(s)
>> two sg_num(s) and two io_byte_count(s).
>>
>> The use of sg_table will clear that confusion a bit, though I wanted it
>> to carry an  io_byte_count as well, but never came to do that.
> 
> Hmmm, so this patch currently assumes that BIDI-COMMAND WRITE and extra
> READ payloads contain the same struct se_task->task_sg_num for both
> struct se_task->task_sg[] and struct se_task->task_sg_bidi[].
> 
> If we need to assume that the internally allocated (LIO-Target iSCSI)

There is no assumption they are completely separate (Even if they happen
to be the equal).

The fabric(s) know that. For pSCSI this comes in the scsi_in()->length
and the scsi_out()->length (and ->sg_count). For iscsi it has an rlenght
AHS header that tells it the transfer length of the bidi_read side.
In iSER and I think FB it is completely symmetrical like with the BSG
API. (Member for "in" and member for "out")

And so on. Each side is completely orthogonal to the other, in every
respect. (They might even execute in parallel)

> *or* pre-exiting SGL mapped T_TASK(cmd)->t_mem_list (TCM_Loop Virtual
> SCSI LLD) and T_TASK(cmd)->t_mem_bidi_list memory can be mapped
> differently, then an seperate second call to transport_calc_sg_num() in
> order to determine a struct se_task->task_sg_bidi_num is required.
> 

Perhaps it would be easier to do, if you convert to use of scsi_data_buffer
in current code. Then apply the double instance. You might also need a similar
mechanics for your ->t_mem_list and associated members. Group them together
then double the handling.

Down the road you'll need a third one for supporting DIFF

Boaz
>>
>>>  fail:
>>> @@ -1181,6 +1213,27 @@ fail:
>>>  	return ret;
>>>  }
>>>  
>>> +static int pscsi_map_task_SG(struct se_task *task)
>>> +{
>>> +	int ret;
>>> +	/*
>>> +	 * Setup the main struct request for the task->task_sg[] payload
>>> +	 */
>>> +
>>> +	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_num, 0);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	if (!(task->task_sg_bidi))
>>> +		return ret;
>>> +	/*
>>> +	 * If present, set up the extra BIDI-COMMAND SCSI READ
>>> +	 * struct request and payload.
>>> +	 */
>>> +	return __pscsi_map_task_SG(task, task->task_sg_bidi,
>>> +				task->task_sg_num, 1);
>>
>> What? the task->task_sg_bidi as the same sg_num as the above
>> task->task_sg. (See you should use sg_table to remove these
>> bugs.
>>
> 
> <nod>
> 
>> (I wrote this comment before I wrote the above one ;-))
>>
>>> +}
>>> +
>>>  /*	pscsi_map_task_non_SG():
>>>   *
>>>   *
>>> @@ -1438,6 +1491,12 @@ static void pscsi_req_done(struct request *req, int uptodate)
>>>  	pt->pscsi_resid = req->resid_len;
>>>  
>>>  	pscsi_process_SAM_status(task, pt);
>>> +
>>> +	if (req->next_rq != NULL) {
>>> +		__blk_put_request(req->q, req->next_rq);
>>
>> 		req->next_rq = NULL;
>>
>>> +		pt->pscsi_req_bidi = NULL;
>>> +	}
>>> +
>>>  	__blk_put_request(req->q, req);
>>>  	pt->pscsi_req = NULL;
>>>  }
>>> diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
>>> index 086e6f1..d3c8972 100644
>>> --- a/drivers/target/target_core_pscsi.h
>>> +++ b/drivers/target/target_core_pscsi.h
>>> @@ -34,6 +34,7 @@ struct pscsi_plugin_task {
>>>  	int	pscsi_result;
>>>  	u32	pscsi_resid;
>>>  	struct request *pscsi_req;
>>> +	struct request *pscsi_req_bidi;
>>
>> You don't really need to, you know. You have it right here at
>> pscsi_req->next_rq. But it's your call
> 
> OK, I will go ahead and drop this item.
> 
>>
>>>  } ____cacheline_aligned;
>>>  
>>>  #define PDF_HAS_CHANNEL_ID	0x01
>>
>> Cheers (life is hard)
>> Boaz
> 
> Many thanks Boaz!
> 
> --nab
> 
> 
