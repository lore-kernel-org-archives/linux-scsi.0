Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F56C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 11:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDCFC21734
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 11:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="gTRTfxAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgABLwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 06:52:17 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44532 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgABLwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 06:52:17 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so33859218iln.11
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2020 03:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChT5QRhB+HU0xnOUq9zaJHL2udftBPqSh9wSSSkUm/8=;
        b=gTRTfxAP1ViZQ2bay90TDe/VhU/Wk6e9FWJ4LDPiMy+OyyPgTgWNDRB8pioKwTfeVB
         Spzhy2Rf2m9DS1aARxeqT5jK3iZ90KJvmIFZNXExbgX/W1EOERLgSKThPbZ1MDWlbw1Y
         IhS1tWVbgKEwnDtN3MKmacjkCNFVScWdZSpgynPSO8LCabzF4RHEa0fhvMt8SltX0owl
         Kyu3tzqM9Or8sq3RnVgzxMF7//dMEPRxfnlgGzsbvnPEZtQhGxp62clUZBGQPwk2JTO1
         iEsGGXVARNAIrqqHkJ3sG7zimqYXiFbzbjJt3HY1rcZ2HGGUwqBilExuCDnZQq89kPdl
         LZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChT5QRhB+HU0xnOUq9zaJHL2udftBPqSh9wSSSkUm/8=;
        b=QR+csh2HX6ka5CG47BGjjs1i+gMcWslwYLQPq1IljzVZBrN9nIc8L+wdY6oCfePhwX
         tbaykEFOvrzUv2R5prO5E+W9D9JzuRYt+MSDLsHmxCkn7KADgn3s+zOEWMtV9+cZVR2e
         BYTnRth+4A1+2uviiMq5AKIL0dsK3lKbupRm61mfCcUdsbjubGRS9dkkoxsS9hAHBoNP
         QBTHYsmQfqGfXzB0TeJusxiN+jiFJ7I7Mzjpan/dx07B4oiMkN3PJGxvEQbrLLRvDaSU
         PO5o8mURbhJ1LeT8zdnIkRoAXU1PX56LJeoC2Glp2dGGn8J++6/eXXiG37UP6q23WyDQ
         MEwQ==
X-Gm-Message-State: APjAAAX2v0KfM3rb0NKAyRiVgCp7hHlfAFysmv3m4QqR6QsMFEgSMnFB
        HHlGZS2U5WCh3Zw1YRgt8UbbPo7cHtwQnIB1ZK54Bg==
X-Google-Smtp-Source: APXvYqzc3p4Lgkxbpv9xOVUd5RJ9N58sLJ0kyhmL+yvvmWPliELJbVNFDhasdfl4ZudGJhlsenmpdvMq6MCJxC39yAo=
X-Received: by 2002:a92:8d88:: with SMTP id w8mr71560257ill.71.1577965936122;
 Thu, 02 Jan 2020 03:52:16 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-3-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-3-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 2 Jan 2020 12:52:05 +0100
Message-ID: <CAMGffEkyNY4BkbZwSMYX6z0gP21LULiV-qkTsJ7h_Mx_OXc5kw@mail.gmail.com>
Subject: Re: [PATCH 02/12] pm80xx : Deal with kexec reboots.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com, radha@google.com,
        akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:40 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Vikram Auradkar <auradkar@google.com>
>
> A kexec reboot causes the controller fw to assert. This assertion
> shows up in two ways, the controller doesn't show up as ready and
> an interrupt is waiting as soon as the handler is registered. To
> resolve this added below fix:
> -split the interrupt handling setup into two parts, setup and
>  request.
> -If the controller ready register indicates not-ready, but that the
>  not readiness is only on the IOC units we can still try a reset to
>  bring the system back to the pre-reboot state.
>
> Signed-off-by: Vikram Auradkar <auradkar@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>

The patch looks fine, Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
ps: the signed-off-by chain was surprisingly long for such simple
patch, do they all contribute to the patch?
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 48 +++++++++++++++++++++++++++++++++++----
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 15 ++++++++----
>  2 files changed, 54 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 3f1e755c52c6..a002eb5a3fe4 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -248,6 +248,9 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
>         return ret;
>  }
>
> +static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha);
> +static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
> +
>  /**
>   * pm8001_alloc - initiate our hba structure and 6 DMAs area.
>   * @pm8001_ha:our hba structure.
> @@ -890,9 +893,7 @@ static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
>   */
>  static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  {
> -       u32 i = 0, j = 0;
>         u32 number_of_intr;
> -       int flag = 0;
>         int rc;
>
>         /* SPCv controllers supports 64 msi-x */
> @@ -900,11 +901,11 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>                 number_of_intr = 1;
>         } else {
>                 number_of_intr = PM8001_MAX_MSIX_VEC;
> -               flag &= ~IRQF_SHARED;
>         }
>
>         rc = pci_alloc_irq_vectors(pm8001_ha->pdev, number_of_intr,
>                         number_of_intr, PCI_IRQ_MSIX);
> +       number_of_intr = rc;
>         if (rc < 0)
>                 return rc;
>         pm8001_ha->number_of_intr = number_of_intr;
> @@ -912,8 +913,22 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>         PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
>                 "pci_alloc_irq_vectors request ret:%d no of intr %d\n",
>                                 rc, pm8001_ha->number_of_intr));
> +       return 0;
> +}
> +
> +static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
> +{
> +       u32 i = 0, j = 0;
> +       int flag = 0, rc = 0;
>
> -       for (i = 0; i < number_of_intr; i++) {
> +       if (pm8001_ha->chip_id != chip_8001)
> +               flag &= ~IRQF_SHARED;
> +
> +       PM8001_INIT_DBG(pm8001_ha,
> +               pm8001_printk("pci_enable_msix request number of intr %d\n",
> +               pm8001_ha->number_of_intr));
> +
> +       for (i = 0; i < pm8001_ha->number_of_intr; i++) {
>                 snprintf(pm8001_ha->intr_drvname[i],
>                         sizeof(pm8001_ha->intr_drvname[0]),
>                         "%s-%d", pm8001_ha->name, i);
> @@ -938,6 +953,21 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  }
>  #endif
>
> +static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
> +{
> +       struct pci_dev *pdev;
> +
> +       pdev = pm8001_ha->pdev;
> +
> +#ifdef PM8001_USE_MSIX
> +       if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
> +               return pm8001_setup_msix(pm8001_ha);
> +       PM8001_INIT_DBG(pm8001_ha,
> +               pm8001_printk("MSIX not supported!!!\n"));
> +#endif
> +       return 0;
> +}
> +
>  /**
>   * pm8001_request_irq - register interrupt
>   * @chip_info: our ha struct.
> @@ -951,7 +981,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
>
>  #ifdef PM8001_USE_MSIX
>         if (pdev->msix_cap && pci_msi_enabled())
> -               return pm8001_setup_msix(pm8001_ha);
> +               return pm8001_request_msix(pm8001_ha);
>         else {
>                 PM8001_INIT_DBG(pm8001_ha,
>                         pm8001_printk("MSIX not supported!!!\n"));
> @@ -1033,6 +1063,13 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>                 rc = -ENOMEM;
>                 goto err_out_free;
>         }
> +       /* Setup Interrupt */
> +       rc = pm8001_setup_irq(pm8001_ha);
> +       if (rc) {
> +               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +                       "pm8001_setup_irq failed [ret: %d]\n", rc));
> +               goto err_out_shost;
> +       }
>         list_add_tail(&pm8001_ha->list, &hba_list);
>         PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>         rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
> @@ -1045,6 +1082,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>         rc = scsi_add_host(shost, &pdev->dev);
>         if (rc)
>                 goto err_out_ha_free;
> +       /* Request Interrupt */
>         rc = pm8001_request_irq(pm8001_ha);
>         if (rc) {
>                 PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 98dcdbd146d5..d805fd036ddf 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1438,11 +1438,18 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>         if (!pm8001_ha->controller_fatal_error) {
>                 /* Check if MPI is in ready state to reset */
>                 if (mpi_uninit_check(pm8001_ha) != 0) {
> -                       regval = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> +                       u32 r0 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
> +                       u32 r1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> +                       u32 r2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
> +                       u32 r3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
>                         PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> -                               "MPI state is not ready scratch1 :0x%x\n",
> -                               regval));
> -                       return -1;
> +                               "MPI state is not ready scratch: %x:%x:%x:%x\n",
> +                               r0, r1, r2, r3));
> +                       /* if things aren't ready but the bootloader is ok then
> +                        * try the reset anyway.
> +                        */
> +                       if (r1 & SCRATCH_PAD1_BOOTSTATE_MASK)
> +                               return -1;
>                 }
>         }
>         /* checked for reset register normal state; 0x0 */
> --
> 2.16.3
>
