Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30715ECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 06:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIWGvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 02:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiIWGvV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 02:51:21 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AC7128A1F
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 23:51:20 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id s10so13568788ljp.5
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 23:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5n36C2tqfcTCjqcGkGfBQuKpTNAA2BKA5lMbPoJLYUQ=;
        b=fJmGGepxP+6q2bIHI5328Lq4ITyrloOYv1zS43szF3ZREYrzkBnONf42D6jHk+s25l
         RV2QvL/SeyLmojPAck86cTnW+P/VtmvtOTV7cohizBPTykbHHF+0S+z9GfWCWz6Fu4YC
         wwmFQ3wyyOSX2irMzapqbBkQ44KA2MW7ZzaScBU64k4eq6SzYDRtcoPtOp+G8fQaMAT9
         chVIkxfXJALs4DlMhQilRH/ZyGIEdFTyXK+Ty62ay8SkeNa8R+VaEz+OdIsrf+NzsNF9
         5ct8+yG0BbEBt8blD+5XJYs6ASJqofVKx47FlbA5iwaZpeDBeRt8DfVc+BXbdtljP5xb
         DiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5n36C2tqfcTCjqcGkGfBQuKpTNAA2BKA5lMbPoJLYUQ=;
        b=yaMpLkszgisgdcCWUbHbyIXU30MOURA4o0SEi62QY75IGjCd0g1qnfXt+x7dAr5xAl
         z+2k62W2OdGND6qZkT2PhEa6MH26VO1WLaH/AE97jT1UgKnGTJ8JnPZc4GvYi1oWb5Du
         rXDQBJBDVbL2RPryn1gkor+GyKTKliWWflfXuXg5FIy/a4Q2WMW78LlOggjd8pRYJsqn
         gYu9OgwWTCjiQh3HzXK/Ult7pEpQrmsxgxMmTzfhMRwDp3++u5NlxGgx64+aAUxS9uxD
         Afm5V5qV0GZ2Y3dIpX7oUVluWSGQfF8RnLndbDXonDC7YDJ6G5cVA0nbVrczwTvfw7y/
         wVSQ==
X-Gm-Message-State: ACrzQf2QP/fbzD2F7YCC3mCsjJt9a4Cq//rBBY9Ikkmu8X0TyyntW0xz
        s29k+GfASkOPXpLs646kR7rp2cW0hyio9WUtaQJ2zg==
X-Google-Smtp-Source: AMsMyM4SYRLgKDTQtFAegqm3ErVf2J0G8v6d3X72fLkW2LgxrDp+F7ox3cOfwCkywNJMh76S2LXalTh5KpfVW9XypK8=
X-Received: by 2002:a2e:bf21:0:b0:266:2be3:61e8 with SMTP id
 c33-20020a2ebf21000000b002662be361e8mr2243397ljr.383.1663915878464; Thu, 22
 Sep 2022 23:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <Yyy31OuBza1FJCXP@work>
In-Reply-To: <Yyy31OuBza1FJCXP@work>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 23 Sep 2022 08:51:07 +0200
Message-ID: <CAMGffEnPaZPw8PKq4HaB-0cbd-XyxDY4Hzrs5GxsoQKQJiCK5Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Replace one-element array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 9:30 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct fw_control_info.
>
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
>
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/207
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836 [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index c5e3f380a01c..b08f52673889 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -612,7 +612,7 @@ struct fw_control_info {
>         operations.*/
>         u32                     reserved;/* padding required for 64 bit
>         alignment */
> -       u8                      buffer[1];/* Start of buffer */
> +       u8                      buffer[];/* Start of buffer */
>  };
>  struct fw_control_ex {
>         struct fw_control_info *fw_control;
> --
> 2.34.1
>
