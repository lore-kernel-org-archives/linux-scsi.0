Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18A3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbiBQTOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:14:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245035AbiBQTOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:14:35 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1E69025A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:14:21 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w3so11427572edu.8
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvrqXIhqhVcqWbatH2+RbGw9/Y9zxmwBs1ZtZq+LJl8=;
        b=ItcOqd6NQY/4KVPNb9jj/luUc9Yh57Xp82pe8SZBwvEdquNJd8lSEU9r7+ulNqhAGJ
         nqYqwFeAXBe9wF4XHAoJhCWZTWD540zysgy8//9wX4FQlDP7a+2Xy7JtMuYcZJN9caY6
         mwgpp6Q3ankHo3RBzJ8BClnKxyA0G/F88mbfWVFeUYBwWVk1lKRqgsOCDcpPjK+rrRcr
         6RJbfAuwt2DeMYXv4xCjUfcQlyM4pvJFsmJJU8trtk8c9uL4XFQPQjKd566mQ0XVKsXq
         BrpTSNB30SdG9QXNxNfT2O1AJ/dhF6GmbJbH7r38KNAFVHbR+ueRenxs8kD1BpHkRvGX
         p+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvrqXIhqhVcqWbatH2+RbGw9/Y9zxmwBs1ZtZq+LJl8=;
        b=Ea7wMYBsgcrKOo8gkR8P9CU6b1FlkfE0TmcRVwUJponWQnZaaOk4TCEfCiGopi2KPi
         jl/w9meuj4U5xmCqvQMmpswxv6XjSxGFbu8u34Ox4o4tsw4npwAvzfBJcWDLYi+tzEQ6
         3YXndv0oLkvoFbHJpM0+yuT/g5leX0ubswkq/4SbDopGUr5SAYvWU+R+CLKHBCj8EiA3
         SZgD0y5jKiNBBjCxYz6wekzH4CfJU6SvosibVAPI9xwJmhBjRHCstfqGWoNqkgHPKmTg
         4aD79GyZ1rQ9HGXItTAopl6isV8HFwHpq9VJ4UXfsL6eJ32RAQhGx9hVzTWabjSmO2wj
         UKVA==
X-Gm-Message-State: AOAM532erDxRnbW+wxQDiF3oUdk/z2+dLKUdHJs+AKk56lY5phRH7vQw
        J+WG4NeVvMboPae5WdhO8OodkWaxsRRAc71GGSZNkg==
X-Google-Smtp-Source: ABdhPJy3z10CF5FdSVk4Rvu+0CTIuG3NGBJinAS43qhKLeTruiTaT6nEy81+EVWxYbVzZV46azd8MryI8gUL+OychDo=
X-Received: by 2002:a50:a6c2:0:b0:410:a328:3c86 with SMTP id
 f2-20020a50a6c2000000b00410a3283c86mr4205579edc.55.1645125259531; Thu, 17 Feb
 2022 11:14:19 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-13-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-13-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:14:09 +0100
Message-ID: <CAMGffEk4CicNVUt3ia72rNSnWzYoSt5Z_RtahKVpYEaCSWZLpQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/31] scsi: pm8001: Fix use of struct
 set_phy_profile_req fields
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
> In mpi_set_phy_profile_req() and pm8001_set_phy_profile_single(), use
> cpu_to_le32() to initialize the ppc_phyid field of struct
> set_phy_profile_req. Furthermore, fix the definition of the reserved
> field of this structure to be an array of __le32, to match the use of
> cpu_to_le32() when assigning values. These changes remove several sparse
> type warnings.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 12 +++++++-----
>  drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 1f3b01c70f24..60c305f987b5 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4970,12 +4970,13 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
>                 pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         payload.tag = cpu_to_le32(tag);
> -       payload.ppc_phyid = (((operation & 0xF) << 8) | (phyid  & 0xFF));
> +       payload.ppc_phyid =
> +               cpu_to_le32(((operation & 0xF) << 8) | (phyid  & 0xFF));
>         pm8001_dbg(pm8001_ha, INIT,
>                    " phy profile command for phy %x ,length is %d\n",
> -                  payload.ppc_phyid, length);
> +                  le32_to_cpu(payload.ppc_phyid), length);
>         for (i = length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
> -               payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
> +               payload.reserved[j] = cpu_to_le32(*((u32 *)buf + i));
>                 j++;
>         }
>         rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> @@ -5015,8 +5016,9 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
>         opc = OPC_INB_SET_PHY_PROFILE;
>
>         payload.tag = cpu_to_le32(tag);
> -       payload.ppc_phyid = (((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
> -                               | (phy & 0xFF));
> +       payload.ppc_phyid =
> +               cpu_to_le32(((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
> +                           | (phy & 0xFF));
>
>         for (i = 0; i < length; i++)
>                 payload.reserved[i] = cpu_to_le32(*(buf + i));
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index c41ed039c92a..d66b49323d49 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -972,7 +972,7 @@ struct dek_mgmt_req {
>  struct set_phy_profile_req {
>         __le32  tag;
>         __le32  ppc_phyid;
> -       u32     reserved[29];
> +       __le32  reserved[29];
>  } __attribute__((packed, aligned(4)));
>
>  /**
> --
> 2.34.1
>
