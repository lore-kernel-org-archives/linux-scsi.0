Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A273C35669
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 03:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D80FF2072C
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 03:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrIXTkIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgBVDGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 22:06:16 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:37936 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBVDGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 22:06:16 -0500
Received: by mail-vk1-f196.google.com with SMTP id w4so1145850vkd.5
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2020 19:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WqxcktmdzAdiizHmOrEakg2Rb0ODjrIDsA/V2AckjiY=;
        b=JrIXTkIWlqGWEknxQ75uGittZ/iOZ3p4AERW9PSNo35GRqFNQuwHpAsKnjiRfEwup6
         cjHmkbiFnQpTF1OeYhuLSrHX07QHy5ICOCMSeeDJ3b6zpzG8VpTaYYoZ2vS2vccG6du+
         86cxZIAOVAjU53EUaQ9BtqsANTIHL/+Tmxqhocbr+Wlg2PkdY0pWW1AohhtqM9fiJwKK
         Q7LGPu7+wBVGXDTmHvhEu823prQhB1Vz74KKRu/zB7hSI408bijwVNJKIY+NSqw7nIUH
         o6YmlEE4tfRDY9w7P5NPku0Ppj4Uo7lEL1HACp4BTv6SItNK1R9KLw3/YlIn2Jj4uSAl
         Ozfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WqxcktmdzAdiizHmOrEakg2Rb0ODjrIDsA/V2AckjiY=;
        b=Zxi0A3KkxeyuSQ/O213lwU2lA7uObtufwgm8SjbgrCOsMpN9EIrg/2Elf3E3WZ8Oec
         XYlMNJm7b8W+CpV5ysnyhZpXKmi+9hz2mOzxzG9ISo5YWVUgqoE4hppPMOASlZhAZ1Bt
         gVxmqTlNJ1iLQU7BJRfmm16I24ZapNZUgpyqJcHtcG5RT6D+cGt75u5wb4tBTNnIgUdL
         MAXWLHuWsySUVA3p115gjCHkYJcyh2oXlWGwD9yPC9CNS2b8S0Y/zFTTGQ8h+r4Gnn3r
         h4q/SsJ47HmNPSCGgX0Fr5ypvkZg2vUr08Dk9g9PgevPcR8NczM6LQPhHCzu5SfgzBhV
         D5gA==
X-Gm-Message-State: APjAAAXZEemBpJJeFO89UIQPuo1rY4/MO2xYcATBO0+XSZ8UQT5E6Mdf
        7RzUFc0yv/8WglGZ8c3963pJIKf1enMWM2dnxgg=
X-Google-Smtp-Source: APXvYqxShzr9YUXE0XMU0u3JOz0yzv++a+QzkMRngGsvG603Kb6F4PJ5l6YRY6KsaSk/X8NRDd9WmdEb9c0U7aRDBRY=
X-Received: by 2002:a1f:1bc3:: with SMTP id b186mr19210126vkb.96.1582340773718;
 Fri, 21 Feb 2020 19:06:13 -0800 (PST)
MIME-Version: 1.0
References: <20200221140812.476338-1-hch@lst.de> <20200221140812.476338-2-hch@lst.de>
In-Reply-To: <20200221140812.476338-2-hch@lst.de>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sat, 22 Feb 2020 08:35:37 +0530
Message-ID: <CAGOxZ52TVc4NEb6=bxH6potSgmRhjZt2NGsBMODweEbWkKJM5A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ufshcd: remove unused quirks
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2020 at 7:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove various quirks that don't have users, as well as the dead code
> keyed off them.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


This does not make sense to remove it now and revert the patch a few week later.
Martin / Avri your thought please.


> ---
>  drivers/scsi/ufs/ufshcd.c | 119 ++++----------------------------------
>  drivers/scsi/ufs/ufshcd.h |  22 -------
>  2 files changed, 12 insertions(+), 129 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index abd0e6b05f79..886a8a597e6a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -642,11 +642,7 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
>   */
>  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -       if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> -               ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> -       else
> -               ufshcd_writel(hba, ~(1 << pos),
> -                               REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +       ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>  }
>
>  /**
> @@ -656,10 +652,7 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>   */
>  static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -       if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> -               ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
> -       else
> -               ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
> +       ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
>  }
>
>  /**
> @@ -2093,13 +2086,8 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>                 return sg_segments;
>
>         if (sg_segments) {
> -               if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> -                       lrbp->utr_descriptor_ptr->prd_table_length =
> -                               cpu_to_le16((u16)(sg_segments *
> -                                       sizeof(struct ufshcd_sg_entry)));
> -               else
> -                       lrbp->utr_descriptor_ptr->prd_table_length =
> -                               cpu_to_le16((u16) (sg_segments));
> +               lrbp->utr_descriptor_ptr->prd_table_length =
> +                       cpu_to_le16((u16)sg_segments);
>
>                 prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
>
> @@ -3403,21 +3391,11 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>                                 cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
>
>                 /* Response upiu and prdt offset should be in double words */
> -               if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
> -                       utrdlp[i].response_upiu_offset =
> -                               cpu_to_le16(response_offset);
> -                       utrdlp[i].prd_table_offset =
> -                               cpu_to_le16(prdt_offset);
> -                       utrdlp[i].response_upiu_length =
> -                               cpu_to_le16(ALIGNED_UPIU_SIZE);
> -               } else {
> -                       utrdlp[i].response_upiu_offset =
> -                               cpu_to_le16((response_offset >> 2));
> -                       utrdlp[i].prd_table_offset =
> -                               cpu_to_le16((prdt_offset >> 2));
> -                       utrdlp[i].response_upiu_length =
> -                               cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> -               }
> +               utrdlp[i].response_upiu_offset =
> +                       cpu_to_le16(response_offset >> 2);
> +               utrdlp[i].prd_table_offset = cpu_to_le16(prdt_offset >> 2);
> +               utrdlp[i].response_upiu_length =
> +                       cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
>
>                 hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
>                 hba->lrb[i].utrd_dma_addr = hba->utrdl_dma_addr +
> @@ -3460,52 +3438,6 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>                         "dme-link-startup: error code %d\n", ret);
>         return ret;
>  }
> -/**
> - * ufshcd_dme_reset - UIC command for DME_RESET
> - * @hba: per adapter instance
> - *
> - * DME_RESET command is issued in order to reset UniPro stack.
> - * This function now deal with cold reset.
> - *
> - * Returns 0 on success, non-zero value on failure
> - */
> -static int ufshcd_dme_reset(struct ufs_hba *hba)
> -{
> -       struct uic_command uic_cmd = {0};
> -       int ret;
> -
> -       uic_cmd.command = UIC_CMD_DME_RESET;
> -
> -       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> -       if (ret)
> -               dev_err(hba->dev,
> -                       "dme-reset: error code %d\n", ret);
> -
> -       return ret;
> -}
> -
> -/**
> - * ufshcd_dme_enable - UIC command for DME_ENABLE
> - * @hba: per adapter instance
> - *
> - * DME_ENABLE command is issued in order to enable UniPro stack.
> - *
> - * Returns 0 on success, non-zero value on failure
> - */
> -static int ufshcd_dme_enable(struct ufs_hba *hba)
> -{
> -       struct uic_command uic_cmd = {0};
> -       int ret;
> -
> -       uic_cmd.command = UIC_CMD_DME_ENABLE;
> -
> -       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> -       if (ret)
> -               dev_err(hba->dev,
> -                       "dme-reset: error code %d\n", ret);
> -
> -       return ret;
> -}
>
>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
>  {
> @@ -4217,7 +4149,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
>  }
>
>  /**
> - * ufshcd_hba_execute_hce - initialize the controller
> + * ufshcd_hba_enable - initialize the controller
>   * @hba: per adapter instance
>   *
>   * The controller resets itself and controller firmware initialization
> @@ -4226,7 +4158,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> -static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
> +int ufshcd_hba_enable(struct ufs_hba *hba)
>  {
>         int retry;
>
> @@ -4274,32 +4206,6 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>
>         return 0;
>  }
> -
> -int ufshcd_hba_enable(struct ufs_hba *hba)
> -{
> -       int ret;
> -
> -       if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
> -               ufshcd_set_link_off(hba);
> -               ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
> -
> -               /* enable UIC related interrupts */
> -               ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
> -               ret = ufshcd_dme_reset(hba);
> -               if (!ret) {
> -                       ret = ufshcd_dme_enable(hba);
> -                       if (!ret)
> -                               ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
> -                       if (ret)
> -                               dev_err(hba->dev,
> -                                       "Host controller enable failed with non-hce\n");
> -               }
> -       } else {
> -               ret = ufshcd_hba_execute_hce(hba);
> -       }
> -
> -       return ret;
> -}
>  EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
>
>  static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
> @@ -4869,8 +4775,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
>          * false interrupt if device completes another request after resetting
>          * aggregation and before reading the DB.
>          */
> -       if (ufshcd_is_intr_aggr_allowed(hba) &&
> -           !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
> +       if (ufshcd_is_intr_aggr_allowed(hba))
>                 ufshcd_reset_intr_aggr(hba);
>
>         tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 2ae6c7c8528c..9c2b80f87b9f 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -612,28 +612,6 @@ struct ufs_hba {
>          */
>         #define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION             0x20
>
> -       /*
> -        * This quirk needs to be enabled if the host contoller regards
> -        * resolution of the values of PRDTO and PRDTL in UTRD as byte.
> -        */
> -       #define UFSHCD_QUIRK_PRDT_BYTE_GRAN                     0x80
> -
> -       /*
> -        * Clear handling for transfer/task request list is just opposite.
> -        */
> -       #define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR                0x100
> -
> -       /*
> -        * This quirk needs to be enabled if host controller doesn't allow
> -        * that the interrupt aggregation timer and counter are reset by s/w.
> -        */
> -       #define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR               0x200
> -
> -       /*
> -        * This quirks needs to be enabled if host controller cannot be
> -        * enabled via HCE register.
> -        */
> -       #define UFSHCI_QUIRK_BROKEN_HCE                         0x400
>         unsigned int quirks;    /* Deviations from standard UFSHCI spec. */
>
>         /* Device deviations from standard UFS device spec. */
> --
> 2.24.1
>


-- 
Regards,
Alim
