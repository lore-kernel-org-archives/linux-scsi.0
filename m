From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Correct tag initialisation for commands
Date: Fri, 19 Oct 2007 12:59:38 -0500
Message-ID: <4718F08A.7010805@cs.wisc.edu>
References: <4718AFD7.5000203@suse.de> <4718F000.6020104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42164 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765074AbXJSR7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 13:59:47 -0400
In-Reply-To: <4718F000.6020104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Hannes Reinecke wrote:
>> Hi all,
>>
>> currently the initialisation of scmd->tag seems to be wrong.
>> We have this lines from scsi_lib.c:scsi_get_cmd_from_req():
>>
>>     /* pull a tag out of the request if we have one */
>>     cmd->tag = req->tag;
>>
>> which are supposed to fill the tag value for a given command.
>> However, the function is called from the ->prep_fn callback,
>> invoked from elv_next_request() in scsi_request_fn().
>>
>> In scsi_request_fn() we have:
>>
>>     req = elv_next_request(q);
>>     if (!req || !scsi_dev_queue_ready(q, sdev))
>>         break;
>>
>>     if (unlikely(!scsi_device_online(sdev))) {
>>         sdev_printk(KERN_ERR, sdev,
>>                 "rejecting I/O to offline device\n");
>>         scsi_kill_request(req, q);
>>         continue;
>>     }
>>
>>     /*
>>      * Remove the request from the request list.
>>      */
>>     if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
>>         blkdev_dequeue_request(req);
>>
>> ie the value of rq->tag is filled _after it has been copied
>> to scmd->tag.
>>
>> A proposed patch would be:
>>
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1055,8 +1055,6 @@ static struct scsi_cmnd 
>> *scsi_get_cmd_from_req(struct scsi_device *sdev,
>>          cmd = req->special;
>>      }
>>  
>> -    /* pull a tag out of the request if we have one */
>> -    cmd->tag = req->tag;
>>      cmd->request = req;
>>  
>>      return cmd;
>> @@ -1445,6 +1443,9 @@ static void scsi_request_fn(struct request_queue 
>> *q)
>>              blk_dump_rq_flags(req, "foo");
>>              BUG();
>>          }
>> +        /* pull a tag out of the request if we have one */
>> +        cmd->tag = req->tag;
>> +
>>          spin_lock(shost->host_lock);
>>  
>>          if (!scsi_host_queue_ready(q, shost, sdev))
>>
>> Comments?
>>
> 
> I saw that while working on qla4xxx. I think the reason no one ever 
> complained before is because of how most drivers use the tags. Was there 
> some driver accesing the scsi cmd tag value?

Ignore that question. I forgot about your other patch.
