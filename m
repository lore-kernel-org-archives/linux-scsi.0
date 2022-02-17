Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5D3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbiBQTMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:12:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243867AbiBQTMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:12:14 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020EB13F6A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:11:59 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id hw13so9497559ejc.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i8NcNrvMjKo2DftSnT9G7pCA9ycNbDZvqRLPhj0TRw0=;
        b=C+BWDWShxJ1St971CmODKFdscEMX60whIPBhn1P7sx19DlJG+9jFk3bVUENuOjfF60
         2b06wxcqz4gf+VtVF2/RhM+0f5JWwZGM6XyCV4p0zYIgTeUkH1hkvI96ACObXMY6eVHG
         U5KV6a+gkosu+9925gZjadwDVlL4qCDSSLWQhVOAhkB+GV+3R0zZQdX6aXsuH62Gv6Jm
         8pGJrCHHhx2W+vfYmXoX/HRfFGQ5Xf9Xl/iriZ40lPYomFCHWmbD1RgBo6xJCfVCi0D9
         APG4MC88gsNapU4MRpzT1bBkn/Hs4Xt/T6fTkGt6AtJruJM0AoRoZt7jhnnfq0Pwmrbc
         hYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i8NcNrvMjKo2DftSnT9G7pCA9ycNbDZvqRLPhj0TRw0=;
        b=ledGQEK7nI5XcyYeirXwWa+V9k0FflWp2971AE6gSo8+BWq/pWP6BU9atnEa5z07RG
         d/EG092KjAESi2rSt4CO7CQ8nMapwZ5Vp+TLluFEQ7g7tqds7yoduB3wzZaiBNooLhNU
         Xu9NDRNNg24lvqmtYHU2Kd323k9qPmSOFmBfnplCtkRuFHw5XM6lVjZYKSbC4DtaesFi
         a4YZYqWnmqZkqwFy2K8j+cm4cWymlWgDeNqmbXZeMFv9fttLNSUqZIpHME50e/nHcobH
         rTf5X4oU0kvRB6DbGuWOxd/GMsLSObzNHfDGWWIf6eRqmie0/12prKxtQnoi4Kg7Bnmm
         PGcQ==
X-Gm-Message-State: AOAM531FXqogXFHRZkx1GTPPFO3BfS7NIuOprTjLPBAB9NA7Ozm6LxpW
        ym7xqueper9lItdr85RGXwqDySh/jctrIoh0PILQVQ==
X-Google-Smtp-Source: ABdhPJw091U7d/lmFPZeU/q9tnFPVfmqN87azlLbjk9RnOStkWiMslxq7v/C2kPkJd+cDqOLuLtAAJnGpbCRpPaxwsM=
X-Received: by 2002:a17:906:b201:b0:6b5:58c8:e43c with SMTP id
 p1-20020a170906b20100b006b558c8e43cmr3374845ejz.441.1645125117457; Thu, 17
 Feb 2022 11:11:57 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-11-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-11-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:11:46 +0100
Message-ID: <CAMGffEmW-rR-=dwpWRNUS2oAMdVRaztDC3fSrPz2QXiyfMAF-g@mail.gmail.com>
Subject: Re: [PATCH v4 10/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
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
> Make sure that the __le32 fields of struct ssp_ini_io_start_req are
> manipulated after applying the correct endian conversion. That is, use
> cpu_to_le32() for assigning values and le32_to_cpu() for consulting a
> field value. In particular, make sure that the calculations for the 4G
> boundary check are done using CPU endianness and *not* little endian
> values. With these fixes, many sparse warnings are removed.
>
> While at it, add blank lines after variable declarations and in some
> other places to make this code more readable.
>
> Fixes: 0ecdf00ba6e5 ("[SCSI] pm80xx: 4G boundary fix.")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 41 +++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b06d5ded45ca..130747b5a70a 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4374,13 +4374,15 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>         struct ssp_ini_io_start_req ssp_cmd;
>         u32 tag = ccb->ccb_tag;
>         int ret;
> -       u64 phys_addr, start_addr, end_addr;
> +       u64 phys_addr, end_addr;
>         u32 end_addr_high, end_addr_low;
>         struct inbound_queue_table *circularQ;
>         u32 q_index, cpu_id;
>         u32 opc = OPC_INB_SSPINIIOSTART;
> +
>         memset(&ssp_cmd, 0, sizeof(ssp_cmd));
>         memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
> +
>         /* data address domain added for spcv; set to 0 by host,
>          * used internally by controller
>          * 0 for SAS 1.1 and SAS 2.0 compatible TLR
> @@ -4391,7 +4393,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>         ssp_cmd.device_id = cpu_to_le32(pm8001_dev->device_id);
>         ssp_cmd.tag = cpu_to_le32(tag);
>         if (task->ssp_task.enable_first_burst)
> -               ssp_cmd.ssp_iu.efb_prio_attr |= 0x80;
> +               ssp_cmd.ssp_iu.efb_prio_attr = 0x80;
>         ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_prio << 3);
>         ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
>         memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
> @@ -4423,21 +4425,24 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                         ssp_cmd.enc_esgl = cpu_to_le32(1<<31);
>                 } else if (task->num_scatter == 1) {
>                         u64 dma_addr = sg_dma_address(task->scatter);
> +
>                         ssp_cmd.enc_addr_low =
>                                 cpu_to_le32(lower_32_bits(dma_addr));
>                         ssp_cmd.enc_addr_high =
>                                 cpu_to_le32(upper_32_bits(dma_addr));
>                         ssp_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
>                         ssp_cmd.enc_esgl = 0;
> +
>                         /* Check 4G Boundary */
> -                       start_addr = cpu_to_le64(dma_addr);
> -                       end_addr = (start_addr + ssp_cmd.enc_len) - 1;
> -                       end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> -                       end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> -                       if (end_addr_high != ssp_cmd.enc_addr_high) {
> +                       end_addr = dma_addr + le32_to_cpu(ssp_cmd.enc_len) - 1;
> +                       end_addr_low = lower_32_bits(end_addr);
> +                       end_addr_high = upper_32_bits(end_addr);
> +
> +                       if (end_addr_high != le32_to_cpu(ssp_cmd.enc_addr_high)) {
>                                 pm8001_dbg(pm8001_ha, FAIL,
>                                            "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
> -                                          start_addr, ssp_cmd.enc_len,
> +                                          dma_addr,
> +                                          le32_to_cpu(ssp_cmd.enc_len),
>                                            end_addr_high, end_addr_low);
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
> @@ -4446,7 +4451,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                                         cpu_to_le32(lower_32_bits(phys_addr));
>                                 ssp_cmd.enc_addr_high =
>                                         cpu_to_le32(upper_32_bits(phys_addr));
> -                               ssp_cmd.enc_esgl = cpu_to_le32(1<<31);
> +                               ssp_cmd.enc_esgl = cpu_to_le32(1U<<31);
>                         }
>                 } else if (task->num_scatter == 0) {
>                         ssp_cmd.enc_addr_low = 0;
> @@ -4454,8 +4459,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                         ssp_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
>                         ssp_cmd.enc_esgl = 0;
>                 }
> +
>                 /* XTS mode. All other fields are 0 */
> -               ssp_cmd.key_cmode = 0x6 << 4;
> +               ssp_cmd.key_cmode = cpu_to_le32(0x6 << 4);
> +
>                 /* set tweak values. Should be the start lba */
>                 ssp_cmd.twk_val0 = cpu_to_le32((task->ssp_task.cmd->cmnd[2] << 24) |
>                                                 (task->ssp_task.cmd->cmnd[3] << 16) |
> @@ -4477,20 +4484,22 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                         ssp_cmd.esgl = cpu_to_le32(1<<31);
>                 } else if (task->num_scatter == 1) {
>                         u64 dma_addr = sg_dma_address(task->scatter);
> +
>                         ssp_cmd.addr_low = cpu_to_le32(lower_32_bits(dma_addr));
>                         ssp_cmd.addr_high =
>                                 cpu_to_le32(upper_32_bits(dma_addr));
>                         ssp_cmd.len = cpu_to_le32(task->total_xfer_len);
>                         ssp_cmd.esgl = 0;
> +
>                         /* Check 4G Boundary */
> -                       start_addr = cpu_to_le64(dma_addr);
> -                       end_addr = (start_addr + ssp_cmd.len) - 1;
> -                       end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> -                       end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> -                       if (end_addr_high != ssp_cmd.addr_high) {
> +                       end_addr = dma_addr + le32_to_cpu(ssp_cmd.len) - 1;
> +                       end_addr_low = lower_32_bits(end_addr);
> +                       end_addr_high = upper_32_bits(end_addr);
> +                       if (end_addr_high != le32_to_cpu(ssp_cmd.addr_high)) {
>                                 pm8001_dbg(pm8001_ha, FAIL,
>                                            "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
> -                                          start_addr, ssp_cmd.len,
> +                                          dma_addr,
> +                                          le32_to_cpu(ssp_cmd.len),
>                                            end_addr_high, end_addr_low);
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
> --
> 2.34.1
>
