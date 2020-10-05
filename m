Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC644C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9565020776
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="XCvn0rL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJELSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJELSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 07:18:24 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25258C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 04:18:23 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k14so8867365edo.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 04:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zv9Pl34MX+bN7yjITYSz7GoCnQtiZVN/s4nnZ3Efb9U=;
        b=XCvn0rL05suYVESPg/yk5HdLGGKYtvgNAitohNgL6rgWKlhOgGq7GqZHguFRT1TD0d
         LxD3fxnYnRjB0aHTZfl9dBx3QSlTP58gm7jYx3sIPuvESM997EvKLAsawREYJLSE0I9M
         P/+w1XZkh0nD12jYVVIYC9R7lnkrDp/FkT3n6N6gIZ1YRVTEXFf9iCi6o03Yikst8YAu
         rV8e1x3Za/LuhV8lOQiE2gji9QByxahdtux+EZ6UFWfy4Mhn4IsInbb8yL6d5IIZYu7/
         1q1TOIKlEc0w7yk0VL1jvgmoxRBfblqmGr+dD5wO9yrbQYAWuKg2vmYV67wJt/ggVFzW
         kXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zv9Pl34MX+bN7yjITYSz7GoCnQtiZVN/s4nnZ3Efb9U=;
        b=acR15ERmpnz0x2RviHsZlFOglGmxJ9HUJdxunOV9ZpQx1E2iFG+6MbHYF6+iTdtGw4
         NcOYvesICajy1QY0/J1LuBy6Q2O/k8HWFcuv2O1Eyl6nQ7f86UwWpu47kXUtgmE1otjO
         Ci98JrSsGGLp7c7mgR+ha4sOeDlJSiDTOh4FBPwToi9JsONI4Wg+nxwVdPALLlYaXHla
         jbjfJEKLI5LtH/WM/ekH5yC5UOP4ykveE2510SaTkWFX0pgNua4kiAXnn3G2aoQlehDV
         DVeXU6sOFWX3XBJ75zIH2qoyOqHWHkIIxMux3YI7FIiRnqexPfdFDtfDyrPCCgsPdBlm
         cJdg==
X-Gm-Message-State: AOAM531oyavu2ZKmokKdqvDJUF14W9wuBEWzeGh7Lawpa5ckB7C6y3Lk
        wtYhFGpBvnA1jL+NbJhHqDlf52e+2n8vw81wBs288Q==
X-Google-Smtp-Source: ABdhPJz8oSd5TXI+nvW4Qfo2Y/FHWnIKfVPMnLjenzZVTyj6qKGJZroE3ln4bXQMV+zSFuuv4wgDvX8Ol1q44DYv1sI=
X-Received: by 2002:aa7:c984:: with SMTP id c4mr10117824edt.42.1601896701844;
 Mon, 05 Oct 2020 04:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200925061605.31628-1-Viswas.G@microchip.com.com> <20200925061605.31628-5-Viswas.G@microchip.com.com>
In-Reply-To: <20200925061605.31628-5-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 5 Oct 2020 13:18:10 +0200
Message-ID: <CAMGffE=z7+u6+-4H3HcOPFK4BQ2QkaiU6MzeXveRSDSvdCnbWQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] pm80xx : Driver version update
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 25, 2020 at 8:06 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> Update driver version from "0.1.39" -> "0.1.40"
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 9d7796a74ed4..95663e138083 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -58,7 +58,7 @@
>  #include "pm8001_defs.h"
>
>  #define DRV_NAME               "pm80xx"
> -#define DRV_VERSION            "0.1.39"
> +#define DRV_VERSION            "0.1.40"
>  #define PM8001_FAIL_LOGGING    0x01 /* Error message logging */
>  #define PM8001_INIT_LOGGING    0x02 /* driver init logging */
>  #define PM8001_DISC_LOGGING    0x04 /* discovery layer logging */
> --
> 2.16.3
>
