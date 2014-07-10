From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: [PATCH 2/4] scsi: pm8001: fix update_flash
Date: Thu, 10 Jul 2014 10:25:44 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E49DC3A54@BBYEXM02.pmc-sierra.internal>
References: <1404746401-25229-2-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60384 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbaGJKZq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 06:25:46 -0400
In-Reply-To: <1404746401-25229-2-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>



On Mon, Jul 7, 2014 at 8:49 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> The driver checks the return valu, but after he tries to wait_for_completion
> which might never happen.
> Also the ioctlbuffer is freed at the end of the function,
> so the first removal is not needed.

Looks good. Thanks Tomas.
Acked-by: Suresh Thiagarajan<Suresh.Thiagarajan@pmcs.com>

>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 211ffd6..e9753bd 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -617,11 +617,11 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>
>                 pm8001_ha->nvmd_completion = &completion;
>                 ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);
> +               if (ret)
> +                       break;
>                 wait_for_completion(&completion);
> -               if (ret || (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS)) {
> +               if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
>                         ret = fwControl->retcode;
> -                       kfree(ioctlbuffer);
> -                       ioctlbuffer = NULL;
>                         break;
>                 }
>         }
> --
> 1.8.3.1
