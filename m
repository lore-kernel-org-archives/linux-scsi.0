Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5584DC43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 06:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGIGVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jul 2022 02:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIGVE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2022 02:21:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B157171D
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 23:21:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l23so948704ejr.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 23:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gjeg9WUwnbgnNpG18j3Ii5d6kwssgCM59unaq2578Ss=;
        b=MdSl4g42hl/XcKp8A3kiIPno+qtAUIV46Aw/Ntqb3UMvVmsjRH1U3F4Osp+YPRLiz5
         uKGM15RQsw2bPmkVviV8jZ2fj4dDWYry8OrTXAUvkZNiv3iiQhGXdKgy4OB9sQEcBTRy
         4xeFT1RWgisGCA+gAdaWOIPFRa5CMWhb0L0DVonLg3ceR7Pzfvq/k8eb77D+sCUSwz76
         SPhLV89BeZofc3BdRLRhA+Me40q+v3yiT94zj+upgNK+N99miE/9oRu8162GBOE2t5+R
         TNbar33GSVGWNjx8u10qhujH4Ws7Lk7DS5qoH+rINqR7TJ4FlHgMRfMoXe2JJW1j5j6F
         XMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gjeg9WUwnbgnNpG18j3Ii5d6kwssgCM59unaq2578Ss=;
        b=6+0QpUoIJKJTB4ttpHOFmXSyrHMysyl6QMLFs7WfS+4kdWL9HsKu3dXWOX5a4vM7aE
         vl5iivFu84FZi4jbspPML+JLwDseQviQG++B8ZlLwr+R8hq58CrPlkpLc6pwm2TlCw6/
         TTPwz4+LYvY3bs36+AJS49WCivLelKZetk6+4y3JmADf+XR6QPF2zlAtxHCExo78vRoC
         WM/lM6lSldlZmBAFfxZW8ysSI1hNm1TlNMBO6swcUX9IReK3los8pmqL/kVcT71GLpuy
         R3iXhAB2Ap7uKZSe71FZmgHQLZypUnTE6IShyUJy1wRWdpinxLTcBlfzYkixXKsWoGCO
         EMfg==
X-Gm-Message-State: AJIora/9zFdgMg+SxPIpIHLChrEVlweD95dtGWqSWJFkiX87529URQJT
        Lh+rLmU6k0dd9g2/J2S0Z2ccxGtrhTffpxfic4AnrupynmU=
X-Google-Smtp-Source: AGRyM1uNvKfMf2qfrRolNo3yRmFWwfpwBlBeuYXlrb9/ZqMXODSuUpI4ZWGlfVoltn/spv1MaGc4EO7ManjBWBYcG6E=
X-Received: by 2002:a17:906:9bdd:b0:72b:3cab:eade with SMTP id
 de29-20020a1709069bdd00b0072b3cabeademr87936ejc.58.1657347661422; Fri, 08 Jul
 2022 23:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220708205026.969161-1-changyuanl@google.com>
In-Reply-To: <20220708205026.969161-1-changyuanl@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Sat, 9 Jul 2022 08:20:50 +0200
Message-ID: <CAMGffEkqXWTrJN-hHj4UE+Fcdm-hDBO2Q++bPcd2wQhJjNiQiQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Set stopped phy's linkrate to Disabled
To:     Changyuan Lyu <changyuanl@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 8, 2022 at 10:50 PM Changyuan Lyu <changyuanl@google.com> wrote:
>
> Negotiated link rate needs to be updated to Disabled when phy is
> stopped.
>
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Acked-by: Jack Wang <jinpu.wang@ionso.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 01c5e8ff4cc5..303cd05fec50 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3723,8 +3723,12 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         pm8001_dbg(pm8001_ha, MSG, "phy:0x%x status:0x%x\n",
>                    phyid, status);
>         if (status == PHY_STOP_SUCCESS ||
> -               status == PHY_STOP_ERR_DEVICE_ATTACHED)
> +               status == PHY_STOP_ERR_DEVICE_ATTACHED) {
>                 phy->phy_state = PHY_LINK_DISABLE;
> +               phy->sas_phy.phy->negotiated_linkrate = SAS_PHY_DISABLED;
> +               phy->sas_phy.linkrate = SAS_PHY_DISABLED;
> +       }
> +
>         return 0;
>  }
>
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
