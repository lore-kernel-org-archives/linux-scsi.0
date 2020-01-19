Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48120C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 02:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6CE246B5
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 02:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NuHOjd7j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgASCIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 21:08:21 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37214 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgASCIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 21:08:20 -0500
Received: by mail-vs1-f67.google.com with SMTP id x18so17083944vsq.4;
        Sat, 18 Jan 2020 18:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQ+1APHbFNKB143+sO59fLKK+w2945ZFYvD9Iav9Dtk=;
        b=NuHOjd7jwhOszfbdWOMQ+xmm+OJ6YbgqxVXHC/0pXwCkUbXNTM5bytx6GQSRZeQwfN
         itX95yjELoxZeTc9mNxxOJ9YhdwE6WfuXQZBH1hBFWht5QlTN4U3Y7bcbbDORrCg9hvf
         Og407w9p+WbPUIAAb0PxIhhT6IbCaNXBGXvMel/JyYOAK1czZLQoNNnSmvjTGr/DaHMb
         gcQJ9JKXnqXVMwS8ahjYzM5SFpx/BQsLVUhqMyfOmLZVvao5aYcYNudEwKl3sWgUrJTJ
         zrrusySCB8KEGpnsoc1CiGSs71KCqzOXgKslM4dQZSbUcGevxLtrkRRJF/00tFH9bZHH
         A/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQ+1APHbFNKB143+sO59fLKK+w2945ZFYvD9Iav9Dtk=;
        b=thlKkGZ6gO403xKUG7wG0Kly7jZNkYMVzkApL8Mnfqq30MLztZ+irWA78973iIo+ZM
         lYdna6X/GL57WOv7vS4SNrOyfS+jaFbiYwJgnw/jgXoraUmUfZEvc/rBB+ATd/2liSYl
         B7V7HpDohvXzbTrVzaxJYKraWe+nLh3XaV3N+EQddkZv4dRU/+7fLo06KpIoFVOHl26g
         an+yO5en5hNTotwb2Y8zxSqm7boRMr3f/33NMOht65nLIO2rW16lW/54HM9MDQISinXd
         fU/QGQoSa3ip8nNesOkbtceNsq4m7TKvifyMA+OQIzo7RfseHRL6pJFSGsCQYED0rIhb
         mDSA==
X-Gm-Message-State: APjAAAXkpuZNBDBKXPuVCjgbqY4+kR75EtBJ1RyUuGuJVHgQn/G4amLr
        a4Pqc7EuxcSAeL5igZdFDgAUIIxIUmgEL16fAkt1IDRYb/w=
X-Google-Smtp-Source: APXvYqymyBuxrOXAKX9NFQWTYDBqP/WQWLdZEsOztWSP9xkhb8gGyvcwg84YTQlsTwHj5AhMFFSzUXP/EXTHy8i7LX4=
X-Received: by 2002:a67:e204:: with SMTP id g4mr9216274vsa.176.1579399699177;
 Sat, 18 Jan 2020 18:08:19 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-8-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-8-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:37:43 +0530
Message-ID: <CAGOxZ50VQs+oXmSDFAtsmJYACPszdnJOr2b0vQXmjBH2VWTtWQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] scsi: ufs: Add max_lu_supported in struct ufs_dev_info
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

On Sun, Jan 19, 2020 at 5:45 AM Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> Add one new parameter max_lu_supported in struct ufs_dev_info,
> which will be used to express exactly how many general LUs being
> supported by UFS device, and initialize it during booting stage.
> This patch also adds a new function ufshcd_init_device_geo_params()
> for initialization of UFS device geometry descriptor related parameters.
>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs.h    |  2 ++
>  drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 41 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index fcc9b4d4e56f..c982bcc94662 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -530,6 +530,8 @@ struct ufs_dev_info {
>         bool f_power_on_wp_en;
>         /* Keeps information if any of the LU is power on write protected */
>         bool is_lu_power_on_wp;
> +       /* Maximum number of general LU supported by the UFS device */
> +       u8 max_lu_supported;
>         u16 wmanufacturerid;
>         /*UFS device Product Name */
>         u8 *model;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4f8fcbb5f92e..dd10558f4d01 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6858,6 +6858,37 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
>                 hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>  }
>
> +static int ufshcd_init_device_geo_params(struct ufs_hba *hba)
> +{
> +       int err;
> +       size_t buff_len;
> +       u8 *desc_buf;
> +
> +       buff_len = hba->desc_size.geom_desc;
> +       desc_buf = kmalloc(buff_len, GFP_KERNEL);
> +       if (!desc_buf) {
> +               err = -ENOMEM;
> +               goto out;
> +       }
> +
> +       err = ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0,
> +                       desc_buf, buff_len);
> +       if (err) {
> +               dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
> +                               __func__, err);
> +               goto out;
> +       }
> +
> +       if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 1)
> +               hba->dev_info.max_lu_supported = 32;
> +       else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
> +               hba->dev_info.max_lu_supported = 8;
> +
> +out:
> +       kfree(desc_buf);
> +       return err;
> +}
> +
>  static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
>         {19200000, REF_CLK_FREQ_19_2_MHZ},
>         {26000000, REF_CLK_FREQ_26_MHZ},
> @@ -6931,9 +6962,17 @@ static int ufshcd_init_params(struct ufs_hba *hba)
>         bool flag;
>         int ret;
>
> +       /* Clear any previous UFS device information */
> +       memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> +
>         /* Init check for device descriptor sizes */
>         ufshcd_init_desc_sizes(hba);
>
> +       /* Init UFS geometry descriptor related parameters */
> +       ret = ufshcd_init_device_geo_params(hba);
> +       if (ret)
> +               goto out;
> +
>         /* Check and apply UFS device quirks */
>         ret = ufs_get_device_desc(hba);
>         if (ret) {
> @@ -6944,8 +6983,6 @@ static int ufshcd_init_params(struct ufs_hba *hba)
>
>         ufs_fixup_device_setup(hba);
>
> -       /* Clear any previous UFS device information */
> -       memset(&hba->dev_info, 0, sizeof(hba->dev_info));
>         if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
>                         QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>                 hba->dev_info.f_power_on_wp_en = flag;
> --
> 2.17.1
>


--
Regards,
Alim
