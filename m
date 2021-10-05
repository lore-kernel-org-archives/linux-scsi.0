Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1E0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 17:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D6B61166
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 17:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhJERNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 13:13:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233961AbhJERNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 13:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633453918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wHl5J4zNfT/bWznJWZv8bIo1r3C0dEpluMHYuDTpiE4=;
        b=WDuA5PwSY0oMfKMQzc18yyyrk5wvaBTaBBDDZQYUOILIbn9UCHijz2pMuFxQvXLxoZQwAV
        50hvMVjjpDlnxdDuOxlwBk9fxhXFJaleMHanVnM1pdXAaGY9j9S1Vdv/FVlohefQJYWieq
        szwrswCnn3PMv2veZPiFm7i9kUxkXp8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-G75oEEC5MOCa8Zeh_TeQCw-1; Tue, 05 Oct 2021 13:11:57 -0400
X-MC-Unique: G75oEEC5MOCa8Zeh_TeQCw-1
Received: by mail-lf1-f70.google.com with SMTP id z29-20020a195e5d000000b003fd437f0e07so2017776lfi.20
        for <linux-scsi@vger.kernel.org>; Tue, 05 Oct 2021 10:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHl5J4zNfT/bWznJWZv8bIo1r3C0dEpluMHYuDTpiE4=;
        b=nCX5OWQZvJFdWYE1PrfSftMvN06DRu6FfZowt9v9zt65qi8og+U0RJyhVOtyGuqkr5
         0DW0WMfC0pjSK0nrqZxsDw+JJ6qHHoVCac/mn6RLUTREng286hOjhVs2UXOntFAnp0tg
         t0ZZbwesftD+czS1S8QPhUGwJy7UKKSJnZfWr/VwAmrl0y1VY+EKZb2mj82KaRVwTQ6R
         FyrQW9sR+mWqfJOQgBXq24Hx/cKdp/qpgyuA1N1dmIjKR6569i2s5E6bGd3Aq1953Crj
         ECPQFDCFPEaPsy7HJCaSA9ufkDWxKasGGiTc2tOv15951n6/6Nob9E9omTRg98odhYVG
         G4MA==
X-Gm-Message-State: AOAM532AKucB+oxsW51z1Kf3jRiQwHBWM8yiL+vgyp/MH0JW3wntQraR
        cQk99zUVsYdLDBJ9esyBcsgPJ7636Qonf0dNCqFrJjp9hy+SRPBWs5qVspIxQYLgQXGa7U+PIKg
        Jr4pkWFqVOXXgdvop/X5FGfAGKLOy8yIQP5vqYQ==
X-Received: by 2002:a2e:504a:: with SMTP id v10mr22975152ljd.9.1633453915549;
        Tue, 05 Oct 2021 10:11:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh6u1il893+vUTqCwySO/pxGosUhKIW8Y6ufFqjXA49ELl+JPzV3XQe2mhFgvrpV64fvAu3bEffOvg8e+VIfM=
X-Received: by 2002:a2e:504a:: with SMTP id v10mr22975133ljd.9.1633453915275;
 Tue, 05 Oct 2021 10:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211004231210.35524-1-jsmart2021@gmail.com>
In-Reply-To: <20211004231210.35524-1-jsmart2021@gmail.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Tue, 5 Oct 2021 13:11:44 -0400
Message-ID: <CAGtn9rmsV9QcMr2-dKR8GEN+Ln7MtaCy5ruY+5gzXoUy+gg3pw@mail.gmail.com>
Subject: Re: [PATCH] lpfc: Fix memory overwrite during FC-GS IO abort handling
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tested-by: Ewan D. Milne <emilne@redhat.com>

On Mon, Oct 4, 2021 at 7:12 PM James Smart <jsmart2021@gmail.com> wrote:
>
> When an FC-GS IO is aborted by lpfc, the driver requires a node pointer
> for a dereference operation.  In the abort IO routine, the driver
> miscasts a context pointer to the wrong data type and overwrites a
> single byte outside of the allocated space.  This miscast is done in the
> abort io function handler because the abort io handler works on FC-GS
> and FC-LS commands but the code neglected to get the correct job location
> for the node.
>
> Fix this by acquiring the necessary node pointer from the correct
> job structure depending on the IO type.
>
> Co-developed-by: Justin Tee <justin.tee@broadcom.com>
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 3f911cb48cf2..d8c01114442f 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -12308,12 +12308,12 @@ void
>  lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>                      struct lpfc_iocbq *rspiocb)
>  {
> -       struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
> +       struct lpfc_nodelist *ndlp = NULL;
>         IOCB_t *irsp = &rspiocb->iocb;
>
>         /* ELS cmd tag <ulpIoTag> completes */
>         lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> -                       "0139 Ignoring ELS cmd tag x%x completion Data: "
> +                       "0139 Ignoring ELS cmd code x%x completion Data: "
>                         "x%x x%x x%x\n",
>                         irsp->ulpIoTag, irsp->ulpStatus,
>                         irsp->un.ulpWord[4], irsp->ulpTimeout);
> @@ -12321,10 +12321,13 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>          * Deref the ndlp after free_iocb. sli_release_iocb will access the ndlp
>          * if exchange is busy.
>          */
> -       if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
> +       if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) {
> +               ndlp = cmdiocb->context_un.ndlp;
>                 lpfc_ct_free_iocb(phba, cmdiocb);
> -       else
> +       } else {
> +               ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
>                 lpfc_els_free_iocb(phba, cmdiocb);
> +       }
>
>         lpfc_nlp_put(ndlp);
>  }
> --
> 2.26.2
>

