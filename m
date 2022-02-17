Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E4EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiBQTaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:30:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244447AbiBQTan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:30:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BB4149B9B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:30:28 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id q17so11540931edd.4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F31HCFvxjXp/zXna7pT2FFmJaYGnEdA0j/j5IxOfv4w=;
        b=b2miigayC2t3mWOc5iFDBCDgusST0RmmEIXv3ADODJGUPEzWEWJuk06v33/EzeHlan
         g51eR5zdskdNoMjEcxNRp1cnyibe+4wPocvDsFkiLPJTltn5++OxAsdxgzwAkG+CE6lx
         jtz82emM76vCrsCcxJNhg2hqOtYCMDOsSAd/ea7aUhI+cW3zAzzq+pO8jpvkD/EarwBU
         LndWDuSp6IqsGKGUOV+62DB1cMXp30WZK2Xox0wl10H9tqCjOzL0njJGae9wqk6DanhL
         SRZW7iot8kArmIyfxHe/kk/SWipM304EQbYar1qXahsTIBOLp7FgNZBnNs6s/hbX9zWO
         O0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F31HCFvxjXp/zXna7pT2FFmJaYGnEdA0j/j5IxOfv4w=;
        b=ivLr0xwqknxSk8jJQR4n9NgJE0qmEQgrOm2OlwP6li8uqHlm5wBolAMM9cstsaLKYT
         yxShuP1rhmlEKqcLLE6tttWgB7CiraiYDP+t5HPqdFUFdkKzmjURc43Kz92GtwHUyusc
         LHly5cdmDbm9NEJ6AoMbK3o692/zGyE6l0OA/5/A/1nVz+qUJJY+ivzpGG3qq+gHE6OD
         /zGRVegam/rEsj9SvAf9gK1abqyat9VG1kLH2PSDsgkAvuJlUKQKqxkxcebL+e4vFsiK
         z5za+xkIBv0E/GhPb6xm4he1YjSysdsrs7K4x0TOuXdq3clG12C5xJ2HBKVcrH660NuS
         VHeg==
X-Gm-Message-State: AOAM530iIA0l2b5eCM4RWmx8JAplbfE5lEdpQMXIACmmVXrI6RTHHUTr
        GmLWui9+nNAIvum2a45S4fEHxSUei5z+6KaqDQoQyg==
X-Google-Smtp-Source: ABdhPJxqnaRoIFeoQX4GXZpp9r8T449Q4Zp73Bf8jNp/xkXSPtm/LSN0Lqxy2Yi2QDQeFKSJtJuGOnZvvmGk0Ha833o=
X-Received: by 2002:a50:9d89:0:b0:410:ff04:5a98 with SMTP id
 w9-20020a509d89000000b00410ff045a98mr4421792ede.404.1645126227364; Thu, 17
 Feb 2022 11:30:27 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-17-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-17-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:30:16 +0100
Message-ID: <CAMGffEnc=p16dihYUQ6wejqYQdvn7rkDhS5DdqWAZvJirarfYw@mail.gmail.com>
Subject: Re: [PATCH v4 16/31] scsi: pm8001: Fix abort all task initialization
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> In pm80xx_send_abort_all(), the n_elem field of the ccb used is not
> initialized to 0. This missing initialization sometimes lead to the
> task completion path seeing the ccb with a non-zero n_elem resulting in
> the execution of invalid dma_unmap_sg() calls in pm8001_ccb_task_free(),
> causing a crash such as:
>
> [  197.676341] RIP: 0010:iommu_dma_unmap_sg+0x6d/0x280
> [  197.700204] RSP: 0018:ffff889bbcf89c88 EFLAGS: 00010012
> [  197.705485] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83d0bda0
> [  197.712687] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88810dffc0d0
> [  197.719887] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881c790098b
> [  197.727089] R10: ffffed1038f20131 R11: 0000000000000001 R12: 0000000000000000
> [  197.734296] R13: ffff88810dffc0d0 R14: 0000000000000010 R15: 0000000000000000
> [  197.741493] FS:  0000000000000000(0000) GS:ffff889bbcf80000(0000) knlGS:0000000000000000
> [  197.749659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  197.755459] CR2: 00007f16c1b42734 CR3: 0000000004814000 CR4: 0000000000350ee0
> [  197.762656] Call Trace:
> [  197.765127]  <IRQ>
> [  197.767162]  pm8001_ccb_task_free+0x5f1/0x820 [pm80xx]
> [  197.772364]  ? do_raw_spin_unlock+0x54/0x220
> [  197.776680]  pm8001_mpi_task_abort_resp+0x2ce/0x4f0 [pm80xx]
> [  197.782406]  process_oq+0xe85/0x7890 [pm80xx]
> [  197.786817]  ? lock_acquire+0x194/0x490
> [  197.790697]  ? handle_irq_event+0x10e/0x1b0
> [  197.794920]  ? mpi_sata_completion+0x2d70/0x2d70 [pm80xx]
> [  197.800378]  ? __wake_up_bit+0x100/0x100
> [  197.804340]  ? lock_is_held_type+0x98/0x110
> [  197.808565]  pm80xx_chip_isr+0x94/0x130 [pm80xx]
> [  197.813243]  tasklet_action_common.constprop.0+0x24b/0x2f0
> [  197.818785]  __do_softirq+0x1b5/0x82d
> [  197.822485]  ? do_raw_spin_unlock+0x54/0x220
> [  197.826799]  __irq_exit_rcu+0x17e/0x1e0
> [  197.830678]  irq_exit_rcu+0xa/0x20
> [  197.834114]  common_interrupt+0x78/0x90
> [  197.840051]  </IRQ>
> [  197.844236]  <TASK>
> [  197.848397]  asm_common_interrupt+0x1e/0x40
>
> Avoid this issue by always initializing the ccb n_elem field to 0 in
> pm8001_send_abort_all(), pm8001_send_read_log() and
> pm80xx_send_abort_all().
>
> Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 8149cc0d1ecd..35d62e5c9200 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1787,6 +1787,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>         ccb->device = pm8001_ha_dev;
>         ccb->ccb_tag = ccb_tag;
>         ccb->task = task;
> +       ccb->n_elem = 0;
>
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>
> @@ -1848,6 +1849,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>         ccb->device = pm8001_ha_dev;
>         ccb->ccb_tag = ccb_tag;
>         ccb->task = task;
> +       ccb->n_elem = 0;
>         pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
>         pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ac2178a13e4c..8fd38e54f07c 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1800,6 +1800,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>         ccb->device = pm8001_ha_dev;
>         ccb->ccb_tag = ccb_tag;
>         ccb->task = task;
> +       ccb->n_elem = 0;
>
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>
> --
> 2.34.1
>
