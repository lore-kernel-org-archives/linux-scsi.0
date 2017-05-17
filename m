From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] ses: fix error message in ses_intf_add()
Date: Wed, 17 May 2017 09:41:26 -0400
Message-ID: <1495028486.3629.10.camel@localhost.localdomain>
References: <1495026008-25704-1-git-send-email-mlombard@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbdEQNl1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 May 2017 09:41:27 -0400
In-Reply-To: <1495026008-25704-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

On Wed, 2017-05-17 at 15:00 +0200, Maurizio Lombardi wrote:
> The "result" variable contains a negative error code and
> should not be logged as an hex value.
> This fixes the following error message:
> 
> [  250.068869] scsi 8:0:2:254: Wrong diagnostic page; asked for 2 got 0
> [  250.068872] scsi 8:0:2:254: Failed to get diagnostic page 0xffffffea
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/ses.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index f1cdf32..0ac45be 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -604,6 +604,7 @@ static int ses_intf_add(struct device *cdev,
>  	unsigned char *buf = NULL, *hdr_buf, *type_ptr;
>  	struct ses_device *ses_dev;
>  	u32 result;
> +	int page;
>  	int i, types, len, components = 0;
>  	int err = -ENOMEM;
>  	int num_enclosures;
> @@ -630,7 +631,8 @@ static int ses_intf_add(struct device *cdev,
>  	if (!hdr_buf || !ses_dev)
>  		goto err_init_free;
>  
> -	result = ses_recv_diag(sdev, 1, hdr_buf, INIT_ALLOC_SIZE);
> +	page = 1;
> +	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
>  	if (result)
>  		goto recv_failed;
>  
> @@ -639,7 +641,7 @@ static int ses_intf_add(struct device *cdev,
>  	if (!buf)
>  		goto err_free;
>  
> -	result = ses_recv_diag(sdev, 1, buf, len);
> +	result = ses_recv_diag(sdev, page, buf, len);
>  	if (result)
>  		goto recv_failed;
>  
> @@ -669,7 +671,8 @@ static int ses_intf_add(struct device *cdev,
>  	ses_dev->page1_len = len;
>  	buf = NULL;
>  
> -	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
> +	page = 2;
> +	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
>  	if (result)
>  		goto recv_failed;
>  
> @@ -679,7 +682,7 @@ static int ses_intf_add(struct device *cdev,
>  		goto err_free;
>  
>  	/* make sure getting page 2 actually works */
> -	result = ses_recv_diag(sdev, 2, buf, len);
> +	result = ses_recv_diag(sdev, page, buf, len);
>  	if (result)
>  		goto recv_failed;
>  	ses_dev->page2 = buf;
> @@ -688,7 +691,8 @@ static int ses_intf_add(struct device *cdev,
>  
>  	/* The additional information page --- allows us
>  	 * to match up the devices */
> -	result = ses_recv_diag(sdev, 10, hdr_buf, INIT_ALLOC_SIZE);
> +	page = 10;
> +	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
>  	if (!result) {
>  
>  		len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
> @@ -696,7 +700,7 @@ static int ses_intf_add(struct device *cdev,
>  		if (!buf)
>  			goto err_free;
>  
> -		result = ses_recv_diag(sdev, 10, buf, len);
> +		result = ses_recv_diag(sdev, page, buf, len);
>  		if (result)
>  			goto recv_failed;
>  		ses_dev->page10 = buf;
> @@ -733,8 +737,9 @@ static int ses_intf_add(struct device *cdev,
>  	return 0;
>  
>   recv_failed:
> -	sdev_printk(KERN_ERR, sdev, "Failed to get diagnostic page 0x%x\n",
> -		    result);
> +	sdev_printk(KERN_ERR, sdev,
> +		    "Failed to get diagnostic page %d with error %d\n",
> +		    page, result);
>  	err = -ENODEV;
>   err_free:
>  	kfree(buf);

This looks OK but I think we should consider suppressing these
messages.  There are a lot of devices that return page 0 instead of
the correct page, we should either say something like "enclosure
services not supported", or else work with what we get instead of
logging a message on every device probe that make it sound like
the device is failing.  I've received several complaints about this.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
