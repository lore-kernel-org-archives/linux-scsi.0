From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 03/47] aacraid: split off device, target, and bus reset
Date: Thu, 29 Jun 2017 20:01:16 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CC4E@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0079.outbound.protection.outlook.com ([104.47.38.79]:55296
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751661AbdF2UBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 16:01:43 -0400
In-Reply-To: <1498638793-44672-4-git-send-email-hare@suse.de>
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
> Subject: [PATCH 03/47] aacraid: split off device, target, and bus reset
>=20
> EXTERNAL EMAIL
>=20
>=20
> Split off device, target, and bus reset functionality into
> individual functions.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/linit.c | 141 +++++++++++++++++++++++++++++++-----
> -------
>  1 file changed, 102 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index bf21006..57b2077 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -861,68 +861,129 @@ static u8 aac_eh_tmf_hard_reset_fib(struct
> aac_dev *aac, struct fib *fib,
>  }
>=20
>  /*
> - *     aac_eh_reset    - Reset command handling
> + *     aac_eh_dev_reset        - Device reset command handling
>   *     @scsi_cmd:      SCSI command block causing the reset
>   *
>   */
> -static int aac_eh_reset(struct scsi_cmnd* cmd)
> +static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
>  {
>         struct scsi_device * dev =3D cmd->device;
>         struct Scsi_Host * host =3D dev->host;
>         struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
>         int count;
>         u32 bus, cid;
> +       struct fib *fib;
>         int ret =3D FAILED;
> -       int status =3D 0;
> -
> +       int status;
> +       u8 command;
>=20
>         bus =3D aac_logical_to_phys(scmd_channel(cmd));
>         cid =3D scmd_id(cmd);
> -       if (bus < AAC_MAX_BUSES && cid < AAC_MAX_TARGETS &&
> -               aac->hba_map[bus][cid].devtype =3D=3D AAC_DEVTYPE_NATIVE_=
RAW) {
> -               struct fib *fib;
> -               int status;
> -               u8 command;
> +       if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> +           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +               return FAILED;
>=20
> -               pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> -                       AAC_DRIVERNAME);
> +       pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> +              AAC_DRIVERNAME);
>=20
> -               fib =3D aac_fib_alloc(aac);
> -               if (!fib)
> -                       return ret;
> +       fib =3D aac_fib_alloc(aac);
> +       if (!fib)
> +               return ret;
>=20
>=20
> -               if (aac->hba_map[bus][cid].reset_state =3D=3D 0) {
> -                       /* start a HBA_TMF_LUN_RESET TMF request */
> -                       command =3D aac_eh_tmf_lun_reset_fib(aac, fib,
> -                                                          bus, cid,
> -                                                          cmd->device->l=
un);
> -                       aac->hba_map[bus][cid].reset_state++;
> -               } else if (aac->hba_map[bus][cid].reset_state >=3D 1) {
> -                       /* already tried, start a hard reset now */
> -                       command =3D aac_eh_tmf_hard_reset_fib(aac, fib, b=
us, cid);
> -                       aac->hba_map[bus][cid].reset_state =3D 0;
> +       /* start a HBA_TMF_LUN_RESET TMF request */
> +       command =3D aac_eh_tmf_lun_reset_fib(aac, fib, bus, cid,
> +                                          cmd->device->lun);
> +
> +       cmd->SCp.sent_command =3D 0;
> +
> +       status =3D aac_hba_send(command, fib,
> +                             (fib_callback) aac_hba_callback,
> +                             (void *) cmd);
> +
> +       /* Wait up to 15 seconds for completion */
> +       for (count =3D 0; count < 15; ++count) {
> +               if (cmd->SCp.sent_command) {
> +                       ret =3D SUCCESS;
> +                       break;
>                 }
> -               cmd->SCp.sent_command =3D 0;
> +               msleep(1000);
> +       }
>=20
> -               status =3D aac_hba_send(command, fib,
> -                                 (fib_callback) aac_hba_callback,
> -                                 (void *) cmd);
> +       return ret;
> +}
>=20
> -               /* Wait up to 15 seconds for completion */
> -               for (count =3D 0; count < 15; ++count) {
> -                       if (cmd->SCp.sent_command) {
> -                               ret =3D SUCCESS;
> -                               break;
> -                       }
> -                       msleep(1000);
> +/*
> + *     aac_eh_target_reset     - Target reset command handling
> + *     @scsi_cmd:      SCSI command block causing the reset
> + *
> + */
> +static int aac_eh_target_reset(struct scsi_cmnd *cmd)
> +{
> +       struct scsi_device * dev =3D cmd->device;
> +       struct Scsi_Host * host =3D dev->host;
> +       struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
> +       int count;
> +       u32 bus, cid;
> +       int ret =3D FAILED;
> +       struct fib *fib;
> +       int status;
> +       u8 command;
> +
> +       bus =3D aac_logical_to_phys(scmd_channel(cmd));
> +       cid =3D scmd_id(cmd);
> +       if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> +           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +               return FAILED;
> +
> +       pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> +              AAC_DRIVERNAME);
> +
> +       fib =3D aac_fib_alloc(aac);
> +       if (!fib)
> +               return ret;
> +
> +
> +       /* already tried, start a hard reset now */
> +       command =3D aac_eh_tmf_hard_reset_fib(aac, fib, bus, cid);
> +
> +       cmd->SCp.sent_command =3D 0;
> +
> +       status =3D aac_hba_send(command, fib,
> +                             (fib_callback) aac_hba_callback,
> +                             (void *) cmd);
> +
> +       /* Wait up to 15 seconds for completion */
> +       for (count =3D 0; count < 15; ++count) {
> +               if (cmd->SCp.sent_command) {
> +                       ret =3D SUCCESS;
> +                       break;
>                 }
> +               msleep(1000);
> +       }
>=20
> -               if (ret =3D=3D SUCCESS)
> -                       return ret;
> +       return ret;
> +}
> +
> +/*
> + *     aac_eh_bus_reset        - Bus reset command handling
> + *     @scsi_cmd:      SCSI command block causing the reset
> + *
> + */
> +static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
> +{
> +       struct scsi_device * dev =3D cmd->device;
> +       struct Scsi_Host * host =3D dev->host;
> +       struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
> +       int count;
> +       u32 bus, cid;
> +       int status =3D 0;
>=20
> -       } else {
>=20
> +       bus =3D aac_logical_to_phys(scmd_channel(cmd));
> +       cid =3D scmd_id(cmd);
> +       if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> +           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW) {
>                 /* Mark the assoc. FIB to not complete, eh handler does t=
his */
>                 for (count =3D 0;
>                         count < (host->can_queue + AAC_NUM_MGT_FIB);
> @@ -1409,7 +1470,9 @@ ssize_t aac_get_serial_number(struct device
> *device, char *buf)
>         .change_queue_depth             =3D aac_change_queue_depth,
>         .sdev_attrs                     =3D aac_dev_attrs,
>         .eh_abort_handler               =3D aac_eh_abort,
> -       .eh_bus_reset_handler           =3D aac_eh_reset,
> +       .eh_device_reset_handler        =3D aac_eh_dev_reset,
> +       .eh_target_reset_handler        =3D aac_eh_target_reset,
> +       .eh_bus_reset_handler           =3D aac_eh_bus_reset,
>         .eh_host_reset_handler          =3D aac_eh_host_reset,
>         .can_queue                      =3D AAC_NUM_IO_FIB,
>         .this_id                        =3D MAXIMUM_NUM_CONTAINERS,
> --
> 1.8.5.6

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
