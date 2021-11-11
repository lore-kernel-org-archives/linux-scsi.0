Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70804C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 17:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461D661390
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 17:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhKKRD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 12:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKKRDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 12:03:24 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A3CC061766
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 09:00:34 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id k22so7675473iol.13
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 09:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fu5O0u80ylrE0u3Do5JNvTkSvjHrbbWQiBH5btVlTuk=;
        b=XYRZp40SXjiv7ETDO/9DrIQxjarqTdBUeSFxzj9dMgtMxXLLQc7QZ7WFGBDM8V1Ykk
         go9NxC2+gGJjH/R3wwRVsclQ0xeCiz2C/nBLvY8Pe7X6f5g0HCjCMi6RQwgrIpsMsgmX
         WQe3v22hUTtF9CeZ96WHRAe6RLrXWZfAWuZMMedATa0EHPIJfbic1Lt7pn1AsCDqcdrY
         PjX5m1n7M4mMwUSKXjDvEwt68HgCG91EIZ0IQAeGAsWfvmTRDK7EvfrNOlVBokqkh6ER
         aYm6hfPbJY5+TcsoWdNAB9kSRUv9sf3+prQgmeDuUlRNjDfMuIIp5S+ajoarm4tOPqI/
         RMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fu5O0u80ylrE0u3Do5JNvTkSvjHrbbWQiBH5btVlTuk=;
        b=32jk35GNSG6Ph7+PwZBWTb+z2Oq7sHlI7UOPRUtHhQiIOtuLiTvVS0KwYk/1FLhdU4
         PM1B/7FKFeXaUfugApISJ1LHZmBv6GfgHA4noOfF0bMKUTg6JAtFTSnH22LvJZirTTyt
         789g9/fL+qthrwwanr91/pcrELKL73DDaTxozajFkh+ouP1LXK0YmAbU1KvFumrX3zt1
         wB81LIGq5tIK71qsk6ExaOqY+6AOVxAi8eSSaECKjwi9GbOFWT4Zxv7C5+8M6PHxaxH4
         NdSYyPMbKm8KF1yt0rSRKkcwRWbRdqFbmqGbYmUPQh+CBZkn6yiFvNolJOYzSGUsuR7r
         bfRw==
X-Gm-Message-State: AOAM530ZjRw7XQpZSHmPh9T8wXjY6cYMCYD5t/tyUcF7ysrMx+IAICMt
        xyUqJ9rxP439dGiapNbaYmK5l2OgB8tHvv0yE9QABclO1OY=
X-Google-Smtp-Source: ABdhPJzqqBGeJJU5IoYMlHP8FPsMmmCs1jouQo9fnTTwx55V+FEpwXA2/WAf7rZO8kERVv9fDlV/Mhb41tsuNYt5ogk=
X-Received: by 2002:a05:6638:4183:: with SMTP id az3mr6584039jab.56.1636650034239;
 Thu, 11 Nov 2021 09:00:34 -0800 (PST)
MIME-Version: 1.0
References: <20211110004440.3389311-1-bvanassche@acm.org> <20211110004440.3389311-2-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-2-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 11 Nov 2021 22:29:58 +0530
Message-ID: <CAGOxZ502ciD7OP9dfJi5FFVDb0NaTrby4kKw0wqQwby7NFcUXQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] scsi: ufs: Rename a function argument
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On Wed, Nov 10, 2021 at 6:22 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> The new name makes it clear what the meaning of the function argument is.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Thanks
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-exynos.c | 4 ++--
>  drivers/scsi/ufs/ufshcd.h     | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index cd26bc82462e..474a4a064a68 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -853,14 +853,14 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
>  }
>
>  static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
> -                                               int tag, bool op)
> +                                               int tag, bool is_scsi_cmd)
>  {
>         struct exynos_ufs *ufs = ufshcd_get_variant(hba);
>         u32 type;
>
>         type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
>
> -       if (op)
> +       if (is_scsi_cmd)
>                 hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
>         else
>                 hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 4ceb3c7e65b4..a911ad72de7a 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -338,7 +338,8 @@ struct ufs_hba_variant_ops {
>                                         enum ufs_notify_change_status status,
>                                         struct ufs_pa_layer_attr *,
>                                         struct ufs_pa_layer_attr *);
> -       void    (*setup_xfer_req)(struct ufs_hba *, int, bool);
> +       void    (*setup_xfer_req)(struct ufs_hba *hba, int tag,
> +                                 bool is_scsi_cmd);
>         void    (*setup_task_mgmt)(struct ufs_hba *, int, u8);
>         void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
>                                         enum ufs_notify_change_status);



-- 
Regards,
Alim
