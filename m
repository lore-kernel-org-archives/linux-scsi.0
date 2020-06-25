Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C682FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 19:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910E920767
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 19:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OUrQzZQx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405916AbgFYT0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 15:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405229AbgFYT0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 15:26:36 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EFEC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 12:26:36 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n5so6396776otj.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 12:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hq3i0heQe2gXisAJAumhj7skt5m1T9rFNrUMT0bl4ss=;
        b=OUrQzZQx6ZLmypqNFlEqo6WXOpx8ix9JWUg6tncCEUfjyMsFMT17OpUQz6OZ7T65vR
         V/sa/tDwTqBvUSbPAYy3iIUK2VSXh0gBh/X8i4IO75SovLf7SC02V4K09yVHE0qBLZmE
         T0fuL6hM8tvi8sRKL2gdoVtt4Nx3kayrtjdOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hq3i0heQe2gXisAJAumhj7skt5m1T9rFNrUMT0bl4ss=;
        b=RxgFot0w36OLjmYl4FquIBrY+oBFG0dsVTS4g/bpj3WKYvRr3pIwLEH4OIro+SNTzN
         lsEMCSC1R1ILQDeaDD4Xa6JbNj0dQKDrl6/9IO9zwzh5si5vlZvMqWQqZBOwVe4lIDpE
         LZ4RU/5gpH4yp/OnxYAmDD1i9114WqTafTgwHaRu0lvujvncksktehbM1G3/QkX+mvWY
         48Zfr8CtS39oIEmF54kodg61ljhFZdQu7k77KF/YVMrVhj7rA0yaRdDKKgovAMytcCx/
         5BoV/UTHDmFVPI5sIpoywfxrd+VsFgzq5bWxElWDxUdu0uUDunNxTj/8tTcQqdzq+gwh
         XG9w==
X-Gm-Message-State: AOAM533X+80VB2/Nl1WH/YKFz0qpGM/MuzZrva06JeEFrsEG9IinzF1x
        iQbvl9qbaZCms+N0FZOhw3jmpoaRrixc4eDWYygoVtmdZneyiA==
X-Google-Smtp-Source: ABdhPJy1nabDm7NBqv9uOVw4uMZJmY+21qPFVnrZ9EdKWvhPP6mmyvgkJaHBFuA1Q6EdH1gQN0+4bYPlbJnuT+4Gs3I=
X-Received: by 2002:a9d:17ce:: with SMTP id j72mr27376438otj.211.1593113195946;
 Thu, 25 Jun 2020 12:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200625171220.9168-1-thenzl@redhat.com>
In-Reply-To: <20200625171220.9168-1-thenzl@redhat.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Fri, 26 Jun 2020 00:56:09 +0530
Message-ID: <CAL2rwxpp_kETCaVG_ZSS4Cmkh6J6MsHL-JK9UKUpq6w_pV_XZg@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: clear affinity hint
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

On Thu, Jun 25, 2020 at 10:42 PM Tomas Henzl <thenzl@redhat.com> wrote:
>
> Affinity hint should be cleared before freeing irq.
Hi Tomas,

megaraid_sas driver setups IRQ affinity(non-managed) for MSI-x index
"0" to "instance->low_latency_index_start - 1".
Rest of MSI-x indices- "instance->low_latency_index_start" to
"instance->msix_vectors -1" are managed (API- pci_alloc_irq_affinity()
takes care of this)
so calling irq_set_affinity_hint() for managed IRQs does not seem
right. Please try setting affinity to NULL for only this range- "0" to
 "instance->low_latency_index_start -1" and see if it solves your
problem.

Also, is it regression due to below commit:

f0b9e7bdc309 scsi: megaraid_sas: Set affinity for high IOPS reply queues

Thanks,
Sumit
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 00668335c..d5626ad8b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5602,9 +5602,11 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
>                         &instance->irq_context[i])) {
>                         dev_err(&instance->pdev->dev,
>                                 "Failed to register IRQ for vector %d.\n", i);
> -                       for (j = 0; j < i; j++)
> +                       for (j = 0; j < i; j++) {
> +                               irq_set_affinity_hint(pci_irq_vector(pdev, j), NULL);
>                                 free_irq(pci_irq_vector(pdev, j),
>                                          &instance->irq_context[j]);
> +                       }
>                         /* Retry irq register for IO_APIC*/
>                         instance->msix_vectors = 0;
>                         instance->msix_load_balance = false;
> @@ -5642,6 +5644,7 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
>
>         if (instance->msix_vectors)
>                 for (i = 0; i < instance->msix_vectors; i++) {
> +                       irq_set_affinity_hint(pci_irq_vector(instance->pdev, i), NULL);
>                         free_irq(pci_irq_vector(instance->pdev, i),
>                                  &instance->irq_context[i]);
>                 }
> --
> 2.21.3
>
