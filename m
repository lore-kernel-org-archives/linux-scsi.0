From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 5/6] pm80xx : panic on ncq error cleaning up the read log
Date: Tue, 29 Aug 2017 13:49:32 +0200
Message-ID: <CAD+HZHUt9LUKb5VG1bb6h+wWL_G4c+wJdnjTd1==bZoeQJWWpw@mail.gmail.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com> <20150130060645.23653-6-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36101 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdH2Ltd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 07:49:33 -0400
Received: by mail-wm0-f68.google.com with SMTP id j72so3452310wmi.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2017 04:49:33 -0700 (PDT)
In-Reply-To: <20150130060645.23653-6-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com

2015-01-30 7:06 GMT+01:00 Viswas G <Viswas.G@microsemi.com>:
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
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ae9252cf1706..e75b0aa497f0 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1489,6 +1489,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
>         ccb->device = pm8001_ha_dev;
>         ccb->ccb_tag = ccb_tag;
>         ccb->task = task;
> +       ccb->n_elem = 0;
>         pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
>         pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
>
> --
> 2.12.3
>
Thanks.
Looks good to me!
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
