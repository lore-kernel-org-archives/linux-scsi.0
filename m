From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: correct use of cmd->timeout field
Date: Mon, 8 Aug 2005 08:03:21 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01800B35@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36510 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750833AbVHHMF3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 08:05:29 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James' patch is fine!

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Mark Haverkamp [mailto:markh@osdl.org] 
Sent: Friday, August 05, 2005 5:45 PM
To: James Bottomley
Cc: Salyzyn, Mark; SCSI Mailing List
Subject: Re: [PATCH] aacraid: correct use of cmd->timeout field

On Fri, 2005-08-05 at 16:31 -0500, James Bottomley wrote:
> The cmd->timeout field has been obsolete for a while now.  While
looking
> to remove it, I came across this use in the aacraid driver.  It looks
> like you want to initialise the firmware with the current timeout of
the
> command (in seconds), so the value I think you should be using is cmd-
> >timeout_per_command.

It looks that way to me too.   Is scsicmd->timeout even set anywhere? I
didn't find any.

Mark.

> 
> James
> 
> diff --git a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c
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

