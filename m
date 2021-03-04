Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78FBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931A764F2B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbhCDJwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbhCDJw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:52:29 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC48C061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:51:49 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id c10so21635210ejx.9
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DyZ9u+4CQFaTUGpxZ7Y1chiIzjBwSjejYpZ2cWT/U0c=;
        b=ieIJHxpqiINZmN5DPPQ3ti1xHrBJVvclj2lSDcenYycjgPoKiNg++ktFWoUjpJMwD9
         vMD7CVyJm5gZiA1EO9sSBFuboVk/aCx+xT3VuxVSOyald2aStmcxRKL6q6U8Ku0+gMvR
         xRtGLYWz9rRzdcOBPEQkZ3KdXL4OVsU1gYTSNlysmyblPTZXqK3A3u2/Auf0cf3da68L
         07dulkSEx+2XqLxpNk51ZGJUvx/yicHkKJUbPQguIkEQbWuYNwRRKEt6xTjaPSBMd8oZ
         cupHl2+ztWeSWrIbrsdtJF47cHUkUxQsrhCqcFMOAtYnoH0vTZh+1QLQsAuBQvx/y05B
         P4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DyZ9u+4CQFaTUGpxZ7Y1chiIzjBwSjejYpZ2cWT/U0c=;
        b=QsCopZKrZQKq9htJiYGaASuJ7kXYcXkLPTEBwxjW7Uzpthbf5guIOkQ+vBS8yVLHE/
         eHKVggcftOjEAcG8r4DmIS8EfERCLbPX+FHd7CdhvE3A66MwzJMTz4qJCYdW8/dDfMLp
         DH5uS4Bg94tkdLAguYcc/9iUpKi8QSGJ9wkTfPpqrZqFsL2gJZnu3Mrea/D+zlLilTzY
         O8iKWwESXyqFMzWwlIFIheR0801wDYCR9B1p1OiHIl/gtwqU+UMdvfdWWASPiv3lOr8y
         x77O6vOy4Ak7q4rTJOa5B+U1tcr9V2SkC6/HTvpBQyQ+8ovoCvf0EvUTtfbAjG+p3nq2
         WmUA==
X-Gm-Message-State: AOAM53161nTJThxbOGVUDBHVdgLiEcSukAbz7IUi68i8u2GogwHzs+Dx
        JMbSrnj7hbIYujmsXmtLdCIDBn2li9fX8YCy8Tztlg==
X-Google-Smtp-Source: ABdhPJxVXr0PLxMt5u2JDX1pQ6tBL7LfITuN2AKJDU/ek2sC14xWyumHqMqPxE9rBbsNWnHEJ+c86rMypPNk+PPv8j0=
X-Received: by 2002:a17:906:d18e:: with SMTP id c14mr3192873ejz.62.1614851508128;
 Thu, 04 Mar 2021 01:51:48 -0800 (PST)
MIME-Version: 1.0
References: <20210303144631.3175331-1-lee.jones@linaro.org> <20210303144631.3175331-9-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-9-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:51:37 +0100
Message-ID: <CAMGffEmcyspgsigH3Ek-O=VR+t3Hpx2aBtw04domWQ1Snm7xpg@mail.gmail.com>
Subject: Re: [PATCH 08/30] scsi: pm8001: pm8001_init: Provide function name
 and fix a misspelling
To:     Lee Jones <lee.jones@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>,
        Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>,
        Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 3, 2021 at 3:46 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_init.c:192: warning: expecting prototype for tasklet for 64 msi(). Prototype was for pm8001_tasklet() instead
>  drivers/scsi/pm8001/pm8001_init.c:872: warning: expecting prototype for pm8001_set_phy_settings_ven_117c_12Gb(). Prototype was for pm8001_set_phy_settings_ven_117c_12G() instead
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Cc: Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>
> Cc: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index bd626ef876dac..bbb6b23aa6b1c 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -184,7 +184,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
>  #ifdef PM8001_USE_TASKLET
>
>  /**
> - * tasklet for 64 msi-x interrupt handler
> + * pm8001_tasklet() - tasklet for 64 msi-x interrupt handler
>   * @opaque: the passed general host adapter struct
>   * Note: pm8001_tasklet is common for pm8001 & pm80xx
>   */
> @@ -864,7 +864,7 @@ void pm8001_get_phy_mask(struct pm8001_hba_info *pm8001_ha, int *phymask)
>  }
>
>  /**
> - * pm8001_set_phy_settings_ven_117c_12Gb : Configure ATTO 12Gb PHY settings
> + * pm8001_set_phy_settings_ven_117c_12G() : Configure ATTO 12Gb PHY settings
>   * @pm8001_ha : our adapter
>   */
>  static
> --
> 2.27.0
>
