From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 4/7] aacraid: use aac_tmf_callback for reset fib
Date: Wed, 5 Jul 2017 18:09:01 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C33181@avsrvexchmbx2.microsemi.net>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
 <1498843092-76285-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0073.outbound.protection.outlook.com ([104.47.37.73]:46329
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751664AbdGESJP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Jul 2017 14:09:15 -0400
In-Reply-To: <1498843092-76285-5-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, June 30, 2017 10:18 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCH 4/7] aacraid: use aac_tmf_callback for reset fib
>=20
> EXTERNAL EMAIL
>=20
>=20
> When sending a reset fib we shouldn't rely on the scsi command,
> but rather set the TMF status in the map_info->reset_state variable.
> That allows us to send a TMF independent on a scsi command.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/linit.c | 99 +++++++++++++++++++++++++++++++++---
> --------
>  1 file changed, 74 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 57b2077..e5d2d91 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -814,8 +814,8 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
>         return ret;
>  }
>=20
> -static u8 aac_eh_tmf_lun_reset_fib(struct aac_dev *aac, struct fib *fib,
> -                                  int bus, int cid, u64 tmf_lun)
> +static u8 aac_eh_tmf_lun_reset_fib(struct aac_hba_map_info *info,
> +                                  struct fib *fib, u64 tmf_lun)
>  {
>         struct aac_hba_tm_req *tmf;
>         u64 address;
> @@ -824,7 +824,7 @@ static u8 aac_eh_tmf_lun_reset_fib(struct aac_dev
> *aac, struct fib *fib,
>         tmf =3D (struct aac_hba_tm_req *)fib->hw_fib_va;
>         memset(tmf, 0, sizeof(*tmf));
>         tmf->tmf =3D HBA_TMF_LUN_RESET;
> -       tmf->it_nexus =3D aac->hba_map[bus][cid].rmw_nexus;
> +       tmf->it_nexus =3D info->rmw_nexus;
>         int_to_scsilun(tmf_lun, (struct scsi_lun *)tmf->lun);
>=20
>         address =3D (u64)fib->hw_error_pa;
> @@ -838,8 +838,8 @@ static u8 aac_eh_tmf_lun_reset_fib(struct aac_dev
> *aac, struct fib *fib,
>         return HBA_IU_TYPE_SCSI_TM_REQ;
>  }
>=20
> -static u8 aac_eh_tmf_hard_reset_fib(struct aac_dev *aac, struct fib *fib=
,
> -                                   int bus, int cid)
> +static u8 aac_eh_tmf_hard_reset_fib(struct aac_hba_map_info *info,
> +                                   struct fib *fib)
>  {
>         struct aac_hba_reset_req *rst;
>         u64 address;
> @@ -847,8 +847,7 @@ static u8 aac_eh_tmf_hard_reset_fib(struct aac_dev
> *aac, struct fib *fib,
>         /* already tried, start a hard reset now */
>         rst =3D (struct aac_hba_reset_req *)fib->hw_fib_va;
>         memset(rst, 0, sizeof(*rst));
> -       /* reset_type is already zero... */
> -       rst->it_nexus =3D aac->hba_map[bus][cid].rmw_nexus;
> +       rst->it_nexus =3D info->rmw_nexus;
>=20
>         address =3D (u64)fib->hw_error_pa;
>         rst->error_ptr_hi =3D cpu_to_le32((u32)(address >> 32));
> @@ -860,6 +859,33 @@ static u8 aac_eh_tmf_hard_reset_fib(struct aac_dev
> *aac, struct fib *fib,
>         return HBA_IU_TYPE_SATA_REQ;
>  }
>=20
> +void aac_tmf_callback(void *context, struct fib *fibptr)
> +{
> +       struct aac_hba_resp *err =3D
> +               &((struct aac_native_hba *)fibptr->hw_fib_va)->resp.err;
> +       struct aac_hba_map_info *info =3D context;
> +       int res;
> +
> +       switch (err->service_response) {
> +       case HBA_RESP_SVCRES_TMF_REJECTED:
> +               res =3D -1;
> +               break;
> +       case HBA_RESP_SVCRES_TMF_LUN_INVALID:
> +               res =3D 0;
> +               break;
> +       case HBA_RESP_SVCRES_TMF_COMPLETE:
> +       case HBA_RESP_SVCRES_TMF_SUCCEEDED:
> +               res =3D 0;
> +               break;
> +       default:
> +               res =3D -2;
> +               break;
> +       }
> +       aac_fib_complete(fibptr);
> +
> +       info->reset_state =3D res;
> +}
> +
>  /*
>   *     aac_eh_dev_reset        - Device reset command handling
>   *     @scsi_cmd:      SCSI command block causing the reset
> @@ -870,6 +896,7 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
>         struct scsi_device * dev =3D cmd->device;
>         struct Scsi_Host * host =3D dev->host;
>         struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
> +       struct aac_hba_map_info *info;
>         int count;
>         u32 bus, cid;
>         struct fib *fib;
> @@ -879,8 +906,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
>=20
>         bus =3D aac_logical_to_phys(scmd_channel(cmd));
>         cid =3D scmd_id(cmd);
> +       info =3D &aac->hba_map[bus][cid];
>         if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> -           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +           info->devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +               return FAILED;
> +
> +       if (info->reset_state > 0)
>                 return FAILED;
>=20
>         pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> @@ -890,21 +921,19 @@ static int aac_eh_dev_reset(struct scsi_cmnd
> *cmd)
>         if (!fib)
>                 return ret;
>=20
> -
>         /* start a HBA_TMF_LUN_RESET TMF request */
> -       command =3D aac_eh_tmf_lun_reset_fib(aac, fib, bus, cid,
> -                                          cmd->device->lun);
> +       command =3D aac_eh_tmf_lun_reset_fib(info, fib, dev->lun);
>=20
> -       cmd->SCp.sent_command =3D 0;
> +       info->reset_state =3D 1;
>=20
>         status =3D aac_hba_send(command, fib,
> -                             (fib_callback) aac_hba_callback,
> -                             (void *) cmd);
> +                             (fib_callback) aac_tmf_callback,
> +                             (void *) info);
>=20
>         /* Wait up to 15 seconds for completion */
>         for (count =3D 0; count < 15; ++count) {
> -               if (cmd->SCp.sent_command) {
> -                       ret =3D SUCCESS;
> +               if (info->reset_state =3D=3D 0) {
> +                       ret =3D info->reset_state =3D=3D 0 ? SUCCESS : FA=
ILED;
>                         break;
>                 }
>                 msleep(1000);
> @@ -923,6 +952,7 @@ static int aac_eh_target_reset(struct scsi_cmnd
> *cmd)
>         struct scsi_device * dev =3D cmd->device;
>         struct Scsi_Host * host =3D dev->host;
>         struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
> +       struct aac_hba_map_info *info;
>         int count;
>         u32 bus, cid;
>         int ret =3D FAILED;
> @@ -932,8 +962,12 @@ static int aac_eh_target_reset(struct scsi_cmnd
> *cmd)
>=20
>         bus =3D aac_logical_to_phys(scmd_channel(cmd));
>         cid =3D scmd_id(cmd);
> +       info =3D &aac->hba_map[bus][cid];
>         if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> -           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +           info->devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +               return FAILED;
> +
> +       if (info->reset_state > 0)
>                 return FAILED;
>=20
>         pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> @@ -945,18 +979,18 @@ static int aac_eh_target_reset(struct scsi_cmnd
> *cmd)
>=20
>=20
>         /* already tried, start a hard reset now */
> -       command =3D aac_eh_tmf_hard_reset_fib(aac, fib, bus, cid);
> +       command =3D aac_eh_tmf_hard_reset_fib(info, fib);
>=20
> -       cmd->SCp.sent_command =3D 0;
> +       info->reset_state =3D 2;
>=20
>         status =3D aac_hba_send(command, fib,
> -                             (fib_callback) aac_hba_callback,
> -                             (void *) cmd);
> +                             (fib_callback) aac_tmf_callback,
> +                             (void *) info);
>=20
>         /* Wait up to 15 seconds for completion */
>         for (count =3D 0; count < 15; ++count) {
> -               if (cmd->SCp.sent_command) {
> -                       ret =3D SUCCESS;
> +               if (info->reset_state <=3D 0) {
> +                       ret =3D info->reset_state =3D=3D 0 ? SUCCESS : FA=
ILED;
>                         break;
>                 }
>                 msleep(1000);
> @@ -1044,8 +1078,23 @@ int aac_eh_host_reset(struct scsi_cmnd *cmd)
>          && aac_check_reset
>          && (aac_check_reset !=3D -1 || !is_ignore_reset)) {
>                 /* Bypass wait for command quiesce */
> -               aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
> -               ret =3D SUCCESS;
> +               if (aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET) =3D=3D 0)
> +                       ret =3D SUCCESS;
> +       }
> +       /*
> +        * Reset EH state
> +        */
> +       if (ret =3D=3D SUCCESS) {
> +               int bus, cid;
> +               struct aac_hba_map_info *info;
> +
> +               for (bus =3D 0; bus < AAC_MAX_BUSES; bus++) {
> +                       for (cid =3D 0; cid < AAC_MAX_TARGETS; cid++) {
> +                               info =3D &aac->hba_map[bus][cid];
> +                               if (info->devtype =3D=3D AAC_DEVTYPE_NATI=
VE_RAW)
> +                                       info->reset_state =3D 0;
> +                       }
> +               }
>         }
>         return ret;
>  }
> --
> 1.8.5.6

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
