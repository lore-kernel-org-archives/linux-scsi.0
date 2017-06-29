From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 01/47] aacraid: split off functions to generate reset FIB
Date: Thu, 29 Jun 2017 19:59:44 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CC20@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0041.outbound.protection.outlook.com ([104.47.32.41]:47472
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751532AbdF2T7v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 15:59:51 -0400
In-Reply-To: <1498638793-44672-2-git-send-email-hare@suse.de>
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
> Subject: [PATCH 01/47] aacraid: split off functions to generate reset FIB
>=20
> EXTERNAL EMAIL
>=20
>=20
> Split off reset FIB generation into separate functions.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/linit.c | 83 ++++++++++++++++++++++++++------------=
--
> ----
>  1 file changed, 50 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 0f277df..9a8a27f 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -814,6 +814,52 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
>         return ret;
>  }
>=20
> +static u8 aac_eh_tmf_lun_reset_fib(struct aac_dev *aac, struct fib *fib,
> +                                  int bus, int cid, u64 tmf_lun)
> +{
> +       struct aac_hba_tm_req *tmf;
> +       u64 address;
> +
> +       /* start a HBA_TMF_LUN_RESET TMF request */
> +       tmf =3D (struct aac_hba_tm_req *)fib->hw_fib_va;
> +       memset(tmf, 0, sizeof(*tmf));
> +       tmf->tmf =3D HBA_TMF_LUN_RESET;
> +       tmf->it_nexus =3D aac->hba_map[bus][cid].rmw_nexus;
> +       int_to_scsilun(tmf_lun, (struct scsi_lun *)tmf->lun);
> +
> +       address =3D (u64)fib->hw_error_pa;
> +       tmf->error_ptr_hi =3D cpu_to_le32
> +               ((u32)(address >> 32));
> +       tmf->error_ptr_lo =3D cpu_to_le32
> +               ((u32)(address & 0xffffffff));
> +       tmf->error_length =3D cpu_to_le32(FW_ERROR_BUFFER_SIZE);
> +       fib->hbacmd_size =3D sizeof(*tmf);
> +
> +       return HBA_IU_TYPE_SCSI_TM_REQ;
> +}
> +
> +static u8 aac_eh_tmf_hard_reset_fib(struct aac_dev *aac, struct fib *fib=
,
> +                                   int bus, int cid)
> +{
> +       struct aac_hba_reset_req *rst;
> +       u64 address;
> +
> +       /* already tried, start a hard reset now */
> +       rst =3D (struct aac_hba_reset_req *)fib->hw_fib_va;
> +       memset(rst, 0, sizeof(*rst));
> +       /* reset_type is already zero... */
> +       rst->it_nexus =3D aac->hba_map[bus][cid].rmw_nexus;
> +
> +       address =3D (u64)fib->hw_error_pa;
> +       rst->error_ptr_hi =3D cpu_to_le32((u32)(address >> 32));
> +       rst->error_ptr_lo =3D cpu_to_le32
> +               ((u32)(address & 0xffffffff));
> +       rst->error_length =3D cpu_to_le32(FW_ERROR_BUFFER_SIZE);
> +       fib->hbacmd_size =3D sizeof(*rst);
> +
> +       return HBA_IU_TYPE_SATA_REQ;
> +}
> +
>  /*
>   *     aac_eh_reset    - Reset command handling
>   *     @scsi_cmd:      SCSI command block causing the reset
> @@ -840,7 +886,6 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
>                 aac->hba_map[bus][cid].devtype =3D=3D AAC_DEVTYPE_NATIVE_=
RAW) {
>                 struct fib *fib;
>                 int status;
> -               u64 address;
>                 u8 command;
>=20
>                 pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> @@ -852,42 +897,14 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
>=20
>=20
>                 if (aac->hba_map[bus][cid].reset_state =3D=3D 0) {
> -                       struct aac_hba_tm_req *tmf;
> -
>                         /* start a HBA_TMF_LUN_RESET TMF request */
> -                       tmf =3D (struct aac_hba_tm_req *)fib->hw_fib_va;
> -                       memset(tmf, 0, sizeof(*tmf));
> -                       tmf->tmf =3D HBA_TMF_LUN_RESET;
> -                       tmf->it_nexus =3D aac->hba_map[bus][cid].rmw_nexu=
s;
> -                       tmf->lun[1] =3D cmd->device->lun;
> -
> -                       address =3D (u64)fib->hw_error_pa;
> -                       tmf->error_ptr_hi =3D cpu_to_le32
> -                                       ((u32)(address >> 32));
> -                       tmf->error_ptr_lo =3D cpu_to_le32
> -                                       ((u32)(address & 0xffffffff));
> -                       tmf->error_length =3D cpu_to_le32(FW_ERROR_BUFFER=
_SIZE);
> -                       fib->hbacmd_size =3D sizeof(*tmf);
> -
> -                       command =3D HBA_IU_TYPE_SCSI_TM_REQ;
> +                       command =3D aac_eh_tmf_lun_reset_fib(aac, fib,
> +                                                          bus, cid,
> +                                                          cmd->device->l=
un);
>                         aac->hba_map[bus][cid].reset_state++;
>                 } else if (aac->hba_map[bus][cid].reset_state >=3D 1) {
> -                       struct aac_hba_reset_req *rst;
> -
>                         /* already tried, start a hard reset now */
> -                       rst =3D (struct aac_hba_reset_req *)fib->hw_fib_v=
a;
> -                       memset(rst, 0, sizeof(*rst));
> -                       /* reset_type is already zero... */
> -                       rst->it_nexus =3D aac->hba_map[bus][cid].rmw_nexu=
s;
> -
> -                       address =3D (u64)fib->hw_error_pa;
> -                       rst->error_ptr_hi =3D cpu_to_le32((u32)(address >=
> 32));
> -                       rst->error_ptr_lo =3D cpu_to_le32
> -                               ((u32)(address & 0xffffffff));
> -                       rst->error_length =3D cpu_to_le32(FW_ERROR_BUFFER=
_SIZE);
> -                       fib->hbacmd_size =3D sizeof(*rst);
> -
> -                       command =3D HBA_IU_TYPE_SATA_REQ;
> +                       command =3D aac_eh_tmf_hard_reset_fib(aac, fib, b=
us, cid);
>                         aac->hba_map[bus][cid].reset_state =3D 0;
>                 }
>                 cmd->SCp.sent_command =3D 0;

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
