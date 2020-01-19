Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC686C33CB6
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A950A246B0
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZpcVJEC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgASBfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 20:35:47 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:43364 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgASBfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 20:35:47 -0500
Received: by mail-vk1-f195.google.com with SMTP id h13so7687300vkn.10;
        Sat, 18 Jan 2020 17:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjCtzKiE6H2KfLbQf0zSMWNoP6QcnMK49AjhSMpc7Gk=;
        b=jZpcVJECTMtkiryx5cMOJoRYXEiPURtxNb3Mi+QPn/ShAu4PspFQz868LUYEMVic+a
         jXL/xc2uEEhPMH2JVSv8ebAGqW7slwTc8Zs4Zx49rUZYM/PqfJRGjZOooMDXp1c4ocUK
         VIUnVYZVkAsYHLDn+nelXDGotrNxmfSbEQfn0DsDj37G4d/8pOp5tOouUKNe9hI/QQWB
         JA9OXqYh5/ZF5QeXx5TcsfmC8tC7201w7TLDSLh67eeqrabWAUS1oFRk0i5h0NxpKjsx
         lZ1o5hKsyZz5PcDnww7K34nsruV4QpgfH2G62o85e4sdQhiaGTNC3zRKLkx4GXftC6U5
         Uk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjCtzKiE6H2KfLbQf0zSMWNoP6QcnMK49AjhSMpc7Gk=;
        b=cfU6VqjQLHmOi7G6RtEFW2GSD2npvdBKWOkx5YbWe+OlfoM8m1xgYEVYXiCAfBmf90
         dOO1JswlmjJI8XzbZwibMxPAX4dWG3etZoKAALZ5AzsMvQWLpk0n8X7CgCqHeYZBxvs4
         QFlRjJNgJsNQMRJo4QzCZIJPgNu4tbuKc1zwtFVrShwA6l0gAa+unhpPvrfN5LK/UzwK
         vaxErhXvEB39CuTOVpSGk6AXEVJ8FBJEFt0udfrsWgUlPf97dIl45gUnIKR/4FGFRI99
         wViHsHIzM47BxAmly0bdxflz+Jw4rnqWbZcANqS1SAttRMmzl5G+8lQ4DLU839ARReFp
         0g7g==
X-Gm-Message-State: APjAAAUluBs9Qsdp4ci+lNymIDRUNg4BG3DoPbVakoVEww2d0R8ycwdY
        6cxs5vR32VJKkD06Ktr9qy5piaJtsI7R/y1VHLU=
X-Google-Smtp-Source: APXvYqzufgSuJM08ZEV1+xvWQOUXFWucwmmVn5JGEVWxQgauyxoqGfdPz/hNAkrr26blXkT9FwS+i5F/hLSd9/o7rDM=
X-Received: by 2002:a1f:8f44:: with SMTP id r65mr6443705vkd.8.1579397745427;
 Sat, 18 Jan 2020 17:35:45 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-3-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-3-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:05:09 +0530
Message-ID: <CAGOxZ52AqtLW58wqtZj+RNGSAaE5f8ue4MSNgfzDEpznYH5+kw@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] scsi: ufs: Delete struct ufs_dev_desc
To:     Bean Huo <huobean@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, asutoshd@codeaurora.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

On Sun, Jan 19, 2020 at 5:44 AM Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> In consideration of UFS host driver uses parameters of struct
> ufs_dev_desc, move its parameters to struct ufs_dev_info,
> delete struct ufs_dev_desc.
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-mediatek.c |  7 ++---
>  drivers/scsi/ufs/ufs-qcom.c     |  6 ++---
>  drivers/scsi/ufs/ufs.h          | 11 +-------
>  drivers/scsi/ufs/ufs_quirks.h   |  9 ++++---
>  drivers/scsi/ufs/ufshcd.c       | 47 +++++++++++++++------------------
>  drivers/scsi/ufs/ufshcd.h       |  7 +++--
>  6 files changed, 38 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 8d999c0e60fe..f8dd992b6f3a 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -406,10 +406,11 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>         return 0;
>  }
>
> -static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba,
> -                                   struct ufs_dev_desc *card)
> +static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
>  {
> -       if (card->wmanufacturerid == UFS_VENDOR_SAMSUNG)
> +       struct ufs_dev_info *dev_info = hba->dev_info;
> +
> +       if (dev_info->wmanufacturerid == UFS_VENDOR_SAMSUNG)
>                 ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
>
>         return 0;
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index ebb5c66e069f..9c6a182b3ed9 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -949,12 +949,12 @@ static int ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
>         return err;
>  }
>
> -static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba,
> -                                    struct ufs_dev_desc *card)
> +static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba)
>  {
>         int err = 0;
> +       struct ufs_dev_info *dev_info = hba->dev_info;
>
> -       if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
> +       if (dev_info->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
>                 err = ufs_qcom_quirk_host_pa_saveconfigtime(hba);
>
>         return err;
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index c89f21698629..fcc9b4d4e56f 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -530,17 +530,8 @@ struct ufs_dev_info {
>         bool f_power_on_wp_en;
>         /* Keeps information if any of the LU is power on write protected */
>         bool is_lu_power_on_wp;
> -};
> -
> -#define MAX_MODEL_LEN 16
> -/**
> - * ufs_dev_desc - ufs device details from the device descriptor
> - *
> - * @wmanufacturerid: card details
> - * @model: card model
> - */
> -struct ufs_dev_desc {
>         u16 wmanufacturerid;
> +       /*UFS device Product Name */
>         u8 *model;
>  };
>
> diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
> index fe6cad9b2a0d..d0ab147f98d3 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -22,16 +22,17 @@
>   * @quirk: device quirk
>   */
>  struct ufs_dev_fix {
> -       struct ufs_dev_desc card;
> +       u16 wmanufacturerid;
> +       u8 *model;
>         unsigned int quirk;
>  };
>
> -#define END_FIX { { 0 }, 0 }
> +#define END_FIX { }
>
>  /* add specific device quirk */
>  #define UFS_FIX(_vendor, _model, _quirk) { \
> -       .card.wmanufacturerid = (_vendor),\
> -       .card.model = (_model),            \
> +       .wmanufacturerid = (_vendor),\
> +       .model = (_model),                 \
>         .quirk = (_quirk),                 \
>  }
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9a9085a7bcc5..58ef45b80cb0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6583,16 +6583,13 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>         return ret;
>  }
>
> -static int ufs_get_device_desc(struct ufs_hba *hba,
> -                              struct ufs_dev_desc *dev_desc)
> +static int ufs_get_device_desc(struct ufs_hba *hba)
>  {
>         int err;
>         size_t buff_len;
>         u8 model_index;
>         u8 *desc_buf;
> -
> -       if (!dev_desc)
> -               return -EINVAL;
> +       struct ufs_dev_info *dev_info = &hba->dev_info;
>
>         buff_len = max_t(size_t, hba->desc_size.dev_desc,
>                          QUERY_DESC_MAX_SIZE + 1);
> @@ -6613,12 +6610,12 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
>          * getting vendor (manufacturerID) and Bank Index in big endian
>          * format
>          */
> -       dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
> +       dev_info->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
>                                      desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
>
>         model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>         err = ufshcd_read_string_desc(hba, model_index,
> -                                     &dev_desc->model, SD_ASCII_STD);
> +                                     &dev_info->model, SD_ASCII_STD);
>         if (err < 0) {
>                 dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
>                         __func__, err);
> @@ -6636,23 +6633,25 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
>         return err;
>  }
>
> -static void ufs_put_device_desc(struct ufs_dev_desc *dev_desc)
> +static void ufs_put_device_desc(struct ufs_hba *hba)
>  {
> -       kfree(dev_desc->model);
> -       dev_desc->model = NULL;
> +       struct ufs_dev_info *dev_info = &hba->dev_info;
> +
> +       kfree(dev_info->model);
> +       dev_info->model = NULL;
>  }
>
> -static void ufs_fixup_device_setup(struct ufs_hba *hba,
> -                                  struct ufs_dev_desc *dev_desc)
> +static void ufs_fixup_device_setup(struct ufs_hba *hba)
>  {
>         struct ufs_dev_fix *f;
> +       struct ufs_dev_info *dev_info = &hba->dev_info;
>
>         for (f = ufs_fixups; f->quirk; f++) {
> -               if ((f->card.wmanufacturerid == dev_desc->wmanufacturerid ||
> -                    f->card.wmanufacturerid == UFS_ANY_VENDOR) &&
> -                    ((dev_desc->model &&
> -                      STR_PRFX_EQUAL(f->card.model, dev_desc->model)) ||
> -                     !strcmp(f->card.model, UFS_ANY_MODEL)))
> +               if ((f->wmanufacturerid == dev_info->wmanufacturerid ||
> +                    f->wmanufacturerid == UFS_ANY_VENDOR) &&
> +                    ((dev_info->model &&
> +                      STR_PRFX_EQUAL(f->model, dev_info->model)) ||
> +                     !strcmp(f->model, UFS_ANY_MODEL)))
>                         hba->dev_quirks |= f->quirk;
>         }
>  }
> @@ -6804,8 +6803,7 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
>         return ret;
>  }
>
> -static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
> -                                     struct ufs_dev_desc *card)
> +static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
>  {
>         if (ufshcd_is_unipro_pa_params_tuning_req(hba)) {
>                 ufshcd_tune_pa_tactivate(hba);
> @@ -6819,7 +6817,7 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba,
>         if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
>                 ufshcd_quirk_tune_host_pa_tactivate(hba);
>
> -       ufshcd_vops_apply_dev_quirks(hba, card);
> +       ufshcd_vops_apply_dev_quirks(hba);
>  }
>
>  static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
> @@ -6945,7 +6943,6 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>   */
>  static int ufshcd_probe_hba(struct ufs_hba *hba)
>  {
> -       struct ufs_dev_desc card = {0};
>         int ret;
>         ktime_t start = ktime_get();
>
> @@ -6974,16 +6971,15 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>         /* Init check for device descriptor sizes */
>         ufshcd_init_desc_sizes(hba);
>
> -       ret = ufs_get_device_desc(hba, &card);
> +       ret = ufs_get_device_desc(hba);
>         if (ret) {
>                 dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
>                         __func__, ret);
>                 goto out;
>         }
>
> -       ufs_fixup_device_setup(hba, &card);
> -       ufshcd_tune_unipro_params(hba, &card);
> -       ufs_put_device_desc(&card);
> +       ufs_fixup_device_setup(hba);
> +       ufshcd_tune_unipro_params(hba);
>
>         /* UFS device is also active now */
>         ufshcd_set_ufs_dev_active(hba);
> @@ -7544,6 +7540,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>                 ufshcd_setup_clocks(hba, false);
>                 ufshcd_setup_hba_vreg(hba, false);
>                 hba->is_powered = false;
> +               ufs_put_device_desc(hba);
>         }
>  }
>
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b1a1c65be8b1..32b6714f25a5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -320,7 +320,7 @@ struct ufs_hba_variant_ops {
>         void    (*setup_task_mgmt)(struct ufs_hba *, int, u8);
>         void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
>                                         enum ufs_notify_change_status);
> -       int     (*apply_dev_quirks)(struct ufs_hba *, struct ufs_dev_desc *);
> +       int     (*apply_dev_quirks)(struct ufs_hba *hba);
>         int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>         int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>         void    (*dbg_register_dump)(struct ufs_hba *hba);
> @@ -1054,11 +1054,10 @@ static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
>                 return hba->vops->hibern8_notify(hba, cmd, status);
>  }
>
> -static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba,
> -                                              struct ufs_dev_desc *card)
> +static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
>  {
>         if (hba->vops && hba->vops->apply_dev_quirks)
> -               return hba->vops->apply_dev_quirks(hba, card);
> +               return hba->vops->apply_dev_quirks(hba);
>         return 0;
>  }
>
> --
> 2.17.1
>


-- 
Regards,
Alim
