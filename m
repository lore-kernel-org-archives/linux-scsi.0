Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC74C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F39613FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFJJBj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 05:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhFJJBj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 05:01:39 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA29C061574
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 01:59:43 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ce15so42908393ejb.4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 01:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OhnHGxgfH2XpppAr9TwQVZR1IEQdQ/jAtKT3rr8PF58=;
        b=bIQhJ6QU+GOM1XktVQGr1kRgQ4Diy13lpif3P59pcqMO6fQh0DjoJdnQOZodDR3ZPt
         wGESi0RbEHcCn1rTM8NqWCMPpUrAUlORiHWtshtViGftRGWIy6dhDoL3uLVbi8WB1Y+q
         347iEmiAZnSpl56CU9jtNMFhixP606HysVGqQPRqiJ+aW1HVvPth6rzfVV5AcpDow2xi
         LnqwBa/Y5hmWHBPXRwX/XulJ3dt2aoV4naJD1aQSW4AKiTTJLq0Y6PvGwF5zu5rsyPUl
         OO6/F2E07/cc7ZvjLhDqaq3/PFcZYeUF7hP3xQ8vdyUbm+tZeZLQIYrK8njVILK8sVDl
         i+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OhnHGxgfH2XpppAr9TwQVZR1IEQdQ/jAtKT3rr8PF58=;
        b=Asn6tAk+d3MCbc/qJad4lVqwmeqxZEeZpMI86Ux71BUVKJnB6NgFR7Nl14nmvgm+mQ
         d0wOkwxO8O1qppknWEXfRXs0TjZ7cfMtlP0BnUPBr9NFTL8LHtnQGIMwGHfZ49FTZzBR
         TxztzYXTI313TjzS8VZLbbwsNxYaZt8TT3Lsst/RqiTMQFRX0jpCVuRt92R2+bLNQbYC
         6ACpYMMWyLTws/mb6gbDURjuX4NC/iWQcUF9NvwyzNYQ8syE6bmJq9iFOED7plEUwAt2
         og8OsAKZNwe0+2KOTb7SKzMDQvkamG0Ao83zK/y1cHT1DojxyWI2CJ0QeLmbJ/iBw2jS
         jCdA==
X-Gm-Message-State: AOAM5316le2B7wdQbyWiq5KisMbTlSU6Ke5VFXZNCl1/ZXqmaCbsS4LO
        e6mOWdc1A6POlsZRcmpDV19vqgIW+x09G2HldlQZ0w==
X-Google-Smtp-Source: ABdhPJwNjg9C1mQpCdMTIQh1lZDWd0jXpuzi8tZN6DipVZQLh4ErubZXC9knUsL8rx5M4cdna+yEr9HHYuFJxAyww9M=
X-Received: by 2002:a17:906:9bce:: with SMTP id de14mr3530995ejc.353.1623315581684;
 Thu, 10 Jun 2021 01:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210610082010.16507-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210610082010.16507-1-thunder.leizhen@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 10 Jun 2021 10:59:31 +0200
Message-ID: <CAMGffEkacjUFs8+Z7Jnuuvm3+o_R8JOhrokUu61VmVKopPr9dw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: pm8001: remove unnecessary oom message
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 10, 2021 at 10:20 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> Fixes scripts/checkpatch.pl warning:
> WARNING: Possible unnecessary 'out of memory' message
>
> Remove it can help us save a bit of memory.
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6860d5a9ef83b44..fff01a6effc4dab 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -118,10 +118,8 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
>                 align_offset = (dma_addr_t)align - 1;
>         mem_virt_alloc = dma_alloc_coherent(&pdev->dev, mem_size + align,
>                                             &mem_dma_handle, GFP_KERNEL);
> -       if (!mem_virt_alloc) {
> -               pr_err("pm80xx: memory allocation error\n");
> +       if (!mem_virt_alloc)
>                 return -1;
> -       }
while you are at it, can you also fix the return code to -ENOMEM


Thanks.
