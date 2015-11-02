From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 8/8] pm80xx: avoid a panic if MSI(X) interrupts are disabled
Date: Mon, 2 Nov 2015 09:12:54 +0100
Message-ID: <CAD+HZHW=JVu_fw8PSs5nJBvd9H81LTOqif2_nuQf1w+OGsa=YQ@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-9-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33066 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbKBIMz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:12:55 -0500
Received: by lfbf136 with SMTP id f136so43999911lfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:12:54 -0800 (PST)
In-Reply-To: <1446216811-2248-9-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> If MSI(X) interrupts are disabled via the kernel command line
> (pci=nomsi), the pm8001 driver will kernel panic because it does not
> detect that MSI interrupts are disabled and will soldier on and attempt to
> configure MSI interrupts anyways.  This leads to a kernel panic, most
> likely because a required data structure is not available down the
> line.  Using the pci_msi_enabled() function in order to detect if MSI
> interrupts are enabled before configuring them resolves this issue and
> avoids a kernel panic when the module is loaded.  Additionally, the
> irq_vector structure must be initialized when legacy interrupts are
> being used otherwise legacy interrupts will simply not function and
> result in another panic.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index ab99984..bdc624f 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -482,7 +482,8 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>
>  #ifdef PM8001_USE_TASKLET
>         /* Tasklet for non msi-x interrupt handler */
> -       if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
> +       if ((!pdev->msix_cap || !pci_msi_enabled())
> +           || (pm8001_ha->chip_id == chip_8001))
>                 tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
>                         (unsigned long)&(pm8001_ha->irq_vector[0]));
>         else
> @@ -951,7 +952,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
>         pdev = pm8001_ha->pdev;
>
>  #ifdef PM8001_USE_MSIX
> -       if (pdev->msix_cap)
> +       if (pdev->msix_cap && pci_msi_enabled())
>                 return pm8001_setup_msix(pm8001_ha);
>         else {
>                 PM8001_INIT_DBG(pm8001_ha,
> @@ -962,6 +963,8 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
>
>  intx:
>         /* initialize the INT-X interrupt */
> +       pm8001_ha->irq_vector[0].irq_id = 0;
> +       pm8001_ha->irq_vector[0].drv_inst = pm8001_ha;
>         rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
>                 DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
>         return rc;
> @@ -1112,7 +1115,8 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>  #endif
>  #ifdef PM8001_USE_TASKLET
>         /* For non-msix and msix interrupts */
> -       if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
> +       if ((!pdev->msix_cap || !pci_msi_enabled()) ||
> +           (pm8001_ha->chip_id == chip_8001))
>                 tasklet_kill(&pm8001_ha->tasklet[0]);
>         else
>                 for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
> @@ -1161,7 +1165,8 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  #endif
>  #ifdef PM8001_USE_TASKLET
>         /* For non-msix and msix interrupts */
> -       if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
> +       if ((!pdev->msix_cap || !pci_msi_enabled()) ||
> +           (pm8001_ha->chip_id == chip_8001))
>                 tasklet_kill(&pm8001_ha->tasklet[0]);
>         else
>                 for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
> @@ -1231,7 +1236,8 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>                 goto err_out_disable;
>  #ifdef PM8001_USE_TASKLET
>         /*  Tasklet for non msi-x interrupt handler */
> -       if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
> +       if ((!pdev->msix_cap || !pci_msi_enabled()) ||
> +           (pm8001_ha->chip_id == chip_8001))
>                 tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
>                         (unsigned long)&(pm8001_ha->irq_vector[0]));
>         else
> --
> 2.4.3
>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack
