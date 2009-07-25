From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: remove superfluous NULL pointer check from
 scsi_kill_request()
Date: Sat, 25 Jul 2009 08:42:18 -0700
Message-ID: <1248536538.20477.2.camel@Joe-Laptop.home>
References: <200907261629.26529.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4115 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZGYPm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2009 11:42:27 -0400
In-Reply-To: <200907261629.26529.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com

On Sun, 2009-07-26 at 16:29 +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] scsi: remove superfluous NULL pointer check from scsi_kill_request()
> 
> >From Dan's list:
> 
> drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
> drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'
> 
> We dereference cmd (and possible OOPS if cmd == NULL) before starting
> the request so just remove the superfluous debugging code altogether.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Cc: corbet@lwn.net
> Cc: eteo@redhat.com
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/scsi/scsi_lib.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> Index: b/drivers/scsi/scsi_lib.c
> ===================================================================
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1365,12 +1365,6 @@ static void scsi_kill_request(struct req
>  
>  	blk_start_request(req);
>  
> -	if (unlikely(cmd == NULL)) {
> -		printk(KERN_CRIT "impossible request in %s.\n",
> -				 __func__);
> -		BUG();
> -	}
> -
>  	scsi_init_cmd_errh(cmd);
>  	cmd->result = DID_NO_CONNECT << 16;
>  	atomic_inc(&cmd->device->iorequest_cnt);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


