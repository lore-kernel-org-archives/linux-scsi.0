From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 02/47] aacraid: split off host reset
Date: Thu, 29 Jun 2017 20:00:14 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CC3C@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0044.outbound.protection.outlook.com ([104.47.37.44]:27975
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751605AbdF2UAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 16:00:22 -0400
In-Reply-To: <1498638793-44672-3-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Wednesday, June 28, 2017 1:32 AM
> To: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCH 02/47] aacraid: split off host reset
>=20
> EXTERNAL EMAIL
>=20
>=20
> Split off the host reset parts of aac_eh_reset() into a separate
> host reset function.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/linit.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 9a8a27f..bf21006 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -874,10 +874,6 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
>         u32 bus, cid;
>         int ret =3D FAILED;
>         int status =3D 0;
> -       __le32 supported_options2 =3D 0;
> -       bool is_mu_reset;
> -       bool is_ignore_reset;
> -       bool is_doorbell_reset;
>=20
>=20
>         bus =3D aac_logical_to_phys(scmd_channel(cmd));
> @@ -923,7 +919,7 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
>                 }
>=20
>                 if (ret =3D=3D SUCCESS)
> -                       goto out;
> +                       return ret;
>=20
>         } else {
>=20
> @@ -952,8 +948,24 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
>                 dev_err(&aac->pdev->dev, "Adapter health - %d\n", status)=
;
>=20
>         count =3D get_num_of_incomplete_fibs(aac);
> -       if (count =3D=3D 0)
> -               return SUCCESS;
> +       return (count =3D=3D 0) ? SUCCESS : FAILED;
> +}
> +
> +/*
> + *     aac_eh_host_reset       - Host reset command handling
> + *     @scsi_cmd:      SCSI command block causing the reset
> + *
> + */
> +int aac_eh_host_reset(struct scsi_cmnd *cmd)
> +{
> +       struct scsi_device * dev =3D cmd->device;
> +       struct Scsi_Host * host =3D dev->host;
> +       struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
> +       int ret =3D FAILED;
> +       __le32 supported_options2 =3D 0;
> +       bool is_mu_reset;
> +       bool is_ignore_reset;
> +       bool is_doorbell_reset;
>=20
>         /*
>          * Check if reset is supported by the firmware
> @@ -972,10 +984,8 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
>          && (aac_check_reset !=3D -1 || !is_ignore_reset)) {
>                 /* Bypass wait for command quiesce */
>                 aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
> +               ret =3D SUCCESS;
>         }
> -       ret =3D SUCCESS;
> -
> -out:
>         return ret;
>  }
>=20
> @@ -1399,7 +1409,8 @@ ssize_t aac_get_serial_number(struct device
> *device, char *buf)
>         .change_queue_depth             =3D aac_change_queue_depth,
>         .sdev_attrs                     =3D aac_dev_attrs,
>         .eh_abort_handler               =3D aac_eh_abort,
> -       .eh_host_reset_handler          =3D aac_eh_reset,
> +       .eh_bus_reset_handler           =3D aac_eh_reset,
> +       .eh_host_reset_handler          =3D aac_eh_host_reset,
>         .can_queue                      =3D AAC_NUM_IO_FIB,
>         .this_id                        =3D MAXIMUM_NUM_CONTAINERS,
>         .sg_tablesize                   =3D 16,

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
