From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: use bus '3' for legacy HBA devices
Date: Thu, 17 Nov 2016 21:36:38 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B0BC8C5@avsrvexchmbx1.microsemi.net>
References: <1479381356-94616-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0064.outbound.protection.outlook.com ([104.47.36.64]:40160
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751174AbcKQVvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 16:51:55 -0500
In-Reply-To: <1479381356-94616-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Jack Suter <jack@suter.io>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, November 17, 2016 5:16 AM
> To: Don Brace
> Cc: Martin K. Petersen; Christoph Hellwig; James Bottomley; Johannes
> Thumshirn; Jack Suter; linux-scsi@vger.kernel.org; Hannes Reinecke; Hanne=
s
> Reinecke
> Subject: [PATCH] hpsa: use bus '3' for legacy HBA devices
>=20
> EXTERNAL EMAIL
>=20
>=20
> Older controllers use SCSI target id '0' for the first internal
> disk. As the controllers are now placed on the same bus than the
> internal disks this leads to a clash with the SCSI target id of
> controller.
> This patch checks the SCSI revision, and moves older controller
> to bus '3' to be compatible with older releases and avoid this
> problem.
>=20
> Fixes: 09371d623c9 ("hpsa: Change SAS transport devices to bus 0.")
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Acked-by: Don Brace <don.brace@microsemi.com>


> ---
>  drivers/scsi/hpsa.c | 14 ++++++++++----
>  drivers/scsi/hpsa.h |  2 ++
>  2 files changed, 12 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index ef4e81a..d0a22aa 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2034,7 +2034,8 @@ static int hpsa_slave_alloc(struct scsi_device *sde=
v)
>                         sd->target =3D sdev_id(sdev);
>                         sd->lun =3D sdev->lun;
>                 }
> -       } else
> +       }
> +       if (!sd)
>                 sd =3D lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
>                                         sdev_id(sdev), sdev->lun);
>=20
> @@ -3850,6 +3851,7 @@ static int hpsa_update_device_info(struct ctlr_info
> *h,
>                 sizeof(this_device->vendor));
>         memcpy(this_device->model, &inq_buff[16],
>                 sizeof(this_device->model));
> +       this_device->rev =3D inq_buff[2];
>         memset(this_device->device_id, 0,
>                 sizeof(this_device->device_id));
>         if (hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
> @@ -3939,10 +3941,14 @@ static void figure_bus_target_lun(struct ctlr_inf=
o
> *h,
>=20
>         if (!is_logical_dev_addr_mode(lunaddrbytes)) {
>                 /* physical device, target and lun filled in later */
> -               if (is_hba_lunid(lunaddrbytes))
> +               if (is_hba_lunid(lunaddrbytes)) {
> +                       int bus =3D HPSA_HBA_BUS;
> +
> +                       if (!device->rev)
> +                               bus =3D HPSA_LEGACY_HBA_BUS;
>                         hpsa_set_bus_target_lun(device,
> -                                       HPSA_HBA_BUS, 0, lunid & 0x3fff);
> -               else
> +                                       bus, 0, lunid & 0x3fff);
> +               } else
>                         /* defer target, lun assignment for physical devi=
ces */
>                         hpsa_set_bus_target_lun(device,
>                                         HPSA_PHYSICAL_DEVICE_BUS, -1, -1)=
;
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 3faf6cf..64e9829 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -69,6 +69,7 @@ struct hpsa_scsi_dev_t {
>         u64 sas_address;
>         unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
>         unsigned char model[16];        /* bytes 16-31 of inquiry data */
> +       unsigned char rev;              /* byte 2 of inquiry data */
>         unsigned char raid_level;       /* from inquiry page 0xC1 */
>         unsigned char volume_offline;   /* discovered via TUR or VPD */
>         u16 queue_depth;                /* max queue_depth for this devic=
e */
> @@ -400,6 +401,7 @@ struct offline_device_entry {
>  #define HPSA_RAID_VOLUME_BUS           1
>  #define HPSA_EXTERNAL_RAID_VOLUME_BUS  2
>  #define HPSA_HBA_BUS                   0
> +#define HPSA_LEGACY_HBA_BUS            3
>=20
>  /*
>         Send the command to the hardware
> --
> 1.8.5.6

