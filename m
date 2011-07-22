From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH 6/8] [SCSI] osduld: use ida_simple_get to handle
 id.
Date: Fri, 22 Jul 2011 14:47:06 -0700
Message-ID: <4E29EFDA.1080407@panasas.com>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk> <1311352886-4047-7-git-send-email-jic23@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-7-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, airlied@linux.ie, dri-devel@lists.freedesktop.org, guenter.roeck@ericsson.com, johnpol@2ka.mipt.ru, thellstrom@vmware.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, lm-sensors@lm-sensors.org, airlied@redhat.com, paulmck@linux.vnet.ibm.com, naota@elisp.net, rtc-linux@googlegroups.com, namhyung@gmail.com, rusty@rustcorp.com.au, khali@linux-fr.org, osd-dev@open-osd.org, akpm@linux-foundation.org, a.zummo@towertech.it, jkosina@suse.cz, cabarnes@indesign-llc.com, tj@kernel.org, bhalevy@panasas.com
List-Id: linux-scsi@vger.kernel.org

On 07/22/2011 09:41 AM, Jonathan Cameron wrote:
> This does involve additional use of the spin lock in idr.c.
> Is this an issue?
> 

Actually it looks like a bug fix. I had a TODO: to add one.

> Also, some error mangling was needed to keep the interface
> the same.  Does this matter or can we return -ENOSPC instead
> of -EBUSY?
> 

Na. -ENOSPC is just fine. All the osd Application just check for
"any error" not a specific one.

> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

> ---
>  drivers/scsi/osd/osd_uld.c |   22 ++++++++--------------
>  1 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index b31a8e3..fa849bd 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
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

Just drop the translation is fine as well

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
