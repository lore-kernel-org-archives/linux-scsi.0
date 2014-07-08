From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 03/14] scsi: centralize command re-queueing in
 scsi_dispatch_fn
Date: Tue, 8 Jul 2014 20:51:30 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B922D2@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <1403715121-1201-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-4-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Wednesday, 25 June, 2014 11:52 AM
> To: James Bottomley
> Cc: Jens Axboe; Bart Van Assche; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 03/14] scsi: centralize command re-queueing in
> scsi_dispatch_fn
> 
> Make sure we only have the logic for requeing commands in one place.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c     |   35 ++++++++++++-----------------------
>  drivers/scsi/scsi_lib.c |    9 ++++++---
>  2 files changed, 18 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ce5b4e5..dcc43fd 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -648,9 +648,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  		 * returns an immediate error upwards, and signals
>  		 * that the device is no longer present */
>  		cmd->result = DID_NO_CONNECT << 16;
> -		scsi_done(cmd);
> -		/* return 0 (because the command has been processed) */
> -		goto out;
> +		goto done;
>  	}
> 
>  	/* Check to see if the scsi lld made this device blocked. */
> @@ -662,17 +660,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  		 * occur until the device transitions out of the
>  		 * suspend state.
>  		 */
> -
> -		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> -
>  		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>  			"queuecommand : device blocked\n"));
> -
> -		/*
> -		 * NOTE: rtn is still zero here because we don't need the
> -		 * queue to be plugged on return (it's already stopped)
> -		 */
> -		goto out;
> +		return SCSI_MLQUEUE_DEVICE_BUSY;
>  	}
> 
>  	/*
> @@ -696,20 +686,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  			       "cdb_size=%d host->max_cmd_len=%d\n",
>  			       cmd->cmd_len, cmd->device->host->max_cmd_len));
>  		cmd->result = (DID_ABORT << 16);
> -
> -		scsi_done(cmd);
> -		goto out;
> +		goto done;
>  	}
> 
>  	if (unlikely(host->shost_state == SHOST_DEL)) {
>  		cmd->result = (DID_NO_CONNECT << 16);
> -		scsi_done(cmd);
> -	} else {
> -		trace_scsi_dispatch_cmd_start(cmd);
> -		cmd->scsi_done = scsi_done;
> -		rtn = host->hostt->queuecommand(host, cmd);
> +		goto done;
> +
>  	}
> 
> +	trace_scsi_dispatch_cmd_start(cmd);
> +
> +	cmd->scsi_done = scsi_done;
> +	rtn = host->hostt->queuecommand(host, cmd);
>  	if (rtn) {
>  		trace_scsi_dispatch_cmd_error(cmd, rtn);
>  		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> @@ -718,12 +707,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> 
>  		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>  			"queuecommand : request rejected\n"));
> -
> -		scsi_queue_insert(cmd, rtn);
>  	}
> 
> - out:
>  	return rtn;
> + done:
> +	scsi_done(cmd);
> +	return 0;
>  }
> 

Related to the position of the trace_scsi_dispatch_cmd_start()
call... this function does:

1. check sdev_state - goto done
2. check scsi_device_blocked() - return
3. put LUN into CDB for ancient SCSI-1 devices
4. scsi_log_send()
5. check cmd_len - goto done
6. check shost_state - goto done
7. trace_scsi_dispatch_cmd_start()
8. queuecommand()
9. return
10. done:
	cmd->scsi_done(cmd)  [PATCH 04/14 upgrades it to this]
	return 0;

It's inconsistent for logging and tracing to occur after 
different number of checks.

In scsi_lib.c, both scsi_done() and scsi_mq_done() always call
trace_scsi_dispatch_cmd_done(), so trace_scsi_dispatch_cmd_start()
should be called before scsi_done() is called.  That way the
trace will always have a submission to match each completion.

That means trace should be called before the sdev_state check 
(which calls scsi_done()).  

I don't know about the scsi_device_blocked check (which just 
returns).  Should the trace record multiple submissions with 
one completion?  Maybe both trace_scsi_dispatch_cmd_start() 
and trace_scsi_dispatch_cmd_done() should both be called?

scsi_log_completion() is called by scsi_softirq_done() and
scsi_times_out() but not by scsi_done() and scsi_mq_done(), so 
scsi_log_send() should not be called unless all the checks 
pass and an IO is really queued.

That would lead to something like:
1. check sdev_state - goto done
2. check scsi_device_blocked() - return
3. put LUN into CDB for ancient SCSI-1 devices
5. check cmd_len - goto done
6. check shost_state - goto done
7a. scsi_log_send()
7b. trace_scsi_dispatch_cmd_start()
8. queuecommand()
9. return
10. done:
	trace_scsi_dispatch_cmd_start()
	cmd->scsi_done(cmd);
	return 0;

---
Rob Elliott    HP Server Storage
