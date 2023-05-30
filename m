Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62847C7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 23:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbjE3XU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjE3XU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 19:20:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E14F7
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:20:51 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b01d912924so40860075ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685488850; x=1688080850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddypSZo0pvZj3CCocZxOELdl+DEZnsNHTPXNYsUXA+U=;
        b=fOMdV6bV4zFWMAEfPk/QN3zM+edy6/AD1CsjZLT8PblcO/ut+cRCpK8KxeGMNB0syn
         opcmuwL4i+1Wl/PevrFmRdnTBv5gRGHMyH027oMB3BoiaPTaMlpqyJNWaDoPQR6jrY+s
         iAL/AmtGZeh+OLxcaQxGlX0Q9weQoHgPZSNZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685488850; x=1688080850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddypSZo0pvZj3CCocZxOELdl+DEZnsNHTPXNYsUXA+U=;
        b=RT6USaAZFqTP7kKchb8oUZG5wBO2y6yVNH8jkZ6gaMFMoBL98Hyl5kY0piKKH0Kg9C
         twcK+rrLBm/l6+r/R+RNMpKDS/Q/T7x1rzX1A50/18S0gFubVi63/ZbGJ7gGFT5aLjS7
         gpD+CUR2oOvNjAWrVIooVo/b8sKfjqPEg3K4Ds6ntX5mK4k7SsNQbvDocPuKVdhXQe5t
         f9y49mV7Mt0FGA2eJhf+gH3HooRQfE4qsuE8ftxxkTfyhf8RvuaKiMUMMCBO5InjyuCK
         BqtaBpjfQx10hCf/SkgxEiU9NtVj2MRwfeYLARclZCgPi3DoMbFqIpSujKQl8qlrl5jy
         diqg==
X-Gm-Message-State: AC+VfDwem2SsSspES4nMLiO6EmPTisMlbBR82brAYN6wW2ge4CCgP/yW
        q2PSNB9Z/ez+IKaIJjCvFKx54w==
X-Google-Smtp-Source: ACHHUZ5rzUACM1i508I2O0D5Ud9Tu42v2WmVDme8hyjAXpZFBjMT8MeFfihGvE1PSb330BeZX303gw==
X-Received: by 2002:a17:903:2442:b0:1b0:41fb:4ad5 with SMTP id l2-20020a170903244200b001b041fb4ad5mr4303960pls.46.1685488850466;
        Tue, 30 May 2023 16:20:50 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903244d00b001aaec7a2a62sm8685754pls.188.2023.05.30.16.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:20:49 -0700 (PDT)
Date:   Tue, 30 May 2023 16:20:49 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Don Brace <don.brace@microchip.com>,
        linux-hardening@vger.kernel.org, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: Replace all non-returning strlcpy with
 strscpy
Message-ID: <202305301620.75F9B609@keescook>
References: <20230530162321.984035-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530162321.984035-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 04:23:21PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
