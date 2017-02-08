From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3] scsi/sd: release scan_mutex during sync_cache and
 start_stop
Date: Wed, 8 Feb 2017 22:56:10 +0000
Message-ID: <87413FD9-0B96-4902-B458-034AF7AFDB7B@fb.com>
References: <20170208225353.82334-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36999 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751355AbdBHW5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 17:57:05 -0500
In-Reply-To: <20170208225353.82334-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <FF7C00CA24BFAB438B2F6F8525162845@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

> On Feb 8, 2017, at 2:53 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> When a device is deleted through sysfs handle "delete", the code
> locks shost->scan_mutex. If multiple devices are deleted at the
> same time, these deletes will be handled in series.
>=20
> On the other hand, sd_shutdown() sometimes issues long latency
> commands: sync cache and start_stop. It is not necessary for these
> commands to run in series.
>=20
> To reduce latency of parallel "delete" requests, this patch unlock
> shost->scan_mutex before long latency commands and relock the mutex
> after the command.
>=20
> Fixed bug from previous version.
>=20
> Reported-by: kernel test robot <fengguang.wu@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> drivers/scsi/sd.c | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9e0783b..14c5815 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3304,6 +3304,9 @@ static int sd_start_stop_device(struct scsi_disk *s=
dkp, int start)
> static void sd_shutdown(struct device *dev)
> {
> 	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
> +	struct scsi_device *sdev;
> +	struct Scsi_Host *shost;
> +	int try_lock_scan_mutex;
>=20
> 	if (!sdkp)
> 		return;         /* this can happen */
> @@ -3311,15 +3314,26 @@ static void sd_shutdown(struct device *dev)
> 	if (pm_runtime_suspended(dev))
> 		return;
>=20
> +	sdev =3D sdkp->device;
> +	shost =3D sdev->host;
> +	try_lock_scan_mutex =3D mutex_trylock(&shost->scan_mutex);
> +
> 	if (sdkp->WCE && sdkp->media_present) {
> +		mutex_unlock(&shost->scan_mutex);
> 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> 		sd_sync_cache(sdkp);
> +		mutex_lock(&shost->scan_mutex);
> 	}
>=20
> 	if (system_state !=3D SYSTEM_RESTART && sdkp->device->manage_start_stop)=
 {
> +		mutex_unlock(&shost->scan_mutex);
> 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> 		sd_start_stop_device(sdkp, 0);
> +		mutex_lock(&shost->scan_mutex);
> 	}
> +
> +	if (try_lock_scan_mutex)
> +		mutex_unlock(&shost->scan_mutex);
> }
>=20
> static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> --=20
> 2.9.3
>=20

Forgot to CC Christoph
