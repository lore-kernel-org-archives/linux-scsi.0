From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/5] scsi: sr: runtime pm when ODD is open/closed
Date: Mon, 23 Jul 2012 10:57:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207231052010.1633-100000@iolanthe.rowland.org>
References: <1343026180-22236-3-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343026180-22236-3-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 23 Jul 2012, Aaron Lu wrote:

> The ODD can either be runtime resumed by the user or by a software
> request. And for the latter part, we only support runtime resume the ODD
> when the eject request is received. We did this in sr's block ioctl
> function, this looks ugly.
> 
> Change this by runtime resuming the ODD in its open function and runtime
> suspending it in its release function.
> 
> The downside of this approach is that in old distros with old udisk
> daemon, the ODD will be polled by udisk daemon so open/close will
> constantly be called, which will cause the ODD frequently resume from
> suspend state, breaking the effect of power saving. User with such a
> distro is advised to issue a udisk command to inhibit polling of the
> disk like this:
> $ udisks --inhibit-polling /dev/sr0
> And since newer kernel has in kernel polling, there is no problem
> regarding ODD's event report.
> 
> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> ---
>  drivers/scsi/sr.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5f4d19a..f7a7635 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -152,8 +152,15 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
>  	kref_get(&cd->kref);
>  	if (scsi_device_get(cd->device))
>  		goto out_put;
> +	if (pm_runtime_get_sync(&cd->device->sdev_gendev) < 0) {
> +		pm_runtime_put_noidle(&cd->device->sdev_gendev);
> +		goto out_pm;
> +	}

You should use scsi_autopm_get_device instead of bypassing the SCSI 
layer.  Similarly for the _put call.

I know the existing calls do this already.  They shouldn't.

Alan Stern
