Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F629EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 13:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjGLNMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjGLNMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 09:12:22 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F0E1982
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 06:12:21 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4fbb281eec6so10934581e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 06:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1689167539; x=1691759539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ke1RoJkWHrGMbLYzmAUCdXFetzVb9Iew9ttJlTbSIZw=;
        b=Os6xvLS8Gk/Mp/m8MHivo/UCzBAVjtPOvDtXql9zLZoLY1ym8+E7fhdqYVmM5y/8C3
         DTiYnp5WLQgLSnRWO+k60DVBIFPmMjB2bp/Mh+UgkZ03bWwQlDTikNGrQr1e4oenY9Vs
         +K2SGHrZm16dW3VXLxvtJog4yJ0WhPlwYxnzpsK1kN+RxfiqFmPLvRHEJet1LyRu3GXl
         10yBI/rK8n9Qbm+mTunQS62K2IhtSVovM1gwq5Flm9wOf2hJjqp9WAdoRMzecflfkFKW
         RjXVQeoVS7Q4BUT0XuysnIzAY7P1hpJ1RGlv+62T3LhY1/3AziEWFx1I/S7ZfYEd5bSe
         g+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689167539; x=1691759539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ke1RoJkWHrGMbLYzmAUCdXFetzVb9Iew9ttJlTbSIZw=;
        b=FEeG3AQgS7Y0TwCRA0Lrq6edoXHEASHXNOJdkkaNqEK/HIu7CHCRXMcob7UCDEd276
         q8OITFh3+2cFahxpOD6oshzKuRtXnfY4HU9JmMrLLIDT2mXrNg1fHRv4AiOlKPIzDK1L
         GzJ0plJOnPTmVyjt5de3sd3EGUYuV0ewkQ/HovSEk2gSKjW8Qx2tko7NfABuUanmGqwF
         M9ZD6wtLXJ8D9oQ5EGKViCzpPNsOnO/KtPBqOeUP/Fgi0GsciXpdrt0g1iJiyVK+/Jzr
         wooNNhB34OqH7uHGrUu6F7T/0/8iZTnAw2fvWHZSWQAWaVO7t8LPc5I2r+jo42SQ+eCg
         I8zg==
X-Gm-Message-State: ABy/qLY8BQwe7OXrJfet4Xufbg4y6CF74zW7EqEbVqsZTXmENsYO8OlZ
        z4wp4GA4EvCWllsfZhi8jqS9mwGc9wCtMGUhl4xldg==
X-Google-Smtp-Source: APBJJlH/yrSGeZhx17n+01HoYW2tT4q99wyogdL6NM70ZV25ta/wXIG0VoK3rkFu1pl8TskJhm79jGLE2XEGDY8IUhs=
X-Received: by 2002:a05:6512:32ce:b0:4fb:9f93:365e with SMTP id
 f14-20020a05651232ce00b004fb9f93365emr18369739lfg.41.1689167539433; Wed, 12
 Jul 2023 06:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230712125455.1986455-1-ming.lei@redhat.com> <20230712125455.1986455-9-ming.lei@redhat.com>
In-Reply-To: <20230712125455.1986455-9-ming.lei@redhat.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 12 Jul 2023 15:12:08 +0200
Message-ID: <CAMGffEkY9SGCXrdOYYLU8BYacvw+sOdZFr770=idZZ1hVLtygQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] scsi: pm8001: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 2:55=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Take blk-mq's knowledge into account for calculating io queues.
>
> Fix wrong queue mapping in case of kdump kernel.
>
> On arm and ppc64, 'maxcpus=3D1' is passed to kdump kernel command line,
> see `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
> still returns all CPUs because 'maxcpus=3D1' just bring up one single
> cpu core during booting.
>
> blk-mq sees single queue in kdump kernel, and in driver's viewpoint
> there are still multiple queues, this inconsistency causes driver to appl=
y
> wrong queue mapping for handling IO, and IO timeout is triggered.
>
> Meantime, single queue makes much less resource utilization, and reduce
> risk of kernel failure.
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 2e886c1d867d..e2416f556560 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -965,6 +965,8 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *=
pm8001_ha)
>                 rc =3D pci_alloc_irq_vectors(pm8001_ha->pdev, 1, 1,
>                                            PCI_IRQ_MSIX);
>         } else {
> +               unsigned int max_vecs =3D min_t(unsigned int, PM8001_MAX_=
MSIX_VEC,
> +                               blk_mq_max_nr_hw_queues() + 1);
>                 /*
>                  * Queue index #0 is used always for housekeeping, so don=
't
>                  * include in the affinity spreading.
> @@ -973,7 +975,7 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *=
pm8001_ha)
>                         .pre_vectors =3D 1,
>                 };
>                 rc =3D pci_alloc_irq_vectors_affinity(
> -                               pm8001_ha->pdev, 2, PM8001_MAX_MSIX_VEC,
> +                               pm8001_ha->pdev, 2, max_vecs,
>                                 PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc);
>         }
>
> --
> 2.40.1
>
