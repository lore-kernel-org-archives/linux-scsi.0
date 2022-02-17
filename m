Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F076C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiBQTmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244835AbiBQTmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:42:38 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877C2419BB
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:42:23 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gb39so9764829ejc.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lkezhbeJh3iaQziNyjtt1RCbeY32HUq+YQLgEHGlpXA=;
        b=ZGU2TJp+8BrV+qJ/TwFeYB2TzWn4qvEBU0ZAlx9v2RNvUzsqLKhMOdlXfMfUYM7DOi
         XGGMOqzebYtrsSa4KyjnnTnT0hvzjqGA4TJKCWHSgCoAkkmkhyah4M1hBAyMjAFBXWRI
         U/W0RyaGu1oboV94PSMB/4eEX6Q5wrHyOm1UOuu0sRUsjLic+CoXlNURQssSSl/UIalF
         OU5axfCdWdV1biz5GWY/TvMazSIYw1KjWg7gv4l0tBR0SJxHC26/fhEnv4ri3t2d5js9
         IefCAR2tvPqr3N/Xtbme9Hq4ssYmWk9HMl9AAyv+AELjXAgB4HWEL8MtIS4kGEcOOd3M
         ImGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lkezhbeJh3iaQziNyjtt1RCbeY32HUq+YQLgEHGlpXA=;
        b=vzaR8UYZjv/10yf+iS4uqpQaPu3FngEjc2VKHdUlXlpiTEVnW+1WOWeKE5fAEJideT
         iHAgdGy0gPTgyPQM5TWyhzWjHJHNDloVdzUf+z3CMINYE/lyULLp0yZQOzsYsl0TYW0P
         tm9f0pGpPfQG+Yn+Lhk2G2yz9dXQpym2ffAdHObI9hRrQz/Dn+77qNcwnKhXw+V9lYTM
         1d98qx4z+jSNDhdrYXqjIGoY7gWdFz03fYNitcqrsZlge1YftfvA+9w8yJtGeLfk6Q0f
         aq0I0kiLfIqyotGukZVqrJW71UBoCfoH/ITVlxPeSK3qWR4G/t7Huwoi4ppDmOWeDAy9
         A4Jg==
X-Gm-Message-State: AOAM532abPDBOh9Dw/HpdXA8/DX0PqcoZ0nFQevyxbJueWmjkueGcsZp
        1XMkKsmqxp1VUJ9igWNOlHRKMKU7PB3M/7phBjgrtQ==
X-Google-Smtp-Source: ABdhPJxAerMh7ZSLvK5mosnqmU/T229iCAZ5GV4yJLBQRUSHWn+1seOpcjJYjfvBV7WYTaD3PW87bbRD0hSRdvPLwKw=
X-Received: by 2002:a17:907:76ac:b0:6ce:72b5:7b7c with SMTP id
 jw12-20020a17090776ac00b006ce72b57b7cmr3537321ejc.735.1645126940929; Thu, 17
 Feb 2022 11:42:20 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-24-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-24-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:42:10 +0100
Message-ID: <CAMGffEn4Q=MtkgbNjoAeYfZkQW4aL_teHs2b=KKMQ6pZNbS2mw@mail.gmail.com>
Subject: Re: [PATCH v4 23/31] scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> In pm8001_chip_fw_flash_update_build(), if
> pm8001_chip_fw_flash_update_build() fails, the struct fw_control_ex
> allocated must be freed.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>

> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 431fc9160637..41077c84eec9 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4873,8 +4873,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
>         ccb->ccb_tag = tag;
>         rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
>                 tag);
> -       if (rc)
> +       if (rc) {
> +               kfree(fw_control_context);
>                 pm8001_tag_free(pm8001_ha, tag);
> +       }
>
>         return rc;
>  }
> --
> 2.34.1
>
