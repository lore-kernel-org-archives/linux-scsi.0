From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 21/26] scsi: simplify scsi_log_(send|completion)
Date: Wed, 8 Oct 2014 20:41:37 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CDC959@G4W3202.americas.hpqcorp.net>
References: <1412672605-42868-1-git-send-email-hare@suse.de>
 <1412672605-42868-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38364 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaJHUm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2014 16:42:56 -0400
In-Reply-To: <1412672605-42868-22-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, 07 October, 2014 4:03 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCH 21/26] scsi: simplify scsi_log_(send|completion)
> 
> Simplify scsi_log_(send|completion) by externalizing
> scsi_mlreturn_string() and always print the command address.
> 
...

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b853659..2df485f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -831,7 +831,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned
> int good_bytes)
>  	int error = 0;
>  	struct scsi_sense_hdr sshdr;
>  	bool sense_valid = false;
> -	int sense_deferred = 0;
> +	int sense_deferred = 0, level = 0;
>  	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>  	      ACTION_DELAYED_RETRY} action;
>  	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
> @@ -1037,8 +1037,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
>  	switch (action) {
>  	case ACTION_FAIL:
>  		/* Give up and fail the remainder of the request */
> -		if (!(req->cmd_flags & REQ_QUIET)) {
> -			scsi_print_result(cmd);
> +		if (unlikely(scsi_logging_level))
> +			level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
> +					       SCSI_LOG_MLQUEUE_BITS);

scsi_log_completion prints based on SCSI_LOG_MLCOMPLETE,
not SCSI_LOG_MLQUEUE, so this is not accomplishing what
the next comment says.

> +		/*
> +		 * if logging is enabled the failure will be printed
> +		 * in scsi_log_completion(), so avoid duplicate messages
> +		 */
> +		if (!level && !(req->cmd_flags & REQ_QUIET)) {
> +			scsi_print_result(cmd, NULL, FAILED);
>  			if (driver_byte(result) & DRIVER_SENSE)
>  				scsi_print_sense(cmd);
>  			scsi_print_command(cmd);

This still results in prints on every completion with ACTION_FAIL.  
Since they're not ratelimited, the massive number of prints after
a device failure under heavy load causes other timeouts.  Since
the block layer also prints errors, with ratelimiting, these are
not really necessary (although they're more informative than the
block layer prints).  There needs to be a way to turn these off,
both in scsi_log_completion and here - maybe different MLCOMPLETE
levels?

The issue will be mitigated if the next patch series makes these
ratelimited.


---
Rob Elliott    HP Server Storage



