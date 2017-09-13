From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 4/9] pm80xx : tag allocation for phy control request.
Date: Wed, 13 Sep 2017 13:10:11 +0200
Message-ID: <CAMGffEmCJ+bN3QmKupBu8Nk4ZQsZuv_9_vMOQJo7XrUheOKCmg@mail.gmail.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com> <20150217233650.9091-5-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36769 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdIMLKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 07:10:33 -0400
Received: by mail-wr0-f173.google.com with SMTP id o42so28003829wrb.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 04:10:33 -0700 (PDT)
In-Reply-To: <20150217233650.9091-5-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Feb 18, 2015 at 12:36 AM, Viswas G <Viswas.G@microsemi.com> wrote:
> tag is taken from the tag pool instead of using the hardcoded
> tag value(1).
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |  3 +++
>  drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
> index 10546faac58c..bc4a6f649ec9 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3198,11 +3198,13 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *=
pm8001_ha, void *piomb)
>
>  int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *pi=
omb)
>  {
> +       u32 tag;
>         struct local_phy_ctl_resp *pPayload =3D
>                 (struct local_phy_ctl_resp *)(piomb + 4);
>         u32 status =3D le32_to_cpu(pPayload->status);
>         u32 phy_id =3D le32_to_cpu(pPayload->phyop_phyid) & ID_BITS;
>         u32 phy_op =3D le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
> +       tag =3D le32_to_cpu(pPayload->tag);
>         if (status !=3D 0) {
>                 PM8001_MSG_DBG(pm8001_ha,
>                         pm8001_printk("%x phy execute %x phy op failed!\n=
",
> @@ -3211,6 +3213,7 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info=
 *pm8001_ha, void *piomb)
>                 PM8001_MSG_DBG(pm8001_ha,
>                         pm8001_printk("%x phy execute %x phy op success!\=
n",
>                         phy_id, phy_op));
> +       pm8001_tag_free(pm8001_ha, tag);
>         return 0;
>  }
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 2b26445d1b97..baab8a19c78e 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4500,17 +4500,21 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_=
hba_info *pm8001_ha,
>  static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
>         u32 phyId, u32 phy_op)
>  {
> +       u32 tag;
> +       int rc;
>         struct local_phy_ctl_req payload;
>         struct inbound_queue_table *circularQ;
>         int ret;
>         u32 opc =3D OPC_INB_LOCAL_PHY_CONTROL;
>         memset(&payload, 0, sizeof(payload));
> +       rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
> +       if (rc)
> +               return rc;
>         circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
> -       payload.tag =3D cpu_to_le32(1);
> +       payload.tag =3D cpu_to_le32(tag);
>         payload.phyop_phyid =3D
>                 cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
> -       ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,=
 0);
> -       return ret;
> +       return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, =
0);
>  }
>
>  static u32 pm80xx_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha=
)
> --
> 2.12.3
>

Thanks,
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>

--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
