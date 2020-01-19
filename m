Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C685AC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 635F02467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOrV2fpX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgASBkn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 20:40:43 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40594 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgASBkn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 20:40:43 -0500
Received: by mail-vs1-f68.google.com with SMTP id g23so17071008vsr.7;
        Sat, 18 Jan 2020 17:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5YSujy2zuo2t7ilDNZ2a0YT9iwx5kFXgKtt60+YjIHk=;
        b=cOrV2fpXoi+i4OhZo7Tpi4c6LZJofQX8JbSyXKCCGe4sE12Q1Wr1ZiUahdHx/0nS5J
         rWxl3GwFlGWrk7YINIkFxl81cNjFdi92+eaY87k7iXbWwpkeypjzaFuguQ0mF2YzZfAm
         kN2Y1D3B/a2i6MPSm+CDjbJkcU5sVwn4+5yK9xTdb0e+9ALyhPq7+sCTrJtH6uU1JHRX
         j6G8xdDCoY9X0NjWk7AnvUj9/FySLbMqNi+vSyhwzwYIG6fminMJzdWaLWLCbTXjYsug
         NalNOMyvb0BGMYpG9W3UZr5T9RHoH2qqmxtbf1Ua6lWvlwymETenMPuWnfb4z79GtjL8
         nvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5YSujy2zuo2t7ilDNZ2a0YT9iwx5kFXgKtt60+YjIHk=;
        b=TBMXTc7gIHmUBFFWRiIMsxTguLiT5xmSkojvR/JuIWBgPmkTw6LeXEDG5b3gtycj22
         MDe/wtRaZZkD3sBY3fNLLTAK5heU6v2Htu6x2wvHaoTcV4AzKgE7slabYK7S7NtgP3D9
         L8oS5GjWVNhHtDNElHi3yFK+i25iFITtOwG02xYlmDilLKzkqHXK2SievErXtJrZgkme
         lifi26uactMtkztts0CtI++pe08HXK8merws5fHaEn8Cg0LPsra5yPuCSbNDG62DzDTk
         mOSWXFSs5kLjOt6jPvmKhKs1Qztqn/93eO6W+diCJyxqJzusBBnIehk3EdVTUqZNPW38
         NCww==
X-Gm-Message-State: APjAAAXl0kh+R5WfNnGD4ufPl/r+tb/KtOMwaicmqvQj4ikAlqjYNQrO
        Sq/rSrVJtsQApCK5ib2SGn4SR4//1ebMqo2TKcM=
X-Google-Smtp-Source: APXvYqxqZg/5jmQtC8OP2Ix5RuER7MpI7D/SxERp6mCu5x4Yoi6ff6P5O497VlrfaiaCKdalk8qUoLsMxLMpgOs11Zg=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr9169113vsr.136.1579398041696;
 Sat, 18 Jan 2020 17:40:41 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-4-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-4-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:10:05 +0530
Message-ID: <CAGOxZ524szfnoYTCsgShaGoChHub4kHgvTgdAdsCmgFo53x8aw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] scsi: ufs: Split ufshcd_probe_hba() based on its
 called flow
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
> This patch has two major non-functionality changes:
>
> 1. Take scanning host if-statement out from ufshcd_probe_hba(), and
> move into a new added function ufshcd_add_lus().
> In this new function ufshcd_add_lus(), the main functionalitis include:
> ICC initialization, add well-known LUs, devfreq initialization, UFS
> bsg probe and scsi host scan. The reason for this change is that these
> functionalities only being called during booting stage flow
> ufshcd_init()->ufshcd_async_scan(). In the processes of error handling
> and power management ufshcd_suspend(), ufshcd_resume(), ufshcd_probe_hba()
> being called, but these functionalitis above metioned are not hit.
>
> 2. Move context of initialization of parameters associated with the UFS
> device to a new added function ufshcd_init_params().

Since you are moving UFS device initialization related code, this
function can be renamed as
ufshcd_device_params_init() to make it more obvious about the function.
whats your thought on this?

> The reason of this change is that all of these parameters are used by
> driver, but only need to be initialized once when booting. Combine them
> into an integral function, make them easier maintain.
>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 167 +++++++++++++++++++++++---------------
>  1 file changed, 101 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 58ef45b80cb0..54c127ef360b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -246,7 +246,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
>  static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>  static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>  static void ufshcd_hba_exit(struct ufs_hba *hba);
> -static int ufshcd_probe_hba(struct ufs_hba *hba);
> +static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
>  static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>                                  bool skip_ref_clk);
>  static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> @@ -6307,7 +6307,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>                 goto out;
>
>         /* Establish the link again and restore the device */
> -       err = ufshcd_probe_hba(hba);
> +       err = ufshcd_probe_hba(hba, false);
>
>         if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
>                 err = -EIO;
> @@ -6935,13 +6935,83 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>         return err;
>  }
>
> +static int ufshcd_init_params(struct ufs_hba *hba)
> +{
> +       bool flag;
> +       int ret;
> +
> +       /* Init check for device descriptor sizes */
> +       ufshcd_init_desc_sizes(hba);
> +
> +       /* Check and apply UFS device quirks */
> +       ret = ufs_get_device_desc(hba);
> +       if (ret) {
> +               dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
> +                       __func__, ret);
> +               goto out;
> +       }
> +
> +       ufs_fixup_device_setup(hba);
> +
> +       /* Clear any previous UFS device information */
> +       memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> +       if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +                       QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
> +               hba->dev_info.f_power_on_wp_en = flag;
> +
> +out:
> +       return ret;
> +}
> +
> +/**
> + * ufshcd_add_lus - probe and add UFS logical units
> + * @hba: per-adapter instance
> + */
> +static int ufshcd_add_lus(struct ufs_hba *hba)
> +{
> +       int ret;
> +
> +       if (!hba->is_init_prefetch)
> +               ufshcd_init_icc_levels(hba);
> +
> +       /* Add required well known logical units to scsi mid layer */
> +       ret = ufshcd_scsi_add_wlus(hba);
> +       if (ret)
> +               goto out;
> +
> +       /* Initialize devfreq after UFS device is detected */
> +       if (ufshcd_is_clkscaling_supported(hba)) {
> +               memcpy(&hba->clk_scaling.saved_pwr_info.info,
> +                       &hba->pwr_info,
> +                       sizeof(struct ufs_pa_layer_attr));
> +               hba->clk_scaling.saved_pwr_info.is_valid = true;
> +               if (!hba->devfreq) {
> +                       ret = ufshcd_devfreq_init(hba);
> +                       if (ret)
> +                               goto out;
> +               }
> +
> +               hba->clk_scaling.is_allowed = true;
> +       }
> +
> +       ufs_bsg_probe(hba);
> +       scsi_scan_host(hba->host);
> +       pm_runtime_put_sync(hba->dev);
> +
> +       if (!hba->is_init_prefetch)
> +               hba->is_init_prefetch = true;
> +out:
> +       return ret;
> +}
> +
>  /**
>   * ufshcd_probe_hba - probe hba to detect device and initialize
>   * @hba: per-adapter instance
> + * @async: asynchronous execution or not
>   *
>   * Execute link-startup and verify device initialization
>   */
> -static int ufshcd_probe_hba(struct ufs_hba *hba)
> +static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
>  {
>         int ret;
>         ktime_t start = ktime_get();
> @@ -6960,25 +7030,26 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>         /* UniPro link is active now */
>         ufshcd_set_link_active(hba);
>
> +       /* Verify device initialization by sending NOP OUT UPIU */
>         ret = ufshcd_verify_dev_init(hba);
>         if (ret)
>                 goto out;
>
> +       /* Initiate UFS initialization, and waiting until completion */
>         ret = ufshcd_complete_dev_init(hba);
>         if (ret)
>                 goto out;
>
> -       /* Init check for device descriptor sizes */
> -       ufshcd_init_desc_sizes(hba);
> -
> -       ret = ufs_get_device_desc(hba);
> -       if (ret) {
> -               dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
> -                       __func__, ret);
> -               goto out;
> +       /*
> +        * Initialize UFS device parameters used by driver, these
> +        * parameters are associated with UFS descriptors.
> +        */
> +       if (async) {
> +               ret = ufshcd_init_params(hba);
> +               if (ret)
> +                       goto out;
>         }
>
> -       ufs_fixup_device_setup(hba);
>         ufshcd_tune_unipro_params(hba);
>
>         /* UFS device is also active now */
> @@ -7011,60 +7082,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>         /* Enable Auto-Hibernate if configured */
>         ufshcd_auto_hibern8_enable(hba);
>
> -       /*
> -        * If we are in error handling context or in power management callbacks
> -        * context, no need to scan the host
> -        */
> -       if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
> -               bool flag;
> -
> -               /* clear any previous UFS device information */
> -               memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> -               if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> -                               QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
> -                       hba->dev_info.f_power_on_wp_en = flag;
> -
> -               if (!hba->is_init_prefetch)
> -                       ufshcd_init_icc_levels(hba);
> -
> -               /* Add required well known logical units to scsi mid layer */
> -               ret = ufshcd_scsi_add_wlus(hba);
> -               if (ret)
> -                       goto out;
> -
> -               /* Initialize devfreq after UFS device is detected */
> -               if (ufshcd_is_clkscaling_supported(hba)) {
> -                       memcpy(&hba->clk_scaling.saved_pwr_info.info,
> -                               &hba->pwr_info,
> -                               sizeof(struct ufs_pa_layer_attr));
> -                       hba->clk_scaling.saved_pwr_info.is_valid = true;
> -                       if (!hba->devfreq) {
> -                               ret = ufshcd_devfreq_init(hba);
> -                               if (ret)
> -                                       goto out;
> -                       }
> -                       hba->clk_scaling.is_allowed = true;
> -               }
> -
> -               ufs_bsg_probe(hba);
> -
> -               scsi_scan_host(hba->host);
> -               pm_runtime_put_sync(hba->dev);
> -       }
> -
> -       if (!hba->is_init_prefetch)
> -               hba->is_init_prefetch = true;
> -
>  out:
> -       /*
> -        * If we failed to initialize the device or the device is not
> -        * present, turn off the power/clocks etc.
> -        */
> -       if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
> -               pm_runtime_put_sync(hba->dev);
> -               ufshcd_exit_clk_scaling(hba);
> -               ufshcd_hba_exit(hba);
> -       }
>
>         trace_ufshcd_init(dev_name(hba->dev), ret,
>                 ktime_to_us(ktime_sub(ktime_get(), start)),
> @@ -7080,8 +7098,25 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  {
>         struct ufs_hba *hba = (struct ufs_hba *)data;
> +       int ret;
>
> -       ufshcd_probe_hba(hba);
> +       /* Initialize hba, detect and initialize UFS device */
> +       ret = ufshcd_probe_hba(hba, true);
> +       if (ret)
> +               goto out;
> +
> +       /* Probe and add UFS logical units  */
> +       ret = ufshcd_add_lus(hba);
> +out:
> +       /*
> +        * If we failed to initialize the device or the device is not
> +        * present, turn off the power/clocks etc.
> +        */
> +       if (ret) {
> +               pm_runtime_put_sync(hba->dev);
> +               ufshcd_exit_clk_scaling(hba);
> +               ufshcd_hba_exit(hba);
> +       }
>  }
>
>  static const struct attribute_group *ufshcd_driver_groups[] = {
> --
> 2.17.1
>


-- 
Regards,
Alim
