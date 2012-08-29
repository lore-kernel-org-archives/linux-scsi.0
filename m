From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH v2] [SCSI] mpt2sas: fix double mutex lock in
 NON_BLOCKING state
Date: Wed, 29 Aug 2012 15:48:06 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E20ADBF8@inbmail02.lsi.com>
References: <1346164683-9315-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1346164683-9315-1-git-send-email-khoroshilov@ispras.ru>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ldv-project@ispras.ru" <ldv-project@ispras.ru>
List-Id: linux-scsi@vger.kernel.org

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

> -----Original Message-----
> From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru]
> Sent: Tuesday, August 28, 2012 8:08 PM
> To: James E.J. Bottomley
> Cc: Alexey Khoroshilov; linux-scsi@vger.kernel.org; Nandigama,
> Nagalakshmi; Reddy, Sreekanth; linux-kernel@vger.kernel.org; ldv-
> project@ispras.ru
> Subject: [PATCH v2] [SCSI] mpt2sas: fix double mutex lock in
> NON_BLOCKING state
> 
> If state is NON_BLOCKING and mutex_trylock is succeed,
> the control flow goes to mutex_lock_interruptible() that is a deadlock.
> 
> The previous version of the patch becomes obsolete after
> code movement in commit 913809f6.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> index 49bdd2d..d29ea56 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> @@ -2181,8 +2181,10 @@ _ctl_ioctl_main(struct file *file, unsigned int
> cmd, void __user *arg,
>  		return -EAGAIN;
> 
>  	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
> -	if (state == NON_BLOCKING && !mutex_trylock(&ioc-
> >ctl_cmds.mutex))
> -		return -EAGAIN;
> +	if (state == NON_BLOCKING) {
> +		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
> +			return -EAGAIN;
> +	}
>  	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
>  		return -ERESTARTSYS;
> 
> --
> 1.7.9.5
