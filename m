Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382EFC4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAC5B20795
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:17:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="KPTmyzCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgJELRB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgJELRB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 07:17:01 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F074AC0613A7
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 04:17:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id c22so9989378ejx.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 04:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BZolf6ks3SQrG5Sxkt8lBzFsVk0ZK0G00WRitlzp0w=;
        b=KPTmyzCIWrrY47ajbMVIv6MfoHUhyqcXoeMc8UeUJa+SXQtcUtrfBbNVoU+uNJ4e6r
         dYAKRbv3Xzkrsx0oK5cLVWpEflkJpR13KlQxLECS5Lin35ftoAmufLrZ0dmW68pCxUIQ
         rEoWFMXF3iOPciebpSfhYK2zLw7ZTm/jRIyg2sp7ivjN9udIybcFQd8t4z0fjK5AHh5D
         UcZHFM4agIGtR1Ei0BA5VpXXd+6oiwIdYziDR/8bgZeAOFIPKk6RgEeqSgL2Q/yvPUNv
         wXczQ6cMlmImquRE5YO6VhdPBdfJ3c0mHmvMHnTFffSsHc+y0m2AKZ9nbRNq/5qlZzzp
         SjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BZolf6ks3SQrG5Sxkt8lBzFsVk0ZK0G00WRitlzp0w=;
        b=tu8WNSRI16oFGkrX4qQX6I8znZFVuNM/uFiSKpCFs5aEcSlfN+DH4vrVlNCuGsDyqU
         6SMN/e+AYeX3BZ9HsEYKYmPzjYKOWmKlYFpD5TimjsSTV9t+lH+SIAN48PYt7f04ZYGo
         0bsuE6+vuqlvWnHe3oZecIIwMsZIMNpTFn2wsA+qUG32+pgw9A9g/v9s9OCdYwvkPI5J
         mcNy0HzOjoVdDZyRs4hAEkRZ3lJQsErSKP8IABHXLVa0X2PRrRBRH7bW2T9HdfSDIloE
         1v1BDmPmYSjSR4n9kpTv9Th4DCvw6ZDg7t17v2Ahp2Q69k3STAWMqZe2eDVmwBLc+nQL
         NMTw==
X-Gm-Message-State: AOAM530Bjdfern1uTJg+YdeRzLaH0QSzRFHFZ8098Ysuk1SQ1XvQ++np
        bLjDfbVv9WmMR/CnWqA1ayE8GRYIXTIn8pdt+ZFNGw==
X-Google-Smtp-Source: ABdhPJxJ5jgyIDI9FEDUkWh6b6RrnB9D8WIKG0ZGvBZcB/2+pLfaGq4eaMc5O44IvOJInCZ1NveRUCKuEjEiadCdtWY=
X-Received: by 2002:a17:906:388:: with SMTP id b8mr14223199eja.62.1601896619590;
 Mon, 05 Oct 2020 04:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200925061605.31628-1-Viswas.G@microchip.com.com> <20200925061605.31628-3-Viswas.G@microchip.com.com>
In-Reply-To: <20200925061605.31628-3-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 5 Oct 2020 13:16:48 +0200
Message-ID: <CAMGffEkWSeEt32eDFQNZBfYdVx-2Yc0XoQp-SFR8i59OH3-M0Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] pm80xx : Remove DMA memory allocation for ccb and device
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
> Removed DMA memory allocation for Devices and CCB
> structure, instead allocated memory outside DMA memory.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
I think it's better to mention DMA memory is limited system resource,
better to alloc memory outside
DMA memory when possible.

With the updated commit message you can add my:
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_defs.h |  8 +++----
>  drivers/scsi/pm8001/pm8001_init.c | 48 ++++++++++++++++++++++++---------------
>  2 files changed, 33 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index a4f52a5a449e..1bf1bcfaf010 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -91,17 +91,15 @@ enum port_type {
>  #define        PM8001_MAX_DEVICES       2048   /* max supported device */
>  #define        PM8001_MAX_MSIX_VEC      64     /* max msi-x int for spcv/ve */
>
> -#define USI_MAX_MEMCNT_BASE    5
>  #define        CONFIG_SCSI_PM8001_MAX_DMA_SG   528
>  #define PM8001_MAX_DMA_SG      CONFIG_SCSI_PM8001_MAX_DMA_SG
>  enum memory_region_num {
>         AAP1 = 0x0, /* application acceleration processor */
>         IOP,        /* IO processor */
>         NVMD,       /* NVM device */
> -       DEV_MEM,    /* memory for devices */
> -       CCB_MEM,    /* memory for command control block */
>         FW_FLASH,    /* memory for fw flash update */
> -       FORENSIC_MEM  /* memory for fw forensic data */
> +       FORENSIC_MEM,  /* memory for fw forensic data */
> +       USI_MAX_MEMCNT_BASE
>  };
>  #define        PM8001_EVENT_LOG_SIZE    (128 * 1024)
>
> @@ -109,7 +107,7 @@ enum memory_region_num {
>   * maximum DMA memory regions(number of IBQ + number of IBQ CI
>   * + number of  OBQ + number of OBQ PI)
>   */
> -#define USI_MAX_MEMCNT (USI_MAX_MEMCNT_BASE + 1 + ((2 * PM8001_MAX_INB_NUM) \
> +#define USI_MAX_MEMCNT (USI_MAX_MEMCNT_BASE + ((2 * PM8001_MAX_INB_NUM) \
>                         + (2 * PM8001_MAX_OUTB_NUM)))
>  /*error code*/
>  enum mpi_err {
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index c744f846e08d..d6789a261c1c 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -288,7 +288,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>
>         count = pm8001_ha->max_q_num;
>         /* Queues are chosen based on the number of cores/msix availability */
> -       ib_offset = pm8001_ha->ib_offset  = USI_MAX_MEMCNT_BASE + 1;
> +       ib_offset = pm8001_ha->ib_offset  = USI_MAX_MEMCNT_BASE;
>         ci_offset = pm8001_ha->ci_offset  = ib_offset + count;
>         ob_offset = pm8001_ha->ob_offset  = ci_offset + count;
>         pi_offset = pm8001_ha->pi_offset  = ob_offset + count;
> @@ -380,19 +380,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>         pm8001_ha->memoryMap.region[NVMD].num_elements = 1;
>         pm8001_ha->memoryMap.region[NVMD].element_size = 4096;
>         pm8001_ha->memoryMap.region[NVMD].total_len = 4096;
> -       /* Memory region for devices*/
> -       pm8001_ha->memoryMap.region[DEV_MEM].num_elements = 1;
> -       pm8001_ha->memoryMap.region[DEV_MEM].element_size = PM8001_MAX_DEVICES *
> -               sizeof(struct pm8001_device);
> -       pm8001_ha->memoryMap.region[DEV_MEM].total_len = PM8001_MAX_DEVICES *
> -               sizeof(struct pm8001_device);
> -
> -       /* Memory region for ccb_info*/
> -       pm8001_ha->memoryMap.region[CCB_MEM].num_elements = 1;
> -       pm8001_ha->memoryMap.region[CCB_MEM].element_size = PM8001_MAX_CCB *
> -               sizeof(struct pm8001_ccb_info);
> -       pm8001_ha->memoryMap.region[CCB_MEM].total_len = PM8001_MAX_CCB *
> -               sizeof(struct pm8001_ccb_info);
>
>         /* Memory region for fw flash */
>         pm8001_ha->memoryMap.region[FW_FLASH].total_len = 4096;
> @@ -416,18 +403,30 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>                 }
>         }
>
> -       pm8001_ha->devices = pm8001_ha->memoryMap.region[DEV_MEM].virt_ptr;
> +       /* Memory region for devices*/
> +       pm8001_ha->devices = kzalloc(PM8001_MAX_DEVICES
> +                               * sizeof(struct pm8001_device), GFP_KERNEL);
> +       if (!pm8001_ha->devices) {
> +               rc = -ENOMEM;
> +               goto err_out_nodev;
> +       }
>         for (i = 0; i < PM8001_MAX_DEVICES; i++) {
>                 pm8001_ha->devices[i].dev_type = SAS_PHY_UNUSED;
>                 pm8001_ha->devices[i].id = i;
>                 pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
>                 pm8001_ha->devices[i].running_req = 0;
>         }
> -       pm8001_ha->ccb_info = pm8001_ha->memoryMap.region[CCB_MEM].virt_ptr;
> +       /* Memory region for ccb_info*/
> +       pm8001_ha->ccb_info = kzalloc(PM8001_MAX_CCB
> +                               * sizeof(struct pm8001_ccb_info), GFP_KERNEL);
> +       if (!pm8001_ha->ccb_info) {
> +               rc = -ENOMEM;
> +               goto err_out_noccb;
> +       }
>         for (i = 0; i < PM8001_MAX_CCB; i++) {
>                 pm8001_ha->ccb_info[i].ccb_dma_handle =
> -                       pm8001_ha->memoryMap.region[CCB_MEM].phys_addr +
> -                       i * sizeof(struct pm8001_ccb_info);
> +                       virt_to_phys(pm8001_ha->ccb_info) +
> +                       (i * sizeof(struct pm8001_ccb_info));
>                 pm8001_ha->ccb_info[i].task = NULL;
>                 pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
>                 pm8001_ha->ccb_info[i].device = NULL;
> @@ -437,8 +436,21 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>         /* Initialize tags */
>         pm8001_tag_init(pm8001_ha);
>         return 0;
> +
> +err_out_noccb:
> +       kfree(pm8001_ha->devices);
>  err_out_shost:
>         scsi_remove_host(pm8001_ha->shost);
> +err_out_nodev:
> +       for (i = 0; i < pm8001_ha->max_memcnt; i++) {
> +               if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
> +                       pci_free_consistent(pm8001_ha->pdev,
> +                               (pm8001_ha->memoryMap.region[i].total_len +
> +                               pm8001_ha->memoryMap.region[i].alignment),
> +                               pm8001_ha->memoryMap.region[i].virt_ptr,
> +                               pm8001_ha->memoryMap.region[i].phys_addr);
> +               }
> +       }
>  err_out:
>         return 1;
>  }
> --
> 2.16.3
>
