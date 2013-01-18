From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 4/4] sd: change to auto suspend mode
Date: Fri, 18 Jan 2013 16:25:10 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301181613060.1190-100000@iolanthe.rowland.org>
References: <1358326941-3725-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358326941-3725-5-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Jan 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> Uses block layer runtime pm helper functions in
> scsi_runtime_suspend/resume.
> Remove scsi_autopm_* from sd open/release path and check_events path.
> And remove the quiesce call in runtime suspend path, as we know there is
> no request to quiesce for the device.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -893,6 +893,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	 */
>  	scsi_autopm_get_device(sdev);
>  
> +	blk_pm_runtime_init(rq, &sdev->sdev_gendev);
> +
>  	error = device_add(&sdev->sdev_gendev);
>  	if (error) {
>  		sdev_printk(KERN_INFO, sdev,

Someone just asked about the default autosuspend delay, and I realized
your patch series doesn't set one.  Since we don't know the properties
of the disk drive at this point (or even whether the device is a disk
drive), the only safe course is to call

	pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev, -1);

before calling blk_pm_runtime_init().  Then autosuspends will be 
prevented until userspace writes a non-negative value into the device's 
control/autosuspend_delay_ms file.

The kerneldoc for blk_pm_runtime_init() should mention that the caller 
needs to set the autosuspend delay beforehand.

Alan Stern
