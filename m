From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3 version 2] scsi_lib: Collapse scsi_end_request into
 only user
Date: Mon, 04 Jan 2010 16:12:46 +0200
Message-ID: <4B41F75E.5010606@panasas.com>
References: <4B41DADD.4000102@panasas.com> <4B41DC42.1090706@panasas.com> <4B41F637.8070809@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:56366 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254Ab0ADOMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 09:12:50 -0500
In-Reply-To: <4B41F637.8070809@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/04/2010 04:07 PM, Boaz Harrosh wrote:
> 
> Embedding scsi_end_request() into scsi_io_completion actually simplifies the
> code and makes it clearer what's going on.
> 
> There is absolutely no functional and/or side effects changes after this patch.
> 
> Patch was inspired by Alan Stern. (version 2 comments by Matthew Wilcox)
> 

Matthew please check me out here. I want absolutely equivalent code. I think
Alan's mistake was to introduce enhancements together with cleanups.
The issue is with "error = -EIO" but since error is only used at blk_end_request_err
I think this approach is correct and is goto-less.

Thanks for reviewing

Boaz

> CC: Alan Stern <stern@rowland.harvard.edu>
> CC: Matthew Wilcox <matthew@wil.cx>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/scsi_lib.c |   90 +++++++++--------------------------------------
>  1 files changed, 17 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8d8b4eb..48ebc96 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -512,66 +512,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
>  		scsi_run_queue(sdev->request_queue);
>  }
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
> -				scsi_requeue_command(cmd);
> -				cmd = NULL;
> -			}
> -			return cmd;
> -		}
> -	}
> -
> -	cmd->request = NULL;
> -	/*
> -	 * This will goose the queue request function at the end, so we don't
> -	 * need to worry about launching another command.
> -	 */
> -	scsi_release_buffers(cmd);
> -	scsi_next_command(cmd);
> -	return NULL;
> -}
> -
>  static inline unsigned int scsi_sgtable_index(unsigned short nents)
>  {
>  	unsigned int index;
> @@ -704,7 +644,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	struct scsi_sense_hdr sshdr;
>  	int sense_valid = 0;
>  	int sense_deferred = 0;
> -	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
> +	enum {ACTION_FAIL, ACTION_REPREP, ACTION_NEXT_CMND, ACTION_RETRY,
>  	      ACTION_DELAYED_RETRY} action;
>  	char *description = NULL;
>  
> @@ -773,17 +713,17 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  		error = 0;
>  	}
>  
> -	/*
> -	 * A number of bytes were successfully read.  If there
> -	 * are leftovers and there is some kind of error
> -	 * (result != 0), retry the rest.
> -	 */
> -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> -		return;
> -
> -	error = -EIO;
> -
> -	if (host_byte(result) == DID_RESET) {
> +	if (likely(!blk_end_request(req, error, good_bytes))) {
> +		cmd->request = NULL;
> +		action = ACTION_NEXT_CMND;
> +	} else if (error && scsi_noretry_cmd(cmd)) {
> +		/* kill remainder if no retrys */
> +		blk_end_request_all(req, error);
> +		cmd->request = NULL;
> +		action = ACTION_NEXT_CMND;
> +	} else if (result == 0) {
> +		action = ACTION_REPREP;
> +	} else if (host_byte(result) == DID_RESET) {
>  		/* Third party bus reset or reset for error recovery
>  		 * reasons.  Just retry the command and see what
>  		 * happens.
> @@ -891,11 +831,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  				scsi_print_sense("", cmd);
>  			scsi_print_command(cmd);
>  		}
> -		if (blk_end_request_err(req, error))
> +		if (blk_end_request_err(req, error ? error : -EIO))
>  			scsi_requeue_command(cmd);
>  		else
>  			scsi_next_command(cmd);
>  		break;
> +	case ACTION_NEXT_CMND:
> +		scsi_release_buffers(cmd);
> +		scsi_next_command(cmd);
> +		break;
>  	case ACTION_REPREP:
>  		/* Unprep the request and put it back at the head of the queue.
>  		 * A new command will be prepared and issued.

