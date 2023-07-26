Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CCFC0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 22:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjGZWMb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 18:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjGZWM3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 18:12:29 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F20271B;
        Wed, 26 Jul 2023 15:12:27 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-57a4c0324b5so570847b3.0;
        Wed, 26 Jul 2023 15:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690409547; x=1691014347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8mBYQ48hqxLsJ20eS/0jkkgIvd41omZCyTUT7Irfl8=;
        b=FGMXJIm+YcdnO2qdl9FARUysPWEgy4ZPjJMWoyY5JQFrLYy/xhbsOd/fGYe1HgkGql
         pwgC+CQD+7sPsRUocSzXMxgtDZMqOlRK8JOk8aFBW/RwtRTD8Ox/vfB53GHO6EOOygld
         YgpptCv1YGYr+QjGiznuxc0N10q8/czjpTLTJUUILRBrN0sKXYI6Wiy5lZQ/tyUenAXA
         THq4EpnBOvuM7e1m+P/ccaGwlZQEZCiO1eQQxB18EzMY4+iYdcLfIrmMFoxINsS1EkP8
         CQq9H0/aL9FBMZQK3S9ktE0nJv0/z26zCITlVUKYKkqHI0q+846gLlY+ehtBe9nreUrK
         tY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690409547; x=1691014347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u8mBYQ48hqxLsJ20eS/0jkkgIvd41omZCyTUT7Irfl8=;
        b=j+9x7CCM+wmfOu7U3UnNQ74IqfyZckYgh+QuuU1FUsLZeKjmpaLuU9nRcUM1LXBtt4
         2v8ssyGEMFPDsm6hbVOaRKAf3bf/yoRCus0Jq4zsUALuhsw72HpkgsIXAeJt5GsUoYQG
         KhYNNaET5oihuyu0Es84WRqyFNRXfzeUWND3cPhBxD5pclU6Iq1ba6y+2s0mtFjwD0b9
         0OZdUb91yZgMqOf8Ha2/n0p+604Wl0mSvwNwdj53cGIf90vPUADrGGqZE23UXS8pOaaQ
         3eNebu6wvgZYtQGVlk0WkaYQNQgLG9zfDP0l/Tnrj9xWqHlujJcbvEIzanjX4R40LRWC
         uJXQ==
X-Gm-Message-State: ABy/qLauOpN8o93wQO6EM5cXDfoRN3sca1r+kDCsVMi2cdXe1aftFV3X
        NSja3BN+e500rSocMv/Mau5FKc9WMXl/kSZ3pwg=
X-Google-Smtp-Source: APBJJlFve1PkP06DY6fpBvu+Zd5E0ezqHhw29sIUPOsCCsvNLLVEHnoLaKmgHoIiHbPqze9ucSiCbjkXkmHOEVV5l+c=
X-Received: by 2002:a81:6d51:0:b0:580:e3bf:698f with SMTP id
 i78-20020a816d51000000b00580e3bf698fmr1781329ywc.3.1690409546737; Wed, 26 Jul
 2023 15:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230726094027.535126-1-ming.lei@redhat.com> <20230726094027.535126-5-ming.lei@redhat.com>
In-Reply-To: <20230726094027.535126-5-ming.lei@redhat.com>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Wed, 26 Jul 2023 15:12:16 -0700
Message-ID: <CABPRKS-0GQqMRiGh6akOgk3BKpx5kqTd0QVhH4nPe=fUdi7DbQ@mail.gmail.com>
Subject: Re: [PATCH V2 4/9] scsi: lpfc: use blk_mq_max_nr_hw_queues() to
 calculate io vectors
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

From version 1 of the patchset, I thought we had planned to put the
min comparison right above pci_alloc_irq_vectors instead?

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3221a934066b..20410789e8b8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13025,6 +13025,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
                flags |=3D PCI_IRQ_AFFINITY;
        }

+       vectors =3D min_t(unsigned int, vectors, scsi_max_nr_hw_queues());
+
        rc =3D pci_alloc_irq_vectors(phba->pcidev, 1, vectors, flags);
        if (rc < 0) {
                lpfc_printf_log(phba, KERN_INFO, LOG_INIT,

Thanks,
Justin

On Wed, Jul 26, 2023 at 2:40=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
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
> Cc: Justin Tee <justintee8345@gmail.com>
> Cc: James Smart <james.smart@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 3221a934066b..c546e5275108 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -13022,6 +13022,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>                 cpu =3D cpumask_first(aff_mask);
>                 cpu_select =3D lpfc_next_online_cpu(aff_mask, cpu);
>         } else {
> +               vectors =3D min_t(unsigned int, vectors,
> +                               scsi_max_nr_hw_queues());
>                 flags |=3D PCI_IRQ_AFFINITY;
>         }
>
> --
> 2.40.1
>
