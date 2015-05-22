From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/9] [SCSI] aacraid: Fix for logical device name and UID
 not exposed to the OS
Date: Fri, 22 May 2015 15:18:48 +0200
Message-ID: <555F2CB8.60400@redhat.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com> <1431562378-8514-2-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbbEVNSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 09:18:55 -0400
In-Reply-To: <1431562378-8514-2-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 05/14/2015 02:12 AM, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
> 	Driver sends the right size of the response buffer.
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 9b3dd6e..fe59b00 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -570,7 +570,7 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
>  
>  	status = aac_fib_send(ContainerCommand,
>  		  cmd_fibcontext,
> -		  sizeof (struct aac_get_name),
> +		  sizeof(struct aac_get_name_resp),
Hi Rajinikanth,
in aac_fib_send the size parameter is used in just one place
and a comment there says "Set the size of the Fib we want to send to the
adapter"
>From that^ it looks like it is the size of the command you sending,
to the hw. Do I miss something?
Cheers,
Tomas
>  		  FsaNormal,
>  		  0, 1,
>  		  (fib_callback)get_container_name_callback,
> @@ -1052,7 +1052,7 @@ static int aac_get_container_serial(struct scsi_cmnd * scsicmd)
>  
>  	status = aac_fib_send(ContainerCommand,
>  		  cmd_fibcontext,
> -		  sizeof (struct aac_get_serial),
> +		  sizeof(struct aac_get_serial_resp),
>  		  FsaNormal,
>  		  0, 1,
>  		  (fib_callback) get_container_serial_callback,
> 

