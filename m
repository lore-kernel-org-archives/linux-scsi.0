Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5BDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242994AbiBQTKC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:10:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiBQTKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:10:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89E52B254
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:09:43 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hw13so9484357ejc.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w2nKm8xnHo5czTo3lKHvsB4XjO2nGA+nWQDrBU51W3A=;
        b=crl19KmYzbmYIewbVCKOYLYiSV/Fvs8Eb/Z3MY2hL6yD6DJB2QsNDu+O95cU9i7oIw
         xAwLX4XqpV5ygjBPkuC7IToVZz5w6E6YLYnvYhJpmJPZwdnIw8vw4+C3ublMGTWGqloK
         crblY4zTGh2Cjsa6H0ofRAln4q1s4B4+RnevJ4/pA1NCPN8BCXvso7s+OZcpglTe3QYJ
         pED+Pek1rjhYX0gD4yOLxxOBpv0IWAfpqtGB7WgH1oCO6tB0gBlqfb7Su3agJNSzjoi5
         kHZdJkxJ2zM31l1r/iSvsjhhbU2jozPoi3L+7Vs57GB8DcdQ01ccYosgOruqHYbaS8rj
         wDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w2nKm8xnHo5czTo3lKHvsB4XjO2nGA+nWQDrBU51W3A=;
        b=Y5ig/kRLVxKTdikrV/Fi5VdEdLelqKBHg3FrYkPRBhltCvJGo146wz0bnakr8W7atX
         nIcuF3e8T8xwOTNKjOi0EBPBxJcHqEg7q1+tciMUzjA7ia0FHZk9utNOa0PMQqr8R/Nc
         T3YiLIIjkFTaqEeQQOOD6YJdLQZCJOCrNRsOZDlgmV5ctqPKQY51XyJrDUvJCIRNCmhh
         LoEk8pvP59tXfd79XTHCB9E/f9j7I+yBPARZc2YliCGpbS1RMYV9B2XvQmo6Mo1/Sw68
         8MayVekqjBQZuyV4cv43ybHjcLEQDH5oJ3ghIUZy5nmBuaRt/v7dUHc6N8fOVcz2fLP7
         T6tg==
X-Gm-Message-State: AOAM533rVFpLLQmxa1dp8beAxSMo85K5YWUcOZnIbrUaY6t3Dquwwq51
        xBp/kXMOp4jHZocOwpEfZYFevimyyNeuLHqZYX4oow==
X-Google-Smtp-Source: ABdhPJwS1ika/h3Z4j8nsQf4aw8Y5q2n7okRb1OWJFjizOrpVwaV3py3LGlyORIy5AH1mNz2HmZ4C0+95AKnbHyCI8Y=
X-Received: by 2002:a17:906:ae07:b0:6b8:f4ba:4421 with SMTP id
 le7-20020a170906ae0700b006b8f4ba4421mr3477264ejb.692.1645124982259; Thu, 17
 Feb 2022 11:09:42 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-8-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-8-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:09:31 +0100
Message-ID: <CAMGffE=imNaYKNRMg+0EdPWx25Qf=6H7WVjMTqhQnOhstV2QWQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/31] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
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
> The fields of the set_ctrl_cfg_req structure have the __le32 type, so
> use cpu_to_le32() to assign them. This removes the sparse warnings:
>
> warning: incorrect type in assignment (different base types)
>     expected restricted __le32
>     got unsigned int
>
> Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
> Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 0b3386a3c508..b303bc347f3d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1201,9 +1201,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
>         else
>                 page_code = THERMAL_PAGE_CODE_8H;
>
> -       payload.cfg_pg[0] = (THERMAL_LOG_ENABLE << 9) |
> -                               (THERMAL_ENABLE << 8) | page_code;
> -       payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
> +       payload.cfg_pg[0] =
> +               cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
> +                           (THERMAL_ENABLE << 8) | page_code);
> +       payload.cfg_pg[1] =
> +               cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
>
>         pm8001_dbg(pm8001_ha, DEV,
>                    "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
> --
> 2.34.1
>
