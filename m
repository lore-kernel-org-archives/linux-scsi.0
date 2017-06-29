From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 07/47] aacraid: complete all commands during bus reset
Date: Thu, 29 Jun 2017 20:07:46 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CCCA@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:65344
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751612AbdF2UIQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 16:08:16 -0400
In-Reply-To: <1498638793-44672-8-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Wednesday, June 28, 2017 1:33 AM
> To: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCH 07/47] aacraid: complete all commands during bus reset
>=20
> EXTERNAL EMAIL
>=20
>=20
> When issuing a bus reset we should complete all commands, not
> just the command triggering the reset.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/linit.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 9b284a0..c26130e 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1007,23 +1007,29 @@ static int aac_eh_bus_reset(struct scsi_cmnd*
> cmd)
>         struct Scsi_Host * host =3D dev->host;
>         struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
>         int count;
> -       u32 bus, cid;
> +       u32 cmd_bus;
>         int status =3D 0;
>=20
>=20
> -       bus =3D aac_logical_to_phys(scmd_channel(cmd));
> -       cid =3D scmd_id(cmd);
> -       if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> -           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW) {
> -               /* Mark the assoc. FIB to not complete, eh handler does t=
his */
> -               for (count =3D 0;
> -                       count < (host->can_queue + AAC_NUM_MGT_FIB);
> -                       ++count) {
> -                       struct fib *fib =3D &aac->fibs[count];
> -
> -                       if (fib->hw_fib_va->header.XferState &&
> -                               (fib->flags & FIB_CONTEXT_FLAG) &&
> -                               (fib->callback_data =3D=3D cmd)) {
> +       cmd_bus =3D aac_logical_to_phys(scmd_channel(cmd));
> +       /* Mark the assoc. FIB to not complete, eh handler does this */
> +       for (count =3D 0; count < (host->can_queue + AAC_NUM_MGT_FIB);
> ++count) {
> +               struct fib *fib =3D &aac->fibs[count];
> +
> +               if (fib->hw_fib_va->header.XferState &&
> +                   (fib->flags & FIB_CONTEXT_FLAG) &&
> +                   (fib->flags & FIB_CONTEXT_FLAG_SCSI_CMD)) {
> +                       struct aac_hba_map_info *info;
> +                       u32 bus, cid;
> +
> +                       cmd =3D (struct scsi_cmnd *)fib->callback_data;
> +                       bus =3D aac_logical_to_phys(scmd_channel(cmd));
> +                       if (bus !=3D cmd_bus)
> +                               continue;
> +                       cid =3D scmd_id(cmd);
> +                       info =3D &aac->hba_map[bus][cid];
> +                       if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TA=
RGETS ||
> +                           info->devtype !=3D AAC_DEVTYPE_NATIVE_RAW) {
>                                 fib->flags |=3D FIB_CONTEXT_FLAG_TIMED_OU=
T;
>                                 cmd->SCp.phase =3D AAC_OWNER_ERROR_HANDLE=
R;
>                         }
> --
> 1.8.5.6

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
