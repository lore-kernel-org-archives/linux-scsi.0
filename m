Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F153FC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 16:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C050A20659
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 16:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LBejGigu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfKTQVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:21:32 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:42256 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfKTQVc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 11:21:32 -0500
Received: by mail-io1-f65.google.com with SMTP id k13so28264030ioa.9;
        Wed, 20 Nov 2019 08:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/a8KPIH+AXDi1yxdHgT07/LliAS9enq80vIfL27WA4=;
        b=LBejGigugoMNm8Bg16W2oMRPNSmrXZGpXzIzgxYcuViBXYZQIBlg7Vj01asCexzJk4
         L8x/nAmdRKmBsMhbJ35Jv2UmjU78PJKlBBAOh8dQS8PepWQxmCVA1QSW/7ox/Ox4+wMm
         Wks4HXHEDIWzvMLQsbk3GSJW3SBzCWMo0ATZzUFCzT4PdLxOyMUarPICEeiKAHprVAKP
         j7td40vxoVpICWloLCTa4RlRlchnfNWcjFuRpIioNJptUTciaSOwBXiSsH6hYfYSzGae
         vzXZ+z9hmEDWwX5CEMdDEQTEbdh5IHI/GNiVMTBvYpUNV+Xt+ouWO0HmrFK9UB7z4MMv
         j0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/a8KPIH+AXDi1yxdHgT07/LliAS9enq80vIfL27WA4=;
        b=SbmnUphGEiozHZoYqUOj27qJg1AB1TUMhAoxzowxplnTJKU5HktHHAHLfd7K56dQDS
         yUvtrpZiur7eR3qbl5v1JHOJT+1ZHIi0oVKda1YtMSxNihffwRYVtWbPMg0QfyV7G31R
         IxHr00F215fkcDk+5C2fy8maBfOy9Q041P5vrH+aKzwheAb/U7rjQbTCYsQ0l1S54lK+
         6V2yyuMqya1QD3Uyt0aYQs/FzSJmQ5liO/6qF9uhns1scJqQi80K3SuuDRsKoBwvJjrg
         xMPBQEmbAhZi+DftXo0O59kIJTWX19lRHQaqcOCSj4HJfbLQhlBz4V/gQTMRwSGiBfIy
         sT+A==
X-Gm-Message-State: APjAAAX0Xn4nfEC+mNc5RzpXddtxxl9HD51NC97Y2xrNmzC67LJMzqRO
        QUsguuSaQem7uUv2dBT2wdEjyEsU8fwBNY2iqws6Njp2
X-Google-Smtp-Source: APXvYqwdl0dqh1yZB3bwi+8z4vWgf/5IfIlpYDRGN3WgEiehlF8vpTZooZGzrx+rsLoNYaaVq8NE8e+Ki+07/o/UbTg=
X-Received: by 2002:a02:a810:: with SMTP id f16mr3917078jaj.73.1574266890514;
 Wed, 20 Nov 2019 08:21:30 -0800 (PST)
MIME-Version: 1.0
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com> <1574147082-22725-3-git-send-email-sheebab@cadence.com>
In-Reply-To: <1574147082-22725-3-git-send-email-sheebab@cadence.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 20 Nov 2019 21:50:53 +0530
Message-ID: <CAGOxZ53Lotp6sBUryHsE2S1dbkQNZhPhWNMXidoi=BOmV074VA@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
To:     sheebab <sheebab@cadence.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>, yuehaibing@huawei.com,
        linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, rafalc@cadence.com, mparab@cadence.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sheebab

On Tue, Nov 19, 2019 at 12:38 PM sheebab <sheebab@cadence.com> wrote:
>
> Backup L4 attributes duirng manual hibern8 entry
> and restore the L4 attributes on manual hibern8 exit as per JESD220C.
>
Can you point me to the relevant section on the spec?

> Signed-off-by: sheebab <sheebab@cadence.com>
> ---
>  drivers/scsi/ufs/cdns-pltfrm.c | 97 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 95 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index adbbd60..5510567 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -19,6 +19,14 @@
>
>  #define CDNS_UFS_REG_HCLKDIV   0xFC
>  #define CDNS_UFS_REG_PHY_XCFGD1        0x113C
> +#define CDNS_UFS_MAX 12
> +
> +struct cdns_ufs_host {
> +       /**
> +        * cdns_ufs_dme_attr_val - for storing L4 attributes
> +        */
> +       u32 cdns_ufs_dme_attr_val[CDNS_UFS_MAX];
> +};
>
>  /**
>   * cdns_ufs_enable_intr - enable interrupts
> @@ -47,6 +55,77 @@ static void cdns_ufs_disable_intr(struct ufs_hba *hba, u32 intrs)
>  }
>
>  /**
> + * cdns_ufs_get_l4_attr - get L4 attributes on local side
> + * @hba: per adapter instance
> + *
> + */
> +static void cdns_ufs_get_l4_attr(struct ufs_hba *hba)
> +{
> +       struct cdns_ufs_host *host = ufshcd_get_variant(hba);
> +
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> +                      &host->cdns_ufs_dme_attr_val[0]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERCPORTID),
> +                      &host->cdns_ufs_dme_attr_val[1]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> +                      &host->cdns_ufs_dme_attr_val[2]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PROTOCOLID),
> +                      &host->cdns_ufs_dme_attr_val[3]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> +                      &host->cdns_ufs_dme_attr_val[4]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> +                      &host->cdns_ufs_dme_attr_val[5]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> +                      &host->cdns_ufs_dme_attr_val[6]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> +                      &host->cdns_ufs_dme_attr_val[7]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> +                      &host->cdns_ufs_dme_attr_val[8]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> +                      &host->cdns_ufs_dme_attr_val[9]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTMODE),
> +                      &host->cdns_ufs_dme_attr_val[10]);
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> +                      &host->cdns_ufs_dme_attr_val[11]);
> +}
> +
> +/**
> + * cdns_ufs_set_l4_attr - set L4 attributes on local side
> + * @hba: per adapter instance
> + *
> + */
> +static void cdns_ufs_set_l4_attr(struct ufs_hba *hba)
> +{
> +       struct cdns_ufs_host *host = ufshcd_get_variant(hba);
> +
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> +                      host->cdns_ufs_dme_attr_val[0]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
> +                      host->cdns_ufs_dme_attr_val[1]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> +                      host->cdns_ufs_dme_attr_val[2]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PROTOCOLID),
> +                      host->cdns_ufs_dme_attr_val[3]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> +                      host->cdns_ufs_dme_attr_val[4]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> +                      host->cdns_ufs_dme_attr_val[5]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> +                      host->cdns_ufs_dme_attr_val[6]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> +                      host->cdns_ufs_dme_attr_val[7]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> +                      host->cdns_ufs_dme_attr_val[8]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> +                      host->cdns_ufs_dme_attr_val[9]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE),
> +                      host->cdns_ufs_dme_attr_val[10]);
> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> +                      host->cdns_ufs_dme_attr_val[11]);
> +}
> +
> +/**
>   * Sets HCLKDIV register value based on the core_clk
>   * @hba: host controller instance
>   *
> @@ -134,6 +213,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
>                  * before manual hibernate entry.
>                  */
>                 cdns_ufs_enable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
> +               cdns_ufs_get_l4_attr(hba);
>         }
>         if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT) {
>                 /**
> @@ -141,6 +221,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
>                  * after manual hibern8 exit.
>                  */
>                 cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
> +               cdns_ufs_set_l4_attr(hba);
>         }
>  }
>
> @@ -245,15 +326,27 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
>         const struct of_device_id *of_id;
>         struct ufs_hba_variant_ops *vops;
>         struct device *dev = &pdev->dev;
> +       struct cdns_ufs_host *host;
> +       struct ufs_hba *hba;
>
>         of_id = of_match_node(cdns_ufs_of_match, dev->of_node);
>         vops = (struct ufs_hba_variant_ops *)of_id->data;
>
>         /* Perform generic probe */
>         err = ufshcd_pltfrm_init(pdev, vops);
> -       if (err)
> +       if (err) {
>                 dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> -
> +               goto out;
> +       }
> +       host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +       if (!host) {
> +               err = -ENOMEM;
> +               dev_err(dev, "%s: no memory for cdns host\n", __func__);
> +               goto out;
> +       }
> +       hba =  platform_get_drvdata(pdev);
> +       ufshcd_set_variant(hba, host);
> +out:
>         return err;
>  }
>
> --
> 2.7.4
>


-- 
Regards,
Alim
