Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA3DC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 00:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjGMADc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 20:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbjGMADb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 20:03:31 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B1C1FC8;
        Wed, 12 Jul 2023 17:03:31 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-cab616cc83fso4753276.1;
        Wed, 12 Jul 2023 17:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689206610; x=1689811410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkkA0LMXJ6EJO8ZBIrahw9NK6XtYuf0ofi+9E893seU=;
        b=B4bVQ0sWquLoM0r6xOPwFQ8N6TQnuKE3itkRYhssSKUTCfWniZDokY97TmM4vK4l0k
         7FpToXZGtZD1L8yZVObxO0vaQBOBT5lMcFLdA9tLsrIhr/yzzoYPIlxpOjpvW0hpo73G
         CvWObux//kErneUPfSjCCfOYNrqtV9eK4uFtAyYeKL5rRPITQJ3QWbk3V56qhVR5j93d
         RWU0RjMnah4yf3k1Kc6RIb2XKmEnpo8I5SNjSePmVcQIM3PFf2zwxlw0JxiByDBzPfrK
         7ThMZoB3hRRTSrAO2vdKu+J7B7KfZKVdJotveK6uiWhRavSGowH8kSV0xHHeZfaxCABM
         /L6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689206610; x=1689811410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkkA0LMXJ6EJO8ZBIrahw9NK6XtYuf0ofi+9E893seU=;
        b=erwFWJLFf1flSP96cVHIGd8t9Jv30k01GF2x/xChIHoQST0O1MND9WuREuiEPCCULX
         Gcl4dTYWTtD4eSB10DYnNmIc2D8G85lNC5br2FCw7KcuoLw/6R00B/zAqwtTHwsqnCEP
         adA8c47PQBvMm76ZgIbOa77wr8838M/xlMSCgqq8Bk4798iqgxV9P6orSrQCIIZ9JWhg
         MpZAguxroejnz/yevIHGTHPpmJwrXhYqVW8QlCjBO93fHVsTjFzZbbGKFihzcaeb4uC3
         hP0dy/v28wkWNcUZV+bOUuEd2zoVIBdSubxQCe/0SigL2K2k/EZcda37nipHwtf4NM4v
         asWw==
X-Gm-Message-State: ABy/qLaId3Zfi/N7cDcmszzonnNV8JfwvZhwM/IohTs3XDhfgwdWQppd
        ckbZxK3XhIPTQxDUquTYO3832JiXezdTrtOWlR4=
X-Google-Smtp-Source: APBJJlGADVIdji1KcjMzFLea4D7Ai1TaoUOxO12SLFR1+VzgNBMYdqYw4++7zvjr0JM+V/BO9kUqgi+1qjZbdHQ1cPI=
X-Received: by 2002:a81:4c05:0:b0:569:322b:d067 with SMTP id
 z5-20020a814c05000000b00569322bd067mr104522ywa.4.1689206610234; Wed, 12 Jul
 2023 17:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230712125455.1986455-1-ming.lei@redhat.com> <20230712125455.1986455-4-ming.lei@redhat.com>
In-Reply-To: <20230712125455.1986455-4-ming.lei@redhat.com>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Wed, 12 Jul 2023 17:03:19 -0700
Message-ID: <CABPRKS9WPBq1R9EH39=8vCAcW0+0YDAuYKRtEU9ck=BRfZKo1w@mail.gmail.com>
Subject: Re: [PATCH 3/8] scsi: lpfc: use blk_mq_max_nr_hw_queues() to
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

A few lines below in if (aff_mask), vectors can be overwritten again
with min(phba->cfg_irq_chann, cpu_cnt).

Perhaps we should move blk_mq_max_nr_hw_queues min comparison a little late=
r:

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3221a934066b..20410789e8b8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13025,6 +13025,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
                flags |=3D PCI_IRQ_AFFINITY;
        }

+       vectors =3D min_t(unsigned int, vectors, blk_mq_max_nr_hw_queues())=
;
+
        rc =3D pci_alloc_irq_vectors(phba->pcidev, 1, vectors, flags);
        if (rc < 0) {
                lpfc_printf_log(phba, KERN_INFO, LOG_INIT,


Regards,
Justin

On Wed, Jul 12, 2023 at 6:04=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
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
> Cc: James Smart <james.smart@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 3221a934066b..88314c3f1dc1 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -13012,6 +13012,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>         if (phba->irq_chann_mode !=3D NORMAL_MODE)
>                 aff_mask =3D &phba->sli4_hba.irq_aff_mask;
>
> +       vectors =3D min_t(unsigned int, vectors, blk_mq_max_nr_hw_queues(=
));
>         if (aff_mask) {
>                 cpu_cnt =3D cpumask_weight(aff_mask);
>                 vectors =3D min(phba->cfg_irq_chann, cpu_cnt);
> --
> 2.40.1
>
