From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 6/9] pm80xx : modified port reset timer value for
 PM8006 card
Date: Wed, 13 Sep 2017 13:10:38 +0200
Message-ID: <CAMGffEmd2_dWAxEeNVkvG8qVtVDA+9QBd8BWE4ndEE5bFiC7Lg@mail.gmail.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com> <20150217233650.9091-7-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35863 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbdIMLK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 07:10:59 -0400
Received: by mail-wr0-f173.google.com with SMTP id o42so28006189wrb.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 04:10:59 -0700 (PDT)
In-Reply-To: <20150217233650.9091-7-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Feb 18, 2015 at 12:36 AM, Viswas G <Viswas.G@microsemi.com> wrote:
> Added port reset timer value as 2000ms for PM8006 sata controller.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index baab8a19c78e..8f1f5dc77d71 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -597,6 +597,12 @@ static void update_main_config_table(struct pm8001_h=
ba_info *pm8001_ha)
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &=3D 0xfff=
f0000;
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=3D
>                                                         PORT_RECOVERY_TIM=
EOUT;
> +       if (pm8001_ha->chip_id =3D=3D chip_8006) {
> +               pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &=
=3D
> +                                       0x0000ffff;
> +               pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
=3D
> +                                       0x140000;
> +       }
>         pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
>                         pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_=
timer);
>  }
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
