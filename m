From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: remove scsi_end_request
Date: Wed, 26 Feb 2014 08:12:16 -0800
Message-ID: <20140226161216.GA11703@infradead.org>
References: <20140226142321.GA14126@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBZQMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 11:12:17 -0500
Content-Disposition: inline
In-Reply-To: <20140226142321.GA14126@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

Turns out the bidi handling could cause a use after free in this
version, I'll respin it with a fix for that.

On Wed, Feb 26, 2014 at 06:23:21AM -0800, Christoph Hellwig wrote:
> By folding scsi_end_request into its only caller we can significantly clean
> up the completion logic.  We can use simple goto labels now to only have
> a single place to finish or requeue command there instead of the previous
> convoluted logic.
> 
> Note that the switch from __scsi_release_buffers without the bidi check
> argument to scsi_release_buffers is always correct as we handle bidi
> commands separately in scsi_io_completion and they never reach the path
> scsi_end_request was called from.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c |  119 +++++++++++++----------------------------------
>  1 file changed, 32 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 62ec84b..51063ca 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -540,66 +540,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
>  
>  static void __scsi_release_buffers(struct scsi_cmnd *, int);
>  
> -/*
> - * Function:    scsi_end_request()
> - *
> - * Purpose:     Post-processing of completed commands (usually invoked at end
> - *		of upper level post-processing and scsi_io_completion).
> - *
> - * Arguments:   cmd	 - command that is complete.
> - *              error    - 0 if I/O indicates success, < 0 for I/O error.
> - *              bytes    - number of bytes of completed I/O
> - *		requeue  - indicates whether we should requeue leftovers.
> - *
> - * Lock status: Assumed that lock is not held upon entry.
> - *
> - * Returns:     cmd if requeue required, NULL otherwise.
> - *
> - * Notes:       This is called for block device requests in order to
> - *              mark some number of sectors as complete.
> - * 
> - *		We are guaranteeing that the request queue will be goosed
> - *		at some point during this call.
> - * Notes:	If cmd was requeued, upon return it will be a stale pointer.
> - */
> -static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
> -					  int bytes, int requeue)
> -{
> -	struct request_queue *q = cmd->device->request_queue;
> -	struct request *req = cmd->request;
> -
> -	/*
> -	 * If there are blocks left over at the end, set up the command
> -	 * to queue the remainder of them.
> -	 */
> -	if (blk_end_request(req, error, bytes)) {
> -		/* kill remainder if no retrys */
> -		if (error && scsi_noretry_cmd(cmd))
> -			blk_end_request_all(req, error);
> -		else {
> -			if (requeue) {
> -				/*
> -				 * Bleah.  Leftovers again.  Stick the
> -				 * leftovers in the front of the
> -				 * queue, and goose the queue again.
> -				 */
> -				scsi_release_buffers(cmd);
> -				scsi_requeue_command(q, cmd);
> -				cmd = NULL;
> -			}
> -			return cmd;
> -		}
> -	}
> -
> -	/*
> -	 * This will goose the queue request function at the end, so we don't
> -	 * need to worry about launching another command.
> -	 */
> -	__scsi_release_buffers(cmd, 0);
> -	scsi_next_command(cmd);
> -	return NULL;
> -}
> -
>  static inline unsigned int scsi_sgtable_index(unsigned short nents)
>  {
>  	unsigned int index;
> @@ -751,16 +691,9 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
>   *
>   * Returns:     Nothing
>   *
> - * Notes:       This function is matched in terms of capabilities to
> - *              the function that created the scatter-gather list.
> - *              In other words, if there are no bounce buffers
> - *              (the normal case for most drivers), we don't need
> - *              the logic to deal with cleaning up afterwards.
> - *
> - *		We must call scsi_end_request().  This will finish off
> - *		the specified number of sectors.  If we are done, the
> - *		command block will be released and the queue function
> - *		will be goosed.  If we are not done then we have to
> + * Notes:       We will finish off the specified number of sectors.  If we
> + *		are done, the command block will be released and the queue
> + *		function will be goosed.  If we are not done then we have to
>   *		figure out what to do next:
>   *
>   *		a) We can call scsi_requeue_command().  The request
> @@ -769,7 +702,7 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
>   *		   be used if we made forward progress, or if we want
>   *		   to switch from READ(10) to READ(6) for example.
>   *
> - *		b) We can call scsi_queue_insert().  The request will
> + *		b) We can call __scsi_queue_insert().  The request will
>   *		   be put back on the queue and retried using the same
>   *		   command as before, possibly after a delay.
>   *
> @@ -824,12 +757,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			 * both sides at once.
>  			 */
>  			req->next_rq->resid_len = scsi_in(cmd)->resid;
> -
> -			scsi_release_buffers(cmd);
>  			blk_end_request_all(req, 0);
> -
> -			scsi_next_command(cmd);
> -			return;
> +			goto next_command;
>  		}
>  	}
>  
> @@ -865,12 +794,25 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	}
>  
>  	/*
> -	 * A number of bytes were successfully read.  If there
> -	 * are leftovers and there is some kind of error
> -	 * (result != 0), retry the rest.
> +	 * If we finished all bytes in the request we are done now.
>  	 */
> -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> -		return;
> +	if (!blk_end_request(req, error, good_bytes))
> +		goto next_command;
> +
> +	/*
> +	 * Kill remainder if no retrys.
> +	 */
> +	if (error && scsi_noretry_cmd(cmd)) {
> +		blk_end_request_all(req, error);
> +		goto next_command;
> +	}
> +
> +	/*
> +	 * If there had been no error, but we have leftover bytes in the
> +	 * requeues just queue the command up again.
> +	 */
> +	if (result == 0)
> +		goto requeue;
>  
>  	error = __scsi_error_from_host_byte(cmd, result);
>  
> @@ -992,7 +934,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	switch (action) {
>  	case ACTION_FAIL:
>  		/* Give up and fail the remainder of the request */
> -		scsi_release_buffers(cmd);
>  		if (!(req->cmd_flags & REQ_QUIET)) {
>  			if (description)
>  				scmd_printk(KERN_INFO, cmd, "%s\n",
> @@ -1002,12 +943,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  				scsi_print_sense("", cmd);
>  			scsi_print_command(cmd);
>  		}
> -		if (blk_end_request_err(req, error))
> -			scsi_requeue_command(q, cmd);
> -		else
> -			scsi_next_command(cmd);
> -		break;
> +		if (!blk_end_request_err(req, error))
> +			goto next_command;
> +		/*FALLTHRU*/
>  	case ACTION_REPREP:
> +	requeue:
>  		/* Unprep the request and put it back at the head of the queue.
>  		 * A new command will be prepared and issued.
>  		 */
> @@ -1023,6 +963,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
>  		break;
>  	}
> +	return;
> +
> +next_command:
> +	scsi_release_buffers(cmd);
> +	scsi_next_command(cmd);
>  }
>  
>  static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
