From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/9] scsi_dh: scsi handling of
	REQ_LB_OP_TRANSITION
Date: Fri, 01 Feb 2008 14:00:37 -0600
Message-ID: <47A37A65.8020500@cs.wisc.edu>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	<20080124003059.18871.89111.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080124003059.18871.89111.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: andmike@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> @@ -1445,9 +1479,24 @@ static void scsi_kill_request(struct req
>  static void scsi_softirq_done(struct request *rq)
>  {
>  	struct scsi_cmnd *cmd = rq->completion_data;
> -	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
>  	int disposition;
> +	struct request_queue *q;
> +	unsigned long wait_for, flags;
>  
> +	if (blk_linux_request(rq)) {
> +		q = rq->q;
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		/*
> +		 * we always return 1 and the caller should
> +		 * check rq->errors for the complete status
> +		 */
> +		end_that_request_last(rq, 1);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +		return;
> +	}
> +
> +
> +	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
>  	INIT_LIST_HEAD(&cmd->eh_entry);
>  
.....

> +
>  /*
>   * Function:    scsi_request_fn()
>   *
> @@ -1519,7 +1612,23 @@ static void scsi_request_fn(struct reque
>  		 * accept it.
>  		 */
>  		req = elv_next_request(q);
> -		if (!req || !scsi_dev_queue_ready(q, sdev))
> +		if (!req)
> +			break;
> +
> +		/*
> +		 * We do not account for linux blk req in the device
> +		 * or host busy accounting because it is not necessarily
> +		 * a scsi command that is sent to some object. The lower
> +		 * level can translate it into a request/scsi_cmnd, if
> +		 * necessary, and then queue that up using REQ_TYPE_BLOCK_PC.
> +		 */
> +		if (blk_linux_request(req)) {
> +			blkdev_dequeue_request(req);
> +			scsi_execute_blk_linux_cmd(req);
> +			continue;
> +		}
> +
> +		if (!scsi_dev_queue_ready(q, sdev))
>  			break;

I think these two pieces are one of the reasons I have not pushed the 
patches. I thought the completion and execution pieces here are a little 
ugly and seem to just wedge themselves in where they want to be.

Is there any way to make the insertion of non-scsi commands more common? 
Do we have the code for being able to send requests directly to 
something like a fc rport done? Could we maybe inject these special 
commands to the hw handler using something similar to how bsg would send 
non scsi commands to weird objects (objects like rport, sessions, and 
not devices we traditionally associated with queues like scsi_devices). 
Just a thought with no code :) that is why the ugly code existed still :)
