Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB038C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F0C64F2C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhCDJxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbhCDJw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:52:57 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BECC061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:52:17 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hs11so48161365ejc.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5kTg6Ens5xjmRIndaQA/pYHM/y3pp2HEx8+8boM0KRo=;
        b=CLJeR8W2Qv1PDkbqKntmWArRoeT1ark+WK32hUMP3qfPy8M1GVULqRpwOXhYq7dGFB
         2IeB1nzHK6ref41SUUYadT30KX7o7z3+tW7IAPnVHPAQwfTaC2AmLSwNuWzE1hCDXu+j
         N6Cx8vPXFmJYiAI8aZFHBJl7h13YFCBFP0MVYUlkXXwMZIZUGEYKsIgRMwVegeIAPbtT
         TI7zIe+K8bzZigIvbso7KRYil3ySQqgPmrjM0ntDp/eCBbE0DMwH9TkDtIS2lyectZ2r
         8FJ5dnLnlsNZmd9dBWDCNI1vtWX5ENNFZ+rxzL5PdOrrVeNe+NWBGscWZJswNUR55r4y
         ucIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5kTg6Ens5xjmRIndaQA/pYHM/y3pp2HEx8+8boM0KRo=;
        b=FqhGttlRl5seVhbriNbcE7lnGItgZ1baz/MXg5kmZ4dGMvbQpIXY6+MCM4Ko5lF35F
         NzVu7hBHQF8WA1017y9moqSVbo8ETM97wH2mjCWk98g879yxk9fccBC56IkFS/ehkWYP
         N0nAocwMZ1Hw8jb4XbHahnRqU1wf1jr0svTUDLVpaZaw2kJHQBmPaC+4k1dtm8taY1Kt
         JdG+4vsz5xrdrabNAlhDIELglyLjfqga8mcVOWh0+YqUSiCpAyVYN5h9/mrPGMbEaxJJ
         dw4LzE6noUu7KdpnqF24JZtz2c1PR50aqDAEihUHQDuKsaHueOvG2OypAE951F3qYNKC
         FRYw==
X-Gm-Message-State: AOAM532Oi8Ueg3OPZ6uitLIMFlk9E5bSRKuP4hTDyuph1b9cj9b4Fvdb
        iKEHQEUeIOThAr/q5qZfWjbKP/FPccwyn3NX+si02Q==
X-Google-Smtp-Source: ABdhPJwk91zR1792TuAEVffoOkMzkxlohAeIQth6lnexIjabM83wEHIKTNOAkP/nbZrn7TQxDDyduBjGWKyEFNYODAw=
X-Received: by 2002:a17:906:5811:: with SMTP id m17mr3333784ejq.115.1614851536016;
 Thu, 04 Mar 2021 01:52:16 -0800 (PST)
MIME-Version: 1.0
References: <20210303144631.3175331-1-lee.jones@linaro.org> <20210303144631.3175331-12-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-12-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:52:05 +0100
Message-ID: <CAMGffEmN-Uv5OOdJ1RDvGVdO2Y50RnUqT7M2Zox6mKxvAT6EDw@mail.gmail.com>
Subject: Re: [PATCH 11/30] scsi: pm8001: pm8001_sas: Provide function name
 'pm8001_I_T_nexus_reset()' in header
To:     Lee Jones <lee.jones@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 3, 2021 at 3:47 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_sas.c:989: warning: expecting prototype for and hard reset for(). Prototype was for pm8001_I_T_nexus_reset() instead
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index a98d4496ff8b6..742c83bc45554 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -981,6 +981,7 @@ void pm8001_open_reject_retry(
>  }
>
>  /**
> + * pm8001_I_T_nexus_reset()
>    * Standard mandates link reset for ATA  (type 0) and hard reset for
>    * SSP (type 1) , only for RECOVERY
>    * @dev: the device structure for the device to reset.
> --
> 2.27.0
>
