From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] osd_uld: Check scsi_device_get() return value
Date: Wed, 5 Apr 2017 19:48:53 +0300
Message-ID: <f1f5d734-5ad9-4d85-1e61-e8ba56994ac0@electrozaur.com>
References: <1D08B61A9CF0974AA09887BE32D889DA12E934@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36630 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753608AbdDEQs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 12:48:57 -0400
Received: by mail-wr0-f196.google.com with SMTP id k6so4272874wre.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 09:48:56 -0700 (PDT)
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA12E934@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/30/2017 08:17 PM, Bart Van Assche wrote:
> scsi_device_get() can fail. Hence check its return value.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>

Cool thanks
ACK-by: Boaz Harrosh <ooo@electrozaur.com>

> ---
>  drivers/scsi/osd/osd_uld.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index e0ce5d2fd14d..1dea4244dd0c 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -464,14 +464,15 @@ static int osd_probe(struct device *dev)
>  	/* hold one more reference to the scsi_device that will get released
>  	 * in __release, in case a logout is happening while fs is mounted
>  	 */
> -	scsi_device_get(scsi_device);
> +	if (scsi_device_get(scsi_device))
> +		goto err_put_disk;
>  	osd_dev_init(&oud->od, scsi_device);
>  
>  	/* Detect the OSD Version */
>  	error = __detect_osd(oud);
>  	if (error) {
>  		OSD_ERR("osd detection failed, non-compatible OSD device\n");
> -		goto err_put_disk;
> +		goto err_put_sdev;
>  	}
>  
>  	/* init the char-device for communication with user-mode */
> @@ -508,8 +509,9 @@ static int osd_probe(struct device *dev)
>  
>  err_put_cdev:
>  	cdev_del(&oud->cdev);
> -err_put_disk:
> +err_put_sdev:
>  	scsi_device_put(scsi_device);
> +err_put_disk:
>  	put_disk(disk);
>  err_free_osd:
>  	dev_set_drvdata(dev, NULL);
> 
