Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52122E8FDBF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 23:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbjJCXqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 19:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237902AbjJCXp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 19:45:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7F5B0
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 16:45:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c3d6d88231so11599145ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 16:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696376755; x=1696981555; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RtHYjR3XxoRF+iJTkvp+E/jMMzI/Fs5RNWq+H0ugZaQ=;
        b=Uv+54UEBZvITyMjEPII19CZmsTxTZvB5NDyFvUS5nkcYu7rsLrGfwtaxdwjj7+JYOW
         INlN5xBxwlyY/IxesJp44tCcAW05pW5ACZ/4CqNs7+0CSGRFuSRd6tEFa5oSFWCaU8bU
         XZUqzdUa7jp42b/HYHusuibM+HM3PWkhob+vU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696376755; x=1696981555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtHYjR3XxoRF+iJTkvp+E/jMMzI/Fs5RNWq+H0ugZaQ=;
        b=cqlKt5i1wdRSwMfJg+iZylLti6lbp3hpb7bY0FU1KjXBMv4hbkScTZkA7C1HX6g2h1
         5mwAjkKaSJIRdKbehaMWOXutESYWN7KvSUON913sVoOazPifNokGo+Q4OfJokiHLiPJy
         IFl+duB8vw7ZFxzhLVG5KegO4ErLGTF42bRjLXVv+03mdbyzH1Kx5i9BVvO5d7mCLCRw
         av12Aw8x/NBcwK707j9Oani2b5gNgUoxhzQt4zLQ2s+hYpFe+jdRAexy8E8eutTbpmTP
         tVGkH1uPSXQd0KG8lvtiZpK8eiOH+HokFzIX8OCM5esRVBfsKuHkJoJBEeLTV61D3K9x
         jz8g==
X-Gm-Message-State: AOJu0Yyh0BX/CF7UJWW+B3JjbitA94oQ0j/IzLmEzXPKVQYwx/sDlGgj
        oA/lkmNTSs0MMNoSfP40PlFKeUk3YS6OW8isalc=
X-Google-Smtp-Source: AGHT+IHujQcVFHUY7j+G/kYmbSjiEDK3lKj5pw/1RC5Ut3/Cx7sRwL7lI9kZJjkyqrtiKpo0Jw7Fag==
X-Received: by 2002:a17:902:e850:b0:1c5:d1a2:c3e8 with SMTP id t16-20020a170902e85000b001c5d1a2c3e8mr1097347plg.5.1696376755493;
        Tue, 03 Oct 2023 16:45:55 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ji13-20020a170903324d00b001c726147a45sm2196482plb.190.2023.10.03.16.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 16:45:55 -0700 (PDT)
Date:   Tue, 3 Oct 2023 16:45:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: message: fusion: replace deprecated strncpy
 with strscpy
Message-ID: <202310031645.FBD5955@keescook>
References: <20231003-strncpy-drivers-message-fusion-mptsas-c-v2-1-5ce07e60bd21@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003-strncpy-drivers-message-fusion-mptsas-c-v2-1-5ce07e60bd21@google.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 03, 2023 at 10:15:45PM +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> The only caller of mptsas_exp_repmanufacture_info() is
> mptsas_probe_one_phy() which can allocate rphy in either
> sas_end_device_alloc() or sas_expander_alloc(). Both of which
> zero-allocate:
> |       rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
> ... this is supplied to mptsas_exp_repmanufacture_info() as edev meaning
> that no future NUL-padding of edev members is needed.
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> Also use the more idiomatic strscpy pattern of (dest, src, sizeof(dest))
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for adjusting the sizes. Looks good!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
