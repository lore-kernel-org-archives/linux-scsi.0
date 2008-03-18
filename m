From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] gdth: Use scsi_get_command for gdth internal commands
Date: Tue, 18 Mar 2008 13:54:39 -0500
Message-ID: <1205866479.2900.12.camel@localhost.localdomain>
References: <47E00779.3000701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52633 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbYCSTYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:47 -0400
In-Reply-To: <47E00779.3000701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sven Schnelle <svens@bitebene.org>

On Tue, 2008-03-18 at 20:18 +0200, Boaz Harrosh wrote:
> This is for for the next kernel window (v2.6.26). It is based on top of
> both scsi-misc and scsi-rc-fixes. Once scsi-misc rebases to scsi-rc-fixes
> this patch can be committed.
> 
> Boaz
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Tue, 11 Mar 2008 17:42:06 +0200
> Subject: [PATCH] gdth: Use scsi_get_command for gdth internal commands
> 
> use scsi_get_command() in __gdth_execute() of internal commands for two reasons.
> - To be insulated from future scsi-ml changes and the way scsi_cmnd is
>   structured / allocated.
> - Hold onto the scsi_device while executing since execution can come from
>   user-mode management SW through the gdth char device.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Tested-by: Sven Schnelle <svens@bitebene.org>
> ---
>  drivers/scsi/gdth.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index c6d6e7c..c6e2b8d 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -448,17 +448,10 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>      DECLARE_COMPLETION_ONSTACK(wait);
>      int rval;
>  
> -    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
> +    scp = scsi_get_command(sdev, GFP_KERNEL);
>      if (!scp)
>          return -ENOMEM;
>  
> -    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> -    if (!scp->sense_buffer) {
> -	kfree(scp);
> -	return -ENOMEM;
> -    }
> -
> -    scp->device = sdev;
>      memset(&cmndinfo, 0, sizeof(cmndinfo));
>  
>      /* use request field to save the ptr. to completion struct. */
> @@ -478,8 +471,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>      rval = cmndinfo.status;
>      if (info)
>          *info = cmndinfo.info;
> -    kfree(scp->sense_buffer);
> -    kfree(scp);
> +    scsi_put_command(scp);
>      return rval;

This needs to be the scsi_allocate_command/scsi_free_command interface.  Other than that, it looks fine.

James


