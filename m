From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] [SCSI] scsi_pm: set device runtime state before parent
 suspended
Date: Thu, 5 Jul 2012 09:25:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207050921310.30876-100000@netrider.rowland.org>
References: <1341470884.3484.12.camel@chief-river-32>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341470884.3484.12.camel@chief-river-32>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 5 Jul 2012, Lin Ming wrote:

> There is a race in scsi_bus_resume_common when set device's runtime
> state to active after pm_runtime_put_sync(dev->parent).
> 
> Parent device may have been suspended so pm_runtime_set_active(dev) will
> fail with -EBUSY.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> CC: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_pm.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d4201de..d2a80de 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -85,14 +85,14 @@ static int scsi_bus_resume_common(struct device *dev)
>  		 */
>  		pm_runtime_get_sync(dev->parent);
>  		err = scsi_dev_type_resume(dev);
> +		if (err == 0) {
> +			pm_runtime_disable(dev);
> +			pm_runtime_set_active(dev);
> +			pm_runtime_enable(dev);
> +		}
>  		pm_runtime_put_sync(dev->parent);
>  	}
>  
> -	if (err == 0) {
> -		pm_runtime_disable(dev);
> -		pm_runtime_set_active(dev);
> -		pm_runtime_enable(dev);
> -	}

This isn't quite right.  We still want to execute the 
pm_runtime_disable, _set_active, and _enable even when 
scsi_is_sdev_device(dev) is false.

I guess the revised code should look more like this:

	/*
	 * Parent device may have runtime suspended as soon as
	 * it is woken up during the system resume.
	 *
	 * Resume it on behalf of child.
	 */
	pm_runtime_get_sync(dev->parent);

	if (scsi_is_sdev_device(dev))
		err = scsi_dev_type_resume(dev);
	if (err == 0) {
		pm_runtime_disable(dev);
		pm_runtime_set_active(dev);
		pm_runtime_enable(dev);
	}

	pm_runtime_put_sync(dev->parent);

Alan Stern
