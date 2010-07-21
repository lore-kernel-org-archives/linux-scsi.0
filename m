From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [patch 13/27] scsi: remove superfluous NULL pointer check from scsi_kill_request()
Date: Wed, 21 Jul 2010 13:07:15 +0200
Message-ID: <201007211307.15762.bzolnier@gmail.com>
References: <201007202228.o6KMSrU1021751@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0GULKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2010 07:10:05 -0400
Received: by fxm14 with SMTP id 14so3417076fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2010 04:10:04 -0700 (PDT)
In-Reply-To: <201007202228.o6KMSrU1021751@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, corbet@lwn.net, error27@gmail.com, eteo@redhat.com


Hi,

This one may be dropped as after almost a year of trying to get it
merged [1] it seems that an added complexity of the patch is not worth
the potential gains (although I can't tell for sure since feedback has
been always 'minimal').

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0907.3/00416.html

Thanks.

On Wednesday 21 July 2010 12:28:53 am akpm@linux-foundation.org wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Dan's list included:
> 
> drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
> drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'
> 
> We dereference cmd (and possible OOPS if cmd == NULL) before starting the
> request so just remove the superfluous debugging code altogether.
> 
> [ bart: the potential NULL pointer dereference was finally fixed in
>   (much later than mine) commit 03b1470 but my patch is still valid ]
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Eugene Teo <eteo@redhat.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/scsi_lib.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff -puN drivers/scsi/scsi_lib.c~scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c~scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request
> +++ a/drivers/scsi/scsi_lib.c
> @@ -1370,12 +1370,6 @@ static void scsi_kill_request(struct req
>  
>  	blk_start_request(req);
>  
> -	if (unlikely(cmd == NULL)) {
> -		printk(KERN_CRIT "impossible request in %s.\n",
> -				 __func__);
> -		BUG();
> -	}
> -
>  	sdev = cmd->device;
>  	starget = scsi_target(sdev);
>  	shost = sdev->host;
> _
