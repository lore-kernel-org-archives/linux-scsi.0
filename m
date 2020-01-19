Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2D0C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B553024697
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWjlMtnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgASBye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 20:54:34 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36218 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgASBye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 20:54:34 -0500
Received: by mail-ua1-f67.google.com with SMTP id y3so10326232uae.3;
        Sat, 18 Jan 2020 17:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TTozb2zePNKT8aZKd3kD9UXbrPwY+ZsZD84I1bqkZt0=;
        b=NWjlMtnN0AvKVjD4KMk6naHTEcgvwwlzSmdo0s/PGVBqd/r3IAdCXCCzfyMEtE4TKm
         xoqA7l86kOmxSrQeE1AGIXPdl3BIk7TwiFm2pg7ndj4A8I/8L0qUo1MIHlKorK2RCnOq
         O5PEiXjJAvvyByPPSzd/zgBdzhrsR0wkvSemlwP/X3KCL/wXjRlgsBCSUaZ/qU8YSdE+
         n3kirr6onWrpAk6PDiBAK2ElQtHG3RIl1YieE+DGVWsesubKuk6dhIesEDf3sBDP1d2P
         1A3ftOjMAi/ehPlfVlxOSqBMO1yJ1NFeQ9nwtJogAiSy2KBnasNEtMgWjLlsr5NgrXDz
         gwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TTozb2zePNKT8aZKd3kD9UXbrPwY+ZsZD84I1bqkZt0=;
        b=F1J/xnjmsghuRLlEwg8ml0tJqre0V4fMidSf3OXHaUSmnEBV7tMZnruIBd5MJ8EQtk
         9EIVvibJDzLLto+XOKbudx0BgE5Oq+4ikap3Sxd4epY0Ijg6F5q32udwnbjl6/RFJ8JX
         gMSQ2F/Z4jHuCWEMGumpIU44GsEKNr+/8z0v7PZSUEtX/TCWHK4DPd6QWvVxHtjk1Rt8
         MpBuNQJOifU4e1YpOKKE9vjbDJl9us9WvKRZWeHYkcgb7uLqSOaflega+aCGUIq58BKT
         6ODfUMnNMfg4JXL6Axj5r7KzOLz1KOsD25MVXlgPFHm7hxrycgmAKEPPM07nAMdLKRTn
         dWIg==
X-Gm-Message-State: APjAAAU+eskva6JKCibJZ3TQuV6lvIqst9lTBRgypPVBpNhGWgrUJtei
        KFXhQReuLrkuztBoi00kDh0/QVrxmQ9eM4wWyFU=
X-Google-Smtp-Source: APXvYqxtngsGGKjZoEgoN8myyqs00BjmykkPdhJ09XS2xV/zyMg8qstOs90MhjIQu6IpDdFhxeRPqKR1muol95z3ShI=
X-Received: by 2002:ab0:30c2:: with SMTP id c2mr28532356uam.8.1579398873157;
 Sat, 18 Jan 2020 17:54:33 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-6-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-6-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:23:57 +0530
Message-ID: <CAGOxZ538XeHdsTU-TEroSWapoTsMYFt+4OCsW-ke=_fjsEih0w@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] scsi: ufs: Inline two functions into their callers
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
> Delete ufshcd_read_power_desc() and ufshcd_read_device_desc(), directly
> inline ufshcd_read_desc() into its callers.
>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 925b31dc3110..5f3b0ad5135a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3146,17 +3146,6 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
>         return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
>  }
>
> -static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
> -                                        u8 *buf,
> -                                        u32 size)
> -{
> -       return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
> -}
> -
> -static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
> -{
> -       return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
> -}
>
>  /**
>   * struct uc_string_id - unicode string
> @@ -6493,7 +6482,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
>         if (!desc_buf)
>                 return;
>
> -       ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
> +       ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
> +                       desc_buf, buff_len);
>         if (ret) {
>                 dev_err(hba->dev,
>                         "%s: Failed reading power descriptor.len = %d ret = %d",
> @@ -6599,7 +6589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>                 goto out;
>         }
>
> -       err = ufshcd_read_device_desc(hba, desc_buf, hba->desc_size.dev_desc);
> +       err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
> +                       hba->desc_size.dev_desc);
>         if (err) {
>                 dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
>                         __func__, err);
> --
> 2.17.1
>


-- 
Regards,
Alim
