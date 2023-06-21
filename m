Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1949EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 18:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjFUSdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 14:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjFUSdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 14:33:22 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9361A3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 11:33:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6686a1051beso3652837b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 11:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687372400; x=1689964400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JMCcSs/LNtvhK0BXk5UBwN4S171el/6E9/JAkRmkQ14=;
        b=HdwxOHbSoqUwOb6scyLytVCNBpr1vwNnQT2D/hW5FKgqNmiGZBEUds0gb7Mwid3xVY
         1EVF6TIlDX37MMcT1uuuEKRQMF7BlHM+djkdvHuJnJlP97NE5a1yHBHKxcdlP1JLWij5
         95LAF3n+A/3JrQmWPhQu/6H9+TM2x6GB51clo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687372400; x=1689964400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMCcSs/LNtvhK0BXk5UBwN4S171el/6E9/JAkRmkQ14=;
        b=baOXucO5X4hoA1YJKaeJravsxwF28ZAnQ4cZBjRQa8EA8WcxnMujbMmyi89XP+7wXu
         skU9z9sxQaSa43kCqn18GadAzytzDqvuYAUcj9XWku0jVLkhcKBPz+d78nr0lXvvUt/1
         iXYfr21MhblAd8uSTcdTAmB8fFIJZNaPN2wT6JF7dpkP1t/+5H1GFHokfJM2ZfbGsFml
         Q0UAQJVwYPCtGp+Efxn3sPhV49DuGx8F5LcoEgpS3Vkf6dBPKi5t7ySxjf0U0CWPyh0F
         MpfB5+VDRAyP+U8YNKE/r4JFdSCwBq9hDdXQC6TrUuiMJsh5YW9Nx8jPnaav5lZ9Bwu5
         42gg==
X-Gm-Message-State: AC+VfDyv5EmG3z4xlIINS95a5AG2yWzmBeuIKA0i4Cq+erNz3qgG7h/I
        Jb3gHdf1TowZZGGsiXKbuVEsWw==
X-Google-Smtp-Source: ACHHUZ61VuRGcNyIdsoeKxEP9I9ve0zzxwyEYeiTSUjX+SCoV/75jyc7NFgMI0GbksiCPhqa3pmwdg==
X-Received: by 2002:a05:6a20:244a:b0:10e:440:6d36 with SMTP id t10-20020a056a20244a00b0010e04406d36mr19792675pzc.1.1687372400488;
        Wed, 21 Jun 2023 11:33:20 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id e20-20020a62ee14000000b00665a76a8cfasm3193283pfi.194.2023.06.21.11.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 11:33:19 -0700 (PDT)
Date:   Wed, 21 Jun 2023 11:33:18 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Azeem Shaikh <azeemshaikh38@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: bfa: fix function pointer type mismatch for
 state machines
Message-ID: <202306211131.18885FF471@keescook>
References: <20230616092233.3229414-1-arnd@kernel.org>
 <20230616092233.3229414-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616092233.3229414-2-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 16, 2023 at 11:22:10AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The bfa driver is full of state machines and a generic abstraction layer
> for them. This relies on casting function pointers, but that is no longer
> allowed when CONFIG_CFI_CLANG is enabled and causes a huge number of
> warnings like:
> 
> drivers/scsi/bfa/bfad.c:169:3: error: cast from 'void (*)(struct bfad_s *, enum bfad_sm_event)' to 'bfa_sm_t' (aka 'void (*)(void *, int)') converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>                 bfa_sm_set_state(bfad, bfad_sm_created);
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Rework the mechanism to no longer require the function pointer casts,
> by having separate types for each individual state machine. This in
> turn requires moving the enum definitions for each state machine
> into the header files in order to define the typedef.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for all this! It's a lot of mechanical changes, but looks correct
to me. One nit below...

Reviewed-by: Kees Cook <keescook@chromium.org>

> [...]
>  static void
> -bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event);
>  static void
> -bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event);
>  static void
> -bfad_sm_initializing(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_initializing(struct bfad_s *bfad, enum bfad_sm_event);
>  static void
> -bfad_sm_operational(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_operational(struct bfad_s *bfad, enum bfad_sm_event);
>  static void
> -bfad_sm_stopping(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_stopping(struct bfad_s *bfad, enum bfad_sm_event);
>  static void
> -bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event);
>  static void
> -bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event event);
> +bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event);

This bit doesn't seem needed? i.e. why remove the prototype's argument
names?

-- 
Kees Cook
