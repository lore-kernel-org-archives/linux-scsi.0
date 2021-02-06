Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1835EC433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 04:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C951A64FCD
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 04:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBFELW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 23:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhBFEIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 23:08:37 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FA8C06174A;
        Fri,  5 Feb 2021 20:07:57 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id i187so13406528lfd.4;
        Fri, 05 Feb 2021 20:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J+eX8cvfxZRZnydfgzpZ5i698z/K+trqTZY5SHSLd/s=;
        b=PGxbtl0pe5ElQqi4a0E0M0Nw9s3hoi5BKyo0PEyy8eVgIx2lMmLXIRCfwc2zKkoc+H
         efV71Ws04ApYgjXZrPdp+RHcNmSjpk/P7jhlSgWXOLx52b07eQPwBAvDHGNGn9DOBTcv
         cmbRKVXKpgwL8Z4DM+EaoR0G6eyu3mfglSwfB3OZom4ymdAthZ/Fm1yW6QS13PAlU1xb
         X47wJINaxMuPEyuAhaVbMbTFM91V4gOpmRl1Qb+duzk6iPDcFEiLWJToRBBxrWzo4OV6
         Jkbla2VxMSYxIDngDdXguVkrt04Q0IpExAUJ+Jg+9fWc5XaJix4nYJqnQDHiChSLcFR7
         QpFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+eX8cvfxZRZnydfgzpZ5i698z/K+trqTZY5SHSLd/s=;
        b=Ydf+L0/HaGRpmaSYUHLxGxuhkRXx7WqSs6UIDCql1fxW6ZE6PGBo8YyTYUpcXog7Ze
         mTAFhI3aRdlCDJLcVXueSwruAPICukjAhPhIBeiYzEmxMPE40M7d0Q1v7mTt6wxBuWWY
         OpdcpSgsVhpQ8vyPa2teKA0qZ0c6lEiZDgk/6khI75cjKzoN7abTsJN7BPkwZt4KMyOS
         YeZVa8tlFGTjMH5cTGuEjUxq0pHxXL4+1nz+Ex8ZSarzk01A4b11Ost65Cz36XIR9F6u
         k8jMna94qqlZP+jbXjtliZDwyW8o3smEFR92nHFdodt107j+byZHPQLpa4yVmHfc7xhC
         Kong==
X-Gm-Message-State: AOAM5327w4YHiHp4BHCPsfrhMm6jZamTCkEA5PFSWIBwnxBy5usGnQb9
        MQEf6meSI/8MjBMFezeWEQ+BLxF8Nde8PJK50+Y=
X-Google-Smtp-Source: ABdhPJwNCFVg93cxZuqePljHYYuB3o800M4VWQqxJjFADhqAa525T4G+FIf7CMTHKNbALo3LtibsImz0arYAV3+czsY=
X-Received: by 2002:a05:6512:516:: with SMTP id o22mr4032232lfb.487.1612584475795;
 Fri, 05 Feb 2021 20:07:55 -0800 (PST)
MIME-Version: 1.0
References: <20210205125552.1417492-1-unixbhaskar@gmail.com>
In-Reply-To: <20210205125552.1417492-1-unixbhaskar@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Sat, 6 Feb 2021 15:07:44 +1100
Message-ID: <CAGRGNgUgJP2uovJB5UHM1cBD=+7wDFPJMcx3PDe_aDrQnE-2Ag@mail.gmail.com>
Subject: Re: [PATCH] drivers: scsi: Describe and replace a word with better
 one in the file qlogicpti.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bhaskar,

On Sat, Feb 6, 2021 at 9:55 AM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
>
>
> s/fucking/awful/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/scsi/qlogicpti.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
> index 2b6374e08a7d..4a47631b22ea 100644
> --- a/drivers/scsi/qlogicpti.h
> +++ b/drivers/scsi/qlogicpti.h
> @@ -62,7 +62,7 @@
>  #define REQUEST_QUEUE_WAKEUP           0x8005
>  #define EXECUTION_TIMEOUT_RESET                0x8006
>
> -/* Am I fucking pedantic or what? */
> +/* Am I awful pedantic or what? */

You're right that this needs to go, but "awfully" is a better
replacement than "awful".

However it's likely that the entire comment can either be removed or
replaced with something more descriptive.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
