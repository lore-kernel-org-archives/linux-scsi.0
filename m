Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A28C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 19:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiKBTJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 15:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiKBTIl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 15:08:41 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665F662EF
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 12:08:31 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m6so17289533pfb.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2022 12:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=btNV1F5raSfgVHS1/gKMO9RappBFKUG6No8ZOPbnTjE=;
        b=WnF/CAavVaQFZ6hu1mucTiUFMFRH07YS8pP+nQhN6HJJeWng0qN/pqcGUZWF8DF3YJ
         UKrrhCuT8pZe5efQKDQYbL4sl4O0d0Yq7dniUij9mlyoue48MfGSkAiZceOt6LH7Zyla
         DMmq4Zy98pWpB2nYorJEhV8afi41FbMNfLd98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=btNV1F5raSfgVHS1/gKMO9RappBFKUG6No8ZOPbnTjE=;
        b=P7kjNEQkec0wBWjiknRHoJGZxyW2fo+J7s7DjaoHq77gw4j9XwnOTK4R7lSXmolAfF
         KQXg7Tq5K5idacB2kMUeoBEmm0P+osJE4MCCHeU6/7dtR+xagUnz/Temb6pcdws0HQly
         HmD23EiByRxuXO6NrwjeqBuEbQCZZGt7HdbayaJsHW6Xp571GNZyKEpe1MDqGmmWXj/O
         ZuvuT+N62nIfSwHaQ+qvYql/1/rr3x8zdCPIB+svAY1bONBDrvn09VuKPkUX/MUFlnLH
         P5wpWYn1dYZHf5UZnvWe91vWiKiLDtRbnKc01zjSwmhXWZoO0xtzjJ0PU5u3oqkZInce
         QeaA==
X-Gm-Message-State: ACrzQf1ul4GqQgbzCBofxmhVedPQp/pd7yrcYzgjR49m4BoH6ehwwKli
        ixyc8fNy7SkwR8ELpseazEkgAQ==
X-Google-Smtp-Source: AMsMyM50I03PG/OQ4Z3UbjQlDLWWsbg4/BuY9JFwssVj3kEUSn2BZVgoliMdNU8wDNVwlvCFhiI/zg==
X-Received: by 2002:a63:501f:0:b0:46f:a711:c455 with SMTP id e31-20020a63501f000000b0046fa711c455mr18062893pgb.402.1667416111214;
        Wed, 02 Nov 2022 12:08:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v20-20020a63f214000000b0045ff216a0casm4784265pgh.3.2022.11.02.12.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:08:30 -0700 (PDT)
Date:   Wed, 2 Nov 2022 12:08:30 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: elx: libefc: Fix second parameter type in state
 callbacks
Message-ID: <202211021208.055D396D8E@keescook>
References: <20221102161906.2781508-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102161906.2781508-1-nathan@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 02, 2022 at 09:19:06AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/scsi/elx/libefc/efc_node.c:811:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ctx->current_state = state;
>                                     ^ ~~~~~
>   drivers/scsi/elx/libefc/efc_node.c:878:21: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           node->nodedb_state = state;
>                             ^ ~~~~~
>   drivers/scsi/elx/libefc/efc_node.c:905:6: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' from 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   pf = node->nodedb_state;
>                     ^ ~~~~~~~~~~~~~~~~~~
> 
>   drivers/scsi/elx/libefc/efc_device.c:455:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>                   node->nodedb_state = __efc_d_init;
>                                     ^ ~~~~~~~~~~~~
> 
>   drivers/scsi/elx/libefc/efc_sm.c:41:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ctx->current_state = state;
>                                     ^ ~~~~~
> 
> The type of the second parameter in the prototypes of ->current_state()
> and ->nodedb_state() ('u32') does not match the implementations, which
> have a second parameter type of 'enum efc_sm_event'. Update the
> prototypes to have the correct second parameter type, clearing up all
> the warnings and CFI failures.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
