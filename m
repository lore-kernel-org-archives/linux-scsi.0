Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523C2C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F156C20776
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="jCofJ/aK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJELVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJELVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 07:21:21 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D70C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 04:21:20 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e22so4495330ejr.4
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 04:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4mU1g/pr3kppVYRNoRWzPMgZFj2Uojl7ACAy4c8texQ=;
        b=jCofJ/aK/ND7NqcmK3aEhXz0OUup/JnRlIOXiJJeYWkVJ1EGlAkMefmQC0PG/6woE6
         jyaWFg21VsaHcGqDsDA5VnGgH3xK7WOojGEtGcmxGbl/Iwbm6u4nUaZjMY/ItpHcjc4l
         +iyDTkNdLIwt86jce9feWK71mxC82IxN+nvrZ3t8GDY+Vay7dqSC78KTX1LcBblhs2Re
         /AlIlK7dD8IAG9FW0ClJXcJFYk9hZYJ2t8J7tpBmyZd6mfxIUCDbcIkcVSkeR2SmRqoA
         eQsp83dw1LYg1fGGuktFd54qarmDOCxm3Ywa38SprSy0W2v8h6EyJ5dn9dcPmI8vVX/U
         n/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4mU1g/pr3kppVYRNoRWzPMgZFj2Uojl7ACAy4c8texQ=;
        b=UbnInP2pIdMCGtE0lxsPqP1XmwZ5ZdYhuWuVNOLRtEPoSNdHUUvzuYmBaeRHB8BNt/
         XG+il3wdcw88dSNDjJw1b9axOqGtUUhIZVCsf00T3W8rlFXe37gYezIt8WsJdNzmLaqq
         GF3QYifMUu1OXiADdcz5/HqDjaXJ2Ebjv7hKydwKxTNctAFhiKRHrgqsPuFQXg6afH1H
         mxWsp5eJigY+YNKNTViQoTzeXIeoRT7p1qA7IB+2flKCEKUJQFMS4C9BLewNaJOB1HUZ
         dy/cSZ202qIK4rOVdvxLV6YH6nwUgLE65uK0dSdQBczumdhCS40soqIxsYZfwt6V+i+u
         yavQ==
X-Gm-Message-State: AOAM531/X2p+/4gJhptuGZxWL/fE68p2SwQsTTRNhkpg+syXE2ziLA9Y
        iOnicyi0OC9uqXo/TNje2jyxz6lRtsdoXRm+pAqGv/EvZcJbPg==
X-Google-Smtp-Source: ABdhPJzHQD7DzVtl2FtxX7F/2tUVsqaI1Evtrzag17E1ZcwUa0A4LN7d0JJup5eIwCWbPKl6qbcTYvPmMlgIvHcjcO8=
X-Received: by 2002:a17:906:c78a:: with SMTP id cw10mr6320100ejb.478.1601896879433;
 Mon, 05 Oct 2020 04:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200925061605.31628-1-Viswas.G@microchip.com.com> <20200925061605.31628-4-Viswas.G@microchip.com.com>
In-Reply-To: <20200925061605.31628-4-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 5 Oct 2020 13:21:08 +0200
Message-ID: <CAMGffEnsjQ3jrZEn1TQTXtg2sU=qjQONcVMvq+3VPzKQOdehWg@mail.gmail.com>
Subject: Re: [PATCH 3/4] pm80xx : Increase the number of outstanding IO supported
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 25, 2020 at 8:06 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> Increasing the number of Outstanding IOs from 256 to 1024.
> CCB and tag are allocated according to outstanding IOs.
> Also updating the can_queue value (max_out_io - PM8001_RESERVE_SLOT)
> to scsi midlayer.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
As commented in other patches, please also document the reason for the
change in commit message.

The patch itself looks fine to me!
Thank you
> ---
>  drivers/scsi/pm8001/pm8001_defs.h |  4 +-
>  drivers/scsi/pm8001/pm8001_hwi.c  |  6 +--
>  drivers/scsi/pm8001/pm8001_init.c | 79 ++++++++++++++++++++++++++++-----------
>  drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 28 ++++----------
>  5 files changed, 72 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index 1bf1bcfaf010..501b574239e8 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -75,7 +75,7 @@ enum port_type {
>  };
>
>  /* driver compile-time configuration */
> -#define        PM8001_MAX_CCB           256    /* max ccbs supported */
> +#define        PM8001_MAX_CCB           1024   /* max ccbs supported */
>  #define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
>  #define        PM8001_MAX_INB_NUM       64
>  #define        PM8001_MAX_OUTB_NUM      64
> @@ -90,9 +90,11 @@ enum port_type {
>  #define        PM8001_MAX_PORTS         16     /* max. possible ports */
>  #define        PM8001_MAX_DEVICES       2048   /* max supported device */
>  #define        PM8001_MAX_MSIX_VEC      64     /* max msi-x int for spcv/ve */
> +#define        PM8001_RESERVE_SLOT      8
>
>  #define        CONFIG_SCSI_PM8001_MAX_DMA_SG   528
>  #define PM8001_MAX_DMA_SG      CONFIG_SCSI_PM8001_MAX_DMA_SG
> +
>  enum memory_region_num {
>         AAP1 = 0x0, /* application acceleration processor */
>         IOP,        /* IO processor */
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index e9106575a30f..2b7b2954ec31 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4375,8 +4375,7 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>         /* fill in PRD (scatter/gather) table, if any */
>         if (task->num_scatter > 1) {
>                 pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
> -               phys_addr = ccb->ccb_dma_handle +
> -                               offsetof(struct pm8001_ccb_info, buf_prd[0]);
> +               phys_addr = ccb->ccb_dma_handle;
>                 ssp_cmd.addr_low = cpu_to_le32(lower_32_bits(phys_addr));
>                 ssp_cmd.addr_high = cpu_to_le32(upper_32_bits(phys_addr));
>                 ssp_cmd.esgl = cpu_to_le32(1<<31);
> @@ -4449,8 +4448,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         /* fill in PRD (scatter/gather) table, if any */
>         if (task->num_scatter > 1) {
>                 pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
> -               phys_addr = ccb->ccb_dma_handle +
> -                               offsetof(struct pm8001_ccb_info, buf_prd[0]);
> +               phys_addr = ccb->ccb_dma_handle;
>                 sata_cmd.addr_low = lower_32_bits(phys_addr);
>                 sata_cmd.addr_high = upper_32_bits(phys_addr);
>                 sata_cmd.esgl = cpu_to_le32(1 << 31);
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index d6789a261c1c..d04d6ecd8c0f 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -56,6 +56,7 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
>                 " 8: Link rate 12.0G\n");
>
>  static struct scsi_transport_template *pm8001_stt;
> +static int pm8001_init_ccb_tag(struct pm8001_hba_info *, struct Scsi_Host *, struct pci_dev *);
>
>  /*
>   * chip info structure to identify chip key functionality as
> @@ -302,9 +303,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>                 INIT_LIST_HEAD(&pm8001_ha->port[i].list);
>         }
>
> -       pm8001_ha->tags = kzalloc(PM8001_MAX_CCB, GFP_KERNEL);
> -       if (!pm8001_ha->tags)
> -               goto err_out;
>         /* MPI Memory region 1 for AAP Event Log for fw */
>         pm8001_ha->memoryMap.region[AAP1].num_elements = 1;
>         pm8001_ha->memoryMap.region[AAP1].element_size = PM8001_EVENT_LOG_SIZE;
> @@ -416,29 +414,11 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>                 pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
>                 pm8001_ha->devices[i].running_req = 0;
>         }
> -       /* Memory region for ccb_info*/
> -       pm8001_ha->ccb_info = kzalloc(PM8001_MAX_CCB
> -                               * sizeof(struct pm8001_ccb_info), GFP_KERNEL);
> -       if (!pm8001_ha->ccb_info) {
> -               rc = -ENOMEM;
> -               goto err_out_noccb;
> -       }
> -       for (i = 0; i < PM8001_MAX_CCB; i++) {
> -               pm8001_ha->ccb_info[i].ccb_dma_handle =
> -                       virt_to_phys(pm8001_ha->ccb_info) +
> -                       (i * sizeof(struct pm8001_ccb_info));
> -               pm8001_ha->ccb_info[i].task = NULL;
> -               pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
> -               pm8001_ha->ccb_info[i].device = NULL;
> -               ++pm8001_ha->tags_num;
> -       }
>         pm8001_ha->flags = PM8001F_INIT_TIME;
>         /* Initialize tags */
>         pm8001_tag_init(pm8001_ha);
>         return 0;
>
> -err_out_noccb:
> -       kfree(pm8001_ha->devices);
>  err_out_shost:
>         scsi_remove_host(pm8001_ha->shost);
>  err_out_nodev:
> @@ -1133,6 +1113,10 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>                 goto err_out_ha_free;
>         }
>
> +       rc = pm8001_init_ccb_tag(pm8001_ha, shost, pdev);
> +       if (rc)
> +               goto err_out_enable;
> +
>         rc = scsi_add_host(shost, &pdev->dev);
>         if (rc)
>                 goto err_out_ha_free;
> @@ -1178,6 +1162,59 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>         return rc;
>  }
>
> +/*
> + * pm8001_init_ccb_tag - allocate memory to CCB and tag.
> + * @pm8001_ha: our hba card information.
> + * @shost: scsi host which has been allocated outside.
> + */
> +static int
> +pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
> +                       struct pci_dev *pdev)
> +{
> +       int i, ret = 0;
> +       u32 max_out_io, ccb_count;
> +       u32 can_queue;
> +
> +       max_out_io = pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_out_io;
> +       ccb_count = min_t(int, PM8001_MAX_CCB, max_out_io);
> +
> +       /*Update to the scsi host*/
> +       can_queue = ccb_count - PM8001_RESERVE_SLOT;
> +       shost->can_queue = can_queue;
> +
> +       pm8001_ha->tags = kzalloc(ccb_count, GFP_KERNEL);
> +       if (!pm8001_ha->tags)
> +               goto err_out;
> +
> +       /* Memory region for ccb_info*/
> +       pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
> +               kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
> +       if (!pm8001_ha->ccb_info) {
> +               ret = -ENOMEM;
> +               goto err_out_noccb;
> +       }
> +       for (i = 0; i < ccb_count; i++) {
> +               pm8001_ha->ccb_info[i].buf_prd = pci_alloc_consistent(pdev,
> +                               sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
> +                               &pm8001_ha->ccb_info[i].ccb_dma_handle);
> +               if (!pm8001_ha->ccb_info[i].buf_prd) {
> +                       PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
> +                                       (KERN_ERR "pm80xx: ccb prd memory allocation error\n"));
> +                       goto err_out;
> +               }
> +               pm8001_ha->ccb_info[i].task = NULL;
> +               pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
> +               pm8001_ha->ccb_info[i].device = NULL;
> +               ++pm8001_ha->tags_num;
> +       }
> +       return 0;
> +
> +err_out_noccb:
> +       kfree(pm8001_ha->devices);
> +err_out:
> +       return -ENOMEM;
> +}
> +
>  static void pm8001_pci_remove(struct pci_dev *pdev)
>  {
>         struct sas_ha_struct *sha = pci_get_drvdata(pdev);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index bdfce3c3f619..9d7796a74ed4 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -315,7 +315,7 @@ struct pm8001_ccb_info {
>         u32                     ccb_tag;
>         dma_addr_t              ccb_dma_handle;
>         struct pm8001_device    *device;
> -       struct pm8001_prd       buf_prd[PM8001_MAX_DMA_SG];
> +       struct pm8001_prd       *buf_prd;
>         struct fw_control_ex    *fw_control_context;
>         u8                      open_retry;
>  };
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 26e9e8877107..7593f248afb2 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4483,8 +4483,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                 if (task->num_scatter > 1) {
>                         pm8001_chip_make_sg(task->scatter,
>                                                 ccb->n_elem, ccb->buf_prd);
> -                       phys_addr = ccb->ccb_dma_handle +
> -                               offsetof(struct pm8001_ccb_info, buf_prd[0]);
> +                       phys_addr = ccb->ccb_dma_handle;
>                         ssp_cmd.enc_addr_low =
>                                 cpu_to_le32(lower_32_bits(phys_addr));
>                         ssp_cmd.enc_addr_high =
> @@ -4513,9 +4512,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                                                 end_addr_high, end_addr_low));
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
> -                               phys_addr = ccb->ccb_dma_handle +
> -                                       offsetof(struct pm8001_ccb_info,
> -                                               buf_prd[0]);
> +                               phys_addr = ccb->ccb_dma_handle;
>                                 ssp_cmd.enc_addr_low =
>                                         cpu_to_le32(lower_32_bits(phys_addr));
>                                 ssp_cmd.enc_addr_high =
> @@ -4543,8 +4540,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                 if (task->num_scatter > 1) {
>                         pm8001_chip_make_sg(task->scatter, ccb->n_elem,
>                                         ccb->buf_prd);
> -                       phys_addr = ccb->ccb_dma_handle +
> -                               offsetof(struct pm8001_ccb_info, buf_prd[0]);
> +                       phys_addr = ccb->ccb_dma_handle;
>                         ssp_cmd.addr_low =
>                                 cpu_to_le32(lower_32_bits(phys_addr));
>                         ssp_cmd.addr_high =
> @@ -4572,9 +4568,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                                                  end_addr_high, end_addr_low));
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
> -                               phys_addr = ccb->ccb_dma_handle +
> -                                       offsetof(struct pm8001_ccb_info,
> -                                                buf_prd[0]);
> +                               phys_addr = ccb->ccb_dma_handle;
>                                 ssp_cmd.addr_low =
>                                         cpu_to_le32(lower_32_bits(phys_addr));
>                                 ssp_cmd.addr_high =
> @@ -4666,8 +4660,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                 if (task->num_scatter > 1) {
>                         pm8001_chip_make_sg(task->scatter,
>                                                 ccb->n_elem, ccb->buf_prd);
> -                       phys_addr = ccb->ccb_dma_handle +
> -                               offsetof(struct pm8001_ccb_info, buf_prd[0]);
> +                       phys_addr = ccb->ccb_dma_handle;
>                         sata_cmd.enc_addr_low = lower_32_bits(phys_addr);
>                         sata_cmd.enc_addr_high = upper_32_bits(phys_addr);
>                         sata_cmd.enc_esgl = cpu_to_le32(1 << 31);
> @@ -4692,9 +4685,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                                                 end_addr_high, end_addr_low));
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
> -                               phys_addr = ccb->ccb_dma_handle +
> -                                               offsetof(struct pm8001_ccb_info,
> -                                               buf_prd[0]);
> +                               phys_addr = ccb->ccb_dma_handle;
>                                 sata_cmd.enc_addr_low =
>                                         lower_32_bits(phys_addr);
>                                 sata_cmd.enc_addr_high =
> @@ -4732,8 +4723,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                 if (task->num_scatter > 1) {
>                         pm8001_chip_make_sg(task->scatter,
>                                         ccb->n_elem, ccb->buf_prd);
> -                       phys_addr = ccb->ccb_dma_handle +
> -                               offsetof(struct pm8001_ccb_info, buf_prd[0]);
> +                       phys_addr = ccb->ccb_dma_handle;
>                         sata_cmd.addr_low = lower_32_bits(phys_addr);
>                         sata_cmd.addr_high = upper_32_bits(phys_addr);
>                         sata_cmd.esgl = cpu_to_le32(1 << 31);
> @@ -4758,9 +4748,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                                                 end_addr_high, end_addr_low));
>                                 pm8001_chip_make_sg(task->scatter, 1,
>                                         ccb->buf_prd);
> -                               phys_addr = ccb->ccb_dma_handle +
> -                                       offsetof(struct pm8001_ccb_info,
> -                                       buf_prd[0]);
> +                               phys_addr = ccb->ccb_dma_handle;
>                                 sata_cmd.addr_low =
>                                         lower_32_bits(phys_addr);
>                                 sata_cmd.addr_high =
> --
> 2.16.3
>
