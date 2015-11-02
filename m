From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 7/8] pm80xx: wait a minimum of 500ms before issuing
 commands to SPCv
Date: Mon, 2 Nov 2015 09:12:30 +0100
Message-ID: <CAD+HZHU-2V0R1uRAqauxFWuSsC0qGLsGCoVrBgmbhp2LADbfdg@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-8-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35209 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbKBIMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:12:32 -0500
Received: by lbbes7 with SMTP id es7so82510347lbb.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:12:30 -0800 (PST)
In-Reply-To: <1446216811-2248-8-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> The documentation for the 8070 and 8072 SPCv chip explicitly states that
> a minimum of 500ms must elapse before issuing commands, otherwise the
> SPCv may not process them and the firmware may get into an unrecoverable
> state requiring a reboot.  While the Linux guys will probably think this
> is 'racy', it is called out in the chip documentation and inserting this
> delay makes power management function properly.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index a0e55d4..ab99984 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1190,6 +1190,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>         int rc;
>         u8 i = 0, j;
>         u32 device_state;
> +       u32 wait_count;
>         DECLARE_COMPLETION_ONSTACK(completion);
>         pm8001_ha = sha->lldd_ha;
>         device_state = pdev->current_state;
> @@ -1243,6 +1244,17 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>                 for (i = 1; i < pm8001_ha->number_of_intr; i++)
>                         PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
>         }
> +
> +       if (pm8001_ha->chip_id == chip_8070 ||
> +               pm8001_ha->chip_id == chip_8072) {
> +               wait_count = 500;
> +               do {
> +                       mdelay(1);
> +               } while (--wait_count);
> +       }
> +
> +       /* Spin up the PHYs */
> +
>         pm8001_ha->flags = PM8001F_RUN_TIME;
>         for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
>                 pm8001_ha->phy[i].enable_completion = &completion;
> --
> 2.4.3
>
Could we simply mdelay(500) instead the loop?
Also better to add a comment around.

Thanks,
Jack
