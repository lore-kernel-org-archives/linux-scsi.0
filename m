Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1E5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiBQT0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:26:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245151AbiBQT0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:26:00 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6910F94D9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:25:45 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u18so11465001edt.6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HX3O+V0DE5VNmmAwGaxz3kYZLf2XUYdz0ZnXb81K4/o=;
        b=dc9tydN1ctwHhasj2tMzyWX7Z/MGlLguS/lk2kdij0VE8UiZnnkPxd4PL9h+n7t1ba
         B2t7bjkkQ2AlXLSN0WfbAHZZkCwGq5xIVOZfnT9NY5Pni7Wz0BhZkMasFacVJ2+5o4DC
         9qWj4hRm6xTO7aHl+ehMWtMGb05/qXu9hSMTKMu6HmT0iJvO0PF3TiOgae9148PTJqG7
         UXD98kVHSK/iWmbGVKKZs1LZibRVu9lhrEtwfCaK6oDfEPBw86SqzF+Om9UTCdAFnWHt
         qxl2uQ8c+A8RAYg0zwm8iG3DsQ+Fbgqmj+z69uoOuhSM6ADmcrXnoM3v9C1BndjWLkP+
         ehTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HX3O+V0DE5VNmmAwGaxz3kYZLf2XUYdz0ZnXb81K4/o=;
        b=CGDoyYwvYWlHN2RvcQpRjUMpOr90lBlLbnyn0fXzVFuoMxBMZWgZ+MfTQk74N2tZYv
         9cESLXhMJS1+Up0vhlhQej0o8hjqdWp1wZfZhBssSXfY3HoeClkN+npMrkAhuP9+H6VR
         PdG63cGghL1Mi+DgO9Hz9PgPDU9RFfGbjFjv02hTeSy3hD+fMImRzKV0Tvdp5H79v+qf
         JuUYsEv0sME1JOCtH1tjzixHtRyl0fAqpKPzCzQjhqykDhEutazFm3/vzO14QOMu3gIy
         VnCxXJWXMrYK1T426Qeq4zsBevCTJnwaC45dXycC75Gw/Z9TCD6lbymsgMYpT7Wa3JeS
         Dx2A==
X-Gm-Message-State: AOAM5330dmmdZhG/dPyLHM4TUTLXFxVLJsfv0hoNaCTu88XyMmvBWrEq
        /FYdmLJU72FDC5mLm3i/aKL1HRIIzpOyqDKrKbPdlg==
X-Google-Smtp-Source: ABdhPJx+BZbNu1iSG0rlRnfWrcOgz4LRKHY6BUGsCmoaxgiPpFP8XUmrgiNpayVwAVeGJ7oFXyAYgE6zP9WTDc7Xhdo=
X-Received: by 2002:a05:6402:2707:b0:410:d100:6937 with SMTP id
 y7-20020a056402270700b00410d1006937mr4325818edd.428.1645125944123; Thu, 17
 Feb 2022 11:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-15-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-15-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:25:33 +0100
Message-ID: <CAMGffEkb7vz_gXFi9pEbMOfomf9wQytGx-kAaLu+NjGqn2oHNw@mail.gmail.com>
Subject: Re: [PATCH v4 14/31] scsi: pm8001: Fix NCQ NON DATA command task initialization
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
> In the pm8001_chip_sata_req() and pm80xx_chip_sata_req() functions, all
> tasks with a DMA direction of DMA_NONE (no data transfer) are
> initialized using the ATAP value 0x04. However, NCQ NON DATA commands,
> while being DMA_NONE commands are NCQ commands and need to be
> initialized using the value 0x07 for ATAP, similarly to other NCQ
> commands.
>
> Make sure that NCQ NON DATA command tasks are initialized similarly to
> other NCQ commands by also testing the task "use_ncq" field in addition
> to the DMA direction. While at it, reorganize the code into a chain of
> if - else if - else to avoid useless affectations and debug messages.
>
> Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!


> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
>  drivers/scsi/pm8001/pm80xx_hwi.c | 13 ++++++-------
>  2 files changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index e20a1d4db026..c0215a35a7b5 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4265,22 +4265,22 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         u32  opc = OPC_INB_SATA_HOST_OPSTART;
>         memset(&sata_cmd, 0, sizeof(sata_cmd));
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
> -       if (task->data_dir == DMA_NONE) {
> +
> +       if (task->data_dir == DMA_NONE && !task->ata_task.use_ncq) {
>                 ATAP = 0x04;  /* no data*/
>                 pm8001_dbg(pm8001_ha, IO, "no data\n");
>         } else if (likely(!task->ata_task.device_control_reg_update)) {
> -               if (task->ata_task.dma_xfer) {
> +               if (task->ata_task.use_ncq &&
> +                   dev->sata_dev.class != ATA_DEV_ATAPI) {
> +                       ATAP = 0x07; /* FPDMA */
> +                       pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
> +               } else if (task->ata_task.dma_xfer) {
>                         ATAP = 0x06; /* DMA */
>                         pm8001_dbg(pm8001_ha, IO, "DMA\n");
>                 } else {
>                         ATAP = 0x05; /* PIO*/
>                         pm8001_dbg(pm8001_ha, IO, "PIO\n");
>                 }
> -               if (task->ata_task.use_ncq &&
> -                       dev->sata_dev.class != ATA_DEV_ATAPI) {
> -                       ATAP = 0x07; /* FPDMA */
> -                       pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
> -               }
>         }
>         if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
>                 task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 60c305f987b5..3deb89b11d2f 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4546,22 +4546,21 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         q_index = (u32) (cpu_id) % (pm8001_ha->max_q_num);
>         circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>
> -       if (task->data_dir == DMA_NONE) {
> +       if (task->data_dir == DMA_NONE && !task->ata_task.use_ncq) {
>                 ATAP = 0x04; /* no data*/
>                 pm8001_dbg(pm8001_ha, IO, "no data\n");
>         } else if (likely(!task->ata_task.device_control_reg_update)) {
> -               if (task->ata_task.dma_xfer) {
> +               if (task->ata_task.use_ncq &&
> +                   dev->sata_dev.class != ATA_DEV_ATAPI) {
> +                       ATAP = 0x07; /* FPDMA */
> +                       pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
> +               } else if (task->ata_task.dma_xfer) {
>                         ATAP = 0x06; /* DMA */
>                         pm8001_dbg(pm8001_ha, IO, "DMA\n");
>                 } else {
>                         ATAP = 0x05; /* PIO*/
>                         pm8001_dbg(pm8001_ha, IO, "PIO\n");
>                 }
> -               if (task->ata_task.use_ncq &&
> -                   dev->sata_dev.class != ATA_DEV_ATAPI) {
> -                       ATAP = 0x07; /* FPDMA */
> -                       pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
> -               }
>         }
>         if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
>                 task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
> --
> 2.34.1
>
