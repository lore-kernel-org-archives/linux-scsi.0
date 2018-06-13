From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: xen-scsifront: add error handling for
 xenbus_printf
Date: Wed, 13 Jun 2018 20:09:51 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1806132002180.45@nippy.intranet>
References: <1528774962-39173-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528774962-39173-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Jun 2018, Zhouyang Jia wrote:

> When xenbus_printf fails, the lack of error-handling code may
> cause unexpected results.
> 
> This patch adds error-handling code after calling xenbus_printf.
> 
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/scsi/xen-scsifront.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index 36f59a1..3d858ac 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -654,10 +654,17 @@ static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
>  static int scsifront_sdev_configure(struct scsi_device *sdev)
>  {
>  	struct vscsifrnt_info *info = shost_priv(sdev->host);
> +	struct xenbus_device *dev = info->dev;
> +	int err;
>  
> -	if (info && current == info->curr)
> -		xenbus_printf(XBT_NIL, info->dev->nodename,
> +	if (info && current == info->curr) {
> +		err = xenbus_printf(XBT_NIL, info->dev->nodename,
>  			      info->dev_state_path, "%d", XenbusStateConnected);

The existing code checks whether 'info' is NULL before dereferencing it. 
But your patch checks for NULL after dereferencing.

> +		if (err) {
> +			dev_err(&dev->dev, "writing dev_state_path\n");
> +			return err;
> +		}
> +	}
>  
>  	return 0;
>  }
> @@ -665,10 +672,15 @@ static int scsifront_sdev_configure(struct scsi_device *sdev)
>  static void scsifront_sdev_destroy(struct scsi_device *sdev)
>  {
>  	struct vscsifrnt_info *info = shost_priv(sdev->host);
> +	struct xenbus_device *dev = info->dev;
> +	int err;
>  
> -	if (info && current == info->curr)
> -		xenbus_printf(XBT_NIL, info->dev->nodename,
> +	if (info && current == info->curr) {
> +		err = xenbus_printf(XBT_NIL, info->dev->nodename,
>  			      info->dev_state_path, "%d", XenbusStateClosed);

Same here.

> +		if (err)
> +			dev_err(&dev->dev, "writing dev_state_path\n");
> +	}
>  }
>  
>  static struct scsi_host_template scsifront_sht = {

-- 
