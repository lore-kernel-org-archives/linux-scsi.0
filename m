From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Correct tag initialisation for commands
Date: Fri, 19 Oct 2007 12:57:20 -0500
Message-ID: <4718F000.6020104@cs.wisc.edu>
References: <4718AFD7.5000203@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42157 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbXJSR53 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 13:57:29 -0400
In-Reply-To: <4718AFD7.5000203@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> Hi all,
> 
> currently the initialisation of scmd->tag seems to be wrong.
> We have this lines from scsi_lib.c:scsi_get_cmd_from_req():
> 
> 	/* pull a tag out of the request if we have one */
> 	cmd->tag = req->tag;
> 
> which are supposed to fill the tag value for a given command.
> However, the function is called from the ->prep_fn callback,
> invoked from elv_next_request() in scsi_request_fn().
> 
> In scsi_request_fn() we have:
> 
> 	req = elv_next_request(q);
> 	if (!req || !scsi_dev_queue_ready(q, sdev))
> 		break;
> 
> 	if (unlikely(!scsi_device_online(sdev))) {
> 		sdev_printk(KERN_ERR, sdev,
> 			    "rejecting I/O to offline device\n");
> 		scsi_kill_request(req, q);
> 		continue;
> 	}
> 
> 	/*
> 	 * Remove the request from the request list.
> 	 */
> 	if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
> 		blkdev_dequeue_request(req);
> 
> ie the value of rq->tag is filled _after it has been copied
> to scmd->tag.
> 
> A proposed patch would be:
> 
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1055,8 +1055,6 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
>  		cmd = req->special;
>  	}
>  
> -	/* pull a tag out of the request if we have one */
> -	cmd->tag = req->tag;
>  	cmd->request = req;
>  
>  	return cmd;
> @@ -1445,6 +1443,9 @@ static void scsi_request_fn(struct request_queue *q)
>  			blk_dump_rq_flags(req, "foo");
>  			BUG();
>  		}
> +		/* pull a tag out of the request if we have one */
> +		cmd->tag = req->tag;
> +
>  		spin_lock(shost->host_lock);
>  
>  		if (!scsi_host_queue_ready(q, shost, sdev))
> 
> Comments?
> 

I saw that while working on qla4xxx. I think the reason no one ever 
complained before is because of how most drivers use the tags. Was there 
some driver accesing the scsi cmd tag value?

qla4xxx and other drivers, if I remember drivers like ipr and qla2xxx, 
never access scsi_cmd->tag. Instead they use scsi_find_tag to go from a 
tag to a command or they use scsi_populate_tag_msg to get the MSG_* bits.

If every ones uses the scsi_tcq wrappers, maybe the scsi_cmnd->tag field 
would be something that could be deleted and help Mathew's goals to 
shrink the struct.

If not your patch looks ok, but maybe we could convert to using the 
wrappers since it does not seem that there is a good reason to duplicate 
the tag now that every scsi command has proper request backing.
