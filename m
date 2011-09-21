From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch 5/8] drivers/scsi/osd/osd_uld.c: use ida_simple_get()
 to handle id
Date: Wed, 21 Sep 2011 13:47:47 +0300
Message-ID: <4E79C0D3.5010403@panasas.com>
References: <201109202120.p8KLKIUa000949@wpaz13.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:32832 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1IUKyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2011 06:54:25 -0400
In-Reply-To: <201109202120.p8KLKIUa000949@wpaz13.hot.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@google.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jic23@cam.ac.uk, bhalevy@panasas.com, rusty@rustcorp.com.au, tj@kernel.org

On 09/21/2011 12:20 AM, akpm@google.com wrote:
> From: Jonathan Cameron <jic23@cam.ac.uk>
> Subject: drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
> 
> This does involve additional use of the spin lock in idr.c.  Is this an
> issue?
> 

No it is fine, it actually fixes a bug, thanks

> Also, some error mangling was needed to keep the interface the same.  Does
> this matter or can we return -ENOSPC instead of -EBUSY?
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Benny Halevy <bhalevy@panasas.com>
> Signed-off-by: Andrew Morton <akpm@google.com>

I have already ACKed this patch and: No the error conversion is not
needed.

So please:
- Remove from commit log above the "Is this an issue?"
- Remove from code the error translation
- Remove from commit log above the comment about error translation
  maybe just add "the error return is now different".
- Add my 
  ACK-by: Boaz Harrosh <bharrosh@panasas.com>

> ---
> 
>  drivers/scsi/osd/osd_uld.c |   22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff -puN drivers/scsi/osd/osd_uld.c~drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id drivers/scsi/osd/osd_uld.c
> --- a/drivers/scsi/osd/osd_uld.c~drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id
> +++ a/drivers/scsi/osd/osd_uld.c
> @@ -387,7 +387,7 @@ static void __remove(struct device *dev)
>  
>  	if (oud->disk)
>  		put_disk(oud->disk);
> -	ida_remove(&osd_minor_ida, oud->minor);
> +	ida_simple_remove(&osd_minor_ida, oud->minor);
>  
>  	kfree(oud);
>  }
> @@ -403,18 +403,12 @@ static int osd_probe(struct device *dev)
>  	if (scsi_device->type != TYPE_OSD)
>  		return -ENODEV;
>  
> -	do {
> -		if (!ida_pre_get(&osd_minor_ida, GFP_KERNEL))
> -			return -ENODEV;
> -
> -		error = ida_get_new(&osd_minor_ida, &minor);
> -	} while (error == -EAGAIN);
> -
> -	if (error)
> -		return error;
> -	if (minor >= SCSI_OSD_MAX_MINOR) {
> -		error = -EBUSY;
> -		goto err_retract_minor;
> +	minor = ida_simple_get(&osd_minor_ida, 0,
> +			       SCSI_OSD_MAX_MINOR, GFP_KERNEL);
> +	if (minor < 0) {
> +		if (minor == -ENOSPC)
> +			return -EBUSY;

Please remove the translation. No usermode that I tested is
inspecting the specific return code. Does udev?

Thanks
Boaz

> +		return minor;
>  	}
>  
>  	error = -ENOMEM;
> @@ -491,7 +485,7 @@ err_free_osd:
>  	dev_set_drvdata(dev, NULL);
>  	kfree(oud);
>  err_retract_minor:
> -	ida_remove(&osd_minor_ida, minor);
> +	ida_simple_remove(&osd_minor_ida, minor);
>  	return error;
>  }
>  
> _

