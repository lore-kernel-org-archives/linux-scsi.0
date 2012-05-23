From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v3 4/4] [SCSI] sd: change to auto suspend mode
Date: Wed, 23 May 2012 16:45:55 +0800
Message-ID: <CAF1ivSZaNw6nsBbF8OGbWNjA_uKK__u0rM4mLdVN7zK3bMFVTg@mail.gmail.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
	<1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 22, 2012 at 3:21 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Uses block layer runtime pm helper functions in scsi_runtime_suspend/=
resume.
> Remove scsi_autopm_* from sd open/release/remove path.

Hi Alan,

You mentioned that this patch needs some fixing.
Could you point that out?

Thanks,
Lin Ming

>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> =A0drivers/scsi/scsi_pm.c =A0 =A0| =A0 27 ++++++++++++++++++++-------
> =A0drivers/scsi/scsi_sysfs.c | =A0 =A02 ++
> =A0drivers/scsi/sd.c =A0 =A0 =A0 =A0 | =A0 10 +---------
> =A03 files changed, 23 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index c467064..302a157 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -139,10 +139,16 @@ static int scsi_runtime_suspend(struct device *=
dev)
>
> =A0 =A0 =A0 =A0dev_dbg(dev, "scsi_runtime_suspend\n");
> =A0 =A0 =A0 =A0if (scsi_is_sdev_device(dev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct scsi_device *sdev =3D to_scsi_de=
vice(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_queue *q =3D sdev->reque=
st_queue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D blk_pre_runtime_suspend(q);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D scsi_dev_type_suspend(dev, PMS=
G_AUTO_SUSPEND);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D -EAGAIN)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_schedule_suspend(dev=
, jiffies_to_msecs(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 round_j=
iffies_up_relative(HZ/10)));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_post_runtime_suspend(q, err);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* Insert hooks here for targets, hosts, and transport=
 classes */
> @@ -155,8 +161,14 @@ static int scsi_runtime_resume(struct device *de=
v)
> =A0 =A0 =A0 =A0int err =3D 0;
>
> =A0 =A0 =A0 =A0dev_dbg(dev, "scsi_runtime_resume\n");
> - =A0 =A0 =A0 if (scsi_is_sdev_device(dev))
> + =A0 =A0 =A0 if (scsi_is_sdev_device(dev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct scsi_device *sdev =3D to_scsi_de=
vice(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_queue *q =3D sdev->reque=
st_queue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_pre_runtime_resume(q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D scsi_dev_type_resume(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_post_runtime_resume(q, err);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* Insert hooks here for targets, hosts, and transport=
 classes */
>
> @@ -171,9 +183,10 @@ static int scsi_runtime_idle(struct device *dev)
>
> =A0 =A0 =A0 =A0/* Insert hooks here for targets, hosts, and transport=
 classes */
>
> - =A0 =A0 =A0 if (scsi_is_sdev_device(dev))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pm_schedule_suspend(dev, 100);
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 if (scsi_is_sdev_device(dev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_mark_last_busy(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pm_request_autosuspend(dev);
> + =A0 =A0 =A0 } else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D pm_runtime_suspend(dev);
> =A0 =A0 =A0 =A0return err;
> =A0}
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 04c2a27..1e8975f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -895,6 +895,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0scsi_autopm_get_device(sdev);
>
> + =A0 =A0 =A0 blk_pm_runtime_init(rq, &sdev->sdev_gendev);
> +
> =A0 =A0 =A0 =A0error =3D device_add(&sdev->sdev_gendev);
> =A0 =A0 =A0 =A0if (error) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sdev_printk(KERN_INFO, sdev,
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1205a8b..09e5ffe 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -966,10 +966,6 @@ static int sd_open(struct block_device *bdev, fm=
ode_t mode)
>
> =A0 =A0 =A0 =A0sdev =3D sdkp->device;
>
> - =A0 =A0 =A0 retval =3D scsi_autopm_get_device(sdev);
> - =A0 =A0 =A0 if (retval)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_autopm;
> -
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If the device is in error recovery, wait until it i=
s done.
> =A0 =A0 =A0 =A0 * If the device is offline, then disallow any access =
to it.
> @@ -1014,8 +1010,6 @@ static int sd_open(struct block_device *bdev, f=
mode_t mode)
> =A0 =A0 =A0 =A0return 0;
>
> =A0error_out:
> - =A0 =A0 =A0 scsi_autopm_put_device(sdev);
> -error_autopm:
> =A0 =A0 =A0 =A0scsi_disk_put(sdkp);
> =A0 =A0 =A0 =A0return retval;
> =A0}
> @@ -1050,7 +1044,6 @@ static int sd_release(struct gendisk *disk, fmo=
de_t mode)
> =A0 =A0 =A0 =A0 * XXX is followed by a "rmmod sd_mod"?
> =A0 =A0 =A0 =A0 */
>
> - =A0 =A0 =A0 scsi_autopm_put_device(sdev);
> =A0 =A0 =A0 =A0scsi_disk_put(sdkp);
> =A0 =A0 =A0 =A0return 0;
> =A0}
> @@ -2631,7 +2624,7 @@ static void sd_probe_async(void *data, async_co=
okie_t cookie)
>
> =A0 =A0 =A0 =A0sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sdp->removable ? "removable " : ""=
);
> - =A0 =A0 =A0 scsi_autopm_put_device(sdp);
> + =A0 =A0 =A0 pm_runtime_put_sync_autosuspend(&sdp->sdev_gendev);
> =A0 =A0 =A0 =A0put_device(&sdkp->dev);
> =A0}
>
> @@ -2755,7 +2748,6 @@ static int sd_remove(struct device *dev)
> =A0 =A0 =A0 =A0struct scsi_disk *sdkp;
>
> =A0 =A0 =A0 =A0sdkp =3D dev_get_drvdata(dev);
> - =A0 =A0 =A0 scsi_autopm_get_device(sdkp->device);
>
> =A0 =A0 =A0 =A0async_synchronize_full();
> =A0 =A0 =A0 =A0blk_queue_prep_rq(sdkp->device->request_queue, scsi_pr=
ep_fn);
> --
> 1.7.2.5
