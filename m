Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93197C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245520AbiBQTuf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:50:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244004AbiBQTud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:50:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F41255B3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:50:17 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id i11so9920486eda.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vWP+SwJTRCU1uze0CRzaNHvi6IGN7Vy5cUTtjWb1m0c=;
        b=b77ZSjJNz13WzaKG19dKArM+Gl3dKBrCYcig759Qf0jqLDTJ1n8ZkT751eJM9QP9BG
         KTO4GwMBL1i5a4dPE8FYCRtVGTzHtUE92/bS4eOJ0mkDEpSpdTeRSxmQuSYvDeg6VIU6
         eeG5edudVe10aLjLaLrDajCpRbRo/5cFNcmA3LP12YVkLj7+cPfiWq2fiHnLOQgM1vSS
         LU3UsZ2YoWPigbeisA5nq8ZXN1Iahmu0U3CeoM9VR4c6sS14q8Cw605IB5coQ4cCvbqo
         kA9aBCFqsNQJOZ7LKcSGroS12x+OTuBWwWJEWC9sOs9wN3W1p6AMH+XISz+b8ffp1HvD
         xUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWP+SwJTRCU1uze0CRzaNHvi6IGN7Vy5cUTtjWb1m0c=;
        b=3jy/H5LmVTSeLASk5+USSKpdz76Z1y0q3GUkPg8PmvI3Jlrgmxghsn2qpD74Sq0axY
         eilOD/hQ1aK8grOBa1049jsZZJPoxCTT6ww3FKOYYOy2n74wDmL2nQOj9YMjQyCu9OIl
         9++ofIiKaxxEJTWYSMOadt5l4niV2E3G526pTV+/U8iM9SDencwdsok9fq1FarU2PzUG
         Rvop2Z1QRkeiptHP5GZPuv5PI4JWpF2nA3UKkb50FtNLyRQ1R29Vns7Mlr/B0Vt18bnF
         OAyHchLM/ifyFD6oPIZX4AVGSeUBIb8AOLzzwp34wZGcykmFiCAnWPQBeajggsjFPebc
         Ra2g==
X-Gm-Message-State: AOAM530Z6hYVxTwQq5gt0jkscXRqxE9nU+JerG2lNMZSLF+F3EH5xvQb
        ywG5dUaG8I/bGwF4GvMFeAWnV+irf7dFg5BKNGDP+Q==
X-Google-Smtp-Source: ABdhPJxm/vqRAqtqHbEiWQ0zdxLfTOPuhjs44Yml1TQBZ7E10oLifglVrh/bM8qVed4PmXMxhwgXECai65JstcAh+0E=
X-Received: by 2002:aa7:c789:0:b0:410:dd40:d458 with SMTP id
 n9-20020aa7c789000000b00410dd40d458mr4579444eds.3.1645127416162; Thu, 17 Feb
 2022 11:50:16 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-32-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-32-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:50:05 +0100
Message-ID: <CAMGffEnJ-Fs_KV+-6FZz5OBo_RpB+RGSGiA9A-hj1KONQ=4EUw@mail.gmail.com>
Subject: Re: [PATCH v4 31/31] scsi: pm8001: Fix pm8001_info() message format
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
> Make the driver messages more readable by adding a space after the
> message prefix ":" and removing the extra space between function name
> and line number.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 2aab357d9a23..d78e6690333f 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -71,7 +71,7 @@
>  #define PM8001_IOERR_LOGGING   0x200 /* development io err message logging */
>
>  #define pm8001_info(HBA, fmt, ...)                                     \
> -       pr_info("%s:: %s  %d:" fmt,                                     \
> +       pr_info("%s:: %s %d: " fmt,                                     \
>                 (HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
>
>  #define pm8001_dbg(HBA, level, fmt, ...)                               \
> --
> 2.34.1
>
