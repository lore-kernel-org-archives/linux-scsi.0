Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD91C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiBQTI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:08:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242994AbiBQTIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:08:55 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD5C8594F
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:08:40 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p14so9465038ejf.11
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7TarZMuDOwT50SoVUaZFfPKEfK54HtJyqlJvVn4byHU=;
        b=H5GVo5J6wYwQd+YYSaaxW7rnFtnlIoeyYlKpV/0NRJUrWN0p8/zj5KfmNJSbNxWneX
         zFa2bR0n4YU3ExstEtJUBkKlnDQcBntJVgZQRUOXIynYmTVh3Kghan1omOPjrMuujtlL
         f47fyRqEirxZyfwLFRS3eHfZYnSuvvtN7iqVAW5NJQQmU9pOGQkaRLMrUZ5u2p6b3NLI
         HO1eiPxgVWPL0J/Kosow+gWfyYTqKQ6F17PzWM4q/Okx5e/Zndk1h+S5a0m/46sBFzFx
         9BSoji7DSeNJ67fZLobSwzimAr+R2aWEwgSI9vcgH17IDEkUBK6qZOTg0X2+opE9r6B6
         +2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7TarZMuDOwT50SoVUaZFfPKEfK54HtJyqlJvVn4byHU=;
        b=G6emkxYeZTIu94QUO71BAfg27R8pV9TRDh0/PFd9gpTammip5HBrnA36iJ2SI+fIUy
         9NsWorK8fZFXsnv+ElpYCGrDpU7EYC1IjUcRUjgbAfmZtgQ+dYMoXSZ0gA4RG6mxpyEL
         LuLzLvnIdvCtWOCSuyoyR9d4z0JSzEebwIIHi+arCEBrQyNRCVUBWlY62RBQW7vsFV3n
         jlc91AOwscULpBUPRYyKwa93Ypk7LK53+V0/EpV6orMyaqEKWjdB79zvFXZcvY59kjq0
         f1gzpSl0tPeN9dimVmSjHOBqA4UFOK6yj9JQ1TMfz2Iw9Tzsz1wu9wyEcowiXrLHomrG
         2PPg==
X-Gm-Message-State: AOAM532v1MM9HFwnfgrMdC3nipGd65hrKN5d6TGSYDmnLks5ioLBucAp
        pJyBrnnFA5M6ApIJVMXYLL6bAq+HUNqx2SuxvkQhRw==
X-Google-Smtp-Source: ABdhPJy7s+T87ouK/jLgi4Bz2aKaOp+jdGgKuL0XHLXuoqVNLgFpeLNoRyf05vqyyQp9yEFMOWj+sc7ln9yrc5YxCMQ=
X-Received: by 2002:a17:907:76ac:b0:6ce:72b5:7b7c with SMTP id
 jw12-20020a17090776ac00b006ce72b57b7cmr3434980ejc.735.1645124919326; Thu, 17
 Feb 2022 11:08:39 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-9-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-9-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:08:28 +0100
Message-ID: <CAMGffEnPYWoVA21_GQK3P9+W_EoQkie4HcX9XjodTDTsPUrxug@mail.gmail.com>
Subject: Re: [PATCH v4 08/31] scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
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
> All fields of the SASProtocolTimerConfig structure have the __le32 type.
> As such, use cpu_to_le32() to initialize them. This change suppresses
> many sparse warnings:
>
> warning: incorrect type in assignment (different base types)
>    expected restricted __le32 [addressable] [usertype] pageCode
>    got int
>
> Note that the check to limit the value of the STP_IDLE_TMO field is
> removed as this field is initialized using the fixed (and small) value
> defined by the STP_IDLE_TIME macro.
>
> The pm8001_dbg() calls printing the values of the SASProtocolTimerConfig
> structure fileds are changed to use le32_to_cpu() to present the values
> in human readable form.
>
> Fixes: a6cb3d012b98 ("[SCSI] pm80xx: thermal, sas controller config and error handling update")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 52 +++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b303bc347f3d..e6fb89138030 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1245,43 +1245,41 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         payload.tag = cpu_to_le32(tag);
>
> -       SASConfigPage.pageCode        =  SAS_PROTOCOL_TIMER_CONFIG_PAGE;
> -       SASConfigPage.MST_MSI         =  3 << 15;
> -       SASConfigPage.STP_SSP_MCT_TMO =  (STP_MCT_TMO << 16) | SSP_MCT_TMO;
> -       SASConfigPage.STP_FRM_TMO     = (SAS_MAX_OPEN_TIME << 24) |
> -                               (SMP_MAX_CONN_TIMER << 16) | STP_FRM_TIMER;
> -       SASConfigPage.STP_IDLE_TMO    =  STP_IDLE_TIME;
> -
> -       if (SASConfigPage.STP_IDLE_TMO > 0x3FFFFFF)
> -               SASConfigPage.STP_IDLE_TMO = 0x3FFFFFF;
> -
> -
> -       SASConfigPage.OPNRJT_RTRY_INTVL =         (SAS_MFD << 16) |
> -                                               SAS_OPNRJT_RTRY_INTVL;
> -       SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO =  (SAS_DOPNRJT_RTRY_TMO << 16)
> -                                               | SAS_COPNRJT_RTRY_TMO;
> -       SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR =  (SAS_DOPNRJT_RTRY_THR << 16)
> -                                               | SAS_COPNRJT_RTRY_THR;
> -       SASConfigPage.MAX_AIP =  SAS_MAX_AIP;
> +       SASConfigPage.pageCode = cpu_to_le32(SAS_PROTOCOL_TIMER_CONFIG_PAGE);
> +       SASConfigPage.MST_MSI = cpu_to_le32(3 << 15);
> +       SASConfigPage.STP_SSP_MCT_TMO =
> +               cpu_to_le32((STP_MCT_TMO << 16) | SSP_MCT_TMO);
> +       SASConfigPage.STP_FRM_TMO =
> +               cpu_to_le32((SAS_MAX_OPEN_TIME << 24) |
> +                           (SMP_MAX_CONN_TIMER << 16) | STP_FRM_TIMER);
> +       SASConfigPage.STP_IDLE_TMO = cpu_to_le32(STP_IDLE_TIME);
> +
> +       SASConfigPage.OPNRJT_RTRY_INTVL =
> +               cpu_to_le32((SAS_MFD << 16) | SAS_OPNRJT_RTRY_INTVL);
> +       SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO =
> +               cpu_to_le32((SAS_DOPNRJT_RTRY_TMO << 16) | SAS_COPNRJT_RTRY_TMO);
> +       SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR =
> +               cpu_to_le32((SAS_DOPNRJT_RTRY_THR << 16) | SAS_COPNRJT_RTRY_THR);
> +       SASConfigPage.MAX_AIP = cpu_to_le32(SAS_MAX_AIP);
>
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.pageCode 0x%08x\n",
> -                  SASConfigPage.pageCode);
> +                  le32_to_cpu(SASConfigPage.pageCode));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MST_MSI  0x%08x\n",
> -                  SASConfigPage.MST_MSI);
> +                  le32_to_cpu(SASConfigPage.MST_MSI));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_SSP_MCT_TMO  0x%08x\n",
> -                  SASConfigPage.STP_SSP_MCT_TMO);
> +                  le32_to_cpu(SASConfigPage.STP_SSP_MCT_TMO));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_FRM_TMO  0x%08x\n",
> -                  SASConfigPage.STP_FRM_TMO);
> +                  le32_to_cpu(SASConfigPage.STP_FRM_TMO));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_IDLE_TMO  0x%08x\n",
> -                  SASConfigPage.STP_IDLE_TMO);
> +                  le32_to_cpu(SASConfigPage.STP_IDLE_TMO));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.OPNRJT_RTRY_INTVL  0x%08x\n",
> -                  SASConfigPage.OPNRJT_RTRY_INTVL);
> +                  le32_to_cpu(SASConfigPage.OPNRJT_RTRY_INTVL));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO  0x%08x\n",
> -                  SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO);
> +                  le32_to_cpu(SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR  0x%08x\n",
> -                  SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR);
> +                  le32_to_cpu(SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR));
>         pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MAX_AIP  0x%08x\n",
> -                  SASConfigPage.MAX_AIP);
> +                  le32_to_cpu(SASConfigPage.MAX_AIP));
>
>         memcpy(&payload.cfg_pg, &SASConfigPage,
>                          sizeof(SASProtocolTimerConfig_t));
> --
> 2.34.1
>
