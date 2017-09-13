From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 8/9] pm80xx : panic on ncq error cleaning up the read log.
Date: Wed, 13 Sep 2017 13:13:09 +0200
Message-ID: <CAMGffEk7R+eU3TP5Kd5KhLQOAwMy4sb_CS55Hc4m5kmpWdwr-Q@mail.gmail.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com> <20150217233650.9091-9-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:45174 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdIMLNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 07:13:31 -0400
Received: by mail-wm0-f53.google.com with SMTP id g206so3965990wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 04:13:30 -0700 (PDT)
In-Reply-To: <20150217233650.9091-9-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Feb 18, 2015 at 12:36 AM, Viswas G <Viswas.G@microsemi.com> wrote:
> when there's an error in 'ncq mode' the host has to read the ncq
> error log (10h) to clear the error state. however, the ccb that
> is setup for doing this doesn't setup the ccb so that the
> previous state is cleared. if the ccb was previously used for an IO
> n_elems is set and pm8001_ccb_task_free() treats this as the signal
> to go free a scatter-gather list (that's already been free-ed).
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 92d2045dea68..f2c0839afbe3 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1489,6 +1489,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
>         ccb->device =3D pm8001_ha_dev;
>         ccb->ccb_tag =3D ccb_tag;
>         ccb->task =3D task;
> +       ccb->n_elem =3D 0;
>         pm8001_ha_dev->id |=3D NCQ_READ_LOG_FLAG;
>         pm8001_ha_dev->id |=3D NCQ_2ND_RLE_FLAG;
>
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
