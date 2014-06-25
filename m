From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
 messages.
Date: Wed, 25 Jun 2014 13:06:32 +0200
Message-ID: <20140625110632.GE19181@infradead.org>
References: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaFYLEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 07:04:15 -0400
Content-Disposition: inline
In-Reply-To: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@infradead.org

Can I get another review for this one?

On Fri, Jun 06, 2014 at 10:10:35AM +0200, Maurizio Lombardi wrote:
> During IO with fabric faults, one generally sees several "Unhandled error
> code" messages in the syslog as shown below:
> 
> sd 4:0:6:2: [sdbw] Unhandled error code
> sd 4:0:6:2: [sdbw] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 4:0:6:2: [sdbw] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
> end_request: I/O error, dev sdbw, sector 0
> 
> This comes from scsi_io_completion (in scsi_lib.c) while handling error
> codes other than DID_RESET or not deferred sense keys i.e. this is
> actually handled by the SCSI mid layer. But what gets displayed here is
> "Unhandled error code" which is quite misleading as it indicates
> something that is not addressed by the mid layer.
> 
> This patch removes "Unhandled error code" and replaces "Unhandled sense code"
> with "Failing command with sense code:".
> 
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9db097a..b3c25cd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -955,14 +955,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			action = ACTION_FAIL;
>  			break;
>  		default:
> -			description = "Unhandled sense code";
> +			description = "Failing command with sense code:";
>  			action = ACTION_FAIL;
>  			break;
>  		}
> -	} else {
> -		description = "Unhandled error code";
> +	} else
>  		action = ACTION_FAIL;
> -	}
>  
>  	if (action != ACTION_FAIL &&
>  	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
> -- 
> Maurizio Lombardi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
