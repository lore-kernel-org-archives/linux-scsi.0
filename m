From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] megaraid bad queuecommand return
Date: Fri, 19 Nov 2004 13:17:06 +0100
Message-ID: <20041119121706.GZ26240@suse.de>
References: <20041119085341.GY26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:60322 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261384AbUKSMRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 07:17:36 -0500
Content-Disposition: inline
In-Reply-To: <20041119085341.GY26240@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, Nov 19 2004, Jens Axboe wrote:
> Hi,
> 
> In case of scb allocation failure, mega_build_cmd() can return NULL scb
> but set busy, which causes a non-zero return from ->queuecommand() while
> the scsi command has been completed. Flagging error and calling done
> should be enough for appropriate retries.

Of course the other way around for this particular patch - just return
busy and let the mid layer handle it, but make sure not to call done()
first.

> Signed-off-by: Jens Axboe <axboe@suse.de>
> 
> ===== drivers/scsi/megaraid.c 1.73 vs edited =====
> --- 1.73/drivers/scsi/megaraid.c	2004-11-11 09:43:34 +01:00
> +++ edited/drivers/scsi/megaraid.c	2004-11-19 09:03:43 +01:00
> @@ -634,11 +634,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
>  			}
>  
>  			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -
> -				cmd->result = (DID_ERROR << 16);
> -				cmd->scsi_done(cmd);
>  				*busy = 1;
> -
>  				return NULL;
>  			}
>  
> @@ -677,11 +673,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
>  
>  			/* Allocate a SCB and initialize passthru */
>  			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -
> -				cmd->result = (DID_ERROR << 16);
> -				cmd->scsi_done(cmd);
>  				*busy = 1;
> -
>  				return NULL;
>  			}
>  			pthru = scb->pthru;
> @@ -723,11 +715,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
>  
>  			/* Allocate a SCB and initialize mailbox */
>  			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -
> -				cmd->result = (DID_ERROR << 16);
> -				cmd->scsi_done(cmd);
>  				*busy = 1;
> -
>  				return NULL;
>  			}
>  			mbox = (mbox_t *)scb->raw_mbox;
> @@ -867,11 +855,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
>  
>  			/* Allocate a SCB and initialize mailbox */
>  			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -
> -				cmd->result = (DID_ERROR << 16);
> -				cmd->scsi_done(cmd);
>  				*busy = 1;
> -
>  				return NULL;
>  			}
>  
> @@ -899,11 +883,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
>  	else {
>  		/* Allocate a SCB and initialize passthru */
>  		if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -
> -			cmd->result = (DID_ERROR << 16);
> -			cmd->scsi_done(cmd);
>  			*busy = 1;
> -
>  			return NULL;
>  		}
>  
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Jens Axboe

