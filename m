Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273EFC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 05:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiGKFoj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKFoi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 01:44:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF8FBE23
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 22:44:37 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l23so6996730ejr.5
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 22:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b9QONmd8NgRExIV5f3nev6QohovZOBU+IqQRXyOFp1U=;
        b=iuA+S+lt9N2CKNd6L3MkZNU/L0mFZls912nG2dQyVgh1+wQBMVQq0/EjQNA4Ch1cbE
         uKRFayuHaDYmEh1DAROM2gyyGIlVuMbbWkdSvneKNJfbqXvxUk9yQ1qPnvEXNB+kB3hc
         B1ohPEqsI7xkFPcwJyP7COfkbvnX47ZJuw7JEXLuWtC+bwfYtbvAX5Exbv9uh2Um49UA
         weV/T+KwnVDxbOOQF+VkzClmypWmgWdKJv3A68Gu12qPfvefc7X+yu3AIokoFiWGy7u7
         SnK/7xd3mAxalUatYMGNsvCHISr/Zv26qVj2mW4Gc5k+VDrdwLUuPPx6dCFCSPymfwi3
         oL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9QONmd8NgRExIV5f3nev6QohovZOBU+IqQRXyOFp1U=;
        b=chYsGj/quI9W06DyN9yNH2n647HFaY2fJkn6KIH4jKvmpR3f+X20ZQQ+kYAsWVxid7
         ESpkNA9GKzzCmGaltxTelMHwXxEOrG2cJiX3mzgYrwKwwIGXp8e7RQKREQQGWtusrNqh
         vYuwfh/sXXwqjcQyRppzJvYNI7GYIO+4PC4836lpOLai+qzuowvOhu3ZeeVfHKMg/eVc
         NXYe/9M1EeSXg3aujB5SXOnySKmOYrSUXsKMAgFeZ24fEGNnosG1uGAQyeqjNKQSnFpD
         CtiU+Cr7yo0FQ0FxBpDIW59cURuYnAfs3AphllOtv0NHJ2imoJkNycb2rHkEclfusFPP
         Wt4g==
X-Gm-Message-State: AJIora9qifZq1dMTCEuEgJj520zc3Igw0uNH1xO5NAZ4TJj1/qt7MVF7
        SinLY2vYHbv7zU/NwruMAZYiq2LFn46mX7xKd5n9bA==
X-Google-Smtp-Source: AGRyM1ufIP6EvpmycSWfn01fsb7IKFFmWeyt1/R+3kTidi/mWLr1cXaRq0lxnPiCLuNy+VT46PkYyvXAhu37peF7j/U=
X-Received: by 2002:a17:907:7ea6:b0:72b:4afb:e8b with SMTP id
 qb38-20020a1709077ea600b0072b4afb0e8bmr6026267ejc.205.1657518275921; Sun, 10
 Jul 2022 22:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220707175210.528858-1-changyuanl@google.com>
In-Reply-To: <20220707175210.528858-1-changyuanl@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 11 Jul 2022 07:44:25 +0200
Message-ID: <CAMGffEmGJX1PFbJvsFF4-0UBK301bKUTJutHpHAdD=_9OTmptA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix 'Unknown' max/min linkrate
To:     Changyuan Lyu <changyuanl@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 7, 2022 at 7:52 PM Changyuan Lyu <changyuanl@google.com> wrote:
>
> Currently, the dataflow of the max/min linkrate in the driver is
> * in pm8001_get_lrate_mode():
>   hardcoded value ==> struct sas_phy
> * in pm8001_bytes_dmaed():
>   struct pm8001_phy ==> struct sas_phy
> * in pm8001_phy_control():
>   libsas data ==> struct pm8001_phy
>
> Since pm8001_bytes_dmaed() follows pm8001_get_lrate_mode(), and
> the fields in struct pm8001_phy are not initialized, sysfs
> `/sys/class/sas_phy/phy-*/maximum_linkrate` always shows `Unknown`.
>
> To fix the issue, this patch changes the dataflow to the following:
> * in pm8001_phy_init():
>   initial value ==> struct pm8001_phy
> * in pm8001_get_lrate_mode():
>   struct pm8001_phy ==> struct sas_phy
> * in pm8001_phy_control():
>   libsas data ==> struct pm8001_phy
>
> For negotiated linkrate, the current dataflow is
> * in pm8001_get_lrate_mode():
>   iomb data ==> struct asd_sas_phy ==> struct sas_phy
> * in pm8001_bytes_dmaed():
>   struct asd_sas_phy ==> struct sas_phy
>
> Since pm8001_bytes_dmaed() follows pm8001_get_lrate_mode(), the
> assignment statements in pm8001_bytes_dmaed() are unnecessary and
> cleaned up.
>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
looks it was broken since beginning, would be good to add cc stable.
Thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c  | 19 +++----------------
>  drivers/scsi/pm8001/pm8001_init.c |  2 ++
>  2 files changed, 5 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index f7466a895d3b..991eb01bb1e0 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3145,15 +3145,6 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
>         if (!phy->phy_attached)
>                 return;
>
> -       if (sas_phy->phy) {
> -               struct sas_phy *sphy = sas_phy->phy;
> -               sphy->negotiated_linkrate = sas_phy->linkrate;
> -               sphy->minimum_linkrate = phy->minimum_linkrate;
> -               sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
> -               sphy->maximum_linkrate = phy->maximum_linkrate;
> -               sphy->maximum_linkrate_hw = phy->maximum_linkrate;
> -       }
> -
>         if (phy->phy_type & PORT_TYPE_SAS) {
>                 struct sas_identify_frame *id;
>                 id = (struct sas_identify_frame *)phy->frame_rcvd;
> @@ -3177,26 +3168,22 @@ void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
>         switch (link_rate) {
>         case PHY_SPEED_120:
>                 phy->sas_phy.linkrate = SAS_LINK_RATE_12_0_GBPS;
> -               phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_12_0_GBPS;
>                 break;
>         case PHY_SPEED_60:
>                 phy->sas_phy.linkrate = SAS_LINK_RATE_6_0_GBPS;
> -               phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
>                 break;
>         case PHY_SPEED_30:
>                 phy->sas_phy.linkrate = SAS_LINK_RATE_3_0_GBPS;
> -               phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
>                 break;
>         case PHY_SPEED_15:
>                 phy->sas_phy.linkrate = SAS_LINK_RATE_1_5_GBPS;
> -               phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
>                 break;
>         }
>         sas_phy->negotiated_linkrate = phy->sas_phy.linkrate;
> -       sas_phy->maximum_linkrate_hw = SAS_LINK_RATE_6_0_GBPS;
> +       sas_phy->maximum_linkrate_hw = phy->maximum_linkrate;
>         sas_phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
> -       sas_phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
> -       sas_phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
> +       sas_phy->maximum_linkrate = phy->maximum_linkrate;
> +       sas_phy->minimum_linkrate = phy->minimum_linkrate;
>  }
>
>  /**
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9b04f1a6a67d..01f2f41928eb 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -143,6 +143,8 @@ static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
>         struct asd_sas_phy *sas_phy = &phy->sas_phy;
>         phy->phy_state = PHY_LINK_DISABLE;
>         phy->pm8001_ha = pm8001_ha;
> +       phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
> +       phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
>         sas_phy->enabled = (phy_id < pm8001_ha->chip->n_phy) ? 1 : 0;
>         sas_phy->class = SAS;
>         sas_phy->iproto = SAS_PROTOCOL_ALL;
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
