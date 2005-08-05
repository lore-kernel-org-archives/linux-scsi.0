From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid: correct use of cmd->timeout field
Date: Fri, 05 Aug 2005 14:45:03 -0700
Message-ID: <1123278303.6548.16.camel@markh1.pdx.osdl.net>
References: <1123277495.5003.77.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15232 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261962AbVHEVpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 17:45:06 -0400
In-Reply-To: <1123277495.5003.77.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-05 at 16:31 -0500, James Bottomley wrote:
> The cmd->timeout field has been obsolete for a while now.  While looking
> to remove it, I came across this use in the aacraid driver.  It looks
> like you want to initialise the firmware with the current timeout of the
> command (in seconds), so the value I think you should be using is cmd-
> >timeout_per_command.

It looks that way to me too.   Is scsicmd->timeout even set anywhere? I
didn't find any.

Mark.

> 
> James
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1894,7 +1893,7 @@ static int aac_send_srb_fib(struct scsi_
>  	srbcmd->id   = cpu_to_le32(scsicmd->device->id);
>  	srbcmd->lun      = cpu_to_le32(scsicmd->device->lun);
>  	srbcmd->flags    = cpu_to_le32(flag);
> -	timeout = (scsicmd->timeout-jiffies)/HZ;
> +	timeout = scsicmd->timeout_per_command/HZ;
>  	if(timeout == 0){
>  		timeout = 1;
>  	}
> 
-- 
Mark Haverkamp <markh@osdl.org>

