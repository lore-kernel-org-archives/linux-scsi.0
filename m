From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] scsi: fixup kernel warning during rmmod()
Date: Thu, 5 Oct 2017 15:29:13 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1967204804@avsrvexchmbx1.microsemi.net>
References: <1507105736-19148-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:27280
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751323AbdJEP3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Oct 2017 11:29:53 -0400
In-Reply-To: <1507105736-19148-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Wednesday, October 04, 2017 3:29 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCH] scsi: fixup kernel warning during rmmod()
>=20
> EXTERNAL EMAIL
>=20
>=20
> Calling rmmod() on a FC driver will results in warnings like
>=20
> WARNING: CPU: 60 PID: 14640 at fs/sysfs/group.c:237
> device_del+0x54/0x240()
> sysfs group ffffffff81eff140 not found for kobject '3:0:0:3'
>=20
> The problem here is that during scsi_remove_target() we will iterate
> over all devices, but fail to remove any of those as the call to
> scsi_device_get() fails the check to module_is_live().
> Hence the devices will not be removed at this point, but all
> intermediate structures like fc rport etc. will be.
> Later on during scsi_forget_host() the devices are removed for
> real, but the device parent is already removed and causes
> this warning.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
Tested-by: Don Brace <don.brace@microsemi.com>=20
Using the smartpqi driver.
Thanks for your effort.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation


> ---
>  drivers/scsi/scsi_sysfs.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 1889761..995539f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1336,13 +1336,19 @@ static void __scsi_remove_target(struct
> scsi_target *starget)
>         spin_lock_irqsave(shost->host_lock, flags);
>   restart:
>         list_for_each_entry(sdev, &shost->__devices, siblings) {
> +               /*
> +                * We cannot call scsi_device_get() here, as
> +                * we might've been called from rmmod() causing
> +                * scsi_device_get() to fail the module_is_live()
> +                * check.
> +                */
>                 if (sdev->channel !=3D starget->channel ||
>                     sdev->id !=3D starget->id ||
> -                   scsi_device_get(sdev))
> +                   !get_device(&sdev->sdev_gendev))
>                         continue;
>                 spin_unlock_irqrestore(shost->host_lock, flags);
>                 scsi_remove_device(sdev);
> -               scsi_device_put(sdev);
> +               put_device(&sdev->sdev_gendev);
>                 spin_lock_irqsave(shost->host_lock, flags);
>                 goto restart;
>         }
> --
> 1.8.5.6
