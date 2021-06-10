Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E56C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 09:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C70C961403
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 09:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFJJxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 05:53:44 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:39566 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhFJJxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 05:53:43 -0400
Received: by mail-ed1-f48.google.com with SMTP id dj8so32253430edb.6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 02:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Veun80R6ub7rY+0EXkCcitZyrInb6NzIFBdIkMt8D4=;
        b=i6f9Jc9L0lgcd93jphkY2sEimCfDdkCU7opySxuIhrkL7QpxYElocbEy9mi7D/cuLT
         kVxtmvkz+mFeemjZmaXLAqm9u8IWgxeLUaKPZMP6sozkpsotfaTz0JIfwAwFSsVvKyQJ
         Dk2j2ijtbf22OiVKmMvtJgmE9Ez2TIBOEK7wcLr55Y02z4+t++3U5XQsg1Jp8phFIM0A
         Epz9Kek4F0/SGNkhG+q7Ehs8nn+Fdhn3rpq7NjHBKpyIszmTe/y1mpWTXvsv3yDi+GIa
         /qyGzzS3jqQvqIhd6jNPp+oJjUSABsujxCin6gZpz5WztHo2MIf7owRCYr7oSEOgV86J
         Xd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Veun80R6ub7rY+0EXkCcitZyrInb6NzIFBdIkMt8D4=;
        b=efpJ//nIuOBPfWwhWFCY2tzEagaEI5Gd3unKgEu5AXU84+p6vc5+3YHzD0zDvtnoYQ
         1nDZbb9fxRVkDxtT0CxjCbX39Ht0y4h6Wlp/5hMx9dJnW0wfYSac8kgm7EAI/Knf3jRh
         CscKLReYpWk4Xeg+agTJgoGYB0y/OZu6Z4Aeqki0hqkkQwnLwKJ/4eY3qaWdZPNsD97/
         oIow9BZViRnn+vASWNb+Ns0mN/fYzqXFxophxcgYNgXpt1KzfmqE3Z4nTRCFxaeU425E
         4mAo/ceS4B4bpHCpEAmVJkRFXh7Jk+tdaRH6Ct0h96Nj2+GkTDdMpmb2pDQXHVDWzQJj
         kIHw==
X-Gm-Message-State: AOAM533T0wr9JV0yS8+2Epa98hJ8Eu+zCDFYk7+md6fvs9frmF1wyFWT
        wrrpnQyiuMh7UQrlRT5DDdzfziuJsjbQVRafCf+8GQ==
X-Google-Smtp-Source: ABdhPJwTrFk4TNGVHXdcQASyvFNPg9hfZtQn1ulO9bVWcWvq+Qb36P2Cs1lREER9bq4Ca5/IOt/f49SopbmmviqTp+w=
X-Received: by 2002:a05:6402:26ce:: with SMTP id x14mr3883263edd.104.1623318646286;
 Thu, 10 Jun 2021 02:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210610094605.16672-1-thunder.leizhen@huawei.com> <20210610094605.16672-2-thunder.leizhen@huawei.com>
In-Reply-To: <20210610094605.16672-2-thunder.leizhen@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 10 Jun 2021 11:50:35 +0200
Message-ID: <CAMGffE=BmTR4EXmGmbKTpRJ=M8tc3eW4qvH7qtQCP9Wi5NnKVA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: pm8001: remove unnecessary oom message
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 10, 2021 at 11:46 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> Fixes scripts/checkpatch.pl warning:
> WARNING: Possible unnecessary 'out of memory' message
>
> Remove it can help us save a bit of memory.
>
> By the way, change the return error code from "-1" to "-ENOMEM".
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thx.
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6860d5a9ef83b44..6f33d821e5453d1 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -118,10 +118,8 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
>                 align_offset = (dma_addr_t)align - 1;
>         mem_virt_alloc = dma_alloc_coherent(&pdev->dev, mem_size + align,
>                                             &mem_dma_handle, GFP_KERNEL);
> -       if (!mem_virt_alloc) {
> -               pr_err("pm80xx: memory allocation error\n");
> -               return -1;
> -       }
> +       if (!mem_virt_alloc)
> +               return -ENOMEM;
>         *pphys_addr = mem_dma_handle;
>         phys_align = (*pphys_addr + align_offset) & ~align_offset;
>         *virt_addr = (void *)mem_virt_alloc + phys_align - *pphys_addr;
> --
> 2.26.0.106.g9fadedd
>
>
