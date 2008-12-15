From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Fix uninitialized variable error in scsi_io_completion
Date: Mon, 15 Dec 2008 17:46:03 +0200
Message-ID: <49467BBB.4070002@panasas.com>
References: <Pine.LNX.4.44L0.0812151026100.2525-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:27272 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbYLOPqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 10:46:10 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812151026100.2525-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> This patch (as1191) adds a missing "default" case in
> scsi_io_completion(), thereby fixing an "uninitialized variable"
> error.  It also adds a missing newline to a log entry.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> James, I'm shocked!  :-)   Didn't you ever try to compile your changes 
> to this routine?
> 
> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> +++ usb-2.6/drivers/scsi/scsi_lib.c
> @@ -1024,6 +1024,10 @@ void scsi_io_completion(struct scsi_cmnd
>  				case 0x09: /* self test in progress */
>  					action = ACTION_DELAYED_RETRY;
>  					break;
> +				default:
> +					description = "Device not ready";
> +					action = ACTION_FAIL;
> +					break;
>  				}
>  			} else {
>  				description = "Device not ready";
> @@ -1049,7 +1053,7 @@ void scsi_io_completion(struct scsi_cmnd
>  		/* Give up and fail the remainder of the request */
>  		if (!(req->cmd_flags & REQ_QUIET)) {
>  			if (description)
> -				scmd_printk(KERN_INFO, cmd, "%s",
> +				scmd_printk(KERN_INFO, cmd, "%s\n",
>  					    description);
>  			scsi_print_result(cmd);
>  			if (driver_byte(result) & DRIVER_SENSE)
> 
> --

Good catch, I saw the warning but failed to see the missing case.
I attributed it to my brain dead gcc version.

Boaz
 
