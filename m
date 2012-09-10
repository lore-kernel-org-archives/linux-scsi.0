From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] st: remove st_mutex
Date: Mon, 10 Sep 2012 15:24:38 -0700
Message-ID: <504E68A6.2070102@suse.com>
References: <504E62D2.8030904@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:37386 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2IJWYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2012 18:24:46 -0400
In-Reply-To: <504E62D2.8030904@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, =?ISO-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>, Jeff Mahoney <jeffm@suse.com>

Please disregard this patch -- I have the meta-data wrong.

I'll resubmit.

On 09/10/2012 02:59 PM, Lee Duncan wrote:
> This patch is based on the "misc" branch of the SCSI tree
> and the 5-patch series for st sent by Jeff Mahoney 8/18/2012
> and Ack-ed by Kai on 8/20.
> 
> From: Jeff Mahoney <jeffm@suse.com>
> 
> The st_mutex was created when the BKL was removed, and
> prevents simultaneous st_open calls. It is better to
> protect just the necessary data.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/st.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index ceca095..98156a9 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -75,7 +75,6 @@ static const char *verstr = "20101219";
>  #include "st_options.h"
>  #include "st.h"
> 
> -static DEFINE_MUTEX(st_mutex);
>  static int buffer_kbs;
>  static int max_sg_segs;
>  static int try_direct_io = TRY_DIRECT_IO;
> @@ -1185,7 +1184,6 @@ static int st_open(struct inode *inode, struct
> file *filp)
>  	int dev = TAPE_NR(inode);
>  	char *name;
> 
> -	mutex_lock(&st_mutex);
>  	/*
>  	 * We really want to do nonseekable_open(inode, filp); here, but some
>  	 * versions of tar incorrectly call lseek on tapes and bail out if that
> @@ -1194,7 +1192,6 @@ static int st_open(struct inode *inode, struct
> file *filp)
>  	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
> 
>  	if (!(STp = scsi_tape_get(dev))) {
> -		mutex_unlock(&st_mutex);
>  		return -ENXIO;
>  	}
> 
> @@ -1205,7 +1202,6 @@ static int st_open(struct inode *inode, struct
> file *filp)
>  	if (STp->in_use) {
>  		spin_unlock(&st_use_lock);
>  		scsi_tape_put(STp);
> -		mutex_unlock(&st_mutex);
>  		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
>  		return (-EBUSY);
>  	}
> @@ -1259,16 +1255,16 @@ static int st_open(struct inode *inode, struct
> file *filp)
>  			retval = (-EIO);
>  		goto err_out;
>  	}
> -	mutex_unlock(&st_mutex);
>  	return 0;
> 
>   err_out:
>  	normalize_buffer(STp->buffer);
> +	spin_lock(&st_use_lock);
>  	STp->in_use = 0;
> +	spin_unlock(&st_use_lock);
>  	scsi_tape_put(STp);
>  	if (resumed)
>  		scsi_autopm_put_device(STp->device);
> -	mutex_unlock(&st_mutex);
>  	return retval;
> 
>  }
> 

-- 
Lee Duncan
SUSE Labs
