Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD041EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 18:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjFUSdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 14:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjFUSdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 14:33:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757D1172C
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 11:33:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-25e836b733eso3295563a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 11:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687372410; x=1689964410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R2S4gS2xsl31ZVbj5QmbK/bF8pdwruLrQ0Of/mUlG7M=;
        b=hIQg4b6dBFhr8M1cB2wCKdDIS2BqrZFkxpeYC9/r/Fm4/PFRkhINjLnndweKacJ7IP
         V8cig2c3cCv7oAvLssc4iBdvgeuMqkMdvBVCb2TTShovFY5Gf4Mfmm1haAIxoTVhcXAh
         OT5ZmbC2Hz2Fbpo93tqT6X9u8qiANoR9cGeOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687372410; x=1689964410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2S4gS2xsl31ZVbj5QmbK/bF8pdwruLrQ0Of/mUlG7M=;
        b=KB55SEAzg52ctgjLreN1M/4xjR8DWDi72HBNhD+VcuNfxYqQyFSCsYyZV/T8pZXIZO
         EGc8esn148TaGBslvDF8zbjzMtWkhjbwW/qwa9ODy4bQiZ3/kbkXBNGgkRrnQUx4j4Ix
         5bZi1J3FEw+kvtbO+Z+hI0Qm8M1RXU2I5WHpa8jIoeq4OyMrJ4pPtsoD1/iQFnQpLd3M
         ZPHycPtCQF0B1jueuOy9JEd13WTCAtutHkWXAMc+0la0i4LrYlto20ldFtu45za/k5xM
         2Qv1z2u0wMsALmqrJWROJSlh+3TivReq/VqI55oWAlA0pYVkkFaaKiWkJnec1EoQZSm9
         etxQ==
X-Gm-Message-State: AC+VfDzNeVCf/dXei/9oPOPmkizW5BuJ1P4hGpVyNRRNMsYiHNDGKJvd
        PyG5Pvuzt/UJ0uM5AqiOKhI4kA==
X-Google-Smtp-Source: ACHHUZ55HAlLqELh2ztTLy1Zy882zddDnIs2ffNwpxg18Goh1qFJ8fhZuoht6oim3Oz/H9kVw+iajg==
X-Received: by 2002:a17:90a:69a2:b0:25b:f9ce:d8df with SMTP id s31-20020a17090a69a200b0025bf9ced8dfmr13250289pjj.8.1687372409966;
        Wed, 21 Jun 2023 11:33:29 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i18-20020a17090ad35200b0025e0bea16eesm3466415pjx.42.2023.06.21.11.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 11:33:29 -0700 (PDT)
Date:   Wed, 21 Jun 2023 11:33:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Azeem Shaikh <azeemshaikh38@gmail.com>,
        Krishna Gudipati <kgudipat@brocade.com>,
        James Bottomley <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH 1/2] scsi: bfa: fix function pointer type mismatch for
 hcb_qe->cbfn
Message-ID: <202306211133.DD89F45965@keescook>
References: <20230616092233.3229414-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616092233.3229414-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 16, 2023 at 11:22:09AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Some callback functions used here take a boolean argument, others
> take a status argument. This breaks KCFI type checking, so clang
> now warns about the function pointer cast:
> 
> drivers/scsi/bfa/bfad_bsg.c:2138:29: error: cast from 'void (*)(void *, enum bfa_status)' to 'bfa_cb_cbfn_t' (aka 'void (*)(void *, enum bfa_boolean)') converts to incompatible function type [-Werror,-Wcast-function-type-strict]
> 
> Assuming the code is actually correct here and the callers always match
> the argument types of the callee, rework this to replace the explicit
> cast with a union of the two pointer types. This does not change the
> behavior of the code, so if something is actually broken here, a larger
> rework may be necessary.
> 
> Fixes: 37ea0558b87ab ("[SCSI] bfa: Added support to collect and reset fcport stats")
> Fixes: 3ec4f2c8bff25 ("[SCSI] bfa: Added support to configure QOS and collect stats.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
