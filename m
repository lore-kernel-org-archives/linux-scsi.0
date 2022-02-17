Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744C9C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245498AbiBQTtx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:49:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245490AbiBQTtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:49:52 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B2B4130D
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:49:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id q17so11621714edd.4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pg4HNBbAvIgNwzSHv1dAu1eSYL1X80tDKX+gz5t/870=;
        b=CYacZ1ywud/rV1vp04Rh++3ZTEocEUms+RicLMVoLj8s48HQ68k8pt8D0j/5/l7QvK
         3qhwIY6Tzvds6ilywK8Pevq9u8c1Yj4lgM5zkSUbK72ymgidy46E878HTHlmfExpsl3E
         dtg7BMFgyJHvik6kAzjqY1iMIf/hPVYtPu7om9x3SgT1f8WHFLfVFhlyuo/TZ6OgRB2Y
         7XhJfUnWBnopCTQaPuDwEjGfvdsTOXgx3t6+XWWPj/vcT87AuNEjR6S6z+zr7ucZw44t
         DzRR4yeCvFcv7j/It2gC9rH8dGBjwm4ltpdE+RAVtqg5z1uAEz2A5DoeHiA8lxuCfn78
         8uAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pg4HNBbAvIgNwzSHv1dAu1eSYL1X80tDKX+gz5t/870=;
        b=Afg3hGM1fzc8qCEG/+ASnDg3WHL5/dXl75EXxactciXH4Xbc/pAmEH43IzINicryqc
         9yER0i0GgxZHGzSp+2sjSmp5Vx1FqaGQ8cxHknpMKZpAR6+WYuIXTP7df0KdwXQOVUdA
         bRH0z6Fjc2VG0NFpNNgPbifHJEpVnmnQoobgAJbtiNJ4xhPvxy7wCBUnXb5POeuL6Spr
         e+wHRIZ7zqHcQ+q/Jdsa8/fLvog/miByjdOqCMMV6Oayc9bVvfsSOTPTDid00pV9ZYwn
         BAnSIBP8lECGYNROlN89oIvyTPYjvL0a3ff3keqVGYsdU9Vn6RDfMTUQjQigQpd6eJNf
         wf6g==
X-Gm-Message-State: AOAM5332v/GnWUAPfeAvIAymqwfYIRrB7dw90MNzcSEn+jG5dj/nQ3o4
        yrczdwhDvfV158Xpb5AvVv0exieIQ++4ye+YzLPzCQ==
X-Google-Smtp-Source: ABdhPJwrjb4q9Yx+VK33HiaQiJyKlaeG9gHMwGBVQixArObrn02YjzSCSGRbMXFtOGmpSVs4cH2GZsvSh6+3ChL4qv8=
X-Received: by 2002:a05:6402:42ca:b0:408:ed7:b011 with SMTP id
 i10-20020a05640242ca00b004080ed7b011mr4310579edc.6.1645127371607; Thu, 17 Feb
 2022 11:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-31-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-31-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:49:21 +0100
Message-ID: <CAMGffEnGkhDgjY=KkYLZzGcLAM1xX2Tpy7hgM7LEsL7Gpk47zw@mail.gmail.com>
Subject: Re: [PATCH v4 30/31] scsi: pm8001: improve pm80XX_send_abort_all()
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
> Both pm8001_send_abort_all() and pm80xx_send_abort_all() are called only
> for a non null device with the NCQ_READ_LOG_FLAG set, so remove the
> device check on entry of these functions. Furthermore, setting the
> NCQ_ABORT_ALL_FLAG device id flag and clearing the NCQ_READ_LOG_FLAG is
> always done before calling these functions. Move these operations inside
> the functions.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>

> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++----------
>  drivers/scsi/pm8001/pm80xx_hwi.c | 16 ++++------------
>  2 files changed, 8 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index c2dbadb5d91e..edf83b8a6bd0 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1748,15 +1748,13 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>                 struct pm8001_device *pm8001_ha_dev)
>  {
>         struct pm8001_ccb_info *ccb;
> -       struct sas_task *task = NULL;
> +       struct sas_task *task;
>         struct task_abort_req task_abort;
>         u32 opc = OPC_INB_SATA_ABORT;
>         int ret;
>
> -       if (!pm8001_ha_dev) {
> -               pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
> -               return;
> -       }
> +       pm8001_ha_dev->id |= NCQ_ABORT_ALL_FLAG;
> +       pm8001_ha_dev->id &= ~NCQ_READ_LOG_FLAG;
>
>         task = sas_alloc_slow_task(GFP_ATOMIC);
>         if (!task) {
> @@ -2358,11 +2356,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         ts->stat = SAS_SAM_STAT_GOOD;
>                         /* check if response is for SEND READ LOG */
>                         if (pm8001_dev &&
> -                               (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
> -                               /* set new bit for abort_all */
> -                               pm8001_dev->id |= NCQ_ABORT_ALL_FLAG;
> -                               /* clear bit for read log */
> -                               pm8001_dev->id = pm8001_dev->id & 0x7FFFFFFF;
> +                           (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
>                                 pm8001_send_abort_all(pm8001_ha, pm8001_dev);
>                                 /* Free the tag */
>                                 pm8001_tag_free(pm8001_ha, tag);
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b5e1aaa0fd58..9bb31f66db85 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1761,23 +1761,19 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>                 struct pm8001_device *pm8001_ha_dev)
>  {
>         struct pm8001_ccb_info *ccb;
> -       struct sas_task *task = NULL;
> +       struct sas_task *task;
>         struct task_abort_req task_abort;
>         u32 opc = OPC_INB_SATA_ABORT;
>         int ret;
>
> -       if (!pm8001_ha_dev) {
> -               pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
> -               return;
> -       }
> +       pm8001_ha_dev->id |= NCQ_ABORT_ALL_FLAG;
> +       pm8001_ha_dev->id &= ~NCQ_READ_LOG_FLAG;
>
>         task = sas_alloc_slow_task(GFP_ATOMIC);
> -
>         if (!task) {
>                 pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
>                 return;
>         }
> -
>         task->task_done = pm8001_task_done;
>
>         ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
> @@ -2446,11 +2442,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                         ts->stat = SAS_SAM_STAT_GOOD;
>                         /* check if response is for SEND READ LOG */
>                         if (pm8001_dev &&
> -                               (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
> -                               /* set new bit for abort_all */
> -                               pm8001_dev->id |= NCQ_ABORT_ALL_FLAG;
> -                               /* clear bit for read log */
> -                               pm8001_dev->id = pm8001_dev->id & 0x7FFFFFFF;
> +                           (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
>                                 pm80xx_send_abort_all(pm8001_ha, pm8001_dev);
>                                 /* Free the tag */
>                                 pm8001_tag_free(pm8001_ha, tag);
> --
> 2.34.1
>
