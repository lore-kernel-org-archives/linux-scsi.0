Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03F2C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbiBQTcK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:32:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiBQTcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:32:09 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84215FF9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:31:54 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p15so9638485ejc.7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=voFXABOwSGxYjb4TI6dvVwWzY2QAaDSOqy5C4Qf1+/4=;
        b=I+ePXy/JzzSOHJlTF+FaQ3qcx0g2YWUKRsU+GPzHW/hcfBmfsHsNK1DUZatQhMeVlK
         UobQfrPkbXgDZybdGjHWZz8WM9c3v8PfP6HpCIdWoICGKQUmUsTW2L0OByVP3ErDglDF
         6GSuyhlOePwEqqEBaZrYw9VrNrJZenjGDRuF4Yn7Xx9c9F6gH1/jg859Fbm43M+EmqiN
         yLHSJut6CHJhIGTKkvjqVXlpTnOaBNpMuip5uL+zJIf171Wz6l0Z+1J3WCZc5ZuT6ZCv
         /kZ8RemTOnp7/rWY1Pd06ajRNPKxKWsprfnA8ru2LTy/dXwD//YNZ3/9+0VkBSYTE4Q1
         51Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=voFXABOwSGxYjb4TI6dvVwWzY2QAaDSOqy5C4Qf1+/4=;
        b=HqGiSXw9SZIeqj4KwH3ggD6yAclnsItxsNIwDbFLlZta0g/qJdXjrWeUFMNWvLnPqN
         iiInGpUGzwBsTj5iKFGqnPAp1fa/zJlztgR9tddYgZtqZoT0k1U2meBGzygchMUIkbjx
         GACl+3NPdarLEDGaniSHYPWXvxppXBYZ2ijvoqMG6x7hxarUvArOGeMp2LNG7zr2cSQQ
         HVB2YAQinsAbL9xN+VcrLzPAsMlcHu0f+aB9EDJT5LD9il9vly3ZlpETimY28xSQjd54
         vBrnmcOEYq7g4pwsenMrG9OLE/jBzIJaUGAWpqX6q47WIX/4ubOX2vRcWP/LmPa0UEls
         Hk8w==
X-Gm-Message-State: AOAM532n5DN8ZaLKU7pnqoUIioRiPBvSSOdRu0VvBIhPMVlF6WShYNZ8
        ztBpGEqBJFvTHSgoOeCi8V8lNaXVLF4XV8A+ZzGSQg==
X-Google-Smtp-Source: ABdhPJzyWjt1Ix0a9BAvgqAC8LLnryvhXtoxhJjXHxZ9uLtDPQOaClV5tTlWzToMQuIshKgsZnq8MzEGcJ3Z3pmoPnw=
X-Received: by 2002:a17:906:b201:b0:6b5:58c8:e43c with SMTP id
 p1-20020a170906b20100b006b558c8e43cmr3434661ejz.441.1645126313139; Thu, 17
 Feb 2022 11:31:53 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-18-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-18-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:31:42 +0100
Message-ID: <CAMGffE=UN2YOUHbXNHJa+3-__nfc6m-SnDZXP_Ldx580MKafGw@mail.gmail.com>
Subject: Re: [PATCH v4 17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
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
> In mpi_set_phy_profile_req() and in pm8001_set_phy_profile_single(), if
> pm8001_tag_alloc() fails to allocate a new tag, a warning message is
> issued but the uninitialized tag variable is still used to build a
> command. Avoid this by returning early in case of tag allocation
> failure.
>
> Also make sure to always return the error code returned by
> pm8001_tag_alloc() when this function fails instead of an arbitrary
> value.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 8fd38e54f07c..76260d06b6be 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1191,7 +1191,7 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
>         memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
>         if (rc)
> -               return -1;
> +               return rc;
>
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         payload.tag = cpu_to_le32(tag);
> @@ -1240,7 +1240,7 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
>
>         if (rc)
> -               return -1;
> +               return rc;
>
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         payload.tag = cpu_to_le32(tag);
> @@ -1398,7 +1398,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
>         memset(&payload, 0, sizeof(struct kek_mgmt_req));
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
>         if (rc)
> -               return -1;
> +               return rc;
>
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         payload.tag = cpu_to_le32(tag);
> @@ -4967,8 +4967,11 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
>
>         memset(&payload, 0, sizeof(payload));
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -       if (rc)
> +       if (rc) {
>                 pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
> +               return;
> +       }
> +
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         payload.tag = cpu_to_le32(tag);
>         payload.ppc_phyid =
> @@ -5010,8 +5013,10 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
>         memset(&payload, 0, sizeof(payload));
>
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -       if (rc)
> +       if (rc) {
>                 pm8001_dbg(pm8001_ha, INIT, "Invalid tag\n");
> +               return;
> +       }
>
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         opc = OPC_INB_SET_PHY_PROFILE;
> --
> 2.34.1
>
