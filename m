Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B6FC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E9A2070A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Oin4IWeq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgGUGAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 02:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUGAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 02:00:39 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EED4C061794
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 23:00:39 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t18so14202850otq.5
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 23:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UB1qEkT2Gd35QYm4XiZEmSlBQHbBcT98mLtV3t38Jf0=;
        b=Oin4IWeqDezw+GwOEqd/xudoesid0s8I9tlM+g6tW3AIGcORFW5ckFJswd9lDV3aXT
         /mzfZXQh97D+uTrcWSAcafZaKoNMjQLyAo4LQqwSdILgMh70ZLjj4V7tO4XeM8MJ5P/9
         oyQ7EmwVCfFw30TGpKxuzzfotKUg5pVWRBq00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UB1qEkT2Gd35QYm4XiZEmSlBQHbBcT98mLtV3t38Jf0=;
        b=jc6JPBWuPFMzp7F54/F3JJd3B2MWLArltoRDLjlhfrsP+WiJ+Y25BdCLnWoo7qqdjY
         gKVe02Pt9YRAD/g+uJuY8brbIrFpaIUd6q00GNVrDZ30pCKEFh4AmGdX58nJ3dZUDP5g
         tnR9dCKsBkVQCkMmxg0SEUjRA5EQEwNbLMM44S80F4cOLjeLpk2+l+FhCwzdvPnUdwz0
         yMXwsLTcilElP2eVJmR0guar1iINOPp90EmM2TcWwGO1vOIyh6wkrQFU8KKLH8SQionA
         5RD6iO1RlXSu5rHraWu8GhjL45GioNO6bQg6nSkVifUTQZq1mcsbuI91AZ/1TJfBsEuu
         6TzQ==
X-Gm-Message-State: AOAM530VP0edYH+dR/sWU0VEl4hRwk3VY37K5oJbbYhsqVtr+VZErvPi
        RCXdZymribmriXZi2iMWtJXVYUPzhTCuK6Dg0Zacwfmm1RB6vDRv
X-Google-Smtp-Source: ABdhPJwQYBmS13sD7c2xYwjWQfrlzHq1OXS3AYbvmG9tChpro6Tw1fUJclXYWtBhw9YfF+tdISfBQGWWH1Rjy14qnRI=
X-Received: by 2002:a05:6830:151a:: with SMTP id k26mr23824412otp.363.1595311238310;
 Mon, 20 Jul 2020 23:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200709133144.8363-1-thenzl@redhat.com>
In-Reply-To: <20200709133144.8363-1-thenzl@redhat.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Tue, 21 Jul 2020 11:30:12 +0530
Message-ID: <CAL2rwxpsQ0LL06RT-+qWcEHYDCg8xfF1Cx3hc+v5xR6w7Q_CHQ@mail.gmail.com>
Subject: Re: [PATCH V2] megaraid_sas: clear affinity hint
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 9, 2020 at 7:01 PM Tomas Henzl <thenzl@redhat.com> wrote:
>
> To avoid a warning in free_irq, clear the affinity hint.
>
> Fixes: f0b9e7bdc309e8cc63a640009715626376e047c6 ("scsi: megaraid_sas: Set affinity for high IOPS reply queues")
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Looks good to me.
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
> V2: Added 'Fixes' and low_latency_index_start check as
> asked by Sumit.
>
>  drivers/scsi/megaraid/megaraid_sas_base.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index a378facdd..b40279ae5 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5596,9 +5596,13 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
>                         &instance->irq_context[i])) {
>                         dev_err(&instance->pdev->dev,
>                                 "Failed to register IRQ for vector %d.\n", i);
> -                       for (j = 0; j < i; j++)
> +                       for (j = 0; j < i; j++) {
> +                               if (j < instance->low_latency_index_start)
> +                                       irq_set_affinity_hint(
> +                                               pci_irq_vector(pdev, j), NULL);
>                                 free_irq(pci_irq_vector(pdev, j),
>                                          &instance->irq_context[j]);
> +                       }
>                         /* Retry irq register for IO_APIC*/
>                         instance->msix_vectors = 0;
>                         instance->msix_load_balance = false;
> @@ -5636,6 +5640,9 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
>
>         if (instance->msix_vectors)
>                 for (i = 0; i < instance->msix_vectors; i++) {
> +                       if (i < instance->low_latency_index_start)
> +                               irq_set_affinity_hint(
> +                                   pci_irq_vector(instance->pdev, i), NULL);
>                         free_irq(pci_irq_vector(instance->pdev, i),
>                                  &instance->irq_context[i]);
>                 }
> --
> 2.21.3
>
