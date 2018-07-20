From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1 2/9] scsi: Allow auto suspend override by low-level
 driver
Date: Fri, 20 Jul 2018 16:50:31 -0700
Message-ID: <2c51ab099a01e17163bc219b1c4a135b@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
 <8135b00502f7e089478c9b988806ed40b7d5d40b.1530880006.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8135b00502f7e089478c9b988806ed40b7d5d40b.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-07-06 05:30, Asutosh Das wrote:
> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
> 
> Until now the scsi mid-layer forbids runtime suspend till userspace
> enables it. This is mainly to quarantine some disks with broken
> runtime power management or have high latencies executing suspend
> resume callbacks. If the userspace doesn't enable the runtime suspend
> the underlying hardware will be always on even when it is not doing
> any useful work and thus wasting power.
> 
> Some low-level drivers for the controllers can efficiently use runtime
> power management to reduce power consumption and improve battery life.
> Allow runtime suspend parameters override within the LLD itself
> instead of waiting for userspace to control the power management.
> 
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/scsi_scan.c   | 4 ++++
>  drivers/scsi/scsi_sysfs.c  | 3 ++-
>  drivers/scsi/sd.c          | 2 ++
>  include/scsi/scsi_device.h | 3 +++
>  4 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 0880d97..5b7232a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -969,6 +969,10 @@ static int scsi_add_lun(struct scsi_device *sdev,
> unsigned char *inq_result,
> 
>  	transport_configure_device(&sdev->sdev_gendev);
> 
> +	/* The LLD can override auto suspend tunables in ->slave_configure() 
> */
> +	sdev->use_rpm_auto = 0;
> +	sdev->autosuspend_delay = SCSI_DEFAULT_AUTOSUSPEND_DELAY;
> +
>  	if (sdev->host->hostt->slave_configure) {
>  		ret = sdev->host->hostt->slave_configure(sdev);
>  		if (ret) {
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 7943b76..706e778 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1266,7 +1266,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	device_enable_async_suspend(&sdev->sdev_gendev);
>  	scsi_autopm_get_target(starget);
>  	pm_runtime_set_active(&sdev->sdev_gendev);
> -	pm_runtime_forbid(&sdev->sdev_gendev);
> +	if (!sdev->use_rpm_auto)
> +		pm_runtime_forbid(&sdev->sdev_gendev);
>  	pm_runtime_enable(&sdev->sdev_gendev);
>  	scsi_autopm_put_target(starget);
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a6201e6..205624f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3269,6 +3269,8 @@ static void sd_probe_async(void *data,
> async_cookie_t cookie)
>  	}
> 
>  	blk_pm_runtime_init(sdp->request_queue, dev);
> +	if (sdp->autosuspend_delay >= 0)
> +		pm_runtime_set_autosuspend_delay(dev, sdp->autosuspend_delay);
>  	device_add_disk(dev, gd);
>  	if (sdkp->capacity)
>  		sd_dif_config_host(sdkp);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 4c36af6..1d5ae90 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -197,7 +197,10 @@ struct scsi_device {
>  	unsigned broken_fua:1;		/* Don't set FUA bit */
>  	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
>  	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME 
> */
> +	unsigned use_rpm_auto:1; /* Enable runtime PM auto suspend */
> 
> +#define SCSI_DEFAULT_AUTOSUSPEND_DELAY  -1
> +	int autosuspend_delay;
>  	atomic_t disk_events_disable_depth; /* disable depth for disk events 
> */
> 
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported 
> events */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
