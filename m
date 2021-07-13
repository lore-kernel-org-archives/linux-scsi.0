Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDE5C07E96
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 10:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A907D6128D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 10:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhGMLA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 07:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235390AbhGMLA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 07:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C975D6128D;
        Tue, 13 Jul 2021 10:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626173888;
        bh=7JuPwhmNbwEYzozWmUB3DitVXS4qkMiFn1WMLdcXqoQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m0iSIqjdFz0efD8dvFe+rkkTFRJ1b0Wo8LSd0keFiBs5aNCuJAppbdYGtdtabY2zN
         ik5iFsrn32LPU9Lo/iWmUioXpnzpBB62OT/FmSkhuZVo9i26LpoNkgPDRtRsWQiElK
         BvOozQ9yMPoginQDJFmxGxWE0WqSWt2L92C1KPwdasldqoFe+JnhuHbODIK+HCrH3t
         fMtSwZf4tGJpeO/8Lnrexr4eKNBxkOHTn4iZ67x8rYkcLPKe2oG8jOv3OmWkWpXp3f
         MZbovqBcaUWXFOwOXVBctIheDRnvdMfL0WUD5A55SoM/BDzHkcp1q5X742wJGaIv8m
         ThFH8V4S3Sqfw==
Received: by mail-pf1-f170.google.com with SMTP id p22so6266107pfh.8;
        Tue, 13 Jul 2021 03:58:08 -0700 (PDT)
X-Gm-Message-State: AOAM5316nn3u5vg9Npec86s5l9X+tu9/5heVQQY+zi+FHzEUH024dbjB
        SABCW/LS+OVbH6LW1Eq5FJG1XVaWFVxkLzNPIis=
X-Google-Smtp-Source: ABdhPJwyn9I52CiGukDfHzKnYSo1q/6i0lNmV5zrFBWwgNq78UvZXcPiabAaN0KF1Aq9iMpgZ87RAeohtEzAXFVxQgA=
X-Received: by 2002:a63:2313:: with SMTP id j19mr3727182pgj.42.1626173888408;
 Tue, 13 Jul 2021 03:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79@epcas2p4.samsung.com>
 <20210709065711.25195-1-chanho61.park@samsung.com> <20210709065711.25195-14-chanho61.park@samsung.com>
In-Reply-To: <20210709065711.25195-14-chanho61.park@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 13 Jul 2021 12:57:56 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfJOGz7WhCk4HPtDh0=13gy0q=r5isLNkKz+yetAshAfw@mail.gmail.com>
Message-ID: <CAJKOXPfJOGz7WhCk4HPtDh0=13gy0q=r5isLNkKz+yetAshAfw@mail.gmail.com>
Subject: Re: [PATCH 13/15] scsi: ufs: ufs-exynos: support exynosauto v9 ufs driver
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-On Fri, 9 Jul 2021 at 08:59, Chanho Park <chanho61.park@samsung.com> wrote:
>
> This patch adds to support ufs variant for ExynosAuto v9 SoC. This
> requires control UFS IP sharability register via syscon and regmap.
> Regarding uic_attr, most of values can be shared with exynos7 except
> tx_dif_p_nsec value.
>
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-exynos.c | 97 +++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 9669afe8f1f4..82f915f7a447 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -15,6 +15,7 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> +#include <linux/regmap.h>
>
>  #include "ufshcd.h"
>  #include "ufshcd-pltfrm.h"
> @@ -76,6 +77,12 @@
>                                  UIC_TRANSPORT_NO_CONNECTION_RX |\
>                                  UIC_TRANSPORT_BAD_TC)
>
> +/* FSYS UFS Sharability */

Sharability -> Shareability

> +#define UFS_WR_SHARABLE                BIT(2)
> +#define UFS_RD_SHARABLE                BIT(1)
> +#define UFS_SHARABLE           (UFS_WR_SHARABLE | UFS_RD_SHARABLE)
> +#define UFS_SHARABILITY_OFFSET 0x710
> +
>  enum {
>         UNIPRO_L1_5 = 0,/* PHY Adapter */
>         UNIPRO_L2,      /* Data Link */
> @@ -151,6 +158,80 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
>         return 0;
>  }
>
> +static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
> +{
> +       struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
> +
> +       /* IO Coherency setting */
> +       if (ufs->sysreg) {
> +               return regmap_update_bits(ufs->sysreg, UFS_SHARABILITY_OFFSET,
> +                                         UFS_SHARABLE, UFS_SHARABLE);
> +       }
> +
> +       attr->tx_dif_p_nsec = 3200000;
> +
> +       return 0;
> +}
> +
> +static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
> +{
> +       struct ufs_hba *hba = ufs->hba;
> +       int i;
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x40);
> +       for_each_ufs_rx_lane(ufs, i) {
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, i),
> +                              DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, i), 0x0);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, i), 0x79);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x84, i), 0x1);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, i), 0xf6);
> +       }
> +
> +       for_each_ufs_tx_lane(ufs, i) {
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, i),
> +                              DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, i), 0x02);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, i), 0x8);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, i), 0x22);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, i), 0x8);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x04, i), 0x1);
> +       }
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x0);
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0);
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xa011), 0x8000);
> +
> +       return 0;
> +}
> +
> +static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
> +                                        struct ufs_pa_layer_attr *pwr)
> +{
> +       struct ufs_hba *hba = ufs->hba;
> +
> +       /* PACP_PWR_req and delivered to the remote DME */
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 12000);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 32000);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 16000);
> +
> +       return 0;
> +}
> +

No need for double line.

> +
>  static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
>  {
>         struct ufs_hba *hba = ufs->hba;
> @@ -1305,6 +1386,20 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
>         .pa_dbg_option_suite            = 0x30103,
>  };
>
> +static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
> +       .uic_attr               = &exynos7_uic_attr,
> +       .quirks                 = UFSHCD_QUIRK_PRDT_BYTE_GRAN |
> +                                 UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
> +                                 UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
> +                                 UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
> +       .opts                   = EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
> +                                 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
> +                                 EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> +       .drv_init               = exynosauto_ufs_drv_init,
> +       .pre_link               = exynosauto_ufs_pre_link,
> +       .pre_pwr_change         = exynosauto_ufs_pre_pwr_change,
> +};
> +
>  static struct exynos_ufs_drv_data exynos_ufs_drvs = {
>         .uic_attr               = &exynos7_uic_attr,
>         .quirks                 = UFSHCD_QUIRK_PRDT_BYTE_GRAN |
> @@ -1330,6 +1425,8 @@ static struct exynos_ufs_drv_data exynos_ufs_drvs = {
>  static const struct of_device_id exynos_ufs_of_match[] = {
>         { .compatible = "samsung,exynos7-ufs",
>           .data       = &exynos_ufs_drvs },
> +       { .compatible = "samsung,exynosautov9-ufs",
> +         .data       = &exynosauto_ufs_drvs },

This compatible is not documented. It seems that no one document
exynos7-ufs but that's not an excuse. :)

Best regards,
Krzysztof
