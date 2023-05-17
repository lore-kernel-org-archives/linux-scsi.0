Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90D4C77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 19:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjEQTNb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 15:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjEQTNX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 15:13:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9DA59EE
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:13:20 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ae4be0b1f3so9575155ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684350800; x=1686942800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6czxj2yh/2mLyL8a+KpoQy5McU/reD4RvDXw+77Cpc=;
        b=QwKQlvilqcEW2x6DKwphNwJhhD+FIPW3wsl/pJqnfEhMuS5gPImBThRtc8IeFe9ATj
         9kRW5jalZeegpFo9A40Jj4PZVs9ip76KAgOktsvYXoZNyQn9eubHm/mzXKUDSdmfQkXq
         hx+OqrWYi/AW+RjK/5NRxbzwzOcz36qulbkF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350800; x=1686942800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6czxj2yh/2mLyL8a+KpoQy5McU/reD4RvDXw+77Cpc=;
        b=kIqNYvdSnF/RozlgTq16RcF6Xm/pju8ZM0m6M2X5R/Jtn0wXIw0y55RbzvWHtfNu0G
         6eT0CYt/lo5mTtG5//ORYrUMoPj/LVZyphWRkv3vF9IoHB3Czk9J/coO20UuHV/h6mXh
         Csg4pjcvJAkJDTKVFQ3t7eorN/3Yx3Rm/6LjjkUcfvqdxwEVqt4foMfzsE/J8XlmDyTi
         tgn6yAms0PNt9yH06y9j0g28Yb7jgZkue30gbUAQ2qfSru/BWRsIRGRMgia4syCnWmgc
         3uphZOu7Nv18D/8agaxY6xFCv2h9s9sDvZmq8llwenZQ/Jhf/OKEWbAX0g3uyMK517Tm
         eY8w==
X-Gm-Message-State: AC+VfDz6xQU4Szr2Em7eaiHsCKmTVFJEmJOlj037uVnYK9hxVFNS+q4J
        md7oEjjpV7l74f6lZzjMw+v8GA==
X-Google-Smtp-Source: ACHHUZ64wPSvM/q5kDI7IKFpS45eLHhjh6pMFolF+HvUoNJeUircwL59gxk6wPnioJ8AyerG0Kiv0Q==
X-Received: by 2002:a17:90b:80f:b0:253:2c87:9459 with SMTP id bk15-20020a17090b080f00b002532c879459mr585016pjb.45.1684350800035;
        Wed, 17 May 2023 12:13:20 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a0f8a00b0024e06a71ef5sm2013789pjz.56.2023.05.17.12.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:13:19 -0700 (PDT)
Date:   Wed, 17 May 2023 12:13:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Adam Radford <aradford@gmail.com>, linux-hardening@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: 3w-9xxx: Replace all non-returning strlcpy with
 strscpy
Message-ID: <202305171213.3CA3EC1@keescook>
References: <20230517142955.1519572-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517142955.1519572-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 02:29:55PM +0000, Azeem Shaikh wrote:
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
