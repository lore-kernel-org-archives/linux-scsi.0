Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59295C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245024AbiBQTNj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:13:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242994AbiBQTNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:13:39 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48418D697
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:13:23 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a23so9585995eju.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DjZ8osrxKE8LzG4i79RP8Wbr35iILEvFnLjaS4JxaI=;
        b=AqSprOUHvJFKhCvYM+GP8oQvRDc+cmC9zz6YeCNAvMYx1PJfOhrkEoutkq7YAfiINv
         ebR2LzBdOGr29ZX4icerXG2GThpmTh+qdrL+bKmgxy6IhD0dapB+3E6lzCsD14YWVDxy
         aMl4NRdcwfOwAi1rdgPdwvTkh4Di0fGK/O/F+iD/VH3RasAQhWJXq+GFnGqMIcBVULHU
         jQ/Y7omh/9pr94HT8DysG2m7i1QEX8H+wB3+12UsxoQmAiJbtcJNS++jfnYZLshxZI7i
         SwtT7uTeez/lykRgWnHFAbRD0Kal46QAOTj9y/fbzpUqmGUdd5F6w+e4fwgaGETkIfUG
         Zdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DjZ8osrxKE8LzG4i79RP8Wbr35iILEvFnLjaS4JxaI=;
        b=iImTRANfzSjeEx1EsiNZvhOxY7djVOal0I6c8D0nfjeySB/wCxmrytH82EBpX17Ozf
         tVtHXsorvDVx8OzEzRcbxrw/AbxpyfDQrpkUp3jRwUSIFD1590y+usxs6WK8YcuAju6Z
         dT9W5z7NqD8AlT83sXjM2nlMzNKcXqsoWY/Fw2pPV1PRs8n0ZgCl7VsDN95kTn1WjS8k
         191g9FBbytRmvhCtYgNjdxFvkW6dHY00wMZU3TmxxFerTpWaiXPYTAuqh5GuUghSRZv4
         BCaR4Q351+SH2seVlnCA/N/pe1snxjOZw6pEMZCwQKiqwWD4M9H+ZkG/CD5jzDdIavZB
         C57w==
X-Gm-Message-State: AOAM530CljiSMy2+FL/NtD+y2O5Y+r+btkS41kTOnPu9AQw/o2bKHb5j
        MlT4mqdzgf590d3Hu/gvPHFyv+Z067JfT5oAeAz3OA==
X-Google-Smtp-Source: ABdhPJxO/duPYKwMW7PzkRCGL2j4yBDy2o6T9yUKRexeC3K9SUsepkavzT+FRfguENny6m1jumz+UwPDl0xGfHWzcY8=
X-Received: by 2002:a17:907:76ac:b0:6ce:72b5:7b7c with SMTP id
 jw12-20020a17090776ac00b006ce72b57b7cmr3451750ejc.735.1645125202178; Thu, 17
 Feb 2022 11:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-12-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-12-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:13:11 +0100
Message-ID: <CAMGffEnrov3BVma=xsRrc+eoyVb=eQrSWQXU5x_HmO12w8FRnQ@mail.gmail.com>
Subject: Re: [PATCH v4 11/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> Make sure that the __le32 fields of struct sata_cmd are manipulated
> after applying the correct endian conversion. That is, use cpu_to_le32()
> for assigning values and le32_to_cpu() for consulting a field value.
> In particular, make sure that the calculations for the 4G boundary check
> are done using CPU endianness and *not* little endian values. With these
> fixes, many sparse warnings are removed.
>
> While at it, fix some code identation and add blank lines after
> variable declarations and in some other places to make this code more
> readable.
>
> Fixes: 0ecdf00ba6e5 ("[SCSI] pm80xx: 4G boundary fix.")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 82 ++++++++++++++++++--------------
>  1 file changed, 45 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 130747b5a70a..1f3b01c70f24 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4534,7 +4534,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         u32 q_index, cpu_id;
>         struct sata_start_req sata_cmd;
>         u32 hdr_tag, ncg_tag = 0;
> -       u64 phys_addr, start_addr, end_addr;
> +       u64 phys_addr, end_addr;
>         u32 end_addr_high, end_addr_low;
>         u32 ATAP = 0x0;
>         u32 dir;
> @@ -4595,32 +4595,38 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                         pm8001_chip_make_sg(task->scatter,
>                                                 ccb->n_elem, ccb->buf_prd);
>                         phys_addr = ccb->ccb_dma_handle;
> -                       sata_cmd.enc_addr_low = lower_32_bits(phys_addr);
> -                       sata_cmd.enc_addr_high = upper_32_bits(phys_addr);
> +                       sata_cmd.enc_addr_low =
> +                               cpu_to_le32(lower_32_bits(phys_addr));
> +                       sata_cmd.enc_addr_high =
> +                               cpu_to_le32(upper_32_bits(phys_addr));
>                         sata_cmd.enc_esgl = cpu_to_le32(1 << 31);
>                 } else if (task->num_scatter == 1) {
>                         u64 dma_addr = sg_dma_address(task->scatter);
> -                       sata_cmd.enc_addr_low = lower_32_bits(dma_addr);
> -                       sata_cmd.enc_addr_high = upper_32_bits(dma_addr);
> +
> +                       sata_cmd.enc_addr_low =
> +                               cpu_to_le32(lower_32_bits(dma_addr));
> +                       sata_cmd.enc_addr_high =
> +                               cpu_to_le32(upper_32_bits(dma_addr));
>                         sata_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
>                         sata_cmd.enc_esgl = 0;
> +
>                         /* Check 4G Boundary */
> -                       start_addr = cpu_to_le64(dma_addr);
> -                       end_addr = (start_addr + sata_cmd.enc_len) - 1;
> -                       end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> -                       end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> -                       if (end_addr_high != sata_cmd.enc_addr_high) {
> +                       end_addr = dma_addr + le32_to_cpu(sata_cmd.enc_len) - 1;
> +                       end_addr_low = lower_32_bits(end_addr);
> +                       end_addr_high = upper_32_bits(end_addr);
> +                       if (end_addr_high != le32_to_cpu(sata_cmd.enc_addr_high)) {
>                                 pm8001_dbg(pm8001_ha, FAIL,
>                                            "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
> -                                          start_addr, sata_cmd.enc_len,
> +                                          dma_addr,
> +                                          le32_to_cpu(sata_cmd.enc_len),
>                                            end_addr_high, end_addr_low);
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
>                                 phys_addr = ccb->ccb_dma_handle;
>                                 sata_cmd.enc_addr_low =
> -                                       lower_32_bits(phys_addr);
> +                                       cpu_to_le32(lower_32_bits(phys_addr));
>                                 sata_cmd.enc_addr_high =
> -                                       upper_32_bits(phys_addr);
> +                                       cpu_to_le32(upper_32_bits(phys_addr));
>                                 sata_cmd.enc_esgl =
>                                         cpu_to_le32(1 << 31);
>                         }
> @@ -4631,7 +4637,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                         sata_cmd.enc_esgl = 0;
>                 }
>                 /* XTS mode. All other fields are 0 */
> -               sata_cmd.key_index_mode = 0x6 << 4;
> +               sata_cmd.key_index_mode = cpu_to_le32(0x6 << 4);
> +
>                 /* set tweak values. Should be the start lba */
>                 sata_cmd.twk_val0 =
>                         cpu_to_le32((sata_cmd.sata_fis.lbal_exp << 24) |
> @@ -4657,31 +4664,31 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                         phys_addr = ccb->ccb_dma_handle;
>                         sata_cmd.addr_low = lower_32_bits(phys_addr);
>                         sata_cmd.addr_high = upper_32_bits(phys_addr);
> -                       sata_cmd.esgl = cpu_to_le32(1 << 31);
> +                       sata_cmd.esgl = cpu_to_le32(1U << 31);
>                 } else if (task->num_scatter == 1) {
>                         u64 dma_addr = sg_dma_address(task->scatter);
> +
>                         sata_cmd.addr_low = lower_32_bits(dma_addr);
>                         sata_cmd.addr_high = upper_32_bits(dma_addr);
>                         sata_cmd.len = cpu_to_le32(task->total_xfer_len);
>                         sata_cmd.esgl = 0;
> +
>                         /* Check 4G Boundary */
> -                       start_addr = cpu_to_le64(dma_addr);
> -                       end_addr = (start_addr + sata_cmd.len) - 1;
> -                       end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
> -                       end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
> +                       end_addr = dma_addr + le32_to_cpu(sata_cmd.len) - 1;
> +                       end_addr_low = lower_32_bits(end_addr);
> +                       end_addr_high = upper_32_bits(end_addr);
>                         if (end_addr_high != sata_cmd.addr_high) {
>                                 pm8001_dbg(pm8001_ha, FAIL,
>                                            "The sg list address start_addr=0x%016llx data_len=0x%xend_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
> -                                          start_addr, sata_cmd.len,
> +                                          dma_addr,
> +                                          le32_to_cpu(sata_cmd.len),
>                                            end_addr_high, end_addr_low);
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
>                                 phys_addr = ccb->ccb_dma_handle;
> -                               sata_cmd.addr_low =
> -                                       lower_32_bits(phys_addr);
> -                               sata_cmd.addr_high =
> -                                       upper_32_bits(phys_addr);
> -                               sata_cmd.esgl = cpu_to_le32(1 << 31);
> +                               sata_cmd.addr_low = lower_32_bits(phys_addr);
> +                               sata_cmd.addr_high = upper_32_bits(phys_addr);
> +                               sata_cmd.esgl = cpu_to_le32(1U << 31);
>                         }
>                 } else if (task->num_scatter == 0) {
>                         sata_cmd.addr_low = 0;
> @@ -4689,27 +4696,28 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                         sata_cmd.len = cpu_to_le32(task->total_xfer_len);
>                         sata_cmd.esgl = 0;
>                 }
> +
>                 /* scsi cdb */
>                 sata_cmd.atapi_scsi_cdb[0] =
>                         cpu_to_le32(((task->ata_task.atapi_packet[0]) |
> -                       (task->ata_task.atapi_packet[1] << 8) |
> -                       (task->ata_task.atapi_packet[2] << 16) |
> -                       (task->ata_task.atapi_packet[3] << 24)));
> +                                    (task->ata_task.atapi_packet[1] << 8) |
> +                                    (task->ata_task.atapi_packet[2] << 16) |
> +                                    (task->ata_task.atapi_packet[3] << 24)));
>                 sata_cmd.atapi_scsi_cdb[1] =
>                         cpu_to_le32(((task->ata_task.atapi_packet[4]) |
> -                       (task->ata_task.atapi_packet[5] << 8) |
> -                       (task->ata_task.atapi_packet[6] << 16) |
> -                       (task->ata_task.atapi_packet[7] << 24)));
> +                                    (task->ata_task.atapi_packet[5] << 8) |
> +                                    (task->ata_task.atapi_packet[6] << 16) |
> +                                    (task->ata_task.atapi_packet[7] << 24)));
>                 sata_cmd.atapi_scsi_cdb[2] =
>                         cpu_to_le32(((task->ata_task.atapi_packet[8]) |
> -                       (task->ata_task.atapi_packet[9] << 8) |
> -                       (task->ata_task.atapi_packet[10] << 16) |
> -                       (task->ata_task.atapi_packet[11] << 24)));
> +                                    (task->ata_task.atapi_packet[9] << 8) |
> +                                    (task->ata_task.atapi_packet[10] << 16) |
> +                                    (task->ata_task.atapi_packet[11] << 24)));
>                 sata_cmd.atapi_scsi_cdb[3] =
>                         cpu_to_le32(((task->ata_task.atapi_packet[12]) |
> -                       (task->ata_task.atapi_packet[13] << 8) |
> -                       (task->ata_task.atapi_packet[14] << 16) |
> -                       (task->ata_task.atapi_packet[15] << 24)));
> +                                    (task->ata_task.atapi_packet[13] << 8) |
> +                                    (task->ata_task.atapi_packet[14] << 16) |
> +                                    (task->ata_task.atapi_packet[15] << 24)));
>         }
>
>         /* Check for read log for failed drive and return */
> --
> 2.34.1
>
