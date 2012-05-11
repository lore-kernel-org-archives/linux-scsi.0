From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH]scsi: pm: resume device if suspend failed
Date: Fri, 11 May 2012 10:23:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205111022450.1865-100000@iolanthe.rowland.org>
References: <1336719294-25598-1-git-send-email-Aaron.Lu@amd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47412 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755382Ab2EKOXd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2012 10:23:33 -0400
In-Reply-To: <1336719294-25598-1-git-send-email-Aaron.Lu@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <Aaron.Lu@amd.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

On Fri, 11 May 2012, Aaron Lu wrote:

> For scsi devices which use scsi bus runtime callback, runtime suspend
> will call scsi_dev_type_suspend, and if the drv->suspend failed, the
> device will still be in active state. But since scsi_device_quiesce is
> called, the device will not be able to respond any more commands.
> So add a check here to see if err occured, if so, bring the device back
> to normal state with scsi_device_resume.
> 
> Signed-off-by: Aaron Lu <Aaron.Lu@amd.com>

Good catch.
        
Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
>  drivers/scsi/scsi_pm.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index c467064..33b8bf9 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -24,8 +24,11 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
>  	err = scsi_device_quiesce(to_scsi_device(dev));
>  	if (err == 0) {
>  		drv = dev->driver;
> -		if (drv && drv->suspend)
> +		if (drv && drv->suspend) {
>  			err = drv->suspend(dev, msg);
> +			if (err)
> +				scsi_device_resume(dev);
> +		}
>  	}
>  	dev_dbg(dev, "scsi suspend: %d\n", err);
>  	return err;

