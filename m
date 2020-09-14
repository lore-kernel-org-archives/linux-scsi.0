Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2935DC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 13:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED31206DC
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 13:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AAbjrKgy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgINNdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 09:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgINNaN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 09:30:13 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEB7C06178C
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2020 06:30:12 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x19so17862192oix.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2020 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0kKcJ2z3ux6tW6m9n+LCHXlUg2M6PuuRVsUT1ht3TrU=;
        b=AAbjrKgyT/yb1+2mkNQeXWXcsk3L0KPJKqiQvj0Txms5uTjtTud3Vyxiaq/iziLfQc
         iA939MRt3tLsIBtwfAFdDA2IH/s4uMBg1B1DOcLH6CA46SGKC9J9ZSi9VUGJIs2vj7Ob
         Wopds+oEgY8vJBPJnRR+pVBl7NT9UkdvtNsyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0kKcJ2z3ux6tW6m9n+LCHXlUg2M6PuuRVsUT1ht3TrU=;
        b=CLgBN5+0Wiga7c0rh9tf4K22QnlS4US75N2L/EJwOPgwGzzUUgYDoymz9jZwf2qT7U
         Y5Htc8JwXn+dYWoZWepUqifaezf0vWGlLW976nMeveCSIjxYi3DuqGNhOuKNRK3jh5rJ
         Vcj+pnx3pBoCZ7aPn2Qy+EPPe2nmsFWE65042MF3qFWBStNUolZ2X92MWmbwtg3L5kd1
         jyCZJNe6yZoomp2PoFCbSILwgImoKHeGhzgkH2kDnL38Lcc7RfLlZctJu/fP498GuxM1
         BUxQanEcp5CSv81m2vT8aVdwF+NhDQwesQuxitmuAyIlcxXaTxsi6aGNXQTtVFLMxKeM
         3ZDA==
X-Gm-Message-State: AOAM533oBFIipnXWmrXgNsRLpLG+Hn4HTmGlwV4KR9pIgnAH31WU0tPW
        Ii9GnVHDcFT6TFbJLmFsiMcVN+ntOj3fHcm8IX1vjsb21YVx8g==
X-Google-Smtp-Source: ABdhPJwUohI77Yf7Z+Gf8DtYPSeewHmtoXY+777S0ev3FY3Mwe4bc5hVszZSPL+ajYTo8RCaLkvJlkQ/pkaoSSRcqWE=
X-Received: by 2002:aca:1711:: with SMTP id j17mr9005132oii.152.1600090211806;
 Mon, 14 Sep 2020 06:30:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200910142126.8147-1-thenzl@redhat.com>
In-Reply-To: <20200910142126.8147-1-thenzl@redhat.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 14 Sep 2020 19:00:00 +0530
Message-ID: <CAK=zhgqc1GOOrp8Nm6HWzj6Dr0z4k1kWocku2daPU6u0oShuzw@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: fix sync irqs
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 10, 2020 at 7:51 PM Tomas Henzl <thenzl@redhat.com> wrote:
>
> - _base_process_reply_queue called from _base_interrupt
> may schedule a new irq poll, fix this by calling
> synchronize_irq first
> - a fix for "Unbalanced enable for IRQ..."
> enable_irq should be called only when necessary
>
> Fixes: 320e77acb327 ("scsi: mpt3sas: Irq poll to avoid CPU hard lockups")
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: sreekanth reddy <sreekanth.reddy@broadcom.com>

Thanks,
Sreekanth

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++++++++-----
>  drivers/scsi/scsi_scan.c            |  8 ++++++++
>  2 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index a85c9672c6ea..a67749c8f4ab 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1808,18 +1808,22 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
>                 /* TMs are on msix_index == 0 */
>                 if (reply_q->msix_index == 0)
>                         continue;
> +               synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
>                 if (reply_q->irq_poll_scheduled) {
>                         /* Calling irq_poll_disable will wait for any pending
>                          * callbacks to have completed.
>                          */
>                         irq_poll_disable(&reply_q->irqpoll);
>                         irq_poll_enable(&reply_q->irqpoll);
> -                       reply_q->irq_poll_scheduled = false;
> -                       reply_q->irq_line_enable = true;
> -                       enable_irq(reply_q->os_irq);
> -                       continue;
> +                       /* check how the scheduled poll has ended,
> +                        * clean up only if necessary
> +                        */
> +                       if (reply_q->irq_poll_scheduled) {
> +                               reply_q->irq_poll_scheduled = false;
> +                               reply_q->irq_line_enable = true;
> +                               enable_irq(reply_q->os_irq);
> +                       }
>                 }
> -               synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
>         }
>  }
>
> --
> 2.25.4
>
