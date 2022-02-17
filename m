Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40662C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbiBQTFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:05:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244943AbiBQTFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:05:45 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC7281198
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:05:30 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b13so11499995edn.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZgiqxL+HGzXRpFuzwDXFJU5HXBt8Vnu6t+pLS1Kidw=;
        b=JhiR+Q755+c+h5703zqAcaeEzTXAnnXT2ViDo2OoNdSGmdbTUtYEn5w5vS36eq4fu6
         Dgvv9FyvuL5gD8R3d6Gyl9z+X9aH1E3EjdC0Ur19gFMlPGaEJyeYBBAN7PTz1QCBkNrr
         aZ27zCsLQi6u5FuaXqCTxe3neFLZIlzHEfTSyi0z5/2YB3kuXgzP4aIw0T2RwaIFzQ6g
         XEi6RFvYWEeSlcORpjTyF5bPo0W2ZV1gQkUK9/mPLSWoWAvo/giUEZeQf+uQXujp86hj
         ZWvrj1LB7xH2UF6KGmNHKKnQke39baocCmVJYzhdiX5JonKiMdQFS7ObTWBXNLmKuDuo
         ww2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZgiqxL+HGzXRpFuzwDXFJU5HXBt8Vnu6t+pLS1Kidw=;
        b=WG0a/dcPO6PVE4ZjFqua19uV8U/ZQMTksSoHfyLMz84K+aQLNbhzX1eRuX3Fxtnmys
         etfawxJIvlgIg3hG+LIfjlZ3tZTpi8gwLTeRa//uEbv9MjP8LM7TFAWN8rdGr8oOyAnD
         tJM6A4iO3+PxDYwmqBplthfD5X0C49KVXGZHXPvTxN/RxUeIq9eqbuoNsBmDuL5IJIXg
         9HVkTVxoR362rpvQ7B+2Hsx35MlW1RBIfBsTH3eU/roqxfMcTiIhutDHNvkhWSXSMeYm
         8TSFMGGPnoscr+Qui9gSIaZz56otbewupvCIt308/DngMT0UIb4DXzAN3T9Z4eL4Br5/
         kHIw==
X-Gm-Message-State: AOAM533mVd3Jc4fnIwMSwc3wSr2SD65FrdeuDPMQbS2PJcY08aSiksgz
        TmaDpBrmiUzAfcHEW/EZGS9CFXj12HokS9HMczehvghjPRYInw==
X-Google-Smtp-Source: ABdhPJwWJ0SEu9SY2YjWX3h4vJqVmYqeFucKT1SWBsD+rHqUuNU+Jy/tndOezkQGBOvqi/qog/05cKZg6QvQQKmfxj8=
X-Received: by 2002:a50:9d89:0:b0:410:ff04:5a98 with SMTP id
 w9-20020a509d89000000b00410ff045a98mr4313034ede.404.1645124728868; Thu, 17
 Feb 2022 11:05:28 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-5-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-5-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:05:18 +0100
Message-ID: <CAMGffEmYUzicVoVKb2QCYn+COTfcr40pnEWtiWeHRKbZY4MoqQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/31] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> Since the sata_cmd struct is zeroed out before its fields are
> initialized, there is no need for using "|=" to initialize the
> ncqtag_atap_dir_m field. Using a standard assignment removes the sparse
> warning:
>
> warning: invalid assignment: |=
>
> Also, since the ncqtag_atap_dir_m field has type __le32, use
> cpu_to_le32() to generate the assigned value.
>
> Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
> Reviewed-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 4683fee87b84..817bba65feb3 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1864,7 +1864,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>
>         sata_cmd.tag = cpu_to_le32(ccb_tag);
>         sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
> -       sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
> +       sata_cmd.ncqtag_atap_dir_m = cpu_to_le32((0x1 << 7) | (0x5 << 9));
>         memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
>
>         res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b83500ef3d86..f1663a10693a 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1882,7 +1882,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
>
>         sata_cmd.tag = cpu_to_le32(ccb_tag);
>         sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
> -       sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
> +       sata_cmd.ncqtag_atap_dir_m_dad = cpu_to_le32(((0x1 << 7) | (0x5 << 9)));
>         memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
>
>         res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
> --
> 2.34.1
>
