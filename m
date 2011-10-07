From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] log unhandled scsi error and sense messages via
 SCSI_LOG
Date: Fri, 07 Oct 2011 13:23:28 -0500
Message-ID: <1318011808.5071.90.camel@dabdike.int.hansenpartnership.com>
References: <1318010370-26976-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42640 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab1JGSXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 14:23:31 -0400
In-Reply-To: <1318010370-26976-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de

On Fri, 2011-10-07 at 13:59 -0400, Rob Evers wrote:
> ---
>  drivers/scsi/scsi_lib.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fc3f168..9905e2f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -920,12 +920,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			action = ACTION_FAIL;
>  			break;
>  		default:
> -			description = "Unhandled sense code";
> +			SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
> +							   "Unhandled sense code\n"));
>  			action = ACTION_FAIL;
>  			break;
>  		}
>  	} else {
> -		description = "Unhandled error code";
> +		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
> +						   "Unhandled error code\n"));

I just don't understand the necessity of this.  We're going to fail the
command and we'd like someone to understand why.

Before this patch we print

sdX: Unhandled sense code
sdX: <sense information>
sdX: <command information>

Which hopefully causes someone to investigate what the actual problem
is.

If I apply this patch we're going to print

sdX: <sense information>
sdX: <command information>

Which is even less helpful.

If you're seeing some error or sense code that's causing a common retry,
then perhaps we should add it to the codes we check for instead of
trying to hide it?

James


