Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4946C2D0C4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 09:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D42420663
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 09:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eYtAXHNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfLJJpN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 04:45:13 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42972 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfLJJpN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 04:45:13 -0500
Received: by mail-ot1-f68.google.com with SMTP id 66so14947458otd.9
        for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2019 01:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0hX1Q9n2M6XKrv28o3J4nDH2VccV/c+e5EpwuDXaV8=;
        b=eYtAXHNjbJi0coWRbSWx/MvEE1yATN8Gf5ucGHbk8+GIV8B+gUo0G6Rl1iXdXwCu9h
         AbjbQbUWzVO/Bg2sZ5hP7E2TUpAmKWVNxbhVJPF4B/wATGIilAc/aF+BL/Xc2O+uJbjy
         fuAzaQr/FOWKBKl3+R0ue65031yPbkBhG3ZeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0hX1Q9n2M6XKrv28o3J4nDH2VccV/c+e5EpwuDXaV8=;
        b=DeoqgQ1Deos7SfIxD6PDm5UnYNK/5Tqu/6MhRvh3Qs7Lpcwt2yJhKETgw+hdTQKjSC
         mHjJrOdSqkqMBodZN/Kvgmoidkk2t/5eIN/TWYkwXuWHT7/YadOF06uaiWC3qgVTw7TF
         FDwk0b1emMU/X5K9GhfFuo5twgiPoHtNTZvh3mx6J5H7fmWtKjBVr+8t/NKBqG8M2Hly
         BJRGIgO0ncoJJabsgon6ridG3v8IaiBZ65jaRcbJvtj1GEh1aDOLXWjIdKBS7EAmiULd
         qhq/Ix2rNQKjMfIr3TqX4kqhVu/pX4leLvwsJbZl8cqkIyMkF0Xza8o++JnYbcxYldIK
         LGrQ==
X-Gm-Message-State: APjAAAVB2S9z8R+Fy4RHjg2eQYt8/Oy81T/a8BqtnvO3Zyy1FMwfgAUD
        cQSCFqCgXVx2UHaTMw2QW+HmBpORKCbUhQmeWDROXQ==
X-Google-Smtp-Source: APXvYqzXmWF7kmHvwlQo+xBOGKIDgKUXO26i22KHYHNWJeQSopq7Stgp7SZXldjNy69rP8d22wWHs8UPpwcU7bWGHKg=
X-Received: by 2002:a9d:76c5:: with SMTP id p5mr10471945otl.61.1575971112100;
 Tue, 10 Dec 2019 01:45:12 -0800 (PST)
MIME-Version: 1.0
References: <20191203093652.gyntgvnkw2udatyc@kili.mountain>
In-Reply-To: <20191203093652.gyntgvnkw2udatyc@kili.mountain>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Tue, 10 Dec 2019 15:15:00 +0530
Message-ID: <CAK=zhgrQ_9R+kWhMWG7D0iqsoTb=Q6WQKhN3ydeCxt-uK-CL-g@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix double free in attach error handling
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 3, 2019 at 3:07 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The caller also calls _base_release_memory_pools() on error so it
> leads to a number of double frees:
>
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->chain_dma_pool' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->hpr_lookup' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->internal_lookup' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->pcie_sgl_dma_pool' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_dma_pool' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_free_dma_pool' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_array_dma_pool' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_dma_pool' double freed
> drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->sense_dma_pool' double freed
>
> Fixes: 74522a92bbf0 ("scsi: mpt3sas: Optimize I/O memory consumption in driver.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 848fbec7bda6..45fd8dfb7c40 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5248,7 +5248,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
>                                         &ct->chain_buffer_dma);
>                         if (!ct->chain_buffer) {
>                                 ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
> -                               _base_release_memory_pools(ioc);
>                                 goto out;
>                         }
>                 }
> --
> 2.11.0
>
